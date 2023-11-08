local lsp_config = require"lspconfig"

local function on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

lsp_config.zls.setup {
  on_attach = on_attach,
}
