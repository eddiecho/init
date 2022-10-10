vim.cmd [[packadd nvim-tree.lua]]

vim.o.termguicolors = true

local get_lua_action = function(cb_name)
    return string.format(":lua require'nvim-tree'.on_keypress('%s')<CR>", cb_name)
end

-- Mappings for nvimtree

vim.api.nvim_set_keymap(
    "n",
    "<Leader><Space>",
    ":NvimTreeToggle<CR>",
    {
        noremap = true,
        silent = true
    }
)

nvim_bindings = {
  { key = "<CR>",               action = "edit"},
  { key = "o",                  action = "edit"},
  { key = "<2-LeftMouse>",      action = "edit"},
  { key = "<2-RightMouse>",     action = "cd"},
  { key = "<C->",               action = "cd"},
  { key = "w",                  action = "vsplit"},
  { key = "W",                  action = "split"},
  { key = "<C-t>",              action = "tabnew"},
  { key = "<BS>",               action = "close_node"},
  { key = "<S-CR>",             action = "close_node"},
  { key = "<Tab>",              action = "preview"},
  { key = "I",                  action = "toggle_ignored"},
  { key = "H",                  action = "toggle_dotfiles"},
  { key = "R",                  action = "refresh"},
  { key = "a",                  action = "create"},
  { key = "d",                  action = "remove"},
  { key = "r",                  action = "rename"},
  { key = "<C-r>",              action = "full_rename"},
  { key = "x",                  action = "cut"},
  { key = "c",                  action = "copy"},
  { key = "p",                  action = "paste"},
  { key = "[c",                 action = "prev_git_item"},
  { key = "]c",                 action = "next_git_item"},
  { key = "-",                  action = "dir_up"},
  { key = "q",                  action = "close"},
}

require'nvim-tree'.setup {
  filters = {
    dotfiles = false,
    custom = {}
  },
  view = {
    side = 'left',
    width = 25,
    mappings = {
      custom_only = false,
      list = nvim_bindings,
    }
  },
  actions = {
    open_file = {
      quit_on_open = false
    }
  },
  renderer = {
    root_folder_modifier = ':~',
    highlight_git = true,
    indent_markers = {
      enable = true
    },
    icons = {
      glyphs = {
        default = " ",
        symlink = " ",
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★"
        },
        folder = {
          default = "",
          open = "",
          symlink = ""
        }
      }
    }
  }
}
