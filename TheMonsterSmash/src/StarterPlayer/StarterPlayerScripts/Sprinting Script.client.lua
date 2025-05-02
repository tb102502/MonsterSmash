local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local defaultSpeed = humanoid.WalkSpeed  -- Normal walking speed
local sprintSpeed = defaultSpeed * 2     -- Running speed (adjust as needed)

local userInput = game:GetService("UserInputService")

userInput.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = sprintSpeed  -- Double speed when Shift is held
	end
end)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local defaultSpeed = humanoid.WalkSpeed
local sprintSpeed = defaultSpeed * 2  -- Adjust speed as needed

-- Create the UI Button
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local sprintButton = Instance.new("TextButton")
sprintButton.Size = UDim2.new(0.10, 0, 0.1, 0) -- Adjust size
sprintButton.Position = UDim2.new(0.1, 0, 0.8, 0) -- Adjust position
sprintButton.Text = "Sprint"
sprintButton.TextScaled = true
sprintButton.BackgroundColor3 = Color3.fromRGB(111, 118, 255)
sprintButton.Parent = screenGui

-- Sprint when button is pressed
sprintButton.MouseButton1Down:Connect(function()
	humanoid.WalkSpeed = sprintSpeed
end)

-- Reset speed when button is released
sprintButton.MouseButton1Up:Connect(function()
	humanoid.WalkSpeed = defaultSpeed
end)
