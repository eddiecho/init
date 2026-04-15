vim.pack.add({
	"https://github.com/saghen/blink.cmp",
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Up>"] = { "select_next", "fallback" },
		["<Down>"] = { "select_prev", "fallback" },
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
