# mason-lsp

Claude Code plugin that registers every language server Neovim's Mason has
installed.

The marketplace entry uses the `command` plugin source. Claude Code runs
`generate.sh` at install and again at each startup. The script starts
headless Neovim with the user config, and `generate.lua` writes
`plugin.json` from three sources:

- the Mason registry, for the installed packages
- `vim.lsp.config`, for each server's command and filetypes
- `vim.filetype`, for the file extensions of those filetypes

Extension detection uses the file name only. An extension that Neovim
resolves from file contents (for example `.tf`) maps to its name-only
result. Add an override in `static/nvim/lua/filetypes.lua` to change it.
