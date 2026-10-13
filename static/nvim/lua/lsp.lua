vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Ctrl + T to go back from jump
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		-- Without nowait, gr waits for the global gr* default mappings.
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, nowait = true })
		vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "gK", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "x" }, "<space>ca", vim.lsp.buf.code_action, opts)

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
	jump = {
		on_jump = function(_, bufnr)
			-- Center before the float opens, because the float is placed relative to the cursor.
			vim.cmd.normal({ "zz", bang = true })
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
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
