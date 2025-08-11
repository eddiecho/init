return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    init = function()
      require "lspconfigd"
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
      require "config.completion"
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require "config.mason"
    end,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
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
  "onsails/lspkind.nvim",
  {
    "folke/trouble.nvim",
    config = function()
      require("config.trouble")
    end,
  },
}
