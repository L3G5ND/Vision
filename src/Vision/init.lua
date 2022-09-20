local Package = script

local Util = Package.Util
local StrictTable = require(Util.StrictTable)

local Vision = require(Package.Vision)

local VisionAPI = {}


VisionAPI.createElement = Vision.createElement
VisionAPI.element = Vision.createElement

VisionAPI.createElementGroup = Vision.createElementGroup
VisionAPI.elementGroup = Vision.createElementGroup

VisionAPI.wrapComponent = Vision.wrapComponent
VisionAPI.wrap = Vision.wrapComponent

VisionAPI.wrapSingleComponent = Vision.wrapSingleComponent
VisionAPI.wrapSingle = Vision.wrapSingleComponent


VisionAPI.Component = Vision.Component
VisionAPI.component = Vision.Component


VisionAPI.CreateRef = Vision.createRef
VisionAPI.createRef = Vision.createRef

VisionAPI.DynamicValue = Vision.dynamicValue
VisionAPI.dynamicValue = Vision.dynamicValue


VisionAPI.Event = Vision.Event
VisionAPI.event = Vision.Event
VisionAPI.OnEvent = Vision.Event
VisionAPI.onEvent = Vision.Event

VisionAPI.Change = Vision.Change
VisionAPI.change = Vision.Change
VisionAPI.OnChange = Vision.Change
VisionAPI.onChange = Vision.Change

VisionAPI.Ref = Vision.Ref
VisionAPI.ref = Vision.Ref


VisionAPI.Renderer = Vision.Renderer
VisionAPI.renderer = Vision.Renderer

VisionAPI.Mount = Vision.Renderer.mount
VisionAPI.mount = Vision.Renderer.mount


VisionAPI.Types = Vision.Types
VisionAPI.types = Vision.Types


setmetatable(VisionAPI, {
    __call = function(tbl, ...)
        return Vision.createElement(...)
    end,
})
return StrictTable(VisionAPI, 'UILibrary')