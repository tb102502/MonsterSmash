local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local StartButton = PlayerGui:WaitForChild("StartBossFight"):WaitForChild("StartCrankyFightButton")

local StartCrankyFightEvent = ReplicatedStorage:WaitForChild("StartCrankyFightEvent") -- Replace with your actual RemoteEvent

-- Add a flag so the button only shows once
local buttonShownOnce = false

StartCrankyFightEvent.OnClientEvent:Connect(function()
	if not buttonShownOnce then
		StartButton.Visible = true
		buttonShownOnce = true

		StartButton.MouseButton1Click:Connect(function()
			StartButton.Visible = false
			-- Fire the RemoteEvent to actually start the fight
			ReplicatedStorage:WaitForChild("StartCrankyFightEvent"):FireServer()
		end)
	end
end)
