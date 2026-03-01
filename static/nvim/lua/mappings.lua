-- General key mappings

-- vim.api.nvim_set_keymap is a C function
-- vim.key_map.set is a lua function
-- use the former if you don't need to use lua functions

-- Move vertically by visual line
vim.api.nvim_set_keymap("", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("", "k", "gk", { noremap = true })
vim.api.nvim_set_keymap("", "<Down>", "gj", { noremap = true })
vim.api.nvim_set_keymap("", "<Up>", "gk", { noremap = true })

-- Center search results
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true })

-- Clear last search with Enter
vim.api.nvim_set_keymap("n", "<CR>", ":noh<CR><CR>", { noremap = true })

-- Because I'm a bad typist
vim.api.nvim_set_keymap("c", "Q", "q", { noremap = true })
vim.api.nvim_set_keymap("c", "W", "w", { noremap = true })
vim.api.nvim_set_keymap("c", "Wq", "wq", { noremap = true })
vim.api.nvim_set_keymap("c", "WQ", "wq", { noremap = true })
vim.api.nvim_set_keymap("c", "Qa", "qa", { noremap = true })
vim.api.nvim_set_keymap("c", "Wqa", "wqa", { noremap = true })
vim.api.nvim_set_keymap("c", "WQa", "wqa", { noremap = true })
vim.api.nvim_set_keymap("c", "Wa", "wa", { noremap = true })
vim.api.nvim_set_keymap("c", "WA", "wa", { noremap = true })
vim.api.nvim_set_keymap("c", "qw", "wq", { noremap = true })
vim.api.nvim_set_keymap("c", "qwa", "wqa", { noremap = true })
vim.api.nvim_set_keymap("c", "Qw", "wq", { noremap = true })
vim.api.nvim_set_keymap("c", "Qwa", "wqa", { noremap = true })

-- Esc map
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true })

-- Split navigation
vim.api.nvim_set_keymap("n", "H", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "L", "<C-w>l", { noremap = true })
vim.api.nvim_set_keymap("n", "K", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "J", "<C-w>j", { noremap = true })

local b = require("bufdelete")
vim.keymap.set("n", "<Leader>bb", function()
	b.delete()
end, { noremap = true })
