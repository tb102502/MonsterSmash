-- ServerScriptService/ShopServerScript.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local SaveManager = require(game.ServerScriptService:WaitForChild("SaveManager"))

-- RemoteEvents
local purchaseEvent = ReplicatedStorage:FindFirstChild("PurchaseUpgrade") or Instance.new("RemoteEvent")
purchaseEvent.Name = "PurchaseUpgrade"
purchaseEvent.Parent = ReplicatedStorage

local costUpdateEvent = ReplicatedStorage:FindFirstChild("UpgradeCostUpdate") or Instance.new("RemoteEvent")
costUpdateEvent.Name = "UpgradeCostUpdate"
costUpdateEvent.Parent = ReplicatedStorage

local feedbackEvent = ReplicatedStorage:FindFirstChild("UpgradeFeedback") or Instance.new("RemoteEvent")
feedbackEvent.Name = "UpgradeFeedback"
feedbackEvent.Parent = ReplicatedStorage

-- Config
local baseCosts = {
	Health = 100,
	Damage = 150,
	ClickSpeed = 250,
	WalkSpeed = 200,
	HealthRegen = 200,
	CoinMultiplier = 500
}
local costMultiplier = 1.5
local maxLevel = 25
local costCap = 9999999

-- Cost calculation
local function calculateCost(stat, level)
	local nextLevel = math.min(level + 1, maxLevel)
	local rawCost = baseCosts[stat] * (costMultiplier ^ nextLevel)
	return math.floor(math.min(rawCost, costCap))
end

-- Send cost on join
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()

	local upgrades = player:WaitForChild("UpgradeLevels")

	for stat, base in pairs(baseCosts) do
		local levelObj = upgrades:FindFirstChild(stat .. "Level")
		if levelObj then
			local cost = calculateCost(stat, levelObj.Value)
			costUpdateEvent:FireClient(player, stat, cost)
		end
	end
end)

-- Handle upgrade purchase
purchaseEvent.OnServerEvent:Connect(function(player, stat)
	local leaderstats = player:FindFirstChild("leaderstats")
	local upgrades = player:FindFirstChild("UpgradeLevels")

	if not (leaderstats and upgrades) then return end

	local coins = leaderstats:FindFirstChild("Coins")
	local levelObj = upgrades:FindFirstChild(stat .. "Level")

	if not (coins and levelObj and baseCosts[stat]) then
		return
	end

	local level = levelObj.Value
	if level >= maxLevel then
		feedbackEvent:FireClient(player, stat, 0, level, true, coins.Value)
		return
	end

	local cost = calculateCost(stat, level)
	if coins.Value >= cost then
		-- ✅ Properly deduct coins
		coins.Value -= cost

		-- ✅ Properly upgrade the UpgradeLevel
		levelObj.Value += 1

		-- ✅ Try to upgrade the REAL Stat
		local statObj = leaderstats:FindFirstChild(stat)
		if statObj then
			local upgradeAmount = 0
			if stat == "Health" then upgradeAmount = 10 end
			if stat == "Damage" then upgradeAmount = 5 end
			if stat == "WalkSpeed" then upgradeAmount = 2 end
			if stat == "ClickSpeed" then upgradeAmount = 1 end
			if stat == "HealthRegen" then upgradeAmount = 2 end
			if stat == "CoinMultiplier" then upgradeAmount = 1 end

			statObj.Value += upgradeAmount
		else
			warn("⚠️ Stat", stat, "not found under leaderstats for", player.Name)
		end

		-- ✅ Save upgrade
		SaveManager.Queue(player, "UpgradeLevels", stat, levelObj.Value)

		-- ✅ Send feedback to client
		local newCost = calculateCost(stat, levelObj.Value)
		costUpdateEvent:FireClient(player, stat, newCost)
		feedbackEvent:FireClient(player, stat, newCost, levelObj.Value, levelObj.Value >= maxLevel, coins.Value, true)
	else
		-- Not enough coins
		feedbackEvent:FireClient(player, stat, cost, level, false, coins.Value, false)

		-- ✨ Sparkle FX on Head
		local character = player.Character or player.CharacterAdded:Wait()
		local effectsFolder = ReplicatedStorage:FindFirstChild("UpgradeEffects")
		local sparkleTemplate = effectsFolder and effectsFolder:FindFirstChild("UpgradeSparkle")

		if character and sparkleTemplate then
			local head = character:FindFirstChild("Head")
			if head then
				local attachment = Instance.new("Attachment")
				attachment.Position = Vector3.new(0, 1.5, 0)
				attachment.Parent = head

				local sparkle = sparkleTemplate:Clone()
				sparkle.Enabled = false
				sparkle.Parent = attachment
				sparkle:Emit(40)

				Debris:AddItem(attachment, 1.5)
			else
				warn("❌ Couldn't find Head for", player.Name)
			end
		else
			warn("❌ Missing character or UpgradeSparkle for", player.Name)
		end
	end
end)

-- Final save on leave
Players.PlayerRemoving:Connect(function(player)
	SaveManager.FlushPlayer(player)
end)
