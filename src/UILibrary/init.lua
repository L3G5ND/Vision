local StrictTable = require(script.Util.StrictTable)

local CreateElement = require(script.CreateElement)
local CreateElementGroup = require(script.CreateElementGroup)
local Component = require(script.Component)
local Renderer = require(script.Renderer)
local Types = require(script.Types)

local UILibrary = {

    CreateElement = CreateElement,
    createElement = CreateElement,

    CreateElementGroup = CreateElementGroup,
    createElementGroup = CreateElementGroup,

    Component = Component,
    component = Component,

    Mount = Renderer.Mount,
    mount = Renderer.Mount,

    Types = Types,
    types = Types,
    
}

setmetatable(UILibrary, {
    __call = function(tbl, ...)
        CreateElement(...)
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