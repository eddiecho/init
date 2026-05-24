local function read_hypr_luarc()
    local home = os.getenv("HOME")
    if not home then
        return nil
    end
    local f = io.open(home .. "/.config/hypr/.luarc.json", "r")
    if not f then
        return nil
    end
    local content = f:read("*a")
    f:close()
    local ok, decoded = pcall(vim.fn.json_decode, content)
    if not ok or type(decoded) ~= "table" then
        return nil
    end
    return decoded
end

local hypr = read_hypr_luarc() or {}
local library = (hypr.workspace and hypr.workspace.library) or nil
local globals = (hypr.diagnostics and hypr.diagnostics.globals) or nil

local Lua = {
    workspace = { checkThirdParty = false },
}
if library then
    Lua.workspace.library = library
end
if globals then
    Lua.diagnostics = { globals = globals }
end

return { settings = { Lua = Lua } }
