--[[local middleman = require(game:GetService('ReplicatedStorage').UILibrary.TableMiddleman)

local tbl = {
    a = 1,
    b = 2,
    c = {
        a = 2,
        b = 3,
        c = {
            a = 4,
            b = 5,
            c = {

            }
        }
    }
}

tbl = middleman(tbl)

print(tbl)]]