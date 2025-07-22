local idx = 1
local ensure_installed = {}
if vim.fn.executable("go") == 1 then
  ensure_installed[idx] = "gopls"
  idx += 1
end

if vim.fn.executable("clang") == 1 then
  ensure_installed[idx] = "clangd"
  idx += 1
end

require("mason-lspconfig").setup{
  ensure_installed = ensure_installed,
  automatic_enable = false
}
