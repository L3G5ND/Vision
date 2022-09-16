local Package = script

local Util = Package.Util
local StrictTable = require(Util.StrictTable)

local Props = Package.Props
local Event = require(Props.Event)
local Change = require(Props.Change)
local Ref = require(Props.Ref)

local Element = require(Package.Element)
local Component = require(Package.Component)
local CreateRef = require(Package.CreateRef)
local DynamicValue = require(Package.DynamicValue)
local Types = require(Package.Types)

local NodeTree = require(Package.NodeTree)
local UIRenderer = require(Package.UIRenderer)

local Renderer = NodeTree.createRenderer(UIRenderer)

local UILibrary = {

    createElement = Element.createElement,

    createElementGroup = Element.createElementGroup,

    Component = Component,
    
    createRef = CreateRef,

    dynamicValue = DynamicValue,

    Event = Event,
    Change = Change,
    Ref = Ref,

    mount = function(element, parent)
        return Renderer:mountNodeTree(element, parent)
    end,

    update = function(tree, newElement)
        return Renderer:updateNodeTree(tree, newElement)
    end,

    unmount = function(tree)
        return Renderer:unmountNodeTree(tree)
    end,

    types = Types,
    
}

setmetatable(UILibrary, {
    __call = function(tbl, ...)
        return Element.createElement(...)
    end,
})

return StrictTable(UILibrary, 'UILibrary')