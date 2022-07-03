vim.cmd [[packadd nvim-tree.lua]]

vim.o.termguicolors = true

local get_lua_cb = function(cb_name)
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
  { key = "<CR>",               cb = get_lua_cb("edit")},
  { key = "o",                  cb = get_lua_cb("edit")},
  { key = "<2-LeftMouse>",      cb = get_lua_cb("edit")},
  { key = "<2-RightMouse>",     cb = get_lua_cb("cd")},
  { key = "<C->",               cb = get_lua_cb("cd")},
  { key = "w",                  cb = get_lua_cb("vsplit")},
  { key = "W",                  cb = get_lua_cb("split")},
  { key = "<C-t>",              cb = get_lua_cb("tabnew")},
  { key = "<BS>",               cb = get_lua_cb("close_node")},
  { key = "<S-CR>",             cb = get_lua_cb("close_node")},
  { key = "<Tab>",              cb = get_lua_cb("preview")},
  { key = "I",                  cb = get_lua_cb("toggle_ignored")},
  { key = "H",                  cb = get_lua_cb("toggle_dotfiles")},
  { key = "R",                  cb = get_lua_cb("refresh")},
  { key = "a",                  cb = get_lua_cb("create")},
  { key = "d",                  cb = get_lua_cb("remove")},
  { key = "r",                  cb = get_lua_cb("rename")},
  { key = "<C-r>",              cb = get_lua_cb("full_rename")},
  { key = "x",                  cb = get_lua_cb("cut")},
  { key = "c",                  cb = get_lua_cb("copy")},
  { key = "p",                  cb = get_lua_cb("paste")},
  { key = "[c",                 cb = get_lua_cb("prev_git_item")},
  { key = "]c",                 cb = get_lua_cb("next_git_item")},
  { key = "-",                  cb = get_lua_cb("dir_up")},
  { key = "q",                  cb = get_lua_cb("close")},
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
