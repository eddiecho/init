local fff = require("fff")

vim.api.nvim_set_keymap("n", "<Leader>ff", fff.find_files())

fff.setup({})
