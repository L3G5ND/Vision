local Package = script

local Util = Package.Util
local StrictTable = require(Util.StrictTable)

local UILibrary = require(Package.UILibrary)
local Aliases = require(Package.Aliases)

for alias, v in pairs(Aliases) do
    UILibrary[alias] = v
end

setmetatable(UILibrary, {
    __call = function(tbl, ...)
        return UILibrary.createElement(...)
    end,
})

return StrictTable(UILibrary, 'UILibrary')