local nt = require("neo-tree")
local cmd = require("neo-tree.command")

nt.setup({
	close_if_last_window = false,
	popup_border_style = "",
	enable_git_status = true,
	enable_diagnostics = true,
	open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
	sort_case_insensitive = true,

	default_component_configs = {
		window = {
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<cr>"] = "open",
				["<esc>"] = "cancel", -- close preview or floating neo-tree window
				["w"] = "open_vsplit",
				["W"] = "open_split",
				["a"] = "add",
				["d"] = "delete",
				["r"] = "rename",
				["R"] = "refresh",
				["y"] = "copy_to_clipboard",
			},
		},
	},
	filesystem = {
		filtered_items = {
			hide_gitignored = true,
			hide_dotfiles = false,
			hide_hidden = false,
			visible = true,
		},
	},
})

local function keymap_opts(desc)
	return {
		desc = "neo-tree: " .. desc,
		buffer = bufnr,
		noremap = true,
		silent = true,
		nowait = true,
	}
end

local function wrapper(opts)
	return function()
		cmd.execute(opts)
	end
end

vim.keymap.set("n", "<Leader><Space>", wrapper({ toggle = true, vim.uv.cwd() }), keymap_opts("Toggle"))
