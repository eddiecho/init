local nts = require("nvim-treesitter")

nts.install(
  {
    "bash",
    "cmake",
    "comment",
    "cpp",
    "css",
    "glsl",
    "go",
    "hlsl",
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
