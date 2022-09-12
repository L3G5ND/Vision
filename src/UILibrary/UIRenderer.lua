local Package = script.Parent

local Element = require(Package.Element)
local PropertyUtil = require(Package.PropertyUtil)

local UIRenderer = {}

UIRenderer.RenderNormal = function(nodeTree, node)
    local element = node.data.element
    local parent = node.data.parent

    local object = Element.build(element.type)
    node.data.object = object

    PropertyUtil.applyProps(node, element.props)

    if #element.children > 0 then
        nodeTree:updateChildren({
            node = node,
            children = element.children,
            parent = object
        })
    end

    object.Parent = node.data.parent
end

UIRenderer.RenderGroup = function(nodeTree, node)
    local element = node.data.element
    local parent = node.data.parent

    nodeTree:updateChildren({
        node = node,
        children = element.elements,
        parent = parent
    })
end

UIRenderer.RenderFunction = function(nodeTree, node)
    local element = node.data.element
    local newElement = element.type(element.props)
    nodeTree:updateChildren({
        node = node,
        children = newElement,
        parent = node.data.parent
    })
end

UIRenderer.RenderComponent = function(nodeTree, node)
    
end

return UIRenderer