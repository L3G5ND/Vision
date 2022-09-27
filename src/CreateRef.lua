local Package = script.Parent

local DynamicValue = require(Package.DynamicValue)

return function()
	return DynamicValue.new()
end
 