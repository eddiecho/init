if vim.pack ~= nil then
	-- vim.pack doesn't do dependency tracking
	vim.pack.add({
		"https://github.com/lewis6991/gitsigns.nvim",
		{
			src = "https://github.com/A7Lavinraj/fyler.nvim",
			version = "main",
		},
	})

	require("config.gitsigns")
	require("config.fyler")
end
