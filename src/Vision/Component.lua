local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local TypeMarker = require(Util.TypeMarker)
local Assign = require(Util.Assign)

local Types = require(Package.Types)
local Element = require(Package.Element)

local Component = {}


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
            return self.name
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

    self.props = Assign({}, props)
    self.node = node
    self.nodeTree = nodeTree

    self:init(props)

    self:beforeMount()

    local newElement = self:render(props)
    assert(Type.GetType(newElement) == Types.Element, 'Component:render() must return a valid Element')

    nodeTree:updateChildren({
        node = node,
        children = newElement,
        parent = node.data.parent
    })

    self:onMount()
end

function Component:_unmount(nodeTree)
    self:beforeUnmount()

    for _, node in pairs(self.node.children) do
        nodeTree:unmountNode({
            node = node
        })
    end
    if self.node.data.eventManager then
        self.node.data.eventManager:Destroy()
    end

    self:onUnmount()
end


function Component:update()

    if not self:shouldUpdate() then
        return
    end

    self:beforeUpdate()

    local newElement = self:render(self.props)
    assert(Type.GetType(newElement) == Types.Element, 'Component:render() must return a valid Element')

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