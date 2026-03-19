return {
	"dmtrKovalenko/fff.nvim",
	build = function()
    require("fff.download").download_or_build_binary()
  end,
	config = function()
		require("config.finder")
	end,
}
