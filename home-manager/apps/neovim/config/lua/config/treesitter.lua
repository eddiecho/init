require"ibl".setup{}

require"nvim-treesitter.configs".setup{
  sync_install = false,
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
    "go",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  },
}
