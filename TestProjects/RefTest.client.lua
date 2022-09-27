local RunService = game:GetService('RunService')
local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)

local plr = game:GetService('Players').LocalPlayer
local plrGui = plr.PlayerGui

local RefTest = Vision.Component.new('Test')

function RefTest:init(props)
    self.ref = Vision.createRef()

    self.color = Vision.dynamicValue.new(Color3.fromHSV(0, 1, 1))
    self.rainbowTime = props.RainbowTime
    self.smoothRainbow = props.SmoothRainbow
end

function RefTest:render(props)
    return Vision.createElement('ScreenGui', {}, {
        Vision.createElement('Frame', {
            Position = props.Position,
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
    if self.smoothRainbow then
        local MIN_SATURATION = .65
        local MAX_SATURATION = .75
        local SPEED_CONSTANT = 5 -- Worked best

        local Hue = 0
        RunService.RenderStepped:Connect(function(dt)
            local step = dt/self.rainbowTime
            Hue = (Hue + step)%1
            local Saturation = math.sin( Hue*math.pi*SPEED_CONSTANT )*( MAX_SATURATION-MIN_SATURATION )+MIN_SATURATION
            self.color:set(Color3.fromHSV(Hue, Saturation, 1))
        end)
    else
        local Hue = 0
        RunService.RenderStepped:Connect(function(dt)
            local step = dt/self.rainbowTime
            Hue = (Hue + step)%1
            self.color:set(Color3.fromHSV(Hue, 1, 1))
        end)
    end
end

local element1 = Vision.createElement(RefTest, {
    Position = UDim2.new(.25, 0, .5, 0),
    RainbowTime = 3
}, {})
local element2 = Vision.createElement(RefTest, {
    Position = UDim2.new(.75, 0, .5, 0),
    SmoothRainbow = true,
    RainbowTime = 3
}, {})

Vision.mount(element1, plrGui)
Vision.mount(element2, plrGui) 