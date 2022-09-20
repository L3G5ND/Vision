local Package = script.Parent.Parent
local Element = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local Assert = require(Util.Assert)

local Types = require(Package.Types)

local ElementKind = require(Element.ElementKind)

return function(elements)

    Assert(typeof(elements) == 'table', 'Invalid argument #1 (Must be of type \'table\')')

    local elementGroup = setmetatable({
        elements = elements,
        kind = ElementKind.Group,
    }, {
        __newindex = function() end
    })
    Type.SetType(elementGroup, Types.Element)

    return elementGroup
end