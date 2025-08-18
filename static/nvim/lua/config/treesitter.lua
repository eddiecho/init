require "ibl".setup {}

local nts = require("nvim-treesitter")

nts.setup()
nts.install({
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
})
