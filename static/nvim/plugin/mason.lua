vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
})

local utils = require("utils")
require("mason").setup()

local ensure_installed = {
	"lua_ls",
	"superhtml",
	-- "terraformls",
	"tofu_ls",
	"zls",
}

if vim.fn.executable("nix") == 1 then
	ensure_installed[#ensure_installed + 1] = "nil_ls"
end

if vim.fn.executable("go") == 1 then
	ensure_installed[#ensure_installed + 1] = "gopls"
end

if utils.is_unix_like() then
	ensure_installed[#ensure_installed + 1] = "bashls"
end

if utils.is_neovide() then
	ensure_installed[#ensure_installed + 1] = "csharp_ls"
end

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatic_enable = true,
})

for _, svr in ipairs(ensure_installed) do
	vim.lsp.enable(svr)
end
