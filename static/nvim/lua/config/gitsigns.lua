local function map(mode, l, r, opts, bufnr)
  opts = opts or {}
  opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end

local gs = require 'gitsigns'

require 'gitsigns'.setup {
  signs = {
    add = { hl = "DiffAdd", text = "▌", numhl = "GitSignsAddNr" },
    change = { hl = "DiffChange", text = "▌", numhl = "GitSignsChangeNr" },
    delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr" }
  },
  numhl = false,
  watch_gitdir = {
    interval = 100,
  },
  sign_priority = 5,
  status_formatter = nil,
  on_attach = function(bufnr)
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true }, bufnr)

    map('n', '[c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true }, bufnr)
  end,
}
