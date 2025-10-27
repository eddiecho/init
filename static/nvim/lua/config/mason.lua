local ensure_installed = {
	"bash_language_server",
	"clangd",
	"lua_ls",
	"superhtml",
	"nil_ls",
}

if vim.fn.executable("go") == 1 then
	ensure_installed[#ensure_installed + 1] = "gopls"
end

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatic_enable = false,
})
