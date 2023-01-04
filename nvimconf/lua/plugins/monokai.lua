local monokai = require("monokai-pro")

monokai.setup({
  transparent_background = true,
  italic_comments = true,
  filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
  inc_search = "background", -- underline | background
  diagnostic = {
    background = true,
  },
  plugins = {
    bufferline = {
      underline_selected = false,
      underline_visible = false,
    },
    telescope = {
      background_clear = true,
    },
    cmp = {
        background_clear = true,
    },
    indent_blankline = {
      context_highlight = "default" -- default | pro
    },
  }
})
