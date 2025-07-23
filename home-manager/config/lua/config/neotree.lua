local api = require"neo-tree.command"

local function keymap_opts(desc)
  return {
    desc    = "neo-tree: " .. desc,
    buffer  = bufnr,
    noremap = true,
    silent  = true,
    nowait  = true,
  }
end

vim.keymap.set("n", "<Leader><Space>", api.execute({ toggle = true, vim.uv.cwd() }, keymap_opts("Toggle"))
