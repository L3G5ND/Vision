local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local DeepEqual = require(Util.DeepEqual)

local Element = require(Package.Element)
local Types = require(Package.Types)

local NodeTree = {}

NodeTree.createRenderer = function(renderer)
    local self = setmetatable({}, {__index = NodeTree})
    self.renderer = renderer
    return self
end

function NodeTree:getRootNode(node)
    local currentNode = node
    while true do
        local parentNode = node.parent
        if parentNode == Types.None then
            break
        end
        currentNode = parentNode
    end
    return currentNode
end

function NodeTree:isRootNode(node)
    return node.key == 'root'
end

function NodeTree:updateChildren(data)

    local node = data.node
    local newChildren = data.children
    local parent = data.parent

    local updateNodes = {}

    for key, child in pairs(node.children) do
        local newElement = Element.fromKey(newChildren, key)
        
        if not newElement then
            self:unmountNode({
                node = child
            })
            node.children[key] = nil
            continue
        end

        if not self:isSame({
            node = node, 
            element = newElement
        }) then
            child = self:updateNode({
                node = child, 
                newElement = newElement
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
            })
            childNode.parent = node
            node.children[key] = childNode
        end
    end
end

function NodeTree:_createNode(data)
    local element = data.element
    local parent = data.parent
    local key = data.key

    local node = {
        parent = Types.None,
        children = {},
        key = key,
        data = {
            parent = parent,
            element = element,
            object = Types.None,
        },
    }
    Type.SetType(node, Types.Node)

    return node
end

function NodeTree:isSame(data)
    local node = data.node
    local element = data.element

    return DeepEqual(node.data.element, element) 
end

function NodeTree:updateNode(data)
    
    local node = data.node
    local element = node.data.element
    local newElement = data.newElement

    local parent = node.data.parent
    local key = node.key

    if node.children[Types.ParentKey] then
        node = node.children[Types.ParentKey]
    end

    local componentIsSame = DeepEqual(element.component, newElement.component)
    local isFunction = typeof(newElement.component) == 'function' or typeof(element.component) == 'function'

    if not componentIsSame and not isFunction then
        self:unmountNode({
            node = node
        })
        return self:mountNode({
            element = newElement,
            parent = parent,
            key = key
        })

    else
        local kind = newElement.kind

        if kind == Element.kind.Normal then
            node = self.renderer.Update(self, node, newElement)

        elseif kind == Element.kind.Group then
            self:updateChildren({
                node = node,
                children = newElement.elements,
                parent = parent
            })

        elseif kind == Element.kind.Function then
            local newElement = newElement.component(newElement.props)
            assert(Type.GetType(newElement) == Types.Element, 'Element function must return a valid Element')

            self:updateNode({
                node = node,
                newElement = newElement
            })
            
        elseif kind == Element.kind.Component then
            element.component:_update(self, node, newElement)

        elseif kind == Element.kind.Wrapped then
            node = self.renderer.Update(self, node, newElement)

        end
        node.data.element = newElement

        return node
    end
end

function NodeTree:mountNode(data)

    local element = data.element
    local parent = data.parent
    local key = data.key

    local node = self:_createNode({
        element = element,
        parent = parent,
        key = key
    })
    
    local kind = element.kind
    
    if kind == Element.kind.Normal then
        self.renderer.Render(self, node)

    elseif kind == Element.kind.Group then
        self:updateChildren({
            node = node,
            children = element.elements,
            parent = parent
        })

    elseif kind == Element.kind.Function then
        local newElement = element.component(element.props)
        assert(Type.GetType(newElement) == Types.Element, 'Element function must return a valid Element')

        self:updateChildren({
            node = node,
            children = newElement,
            parent = node.data.parent
        })

    elseif kind == Element.kind.Component then
        element.component:_mount(self, node)

    elseif kind == Element.kind.Wrapped then
        self.renderer.Render(self, node, true)

    end

    return node
end

function NodeTree:unmountNode(data)
    
    local node = data.node
    local element = node.data.element

    local kind = element.kind

    if kind ~= Element.kind.Component then
        for _, node in pairs(node.children) do
            self:unmountNode({
                node = node
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
        element.component:_unmount(self)
    end

end

function NodeTree:mountNodeTree(element, parent)

    assert(Type.GetType(element) == Types.Element, 'element not a element')
    assert(parent, 'parent cant be nil')

    local tree = {
        root = nil,
    }
    Type.SetType(tree, Types.NodeTree)

    tree.root = self:mountNode({
        element = element, 
        parent = parent,
        key = 'root'
    })

    assert(self:getRootNode(tree.root).data.parent == parent, 'Parent property cant be assigned to host nodes')

    return tree
end

function NodeTree:unmountNodeTree(tree)
    self:unmountNode({
        node = tree.root
    })
end

function NodeTree:updateNodeTree(tree, newElement)
    tree.root = self:updateNode({
        node = tree.root,
        newElement = newElement
    })
end

return NodeTree