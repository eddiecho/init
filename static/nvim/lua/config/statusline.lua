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
local trouble = require("trouble")
local symbols = trouble.statusline({
	mode = "diagnostics",
	groups = {},
	title = false,
	filter = { buf = 0 },
	format = "{severity_icon} {count}",
	hl_group = "lualine_c_normal",
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
				symbols.get,
				cond = symbols.has,
			},
		},
	},
})
