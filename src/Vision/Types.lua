local Package = script.Parent

local Util = Package.Util
local TypeMarker = require(Util.TypeMarker)

local Types = {

    DynamicValue = TypeMarker.Mark('DynamicValue'),
    Event = TypeMarker.Mark('Event'),
    Change = TypeMarker.Mark('Change'),
    Ref = TypeMarker.Mark('Ref'),
    None = TypeMarker.Mark('None'),

    Element = TypeMarker.Mark('Element'),
    NodeTree = TypeMarker.Mark('NodeTree'),
    Node = TypeMarker.Mark('Node'),
    ParentKey = TypeMarker.Mark('ParentKey'),

}

return Types