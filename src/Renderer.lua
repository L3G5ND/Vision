local Package = script.Parent

local Props = Package.Props
local CascadeProp = require(Props.Cascade)

local Util = Package.Util
local Type = require(Util.Type)
local DeepEqual = require(Util.DeepEqual)
local Assert = require(Util.Assert)

local Element = require(Package.Element)
local Types = require(Package.Types)
local UIRenderer = require(Package.UIRenderer)
local Enviroments = require(Package.Enviroments)

local Renderer = {}
Renderer.RootKey = "root"

function Renderer.mount(element, parent, name)
	Assert(Type.GetType(element) == Types.Element, "Invalid argument #1 (Must be a valid Element)")
	Assert(parent, "Invalid argument #2 (Must be a Roblox Instance)")
	Assert(typeof(parent) == "Instance", "Invalid argument #2 (Must be a Roblox Instance)")

	local tree = setmetatable({
		root = nil,
		script = getfenv(2).script,
		mounted = false,
	}, {
		__index = Renderer,
	})
	Type.SetType(tree, Types.Renderer)

	tree.root = tree:mountNode({
		element = element,
		parent = parent,
		key = name or Renderer.RootKey,
	})

	Assert(tree:getRootNode().data.parent == parent, "Parent property cannot be assigned to Host Nodes")

	tree.mounted = true
	Enviroments.add(tree.script, tree)

	return tree
end

function Renderer:unmount()
	Enviroments.remove(self.script, self)

	self:unmountNode({
		node = self.root,
	})

	self.mounted = false
end

function Renderer:update(newElement)
	Assert(Type.GetType(newElement) == Types.Element, "Invalid argument #1 (Must be a valid Element)")

	self.root = self:updateNode({
		node = self.root,
		newElement = newElement,
	})
end

function Renderer.isRenderer(tree)
	return Type.GetType(tree) == Types.Renderer
end

function Renderer.isRootNode(node)
	return node.key == "root"
end

function Renderer:getRootNode()
	return self.root
end

function Renderer:mountNode(data)
	local element = data.element
	local parent = data.parent
	local key = data.key
	local cascade = data.cascade or {}

	local node = {
		parent = Types.None,
		children = {},
		key = key,
		cascade = cascade,
		data = {
			parent = parent,
			element = element,
			object = Types.None,
		},
	}
	Type.SetType(node, Types.Node)

	if element.props then
		local cascadeProp = element.props[CascadeProp]
		if cascadeProp then
			Assert(
				typeof(cascadeProp) == "table",
				"Invalid property [" .. tostring(Types.Cascader) .. "] (type 'table' expected)"
			)
			for key, value in pairs(cascadeProp) do
				node.cascade[key] = value
			end
		end
	end

	local kind = element.kind

	if kind == Element.kind.Normal then
		UIRenderer.Render(self, node)
	elseif kind == Element.kind.Group then
		self:updateChildren({
			node = node,
			children = element.elements,
			parent = parent,
		})
	elseif kind == Element.kind.Function then
		local newElement = element.component(element.props)
		Assert(Type.GetType(newElement) == Types.Element, "Element Function must return a valid Element")

		self:updateChildren({
			node = node,
			children = newElement,
			parent = node.data.parent,
		})
	elseif kind == Element.kind.Component then
		element.component:_mount(self, node)
	elseif kind == Element.kind.Wrapped then
		UIRenderer.Render(self, node)
	elseif kind == Element.kind.WrappedSingle then
		UIRenderer.Render(self, node)
	end

	return node
end

function Renderer:unmountNode(data)
	local node = data.node
	local element = node.data.element

	local kind = element.kind

	if kind ~= Element.kind.Component then
		for _, node in pairs(node.children) do
			self:unmountNode({
				node = node,
			})
		end
		if node.data.eventManager then
			node.data.eventManager:Destroy()
		end
		if node.data.object == Types.None then
			return
		end
		node.data.object:Destroy()
	else
		element.component:_unmount(self, node)
	end
end

function Renderer:updateNode(data)
	local node = data.node
	local element = node.data.element
	local newElement = data.newElement

	local parent = node.data.parent
	local key = node.key
	local cascade = node.cascade

	local componentIsSame = DeepEqual(element.component, newElement.component)
	local isFunction = typeof(newElement.component) == "function" or typeof(element.component) == "function"

	if not componentIsSame and not isFunction then
		self:unmountNode({
			node = node,
		})
		return self:mountNode({
			element = newElement,
			parent = parent,
			key = key,
			cascade = cascade,
		})
	else
		if newElement.props then
			local cascadeProp = newElement.props[CascadeProp]
			if cascadeProp then
				Assert(
					typeof(cascadeProp) == "table",
					"Invalid property [" .. tostring(Types.Cascader) .. "] (type 'table' expected)"
				)
				for key, value in pairs(cascadeProp) do
					node.cascade[key] = value
				end
			end
		end

		local kind = newElement.kind

		if kind == Element.kind.Normal then
			node = UIRenderer.Update(self, node, newElement)
		elseif kind == Element.kind.Group then
			self:updateChildren({
				node = node,
				children = newElement.elements,
				parent = parent,
			})
		elseif kind == Element.kind.Function then
			local newElement = newElement.component(newElement.props)
			Assert(Type.GetType(newElement) == Types.Element, "Element function must return a valid Element")

			self:updateChildren({
				node = node,
				children = newElement,
				parent = parent,
			})
		elseif kind == Element.kind.Component then
			element.component.update(node.data._component)
		elseif kind == Element.kind.Wrapped then
			node = UIRenderer.Update(self, node, newElement)
		elseif kind == Element.kind.WrappedSingle then
			node = UIRenderer.Update(self, node, newElement)
		end
		node.data.element = newElement

		return node
	end
end

function Renderer:updateChildren(data)
	local node = data.node
	local newChildren = data.children
	local parent = data.parent

	local updateNodes = {}

	for key, child in pairs(node.children) do
		local newElement = Element.fromKey(newChildren, key)

		if not newElement then
			self:unmountNode({
				node = child,
			})
			node.children[key] = nil
			continue
		end

		if not DeepEqual(node.data.element, newElement) then
			child = self:updateNode({
				node = child,
				newElement = newElement,
			})
			updateNodes[key] = true
			node.children[key] = child
		end
	end

	for key, child in Element.iterator(newChildren) do
		if not updateNodes[key] then
			local _key = key
			if key == Types.ParentKey then
				_key = node.key
			end

			local childNode = self:mountNode({
				element = child,
				parent = parent,
				key = _key,
				cascade = node.cascade,
			})

			childNode.parent = node
			node.children[key] = childNode
		end
	end
end

return Renderer
