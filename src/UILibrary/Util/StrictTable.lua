return function(table, name)
	name = name or tostring(table)
    local mt = getmetatable(table)
    local indexFunc
    local newIndexFunc
    if mt then
        indexFunc = mt.__index
        newIndexFunc = mt.__newindex
    end
	return setmetatable(table, {
		__index = function(tbl, key)
            if indexFunc then
                indexFunc()
            end
			error(("%q is not a valid member of %s"):format(tostring(key), name), 2)
		end,

		__newindex = function(tbl, key, value)
            if newIndexFunc then
                newIndexFunc()
            end
			error(("%s does not accept new values, got %q"):format(name, tostring(key)), 2)
		end,
	})
end