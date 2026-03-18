if vim.pack ~= nil then
  -- vim.pack doesn't do dependency tracking
  vim.pack.add({
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/ryanoasis/vim-devicons",
    "https://github.com/yamatsum/nvim-nonicons",
    "https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/lewis6991/gitsigns.nvim",
    {
      src = "https://github.com/A7Lavinraj/fyler.nvim",
      version = "main",
    },
  })

  require("config.gitsigns")
  require("config.fyler")

end
