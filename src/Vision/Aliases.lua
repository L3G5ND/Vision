local Package = script.Parent

local Vision = require(Package.Vision)

local Aliases = {}

Aliases.element = Vision.createElement
Aliases.elementGroup = Vision.createElementGroup
Aliases.wrap = Vision.wrapComponent
Aliases.wrapSingle = Vision.wrapSingleComponent

Aliases.component = Vision.Component

Aliases.mountTree = Vision.mount
Aliases.unmountTree = Vision.unmount
Aliases.updateTree = Vision.update

return Aliases