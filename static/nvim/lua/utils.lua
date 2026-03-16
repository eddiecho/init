local M = {}

function M.is_neovide()
	return vim.g.neovide ~= nil
end

function M.is_wsl()
	return vim.fn.has("wsl") == 1
end

function M.is_linux()
	return vim.fn.has("linux") == 1 and vim.fn.has("wsl") == 0
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

function M.build_plugin(plugin_name, plugin_path, plugin_cmd)
	-- Create buffer for logs
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "Plugin Build: " .. plugin_name)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
	-- Map 'q' to just close the window easily
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })

	-- Open a small split for the buffer
	vim.cmd("split")
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_win_set_height(0, 10)

	local handle = vim.system(plugin_cmd, {
		cwd = plugin_path,
		stdout = function(_, data)
			if data then
				vim.schedule(function()
					local lines = vim.split(data, "\n", { trimempty = true })
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
					vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
				end)
			end
		end,
		stderr = function(_, data)
			if data then
				vim.schedule(function()
					local lines = vim.split(data, "\n", { trimempty = true })
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
				end)
			end
		end,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "--- BUILD SUCCESSFUL ---" })
			else
				vim.api.nvim_buf_set_lines(
					buf,
					-1,
					-1,
					false,
					{ "--- BUILD FAILED (Exit Code " .. obj.code .. ") ---" }
				)
			end
		end)
	end)

	-- Killing the buffer with :bd will stop the build
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = buf,
		callback = function()
			if handle and not handle:is_closing() then
				handle:kill(15)
			end
		end,
	})
end

return M
