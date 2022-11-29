local Package = script.Parent

local Props = Package.Props
local Ref = require(Props.Ref)
local App = require(Props.App)

local Util = Package.Util
local Type = require(Util.Type)
local TypeMarker = require(Util.TypeMarker)
local Assign = require(Util.Assign)
local Assert = require(Util.Assert)

local Types = require(Package.Types)
local Element = require(Package.Element)

local InternalKey = TypeMarker.Mark("ComponentInternalKey")

local Component = {}

Component.defaultProps = {}

function Component:init(props, children) end

function Component:render(props, children)
	error("Componenet:render() is a required method")
end

function Component:beforeMount() end

function Component:onMount() end

function Component:beforeUnmount() end

function Component:onUnmount() end

function Component:shouldRerender()
	return true
end

function Component:beforeRerender() end

function Component:onRerender() end

function Component:beforeUpdate(newProps, newChildren) end

function Component:onUpdate(newProps, newChildren) end

Component.new = function(name)
	local self = setmetatable({
		name = name,
	}, {
		__tostring = function(self)
			return "[Vision] - Component: " .. self.name
		end,
	})
	Type.SetType(self, Element.kind.Component)

	for key, value in pairs(Component) do
		if key ~= "new" then
			self[key] = value
		end
	end

	return self
end

function Component:_mount(nodeTree, node)
	local element = node.data.element
	local props = element.props

	local component = setmetatable({}, getmetatable(self))

	node.data._component = component

	for key, value in pairs(self) do
		if key ~= "_mount" and key ~= "_unmount" and key ~= "_update" then
			component[key] = value
		end
	end

	component[InternalKey] = {
		node = node,
		nodeTree = nodeTree,
	}

	component.props = Assign({}, self.defaultProps, node.cascade, props)
	component.children = element.children
	component.cascade = node.cascade

	component:init(component.props, component.children)

	component:beforeMount()

	local newElement = component:render(component.props, component.children)
	Assert(Type.GetType(newElement) == Types.Element, "Component:render() must return a valid Element")

	nodeTree:updateChildren({
		node = node,
		children = newElement,
		parent = node.data.parent,
	})

	if not newElement.props[Ref] then
		if component.props[Ref] then
			local key, child = next(node.children)
			local nextChild = next(node.children, key)
	
			if not nextChild then
				local ref = component.props[Ref]
				if typeof(ref) == "function" then
					ref(child.data.object)
				elseif Type.GetType(ref) == Types.DynamicValue then
					ref:set(child.data.object)
				else
					error("[Vision] - Invalid property [Vision.Ref] (type 'function' or type Types.DynamicValue expected)")
				end
			end
		end
	end

	if component.props[App] then
		component.props[App]:set(component)
	end

	component:onMount()
end

function Component:rerender()
	if not self:shouldRerender() then
		return
	end

	self:beforeRerender()

	local newElement = self:render(self.props, self.children)
	Assert(Type.GetType(newElement) == Types.Element, "Component:render() must return a valid Element")

	local Internal = self[InternalKey]

	Internal.nodeTree:updateChildren({
		node = Internal.node,
		children = newElement,
		parent = Internal.node.data.parent,
	})

	if not newElement.props[Ref] then
		if self.props[Ref] then
			local key, child = next(Internal.node.children)
			local nextChild = next(Internal.node.children, key)

			if not nextChild then
				local object = child.data.object
				if self.props[Ref]:get() ~= object then
					local ref = self.props[Ref]
					if typeof(ref) == "function" then
						ref(object)
					elseif Type.GetType(ref) == Types.DynamicValue then
						ref:set(object)
					else
						error("[Vision] - Invalid property [Vision.Ref] (type 'function' or type Types.DynamicValue expected)")
					end
				end
			end
		end
	end

	self:onRerender()
end

function Component:_unmount()
	local Internal = self[InternalKey]
	local node = Internal.node
	local nodeTree = Internal.nodeTree

	self:beforeUnmount()

	for _, node in pairs(node.children) do
		nodeTree:unmountNode({
			node = node,
		})
	end
	if node.data.eventManager then
		node.data.eventManager:Destroy()
	end

	self:onUnmount()
end

function Component:_update(newElement)
	local newProps = Assign({}, self.defaultProps, self.cascade, self.props, newElement.props)
	local newChildren = newElement.children

	self:beforeUpdate(newProps, newChildren)

	self.props = newProps
	self.children = newChildren

	local newElement = self:render(self.props, self.children)
	Assert(Type.GetType(newElement) == Types.Element, "Component:render() must return a valid Element")

	local Internal = self[InternalKey]

	Internal.nodeTree:updateChildren({
		node = Internal.node,
		children = newElement,
		parent = Internal.node.data.parent,
	})

	if not newElement.props[Ref] then
		if self.props[Ref] then
			local key, child = next(Internal.node.children)
			local nextChild = next(Internal.node.children, key)

			if not nextChild then
				local object = child.data.object
				if self.props[Ref]:get() ~= object then
					local ref = self.props[Ref]
					if typeof(ref) == "function" then
						ref(object)
					elseif Type.GetType(ref) == Types.DynamicValue then
						ref:set(object)
					else
						error("[Vision] - Invalid property [Vision.Ref] (type 'function' or type Types.DynamicValue expected)")
					end
				end
			end
		end
	end
	
	self:onUpdate(self.props, self.children)
end

return Component
