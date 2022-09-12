local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)
local Node = require(Package.Node)
local ElementKind = require(Package.ElementKind)
local NodeTree = require(Package.NodeTree)
local BuildElement = require(Package.BuildElement)

local function elementNodeIterator(elementNodes)

    if Type.GetType(elementNodes) == Node.Type then
        local called = false
        return function()
            if not called then
                called = true
                return true, elementNodes
            end
        end
    end
    
    return pairs(elementNodes)
end

local function mount(element, parent)
    local tree = NodeTree.new()--createNodeTree(createNode(element))

    function tree:createNode(element)
        local kind = element.kind
        if kind == ElementKind.Normal then
            local node = Node.new()
            node.children = node:getOutputs()
            node.data = {
                type = element.type,
                kind = element.kind,
                props = element.props,
                children = element.children,
                Object = Types.None
            }
            node:onConnect(function(otherNode)
                otherNode.parent = node
            end)
            return node

        elseif kind == ElementKind.Group then
            local elements = {}
            for _, element in pairs(element.elements) do
                elements[#elements+1] = self:createNode(element)
            end
            return elements

        end
    end

    function tree:descender(node)
        if node.data.children then
            for _, element in pairs(node.data.children) do
                local childNodes = self:createNode(element)
                for _, childNode in elementNodeIterator(childNodes) do
                    node:connect(childNode)
                    self:descender(childNode)
                end
            end
        end
    
        return node
    end

    function tree:mountNode(node, parent)
        local object = BuildElement(node.data.type)
        for prop, value in pairs(node.data.props) do
            object[prop] = value
        end
        if parent then
            object.Parent = parent
        end
        return object
    end

    function tree:mountTree(parent)
        local function mountChildren(node, parent)
            local object = self:mountNode(node, parent)
            node.data.Object = object
            for _, child in pairs(node.children) do
                mountChildren(child, object)
            end
        end
        mountChildren(self.tree)
        self.tree.data.Object.Parent = parent
    end

    function tree:updateNode(node, parent)
        local object = Node.data.Obejct
        for prop, value in pairs(node.data.props) do
            object[prop] = value
        end
        if parent then
            object.Parent = parent
        end
        return object
    end

    tree:createTree(element)
    tree:mountTree(parent)

    return tree.tree
end

return {
    Mount = mount
}