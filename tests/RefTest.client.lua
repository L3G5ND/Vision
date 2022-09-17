local RunService = game:GetService('RunService')
local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)

local RefTest = Vision.Component.new('Test')

function RefTest:init(props)
    self.ref = Vision.createRef()

    self.color = Vision.dynamicValue.new(Color3.fromHSV(0, 1, 1))
    self.rainbowTime = 5
end

function RefTest:render()
    return Vision.createElement('ScreenGui', {}, {
        Vision.createElement('Frame', {
            Position = UDim2.new(.5, 0, .5, 0),
            Size = UDim2.new(0, 300, 0, 300),
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        }, {
            Vision.createElement('TextButton', {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(0, 275, 0, 275),
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = self.color,
                [Vision.Ref] = self.ref, -- Useless example but it works
                [Vision.Event.MouseButton1Up] = function()             
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

local element = Vision.createElement(RefTest, {}, {})

local tree = Vision.mount(element, script.Parent)