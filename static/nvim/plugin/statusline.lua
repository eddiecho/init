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

local function progress()
	return vim.trim(vim.ui.progress_status())
end

-- lualine refreshes the statusline only every 1000 ms by default. Refresh it on each progress message.
vim.api.nvim_create_autocmd("Progress", {
	group = vim.api.nvim_create_augroup("lualine-progress", { clear = true }),
	callback = function()
		require("lualine").refresh({ place = { "statusline" } })
	end,
})

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
		-- lualine_x replaces the default list, so the default components are repeated here.
		lualine_x = { progress, "encoding", "fileformat", "filetype" },
	},
})
