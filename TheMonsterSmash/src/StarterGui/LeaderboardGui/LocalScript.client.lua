local ReplicatedStorage = game:GetService("ReplicatedStorage")

local leaderboardFrame = script.Parent:WaitForChild("LeaderboardFrame")
local leaderboardList = leaderboardFrame:WaitForChild("LeaderboardList")
local template = leaderboardList:WaitForChild("Template")

local clicksButton = leaderboardFrame:WaitForChild("ClicksButton")
local bossesButton = leaderboardFrame:WaitForChild("BossesButton")
local coinsButton = leaderboardFrame:WaitForChild("CoinsButton")

local updateEvent = ReplicatedStorage:WaitForChild("UpdateLeaderboard")
local currentStat = "Clicks" -- Default stat

-- Function to update the leaderboard
local function UpdateLeaderboard(data)
	-- Clear previous leaderboard
	for _, child in pairs(leaderboardList:GetChildren()) do
		if child:IsA("TextLabel") and child ~= template then
			child:Destroy()
		end
	end

	-- Populate new leaderboard
	for rank, entry in ipairs(data) do
		local newEntry = template:Clone()
		newEntry.Text = rank .. ". " .. entry.Name .. " - " .. entry.Value
		newEntry.Visible = true
		newEntry.Parent = leaderboardList
	end
end

-- Request leaderboard update when switching stats
clicksButton.MouseButton1Click:Connect(function()
	currentStat = "Clicks"
	updateEvent:FireServer(currentStat)
end)

bossesButton.MouseButton1Click:Connect(function()
	currentStat = "BossesDefeated"
	updateEvent:FireServer(currentStat)
end)

coinsButton.MouseButton1Click:Connect(function()
	currentStat = "Coins"
	updateEvent:FireServer(currentStat)
end)

-- Listen for leaderboard updates
updateEvent.OnClientEvent:Connect(UpdateLeaderboard)

-- Request default leaderboard on start
updateEvent:FireServer(currentStat)
