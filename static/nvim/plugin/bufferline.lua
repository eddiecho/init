if vim.pack ~= nil then
  vim.pack.add({
    "https://github.com/akinsho/bufferline.nvim",
  })

  require("config.bufferline")
end
