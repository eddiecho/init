vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/ray-x/lsp_signature.nvim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/onsails/lspkind.nvim",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/esmuellert/codediff.nvim",
})

require("lsp")
require("lspconfigd")

require("lsp_signature").setup({
	bind = true,
	floating_window = true,
	handler_opts = {
		border = "single",
	},
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
require("fidget").setup({
	notification = {
		window = {
			winblend = 100,
			border = "rounded",
		},
	},
})

local trouble = require("trouble")
trouble.setup({
	modes = {
		diagnostics = {
			auto_open = false,
			auto_close = true,
			win = {
				position = "bottom",
			},
		},
	},
})

local function opts(desc)
	return {
		desc = "trouble: " .. desc,
		noremap = true,
		silent = true,
		nowait = true,
	}
end

vim.keymap.set("n", "<Leader>xx", function()
	trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, opts("toggle"))

require("tiny-inline-diagnostic").setup({
	options = {
		break_line = {
			enabled = true,
		},

		multilines = {
			enabled = true,
			always_show = true,
			trim_whitespaces = true,
		},

		overflow = {
			mode = "wrap",
			padding = 1,
		},
	},
})

vim.diagnostic.config({ virtual_text = false })
