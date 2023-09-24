local lsp_config = require'lspconfig'

local clangd_flags = { "--background-index" }

lsp_config.clangd.setup {
  cmd = { "clangd", unpack(clangd_flags) },
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = { spacing = 0, prefix = " " },
      signs = true,
      underline = true,
      update_in_insert = true,
    })
  }
}

