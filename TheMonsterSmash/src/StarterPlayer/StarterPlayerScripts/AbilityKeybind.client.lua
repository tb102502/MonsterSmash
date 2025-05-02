-- StarterPlayerScripts | AbilityKeybind.client.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("AbilityTrigger")
local canUse = true
local cooldown = 10

-- Optional UI
local screen = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screen.Name = "AbilityHint"

local label = Instance.new("TextLabel", screen)
label.Size = UDim2.new(0.2, 0, 0.05, 0)
label.Position = UDim2.new(0.4, 0, 0.85, 0)
label.Text = "[F] Power Slam (Level 3+)"
label.TextScaled = true
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 100)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F and canUse then
		canUse = false
		remote:FireServer("PowerSlam")
		for i = cooldown, 1, -1 do
			label.Text = "[F] Power Slam (" .. i .. "s)"
			task.wait(1)
		end
		label.Text = "[F] Power Slam (Level 3+)"
		canUse = true
	end
end)

