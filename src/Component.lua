local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local TypeMarker = require(Util.TypeMarker)
local Assign = require(Util.Assign)
local Copy = require(Util.Copy)
local assert = require(Util.Assert)
local error = require(Util.Error)

local Types = require(Package.Types)
local Props = require(Package.Props)
local ElementKind = require(Package.ElementKind)

local InternalKey = TypeMarker.Mark("ComponentInternalKey")

local Component = {}

Component.defaultProps = {}

function Component:init(props, children) end

function Component:render(props, children)
	error("Componenet:render() is a required method")
end

function Component:beforeMount(props, children) end

function Component:onMount(props, children) end

function Component:beforeUnmount(props, children) end

function Component:onUnmount(props, children) end

function Component:shouldRerender(props, children)
	return true
end

function Component:beforeRerender(props, children) end

function Component:onRerender(props, children) end

function Component:beforeUpdate(newProps, newChildren) end

function Component:onUpdate(newProps, newChildren) end

Component.new = function(name)
	local self = setmetatable({
		name = name,
	}, {
		__tostring = function(self)
			return "[Vision] - Component: " .. self.name
		end,
		__index = function(self, key)
			if key == "app" then
				return self[InternalKey].app
			end
		end,
		__newindex = function(self, key, value)
			if key == "app" then
				error("Cannot override Component.app")
			else
				rawset(self, key, value)
			end
		end,
	})
	Type.SetType(self, ElementKind.Component)

	for key, value in pairs(Component) do
		if key ~= "new" then
			self[key] = value
		end
	end

	return self
end

local function assignRef(newElement, component, node)
	if not newElement.props[Props.Ref] then
		if component.props[Props.Ref] then
			local key, child = next(node.children)
			local nextChild = next(node.children, key)

			if not nextChild then
				local ref = component.props[Props.Ref]
				if typeof(ref) == "function" then
					ref(child.data.object)
				elseif Type.GetType(ref) == Types.DynamicValue then
					ref:set(child.data.object)
				else
					error("Invalid property [Vision.Ref] (type 'function' or type Types.DynamicValue expected)")
				end
			end
		end
	end
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

	local app = Type.GetType(props[Props.App]) == Types.App and props[Props.App] or {}
	local appMetatable = getmetatable(app)
	if appMetatable then
		appMetatable.__index = function(self, key)
			if key == "component" then
				return component
			end
			local value = rawget(component, key)
			if typeof(value) ~= 'function' then
				return value
			end
		end
		appMetatable.__newindex = function(self, key, value)
			if key == "component" then
				error("Cannot override Component.app.component")
			else
				rawset(self, key, value)
			end
		end
	end

	component[InternalKey] = {
		app = app,
		node = node,
		nodeTree = nodeTree,
	}

	component.props = Assign({}, self.defaultProps, node.cascade, props)
	component.children = element.children
	component.cascade = node.cascade

	component:init(component.props, component.children)

	assert(component.state == nil or typeof(component.state) == "table", "Component.state must be a 'table'")
	component[InternalKey].state = Copy(component.state)
	function component:setState(newState)
		local stateType = typeof(newState)
		assert(
			stateType == "table" or stateType == "function",
			"Component:setState() must be a 'table' or a 'function'"
		)
		if stateType == "function" then
			newState = newState(component.state)
		end
		component[InternalKey].state = Copy(newState)
		component.state = newState
		component:rerender()
	end

	component:beforeMount(component.props, component.children)

	local newElement = component:render(component.props, component.children)
	assert(Type.GetType(newElement) == Types.Element, "Component:render() must return a valid Element")

	nodeTree:updateChildren({
		node = node,
		children = newElement,
		parent = node.data.parent,
	})

	if newElement.props then
		assignRef(newElement, component, node)
	end

	component:onMount(component.props, component.children)
end

function Component:rerender()
	if not self:shouldRerender(self.props, self.children) then
		return
	end

	self:beforeRerender(self.props, self.children)

	local newElement = self:render(self.props, self.children)
	assert(Type.GetType(newElement) == Types.Element, "Component:render() must return a valid Element")

	local Internal = self[InternalKey]

	Internal.nodeTree:updateChildren({
		node = Internal.node,
		children = newElement,
		parent = Internal.node.data.parent,
	})

	if newElement.props then
		assignRef(newElement, self, Internal.node)
	end

	self:onRerender(self.props, self.children)
end

function Component:_unmount()
	local Internal = self[InternalKey]
	local node = Internal.node
	local nodeTree = Internal.nodeTree

	self:beforeUnmount(self.props, self.children)

	for _, node in pairs(node.children) do
		nodeTree:unmountNode({
			node = node,
		})
	end
	if node.data.eventManager then
		node.data.eventManager:Destroy()
	end

	self:onUnmount(self.props, self.children)
end

function Component:_update(newElement)
	local newProps = Assign({}, self.defaultProps, self.cascade, newElement.props)
	local newChildren = newElement.children

	self:beforeUpdate(newProps, newChildren)

	self.props = newProps
	self.children = newChildren

	local newElement = self:render(self.props, self.children)
	assert(Type.GetType(newElement) == Types.Element, "Component:render() must return a valid Element")

	local Internal = self[InternalKey]

	Internal.nodeTree:updateChildren({
		node = Internal.node,
		children = newElement,
		parent = Internal.node.data.parent,
	})

	if newElement.props then
		assignRef(newElement, self, Internal.node)
	end

	self:onUpdate(self.props, self.children)
end

return Component
