local Package = script.Parent.Parent

local Types = require(Package.Types)

return function(tbl, ...)
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
