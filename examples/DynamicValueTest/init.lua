local RS = game:GetService("ReplicatedStorage")

local Vision = require(RS.Vision)

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local element = Vision.createElement

local dynamicValue = Vision.dynamicValue.new("Hello!")

local newElement = element("ScreenGui", {}, {
	element("Frame", {
		Size = UDim2.new(0, 400, 0, 400),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	}, {
		element("UIListLayout", {
			Padding = UDim.new(0, 1.5),
		}),
		element("UIPadding", {
			PaddingTop = UDim.new(0, 2),
		}),

		element("Frame", {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
		}, {
			element("UIPadding", {
				PaddingTop = UDim.new(0, 2),
				PaddingBottom = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
			element("TextBox", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(104, 104, 104),
				Text = dynamicValue:get(),
				[Vision.Change.Text] = function(object)
					dynamicValue:set(object.Text)
				end,
			}),
		}),

		element("Frame", {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
		}, {
			element("UIPadding", {
				PaddingTop = UDim.new(0, 2),
				PaddingBottom = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
			element("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(104, 104, 104),
				Text = dynamicValue:map(function(value)
					if value == "" then
						return ""
					end
					return "Text - " .. value
				end),
				[Vision.Event.MouseButton1Down] = function(object)
					print("Down")
				end,
				[Vision.Event.MouseButton1Up] = function(object)
					print("Up")
				end,
			}),
		}),
	}),
})

return function()
	local tree = Vision.mount(newElement, plrGui)

	local function stop()
		tree:unmount()
	end

	return stop
end
