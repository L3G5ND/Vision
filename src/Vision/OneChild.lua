local Package = script.Parent

local Util = Package.Util
local Assert = require(Util.Assert)

return function(children)
    Assert(typeof(children) == 'table', 'Invalid argument #1 (Type \'table\' expected)')

    local key, child = next(children)

    Assert(child, 'Invalid argument #1 (At least, one child element must be specified)')

    local nextChild = next(children, key)

    Assert(nextChild, 'Invalid argument #1 (At most, one child element must be specified)')

    return child
end