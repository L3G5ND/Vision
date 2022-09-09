local Util = script.Parent

local Cryo = require(Util.Cryo)

return function (table, callbackTable)
    local mt = getmetatable(table)
    local newMetatable = {
        __index = function(tbl, key)
            if mt.__index then
                mt.__index(tbl, key)
            end
            if callbackTable.NilIndex then
                assert( (typeof(callbackTable.NilIndex) == 'function'), string.format('callbackTable.NilIndex must be a function, got %s', typeof(callbackTable.NilIndex)) )
                callbackTable.NilIndex(tbl, key)
            end
        end,
        __newindex = function(tbl, key, value)
            if mt.__newindex then
                mt.__newindex(tbl, key)
            end
            if callbackTable.NewIndex then
                assert( (typeof(callbackTable.NewIndex) == 'function'), string.format('callbackTable.NewIndex must be a function, got %s', typeof(callbackTable.NewIndex)) )
                callbackTable.NewIndex(tbl, key, value)
            end
        end
    }
    newMetatable = Cryo.Dictionary.join(mt, newMetatable)
    table = setmetatable(table, newMetatable)
    return table
end