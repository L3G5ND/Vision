local Package = script.Parent.Parent

local Components = Package.Components

local BuildFunctions = {}

local function addBuildFunction(container)
    local name = container.Name
    local src = require(container)
    if typeof(src) == 'table' then
        for name, func in pairs(src) do
            BuildFunctions[name] = func
        end
    end
    BuildFunctions[name] = src
end

addBuildFunction(Components.DefualtComponents)
for _, container in pairs(Components:GetChildren()) do
    if container ~= Components.DefualtComponents then
        addBuildFunction(container)
    end
end

setmetatable(BuildFunctions, {
    __index = function(tbl, key)
        return function()
            local success, instance = pcall(Instance.new, key)
            assert(success, string.format('element is not a valid instnace, got %s', key))
            return instance
        end
    end
})

return function(type)
    return BuildFunctions[type]()
end