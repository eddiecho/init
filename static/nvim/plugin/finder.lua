-- On Windows Neovide, neovim itself holds a lock on the directory or something?
-- I have to close out Neovide and then manually recompile to get it working
vim.pack.add({
	"https://github.com/dmtrKovalenko/fff.nvim",
})

-- Replaces fff.download.download_or_build_binary(). That function blocks in
-- vim.wait() without a redraw, so its messages stay on screen unchanged until it ends.
-- It must still block: plugin/fff.lua loads the binary on UIEnter.
local function install_binary()
	local download = require("fff.download")
	local report = require("ui").progress("fff.nvim.binary", "fff.nvim")
	local start = vim.uv.hrtime()
	local step = "Downloading binary"
	local result = nil

	download.download_binary(function(ok, err)
		if ok then
			result = { ok = true }
			return
		end
		step = "Download failed, building with cargo"
		-- The callback runs in a fast event. build_binary() calls vim.fn, which a fast event does not allow.
		vim.schedule(function()
			download.build_binary(function(build_ok, build_err)
				result = { ok = build_ok, err = build_ok and nil or (build_err or err) }
			end)
		end)
	end)

	local last_secs = -1
	local finished = vim.wait(10 * 60 * 1000, function()
		local secs = math.floor((vim.uv.hrtime() - start) / 1e9)
		if secs ~= last_secs then
			last_secs = secs
			report(("%s (%ds)"):format(step, secs))
		end
		return result ~= nil
	end, 100)

	if not finished then
		report("Binary install timed out", "failed")
	elseif result.ok then
		report("Binary ready", "success")
	else
		report("Binary install failed: " .. (result.err or "unknown error"), "failed")
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("fff-build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("fff.nvim")
			end
			install_binary()
		end
	end,
})

vim.g.fff = {
	lazy_sync = true,
	debug = {
		enabled = true,
		show_scores = true,
	},
}

local fff = require("fff")

local opt = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>ff", function()
	fff.find_files()
end, opt)

vim.keymap.set("n", "<Leader>fg", function()
	fff.live_grep()
end, opt)
