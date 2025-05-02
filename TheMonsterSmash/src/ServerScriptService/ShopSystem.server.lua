-- ServerScriptService/UpgradeHandler.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local purchaseEvent = ReplicatedStorage:WaitForChild("PurchaseUpgrade")
local defaultUpgradeCosts = {
	Health = 100, Damage = 150, ClickSpeed = 200,
	WalkSpeed = 250, HealthRegen = 300, ClickMultiplier = 500
}
local upgradeEffects = {
	Health = 25, Damage = 5, ClickSpeed = 1,
	WalkSpeed = 2, HealthRegen = 1, ClickMultiplier = 1
}
local playerUpgrades = {}

local function setupPlayer(player)
	playerUpgrades[player] = { Costs = table.clone(defaultUpgradeCosts) }
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(function(player)
	playerUpgrades[player] = nil
end)

purchaseEvent.OnServerEvent:Connect(function(player, upgradeType)
	local DataStoreService = player:FindFirstChild("DataStoreService")
	local coins = DataStoreService and DataStoreService:FindFirstChild("Coins")
	if not coins or not upgradeEffects[upgradeType] then return end

	if not playerUpgrades[player] then setupPlayer(player) end
	local cost = playerUpgrades[player].Costs[upgradeType]
	if not cost then return end
	
	if coins.Value >= cost then
		coins.Value -= cost

		local char = player.Character
		local humanoid = char and char:FindFirstChild("Humanoid")
		if humanoid then
			if upgradeType == "Health" then
				humanoid.MaxHealth += upgradeEffects.Health
				humanoid.Health = humanoid.MaxHealth
			elseif upgradeType == "Damage" then
				player:SetAttribute("Damage", (player:GetAttribute("Damage") or 10) + upgradeEffects.Damage)
			elseif upgradeType == "ClickSpeed" then
				player:SetAttribute("ClickSpeed", (player:GetAttribute("ClickSpeed") or 1) + upgradeEffects.ClickSpeed)
			elseif upgradeType == "WalkSpeed" then
				humanoid.WalkSpeed += upgradeEffects.WalkSpeed
			elseif upgradeType == "HealthRegen" then
				player:SetAttribute("HealthRegen", (player:GetAttribute("HealthRegen") or 0) + upgradeEffects.HealthRegen)
			elseif upgradeType == "ClickMultiplier" then
				player:SetAttribute("ClickMultiplier", (player:GetAttribute("ClickMultiplier") or 1) + upgradeEffects.ClickMultiplier)
			end
		end

		-- After applying the upgrade...
		local newCost = playerUpgrades[player].Costs[upgradeType]
		local newValue = player:GetAttribute(upgradeType) or humanoid and humanoid[upgradeType] or "?"
		ReplicatedStorage:WaitForChild("UpgradeFeedback"):FireClient(player, upgradeType, newCost, newValue)

		print("✅ " .. player.Name .. " bought " .. upgradeType .. ". New cost: " .. playerUpgrades[player].Costs[upgradeType])
	else
		warn("❌ Not enough coins for " .. upgradeType)
	end
end)
