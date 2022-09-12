local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Element = require(Package.Element)
local Types = require(Package.Types)

local NodeTree = {}

NodeTree.createRenderer = function(renderer)
    local self = setmetatable({}, {__index = NodeTree})
    self.renderer = renderer
    return self
end

function NodeTree:updateChildren(data)

    local node = data.node
    local newChildren = data.children
    local parent = data.parent

    for i, child in Element.iterator(newChildren) do
        if child ~= node.children[i] then
            print('added child node', i)
            local childNode = self:mountNode({
                element = child,
                parent = parent
            })
            childNode.parent = node
            node.children[#node.children+1] = childNode
        else
            print('removed child node', i)
            self:unmountNode(child)
        end
    end
end

function NodeTree:_createNode(data)

    local element = data.element
    local parent = data.parent

    local node = {
        parent = Types.None,
        children = {},
        data = {
            parent = parent,
            element = element,
            object = Types.None
        }    
    }
    Type.SetType(node, Types.Node)
    return node
end

function NodeTree:updateNode(data)
    
    local node = data.node
    local newElement = data.newElement

    if node.data.element == newElement then
        return node.data.element
    end

end

function NodeTree:mountNode(data)

    local element = data.element
    local parent = data.parent

    local node = self:_createNode({
        element = element, 
        parent = parent
    })

    local kind = element.kind
    
    if kind == Element.kind.Normal then
        self.renderer.RenderNormal(self, node)
    elseif kind == Element.kind.Group then
        self.renderer.RenderGroup(self, node)
    elseif kind == Element.kind.Function then
        self.renderer.RenderFunction(self, node)
    elseif kind == Element.kind.Component then
        self.renderer.RenderComponent(self, node)
    end

    return node
end

function NodeTree:unmountNode(data)
    
    local node = data.node
    local element = node.data.element

    local kind = element.kind

    if kind ~= Element.kind.Component then
        for _, node in pairs(node.children) do
            self:unmountNode(node)
        end
        node.data.object:Destroy()
        node = nil
    else

    end

end

function NodeTree:mountNodeTree(element, parent)

    assert(Type.GetType(element) == Types.ElementCreator, 'element not a element')
    assert(parent, 'parent cant be nil')

    local tree = {
        root = nil,
        mounted = false,
    }
    Type.SetType(tree, Types.NodeTree)

    tree.root = self:mountNode({
        element = element, 
        parent = parent
    })
    tree.mounted = true

    wait(7)
    self:updateChildren({
        node = tree.root,
        children = Element.createElement('ScreenGui', {}, {
            Element.createElement('Frame', {
                Size = UDim2.new(0, 400, 0, 400),
                Position = UDim2.new(.5, 0, .5, 0),
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            }, {
                Element.createElement('UIListLayout', {
                    Padding = UDim.new(0, 1.5),
                }),
                Element.createElement('UIPadding', {
                    PaddingTop = UDim.new(0, 2),
                }),
            })
        }),
        parent = parent
    })

    return tree
end

return NodeTree