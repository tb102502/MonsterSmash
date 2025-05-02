local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a RemoteEvent to send achievements to the client
local achievementEvent = Instance.new("RemoteEvent")
achievementEvent.Name = "AchievementUnlocked"
achievementEvent.Parent = ReplicatedStorage

-- Define achievement milestones
local achievements = {
	Clicks = {
		{Threshold = 1000, Name = "Click Apprentice", Description = "Reached 1,000 Clicks!"},
		{Threshold = 10000, Name = "Click Master", Description = "Reached 10,000 Clicks!"},
		{Threshold = 50000, Name = "Click Legend", Description = "Reached 50,000 Clicks!"}
	},
	BossesDefeated = {
		{Threshold = 5, Name = "Boss Novice", Description = "Defeated 5 Bosses!"},
		{Threshold = 20, Name = "Boss Slayer", Description = "Defeated 20 Bosses!"},
		{Threshold = 50, Name = "Boss Conqueror", Description = "Defeated 50 Bosses!"}
	},
	Coins = {
		{Threshold = 1000, Name = "Rich Rookie", Description = "Earned 1,000 Coins!"},
		{Threshold = 50000, Name = "Wealthy Warrior", Description = "Earned 50,000 Coins!"},
		{Threshold = 100000, Name = "Coin Beast", Description = "Earned 100,000 Coins!"}
	}
}

-- Function to check and award achievements
local function CheckAchievements(player, statName, newValue)
	if achievements[statName] then
		for _, achievement in ipairs(achievements[statName]) do
			if newValue >= achievement.Threshold then
				achievementEvent:FireClient(player, achievement.Name, achievement.Description)
			end
		end
	end
end

-- Track stat changes and award achievements
Players.PlayerAdded:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	for statName, _ in pairs(achievements) do
		local stat = leaderstats:FindFirstChild(statName)
		if stat then
			stat.Changed:Connect(function(newValue)
				CheckAchievements(player, statName, newValue)
			end)
		end
	end
end)
