vim.o.termguicolors = true
-- Buffers become hidden when abandoned
vim.o.hidden = true
-- Ignore case on search
vim.o.ignorecase = true
-- Better splits
vim.o.splitbelow = true
vim.o.splitright = true
-- Line numbers
vim.wo.number = true
vim.o.numberwidth = 2
-- Highlight current line
vim.wo.cul = true
-- Allow mouse
vim.o.mouse = 'a'
-- Signs next to line numbers
vim.wo.signcolumn = "yes"
-- Height of status line
vim.o.cmdheight = 1
-- Update delay time
vim.o.updatetime = 250
-- Allow copy paste
vim.o.clipboard = "unnamedplus"
-- Tabs are just spaces
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
-- Colors
vim.o.termguicolors = true
vim.o.background = "dark"

if vim.fn.has("wsl") == 1 then
  if vim.fn.executable("wl-copy") == 0 then
    print("wl-clipboard not found, clipboard integration won't work")
  else
    vim.g.clipboard = {
      name = "wl-clipboard (wsl)",
      copy = {
        ["+"] = 'wl-copy --foreground --type text/plain',
        ["*"] = 'wl-copy --foreground --primary --type text/plain',
      },
      paste = {
        ["+"] = (function()
          return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', {''}, 1) -- '1' keeps empty lines
        end),
        ["*"] = (function()
          return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', {''}, 1)
        end),
      },
      cache_enabled = true
    }
  end
end
