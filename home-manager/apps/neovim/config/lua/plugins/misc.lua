return {
  "lukas-reineke/indent-blankline.nvim",
  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    opts = {},
  },
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
    "ojroques/nvim-bufdel",
    opts = {
      next = "tabs",
      quit = false,
    },
  },
}
