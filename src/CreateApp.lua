local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)

return function()
	local app = setmetatable({}, {})
	Type.SetType(app, Types.App)
	return app
end
