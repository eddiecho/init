--[[
return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = require"config.icons"
      },
      "ryanoasis/vim-devicons",
      "yamatsum/nvim-nonicons",
    },
    config = function()
      require"config.fs"
    end
  },
}
]]--
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
    },
    lazy = false,
    config = function()
      require"config.neotree"
    end
  },
}
