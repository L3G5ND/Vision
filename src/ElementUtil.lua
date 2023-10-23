local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)
local ElementKind = require(Package.ElementKind)

return {
	Iterator = function(element)
		if Type.GetType(element) == Types.Element then
			local called = false
			return function()
				if not called then
					called = true
					return Types.ParentKey, element
				end
			end
		end

		return pairs(element)
	end,
	fromKey = function(elements, key)
		if elements == nil then
			return nil
		end

		if Type.GetType(elements) == Types.Element then
			if key == Types.ParentKey then
				return elements
			end

			return nil
		end

		if typeof(elements) == "table" then
			return elements[key]
		end
	end,
}
