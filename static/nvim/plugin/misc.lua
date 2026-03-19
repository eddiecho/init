if vim.pack ~= nil then
  vim.pack.add({
    -- color hex codes
    "https://github.com/norcalli/nvim-colorizer.lua",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/alvan/vim-closetag",
    -- Profile startup time for bottlenecks use with :StartupTime
    "https://github.com/tweekmonster/startuptime.vim",
    -- Highlight trailing whitespace
    "https://github.com/ntpeters/vim-better-whitespace",
    -- Live preview for search and replace
    "https://github.com/markonm/traces.vim",
    -- snake_case and CamelCase word motion
    "https://github.com/chaoren/vim-wordmotion",
    -- Highlight git merge conflicts
    "https://github.com/rhysd/conflict-marker.vim",
    -- Show buffer contents
    "https://github.com/junegunn/vim-peekaboo",
    -- Highlight yanks
    "https://github.com/machakann/vim-highlightedyank",
    -- "mg979/vim-visual-multi"
    "https://github.com/christoomey/vim-tmux-navigator",
    -- cursor flashes
    "https://github.com/DanilaMihailov/beacon.nvim",
    -- paste respects indentations
    "https://github.com/nemanjamalesija/smart-paste.nvim",
    -- better folds
		"https://github.com/kevinhwang91/nvim-ufo",
  })

  local ufo = require("ufo")
  ufo.setup({
    provider_selector = function(bufnr, filetype, buftype)
      return { "treesitter", "indent" }
    end,
  })

  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  vim.keymap.set("n", "zR", ufo.openAllFolds)
  vim.keymap.set("n", "zM", ufo.closeAllFolds)
  -- za is the fold toggle

end
