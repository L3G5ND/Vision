return {
	ScreenGui = function()
		local instance = Instance.new("ScreenGui")
		instance.ResetOnSpawn = false
		instance.ZIndexBehavior = "Sibling"
		instance.IgnoreGuiInset = true
		return instance
	end,
	SurfaceGui = function()
		local instance = Instance.new("SurfaceGui")
		instance.ResetOnSpawn = false
		instance.ZIndexBehavior = "Sibling"
		instance.SizingMode = "PixelsPerStud"
		instance.PixelsPerStud = 50
		return instance
	end,
	BillboardGui = function()
		local instance = Instance.new("BillboardGui")
		instance.ResetOnSpawn = false
		instance.ZIndexBehavior = "Sibling"
		return instance
	end,
	Frame = function()
		local instance = Instance.new("Frame")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		return instance
	end,
	ScrollingFrame = function()
		local instance = Instance.new("ScrollingFrame")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		instance.ScrollBarImageColor3 = Color3.new(0, 0, 0)
		return instance
	end,
	TextLabel = function()
		local instance = Instance.new("TextLabel")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		instance.Font = "SourceSans"
		instance.Text = ""
		instance.TextColor3 = Color3.new(0, 0, 0)
		instance.TextScaled = true
		return instance
	end,
	TextButton = function()
		local instance = Instance.new("TextButton")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		instance.AutoButtonColor = false
		instance.Font = "SourceSans"
		instance.Text = ""
		instance.TextColor3 = Color3.new(0, 0, 0)
		instance.TextScaled = true
		return instance
	end,
	TextBox = function()
		local instance = Instance.new("TextBox")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		instance.ClearTextOnFocus = false
		instance.Font = "SourceSans"
		instance.Text = ""
		instance.TextColor3 = Color3.new(0, 0, 0)
		instance.TextScaled = true
		return instance
	end,
	ImageLabel = function()
		local instance = Instance.new("ImageLabel")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		return instance
	end,
	ImageButton = function()
		local instance = Instance.new("ImageButton")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		instance.AutoButtonColor = false
		return instance
	end,
	ViewportFrame = function()
		local instance = Instance.new("ViewportFrame")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		return instance
	end,
	VideoFrame = function()
		local instance = Instance.new("VideoFrame")
		instance.BackgroundColor3 = Color3.new(1, 1, 1)
		instance.BorderColor3 = Color3.new(0, 0, 0)
		instance.BorderSizePixel = 0
		return instance
	end,
}
