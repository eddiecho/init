return {
  "norcalli/nvim-colorizer.lua",
  "windwp/nvim-autopairs",
  "alvan/vim-closetag",
  -- Profile startup time for bottlenecks use with :StartupTime
  "tweekmonster/startuptime.vim",
  -- Popup window support
  "nvim-lua/popup.nvim",
  -- Highlight trailing whitespace
  "ntpeters/vim-better-whitespace",
  -- Live preview for search and replace
  "markonm/traces.vim",
  -- snake_case and CamelCase word motion
  "chaoren/vim-wordmotion",
  -- Highlight git merge conflicts
  "rhysd/conflict-marker.vim",
  -- Show buffer contents
  "junegunn/vim-peekaboo",
  -- Highlight yanks
  "machakann/vim-highlightedyank",
  -- "mg979/vim-visual-multi"
  "christoomey/vim-tmux-navigator",
  "DanilaMihailov/beacon.nvim",
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local ufo = require("ufo")
      vim.keymap.set("n", "zR", ufo.openAllFolds)
      vim.keymap.set("n", "zM", ufo.closeAllFolds)
      -- za is the fold toggle
    end,
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
  },
}
