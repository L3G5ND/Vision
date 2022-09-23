local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)
local Rodux = require(RS.Packages.Rodux)

local element = Vision.createElement

local CounterApp = Vision.Component.new('CounterApp')

function CounterApp:init()
	self.store = self.cascade.store
	self.increment = function()
		self.store:dispatch({
			type = 'increment',
		})
		self:update()
	end
	self.decrement = function()
		self.store:dispatch({
			type = 'decrement',
		})
		self:update()
	end
end

function CounterApp:render()
	return element('ScreenGui', {
		IgnoreGuiInset = true,
	}, {
		Increment = element('ImageButton', {
			Size = UDim2.new(0, 145, 0, 100),
			Position = UDim2.new(.5, -145/2-5, .5, -55),
			AnchorPoint = Vector2.new(.5, .5),
			
			[Vision.Event.MouseButton1Down] = function()
				self.increment()
			end,
		}),
		Decrement = element('ImageButton', {
			Size = UDim2.new(0, 145, 0, 100),
			Position = UDim2.new(.5, 145/2+5, .5, -55),
			AnchorPoint = Vector2.new(.5, .5),
			
			[Vision.Event.MouseButton1Down] = function()
				self.decrement()
			end,
		}),
		Counter = element('TextLabel', {
			Size = UDim2.new(0, 300, 0, 100),
			Position = UDim2.new(.5, 0, .5, 55),
			AnchorPoint = Vector2.new(.5, .5),
			TextScaled = true,
			Text = self.store:getState().value
		}),
	})
end

local store = Rodux.Store.new(
	function(state, action)
		
		if action.type == 'increment' then
			return {
				value = state.value + 1
			}
		elseif action.type == 'decrement' then
			return {
				value = state.value - 1
			}
		end
		
		return state
	end, 
	{
		value = 0
	}
)

local tree = Vision.mount(
    element('Frame', {
        [Vision.Cascade] = {
            store = store
        }
    }, {
        element('Frame', {}, {
            element('Frame', {}, {
                element(CounterApp)
            })
        })    
    }), 
    script.Parent,
    'CounterApp'
)

task.wait(10)

tree:updateNode({
    node = tree.root.children[1],
    newElement = element('Frame', {}, {
        element('Frame', {}, {
            element(CounterApp)
        })
    })   
})

task.wait(10)

tree:unmount()