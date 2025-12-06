local ensure_installed = {
	"bashls",
	"lua_ls",
	"superhtml",
	"rust_analyzer",
	"zls",
}

-- for neovide I guess
if vim.fn.executable("nix") == 1 then
	ensure_installed[#ensure_installed + 1] = "nil_ls"
end

if vim.fn.executable("go") == 1 then
	ensure_installed[#ensure_installed + 1] = "gopls"
end

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatic_enable = false,
})
