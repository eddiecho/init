local fyler = require("fyler")

fyler.setup({
	integrations = {
		icon = "nvim_web_devicons",
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
