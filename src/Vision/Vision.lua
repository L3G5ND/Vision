local Package = script.Parent

local Props = Package.Props

local Element = require(Package.Element)

local NodeTree = require(Package.NodeTree)
local UIRenderer = require(Package.UIRenderer)

local Renderer = NodeTree.createRenderer(UIRenderer)

local Vision = {

    createElement = Element.createElement,
    createElementGroup = Element.createElementGroup,
    Component = require(Package.Component),
    
    createRef = require(Package.CreateRef),
    dynamicValue = require(Package.DynamicValue),

    Event = require(Props.Event),
    Change = require(Props.Change),
    Ref = require(Props.Ref),

    mount = function(element, parent)
        return Renderer:mountNodeTree(element, parent)
    end,
    update = function(tree, newElement)
        return Renderer:updateNodeTree(tree, newElement)
    end,
    unmount = function(tree)
        return Renderer:unmountNodeTree(tree)
    end,

    types = require(Package.Types),
    
}

return Vision