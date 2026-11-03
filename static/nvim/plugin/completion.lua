vim.pack.add({
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.cmp",
})

local function in_treesitter_capture(capture)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if vim.api.nvim_get_mode().mode == "i" then
		col = col - 1
	end

	local buf = vim.api.nvim_get_current_buf()
	local get_captures_at_pos = require("vim.treesitter").get_captures_at_pos

	local captures_at_cursor = vim.tbl_map(function(x)
		return x.capture
	end, get_captures_at_pos(buf, row - 1, col))

	if vim.tbl_isempty(captures_at_cursor) then
		return false
	elseif type(capture) == "string" and vim.tbl_contains(captures_at_cursor, capture) then
		return true
	elseif type(capture) == "table" then
		for _, v in ipairs(capture) do
			if vim.tbl_contains(captures_at_cursor, v) then
				return true
			end
		end
	end
	return false
end

local blink = require("blink.cmp")

blink.setup({
	completion = {
		menu = {
			auto_show = function()
				return not in_treesitter_capture({
					"comment",
					"line_comment",
					"block_comment",
					"string_start",
					"string_fragment",
					"string_content",
					"string_end",
				})
			end,
		},
	},
	keymap = {
		preset = "none",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
	},
	sources = {
		default = { "lsp" },
		per_filetype = {
			gitcommit = {},
			markdown = {},
			text = {},
			lua = { inherit_defaults = true, "lazydev" },
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	fuzzy = {
		-- build_library() reports a missing library, so the setup warning is not necessary.
		implementation = "prefer_rust",
	},
})

local building = false

-- blink.cmp writes one library per commit as lib/lib<name><ext>.<hash> and does not remove old ones.
-- Remove all of them except the library for the current commit.
local function prune_libraries()
	local native = require("blink.lib.native")
	local root = blink.get_repo_root()
	local commit = root and native.try_git_commit(root)
	if not commit then
		return
	end
	local prefix = "lib" .. blink.get_library_name() .. native.platform().lib_extension .. "."
	local keep = prefix .. commit:sub(1, 7)
	for name, type in vim.fs.dir(root .. "/lib") do
		if type == "file" and name ~= keep and vim.startswith(name, prefix) then
			-- A library that a running session has loaded can be locked on Windows. Ignore that error.
			vim.uv.fs_unlink(root .. "/lib/" .. name)
		end
	end
end

-- Build in the background. Until the build ends, blink.cmp uses the Lua matcher.
-- library_available() checks the commit that was current when blink.cmp loaded.
-- After an update in a running session, that check is incorrect. Set `force` to skip it.
---@param force? boolean
local function build_library(force)
	if building then
		return
	end
	if not force and blink.library_available() then
		prune_libraries()
		return
	end
	building = true

	local report = require("ui").progress("blink.cmp.build", "blink.cmp")
	local start = vim.uv.hrtime()
	local timer = assert(vim.uv.new_timer())
	timer:start(
		0,
		1000,
		vim.schedule_wrap(function()
			if building then
				report(("Building native library (%ds)"):format(math.floor((vim.uv.hrtime() - start) / 1e9)))
			end
		end)
	)

	local function finish(msg, status)
		vim.schedule(function()
			building = false
			timer:stop()
			timer:close()
			report(msg, status)
			if status == "success" then
				require("blink.cmp.fuzzy").set_implementation("rust")
				prune_libraries()
			end
		end)
	end

	blink
		.build()
		:on_resolve(function()
			finish("Native library ready", "success")
		end)
		:on_reject(function(err)
			finish("Build failed: " .. tostring(err), "failed")
		end)
end

build_library()

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("blink-cmp-build", { clear = true }),
	callback = function(ev)
		local kind = ev.data.kind
		if ev.data.spec.name == "blink.cmp" and (kind == "install" or kind == "update") then
			-- Wait until vim.pack has checked out the new commit and loaded the plugin.
			vim.schedule(function()
				build_library(true)
			end)
		end
	end,
})
