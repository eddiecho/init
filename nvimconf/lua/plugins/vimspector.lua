vim.cmd [[packadd vimspector]]

local g = vim.g

g.vimspector_enable_mappings = "HUMAN"

vim.api.nvim_set_keymap(
  "n",
  "<Leader>dbg",
  ":call vimspector#Launch()<CR>",
  {
    noremap = true,
    silent = true
  }
)

local mapped = {}
