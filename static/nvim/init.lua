require("filetypes")
require("options")
require("mappings")
local utils = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	git = {
		timeout = 600,
	},
	lockfile = utils.dir_of(vim.fn.stdpath("config")) .. "/static/nvim/lazy-lock.json",
})

require("lsp")

-- keep it at the bottom,
-- has dependencies on other plugin settings
vim.cmd.colorscheme("catppuccin")
