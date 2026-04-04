if vim.pack ~= nil then
	local utils = require("utils")

	vim.pack.add({
		{
			src = "https://github.com/catppuccin/nvim",
			name = "catppuccin",
		},
	})

	local transparent = utils.is_linux()

	require("catppuccin").setup({
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = transparent,
			float = {
				transparent = transparent,
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				fidget = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = false,
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		},
	})

	vim.cmd.colorscheme("catppuccin")
end
