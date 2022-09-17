local Package = script

local Util = Package.Util
local StrictTable = require(Util.StrictTable)

local Vision = require(Package.Vision)
local Aliases = require(Package.Aliases)

for alias, v in pairs(Aliases) do
    Vision[alias] = v
end

setmetatable(Vision, {
    __call = function(tbl, ...)
        return Vision.createElement(...)
    end,
})

return StrictTable(Vision, 'UILibrary')