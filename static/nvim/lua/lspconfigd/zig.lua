local function on_attach(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

if vim.fn.executable("zig") == 1 then
	vim.lsp.enable("zls")
	vim.lsp.config("zls", {
		on_attach = on_attach,
	})
end
