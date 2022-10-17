local Package = script.Parent

local Element = require(Package.Element)
local PropertyUtil = require(Package.PropertyUtil)
local Types = require(Package.Types)

local UIRenderer = {}

UIRenderer.Render = function(renderer, node)
	local element = node.data.element
	local parent = node.data.parent
	local props = element.props
	local kind = element.kind

	local object
	if (kind == Element.kind.Wrapped) or (kind == Element.kind.WrappedSingle) then
		object = node.data.element.component:clone()
		for _, child in pairs(object:GetChildren()) do
			child:Destroy()
		end
	else
		object = Element.build(element.component)
	end

	node.data.object = object

	local name = node.key
	if props.Name then
		name = props.Name
	end
	if typeof(node.key) == "string" then
		name = node.key
	end
	props.Name = name

	PropertyUtil.applyProperties(node, props)

	renderer:updateChildren({
		node = node,
		children = element.children,
		parent = object,
	})

	if props.Parent then
		node.data.parent = props.Parent
	end

	object.Parent = node.data.parent

	if node.data.eventManager then
		node.data.eventManager:Resume()
	end
	if node.data.viewportSizeEventManager then
		node.data.viewportSizeEventManager:Resume()
	end
end

UIRenderer.Update = function(renderer, node, newElement)
	local oldProps = node.data.element.props
	local newProps = newElement.props

	if node.data.eventManager then
		node.data.eventManager:Suspend()
	end
	if node.data.viewportSizeEventManager then
		node.data.viewportSizeEventManager:Suspend()
	end

	local name = node.key
	if newProps.Name then
		name = newProps.Name
	end
	if typeof(node.key) == "string" then
		name = node.key
	end
	newProps.Name = name

	PropertyUtil.updateProperties(node, newProps)

	local children = newElement.children
	if children or node.data.element.children then
		renderer:updateChildren({
			node = node,
			children = children,
			parent = node.data.object,
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
	if node.data.viewportSizeEventManager then
		node.data.viewportSizeEventManager:Resume()
	end

	return node
end

return UIRenderer
