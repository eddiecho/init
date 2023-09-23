vim.cmd [[packadd nvim-tree.lua]]

local nonicons_extention = require("nvim-nonicons.extentions.nvim-tree")

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

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return {
      desc = 'nvim-tree: ' .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  -- custom keybinds
  vim.keymap.set('n', '<CR>',  api.node.open.edit,             opts("Open"))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close, opts("Close directory"))
  vim.keymap.set('n', 'a',     api.fs.create,                  opts('Create'))
  vim.keymap.set('n', 'd',     api.fs.remove,                  opts('Delete'))
  vim.keymap.set('n', 'e',     api.tree.expand_all,            opts("Expand all"))
  vim.keymap.set('n', 'r',     api.fs.rename,                  opts("Rename"))
  vim.keymap.set('n', 'w',     api.node.open.vertical,         opts("Open: vertical split"))
  vim.keymap.set('n', 'W',     api.node.open.horizontal,       opts("Open: horizontal split"))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,           opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.absolute_path,      opts('Copy Absolute Path'))
end

require'nvim-tree'.setup {
  on_attach = on_attach,
  filters = {
    dotfiles = false,
    custom = {}
  },
  view = {
    side = 'left',
    width = 60,
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
--    icons = {
--      glyphs = nonicons_extention.glyphs,
--    }
  }
}
