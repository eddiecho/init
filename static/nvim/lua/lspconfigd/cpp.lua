local clangd_flags = {
	"--background-index",
	"--query-driver=/nix/store/*-clang-wrapper-*/bin/c++",
}

if vim.fn.executable("clangd") == 1 then
	vim.lsp.enable("clangd")
	vim.lsp.config("clangd", {
		cmd = { "clangd", unpack(clangd_flags) },
	})
end
