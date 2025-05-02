local CrankyBossController = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local BossFaceTarget = Workspace:WaitForChild("BossFaceTarget")
local BossSpawn = Workspace:WaitForChild("BossSpawn")
local BossesFolder = ReplicatedStorage:WaitForChild("Bosses")

local CrankyCinematicHandler = require(ServerScriptService.CinematicHandlers:WaitForChild("CrankyCinematicHandler"))
local CrankyDamageHandler = require(ServerScriptService.DamageHandlers:WaitForChild("CrankyDamageHandler"))

local BossTaunt = ReplicatedStorage:WaitForChild("BossTaunt")

local activeBoss = nil
local currentRound = 0
local fightActive = false
local MAX_ROUNDS = 5

-- RemoteEvents
local StartCinematicCamera = ReplicatedStorage:WaitForChild("StartCinematicCamera")
local StartLockMovement = ReplicatedStorage:WaitForChild("StartLockMovement")
local StopLockMovement = ReplicatedStorage:WaitForChild("StopLockMovement")

function CrankyBossController.IsFightActive()
	return fightActive
end

function CrankyBossController.GetCurrentRound()
	return currentRound
end

local function fireTauntToAllPlayers(message)
	for _, player in ipairs(Players:GetPlayers()) do
		BossTaunt:FireClient(player, message)
	end
end

local function tryTaunt(boss, tauntName)
	local tauntFolder = boss:FindFirstChild("Taunts")
	if tauntFolder then
		local taunt = tauntFolder:FindFirstChild(tauntName)
		if taunt and taunt:IsA("StringValue") and taunt.Value ~= "" then
			fireTauntToAllPlayers(taunt.Value)
		end
	end
end

function CrankyBossController.StartRound(player)
	if fightActive then return end
	fightActive = true
	currentRound += 1

	if currentRound > MAX_ROUNDS then
		print("All rounds completed!")
		fightActive = false
		currentRound = 0
		return
	end

	local bossTemplate = BossesFolder:FindFirstChild("Cranky")
	if not bossTemplate then
		warn("Cranky not found in ReplicatedStorage.Bosses")
		return
	end

	activeBoss = bossTemplate:Clone()
	activeBoss.Name = "Cranky"
	activeBoss.Parent = Workspace

	if not activeBoss.PrimaryPart then
		warn("Boss has no PrimaryPart set")
		return
	end

	local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not playerRoot then
		warn("Player has no HumanoidRootPart")
		return
	end

	local offsetY = 5
	local bossPosition = BossSpawn.Position + Vector3.new(0, offsetY, 0)
	local facingCFrame = CFrame.new(bossPosition, BossFaceTarget.Position)
	activeBoss:SetPrimaryPartCFrame(facingCFrame)

	-- Set active boss AFTER position is set
	CrankyDamageHandler.SetActiveBoss(activeBoss)

	local baseHealth = 100
	local baseDamage = 10
	local scaledHealth = baseHealth * currentRound
	local scaledDamage = baseDamage * currentRound

	local humanoid = activeBoss:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.MaxHealth = scaledHealth
		humanoid.Health = scaledHealth

		humanoid.HealthChanged:Connect(function(health)
			if health <= (scaledHealth / 2) and health > 0 then
				tryTaunt(activeBoss, "LowHealth")
			end
		end)

		humanoid.Died:Connect(function()
			tryTaunt(activeBoss, "Death")

			local explosion = Instance.new("Explosion")
			explosion.Position = activeBoss.PrimaryPart.Position
			explosion.BlastRadius = 10
			explosion.BlastPressure = 5
			explosion.Parent = workspace
		end)
	end

	print("Begin round", currentRound, "against", activeBoss.Name)

	tryTaunt(activeBoss, "Intro")

	CrankyCinematicHandler.PlayBossIntro(
		player,
		activeBoss.Name,
		"Interests: Sleeping, Electricity, Cereal",
		currentRound
	)
end

function CrankyBossController.OnBossDefeated(player)
	print("Boss defeated in round", currentRound)
	wait(2)
	fightActive = false
	CrankyBossController.StartRound(player)
end

return CrankyBossController
