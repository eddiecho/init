require("mason-lspconfig").setup{
  ensure_installed = {
    "stylua",
    "clangd",
    "gopls",
  },
  automatic_enable = false
}
