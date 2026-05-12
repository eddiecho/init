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

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind

		local plugin_name = "nvim-treesitter"

		if name == plugin_name and (kind == "install" or kind == "update") then
			vim.cmd("TSUpdate")
		end
	end,
})

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
	"python",
	"vimdoc",
	"zig",
}

local cfg = require("nvim-treesitter.config")

cfg.setup({
  parser_install_dir = "~/.local/share/nvim/treesitter",
})

local already_installed = cfg.get_installed()
local to_install = vim.iter(ensure_installed)
	:filter(function(c)
		return not vim.tbl_contains(already_installed, c)
	end)
	:totable()

-- Add this early in your init.lua
vim.opt.runtimepath:prepend("~/.local/share/nvim/treesitter")

require("nvim-treesitter").install(to_install, {
	summary = false,
})
