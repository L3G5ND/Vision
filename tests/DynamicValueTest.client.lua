local RS = game:GetService('ReplicatedStorage')

local UILibrary = require(RS.UILibrary)

local dynamicValue = UILibrary.dynamicValue.new('a')

local newElement = UILibrary.createElement('ScreenGui', {}, {
    UILibrary.createElement('Frame', {
        Size = UDim2.new(0, 400, 0, 400),
        Position = UDim2.new(.5, 0, .5, 0),
        AnchorPoint = Vector2.new(.5, .5),
        BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    }, {
        UILibrary.createElement('UIListLayout', {
            Padding = UDim.new(0, 1.5),
        }),
        UILibrary.createElement('UIPadding', {
            PaddingTop = UDim.new(0, 2),
        }),

        UILibrary.createElement('Frame', {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
        }, {
            UILibrary.createElement('UIPadding', {
                PaddingTop = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            }),
            UILibrary.createElement('TextBox', {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(104, 104, 104),
                Text = dynamicValue:get(),
                [UILibrary.Change.Text] = function(object)
                    dynamicValue:set(object.Text)
                end,
            }),
        }),

        UILibrary.createElement('Frame', {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
        }, {
            UILibrary.createElement('UIPadding', {
                PaddingTop = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            }),
            UILibrary.createElement('TextButton', {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(104, 104, 104),
                Text = dynamicValue:map(function(value)
                    if value == '' then
                        return ''
                    end
                    return 'Text - '..value
                end),
                [UILibrary.Event.MouseButton1Down] = function(object)
                    print('Down')
                end,
                [UILibrary.Event.MouseButton1Up] = function(object)
                    print('Up')
                end
            }),
        })
    })
})

UILibrary.mount(newElement, script.Parent)