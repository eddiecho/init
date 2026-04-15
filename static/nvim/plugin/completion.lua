vim.pack.add({
	"https://github.com/saghen/blink.cmp",
})

local function in_treesitter_capture(capture)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if vim.api.nvim_get_mode().mode == "i" then
		col = col - 1
	end

	local buf = vim.api.nvim_get_current_buf()
	local get_captures_at_pos = require("vim.treesitter").get_captures_at_pos

	local captures_at_cursor = vim.tbl_map(function(x)
		return x.capture
	end, get_captures_at_pos(buf, row - 1, col))

	if vim.tbl_isempty(captures_at_cursor) then
		return false
	elseif type(capture) == "string" and vim.tbl_contains(captures_at_cursor, capture) then
		return true
	elseif type(capture) == "table" then
		for _, v in ipairs(capture) do
			if vim.tbl_contains(captures_at_cursor, v) then
				return true
			end
		end
	end
	return false
end

require("blink.cmp").setup({
	completion = {
		menu = {
			auto_show = function()
				return not in_treesitter_capture({
					"comment",
					"line_comment",
					"block_comment",
					"string_start",
					"string_fragment",
					"string_content",
					"string_end",
				})
			end,
		},
	},
	keymap = {
		preset = "none",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
	},
	sources = {
		default = { "lsp" },
		per_filetype = {
			gitcommit = {},
			markdown = {},
			text = {},
			lua = { inherit_defaults = true, "lazydev" },
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
		prebuilt_binaries = {
			download = true,
			ignore_version_mismatch = true,
			force_version = "v*",
		},
	},
})
