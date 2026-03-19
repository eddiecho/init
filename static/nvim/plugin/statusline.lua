if vim.pack ~= nil then
	vim.pack.add({
		"https://github.com/nvim-lualine/lualine.nvim",
	})

	require("config.statusline")
end
