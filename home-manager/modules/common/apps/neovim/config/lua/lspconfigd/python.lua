local lsp_config = require"lspconfig"
local lsp = require"lsp"

local python_root_files = {
  "setup.py",
  "pyproject.toml",
  "setup.cfg",
  "requirements.txt",
  ".git",
}

lsp_config.pyright.setup {
  cmd = {
    "pyright-langserver",
    "--stdio"
  },
  filetypes = { "python" },
  root_dir = lsp.root_dir(python_root_files),
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        virtual_text = {spacing = 0, prefix = " "},
        signs = true,
        underline = true,
        update_in_insert = true
      }
    )
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      }
    }
  }
}
