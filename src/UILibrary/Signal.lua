local signal = {}

signal.new = function()
    local self = setmetatable({}, {__index = signal})
    self._connections = {}
    return self
end

function signal:Connect(callback)
    assert(typeof(callback) == 'function', string.format("callback must be a function, got %s", tostring(callback)))

    local index = #self._connections+1
    self._connections[index] = callback

    return function()
        self._connections[index] = nil
    end
end

function signal:Fire(...)
    local args = {...}
    self._firing = true
    for _, callback in pairs(self._connections) do
        callback(table.unpack(args))
    end
    self._firing = false
end

function signal:AsyncFire(...)
    local args = {...}
    self._firing = true
    for _, callback in pairs(self._connections) do
        coroutine.wrap(function()
            callback(table.unpack(args))
        end)()
    end
    self._firing = false
end

function signal:Disconnect()
    self._connections = nil
end

return signal