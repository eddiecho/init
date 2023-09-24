require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "rust_analyzer",
    "pyright",
    "zls",
    "tsserver"
  },

  -- this means automatically install new servers when visiting a new file type
  -- not worth for me, since I need clangtools available in nix-path
  automatic_installation = false,
})

local lsp_config = require'lspconfig'

-- Why don't we have these in ftplugin files?
-- Something about Packer probably messes up the load order
-- The first file you enter doesn't get LSP working
local clangd_flags = { "--background-index" }
lsp_config.clangd.setup {
  cmd = { "clangd", unpack(clangd_flags) },
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = { spacing = 0, prefix = " " },
      signs = true,
      underline = true,
      update_in_insert = true,
    })
  }
}

lsp_config.gopls.setup {}

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

vim.lsp.set_log_level('info')

vim.keymap.set('n', ']d',       vim.diagnostic.goto_next)
vim.keymap.set('n', '[d',       vim.diagnostic.goto_prev)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    vim.keymap.set("n", "gD",        vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd",        vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi",        vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr",        vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<C-k>",     vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>D",  vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format {async = true}
    end, opts)
  end,
})

local lsp = {}

function lsp.root_dir(root_files)
  return function(filename)
    print(filename)
    lsp_config.util.root_pattern(unpack(root_files))(filename)
  end
end

return lsp
