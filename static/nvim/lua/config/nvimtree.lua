local api = require "nvim-tree.api"

local function nvimtree_onattach(bufnr)
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close directory"))
  vim.keymap.set("n", "a", api.fs.create, opts("Create"))
  vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
  vim.keymap.set("n", "e", api.tree.expand_all, opts("Expand all"))
  vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
  vim.keymap.set("n", "w", api.node.open.vertical, opts("Open: vertical split"))
  vim.keymap.set("n", "W", api.node.open.horizontal, opts("Open: horizontal split"))
  vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
  vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
end

require "nvim-tree".setup {
  on_attach = nvimtree_onattach,
  filters = {
    dotfiles = false,
    custom = {},
  },
  view = {
    centralize_selection = true,
    side = "left",
    width = 60,
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
  renderer = {
    root_folder_modifier = ":~",
    highlight_git = true,
    indent_markers = {
      enable = true,
    },
  },
}

vim.api.nvim_set_keymap(
  "n",
  "<Leader><Space>",
  ":NvimTreeToggle<CR>",
  {
    noremap = true,
    silent = true,
  }
)
