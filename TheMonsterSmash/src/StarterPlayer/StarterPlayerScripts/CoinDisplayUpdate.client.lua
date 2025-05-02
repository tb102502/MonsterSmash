local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local coins = leaderstats:WaitForChild("Coins")

-- Function to update coins display
local function updateCoinsDisplay()
end

-- Connect coins change event
coins.Changed:Connect(updateCoinsDisplay)

-- Initial display update
updateCoinsDisplay()

