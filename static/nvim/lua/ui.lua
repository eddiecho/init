local M = {}

local ui2 = require("vim._core.ui2")

local last_title = nil
local last_hl = "Normal"

function M.msg_win()
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

function M.pager_win()
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

function M.dialog_win()
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

return M
