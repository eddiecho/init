if vim.pack ~= nil then
	vim.pack.add({
		{
			src = "https://github.com/lukas-reineke/indent-blankline.nvim",
			version = "master",
		},
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter",
			version = "main",
		},
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind

			local plugin_name = "nvim-treesitter"

			if name == plugin_name and (kind == "install" or kind == "update") then
				vim.cmd("TSUpdate")
			end
		end,
	})

	require("nvim-treesitter").install({
		"bash",
		"cmake",
		"comment",
		"cpp",
		"css",
		"c_sharp",
		"glsl",
		"go",
		"hlsl",
		"html",
		"javascript",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"nix",
		"python",
		"vimdoc",
		"zig",
	}, {
		summary = false,
	})
end
