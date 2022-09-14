local StrictTable = require(script.Util.StrictTable)

local Element = require(script.Element)
local Component = require(script.Component)
local Types = require(script.Types)

local NodeTree = require(script.NodeTree)
local UIRenderer = require(script.UIRenderer)

local Renderer = NodeTree.createRenderer(UIRenderer)

local UILibrary = {

    CreateElement = Element.createElement,
    createElement = Element.createElement,

    CreateElementGroup = Element.createElementGroup,
    createElementGroup = Element.createElementGroup,

    Component = Component,
    component = Component,

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

    Types = Types,
    types = Types,
    
}

setmetatable(UILibrary, {
    __call = function(tbl, ...)
        Element.createElement(...)
    end,
})

return StrictTable(UILibrary, {
    NilIndex = function(tbl, key)
        error(string.format('UILibrary.%s does not exist', key))
    end,
    NewIndex = function(tbl, key, value)
        error('UILibrary does not accept new values')
    end
})