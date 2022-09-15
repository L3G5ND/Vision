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

    PropertyUtil.applyProperties(node, element.props)

    nodeTree:updateChildren({
        node = node,
        children = element.children,
        parent = object
    })

    if node.data.eventManager then
        node.data.eventManager:Resume()
    end

    object.Parent = node.data.parent
end

UIRenderer.Update = function(nodeTree, node, newElement)
    local oldProps = node.data.element.props
	local newProps = newElement.props

    print(1)
    if node.data.eventManager then
        node.data.eventManager:Suspend()
    end

    PropertyUtil.updateProperties(node, newProps)

    local children = newElement.children
	if children or node.data.element.children then
        nodeTree:updateChildren({
            node = node,
            children = children,
            parent = node.data.object
        })
	end

    if node.data.eventManager then
        node.data.eventManager:Resume()
    end

    return node
end

return UIRenderer