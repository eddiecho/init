return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = function(plug)
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
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
  "nvim-treesitter/nvim-treesitter-textobjects",
}
