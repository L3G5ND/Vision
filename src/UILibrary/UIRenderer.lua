local Package = script.Parent

local Element = require(Package.Element)
local PropertyUtil = require(Package.PropertyUtil)

local UIRenderer = {}

UIRenderer.Render = function(nodeTree, node)
    local element = node.data.element
    local parent = node.data.parent

    local object = Element.build(element.type)
    object.Name = node.key
    node.data.object = object

    PropertyUtil.applyProps(node, element.props)

    nodeTree:updateChildren({
        node = node,
        children = element.children,
        parent = object
    })

    object.Parent = node.data.parent
end

UIRenderer.Update = function(nodeTree, node, newElement)
    local oldProps = node.data.element.props
	local newProps = newElement.props

    PropertyUtil.applyProps(node, newProps)

    local children = newElement.children
	if children or node.data.element.children then
        nodeTree:updateChildren({
            node = node,
            children = children,
            parent = node.data.object
        })
	end

    return node
end

return UIRenderer