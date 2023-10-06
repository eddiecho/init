-- load all plugins
require "pluginsList"
require "plugins/fileicons"

require("neodev").setup({})

require "lsp"
require "lspconfigd"

require "mappings"
require "options"
require "utils"
require "plugins/bufferline"
require "plugins/statusline"

require("colorizer").setup()
require "plugins/cmp"

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

require "plugins/treesitter"
require "plugins/telescope"
require "plugins/nvimtree"
--require "plugins/neotree"
require "plugins/gitsigns"

require("nvim-autopairs").setup()

require("lspkind").init(
  {
    mode = "symbol_text",
    symbol_map = {
      Folder = ""
    }
  }
)

require("lsp_signature").on_attach({
  bind = true,
  floating_window = true,
  handler_opts = {
    border = "single"
  }
})

require('fidget').setup({
  window = {
    blend = 0,
  }
})

-- hide line numbers in terminal windows
vim.api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)

-- inactive statuslines as thin splitlines
cmd("highlight! StatusLineNC gui=underline guibg=NONE guifg=#383c44")

cmd "hi clear CursorLine"
cmd "hi cursorlinenr guibg=NONE guifg=#abb2bf"

require "plugins/ufo"

require("bufdel").setup({
  next = "tabs",
  quit = false,
})

-- keep it at the bottom,
-- has dependencies on other plugin settings
require "plugins/colorscheme"
cmd.colorscheme "catppuccin"

