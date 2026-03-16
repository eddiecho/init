local nts = require("nvim-treesitter")

nts.install({
	"bash",
	"cmake",
	"comment",
	"cpp",
	"css",
	"c_sharp",
	"glsl",
	"go",
	"hlsl",
	"html",
	"javascript",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"nix",
	"python",
	"vimdoc",
	"zig",
}, {
	summary = false,
})
