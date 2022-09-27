local RS = game:GetService("ReplicatedStorage")

local Vision = require(RS.Vision)

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local Test = Vision.Component.new("Test")

function Test:init(props)
	self.indexToColors = {
		"gray",
		"red",
		"blue",
	}
	self.colors = {
		gray = Color3.fromRGB(82, 82, 82),
		red = Color3.fromRGB(168, 82, 82),
		blue = Color3.fromRGB(100, 119, 180),
	}

	self.colorIndex = 1
	self.color = self.colors[self.indexToColors[self.colorIndex]]
end

function Test:render(props)
	return Vision.createElement("ScreenGui", {}, {
		Vision.createElement("Frame", {
			Position = props.Position,
			Size = UDim2.new(0, 300, 0, 300),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(56, 56, 56),
		}, {
			Vision.createElement("TextButton", {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 275, 0, 275),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = self.color,
				[Vision.Event.MouseButton1Up] = function()
					local newIndex = self.colorIndex + 1
					if newIndex > #self.indexToColors then
						self.colorIndex = 1
					else
						self.colorIndex = newIndex
					end

					self.color = self.colors[self.indexToColors[self.colorIndex]]
					self:update()
				end,
			}),
		}),
	})
end

local element1 = Vision.createElement(Test, {
	Position = UDim2.new(0.25, 0, 0.5, 0),
}, {})
local element2 = Vision.createElement(Test, {
	Position = UDim2.new(0.75, 0, 0.5, 0),
}, {})

Vision.mount(element1, plrGui)
Vision.mount(element2, plrGui)
