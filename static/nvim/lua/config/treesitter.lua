require "ibl".setup {}

require "nvim-treesitter".setup({
  sync_install = false,
  ensure_installed = {
    "bash",
    "cmake",
    "comment",
    "cpp",
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "vimdoc",
    "zig",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  },
})
