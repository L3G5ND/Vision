local Package = script.Parent.Parent

local Util = Package.Util
local TypeCache = require(Util.TypeCache)

local Types = require(Package.Types)

return TypeCache(Types.Change)
