local RS = game:GetService("ReplicatedStorage")

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local Vision = require(RS.Vision)

local element = Vision.createElement

local scripts = {
    {
        name = 'StoreTest',
        label = 'Store'
    },
    {
        name = 'StateTest',
        label = 'State'
    },
    {
        name = 'ComponentTest',
        label = 'Component'
    },
    {
        name = 'DynamicValueTest',
        label = 'Dynamic Value'
    },
    {
        name = 'ParentPropertyTest',
        label = 'Parent Property'
    },
    {
        name = 'RefTest',
        label = 'Ref'
    },
    {
        name = 'AppTest',
        label = 'App'
    },
    {
        name = 'UpdateNodeTreeTest',
        label = 'Update Node Tree'
    },
    {
        name = 'WrappedElementTest',
        label = 'Wrapped Element'
    }
}

for _, scriptInfo in scripts do
    scriptInfo.run = require(script:WaitForChild(scriptInfo.name))
end

local Examples = Vision.Component.new("Examples")

function Examples:init(props)
    self.CanvasSize = Vision.dynamicValue.new()
    self.runninagTest = false
    self.stopTest = nil
end

function Examples:render(props)
    local children = {
        element("UICorner", {
            CornerRadius = UDim.new(.05, 0)
        }),
        element("UIGridLayout", {
            CellPadding = UDim2.fromOffset(5, 5),
            CellSize = UDim2.fromScale(.316, .11),
        })
    }
    for _, scriptInfo in scripts do
        children[#children+1] = element("TextButton", {
            BackgroundColor3 = Color3.fromRGB(71, 71, 71),
            Text = scriptInfo.label,
            [Vision.Event.MouseButton1Up] = function()
                self.runninagTest = true
                self.stopTest = scriptInfo.run()
                self:rerender()
            end,
        })
    end
	return element("ScreenGui", {}, {
		element("Frame", {
			Position = UDim2.fromScale(.5, .5),
			Size = UDim2.fromScale(.4, .6),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Visible = not self.runninagTest
		}, {
            element("UIStroke", {
                Color = Color3.fromRGB(30, 30, 30),
                Thickness = 8
            }),
            element("UICorner", {
                CornerRadius = UDim.new(.05, 0)
            }),
            element("ScrollingFrame", {
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromScale(.98, .93),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }, children)
		}),
        element("TextButton", {
			Position = UDim2.new(0, 5, 1, -5),
			Size = UDim2.fromScale(.07, .08),
			AnchorPoint = Vector2.new(0, 1),
            Text = 'Back',
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Visible = self.runninagTest,
            [Vision.Event.MouseButton1Up] = function()
                self.runninagTest = false
                self.stopTest()
                self:rerender()
            end
		})
	})
end

Vision.mount(element(Examples), plrGui, "Examples")
