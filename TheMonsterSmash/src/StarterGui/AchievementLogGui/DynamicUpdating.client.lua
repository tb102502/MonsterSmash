local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


local logFrame = script.Parent:WaitForChild("LogFrame")
logFrame.Visible = false
local achievementList = logFrame:WaitForChild("AchievementList")
local template = achievementList:WaitForChild("Template")
local closeButton = logFrame:WaitForChild("CloseButton")

local achievements = {
	{Name = "Click Apprentice", Desc = "Reached 1,000 Clicks!", Stat = "Clicks", Threshold = 1000},
	{Name = "Click Master", Desc = "Reached 10,000 Clicks!", Stat = "Clicks", Threshold = 10000},
	{Name = "Click Legend", Desc = "Reached 50,000 Clicks!", Stat = "Clicks", Threshold = 50000},
	{Name = "Boss Novice", Desc = "Defeated 5 Bosses!", Stat = "BossesDefeated", Threshold = 5},
	{Name = "Boss Slayer", Desc = "Defeated 20 Bosses!", Stat = "BossesDefeated", Threshold = 20},
	{Name = "Boss Conqueror", Desc = "Defeated 50 Bosses!", Stat = "BossesDefeated", Threshold = 50},
	{Name = "Rich Rookie", Desc = "Earned 1,000 Coins!", Stat = "Coins", Threshold = 1000},
	{Name = "Wealthy Warrior", Desc = "Earned 50,000 Coins!", Stat = "Coins", Threshold = 50000},
	{Name = "Coin Beast", Desc = "Earned 100,000 Coins!", Stat = "Coins", Threshold = 100000}
}

-- Function to update the Achievement Log
local function UpdateAchievementLog()
	for _, child in pairs(achievementList:GetChildren()) do
		if child:IsA("TextLabel") and child ~= template then
			child:Destroy()
		end
	end

	local player = Players.LocalPlayer
	local leaderstats = player:FindFirstChild("leaderstats")

	if leaderstats then
		for _, achievement in ipairs(achievements) do
			local stat = leaderstats:FindFirstChild(achievement.Stat)
			local unlocked = stat and stat.Value >= achievement.Threshold

			local newEntry = template:Clone()
			newEntry.Text = achievement.Name .. " - " .. (unlocked and "✅ Unlocked" or "❌ Locked")
			newEntry.TextColor3 = unlocked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
			newEntry.Visible = true
			newEntry.Parent = achievementList
		end
	end
end

-- Open/Close Log
logFrame.Visible = false
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local achievementLogGui = playerGui:WaitForChild("AchievementLogGui", 10) -- Wait up to 10 seconds
if not achievementLogGui then
	warn("AchievementLogGui not found!")
	return
end

local openButton = achievementLogGui:FindFirstChild("AchievementLogButton")
if not openButton then
	warn("AchievementLogButton not found!")
	return
end

openButton.MouseButton1Click:Connect(function()
	local logFrame = achievementLogGui:FindFirstChild("LogFrame")
	if logFrame then
		logFrame.Visible = not logFrame.Visible
	else
		warn("LogFrame not found!")
	end
end)


	UpdateAchievementLog()
	logFrame.Visible = true
closeButton.MouseButton1Click:Connect(function()
	logFrame.Visible = false
end)
