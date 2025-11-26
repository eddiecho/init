if vim.fn.executable("nix") == 1 then
	vim.lsp.enable("nil_ls")
  vim.lsp.config("nil_ls", {
    flake = {
      autoArchive = true,
    },
  })
end
