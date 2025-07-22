local ensure_installed = {}
local idx = 1

if vim.fn.executable("go") == 1 then
  ensure_installed[idx] = "gopls"
  idx = idx + 1
end

if vim.fn.executable("clang") == 1 then
  ensure_installed[idx] = "clangd"
  idx = idx + 1
end

if vim.fn.executable("nix") == 1 then
  ensure_installed[idx] = "nil_ls"
  idx = idx + 1
end

require("mason-lspconfig").setup{
  ensure_installed = ensure_installed,
  automatic_enable = false
}
