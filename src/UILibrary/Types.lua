local Package = script.Parent

local Util = Package.Util

local TypeMarker = require(Util.TypeMarker)

return {
    None = TypeMarker.Mark('None'),
    ElementCreator = TypeMarker.Mark('ElementCreator'),
    NodeTree = TypeMarker.Mark('NodeTree'),
    Node = TypeMarker.Mark('Node'),
}