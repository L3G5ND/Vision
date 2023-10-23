local RS = game:GetService("ReplicatedStorage")

local Vision = require(RS.Vision)
local Rodux = require(RS.Packages.Rodux)

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local element = Vision.createElement

local StateApp = Vision.Component.new("StateApp")

function StateApp:init(props, children)
	self.state = {
        value = 1
    }
end

function StateApp:render()
	return element("ScreenGui", {}, {
		element("TextButton", {
			Size = UDim2.fromScale(.25, .25),
			Position = UDim2.fromScale(.5, .5),
			AnchorPoint = Vector2.new(0.5, 0.5),
            Text = self.state.value,

			[Vision.Event.MouseButton1Down] = function()
				self:setState({
                    value = self.state.value + 1
                })
			end,
		}),
	})
end

return function()
	local tree = Vision.mount(
		element(StateApp),
		plrGui,
		"StateTest"
	)

	local function stop()
		tree:unmount()
	end

	return stop
end
