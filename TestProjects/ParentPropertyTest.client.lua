local RS = game:GetService('ReplicatedStorage')

local Vision = require(RS.Vision)

local plr = game:GetService('Players').LocalPlayer
local plrGui = plr.PlayerGui

local partRef = Vision.createRef()

local element = Vision.createElement("Part", {
    Anchored = true,
    Position = Vector3.new(0, 10.5, 0),
    [Vision.Ref] = partRef
}, {
    SurfaceGui = Vision.createElement("SurfaceGui", {
        Parent = plrGui,
        Adornee = partRef
    }, {
        TextLabel = Vision.createElement("TextLabel", {
            Text = 'Hello!',
            Size = UDim2.new(1, 0, 1, 0)
        })
    })
})

local tree = Vision.mount(element, workspace) 