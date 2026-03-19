if vim.pack ~= nil then
	vim.pack.add({
		{
			src = "lukas-reineke/indent-blankline.nvim",
			version = "ibl",
		},
		{
			src = "nvim-treesitter/nvim-treesitter",
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

	require("config.treesitter")
end
