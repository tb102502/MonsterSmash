
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local StartLockMovement = ReplicatedStorage:WaitForChild("StartLockMovement")
local StopLockMovement = ReplicatedStorage:WaitForChild("StopLockMovement")

local UserInputService = game:GetService("UserInputService")

local movementLocked = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if movementLocked and input.UserInputType == Enum.UserInputType.Keyboard then
		input:CaptureController()
	end
end)

StartLockMovement.OnClientEvent:Connect(function()
	movementLocked = true
	player.Character:WaitForChild("Humanoid").WalkSpeed = 0
	player.Character.Humanoid.JumpPower = 0
end)

StopLockMovement.OnClientEvent:Connect(function()
	movementLocked = false
	player.Character.Humanoid.WalkSpeed = 16
	player.Character.Humanoid.JumpPower = 50
end)
