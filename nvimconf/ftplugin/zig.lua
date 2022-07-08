local on_attach = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
end

vim.bo.shiftwidth = 4
vim.o.shiftwidth = 4

require"lspconfig".zls.setup {
  on_attach=on_attach
}
