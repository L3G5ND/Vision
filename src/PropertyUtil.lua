local RunService = game:GetService('RunService')

local Package = script.Parent

local Util = Package.Util
local Type = require(Util.Type)
local Assert = require(Util.Assert)

local Types = require(Package.Types)
local EventManager = require(Package.EventManager)

local PropertyUtil = {}

local DefualtPropertyCache = {}
PropertyUtil.GetDefualtProperty = function(type, prop)
	local cache = DefualtPropertyCache[type]
	if cache then
		local propCache = cache[prop]
		if propCache == Types.None then
			return nil
		end
		if propCache then
			return propCache
		end
	else
		DefualtPropertyCache[type] = {}
		cache = DefualtPropertyCache[type]
	end

	local object = Instance.new(type)
	local success, defualtProperty = pcall(function()
		return object[prop]
	end)
	object:Destroy()

	if success then
		if defualtProperty then
			cache[prop] = defualtProperty
		else
			cache[prop] = Types.None
		end
	end

	return defualtProperty
end

local validPropertyCache = {}
PropertyUtil.IsNormalProperty = function(type, prop)
	local cache = validPropertyCache[type]
	if cache then
		local prop = cache[prop]
		if prop == Types.None then
			return false
		end
		if prop then
			return true
		end
	else
		validPropertyCache[type] = {}
		cache = validPropertyCache[type]
	end

	local object = Instance.new(type)
	local success, _ = pcall(function()
		return object[prop]
	end)
	object:Destroy()

	if success then
		cache[prop] = true
		return true
	else
		cache[prop] = Types.None
		return false
	end
end

PropertyUtil.applyEventProperty = function(node, prop, value)
	local propType = Type.GetType(prop)

	if not node.data.eventManager then
		node.data.eventManager = EventManager.new(node.data.object)
	end

	local key = prop.key

	if propType == Types.Event then
		node.data.eventManager:Connect("Event", key, value)
	elseif propType == Types.Change then
		node.data.eventManager:Connect("Change", key, value)
	end
end

PropertyUtil.applySpecialProperty = function(node, prop, value)
	if typeof(value) ~= 'function' then
		node.data.object[prop] = value
	else
		if not node.data.cameraEventManager then
			node.data.cameraEventManager = EventManager.new(workspace.CurrentCamera)
			node.data.updateSpecialProperties = {}
			node.data.cameraEventManager:Connect('Change', 'ViewportSize', function(viewportSize)
				for prop, value in pairs(node.data.updateSpecialProperties) do
					node.data.object[prop] = value(viewportSize)
				end
			end)
		end
		node.data.updateSpecialProperties[prop] = value
		node.data.object[prop] = value(workspace.CurrentCamera.ViewportSize)
	end
end

PropertyUtil.applyRefProperty = function(node, ref)
	if typeof(ref) == "function" then
		ref(node.data.object)
	elseif Type.GetType(ref) == Types.DynamicValue then
		ref:set(node.data.object)
	else
		error("[Vision] - Invalid property [Vision.Ref] (type 'function' or type Types.DynamicValue expected)")
	end
end

PropertyUtil.applyDynamicValueProperty = function(node, prop, value)
	if value.isMap then
		value.DynamicValue:onChanged(function()
			PropertyUtil.applyNormalProperty(node.data.object, prop, value:get())
		end)
		PropertyUtil.applyNormalProperty(node.data.object, prop, value:get())
	else
		value:onChanged(function()
			PropertyUtil.applyNormalProperty(node.data.object, prop, value:get())
		end)
		PropertyUtil.applyNormalProperty(node.data.object, prop, value:get())
	end
end

PropertyUtil.applyNormalProperty = function(object, prop, value)
	if value == nil then
		value = PropertyUtil.GetDefualtProperty(object.ClassName, prop)
	end
	object[prop] = value
end

PropertyUtil.applyProperty = function(node, prop, newValue, oldValue)
	local object = node.data.object

	if prop == "Parent" then
		return
	end

	if newValue == oldValue then
		return
	end

	local propType = Type.GetType(prop)
	local newValueType = Type.GetType(newValue)
	local oldValueType = Type.GetType(oldValue)

	if propType == Types.Event or propType == Types.Change then
		PropertyUtil.applyEventProperty(node, prop, newValue)
	elseif prop == Types.Ref then
		PropertyUtil.applyRefProperty(node, newValue)
	elseif newValueType == Types.DynamicValue then
		PropertyUtil.applyDynamicValueProperty(node, prop, newValue)
	elseif prop == 'Size' then
		PropertyUtil.applySpecialProperty(node, 'Size', newValue)
	elseif prop == 'Position' then
		PropertyUtil.applySpecialProperty(node, 'Position', newValue)
	elseif PropertyUtil.IsNormalProperty(object.ClassName, prop) then
		PropertyUtil.applyNormalProperty(object, prop, newValue)
	else
		-- Ignore prop
	end
end

PropertyUtil.applyProperties = function(node, props)
	for prop, value in pairs(props) do
		PropertyUtil.applyProperty(node, prop, value, nil)
	end
end

PropertyUtil.updateProperties = function(node, props)
	local oldProps = node.data.element.props
	for prop, value in pairs(props) do
		PropertyUtil.applyProperty(node, prop, value, oldProps[prop])
	end

	for prop, value in pairs(oldProps) do
		local newValue = props[prop]
		if newValue == nil then
			PropertyUtil.applyProperty(node, prop, nil, value)
		end
	end
end

return PropertyUtil
