-- Runs inside headless Neovim with the user config loaded. Writes a Claude
-- Code plugin.json that registers every language server Mason has installed.
local out = assert(os.getenv("MASON_LSP_PLUGIN_JSON"), "MASON_LSP_PLUGIN_JSON is not set")

-- Claude Code matches files by extension, Neovim by filetype. Invert the
-- extension table. Some extensions map to a detection function: call it with
-- the file name only. It cannot read file contents here.
local filetype_extensions = {}
for ext, ft in pairs(vim.filetype.inspect().extension) do
	if type(ft) ~= "string" then
		local ok, detected = pcall(vim.filetype.match, { filename = "file." .. ext })
		ft = ok and detected or nil
	end
	if ft then
		filetype_extensions[ft] = filetype_extensions[ft] or {}
		table.insert(filetype_extensions[ft], ext)
	end
end

local package_to_lspconfig = require("mason-lspconfig").get_mappings().package_to_lspconfig
local servers = {}
for _, package in ipairs(require("mason-registry").get_installed_package_names()) do
	local name = package_to_lspconfig[package]
	local config = name and vim.lsp.config[name]
	-- A cmd that is a function starts the server from Lua. Claude Code cannot do that.
	if config and type(config.cmd) == "table" and config.filetypes then
		local extension_to_language = {}
		for _, ft in ipairs(config.filetypes) do
			for _, ext in ipairs(filetype_extensions[ft] or {}) do
				-- Neovim sends the filetype as the LSP languageId. Do the same.
				extension_to_language["." .. ext] = ft
			end
		end
		local command = vim.fn.exepath(config.cmd[1])
		if command ~= "" and next(extension_to_language) then
			servers[name] = {
				command = command,
				args = #config.cmd > 1 and vim.list_slice(config.cmd, 2) or nil,
				extensionToLanguage = extension_to_language,
			}
		end
	end
end

local plugin = {
	name = "mason-lsp",
	description = "Language servers installed by Neovim's Mason",
	lspServers = servers,
}
local file = assert(io.open(out, "w"))
-- Sorted keys keep the output stable, so Claude Code sees no change unless a server changes.
file:write(vim.json.encode(plugin, { sort_keys = true }))
file:close()
