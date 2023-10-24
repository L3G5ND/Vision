local Package = script.Parent.Parent

local Util = Package.Util
local Type = require(Util.Type)
local assert = require(Util.Assert)

local Types = require(Package.Types)
local ElementKind = require(Package.ElementKind)

return function(component, props, children)
	if not props then
		props = {}
	end
	if not children then
		children = {}
	end

	assert(typeof(component) == "Instance", "Invalid argument #1 (Must be a valid Roblox Instance)")
	assert(typeof(props) == "table", "Invalid argument #2 (Must be of type 'table')")
	assert(typeof(children) == "table", "Invalid argument #3 (Must be of type 'table')")

	local kind = ElementKind.WrappedSingle

	local element = setmetatable({

		component = component,
		kind = kind,

		props = props,
		children = children,
	}, {
		__newindex = function() end,
	})
	Type.SetType(element, Types.Element)

	return element
end
