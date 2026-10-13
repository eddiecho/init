-- General key mappings

-- Move vertically by visual line
-- A count moves by real lines so that relative jumps stay correct.
-- Operator-pending mode keeps the linewise j and k.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Center search results
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true })

-- Clear last search with Enter
vim.api.nvim_set_keymap("n", "<CR>", ":noh<CR><CR>", { noremap = true })

-- Because I'm a bad typist
-- Expand only when the typo is the whole ':' command line.
-- A search, a :s pattern, or a command argument stays unchanged.
local typos = {
	Q = "q",
	W = "w",
	Wq = "wq",
	WQ = "wq",
	Qa = "qa",
	Wqa = "wqa",
	WQa = "wqa",
	Wa = "wa",
	WA = "wa",
	qw = "wq",
	qwa = "wqa",
	Qw = "wq",
	Qwa = "wqa",
}
for typo, command in pairs(typos) do
	vim.keymap.set("ca", typo, function()
		if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == typo then
			return command
		end
		return typo
	end, { expr = true })
end

-- Esc map
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true })

-- Split navigation
vim.api.nvim_set_keymap("n", "H", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "L", "<C-w>l", { noremap = true })
vim.api.nvim_set_keymap("n", "K", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "J", "<C-w>j", { noremap = true })

local b = require("bufdelete")
vim.keymap.set("n", "<Leader>bb", function()
	b.delete()
end, { noremap = true })
