local clangd_flags = {
	"--background-index",
	"--query-driver=/nix/store/*-clang-wrapper-*/bin/c++",
}

return {
	cmd = { "clangd", unpack(clangd_flags) },
}
