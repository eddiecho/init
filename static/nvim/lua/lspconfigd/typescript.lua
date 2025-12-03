if vim.fn.executable("typescript_language_server") == 1 then
	vim.lsp.enable("ts_ls")
	vim.lsp.config("ts_ls", {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		settings = { documentFormatting = false },
	})
end
