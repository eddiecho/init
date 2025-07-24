return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    init = function()
      require"lspconfigd"
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
      require"config.completion"
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require"config.mason"
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
    {
      "j-hui/fidget.nvim",
      opts = {
        window = {
          blend = 0,
        },
      },
    },
  },
  "onsails/lspkind.nvim",
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
