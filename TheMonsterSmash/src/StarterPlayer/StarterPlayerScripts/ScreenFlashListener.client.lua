local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Create overlay GUI
local flashGui = Instance.new("ScreenGui")
flashGui.Name = "FlashGui"
flashGui.IgnoreGuiInset = true
flashGui.ResetOnSpawn = false
flashGui.Parent = PlayerGui

local flashFrame = Instance.new("Frame")
flashFrame.BackgroundColor3 = Color3.new(1, 1, 1)
flashFrame.Size = UDim2.new(1, 0, 1, 0)
flashFrame.BackgroundTransparency = 1
flashFrame.BorderSizePixel = 0
flashFrame.Parent = flashGui

-- Screen shake function
local function screenShake(intensity, duration)
	local camera = workspace.CurrentCamera
	local original = camera.CFrame
	for i = 1, duration do
		camera.CFrame = original * CFrame.new(
			math.random(-1, 1) * intensity,
			math.random(-1, 1) * intensity,
			math.random(-1, 1) * intensity
		)
		task.wait(0.02)
	end
	camera.CFrame = original
end

-- Listen for flash trigger
local flashEvent = ReplicatedStorage:WaitForChild("ScreenFlashEvent")
flashEvent.OnClientEvent:Connect(function()
	print("⚡ ScreenFlashEvent received!")
	flashFrame.BackgroundTransparency = 0

	local tween = TweenService:Create(
		flashFrame,
		TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 1 }
	)
	tween:Play()

	screenShake(0.2, 5)
end)
