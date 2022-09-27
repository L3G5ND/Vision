local Package = script.Parent.Parent

local Util = Package.Util
local Type = require(Util.Type)

return function(_type)
	local self = setmetatable({}, {
		__index = function(self, key)
			if self.Cache[key] then
				return self.Cache[key]
			end
			local newType = setmetatable({
				key = key,
			}, {
				__tostring = function(tbl)
					return tostring(_type)
				end,
			})
			Type.SetType(newType, _type)

			self.Cache[key] = newType

			return newType
		end,
	})
	self.Cache = {}
	return self
end
