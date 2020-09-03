--[[
## Good little function for requiring this lib. So you can utilize the import afterwards
local fs = filesystem
function require(...)
    for k,v in pairs({...}) do
        return fs.loadFile(v)()
    end
end
]]

local lib = {}
local fs = filesystem

function lib.import(...) -- import('RootAPI', 'Graphics').as 'Graphics'
    local args = {...}
    local module = fs.doFile(string.lower(args[1]) .. '.lua')
    local returnMod = module

    if #args > 1 then
        for i = 2, #args do
            if returnMod[args[i]] then returnMod = returnMod[args[i]] 
            else
                break
            end 
        end
    end

    local function declareGlobal(self, name)
        _G[name] = self
    end

    returnMod.as = declareGlobal
    returnMod.As = declareGlobal

    return returnMod
end

function lib.DoRead(file)
    local fLoaded = fs.open()
end


return lib