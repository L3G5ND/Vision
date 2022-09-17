local Package = script.Parent.Parent
local Element = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)

local ElementKind = require(Element.ElementKind)

return function(elements)

    assert(typeof(elements) == 'table', string.format('Elements must be a table, got %s', typeof(elements)))

    local elementGroup = setmetatable({
        elements = elements,
        kind = ElementKind.Group,
    }, {
        __newindex = function() end
    })
    Type.SetType(elementGroup, Types.ElementCreator)

    return elementGroup
end