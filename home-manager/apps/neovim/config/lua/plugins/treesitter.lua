return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function(plug)
	pcall(require('nvim-treesitter.install').update{ with_sync = true })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = false,
        ensure_installed = {
          "javascript",
          "comment",
          "html",
          "css",
          "bash",
          "cpp",
          "rust",
          "lua",
          "python",
          "vimdoc",
          "nix",
          "cmake",
          "go",
        },
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
}
