vim.api.nvim_set_keymap(
  "n",
  "<Leader><Space>",
  ":NvimTreeToggle<CR>",
  {
    noremap = true,
    silent = true,
  }
)

devicon_opts = {
  {
    html = {
      icon = "",
      color = "#DE8C92",
      name = "html"
    },
    css = {
      icon = "",
      color = "#61afef",
      name = "css"
    },
    js = {
      icon = "",
      color = "#EBCB8B",
      name = "js"
    },
    ts = {
      icon = "ﯤ",
      color = "#519ABA",
      name = "ts"
    },
    kt = {
      icon = "󱈙",
      color = "#ffcb91",
      name = "kt"
    },
    png = {
      icon = " ",
      color = "#BD77DC",
      name = "png"
    },
    jpg = {
      icon = " ",
      color = "#BD77DC",
      name = "jpg"
    },
    jpeg = {
      icon = " ",
      color = "#BD77DC",
      name = "jpeg"
    },
    mp3 = {
      icon = "",
      color = "#C8CCD4",
      name = "mp3"
    },
    mp4 = {
      icon = "",
      color = "#C8CCD4",
      name = "mp4"
    },
    out = {
      icon = "",
      color = "#C8CCD4",
      name = "out"
    },
    Dockerfile = {
      icon = "",
      color = "#b8b5ff",
      name = "Dockerfile"
    },
    rb = {
      icon = "",
      color = "#ff75a0",
      name = "rb"
    },
    vue = {
      icon = "﵂",
      color = "#7eca9c",
      name = "vue"
    },
    py = {
      icon = "",
      color = "#a7c5eb",
      name = "py"
    },
    toml = {
      icon = "",
      color = "#61afef",
      name = "toml"
    },
    lock = {
      icon = "",
      color = "#DE6B74",
      name = "lock"
    },
    zip = {
      icon = "",
      color = "#EBCB8B",
      name = "zip"
    },
    xz = {
      icon = "",
      color = "#EBCB8B",
      name = "xz"
    },
    h = {
      icon = "",
      color = "#61afef",
      name = "h"
    }
  }
}

local function nvimtree_onattach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

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

return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = devicon_opts,
      },
      "ryanoasis/vim-devicons",
      "yamatsum/nvim-nonicons",
    },
    opts = {
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
        root_folder_modifier = ':~',
        highlight_git = true,
        indent_markers = {
          enable = true,
        },
      },
    },
  },
  --[[
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "yamatsum/nvim-nonicons",
    },
  }
  --]]
}
