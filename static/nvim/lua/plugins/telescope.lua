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
]] --

local build_func = function()
  if vim.fn.executable("nix") == 1 then
    return "nix run .#release"
  end

  return "cargo build --release"
end

return {
  "dmtrKovalenko/fff.nvim",
  build = build_func(),
  config = function()
    require("config.finder")
  end,
}
