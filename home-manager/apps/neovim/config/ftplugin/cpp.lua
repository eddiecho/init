local clangd_flags = { "--background-index" }

require"lspconfig".clangd.setup {
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
