-- load all plugins
require "lazyplug"

require "lsp"
require "lspconfigd"

require "mappings"
require "options"
require "utils"

local cmd = vim.cmd
local g = vim.g

-- blankline
g.indentLine_enabled = 1
g.indent_blankline_char = "▏"

cmd "hi IndentBlanklineChar guifg=#42464e"

g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = false


-- hide line numbers in terminal windows
vim.api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)

-- inactive statuslines as thin splitlines
cmd("highlight! StatusLineNC gui=underline guibg=NONE guifg=#383c44")

cmd "hi clear CursorLine"
cmd "hi cursorlinenr guibg=NONE guifg=#abb2bf"

-- keep it at the bottom,
-- has dependencies on other plugin settings
cmd.colorscheme "catppuccin"

