local Package = script.Parent

local Util = Package.Util
local Copy = require(Util.Copy)
local assert = require(Util.Assert)

local DefualtElements = require(Package.DefualtElements)

local BuildFunctions = Copy(DefualtElements)

setmetatable(BuildFunctions, {
	__index = function(tbl, key)
		return function()
			local success, instance = pcall(Instance.new, key)
			assert(success, "Invalid argument #1 (Must be a valid Instance ClassName)")
			return instance
		end
	end,
})

return function(type)
	return BuildFunctions[type]()
end
