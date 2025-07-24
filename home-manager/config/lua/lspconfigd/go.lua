if vim.fn.executable("gopls") == 1 then
  vim.lsp.enable("gopls")
end
