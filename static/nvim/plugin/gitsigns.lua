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
			gs.nav_hunk("next")
		end, { buffer = bufnr })

		vim.keymap.set("n", "<leader>C", function()
			gs.nav_hunk("prev")
		end, { buffer = bufnr })
	end,
})
