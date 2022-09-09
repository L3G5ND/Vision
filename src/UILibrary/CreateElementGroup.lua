local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)
local ElementKind = require(Package.ElementKind)

return function (elements)

    assert(typeof(elements) == 'table', string.format('Elements must be a table, got %s', typeof(elements)))

    local elementGroup = setmetatable({
        type = Types.ElementGroup,
        elements = elements,
        kind = ElementKind.Group,
    }, {
        __newindex = function() end
    })
    Type.SetType(elementGroup, Types.ElementCreator)

    return elementGroup
end