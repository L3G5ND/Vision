local Package = script.Parent.Parent
local Element = script.Parent

local Util = Package.Util
local Type = require(Util.Type)

local Types = require(Package.Types)

return function(elements, key)
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
end
