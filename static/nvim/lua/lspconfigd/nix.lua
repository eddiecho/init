if vim.fn.executable("nix") == 1 then
	vim.lsp.enable("nil_ls")
	vim.lsp.config("nil_ls", {
		nix = {
			flake = {
				autoArchive = true,
				autoEvalInputs = true,
			},
		},
	})
end
