local Package = script.Parent

local Util = Package.Util
local Type = Util.Type

local ElementKind = require(Package.ElementKind)
local CreateElement = require(Package.CreateElement)
local BuildElement = require(Package.BuildElement)

local function applyProperties(object, props)
    for prop, value in pairs(props) do
        if object[prop] then
            object[prop] = value
        end
    end
end

local function mount(element, parent, tree)

    if not tree then
        tree = {}
    end

    if element.kind == ElementKind.Normal then
        
        local newTree = {}
        
        local object = BuildElement(element)
        local children = {}
        for i, child in pairs(element.children) do
            if child.kind == ElementKind.Group then
                for i, element in pairs(child.elements) do
                    children[i] = mount(element, object, newTree)
                end
            else
                children[i] = mount(child, object, newTree)
            end
        end

        applyProperties(object, element.props)

        newTree.props = element.props
        newTree.children = children
        newTree.object = object

        object.Parent = parent

        return newTree

    elseif element.kind == ElementKind.Function then

        element = CreateElement(element.content(), element.props, element.children)
        return mount(element, parent)

    elseif element.kind == ElementKind.Group then

        local virtualTrees = {}
        for _, element in pairs(element) do
            table.insert(virtualTrees, mount(element, parent))
        end
        return virtualTrees

    end
end

local Renderer = {}

Renderer.Mount = function(element, parent)
    local tree = mount(element, parent)
    return tree
end

Renderer.Unmount = function(content, parent)

end

return Renderer