if vim.pack ~= nil then
  vim.pack.add({
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/ray-x/lsp_signature.nvim",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
		"https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/mason-org/mason.nvim",
		"https://github.com/mason-org/mason-lspconfig.nvim",
		"https://github.com/folke/lazydev.nvim",
		"https://github.com/j-hui/fidget.nvim",
    "https://github.com/onsails/lspkind.nvim",
		"https://github.com/folke/trouble.nvim",
		"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
		"https://github.com/MunifTanjim/nui.nvim",
		"https://github.com/esmuellert/codediff.nvim",
  })

  require("lspconfigd")
  require("lsp_signature").setup({
    bind = true,
    floating_window = true,
    handler_opts = {
      border = "single",
    },
  })
  require("config.completion")
  require("config.mason")
  require("lazydev.nvim").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
  require("fidget.nvim").setup({
    notification = {
      window = {
        winblend = 100,
        border = "rounded",
      },
    },
  })

  require("config.trouble")
  require("tiny-inline-diagnostic").setup({
    options = {
      break_line = {
        enabled = true,
      },

      multilines = {
        enabled = true,
        always_show = true,
        trim_whitespaces = true,
      },

      overflow = {
        mode = "wrap",
        padding = 1,
      },
    },
  })
  vim.diagnostic.config({ virtual_text = false })
end
