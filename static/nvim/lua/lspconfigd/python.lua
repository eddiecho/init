local lsp = require("lsp")

if vim.fn.executable("pyright") == 1 then
	vim.lsp.enable("pyright")
	vim.lsp.config("pyright", {
		cmd = {
			"pyright-langserver",
			"--stdio",
		},
		filetypes = { "python" },
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
				},
			},
		},
	})
end
