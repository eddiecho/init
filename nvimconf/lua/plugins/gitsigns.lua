require("gitsigns").setup {
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr = true})

    map('n', '[c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr = true})
  end,

  signs = {
      add = {hl = "DiffAdd", text = "▌", numhl = "GitSignsAddNr"},
      change = {hl = "DiffChange", text = "▌", numhl = "GitSignsChangeNr"},
      delete = {hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr"},
      topdelete = {hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr"},
      changedelete = {hl = "DiffChange", text = "~", numhl = "GitSignsChangeNr"}
  },
  numhl = false,
  watch_gitdir = {
      interval = 100
  },
  sign_priority = 5,
  status_formatter = nil -- Use default
}
