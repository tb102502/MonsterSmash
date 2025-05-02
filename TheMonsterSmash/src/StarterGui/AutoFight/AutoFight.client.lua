-- AutoFightToggleScript (LocalScript inside AutoFight ScreenGui)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local autoFightGui = script.Parent
local button = autoFightGui:WaitForChild("AutoFight")

local ToggleAutoFight = ReplicatedStorage:WaitForChild("ToggleAutoFight") -- RemoteEvent

local autoEnabled = false

local function updateButtonText()
	button.Text = autoEnabled and "Auto-Fight: ON" or "Auto-Fight: OFF"
end

button.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled
	updateButtonText()
	ToggleAutoFight:FireServer(autoEnabled)
end)

-- Set initial button text
updateButtonText()
