local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)

local plr = game:GetService('Players').LocalPlayer
local plrGui = plr.PlayerGui

local dynamicValue = Vision.dynamicValue.new('Hello!')

local partRef = Vision.createRef()

local newElement = Vision.createElement('ScreenGui', {}, {
	Vision.createElement('Frame', {
		Size = UDim2.new(0, 400, 0, 54),
		Position = UDim2.new(.5, 0, .5, 0),
		AnchorPoint = Vector2.new(.5, .5),
		BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	}, {
		Vision.createElement('UIListLayout', {
			Padding = UDim.new(0, 1.5),
		}),
		Vision.createElement('UIPadding', {
			PaddingTop = UDim.new(0, 2),
		}),

		Vision.createElement('Frame', {
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
		}, {
			Vision.createElement('UIPadding', {
				PaddingTop = UDim.new(0, 2),
				PaddingBottom = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
			Vision.createElement('TextBox', {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(104, 104, 104),
				Text = dynamicValue:get(),
				[Vision.Change.Text] = function(object)
					dynamicValue:set(object.Text)
				end,
			}),
		})
	})
})

local element = Vision.createElement("Part", {
    Anchored = true,
    Position = Vector3.new(0, 10.5, 0),
    [Vision.Ref] = partRef
}, {
    SurfaceGui = Vision.createElement("SurfaceGui", {
        Parent = plrGui,
        Adornee = partRef
    }, {
        TextLabel = Vision.createElement("TextLabel", {
			Text = dynamicValue,
            Size = UDim2.new(1, 0, 1, 0)
        })
    })
})

Vision.mount(element, workspace)
Vision.mount(newElement, plrGui)
