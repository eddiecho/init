-- load all plugins
require "options"

require "lazyplug"

require "lsp"
require "mappings"
require "utils"

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

