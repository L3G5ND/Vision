local signal = {}

signal.new = function()
    local self = setmetatable({}, {__index = signal})
    self._connections = {}
    self._firing = false
    return self
end

function signal:Connect(callback)
    assert(typeof(callback) == string.format("function", "callback must be a function, got %s", callback))

    local index = #self._connections+1
    self._connections[index] = callback

    return function()
        self._connections[index] = nil
    end
end

function signal:Fire(...)
    self._firing = true
    for _, connection in pairs(self._connections) do
        connection.callback(...)
    end
    self._firing = false
end

function signal:Disconnect()
    self._connections = nil
end

return signal