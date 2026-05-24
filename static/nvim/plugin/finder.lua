-- On Windows Neovide, I think Lazy holds a lock on the directory or something?
-- I have to close out Neovide and then manually recompile to get it working
vim.pack.add({
	"https://github.com/dmtrKovalenko/fff.nvim",
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("fff.nvim")
			end
			require("fff.download").download_or_build_binary()
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

fff.setup({})
