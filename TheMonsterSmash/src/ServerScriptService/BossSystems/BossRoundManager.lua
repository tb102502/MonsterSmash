-- BossRoundManager.lua (ModuleScript)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BossRoundManager = {}

local BossModel = workspace:WaitForChild("Boss") -- Change if needed
local Humanoid = BossModel:WaitForChild("Humanoid")

local RoundWinEvent = ReplicatedStorage:FindFirstChild("BossRoundWin")
if not RoundWinEvent then
	RoundWinEvent = Instance.new("RemoteEvent")
	RoundWinEvent.Name = "BossRoundWin"
	RoundWinEvent.Parent = ReplicatedStorage
end

-- Internal Bindable for Boss death
local BossDefeatedEvent = Instance.new("BindableEvent")

-- === Config ===
local MaxRounds = 5
local CurrentRound = 1

local baseHealth = 300
local baseDamage = 10
local healthPerRound = 150
local damagePerRound = 10

-- === Internal Functions ===

local function scaleBoss()
	local newHealth = baseHealth + (healthPerRound * (CurrentRound - 1))
	local newDamage = baseDamage + (damagePerRound * (CurrentRound - 1))

	Humanoid.MaxHealth = newHealth
	Humanoid.Health = newHealth

	BossModel:SetAttribute("AttackDamage", newDamage)
	print("⚔️ Boss scaled for round", CurrentRound, "- HP:", newHealth, "DMG:", newDamage)
end

local function onBossDefeated(player)
	if CurrentRound < MaxRounds then
		CurrentRound += 1
		scaleBoss()
		RoundWinEvent:FireClient(player, CurrentRound)
	else
		print("🏆 Player beat all 5 rounds!")
		RoundWinEvent:FireClient(player, "Victory")
	end
end

-- === External API ===

function BossRoundManager.Init()
	scaleBoss()

	Humanoid.Died:Connect(function()
		print("☠️ Boss defeated in round", CurrentRound)
		BossDefeatedEvent:Fire()
	end)
end

function BossRoundManager.OnDefeated(callback)
	-- Connect your own function to boss defeat
	BossDefeatedEvent.Event:Connect(callback)
end

function BossRoundManager.StartNextRound(player)
	print("⚡ StartNextRound called!")
	local CountdownEvent = game.ReplicatedStorage:WaitForChild("StartRoundCountdown")
	print("📡 Sending countdown to", player.Name)

	CountdownEvent:FireClient(player, 3) -- Countdown from 3

	onBossDefeated(player)
end

function BossRoundManager.GetRound()
	return CurrentRound
end

return BossRoundManager
