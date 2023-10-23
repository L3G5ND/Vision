local Package = script.Parent

local Util = Package.Util
local AutoType = require(Util.AutoType)

local Types = require(Package.Types)

return {
	Event = AutoType(Types.Event),
	Change = AutoType(Types.Change),
	Ref = Types.Ref,
	App = Types.App,
	Cascade = Types.Cascade,
}
