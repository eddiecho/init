return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		init = function()
			require("lspconfigd")
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		opts = {
			bind = true,
			floating_window = true,
			handler_opts = {
				border = "single",
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("config.completion")
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("config.mason")
		end,
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
		},
	},
	{
		-- gives lua completions for nvim specifically
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- show lsp server notifications
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					winblend = 100,
					border = "rounded",
				},
			},
		},
	},
	-- icons in completions
	"onsails/lspkind.nvim",
	{
		-- diagnostic lists
		"folke/trouble.nvim",
		config = function()
			require("config.trouble")
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000,
		config = function()
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
		end,
	},
	{
		"retran/meow.yarn.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		init = function()
			local yarn = require("meow.yarn")
			vim.keymap.set("n", "<Leader>yt", function()
				yarn.open_tree("type_hierarchy", "supertypes")
			end, { desc = "Yarn: Type Hierarchy (Super)" })
			vim.keymap.set("n", "<leader>yT", function()
				yarn.open_tree("type_hierarchy", "subtypes")
			end, { desc = "Yarn: Type Hierarchy (Sub)" })
			vim.keymap.set("n", "<leader>yc", function()
				yarn.open_tree("call_hierarchy", "callers")
			end, { desc = "Yarn: Call Hierarchy (Callers)" })
			vim.keymap.set("n", "<leader>yC", function()
				yarn.open_tree("call_hierarchy", "callees")
			end, { desc = "Yarn: Call Hierarchy (Callees)" })
		end,
	},
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
	},
}
