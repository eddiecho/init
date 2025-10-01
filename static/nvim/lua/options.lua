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
vim.o.mouse = "a"
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
	-- remember to install this garbage on the windows side
	-- choco install win32yank
	--[[
	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = { "win32yank.exe", "-i", "--crlf" },
			["*"] = { "win32yank.exe", "-i", "--crlf" },
		},
		paste = {
			["+"] = { "win32yank.exe", "-o", "--lf" },
			["*"] = { "win32yank.exe", "-o", "--lf" },
		},
		cache_enabled = 0,
	}
  ]]
	--

	--[[
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = {'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'},
      ["*"] = {'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'},
    },
    cache_enabled = 0,
  }
  ]]
	--
end
