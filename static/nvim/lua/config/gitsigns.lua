local function map(mode, l, r, opts, bufnr)
	opts = opts or {}
	opts.buffer = bufnr
	vim.keymap.set(mode, l, r, opts)
end

local gs = require("gitsigns")

require("gitsigns").setup({
	signs = {
		add = { text = "▌" },
		change = { text = "▌" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	numhl = false,
	watch_gitdir = {
		interval = 100,
	},
	sign_priority = 5,
	status_formatter = nil,
	on_attach = function(bufnr)
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true }, bufnr)

		map("n", "[c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true }, bufnr)
	end,
})
