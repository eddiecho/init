local M = {}

function M.is_neovide()
  return vim.g.neovide ~= nil
end

function M.is_buffer_empty()
	-- Check whether the current buffer is empty
	return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function M.has_width_gt(cols)
	-- Check if the windows width is greater than a given number of columns
	return vim.fn.winwidth(0) / 2 > cols
end

function M.dir_of(path)
	return path:match("^(.+[/\\])")
end

return M
