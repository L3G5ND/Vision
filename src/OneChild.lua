local Package = script.Parent

local Util = Package.Util
local assert = require(Util.Assert)

return function(children)
	assert(typeof(children) == "table", "Invalid argument #1 (Type 'table' expected)")

	local key, child = next(children)

	assert(child, "Invalid argument #1 (At least, one child element must be specified)")

	local nextChild = next(children, key)

	assert(nextChild, "Invalid argument #1 (At most, one child element must be specified)")

	return child
end
