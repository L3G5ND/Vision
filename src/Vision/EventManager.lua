local Package = script.Parent

local Util = Package.Util
local TypeMarker = require(Util.TypeMarker)

local EventManager = {}

EventManager.states = {
	Disabled = TypeMarker.Mark("Disabled"),
	Suspended = TypeMarker.Mark("Suspended"),
	Enabled = TypeMarker.Mark("Enabled"),
}

EventManager.types = {
	Event = function(object, key)
		return object[key]
	end,
	Change = function(object, key)
		return object:GetPropertyChangedSignal(key)
	end,
}

function EventManager.new(object)
	return setmetatable({

		_suspendedEvents = {},
		_connections = {},
		_callbacks = {},
		_isResuming = false,

		state = EventManager.states.Disabled,
		object = object,
	}, {
		__index = EventManager,
	})
end

function EventManager:Connect(type, key, callback)
	local event = EventManager.types[type](self.object, key)
	local callbackKey = type .. "." .. key

	if not self._connections[callbackKey] then
		self._connections[callbackKey] = event:Connect(function(...)
			if self.state == EventManager.states.Enabled then
				self._callbacks[callbackKey](self.object, ...)
			elseif self.state == EventManager.states.Suspended then
				self._suspendedEvents[#self._suspendedEvents + 1] = { callbackKey, { ... } }
			end
		end)
	end
	self._callbacks[callbackKey] = callback
end

function EventManager:Suspend()
	self.state = EventManager.states.Suspended
end

function EventManager:Resume()
	if self._isResuming then
		return
	end

	self._isResuming = true

	local index = 1

	while index <= #self._suspendedEvents do
		local callbackArgs = self._suspendedEvents[index]
		local eventKey = callbackArgs[1]
		local args = callbackArgs[2]

		if self._connections[eventKey] then
			coroutine.wrap(self._callbacks[eventKey])(self.object, args)
		end

		index += 1
	end

	self.state = EventManager.states.Enabled
	self._isResuming = false
	self._suspendedEvents = {}
end

function EventManager:Destroy()
	for _, connection in pairs(self._connections) do
		connection:Disconnect()
	end
	self = nil
end

return EventManager
