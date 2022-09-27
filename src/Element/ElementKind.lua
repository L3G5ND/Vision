local Package = script.Parent.Parent

local Util = Package.Util
local TypeMarker = require(Util.TypeMarker)

local elementKinds = {
	Normal = TypeMarker.Mark("Normal"),
	Group = TypeMarker.Mark("Group"),
	Function = TypeMarker.Mark("Function"),
	Component = TypeMarker.Mark("Component"),
	Wrapped = TypeMarker.Mark("Wrapped"),
	WrappedSingle = TypeMarker.Mark("WrappedSingle"),
}

return setmetatable({
	Kinds = elementKinds,
}, {
	__index = function(tbl, key)
		if elementKinds[key] then
			return elementKinds[key]
		end
	end,
})
 