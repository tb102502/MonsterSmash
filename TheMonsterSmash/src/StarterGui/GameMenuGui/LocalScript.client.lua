local menu = script.Parent:WaitForChild("Frame") -- Main menu
local settingsMenu = script.Parent:WaitForChild("SettingsFrame") -- Settings menu
local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")

-- Hide menus initially
menu.Visible = false
settingsMenu.Visible = false

-- Function to toggle main menu visibility
local function toggleMenu()
	menu.Visible = not menu.Visible
	settingsMenu.Visible = false -- Hide settings when opening main menu
end

-- Detect when 'M' is pressed to open/close menu
userInput.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		toggleMenu()
	end
end)

-- Play Button Function
menu.ResumeButton.MouseButton1Click:Connect(function()
	menu.Visible = false -- Hide menu when Play is clicked
end)

-- Quit Button Function
menu.QuitButton.MouseButton1Click:Connect(function()
	player:Kick("You have left the game.") -- Kicks the player
end)

-- Settings Button Function (Opens Settings Menu)
menu.SettingsButton.MouseButton1Click:Connect(function()
	settingsMenu.Visible = true
	menu.Visible = false -- Hide main menu
end)

-- Close Button in Settings (Returns to Main Menu)
settingsMenu.CloseButton.MouseButton1Click:Connect(function()
	settingsMenu.Visible = false
	menu.Visible = true
end)

local settingsMenu = script.Parent:WaitForChild("SettingsFrame")
local player = game.Players.LocalPlayer
local settingsFolder = player:WaitForChild("Settings")

local sliders = {
	Volume = settingsMenu:WaitForChild("VolumeSlider"),
	Graphics = settingsMenu:WaitForChild("GraphicsSlider"),
	Sensitivity = settingsMenu:WaitForChild("SensitivitySlider")
}

local function updateSlider(slider, value)
	local fillBar = slider:FindFirstChild("FillBar")
	local handle = slider:FindFirstChild("Handle")

	if fillBar and handle then
		fillBar.Size = UDim2.new(value / 100, 0, 1, 0)
		handle.Position = UDim2.new(value / 100, -5, 0.5, -5)
	end
end

local function setupSlider(slider, settingName)
	local handle = slider:FindFirstChild("Handle")
	local fillBar = slider:FindFirstChild("FillBar")

	if handle and fillBar then
		local dragging = false

		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
			end
		end)

		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mouseX = input.Position.X
				local sliderPosition = slider.AbsolutePosition.X
				local sliderWidth = slider.AbsoluteSize.X

				local percent = math.clamp((mouseX - sliderPosition) / sliderWidth, 0, 1)
				local newValue = math.floor(percent * 100)

				updateSlider(slider, newValue)

				-- Update player's setting value
				if settingsFolder:FindFirstChild(settingName) then
					settingsFolder[settingName].Value = newValue
				end

				-- Apply changes in real-time
				if settingName == "Volume" then
					game:GetService("SoundService").Volume = newValue / 100
				elseif settingName == "Graphics" then
					game:GetService("Lighting").GlobalShadows = newValue > 50
				elseif settingName == "Sensitivity" then
					game:GetService("UserInputService").MouseDeltaSensitivity = newValue / 100
				end
			end
		end)
	end
end

-- Initialize sliders with saved values
for setting, slider in pairs(sliders) do
	local savedValue = settingsFolder:FindFirstChild(setting) and settingsFolder[setting].Value or 50
	setupSlider(slider, setting)
	updateSlider(slider, savedValue)
end
