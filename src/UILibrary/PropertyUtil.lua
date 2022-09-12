local Package = script.Parent

local Util = Package.Util
local TypeMarker = require(Util.TypeMarker)

local PropertyUtil = {}

local nilProperty = TypeMarker.Mark('nilProperty')
local DefualtPropertyCache = {}
PropertyUtil.GetDefualtProperty = function(type, prop)
    local cache = DefualtPropertyCache[type]
    if cache then
        local propCache = cache[prop]
        if propCache == nilProperty then
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
            cache[prop] = nilProperty
        end
    end

    return defualtProperty

end

local validPropertyCache = {}
PropertyUtil.IsValidProperty = function(type, prop)
    local cache = validPropertyCache[type]
    if cache then
        local prop = cache[prop]
        if prop == nilProperty then
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
        cache[prop] = nilProperty
        return false
    end
end

PropertyUtil.applyNormalProp = function(object, prop, value)
    assert(PropertyUtil.IsValidProperty(object.ClassName, prop), string.format('%s.%s is not a valid property', object.ClassName, prop))
    if value == nil then
        value = PropertyUtil.GetDefualtProperty(object.ClassName, prop)
    end
    object[prop] = value
end

PropertyUtil.applyProp = function(node, prop, newValue, oldValue)

    local object = node.data.object

    if newValue == oldValue then
        return
    end

    PropertyUtil.applyNormalProp(object, prop, newValue)

end

PropertyUtil.applyProps = function(node, props)
    for prop, value in pairs(props) do
        PropertyUtil.applyProp(node, prop, value, nil)
    end
end

return PropertyUtil