local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)

local Test = Vision.Component.new('Test')

function Test:init(props)

    self.colors = {
        'gray',
        'red',
        'blue'
    }

    self.colorIndex = 1
    self.color = self.colors[self.colorIndex]

    self.createTestElement = function(props)
        return Vision.createElement('ScreenGui', {}, {
            Vision.createElement('Frame', {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(0, 300, 0, 300),
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = Color3.fromRGB(56, 56, 56)
            }, {
                Vision.createElement('TextButton', {
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.new(0, 275, 0, 275),
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundColor3 = props.color,
                    [Vision.Event.MouseButton1Up] = function()             
                        local newIndex = self.colorIndex + 1
                        if newIndex > #self.colors then
                            self.colorIndex = 1
                        else
                            self.colorIndex = newIndex
                        end

                        self.color = self.colors[self.colorIndex]
                        self:update()
                    end
                })
            })
        })
    end
end

function Test:render()
    local color = self.color
    if color == 'gray' then
        return Vision.createElement(self.createTestElement, {color = Color3.fromRGB(82, 82, 82)})
    elseif color == 'red' then
        return Vision.createElement(self.createTestElement, {color = Color3.fromRGB(168, 82, 82)})
    elseif color == 'blue' then
        return Vision.createElement(self.createTestElement, {color = Color3.fromRGB(100, 119, 180)})
    end
end

local element = Vision.createElement(Test, {}, {})

local tree = Vision.mount(element, script.Parent)

task.wait(10)

Vision.unmount(tree)