local fff = require("fff")

local opt = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>ff", function()
	fff.find_files()
end, opt)

vim.keymap.set("n", "<Leader>fg", function()
	fff.live_grep()
end, opt)

fff.setup({})
