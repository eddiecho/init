vim.pack.add({
	"https://github.com/akinsho/bufferline.nvim",
})

local bd = require("bufdelete")
local bl = require("bufferline")

local opt = { silent = true }
vim.keymap.set("n", "<Tab>", function()
	bl.cycle(1)
end, opt)
vim.keymap.set("n", "<S-Tab>", function()
	bl.cycle(-1)
end, opt)

bl.setup({
	options = {
		numbers = "both",
		buffer_close_icon = "✗",
		offsets = {
			{
				filetype = "fyler",
				text = "Explorer",
				highlight = "Directory",
			},
		},
		diagnostics = "nvim_lsp",
		modified_icon = "●",
		close_icon = "",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 18,
		enforce_regular_tabs = true,
		show_buffer_close_icons = true,
		separator_style = "slant",
		close_command = bd.delete,
	},
})
