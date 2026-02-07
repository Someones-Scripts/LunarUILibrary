--this library is my first so dont judge
--this is in beta and follows MIT license
local Lunar = {}
local TS = game:GetService("TweenService")
Lunar.__index = Lunar

function Lunar:CreateWindow(config)
	if config == nil or config.Title == nil or config.Author == nil then 
		warn("CreateWindow: No Config or required Info")
		return 
	end

	local self = setmetatable({}, Lunar)

	self.Window = Instance.new("ScreenGui")
	self.Window.Name = "Window"
	self.Window.ResetOnSpawn = false
	self.Window.Parent = game:GetService("Players").LocalPlayer.PlayerGui

	local closingEvent = Instance.new("BindableEvent")
	self.Closing = {}
	function self.Closing:Connect(func)
		return closingEvent.Event:Connect(func)
	end

	self.WindowFrame = Instance.new("Frame")
	local WindowUICorner = Instance.new("UICorner")
	local WindowUIStroke = Instance.new("UIStroke")
	local Title = Instance.new("TextLabel")
	self.ElementHolder = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local CloseButton = Instance.new("TextButton")
	local CloseUICorner = Instance.new("UICorner")
	local WindowAspectRatio = Instance.new("UIAspectRatioConstraint")

	self.WindowFrame.Active = true
	self.WindowFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
	self.WindowFrame.BorderSizePixel = 0
	self.WindowFrame.Position = UDim2.new(0.4837, 0, 0.3533, 0)
	self.WindowFrame.Size = UDim2.new(0, 171, 0, 255)
	self.WindowFrame.Name = "WindowFrame"
	self.WindowFrame.Parent = self.Window
    local screenSize = workspace.CurrentCamera.ViewportSize
    local windowWidth = 171  -- width of the window (same as your original value)
    local windowHeight = 255  -- height of the window (same as your original value)

    window.WindowFrame.Position = UDim2.new(0.5, -windowWidth / 2, 0.5, -windowHeight / 2)
	
	WindowUICorner.CornerRadius = UDim.new(0, 12)
	WindowUICorner.Parent = self.WindowFrame

	WindowUIStroke.Color = Color3.fromRGB(255, 255, 255)
	WindowUIStroke.Transparency = 0.94
	WindowUIStroke.Parent = self.WindowFrame

	Title.Font = Enum.Font.GothamBold
	Title.Text = config.Title
	Title.TextColor3 = Color3.fromRGB(245, 245, 245)
	Title.TextSize = 10
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 0, 0, 5)
	Title.Size = UDim2.new(1, 0, 0, 38)
	Title.Name = "Title"
	Title.Parent = self.WindowFrame

	self.ElementHolder.CanvasSize = UDim2.new(0, 0, 0.1, 0)
	self.ElementHolder.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	self.ElementHolder.Active = true
	self.ElementHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	self.ElementHolder.BackgroundTransparency = 1
	self.ElementHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.ElementHolder.BorderSizePixel = 0
	self.ElementHolder.Position = UDim2.new(0, 0, 0, 41)
	self.ElementHolder.Size = UDim2.new(0, 171, 0, 213)
	self.ElementHolder.Name = "ElementHolder"
	self.ElementHolder.Parent = self.WindowFrame

	local holderFrame = Instance.new("Frame")
	holderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	holderFrame.BackgroundTransparency = 1
	holderFrame.BorderSizePixel = 0
	holderFrame.Position = UDim2.new(-0.0175, 0, 0, 0)
	holderFrame.Size = UDim2.new(0, 177, 0, 8)
	holderFrame.Parent = self.ElementHolder

	UIListLayout.Padding = UDim.new(0.015, 0)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = self.ElementHolder

	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Color3.fromRGB(245, 245, 245)
	CloseButton.TextSize = 14
	CloseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	CloseButton.Position = UDim2.new(0.8482, 0, 0.0314, 0)
	CloseButton.Size = UDim2.new(0.1168, 0, 0.07845, 0)
	CloseButton.Name = "Close"
	CloseButton.Parent = self.WindowFrame

	CloseButton.Activated:Connect(function()
		closingEvent:Fire()
		self.Window:Destroy()
	end)

	CloseUICorner.CornerRadius = UDim.new(1, 0)
	CloseUICorner.Parent = CloseButton

	WindowAspectRatio.AspectRatio = 0.6717
	WindowAspectRatio.Parent = self.WindowFrame

	local dragging = false
	local dragInput, mousePos, framePos

	local function update(input)
		local delta = input.Position - mousePos
		local newPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		TS:Create(self.WindowFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
	end

	self.WindowFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = self.WindowFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	self.WindowFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	local footerLabel = Instance.new("TextLabel")
	local footerStroke = Instance.new("UIStroke")

	footerLabel.Font = Enum.Font.GothamBold
	footerLabel.Text = config.Author
	footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	footerLabel.TextSize = 9
	footerLabel.TextTransparency = 0.5
	footerLabel.BackgroundTransparency = 1
	footerLabel.Position = UDim2.new(-0.0017, 0, 0.9841, -15)
	footerLabel.Size = UDim2.new(1.0017, 0, 0.0123, 15)
	footerLabel.Parent = self.WindowFrame

	footerStroke.Color = Color3.fromRGB(255, 255, 255)
	footerStroke.Thickness = 0.1
	footerStroke.Parent = footerLabel

	return self
end

function Lunar:CreateToggle(config)
	if config == nil or config.Title == nil then
		warn("CreateToggle: No Config or required Info")
		return
	end

	local TI = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local Colours = {
		Off = Color3.fromRGB(245, 245, 245),
		On = Color3.fromRGB(0, 255, 50)
	}

	local button = Instance.new("TextButton")
	button.Font = Enum.Font.GothamBold
	button.Text = config.Title or "Toggle"
	button.TextColor3 = Colours.Off
	button.TextSize = 9
	button.AutoButtonColor = false
	button.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	button.Size = UDim2.new(1, -24, 0, 36)
	button.Parent = self.ElementHolder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.9
	stroke.Thickness = 1
	stroke.Parent = button

	local OffTween = TS:Create(button, TI, {TextColor3 = Colours.Off})
	local OnTween = TS:Create(button, TI, {TextColor3 = Colours.On})

	local toggled = false

	button.MouseEnter:Connect(function()
		TS:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.5, Color = Color3.fromRGB(233, 255, 233)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TS:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.9, Color = Color3.fromRGB(255, 255, 255)}):Play()
	end)

	button.MouseButton1Down:Connect(function()
		TS:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -28, 0, 32), BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
	end)
	button.MouseButton1Up:Connect(function()
		TS:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -24, 0, 36), BackgroundColor3 = Color3.fromRGB(24, 24, 28)}):Play()
	end)

	button.Activated:Connect(function()
		toggled = not toggled
		if toggled then
			button.Text = config.Title .. ": ON"
			OnTween:Play()
		else
			button.Text = config.Title
			OffTween:Play()
		end

		if config.Callback and typeof(config.Callback) == "function" then
			config.Callback(toggled)
		end
	end)
end

return Lunar

