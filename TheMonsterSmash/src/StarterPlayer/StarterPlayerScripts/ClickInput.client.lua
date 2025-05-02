local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local ClickEvent = ReplicatedStorage:WaitForChild("ClickEvent")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		ClickEvent:FireServer()
	end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local BossDamageEvent = ReplicatedStorage:WaitForChild("BossDamageEvent")

-- Replace this with your actual click handler
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, isProcessed)
	if isProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		-- Send damage request to server
		BossDamageEvent:FireServer(10) -- Example: deal 10 damage
	end
end)
