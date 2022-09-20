local Package = script.Parent.Parent

local Util = Package.Util
local Assert = require(Util.Assert)

local BuildFunctions = {}

local function addBuildFunctions(container)
    local name = container.Name
    local src = require(container)
    if typeof(src) == 'table' then
        for name, func in pairs(src) do
            BuildFunctions[name] = func
        end
    end
    BuildFunctions[name] = src
end

addBuildFunctions(Package.DefualtComponents)

setmetatable(BuildFunctions, {
    __index = function(tbl, key)
        return function()
            local success, instance = pcall(Instance.new, key)
            Assert(success, 'Invalid argument #1 (Must be a valid Instance ClassName)')
            return instance
        end
    end
})

return function(type)
    return BuildFunctions[type]()
end