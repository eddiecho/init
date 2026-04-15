vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_next() })
end)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() })
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Ctrl + T to go back from jump
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

vim.diagnostic.config({
	underline = true,
	signs = {
		active = true,
	},
})

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value
		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. ev.data.client_id,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

-- commenting out until i figure out how to get the tab behavior i want
--[[
vim.opt.completeopt = "menu,menuone,noselect,popup" -- Ensures the menu appears even for a single match and uses the native popup window.
vim.o.autocomplete = true -- Enables the overall completion feature.

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if client and client:supports_method("textDocument/completion") then
      -- Enable native LSP completion for this client + buffer
      vim.lsp.completion.enable(true, client_id, args.buf, {
        autotrigger = true,   -- auto-show menu as you type (recommended)
        -- You can also set { autotrigger = false } and trigger manually with <C-x><C-o>
      })
    end
  end,
})
]]--
