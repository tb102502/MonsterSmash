-- ServerScriptService/BossController.lua

local BossController = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local BossFactory = require(script.Parent:WaitForChild("BossFactory"))
local BossConfig = require(ReplicatedStorage:WaitForChild("BossConfig"))
local BossTaunt = ReplicatedStorage:WaitForChild("BossTaunt")
local BossDamageHandler = require(ServerScriptService.BossSystems.BossDamageHandler)
local BossAttackHandler = require(ServerScriptService.BossSystems.BossAttackHandler)

local CameraFXRemote = ReplicatedStorage:WaitForChild("CameraFXRemote")
local ShowBossStats = ReplicatedStorage:WaitForChild("ShowBossStats")

local currentRound = 0
local fightActive = false


function BossController.GetCurrentRound()
	return currentRound
end

function BossController.IsFightActive()
	return fightActive
end

function BossController.IncrementRound()
	currentRound += 1
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

function BossController.StartSpecificBoss(player)
	if fightActive then return end
	fightActive = true
	currentRound += 1

	local MAX_ROUNDS = 5
	if currentRound > MAX_ROUNDS then
		print("✅ All rounds completed!")
		fightActive = false
		currentRound = 0
		return
	end

	local bossName = "Cranky" -- 🧠 Always Cranky
	local config = BossConfig[bossName]
	if not config then
		warn("❌ Boss config not found:", bossName)
		fightActive = false
		return
	end

	print(`📦 Spawning boss: {bossName} | Round: {currentRound}`)

	local bossBundle = BossFactory.newBoss(bossName, currentRound)
	local boss = bossBundle.Model
	local humanoid = bossBundle.Humanoid
	local scaledHealth = bossBundle.Health
	local scaledDamage = bossBundle.Damage
	local attackInterval = bossBundle.AttackInterval

	local ShowBossStats = ReplicatedStorage:WaitForChild("ShowBossStats")
	ShowBossStats:FireClient(player, {
		BossName = bossName,
		Round = "Phase " .. currentRound, -- ✅ changed from "Round"
		Health = scaledHealth,
		Damage = scaledDamage,
	})

	wait(2)

	if not boss or not humanoid then
		warn("❌ Failed to create boss")
		fightActive = false
		return
	end

	assert(boss.PrimaryPart, "❌ Boss is missing PrimaryPart!")

	humanoid.MaxHealth = scaledHealth
	humanoid.Health = scaledHealth

	humanoid.HealthChanged:Connect(function(health)
		CameraFXRemote:FireClient(player, "FlashScreen", Color3.fromRGB(255, 0, 0), 0.1)
		if health <= scaledHealth / 2 and health > 0 then
			tryTaunt(boss, "LowHealth")
		end
	end)

	humanoid.Died:Connect(function()
		tryTaunt(boss, "Death")
		fightActive = false

		local explosion = Instance.new("Explosion")
		explosion.Position = boss:GetPivot().Position
		explosion.BlastRadius = 8
		explosion.BlastPressure = 0
		explosion.DestroyJointRadiusPercent = 0
		explosion.Parent = workspace

		task.wait(2)
		boss:Destroy()

		if currentRound >= MAX_ROUNDS then
			print("🎉 Player beat all 5 rounds!")
			local spawn = workspace:FindFirstChild("SpawnLocation")
			if spawn then
				for _, p in ipairs(Players:GetPlayers()) do
					local char = p.Character
					local root = char and char:FindFirstChild("HumanoidRootPart")
					if root then
						root.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
					end
				end
			end
			currentRound = 0
		else
			-- 😈 Cranky laugh before respawn
			local laughSound = Instance.new("Sound")
			laughSound.SoundId = "rbxassetid://7854285068" -- 🔊 Replace with your laugh asset if desired
			laughSound.Volume = 1
			laughSound.PlayOnRemove = true
			laughSound.Parent = workspace
			laughSound:Destroy() -- This will trigger PlayOnRemove

			wait(3) -- ⏳ small pause before new phase
			BossController.StartSpecificBoss(player)
		end

	end)

	BossDamageHandler.SetActiveBoss(boss, scaledDamage)
	BossAttackHandler.SetAttackInterval(attackInterval)

	if boss:FindFirstChild("AttackAnimationId") then
		local animId = boss.AttackAnimationId.Value
		BossAttackHandler.SetAttackAnimation(animId)
	end

	tryTaunt(boss, "Intro")

	config.CinematicHandler.PlayBossIntro(
		player,
		bossName,
		config.Interest,
		currentRound,
		config.SpawnPart.Position + Vector3.new(0, 10, 0),
		scaledHealth,
		scaledDamage
	)
end


return BossController
