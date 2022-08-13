vim.o.termguicolors = true

numbers = function(opts)
  return string.format('%s|%s.', opts.id, opts.raise(opts.ordinal))
end

require "bufferline".setup {
    options = {
        numbers = numbers,
        buffer_close_icon = "✗",
        offsets = {{filetype = "NvimTree", text = "Explorer", highlight = "Directory" }},
        modified_icon = "●",
        close_icon = " ",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 18,
        enforce_regular_tabs = true,
        show_buffer_close_icons = true,
        separator_style = "slant",
    },
    highlights = {
        background = {
            fg = comment_fg,
            bg = "#1e222a"
        },
        fill = {
            fg = comment_fg,
            bg = "#1e222a"
        },
        buffer_selected = {
            fg = normal_fg,
            bg = "#282c34",
            bold = true,
        },
        buffer_visible = {
            fg = "#3e4451",
            bg = "#1e222a"
        },
        separator_visible = {
            fg = "#1e222a",
            bg = "#1e222a"
        },
        separator_selected = {
            fg = "#1e222a",
            bg = "#1e222a"
        },
        separator = {
            fg = "#1e222a",
            bg = "#1e222a"
        },
        indicator_selected = {
            fg = "#1e222a",
            bg = "#1e222a"
        },
        modified_selected = {
            fg = string_fg,
            bg = "#353b45"
        }
    }
}

local opt = {silent = true}

--command that adds new buffer and moves to it
vim.api.nvim_command "com -nargs=? -complete=file_in_path New badd <args> | blast"
vim.api.nvim_set_keymap("n", "<S-b>", ":New ", opt)

--removing a buffer
vim.api.nvim_set_keymap("n", "<C-w>", [[<Cmd>bdelete<CR>]], opt)

-- tabnew and tabprev
vim.api.nvim_set_keymap("n", "<Tab>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
vim.api.nvim_set_keymap("n", "<S-Tab>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)

