-- TODO - this one is it's own mess
local lsp_config = require"lspconfig"
local lsp = require"lsp"

local js_root_files = {
  "package.json",
  "tsconfig.json",
}

local function on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  local ts_utils = require"nvim-lsp-ts-utils"

  ts_utils.setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = true,
    import_all_timeout = 2000,

    eslint_enable_code_actions = true,
    eslint_enable_disable_comments = true,
    eslint_bin = "eslint",
    eslint_config_fallback = nil,
    eslint_enable_diagnostics = true,

    enable_formatting = true,
    formatter = "prettier",
    formatter_config_fallback = nil,

    complete_parens = false,
    signature_help_in_parens = false,

    update_imports_on_move = false,
    require_confirmation_on_move = false,
    watch_dir = nil,
  }

  ts_utils.setup_client(client)
end

lsp_config.ts_ls.setup {
  cmd = {"typescript-language-server", "--stdio"},
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = { documentFormatting = false },
  root_dir = lsp.root_dir(js_root_files),
  on_attach = on_attach,
}
