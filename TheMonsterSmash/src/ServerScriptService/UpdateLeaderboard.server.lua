local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local updateEvent = Instance.new("RemoteEvent")
updateEvent.Name = "UpdateLeaderboard"
updateEvent.Parent = ReplicatedStorage

local function GetTopPlayers(stat)
	local data = {}

	-- Gather stats
	for _, player in pairs(Players:GetPlayers()) do
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats and leaderstats:FindFirstChild(stat) then
			table.insert(data, { Name = player.Name, Value = leaderstats[stat].Value })
		end
	end

	-- Sort players (Highest First)
	table.sort(data, function(a, b)
		return a.Value > b.Value
	end)

	-- Keep only top 10 players
	local topPlayers = {}
	for i = 1, math.min(10, #data) do
		table.insert(topPlayers, data[i])
	end

	return topPlayers
end

-- Update leaderboard when requested
updateEvent.OnServerEvent:Connect(function(player, stat)
	if stat == "Clicks" or stat == "BossesDefeated" or stat == "Coins" then
		updateEvent:FireClient(player, GetTopPlayers(stat))
	end
end)

-- Refresh leaderboard every 10 seconds (optional)
while true do
	for _, stat in pairs({"Clicks", "BossesDefeated", "Coins"}) do
		updateEvent:FireAllClients(GetTopPlayers(stat))
	end
	wait(10)
end
