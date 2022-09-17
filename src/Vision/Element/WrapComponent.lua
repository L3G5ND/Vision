local Package = script.Parent.Parent
local Element = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local Assign = require(Util.Assign)

local Types = require(Package.Types)

local ElementKind = require(Element.ElementKind)

local function wrapComponent(component, props, children)

    if not props then props = {} end
    if not children then children = {} end

    assert(typeof(props) == 'table', string.format('props must be a table, got %s', typeof(props)))
    assert(typeof(children) == 'table', string.format('children must be a table, got %s', typeof(children)))
    assert(typeof(component) == 'Instance', string.format('componenet must be a instance, got %s', typeof(component)))

    local kind = ElementKind.Wrapped

    local componentChildren = {}
    for _, child in pairs(component:GetChildren()) do
        componentChildren[child.name] = wrapComponent(child, {}, {})
    end
    for _, child in pairs(children) do
        local hasOverwrite = false
        for key, childComponent in pairs(componentChildren) do
            if childComponent.component.Name == child.component.Name then
                componentChildren[key] = child
            end
        end
    end

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

return wrapComponent