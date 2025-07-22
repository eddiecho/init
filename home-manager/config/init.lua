require "options"
require "mappings"
local utils = require "utils"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  lockfile = utils.dir_of(vim.fn.stdpath("config")) .. "/home-manager/config/lazy-lock.json"
})

require "lsp"

-- hide line numbers in terminal windows
vim.api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)

local cmd = vim.cmd

-- inactive statuslines as thin splitlines
cmd("highlight! StatusLineNC gui=underline guibg=NONE guifg=#383c44")

cmd "hi clear CursorLine"
cmd "hi cursorlinenr guibg=NONE guifg=#abb2bf"

-- keep it at the bottom,
-- has dependencies on other plugin settings
cmd.colorscheme "catppuccin"

