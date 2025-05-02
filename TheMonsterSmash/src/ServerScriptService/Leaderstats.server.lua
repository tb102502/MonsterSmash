local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")


-- Initialize leaderstats for each player and set default values
players.PlayerAdded:Connect(function(player)
	-- Create leaderstats folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Initialize stats
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0  -- Initial coins
	coins.Parent = leaderstats
	
	-- Stat 1: Clicks
	local clicks = Instance.new("IntValue")
	clicks.Name = "Clicks"
	clicks.Value = 0 -- Default value
	clicks.Parent = leaderstats

	-- Stat 2: Bosses Defeated
	local bossesDefeated = Instance.new("IntValue")
	bossesDefeated.Name = "BossesDefeated"
	bossesDefeated.Value = 0
	bossesDefeated.Parent = leaderstats

	local clickMultiplier = Instance.new("IntValue")
	clickMultiplier.Name = "ClickMultiplier"
	clickMultiplier.Value = 0  -- Default ClickMultiplier
	clickMultiplier.Parent = leaderstats

	local clickSpeed = Instance.new("IntValue")
	clickSpeed.Name = "ClickSpeed"
	clickSpeed.Value = 1  -- Default click speed (in seconds)
	clickSpeed.Parent = leaderstats

	local walkSpeed = Instance.new("IntValue")
	walkSpeed.Name = "WalkSpeed"
	walkSpeed.Value = 16  -- Default walk speed
	walkSpeed.Parent = leaderstats

	local health = Instance.new("IntValue")
	health.Name = "Health"
	health.Value = 50-- Default MaxHealth
	health.Parent = leaderstats

	local healthRegen = Instance.new("IntValue")
	healthRegen.Name = "HealthRegen"
	healthRegen.Value = 1  -- Default HealthRegen
	healthRegen.Parent = leaderstats

		-- Store Base Damage
	local damage = Instance.new("IntValue")
	damage.Name = "Damage"
	damage.Value = 10 -- Starting damage
	damage.Parent = leaderstats
	
	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = 0
	rebirths.Parent = leaderstats
	

	--local weaponDamage = Instance.new("IntValue")
	--weaponDamage.Name = "WeaponDamage"
	--weaponDamage.Value = 10 -- No weapon equipped initially
	--weaponDamage.Parent = leaderstats
end)

