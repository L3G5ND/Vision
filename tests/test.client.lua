local RS = game:GetService('ReplicatedStorage')

local UILibrary = require(RS.UILibrary)

local ListItem = UILibrary.Component.new()

function ListItem:init()
    
end

function ListItem:render()
    return UILibrary.createElement('Frame', {
        Size = self.props.Size,
        BackgroundTransparency = 1,
    }, {
        UILibrary.createElement('UIPadding', {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
        }),
        UILibrary.createElement('TextLabel', {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(104, 104, 104),
            Text = self.props.Text
        }),
    })
end

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
           -- [UILibrary.Event.MouseButton1Click] = function()
          --      props(props.Text)
          --  end
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
        createListItems(6)
    })
})
print(newElement)
local virtualTree = UILibrary.mount(newElement, script.Parent)
print(virtualTree)