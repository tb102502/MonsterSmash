-- ServerScriptService | XPLevelSystem.server.lua
local Players = game:GetService("Players")

-- Define XP Level Tiers
local XP_LEVELS = {
	{Level = 1, XP = 0},
	{Level = 2, XP = 100},
	{Level = 3, XP = 250},
	{Level = 4, XP = 500},
	{Level = 5, XP = 1000}
}

local function getLevel(xp)
	local lvl = 1
	for _, tier in ipairs(XP_LEVELS) do
		if xp >= tier.XP then
			lvl = tier.Level
		end
	end
	return lvl
end

local function applyLevel(player, level)
	local current = player:GetAttribute("XP_Level") or 1
	if level > current then
		player:SetAttribute("XP_Level", level)
		print("LEVEL UP! Player:", player.Name, "to Level:", level)
		-- Unlock logic here (abilities, access, effects)
	end
end

Players.PlayerAdded:Connect(function(player)
	local stats = player:WaitForChild("leaderstats")
	local xp = stats:WaitForChild("XP")

	xp:GetPropertyChangedSignal("Value"):Connect(function()
		local lvl = getLevel(xp.Value)
		applyLevel(player, lvl)
	end)
end)
