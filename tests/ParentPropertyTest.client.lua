local RS = game:GetService('ReplicatedStorage')

local UILibrary = require(RS.UILibrary)

local partRef = UILibrary.createRef()

local element = UILibrary.createElement("Part", {
    Anchored = true,
    Position = Vector3.new(0, 10.5, 0),
    [UILibrary.Ref] = partRef
}, {
    SurfaceGui = UILibrary.createElement("SurfaceGui", {
        Parent = script.Parent,
        Adornee = partRef
    }, {
        TextLabel = UILibrary.createElement("TextLabel", {
            Text = 'Hello!',
            Size = UDim2.new(1, 0, 1, 0)
        })
    })
})

local tree = UILibrary.mount(element, workspace)