vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
})

local gs = require("gitsigns")

gs.setup({
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
		vim.keymap.set("n", "<leader>c", function()
			if vim.wo.diff then
				return "<leader>c"
			end
			vim.schedule(function()
				gs.nav_hunk("next")
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr })

		vim.keymap.set("n", "<leader>c", function()
			if vim.wo.diff then
				return "<leader>C"
			end
			vim.schedule(function()
				gs.nav_hunk("prev")
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr })
	end,
})
