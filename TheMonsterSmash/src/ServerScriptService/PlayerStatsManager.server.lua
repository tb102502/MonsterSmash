-- ServerScriptService/PlayerStatsManager.lua

local Players = game:GetService("Players")
local SaveManager = require(game.ServerScriptService:WaitForChild("SaveManager"))
local LoadManager = require(game.ServerScriptService:WaitForChild("LoadManager"))

-- Upgrade stat config
local upgradeTypes = {
	Health = { base = 50, perLevel = 5 },
	Damage = { base = 5, perLevel = 5 },
	ClickSpeed = { base = 1, perLevel = 1 },
	WalkSpeed = { base = 16, perLevel = 2 },
	HealthRegen = { base = 0, perLevel = 2 },
	CoinMultiplier = { base = 1, perLevel = 1 }
}

Players.PlayerAdded:Connect(function(player)
	-- leaderstats folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Load Coins and XP
	local coinsValue = LoadManager.Load(player, "CurrencyData", "Coins", 0)
	local xpValue = LoadManager.Load(player, "XPData", "XP", 0)

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = coinsValue
	coins.Parent = leaderstats

	local xp = Instance.new("IntValue")
	xp.Name = "XP"
	xp.Value = xpValue
	xp.Parent = leaderstats

	-- Track future changes
	coins.Changed:Connect(function(val)
		SaveManager.Queue(player, "CurrencyData", "Coins", val)
	end)

	xp.Changed:Connect(function(val)
		SaveManager.Queue(player, "XPData", "XP", val)
	end)

	-- Upgrade levels
	local upgradeFolder = Instance.new("Folder")
	upgradeFolder.Name = "UpgradeLevels"
	upgradeFolder.Parent = player

	for stat, config in pairs(upgradeTypes) do
		local savedLevel = LoadManager.Load(player, "UpgradeLevels", stat, 0)

		local level = Instance.new("IntValue")
		level.Name = stat .. "Level"
		level.Value = savedLevel
		level.Parent = upgradeFolder

		-- Derived stat
		local statValue = Instance.new("NumberValue")
		statValue.Name = stat
		statValue.Value = config.base + (savedLevel * config.perLevel)
		statValue.Parent = leaderstats

		level.Changed:Connect(function(newLevel)
			statValue.Value = config.base + (newLevel * config.perLevel)
			SaveManager.Queue(player, "UpgradeLevels", stat, newLevel)
		end)
	end
end)

-- Save on exit
Players.PlayerRemoving:Connect(function(player)
	SaveManager.FlushPlayer(player)
end)
