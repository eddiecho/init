local ensure_installed = {
	"bashls",
	"lua_ls",
	"superhtml",
	"nil_ls",
	"rust_analyzer",
	"zls",
}

if vim.fn.executable("go") == 1 then
	ensure_installed[#ensure_installed + 1] = "gopls"
end

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatic_enable = false,
})
