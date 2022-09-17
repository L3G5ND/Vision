local Package = script.Parent.Parent
local Element = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)

local ElementKind = require(Element.ElementKind)

return function (component, props, children)

    if not props then props = {} end
    if not children then children = {} end

    assert(typeof(props) == 'table', string.format('props must be a table, got %s', typeof(props)))
    assert(typeof(children) == 'table', string.format('children must be a table, got %s', typeof(children)))
    assert(typeof(component) == 'Instance', string.format('componenet must be a instance, got %s', typeof(component)))

    local kind = ElementKind.WrappedSingle

    local element = setmetatable({

        component = component,
        kind = kind,

        props = props, 
        children = children,

    }, {
        __newindex = function() end
    })
    Type.SetType(element, Types.Element)

    return element
end