return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    init = function()
      require"lspconfigd"
    end,
    dependencies = {
      -- LSP completions for neovim configs
      "folke/neodev.nvim",
      -- LSP status updates
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
          window = {
            blend = 0,
          },
        },
      },
    },
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
      require"config.completion"
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      opt = {
        automatic_installation = false,
      },
    },
  },
  {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
  },
  "onsails/lspkind-nvim",
  "simrat39/rust-tools.nvim",
}
