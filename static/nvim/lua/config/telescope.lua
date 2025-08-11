local opt = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<Leader>ff", [[<Cmd>lua require("telescope.builtin").find_files()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>fg", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>ft", [[<Cmd>lua require("telescope.builtin").t
reesitter()<CR>]], opt)

local function buffer_previewer(filepath, bufnr, opts)
  local job = require("plenary.job")
  local previewers = require("telescope.previewers")

  filepath = vim.fn.expand(filepath)

  job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

require "telescope".setup {
  defaults = {
    winblend = 20,
    width = 0.8,
    show_line = false,
    prompt_title = "",
    results_title = "",
    preview_title = "",
    path_display = { "smart" },
    file_ignore_patterns = { ".git/", "node_modules", "build", "out" },
    buffer_previewer_maker = buffer_previewer,
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim" -- add this value
    }
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    }
  }
}
