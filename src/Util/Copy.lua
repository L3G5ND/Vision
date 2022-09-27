local function copy(tbl)
	local newTable = {}
	local mt = getmetatable(tbl)
	for i, v in pairs(tbl) do
		if typeof(v) == "table" then
			newTable[i] = copy(v)
		else
			newTable[i] = v
		end
	end
	setmetatable(newTable, mt)
	return newTable
end

return copy
