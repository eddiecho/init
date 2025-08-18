return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = require "config.icons"
      },
      "ryanoasis/vim-devicons",
      "yamatsum/nvim-nonicons",
    },
    config = function()
      require "config.nvimtree"
    end
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
]] --
