vim.pack.add({
	{
		src = "https://github.com/FylerOrg/fyler.nvim",
		version = "main",
	},
})

local fyler = require("fyler")

fyler.setup({
	auto_confirm_simple_mutation = true,
	follow_current_file = false,
	use_as_default_explorer = true,
	mappings = {
		n = {
			["q"] = { action = "close" },
			["<CR>"] = { action = "select" },
			["<C-t>"] = { action = "select", args = { tabedit = true } },
			["w"] = { action = "select", args = { vsplit = true } },
			["-"] = { action = "select", args = { split = true } },
			["^"] = { action = "visit", args = { parent = true } },
			["="] = { action = "visit" },
			["."] = { action = "visit", args = { cursor = true } },
			["#"] = { action = "shrink", args = { recursive = true } },
			["<BS>"] = { action = "shrink" },
		},
	},
	integrations = {
		icon = "nvim_web_devicons",
	},
	extensions = {
		git = {
			enabled = true,
			inline = true,
		},
		trash = {
			enabled = false,
		},
		watcher = {
			enabled = true,
		},
	},
	ui = {
		hidden_items = {
			switches = {},
			patterns = {},
			always_hidden = {},
			always_visible = {},
		},
		indent_guides = true,
	},
})

vim.keymap.set("n", "<Leader><Space>", function()
	fyler.toggle({ kind = "split_left_most" })
end, { noremap = true, silent = true })
