if vim.fn.executable("nix") == 1 then
  vim.lsp.enable("nixd")
end
