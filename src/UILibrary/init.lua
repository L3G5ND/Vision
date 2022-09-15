local Package = script

local Util = Package.Util
local StrictTable = require(Util.StrictTable)

local CustomProps = Package.CustomProps
local Event = require(CustomProps.Event)
local Change = require(CustomProps.Change)

local Element = require(Package.Element)
local Component = require(Package.Component)
local DynamicValue = require(Package.DynamicValue)
local Types = require(Package.Types)

local NodeTree = require(Package.NodeTree)
local UIRenderer = require(Package.UIRenderer)

local Renderer = NodeTree.createRenderer(UIRenderer)

local UILibrary = {

    CreateElement = Element.createElement,
    createElement = Element.createElement,

    CreateElementGroup = Element.createElementGroup,
    createElementGroup = Element.createElementGroup,

    Component = Component,
    component = Component,

    DynamicValue = DynamicValue,
    dynamicValue = DynamicValue,

    Event = Event,
    event = Event,

    Changed = Change,
    changed = Change,

    Mount = function(element, parent)
        return Renderer:mountNodeTree(element, parent)
    end,
    mount = function(element, parent)
        return Renderer:mountNodeTree(element, parent)
    end,

    Update = function(tree, newElement)
        return Renderer:updateNodeTree(tree, newElement)
    end,
    update = function(tree, newElement)
        return Renderer:updateNodeTree(tree, newElement)
    end,

    Unmount = function(tree)
        return Renderer:unmountNodeTree(tree)
    end,
    unmount = function(tree)
        return Renderer:unmountNodeTree(tree)
    end,

    Types = Types,
    types = Types,
    
}

setmetatable(UILibrary, {
    __call = function(tbl, ...)
        Element.createElement(...)
    end,
})

return StrictTable(UILibrary, 'UILibrary')