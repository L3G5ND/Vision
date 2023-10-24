local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local assert = require(Util.Assert)

local Types = require(Package.Types)
local Signal = require(Package.Signal)

local DynamicValue = {}

DynamicValue.new = function(value)
	local self = setmetatable({
		value = value,
		_signal = Signal.new(),
	}, {
		__index = DynamicValue,
	})
	Type.SetType(self, Types.DynamicValue)

	return self
end

function DynamicValue:get()
	return self.value
end

function DynamicValue:set(value)
	self.value = value
	self._signal:Fire(value)
end

function DynamicValue:onChanged(callback)
	assert(typeof(callback) == "function", "Invalid argument #1 (type 'function' expected)")
	return self._signal:Connect(callback)
end

function DynamicValue:map(func)
	assert(typeof(func) == "function", "Invalid argument #1 (type 'function' expected)")
	local map = {
		DynamicValue = self,
		isMap = true,
		get = function()
			return func(self:get())
		end,
	}
	Type.SetType(map, Types.DynamicValue)

	return map
end

return DynamicValue
