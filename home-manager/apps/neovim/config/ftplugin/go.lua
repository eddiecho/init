local lsp_config = require'lspconfig'
local lsp = require'lsp'

lsp_config.gopls.setup {}

local vo = vim.opt_local
vo.tabstop = 8
vo.shiftwidth = 8
vo.softtabstop = 8
vo.expandtab = false
