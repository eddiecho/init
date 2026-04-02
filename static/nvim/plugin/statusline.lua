if vim.pack ~= nil then
	vim.pack.add({
		"https://github.com/nvim-lualine/lualine.nvim",
	})

	local function diff_source()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end

	local utils = require("utils")

	require("lualine").setup({
		sections = {
			lualine_a = {
				{ "mode", fmt = utils.truncate(80, 4, nil, true) },
			},
			lualine_b = {
				{ "diff", source = diff_source },
				{ "b:gitsigns_head", icon = "" },
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					shorting_target = 80,
					symbols = {
						modified = "[+]",
						readonly = "[-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
				},
				{
					"diagnostics",
					sources = { "nvim_lsp" },
					sections = { "error", "warn", "info", "hint" },
					symbols = { error = "E", warn = "W", info = "I", hint = "H" },
					colored = true, -- Displays diagnostics status in color if set to true.
					update_in_insert = false, -- Update diagnostics in insert mode.
					always_visible = false, -- Show diagnostics even if there are none.
				},
			},
		},
	})
end
