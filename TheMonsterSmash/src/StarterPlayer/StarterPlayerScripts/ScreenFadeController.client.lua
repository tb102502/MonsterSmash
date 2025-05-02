-- StarterPlayerScripts > ScreenFadeController (LocalScript)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local fadeEvent = ReplicatedStorage:WaitForChild("ScreenFadeEvent")

-- Create FadeGui if it doesn’t exist
local gui = Instance.new("ScreenGui")
gui.Name = "FadeGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "FadeFrame"
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.ZIndex = 999
frame.Parent = gui

-- Listen for fade events
fadeEvent.OnClientEvent:Connect(function(mode, duration)
	local targetTransparency = (mode == "Out") and 0 or 1
	TweenService:Create(frame, TweenInfo.new(duration), {
		BackgroundTransparency = targetTransparency
	}):Play()
end)
