local Package = script.Parent

local Util = Package.Util
local Assert = require(Util.Assert)

local signal = {}

signal.new = function()
	local self = setmetatable({}, { __index = signal })
	self._connections = {}
	return self
end

function signal:Connect(callback)
	Assert(typeof(callback) == "function", "Invalid argument #1 (Must be of type 'function')", 4)

	local index = #self._connections + 1
	self._connections[index] = callback

	return function()
		self._connections[index] = nil
	end
end

function signal:Fire(...)
	local args = { ... }
	self._firing = true
	for _, callback in pairs(self._connections) do
		callback(table.unpack(args))
	end
	self._firing = false
end

function signal:AsyncFire(...)
	local args = { ... }
	self._firing = true
	for _, callback in pairs(self._connections) do
		coroutine.wrap(function()
			callback(table.unpack(args))
		end)()
	end
	self._firing = false
end

function signal:Disconnect()
	for key, _ in pairs(self._connections) do
		self._connections[key] = nil 
	end
end

return signal
