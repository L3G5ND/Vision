local Package = script

local Element = require(Package.Element)
local Props = require(Package.Props)
local Renderer = require(Package.Renderer)
local Types = require(Package.Types)

local Util = Package.Util
local StrictTable = require(Util.StrictTable)

local Vision = {
	createElement = Element.createElement,
	createElementGroup = Element.createElementGroup,
	wrapElement = Element.wrapElement,
	wrapSingleElement = Element.wrapSingleElement,

	Component = require(Package.Component),

	createRef = require(Package.CreateRef),
	createApp = require(Package.CreateApp),
	dynamicValue = require(Package.DynamicValue),

	Event = Props.Event,
	Change = Props.Change,
	Ref = Props.Ref,
	App = Props.App,
	Cascade = Props.Cascade,

	mount = Renderer.mount,

	oneChild = require(Package.OneChild),

	Types = Types,
	None = Types.None
}

setmetatable(Vision, {
	__call = function(tbl, ...)
		return Element.createElement(...)
	end,
})
return StrictTable(Vision, "Vision")
