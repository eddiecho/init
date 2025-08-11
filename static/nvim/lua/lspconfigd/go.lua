if vim.fn.executable("go") == 1 then
  vim.lsp.enable("gopls")
end
