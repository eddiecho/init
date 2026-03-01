return {
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("config.gitsigns")
		end,
	},
	{
		"A7Lavinraj/fyler.nvim",
		dependencies = {
			"nvim-mini/mini.icons",
			"nvim-tree/nvim-web-devicons",
			"ryanoasis/vim-devicons",
			"yamatsum/nvim-nonicons",
		},
		branch = "main",
		config = function()
			require("config.fyler")
		end,
	},
}
