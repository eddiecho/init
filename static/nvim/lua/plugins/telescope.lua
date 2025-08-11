--[[
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-media-files.nvim"
  },
  config = function()
    require"config.telescope"
  end,
}
]]--

return {
  "dmtrKovalenko/fff.nvim",
  build = "nix run .#release",
  config = function()
    require("config.finder")
  end,
}
