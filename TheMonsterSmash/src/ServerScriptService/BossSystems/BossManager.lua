-- ServerScriptService/BossSystems/BossManager.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local BossConfigs = require(ServerScriptService.BossSystems.BossConfigs)
local BossDamageHandler = require(ServerScriptService.BossSystems.BossDamageHandler)

local BossManager = {}
local BossDefeatedEvent = Instance.new("BindableEvent")
BossManager.BossDefeated = BossDefeatedEvent.Event
BossManager.activeBoss = nil

function BossManager:IsFightActive()
	return self.activeBoss and self.activeBoss.Parent ~= nil
end

function BossManager:StartBossFight(bossName, round)
	-- ❄ Freeze players and auto-equip sword
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0

				local backpack = player:FindFirstChild("Backpack")
				if backpack then
					local sword = backpack:FindFirstChild("Sword")
					if sword then
						sword.Parent = player.Character
					end
				end
			end
		end
	end

	local config = BossConfigs[bossName]
	if not config then warn("⚠️ Invalid boss:", bossName) return end
	if self:IsFightActive() then warn("⚠️ Fight already running!") return end

	-- 🧟 Spawn Boss
	local boss = config.Model:Clone()
	boss.Parent = Workspace:WaitForChild("BossArena")

	-- ⚙ Correct spawn position based on round
	local pos
	if round == 1 then
		pos = config.SpawnPosition -- First cinematic table position
	else
		local arenaCenter = Workspace:FindFirstChild("BossArena") and Workspace.BossArena:FindFirstChild("ArenaCenter")
		if arenaCenter then
			pos = arenaCenter.Position + Vector3.new(10, 8, 0) -- Move 4.5 studs up and shift 4 left

		else
			warn("⚠️ ArenaCenter not found. Using (0,5,0)")
			pos = Vector3.new(0, 5, 0)
		end
	end

	local uprightCFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(180), 0)
	boss:SetPrimaryPartCFrame(uprightCFrame)

	-- 📈 Set attributes
	local hp = config.BaseHP * (1.5 ^ (round - 1))
	local dmg = config.BaseDamage * (1.25 ^ (round - 1))
	boss:SetAttribute("HP", hp)
	boss:SetAttribute("Damage", dmg)
	boss:SetAttribute("Round", round)
	boss:SetAttribute("BossName", bossName)
	self.activeBoss = boss

	BossDamageHandler.SetActiveBoss(boss, dmg)

	-- 🎬 Play Intro
	if config.Sounds and config.Sounds.Intro then
		local introSound = Instance.new("Sound", boss.PrimaryPart)
		introSound.SoundId = config.Sounds.Intro
		introSound:Play()
	end
	if config.Intro then config.Intro(Players:GetPlayers()[1], bossName, nil, round, boss) end
	if config.Animate then config.Animate(boss) end
	if config.Taunt then config.Taunt(boss) end

	-- 🎯 Boss Attack Loop
	task.delay(6, function()
		print("🌀 Boss attack loop starting")
		while boss and boss.Parent do
			local humanoid = boss:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then break end

			local players = Players:GetPlayers()
			if #players == 0 then
				warn("⚠️ No players left!")
				break
			end

			local player = players[math.random(1, #players)]
			local target = player and player.Character
			local targetHumanoid = target and target:FindFirstChildOfClass("Humanoid")

			if target and targetHumanoid and targetHumanoid.Health > 0 then
				local root = target:FindFirstChild("HumanoidRootPart")
				if root and (boss.PrimaryPart.Position - root.Position).Magnitude <= 80 then
					local attacks = config.Attacks
					if attacks and #attacks > 0 then
						local attack = attacks[math.random(1, #attacks)]
						if attack and attack.Perform then
							print("🎯 Boss uses:", attack.Name)
							attack.Perform(boss, config.BaseDamage, player)

							-- 🎞 Play attack animation
							if attack.AnimationId then
								local animator = humanoid:FindFirstChildOfClass("Animator")
								if animator then
									local anim = Instance.new("Animation")
									anim.AnimationId = attack.AnimationId
									local track = animator:LoadAnimation(anim)
									track.Looped = false
									track:Play()
									track.Stopped:Wait()
									track:Destroy()
								end
							end
						else
							warn("⚠️ Attack missing Perform!", attack and attack.Name)
						end
					end
				end
			end

			task.wait(config.AttackDelay or 2)
		end

		-- 💀 Boss Defeated
		local humanoid = boss:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			-- 🎶 Death Sound
			if config.Sounds and config.Sounds.Death then
				local deathSound = Instance.new("Sound", boss.PrimaryPart)
				deathSound.SoundId = config.Sounds.Death
				deathSound:Play()
			end

			if config.Loot then config.Loot(boss) end
			if config.RoundEnd then config.RoundEnd(boss) end
			BossDefeatedEvent:Fire(bossName, round)

			boss:Destroy()
			self.activeBoss = nil

			-- 🔥 Always unfreeze players now!
			for _, player in ipairs(Players:GetPlayers()) do
				local char = player.Character
				if char then
					local humanoid = char:FindFirstChildWhichIsA("Humanoid")
					if humanoid then
						humanoid.WalkSpeed = 16
						humanoid.JumpPower = 50
					end
				end
			end

			-- 🏆 Final reward if final round
			if round >= 5 then
				print("🎁 Final round completed! Spawning chest...")

				local chest = Instance.new("Model")
				chest.Name = "RewardChest"
				chest.Parent = Workspace

				local base = Instance.new("Part")
				base.Name = "ChestBase"
				base.Size = Vector3.new(4,2,4)
				base.Anchored = true
				base.Material = Enum.Material.Wood
				base.Color = Color3.fromRGB(139,69,19)
				base.Parent = chest

				local arenaCenterPart = Workspace:FindFirstChild("BossArena") and Workspace.BossArena:FindFirstChild("ArenaCenter")
				if arenaCenterPart then
					base.Position = arenaCenterPart.Position + Vector3.new(0,2,0)
				else
					warn("⚠️ No ArenaCenter! Default chest spawn.")
					base.Position = Vector3.new(0,5,0)
				end

				local prompt = Instance.new("ProximityPrompt")
				prompt.ActionText = "Open"
				prompt.ObjectText = "Treasure Chest"
				prompt.MaxActivationDistance = 8
				prompt.Parent = base

				prompt.Triggered:Connect(function(player)
					print(player.Name .. " opened the Reward Chest!")

					local leaderstats = player:FindFirstChild("leaderstats")
					if leaderstats then
						local xp = leaderstats:FindFirstChild("XP")
						if xp then
							xp.Value += 100
						end
					end

					chest:Destroy()
				end)

			else
				-- ⚡ Resurrect next round
				task.delay(1, function()
					print("⚡ Resurrecting boss for round", round + 1)
					self:StartBossFight(bossName, round + 1)
				end)
			end
		end
	end)
end

function BossManager:DamageBoss(amount, player)
	local boss = self.activeBoss
	if not boss or not boss.Parent then
		warn("⚠️ No active boss to damage!")
		return
	end

	local humanoid = boss:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid:TakeDamage(amount)
		boss:SetAttribute("HP", math.max(0, humanoid.Health))
		print("💢 Boss took", amount, "damage from", player.Name)
	end
end

return BossManager
