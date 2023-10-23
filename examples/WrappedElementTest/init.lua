local RS = game:GetService("ReplicatedStorage")

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local Vision = require(RS.Vision)

local wrapElement = Vision.wrapElement

local UI = Instance.new("ScreenGui")
UI.IgnoreGuiInset = true
UI.ResetOnSpawn = false

local Frame = Instance.new("Frame", UI)
Frame.Size = UDim2.new(0, 264, 0, 264)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
Frame.BorderSizePixel = 0

local ImageButton = Instance.new("ImageButton", Frame)
ImageButton.Size = UDim2.new(0.9, 0, 0.9, 0)
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.BackgroundColor3 = Color3.fromRGB(107, 107, 107)
ImageButton.BorderSizePixel = 0

local wrappedElement = wrapElement(UI, {}, {
	wrapElement(Frame, {}, {
		wrapElement(ImageButton, {
			[Vision.Event.MouseButton1Down] = function()
				print("down")
			end,
			[Vision.Event.MouseButton1Up] = function()
				print("up")
			end,
		}),
	}),
})

return function()
	local tree = Vision.mount(wrappedElement, plrGui)

	local function stop()
		tree:unmount()
	end

	return stop
end
