local RS = game:GetService("ReplicatedStorage")

local Vision = require(RS.Vision)
local Rodux = require(RS.Packages.Rodux)

local element = Vision.createElement

local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui

local CounterApp = Vision.Component.new("CounterApp")

function CounterApp:init(props, children)
	self.store = props.store -- or self.cascade.store
	self.increment = function()
		self.store:dispatch({
			type = "increment",
		})
		self:rerender()
	end
	self.decrement = function()
		self.store:dispatch({
			type = "decrement",
		})
		self:rerender()
	end
end

function CounterApp:render(props, children)
	return element("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		Increment = element("ImageButton", {
			Size = UDim2.new(0, 145, 0, 100),
			Position = UDim2.new(0.5, -145 / 2 - 5, 0.5, -55),
			AnchorPoint = Vector2.new(0.5, 0.5),

			[Vision.Event.MouseButton1Down] = function()
				self.increment()
			end,
		}),
		Decrement = element("ImageButton", {
			Size = UDim2.new(0, 145, 0, 100),
			Position = UDim2.new(0.5, 145 / 2 + 5, 0.5, -55),
			AnchorPoint = Vector2.new(0.5, 0.5),

			[Vision.Event.MouseButton1Down] = function()
				self.decrement()
			end,
		}),
		Counter = element("TextLabel", {
			Size = UDim2.new(0, 300, 0, 100),
			Position = UDim2.new(0.5, 0, 0.5, 55),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextScaled = true,
			Text = self.store:getState().value,
		}),
	})
end

local store = Rodux.Store.new(function(state, action)
	if action.type == "increment" then
		return {
			value = state.value + 1,
		}
	elseif action.type == "decrement" then
		return {
			value = state.value - 1,
		}
	end

	return state
end, {
	value = 0,
})

function CounterAppCreator(props, children)
	return element(CounterApp, props, children)
end

local tree = Vision.mount(
	element(CounterAppCreator, {
		[Vision.Cascade] = {
			store = store,
		},
	}),
	plrGui,
	"CounterApp"
)
