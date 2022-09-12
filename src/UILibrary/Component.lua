local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Element = require(Package.Element)

local Component = {}

Component.new = function(name)
    local self = setmetatable({
        name = name
    }, {
        __index = Component,
        __tostring = function(self)
            return self.name
        end
        
    })
    Type.SetType(self, Element.kind.Component)
    return self
end

function Component:init()
    
end

function Component:render()
    
end

function Component:beforeMount()
    
end

function Component:onMounted()
    
end

function Component:beforeUnmount()
    
end

function Component:onUnmount()
    
end

function Component:shouldUpdate()
    
end

function Component:beforeUpdate()
    
end

function Component:onUpdate()
    
end

return Component