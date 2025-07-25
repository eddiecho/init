local t = require("trouble")

t.setup({
  modes = {
    diagnostics = {
      auto_open = false,
      auto_close = true,
      win = {
        position = "right",
      },
    },
  },
})

local function opts(desc)
  return {
    desc = "trouble: " .. desc,
    noremap = true,
    silent = true,
    nowait = true,
  }
end

vim.keymap.set("n", "<Leader>xx", function() t.toggle({ mode = "diagnostics", filter = { buf = 0 } }) end, opts("toggle"))
