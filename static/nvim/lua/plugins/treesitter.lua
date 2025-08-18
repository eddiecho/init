return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ':TSUpdate',
    config = function()
      require "config.treesitter"
    end,
    dependencies = {
      {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
      },
    }
  },
}
