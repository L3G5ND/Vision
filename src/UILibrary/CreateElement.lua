local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)
local ElementKind = require(Package.ElementKind)

local BlacklistedProperties = {
    Parent = true,
    Element = true,
}

return function (content, props, children)

    if not props then props = {} end
    if not children then children = {} end

    assert(typeof(props) == 'table', string.format('props must be a table, got %s', typeof(props)))
    assert(typeof(children) == 'table', string.format('children must be a table, got %s', typeof(children)))
    for prop, _ in pairs(BlacklistedProperties) do
        assert(not props[prop], string.format('props.%s connot be assigned', prop))
    end

    local kind = ElementKind.Normal
    if Type.GetType(content) == 'function' then
        kind = ElementKind.Function
    elseif Type.GetType(content) == ElementKind.ElementComponent then
        kind = ElementKind.Component
    end

    local element = setmetatable({

        content = content,
        kind = kind,

        props = props, 
        children = children,

    }, {
        __newindex = function() end
    })
    Type.SetType(element, Types.ElementCreator)

    return element
end