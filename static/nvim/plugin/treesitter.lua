vim.pack.add({
	{
		src = "https://github.com/lukas-reineke/indent-blankline.nvim",
		version = "master",
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
})

require("ibl").setup()

local ensure_installed = {
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
	"terraform",
	"python",
	"vimdoc",
	"zig",
}

local cfg = require("nvim-treesitter.config")
local already_installed = cfg.get_installed()
local to_install = vim.iter(ensure_installed)
	:filter(function(c)
		return not vim.tbl_contains(already_installed, c)
	end)
	:totable()

require("nvim-treesitter").install(to_install, {
	summary = false,
})
