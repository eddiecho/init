local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
  ensure_installed = {
    "javascript",
    "comment",
    "html",
    "css",
    "bash",
    "cpp",
    "rust",
    "lua",
    "python",
    "vimdoc",
    "nix",
    "cmake",
  },
  highlight = {
    enable = true,
    use_languagetree = true
  },
  indent = {
    enable = true,
    disable = { 'python' }
  }
}
