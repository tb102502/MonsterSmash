local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local ToggleBossFight = ReplicatedStorage:WaitForChild("ToggleBossFight")

local tapRemote = ReplicatedStorage:WaitForChild("TapBoss")

local bossFightActive = false -- Set this to true when boss fight begins

-- Optional: Listen to a RemoteEvent that enables/disables tapping
ReplicatedStorage:WaitForChild("ToggleBossFight").OnClientEvent:Connect(function(isActive)
	bossFightActive = isActive
end)

UserInputService.InputBegan:Connect(function(input, isProcessed)
	if isProcessed then return end
	if not bossFightActive then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tapRemote:FireServer()
	end

	ToggleBossFight.OnClientEvent:Connect(function(isActive)
		bossFightActive = isActive
		print("Boss fight active:", isActive)
	end)
end)
	-- You already have this somewhere in your InputBegan section:
	-- if bossFightActive then
	--     tapRemote:FireServer()
	-- en