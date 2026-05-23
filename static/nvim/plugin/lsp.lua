vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/ray-x/lsp_signature.nvim",
	"https://github.com/onsails/lspkind.nvim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/esmuellert/codediff.nvim",
})

require("lsp")

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

vim.keymap.set("n", "<Leader>xx", function()
	trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, { noremap = true, silent = true, nowait = true })

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

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id) or {}
		local value = ev.data.params.value
		local msg = ("[%s] %s %s"):format(client.name or "", value.kind == "end" and "✓" or "", value.title or "")
		vim.notify(msg)
	end,
})
