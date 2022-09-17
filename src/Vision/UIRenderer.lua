local Package = script.Parent

local Util = Package.Util
local Assign = require(Util.Assign)

local Element = require(Package.Element)
local PropertyUtil = require(Package.PropertyUtil)
local Types = require(Package.Types)

local UIRenderer = {}

UIRenderer.Render = function(nodeTree, node, dontBuild)
    local element = node.data.element
    local parent = node.data.parent
    local props = element.props

    local object
    if not dontBuild then
        object = Element.build(element.component)
    else
        object = node.data.element.component:Clone()
    end
    
    object.Name = node.key
    node.data.object = object
    
    PropertyUtil.applyProperties(node, props)

    nodeTree:updateChildren({
        node = node,
        children = element.children,
        parent = object
    })

    if props.Parent then
        node.data.parent = props.Parent
    end

    object.Parent = node.data.parent

    if node.data.eventManager then
        node.data.eventManager:Resume()
    end
end

UIRenderer.Update = function(nodeTree, node, newElement)
    local oldProps = node.data.element.props
	local newProps = newElement.props
    
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

    if newProps.Parent then
        if not newProps.Parent == node.data.parent then
            node.data.parent = newProps.Parent
        end
    end

    if node.data.eventManager then
        node.data.eventManager:Resume()
    end

    return node
end

return UIRenderer