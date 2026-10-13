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

-- Give lua_ls every plugin at attach time.
-- Without this, lazydev adds a plugin when a buffer first requires it, and lua_ls reloads the full workspace each time.
local library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } }
for _, plugin in ipairs(vim.pack.get()) do
	table.insert(library, plugin.path)
end
require("lazydev").setup({
	library = library,
	-- A workspace with its own .luarc.json is not Neovim config, for example the Hyprland config.
	enabled = function(root_dir)
		return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
	end,
})

local trouble = require("trouble")
trouble.setup({
	modes = {
		diagnostics = {
			filter = {
				any = {
					buf = 0,
					{
						severity = vim.diagnostic.severity.ERROR,
						function(item)
							return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
						end,
					},
				},
			},
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
