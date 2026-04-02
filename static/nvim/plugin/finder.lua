if vim.pack ~= nil then
	local utils = require("utils")

	-- On Windows Neovide, I think Lazy holds a lock on the directory or something?
	-- I have to close out Neovide and then manually recompile to get it working
	local function build_cmd()
		if vim.fn.executable("nix") == 1 then
			return { "nix", "run", ".#release" }
		end

		return { "cargo", "build", "--release" }
	end

	vim.pack.add({
		"https://github.com/dmtrKovalenko/fff.nvim",
	})

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      if event.data.updated then
        require('fff.download').download_or_build_binary()
      end
    end,
  })

  -- the plugin will automatically lazy load
  vim.g.fff = {
    lazy_sync = true, -- start syncing only when the picker is open
    debug = {
      enabled = true,
      show_scores = true,
    },
  }

  --[[
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind

			local plugin_name = "fff.nvim"

			if name == plugin_name and (kind == "install" or kind == "update") then
				utils.build_plugin_with_logs(plugin_name, ev.data.path, build_cmd())
			end
		end,
	})
  ]]--

	require("config.finder")
end
