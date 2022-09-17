local Package = script.Parent

local Vision = require(Package.Vision)

local Aliases = {}

Aliases.wrap = Vision.wrapComponent

Aliases.component = Vision.Component

Aliases.Types = Vision.types

return Aliases