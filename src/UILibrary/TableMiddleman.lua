local function makeTable(tbl)
	local newTable = {}
	for i, v in pairs(tbl) do
		if typeof(v) == 'userdata' then
			local mt = getmetatable(v)
			local tbl = mt.__tbl
			newTable[i] = makeTable(tbl)
		else
			newTable[i] = v
		end
	end
	return newTable
end

local function findParentProxy(proxy)
	local currectTbl = proxy
	while true do
		local mt = getmetatable(currectTbl)
		local parent = mt.__parent
		if not parent then
			break
		end
		currectTbl = parent
	end
	return currectTbl
end

local function isParentProxy(proxy, value)
	local foundParent = false
	local currectTbl = proxy
	while not foundParent do
		local mt = getmetatable(currectTbl)
		local originalTable = mt.__originalTable
		if originalTable == value then
			foundParent = true
			break
		end
		local parent = mt.__parent
		if not parent then
			break
		end
		currectTbl = parent
	end
	return foundParent
end

local TableMiddleman = {}

function TableMiddleman:onChanged(func)
	local mt = getmetatable(self)
	local index = #mt.__changedConnections+1
	mt.__changedConnections[index] = func
	return function()
		mt.__changedConnections[index] = nil
	end
end

function TableMiddleman:onIndexed(func)
	local mt = getmetatable(self)
	local index = #mt.__indexedConnections+1
	mt.__indexedConnections[index] = func
	return function()
		mt.__indexedConnections[index] = nil
	end
end

function TableMiddleman:rawPath(path)
	local parent = findParentProxy(self)
	path = string.split(path, '.')
	local currentIndex
	for _, path in pairs(path) do
		if not currentIndex then
			currentIndex = self:getKeyRaw(path)
		else
			currentIndex = currentIndex:getKeyRaw(path)
		end
	end
	return currentIndex
end

function TableMiddleman:getKeyRaw(key)
	local mt = getmetatable(self)
	return mt.__tbl[key]
end

function TableMiddleman:setKeyRaw(key, value)
	local mt = getmetatable(self)
	mt.__tbl[key] = value
end

function TableMiddleman:getRawTable()
	local mt = getmetatable(self)
	return makeTable(mt.__tbl)
end

local function wrapTable(tbl, parent)

	local proxy = newproxy(true)
	local mt = getmetatable(proxy)

	mt.__originalTable = tbl
	mt.__parent = parent

    local wrappedTbl = {}
	for i, v in pairs(tbl) do
        if typeof(v) == 'table' then
			if not isParentProxy(proxy, v) then
				v = wrapTable(v, proxy)
			end
        end
		wrappedTbl[i] = v
	end

	mt.__tbl = wrappedTbl

	mt.__changedConnections = {}
	mt.__indexedConnections = {}

	mt.__tostring = function()
		local tbl = makeTable(wrappedTbl)
		print(tbl)
		return ''
	end

	mt.__len = function()
		return #wrappedTbl
	end

	local function index(tbl, key)
		if TableMiddleman[key] then
			return TableMiddleman[key]

		else
			if not wrappedTbl[key] then
				return
			end

			local parentTable = findParentProxy(proxy)
			local mt = getmetatable(parentTable)

			for _, func in pairs(mt.__indexedConnections) do
				func(proxy, key, wrappedTbl[key])
			end

			return wrappedTbl[key]
		end
	end

	local function newIndex(tbl, key, value)
		index(tbl, key)

		local parentTable = findParentProxy(proxy)
		local mt = getmetatable(parentTable)

		for _, func in pairs(mt.__changedConnections) do
			func(proxy, key, value, wrappedTbl[key])
		end

		if typeof(value) == 'table' then
			value = wrapTable(value, proxy)
		end

		wrappedTbl[key] = value

		return wrappedTbl[key]
	end

	mt.__newindex = newIndex
	mt.__index = index

	return proxy
end

return wrapTable