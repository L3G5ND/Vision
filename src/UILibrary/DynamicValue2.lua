local RunService = game:GetService('RunService')

local DynamicValue = {}
local OnChangedCallbacks = {}
local OnChangedConnection

DynamicValue.new = function(value)
    local self = setmetatable({
        Value = value,
        _onChangedCallbacks = {}
    }, {__index = DynamicValue})
    self._onChangedCallbacksIndex = OnChangedCallbacks[#OnChangedCallbacks+1]
    OnChangedCallbacks[self._onChangedCallbacksIndex] = function()
        for _, callback in pairs(self._onConnectCallbacks) do
            callback(value)
        end
    end
    if not OnChangedConnection then
        OnChangedConnection = RunService.RenderStepped:Connect(function()
            for _, callback in pairs(self._onConnectCallbacks) do
                callback(value)
            end
        end)
    end
    return self
end

function DynamicValue:get()
    return self.Value
end

function DynamicValue:set(value)
    self.Value = value
    for _, callback in pairs(self._onConnectCallbacks) do
        callback(value)
    end
end

function DynamicValue:onChanged(callback)
    self._onChangedCallbacks[#self._onChangedCallbacks+1] = callback
end

function DynamicValue:Destroy()
    OnChangedCallbacks[self._onChangedCallbacksIndex] = nil
end