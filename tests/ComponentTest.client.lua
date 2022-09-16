local RS = game:GetService('ReplicatedStorage')

local UILibrary = require(RS.UILibrary)

local Test = UILibrary.Component.new('Test')

function Test:init(props)

    self.colors = {
        'gray',
        'red',
        'blue'
    }

    self.colorIndex = 1
    self.color = self.colors[self.colorIndex]

    self.createTestElement = function(props)
        return UILibrary.createElement('ScreenGui', {}, {
            UILibrary.createElement('Frame', {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(0, 300, 0, 300),
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = Color3.fromRGB(56, 56, 56)
            }, {
                UILibrary.createElement('TextButton', {
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.new(0, 275, 0, 275),
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundColor3 = props.color,
                    [UILibrary.Event.MouseButton1Up] = function()             
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
        return UILibrary.createElement(self.createTestElement, {color = Color3.fromRGB(82, 82, 82)})
    elseif color == 'red' then
        return UILibrary.createElement(self.createTestElement, {color = Color3.fromRGB(168, 82, 82)})
    elseif color == 'blue' then
        return UILibrary.createElement(self.createTestElement, {color = Color3.fromRGB(100, 119, 180)})
    end
end

local element = UILibrary.createElement(Test, {}, {})

local tree = UILibrary.mount(element, script.Parent)

task.wait(5)

UILibrary.unmount(tree)