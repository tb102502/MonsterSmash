-- ServerScriptService/DataStoreService.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LoadManager = require(game.ServerScriptService:WaitForChild("LoadManager"))
local SaveManager = require(game.ServerScriptService:WaitForChild("SaveManager"))

-- Constants
local AUTOSAVE_INTERVAL = 60

-- Player Join
Players.PlayerAdded:Connect(function(player)
	-- Leaderstats Setup
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- XP
	local xp = Instance.new("IntValue")
	xp.Name = "XP"
	xp.Value = LoadManager.Load(player, "XPData", "XP", 0)
	xp.Parent = leaderstats

	-- Coins
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = LoadManager.Load(player, "CoinData", "Coins", 0)
	coins.Parent = leaderstats

	-- Auto-queue changes
	xp.Changed:Connect(function(val)
		SaveManager.Queue(player, "XPData", "XP", val)
	end)
	coins.Changed:Connect(function(val)
		SaveManager.Queue(player, "CoinData", "Coins", val)
	end)

	-- Other stats (static or upgrade-derived)
	local defaults = {
		Clicks = 0,
		CoinMultiplier = 1,
		ClickSpeed = 1,
		WalkSpeed = 16,
		Health = 50,
		HealthRegen = 0,
		Damage = LoadManager.Load(player, "UpgradeData", "Damage", 5),
		Rebirths = 0,
	}

	for name, value in pairs(defaults) do
		local stat = Instance.new("IntValue")
		stat.Name = name
		stat.Value = value
		stat.Parent = leaderstats
	end

	-- UpgradeLevels Setup (NEW!)
	local upgradeLevels = Instance.new("Folder")
	upgradeLevels.Name = "UpgradeLevels"
	upgradeLevels.Parent = player

	-- Upgrade stats to track
	local upgradeStats = { "Health", "Damage", "WalkSpeed", "ClickSpeed", "HealthRegen", "CoinMultiplier" }

	for _, upgradeName in ipairs(upgradeStats) do
		local level = Instance.new("IntValue")
		level.Name = upgradeName .. "Level"
		level.Value = LoadManager.Load(player, "UpgradeData", upgradeName .. "Level", 0)
		level.Parent = upgradeLevels

		-- Auto-queue save when upgraded
		level.Changed:Connect(function(val)
			SaveManager.Queue(player, "UpgradeData", upgradeName .. "Level", val)
		end)
	end

	-- 🔁 Autosave loop
	task.spawn(function()
		while player:IsDescendantOf(Players) do
			task.wait(AUTOSAVE_INTERVAL)

			-- Fire GUI icon for feedback
			local iconEvent = ReplicatedStorage:FindFirstChild("SavedIconEvent")
				or Instance.new("RemoteEvent", ReplicatedStorage)
			iconEvent.Name = "SavedIconEvent"
			iconEvent:FireClient(player)

			-- Flush queued saves
			SaveManager.FlushPlayer(player)
		end
	end)
end)

-- Save on leave
Players.PlayerRemoving:Connect(function(player)
	SaveManager.FlushPlayer(player)
end)
