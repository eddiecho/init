local on_attach = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
end

require"lspconfig".zls.setup {
  on_attach=on_attach
}
