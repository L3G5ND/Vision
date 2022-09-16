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

    local kind = ElementKind.Normal
    if Type.GetType(component) == 'function' then
        kind = ElementKind.Function
    elseif Type.GetType(component) == ElementKind.Component then
        kind = ElementKind.Component
    end

    local element = setmetatable({

        component = component,
        kind = kind,

        props = props, 
        children = children,

    }, {
        __newindex = function() end
    })
    Type.SetType(element, Types.ElementCreator)

    return element
end