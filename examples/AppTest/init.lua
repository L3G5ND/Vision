local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local Vision = require(RS.Vision)

local element = Vision.createElement

local AppTest = Vision.Component.new("App")

function AppTest:init()
    self.color = Vision.dynamicValue.new(Color3.fromRGB(56, 56, 56))

    self.app.borderColor = Vision.dynamicValue.new(Color3.new(1, 1, 1))
    function self.app:setColor(color)
        self.color:set(color)
    end
end

function AppTest:render()
    return element("ScreenGui", {}, {
		element("Frame", {
			Position = UDim2.fromScale(.5, .5),
			Size = UDim2.fromOffset(264, 264),
			AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.app.borderColor
		}, {
            element("Frame", {
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromScale(.9, .9),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = self.color,
            })
        })
    })
end

return function()
    local app = Vision.createApp()

	local tree = Vision.mount(element(AppTest, {
        [Vision.App] = app
    }), plrGui)

    local didStop = false

	local function stop()
        didStop = true
		tree:unmount()
	end

    task.spawn(function()
        app.borderColor:set(Color3.fromRGB(26, 26, 26))

        local hue = 0
		local connection
        connection = RunService.RenderStepped:Connect(function(dt)
			local step = dt / 3
			hue = (hue + step) % 1
			app:setColor(Color3.fromHSV(hue, 1, 1))
            if didStop then
                connection:Disconnect()
            end
		end)
    end)

	return stop
end
