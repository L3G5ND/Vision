local Package = script.Parent.Parent

local Util = Package.Util
local Copy = require(Util.Copy)

local Types = require(Package.Types)

return function(tbl, ...)
	tbl = Copy(tbl)

	for index = 1, select("#", ...) do
		local source = select(index, ...)

		if source ~= nil then
			for key, value in pairs(source) do
				if value == Types.None then
					tbl[key] = nil
				else
					tbl[key] = value
				end
			end 
		end
	end

	return tbl
end
