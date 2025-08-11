local bd = require("bufdelete")
local opt = { silent = true }

--command that adds new buffer and moves to it
vim.api.nvim_command "com -nargs=? -complete=file_in_path New badd <args> | blast"
vim.api.nvim_set_keymap("n", "<S-b>", ":New ", opt)

-- tabnew and tabprev
vim.api.nvim_set_keymap("n", "<Tab>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
vim.api.nvim_set_keymap("n", "<S-Tab>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)

require "bufferline".setup {
  options = {
    numbers = "both",
    buffer_close_icon = "✗",
    offsets = {
      {
        filetype = "NvimTree",
        text = "Explorer",
        highlight = "Directory",
      }
    },
    diagnostics = "nvim_lsp",
    modified_icon = "●",
    close_icon = '',
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 18,
    enforce_regular_tabs = true,
    show_buffer_close_icons = true,
    separator_style = "slant",
    close_command = bd.delete
  },
}
