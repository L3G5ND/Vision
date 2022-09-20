local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local TypeMarker = require(Util.TypeMarker)
local Assign = require(Util.Assign)
local Assert = require(Util.Assert)

local Types = require(Package.Types)
local Element = require(Package.Element)

local Component = {}

Component.defaultProps = {}

function Component:init()
    
end

function Component:render()
    error('Componenet:render() is a required method')
end


function Component:beforeMount()
    
end

function Component:onMount()
    
end


function Component:beforeUnmount()
    
end

function Component:onUnmount()
    
end


function Component:shouldUpdate()
    return true
end


function Component:beforeUpdate()
    
end

function Component:onUpdate()
    
end



Component.new = function(name)
    local self = setmetatable({
        name = name,
    }, {
        __tostring = function(self)
            return '[Vision] - Component: '.. self.name
        end    
    })
    Type.SetType(self, Element.kind.Component)

    for key, value in pairs(Component) do
		if key ~= 'new' then
			self[key] = value
		end
	end

    return self
end

function Component:_mount(nodeTree, node)
    local element = node.data.element
    local props = element.props

    local component = setmetatable({}, getmetatable(self))

    for key, value in pairs(self) do
		if key ~= 'new' then
			component[key] = value
		end
	end

    node.data._component = component
    
    component.props = Assign({}, self.defaultProps, props)
    component.node = node
    component.nodeTree = nodeTree

    component:init(props)

    component:beforeMount()

    local newElement = component:render(props)
    Assert(Type.GetType(newElement) == Types.Element, 'Component:render() must return a valid Element')

    nodeTree:updateChildren({
        node = node,
        children = newElement,
        parent = node.data.parent
    })

    component:onMount()
end

function Component:_unmount(nodeTree, node)
    local component = self.data._component

    component:beforeUnmount()

    for _, node in pairs(component.node.children) do
        nodeTree:unmountNode({
            node = node
        })
    end
    if component.node.data.eventManager then
        component.node.data.eventManager:Destroy()
    end

    component:onUnmount()
end


function Component:update()

    if not self:shouldUpdate() then
        return
    end

    self:beforeUpdate()

    local newElement = self:render(self.props)
    Assert(Type.GetType(newElement) == Types.Element, 'Component:render() must return a valid Element')

    self.nodeTree:updateNode({
        node = self.node,
        newElement = newElement
    })

    self:onUpdate()
end

function Component:_update(nodeTree, newElement)
    nodeTree:updateChildren({
        node = self.node,
        children = newElement,
        parent = self.node.data.parent
    })
end

return Component