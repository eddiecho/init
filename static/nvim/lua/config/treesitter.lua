local nts = require("nvim-treesitter")

nts.install(
  {
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
  {
    summary = true,
    max_jobs = 2,
  }
)
