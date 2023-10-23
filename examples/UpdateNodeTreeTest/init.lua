local RS = game:GetService("ReplicatedStorage")

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local Vision = require(RS.Vision)

local element = Vision.createElement
local elementGroup = Vision.createElementGroup

local function createListItem(props)
	return element("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
	}, {
		element("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
		}),
		element("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(104, 104, 104),
			Text = props.Text,
			[Vision.Event.MouseButton1Down] = function(object, a)
				print("Down")
			end,
			[Vision.Event.MouseButton1Up] = function(object, a)
				print("Up")
			end,
		}),
	})
end

local function createListItems(n)
	local items = {}
	for i = 1, n do
		items[i] = element(createListItem, { Text = i })
	end
	return elementGroup(items)
end

local function createList(props)
	return element("ScreenGui", {}, {
		element("Frame", {
			Size = UDim2.new(0, 400, 0, 400),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(65, 65, 65),
		}, {
			element("UIListLayout", {
				Padding = UDim.new(0, 1.5),
			}),
			element("UIPadding", {
				PaddingTop = UDim.new(0, 2),
			}),
			createListItems(props.num),
		}),
	})
end

return function()
	local maxNum = 7
	local times = 10

	local tree = Vision.mount(Vision.createElement(createList, { num = maxNum }, {}), plrGui)

	local didStop = false

	local function stop()
		didStop = true
		tree:unmount()
	end

	task.delay(4, function()
		for i = 0, maxNum * times - 1 do
			if didStop then
				break
			end
			tree:update(Vision.createElement(createList, { num = i % maxNum + 1 }, {}))
			task.wait(0.1)
		end
	end)

	return stop
end
