-- ServerScriptService | XPUpgradeShop.server.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local XPShopRemote = Instance.new("RemoteFunction", ReplicatedStorage)
XPShopRemote.Name = "XPShopRequest"

-- Upgrade Costs
local Upgrades = {
	Strength = {Cost = 50, Increment = 5},
	Health = {Cost = 75, Increment = 25},
	Speed = {Cost = 60, Increment = 1},
}

local function grantUpgrade(player, upgrade)
	local stats = player:FindFirstChild("leaderstats")
	local xp = stats and stats:FindFirstChild("XP")
	if not xp then return false, "No XP available" end

	local config = Upgrades[upgrade]
	if not config then return false, "Upgrade not found" end
	if xp.Value < config.Cost then return false, "Not enough XP" end

	xp.Value -= config.Cost
	local attrName = "Upgrade_" .. upgrade
	local current = player:GetAttribute(attrName) or 0
	player:SetAttribute(attrName, current + config.Increment)

	return true, "Upgraded " .. upgrade .. "!"
end

XPShopRemote.OnServerInvoke = grantUpgrade
