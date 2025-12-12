return {
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-tree/nvim-tree.lua",
				lazy = false,
				priority = 1000,
				dependencies = {},
				config = function()
					require("config.nvimtree")
				end,
			},
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
-- neotree.nvim is apparently less performant than nvimtree
-- and i don"t really care about the other features anyway
--[[
return {
  {
    "echasnovski/mini.icons",
    lazy = false,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              bo = {
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    lazy = false,
    config = function()
      require"config.neotree"
    end
  },
}
]]
--
