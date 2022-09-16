local RunService = game:GetService('RunService')
local RS = game:GetService('ReplicatedStorage')

local UILibrary = require(RS.UILibrary)

local RefTest = UILibrary.Component.new('Test')

function RefTest:init(props)
    self.ref = UILibrary.createRef()

    self.color = UILibrary.dynamicValue.new(Color3.fromHSV(0, 1, 1))
    self.rainbowTime = 5
end

function RefTest:render()
    return UILibrary.createElement('ScreenGui', {}, {
        UILibrary.createElement('Frame', {
            Position = UDim2.new(.5, 0, .5, 0),
            Size = UDim2.new(0, 300, 0, 300),
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        }, {
            UILibrary.createElement('TextButton', {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(0, 275, 0, 275),
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = self.color,
                [UILibrary.Ref] = self.ref, -- Useless example but it works
                [UILibrary.Event.MouseButton1Up] = function()             
                    print(self.ref:get().BackgroundColor3)
                end
            })
        })
    })
end

function RefTest:beforeMount()
    local Hue = 0
    RunService.RenderStepped:Connect(function(dt)
        local step = dt/self.rainbowTime
        Hue = (Hue + step)%1
        self.color:set(Color3.fromHSV(Hue, 1, 1))
    end)
end

local element = UILibrary.createElement(RefTest, {}, {})

local tree = UILibrary.mount(element, script.Parent)