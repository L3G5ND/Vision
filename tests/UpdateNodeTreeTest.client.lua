local RS = game:GetService('ReplicatedStorage')

local UILibrary = require(RS.UILibrary)

local function createListItem(props)
    return UILibrary.createElement('Frame', {
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
            Text = props.Text,
            [UILibrary.Event.MouseButton1Down] = function(object, a)
                print('Down')
            end,
            [UILibrary.Event.MouseButton1Up] = function(object, a)
                print('Up')
            end
        }),
    })
end

local function createListItems(n)
    local items = {}
    for i = 1, n do
        items[i] = UILibrary.createElement(createListItem, {Text = i})
    end
    return UILibrary.createElementGroup(items)
end

local function createList(props)
    return UILibrary.createElement('ScreenGui', {}, {
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
            createListItems(props.num)
        })
    })
end

local maxNum = 7
local times = 10

local tree = UILibrary.mount(UILibrary.createElement(createList, {num = maxNum}, {}), script.Parent)

task.wait(6)

for i = 0, maxNum*times-1 do
    UILibrary.update(tree, UILibrary.createElement(createList, {num = i%maxNum+1}, {}))
    wait(.1)
end