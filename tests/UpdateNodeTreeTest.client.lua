local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)

local function createListItem(props)
    return Vision.createElement('Frame', {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
    }, {
        Vision.createElement('UIPadding', {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
        }),
        Vision.createElement('TextButton', {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(104, 104, 104),
            Text = props.Text,
            [Vision.Event.MouseButton1Down] = function(object, a)
                print('Down')
            end,
            [Vision.Event.MouseButton1Up] = function(object, a)
                print('Up')
            end
        }),
    })
end

local function createListItems(n)
    local items = {}
    for i = 1, n do
        items[i] = Vision.createElement(createListItem, {Text = i})
    end
    return Vision.createElementGroup(items)
end

local function createList(props)
    return Vision.createElement('ScreenGui', {}, {
        Vision.createElement('Frame', {
            Size = UDim2.new(0, 400, 0, 400),
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
            createListItems(props.num)
        })
    })
end

local maxNum = 7
local times = 10

local tree = Vision.mount(Vision.createElement(createList, {num = maxNum}, {}), script.Parent)

task.wait(8)

for i = 0, maxNum*times-1 do
    tree:update(Vision.createElement(createList, {num = i%maxNum+1}, {}))
    wait(.1)
end

print(tree)