local Package = script.Parent.Parent
local Element = script.Parent

local ElementKind = require(Element.ElementKind)

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)

return function(element)
    if Type.GetType(element) == Types.Element then
        local called = false
        return function()
            if not called then
                called = true
                return Types.ParentKey, element
            end
        end
    end
    
    return pairs(element)
end