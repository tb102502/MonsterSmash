local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local StartButton = PlayerGui:WaitForChild("StartBossFight"):WaitForChild("StartDracFightButton")

local StartDracFightEvent = ReplicatedStorage:WaitForChild("StartDracFightEvent") -- Replace with your actual RemoteEvent

-- Add a flag so the button only shows once
local buttonShownOnce = false

StartDracFightEvent.OnClientEvent:Connect(function()
	if not buttonShownOnce then
		StartButton.Visible = true
		buttonShownOnce = true

		StartButton.MouseButton1Click:Connect(function()
			StartButton.Visible = false
			-- Fire the RemoteEvent to actually start the fight
			ReplicatedStorage:WaitForChild("StartDracFightEvent"):FireServer()
		end)
	end
end)
