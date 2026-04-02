if vim.pack ~= nil then
	-- vim.pack doesn't do dependency tracking
	vim.pack.add({
		"https://github.com/lewis6991/gitsigns.nvim",
		{
			src = "https://github.com/A7Lavinraj/fyler.nvim",
			version = "main",
		},
	})

	local function map(mode, l, r, opts, bufnr)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	local gs = require("gitsigns")

	gs.setup({
		signs = {
			add = { text = "▌" },
			change = { text = "▌" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		numhl = false,
		watch_gitdir = {
			interval = 100,
		},
		sign_priority = 5,
		status_formatter = nil,
		on_attach = function(bufnr)
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.nav_hunk("next")
				end)
				return "<Ignore>"
			end, { expr = true }, bufnr)

			map("n", "[c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.nav_hunk("prev")
				end)
				return "<Ignore>"
			end, { expr = true }, bufnr)
		end,
	})

	local fyler = require("fyler")

	fyler.setup({
		integrations = {
			icon = "nvim_web_devicons",
			winpick = "builtin",
		},
		views = {
			finder = {
				close_on_select = false,
				confirm_simple = true,
				default_explorer = true,
				delete_to_trash = false,
				columns = {
					git = {
						enabled = true,
					},
				},
				watcher = {
					enabled = true,
				},
				mappings = {
					["q"] = "CloseView",
					["<CR>"] = "Select",
					["<C-t>"] = "SelectTab",
					["w"] = "SelectVSplit",
					["-"] = "SelectSplit",
					["^"] = "GotoParent",
					["="] = "GotoCwd",
					["."] = "GotoNode",
					["#"] = "CollapseAll",
					["<BS>"] = "CollapseNode",
				},
				win = {
					border = "rounded",
				},
			},
		},
	})

	vim.keymap.set("n", "<Leader><Space>", function()
		fyler.toggle({ kind = "split_left_most" })
	end, { noremap = true, silent = true })
end
