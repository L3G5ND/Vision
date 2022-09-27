return function()
	local Package = script.Parent

	local Util = Package.Util
	local Type = require(Util.Type)

	local Types = require(Package.Types)
	local DynamicValue = require(Package.DynamicValue)

	describe("DynamicValue.new", function()
		it("should return a DynamicValue object", function()
			local dynamicValue = DynamicValue.new()

			expect(dynamicValue).to.be.ok()
		end)

		it("should return an object with type DynamicValue", function()
			local dynamicValue = DynamicValue.new()
 
			expect(Type.GetType(dynamicValue)).to.equal(Types.DynamicValue)
		end)
	end)

	describe("DynamicValue:get", function()
		it("should return a DynamicValue object", function()
			local dynamicValue = DynamicValue.new()

			expect(dynamicValue).to.be.ok()
		end)

		it("should return initial value", function()
			local dynamicValue = DynamicValue.new("initial value")

			expect(dynamicValue:get()).to.equal("initial value")
		end)

		it("should return DynamicValue.value", function()
			local dynamicValue = DynamicValue.new("initial value")

			expect(dynamicValue:get()).to.equal(dynamicValue.value)
		end)
	end)

	describe("DynamicValue:set", function()
		it("should return nil", function()
			local dynamicValue = DynamicValue.new()

			expect(dynamicValue:set()).to.equal(nil)
		end)

		it("should change dynamicValue:get", function()
			local dynamicValue = DynamicValue.new("value1")

			local value1 = dynamicValue:get()

			dynamicValue:set("value2")

			local value2 = dynamicValue:get()

			expect(value1).never.to.equal(value2)
			expect(value2).to.equal("value2")
		end)
	end)

	describe("DynamicValue:onChanged", function()
		it("should return disconnect function", function()
			local dynamicValue = DynamicValue.new()

			expect(dynamicValue:onChanged(function() end)).to.be.a("function")
		end)

		it("should expect argument #1 to be type 'function'", function()
			local dynamicValue = DynamicValue.new()

			expect(function()
				dynamicValue:onChanged()
			end).to.throw()
		end)

		it("should not fire changed function", function()
			local dynamicValue = DynamicValue.new()

			local changed = false
			local disconnect = dynamicValue:onChanged(function()
				changed = true
			end)

			expect(changed).to.equal(false)
		end)

		it("should fire when changed", function()
			local dynamicValue = DynamicValue.new()

			local changed = false
			dynamicValue:onChanged(function()
				changed = true
			end)

			dynamicValue:set(1)

			expect(changed).to.equal(true)
		end)

		it("should disconnect connection", function()
			local dynamicValue = DynamicValue.new()

			local changedCount = 0
			local disconnect = dynamicValue:onChanged(function()
				changedCount += 1
			end)

			dynamicValue:set()

			expect(changedCount).to.equal(1)

			disconnect()
			dynamicValue:set()

			expect(changedCount).to.equal(1)
		end)
	end)

	describe("DynamicValue:map", function()
		it("should expect argument #1 to be type 'function'", function()
			local dynamicValue = DynamicValue.new()

			expect(function()
				dynamicValue:map()
			end).to.throw()
		end)

		it("should return a mapped DynamicValue", function()
			local dynamicValue = DynamicValue.new()
			local mappedDynamicValue = dynamicValue:map(function() end)

			expect(mappedDynamicValue.DynamicValue).to.equal(dynamicValue)
			expect(mappedDynamicValue.isMap).to.equal(true)
			expect(mappedDynamicValue.get).to.a("function")
			expect(Type.GetType(mappedDynamicValue)).to.equal(Types.DynamicValue)
		end)

		it("should map correctly", function()
			local dynamicValue = DynamicValue.new(0)

			local map = function(value)
				return value + 1
			end

			local mappedDynamicValue = dynamicValue:map(map)

			expect(mappedDynamicValue.get()).to.equal(map(dynamicValue.value))
		end)
	end)
end
