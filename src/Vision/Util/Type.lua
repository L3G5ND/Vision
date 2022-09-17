local Type = {}

Type.GetType = function(content)
    if typeof(content) ~= 'table' then
        return typeof(content)
    end
    local mt = getmetatable(content)
    if mt then
        if mt._type then
            return mt._type
        end
    end
    return 'table'
end

Type.SetType = function(tbl, type)
    assert(typeof(tbl) == 'table', string.format('Table expected, got %s', typeof(tbl)))
    if not getmetatable(tbl) then
        setmetatable(tbl, {})
    end
    getmetatable(tbl)._type = type
end

return Type