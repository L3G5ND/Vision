local Util = script.Parent
local error = require(Util.Error)

return function(condition, message, level)
	if not condition then
		error(message, level)
	end
end
