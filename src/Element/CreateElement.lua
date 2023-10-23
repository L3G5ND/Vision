local Package = script.Parent.Parent

local Util = Package.Util
local Type = require(Util.Type)
local Assert = require(Util.Assert)

local Types = require(Package.Types)
local ElementKind = require(Package.ElementKind)

return function(component, props, children)
	if not props then
		props = {}
	end
	if not children then
		children = {}
	end

	Assert(typeof(props) == "table", "Invalid argument #2 (Must be of type 'table')")
	Assert(typeof(children) == "table", "Invalid argument #3 (Must be of type 'table')")

	local kind = ElementKind.Normal
	if Type.GetType(component) == "function" then
		kind = ElementKind.Function
	elseif Type.GetType(component) == ElementKind.Component then
		kind = ElementKind.Component
	end

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
