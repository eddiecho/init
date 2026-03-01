local M = {}

function M.is_neovide()
	return vim.g.neovide ~= nil
end

function M.is_wsl()
	return vim.fn.has("wsl") == 1
end

-- Check whether the current buffer is empty
function M.is_buffer_empty()
	return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

-- Check if the windows width is greater than a given number of columns
function M.has_width_gt(cols)
	return vim.fn.winwidth(0) / 2 > cols
end

function M.dir_of(path)
	return path:match("^(.+[/\\])")
end

--- @param width number trunctates component when screen width is less then trunc_width @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number|nil hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding "..." at end after truncation
--- return function that can format the component accordingly
function M.truncate(width, len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif width and len and win_width < width and #str > len then
			return str:sub(1, len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end

return M
