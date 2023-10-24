local Package = script.Parent.Parent

local Util = Package.Util
local Type = require(Util.Type)
local assert = require(Util.Assert)

local Types = require(Package.Types)
local ElementKind = require(Package.ElementKind)

return function(elements)
	assert(typeof(elements) == "table", "Invalid argument #1 (Must be of type 'table')")

	local elementGroup = setmetatable({
		elements = elements,
		kind = ElementKind.Group,
	}, {
		__newindex = function() end,
	})
	Type.SetType(elementGroup, Types.Element)

	return elementGroup
end
