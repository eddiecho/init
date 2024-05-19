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
