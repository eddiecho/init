vim.pack.add({
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/ryanoasis/vim-devicons",
	"https://github.com/yamatsum/nvim-nonicons",
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},
})

local icons = require("nvim-web-devicons")
local icon_maps = {
  {
    from = "tofu",
    to = "terraform",
  },
}

local overrides = {}
for _, o in pairs(icon_maps) do
  local icon, color = icons.get_icon_color_by_filetype(o.to, {})
  overrides[o.from] = {
    icon = icon,
    color = color,
    name = o.from,
  }
end

icons.setup({
  override_by_extension = overrides,
})

local utils = require("utils")
local transparent = utils.is_linux()

require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = transparent,
	float = {
		solid = false,
		transparent = transparent,
	},

	integrations = {
		beacon = true,
		blink_cmp = {
			style = "bordered",
		},
		cmp = true,
		gitsigns = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = false,
		},
		lsp_trouble = true,
		mason = true,
		nvimtree = true,
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
	},
})
vim.cmd.colorscheme("catppuccin-nvim")

local ui2 = require("vim._core.ui2")
local messages = require("vim._core.ui2.messages")

ui2.enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},

		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 1,
		},
	},
})

local last_title = nil
local last_hl = "Normal"

local function msg_win()
	local win = ui2.wins and ui2.wins.msg
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	if vim.api.nvim_win_get_config(win).hide then
		return
	end
	pcall(vim.api.nvim_win_set_config, win, {
		relative = "editor",
		anchor = "NE",
		row = 1,
		col = vim.o.columns - 1,
		border = "rounded",
		style = "minimal",
		title = last_title and { { last_title, last_hl } } or nil,
		title_pos = last_title and "center" or nil,
	})
end

local function pager_win()
	local win = ui2.wins and ui2.wins.pager
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	if vim.api.nvim_win_get_config(win).hide then
		return
	end
	local height = vim.api.nvim_win_get_height(win)
	pcall(vim.api.nvim_win_set_config, win, {
		border = "rounded",
		height = height,
		style = "minimal",
		title = last_title and { { last_title, last_hl } } or nil,
		title_pos = last_title and "center" or nil,
	})
end

local function dialog_win()
	local win = ui2.wins and ui2.wins.dialog
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	if vim.api.nvim_win_get_config(win).hide then
		return
	end
	local height = vim.api.nvim_win_get_height(win)
	pcall(vim.api.nvim_win_set_config, win, {
		border = "rounded",
		height = height,
		style = "minimal",
		title = last_title and { { last_title, last_hl } } or nil,
		title_pos = last_title and "center" or nil,
	})
end

local orig_set_pos = messages.set_pos
messages.set_pos = function(tgt)
	orig_set_pos(tgt)
	if tgt == "msg" or tgt == nil then
		msg_win()
	elseif tgt == "pager" then
		pager_win()
	elseif tgt == "dialog" then
		dialog_win()
	end
end

-- show cursor line only in active window
local cursorline_augroup = vim.api.nvim_create_augroup("cursorline-active-window", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
	group = cursorline_augroup,
	callback = function()
		local win = vim.api.nvim_get_current_win()
		-- Schedule to preserve the correct order of events when synchronously
		-- changing between windows a bunch of times (like in `<c-w>t`)
		vim.schedule(function()
			if not vim.api.nvim_win_is_valid(win) then
				return
			end
			if not vim.w[win].cached_cursorline then
				return
			end

			vim.wo[win].cursorline = vim.w[win].cached_cursorline
			vim.w[win].cached_cursorline = nil
		end)
	end,
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = cursorline_augroup,
	callback = function()
		local win = vim.api.nvim_get_current_win()
		-- Copying the current window options seems to be done after `WinLeave`
		-- when opening a new tab. Delay setting `cursorline` to `false` until
		-- after the options are copied
		vim.schedule(function()
			if not vim.api.nvim_win_is_valid(win) then
				return
			end
			vim.w[win].cached_cursorline = vim.wo[win].cursorline
			vim.wo[win].cursorline = false
		end)
	end,
})
