local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local ElementKind = require(Package.ElementKind)

local Component = {}

Component.new = function()
    local self = setmetatable({}, {__index = Component})
    Type.SetType(self, ElementKind.ElementComponent)
    return self
end

function Component:Render()
    
end
Component.render = Component.Render

return Component