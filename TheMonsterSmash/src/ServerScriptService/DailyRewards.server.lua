local DataStoreService = game:GetService("DataStoreService")
local RewardDataStore = DataStoreService:GetDataStore("DailyRewards")

local REWARD_AMOUNT = 100 -- Change as needed
local REWARD_RESET_TIME = 86400 -- 24 hours in seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rewardEvent = ReplicatedStorage:WaitForChild("DailyRewardEvent")

game.Players.PlayerAdded:Connect(function(player)
	local playerUserId = player.UserId
	local success, lastClaimed = pcall(function()
		return RewardDataStore:GetAsync("LastClaim_" .. playerUserId)
	end)

	local currentTime = os.time()

	-- If the player has never claimed, or if 24 hours have passed
	if not success or not lastClaimed or (currentTime - lastClaimed >= REWARD_RESET_TIME) then
		rewardEvent:FireClient(player, REWARD_AMOUNT) -- Show the GUI pop-up
	end
end)

-- Handle reward claiming
rewardEvent.OnServerEvent:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			coins.Value = coins.Value + REWARD_AMOUNT
		end
	end

	-- Save the new claim time
	pcall(function()
		RewardDataStore:SetAsync("LastClaim_" .. player.UserId, os.time())
	end)
end)
