local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local Vision = require(RS.Vision)

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local element = Vision.createElement

local RefTest = Vision.Component.new("Ref")

function RefTest:init(props)
	self.ref = Vision.createRef()

	self.color = Vision.dynamicValue.new(Color3.fromHSV(0, 1, 1))
	self.rainbowTime = props.RainbowTime
	self.smoothRainbow = props.SmoothRainbow
end

function RefTest:render(props)
	return element("ScreenGui", {}, {
		element("Frame", {
			Position = props.Position,
			Size = UDim2.new(0, 300, 0, 300),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		}, {
			element("TextButton", {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 275, 0, 275),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = self.color,
				[Vision.Ref] = self.ref, -- Useless example but it works
				[Vision.Event.MouseButton1Up] = function()
					print(self.ref:get().BackgroundColor3)
				end,
			}),
		}),
	})
end

function RefTest:beforeMount()
	if self.smoothRainbow then
		local MIN_SATURATION = 0.65
		local MAX_SATURATION = 0.75
		local SPEED_CONSTANT = 5 -- Worked best

		local hue = 0
		RunService.RenderStepped:Connect(function(dt)
			local step = dt / self.rainbowTime
			hue = (hue + step) % 1
			local Saturation = math.sin(hue * math.pi * SPEED_CONSTANT) * (MAX_SATURATION - MIN_SATURATION)
				+ MIN_SATURATION
			self.color:set(Color3.fromHSV(hue, Saturation, 1))
		end)
	else
		local hue = 0
		RunService.RenderStepped:Connect(function(dt)
			local step = dt / self.rainbowTime
			hue = (hue + step) % 1
			self.color:set(Color3.fromHSV(hue, 1, 1))
		end)
	end
end

local element1 = element(RefTest, {
	Position = UDim2.new(0.25, 0, 0.5, 0),
	RainbowTime = 3,
}, {})
local element2 = element(RefTest, {
	Position = UDim2.new(0.75, 0, 0.5, 0),
	SmoothRainbow = true,
	RainbowTime = 3,
}, {})

return function()
	local tree1 = Vision.mount(element1, plrGui)
	local tree2 = Vision.mount(element2, plrGui)

	local function stop()
		tree1:unmount()
		tree2:unmount()
	end

	return stop
end

