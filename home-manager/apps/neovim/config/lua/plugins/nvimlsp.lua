return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      -- LSP status updates
      {
        'j-hui/fidget.nvim',
	tag = 'legacy',
        opts = {
          window = {
            blend = 0,
          },
        },
      },
      -- LSP completions for neovim configs
      {
	'folke/neodev.nvim',
	opts = {},
      },
    },
  },
  'onsails/lspkind-nvim',
  {
    'ray-x/lsp_signature.nvim',
    opts = {
      bind = true,
      floating_window = true,
      handler_opts = {
        border = "single",
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
         mapping = cmp.mapping.preset.insert {
           ['<C-d>'] = cmp.mapping.scroll_docs(-4),
           ['<C-f>'] = cmp.mapping.scroll_docs(4),
           ['<C-Space>'] = cmp.mapping.complete(),
           ['<CR>'] = cmp.mapping.confirm {
             behavior = cmp.ConfirmBehavior.Replace,
             select = true,
           },
           ['<Tab>'] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_next_item()
             elseif luasnip.expand_or_jumpable() then
               luasnip.expand_or_jump()
             else
               fallback()
             end
           end, { 'i', 's' }),
           ['<S-Tab>'] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_prev_item()
             elseif luasnip.jumpable(-1) then
               luasnip.jump(-1)
             else
               fallback()
             end
           end, { 'i', 's' }),
         },
         sources = {
           { name = 'nvim_lsp' },
           { name = 'luasnip' },
         },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opt = {},
    dependencies = {
      "williamboman/mason-lspconfig.nvim"
      opt = {
	automatic_installation = false,
      },
    },
  },
  "simrat39/rust-tools.nvim",
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
}
