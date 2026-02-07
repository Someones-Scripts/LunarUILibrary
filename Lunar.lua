--this library is my first so dont judge
--this is in beta and follows MIT license
local Lunar = {}
local TS = game:GetService("TweenService")
Lunar.__index = Lunar

function Lunar:CreateWindow(config)
    if not config or not config.Title or not config.Author then
        warn("CreateWindow: Missing required config fields.")
        return
    end

    local self = setmetatable({}, Lunar)

    -- Create ScreenGui
    self.Window = Instance.new("ScreenGui")
    self.Window.Name = "Window"
    self.Window.ResetOnSpawn = false
    self.Window.Parent = game:GetService("Players").LocalPlayer.PlayerGui

    -- Create closing event
    local closingEvent = Instance.new("BindableEvent")
    self.Closing = {}
    function self.Closing:Connect(func)
        return closingEvent.Event:Connect(func)
    end

    -- Create WindowFrame
    self.WindowFrame = Instance.new("Frame")
    self.WindowFrame.Active = true
    self.WindowFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
    self.WindowFrame.BorderSizePixel = 0
    self.WindowFrame.Position = UDim2.new(0.4837, 0, 0.3533, 0)
    self.WindowFrame.Size = UDim2.new(0, 171, 0, 255)
    self.WindowFrame.Name = "WindowFrame"
    self.WindowFrame.Parent = self.Window

    -- Debug check for WindowFrame initialization
    if self.WindowFrame then
        print("WindowFrame successfully created.")
    else
        warn("WindowFrame is nil after creation.")
    end

    -- Rest of the code for adding UI elements...

    -- Add the close button logic
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(245, 245, 245)
    CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    CloseButton.Position = UDim2.new(0.85, 0, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    CloseButton.Parent = self.WindowFrame

    CloseButton.Activated:Connect(function()
        closingEvent:Fire()
        self.Window:Destroy()
    end)

    -- Check if everything is set up before returning
    if self.WindowFrame and self.ElementHolder then
        print("All elements initialized properly.")
    else
        warn("Some elements are not initialized correctly.")
    end

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

