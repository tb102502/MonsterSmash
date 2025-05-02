-- ServerScriptService/BossSystems/BossConfigs.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local BossDamageHandler = require(script.Parent.BossDamageHandler)
local CrankyCinematicHandler = require(script.Parent.Parent.CinematicHandlers.CrankyCinematicHandler)
local DracCinematicHandler = require(script.Parent.Parent.CinematicHandlers.DracCinematicHandler)

local BossConfigs = {}

-- 🌟 Tween Hand Glow Helper
local function TweenHandGlow(hand)
	local light = hand:FindFirstChild("HandGlow")
	if not light then
		light = Instance.new("PointLight")
		light.Name = "HandGlow"
		light.Color = Color3.fromRGB(255, 255, 100)
		light.Range = 8
		light.Brightness = 0
		light.Parent = hand
	end

	local upTween = TweenService:Create(light, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Brightness = 8
	})
	upTween:Play()
	upTween.Completed:Wait()

	local downTween = TweenService:Create(light, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		Brightness = 0
	})
	downTween:Play()
end

----------------------------------
-- Cranky Boss
----------------------------------
BossConfigs["Cranky"] = {
	Model = ReplicatedStorage.Bosses:WaitForChild("Cranky"),
	SpawnPosition = Workspace:WaitForChild("CrankySpawn").Position,
	BaseHP = 2000,
	BaseDamage = 20,
	AttackDelay = 3,

	Intro = function(player, bossName, bossInterest, roundNumber, boss)
		if roundNumber > 1 then
			print("🔄 Skipping intro for round", roundNumber)
			return
		end
		print("🎬 Cranky cinematic starting...")
		CrankyCinematicHandler.PlayBossIntro(player, bossName, bossInterest, roundNumber, boss)
	end,


	Animate = function(boss)
		local animateScript = boss:FindFirstChild("Animate")
		if animateScript and animateScript:IsA("LocalScript") then
			animateScript.Disabled = false
		end
	end,

	Taunt = function(boss)
		print("😡 Cranky taunts menacingly!")
	end,

	Attacks = {
		{
			Name = "Punch",
			AnimationId = "rbxassetid://83761091636986",
			Perform = function(boss, damage, player)
				print("🤜 Cranky punches!", damage)

				local hand = boss:FindFirstChild("RightHand") or boss:FindFirstChild("Right Arm")
				if hand then
					TweenHandGlow(hand)

					-- ⚡ Create crackling sparks effect
					local sparks = Instance.new("ParticleEmitter")
					sparks.Texture = "rbxassetid://483750004" -- Sparks texture
					sparks.LightEmission = 1
					sparks.Rate = 200
					sparks.Lifetime = NumberRange.new(0.1, 0.2)
					sparks.Speed = NumberRange.new(8, 15)
					sparks.Size = NumberSequence.new({ 
						NumberSequenceKeypoint.new(0, 0.2),
						NumberSequenceKeypoint.new(1, 0) 
					})
					sparks.Parent = hand

					-- ⚡ Auto remove the sparks after short time
					task.delay(0.6, function()
						if sparks then
							sparks.Enabled = false
							sparks:Destroy()
						end
					end)
				end

				-- 💥 Damage and Knockback
				BossDamageHandler.DamagePlayer(player, damage)
				BossDamageHandler.ApplyKnockbackFrom(boss, player)

				-- 🎥 Camera FX
				local CameraFXRemote = ReplicatedStorage:WaitForChild("CameraFXRemote")
				if CameraFXRemote then
					CameraFXRemote:FireClient(player, "Shake", 3, 0.4)
					CameraFXRemote:FireClient(player, "Flash", 0.5)
				end

				-- ⚡ Lightning Strike
				local primaryPart = boss:FindFirstChild("HumanoidRootPart")
				if primaryPart then
					local beamPart = Instance.new("Part")
					beamPart.Size = Vector3.new(1, 1, 1)
					beamPart.Transparency = 1
					beamPart.Anchored = true
					beamPart.CanCollide = false
					beamPart.Position = primaryPart.Position + Vector3.new(0, 6, 0)
					beamPart.Parent = workspace

					local sourceAttachment = Instance.new("Attachment", beamPart)
					local targetAttachment = Instance.new("Attachment", primaryPart)

					local beam = Instance.new("Beam")
					beam.Attachment0 = sourceAttachment
					beam.Attachment1 = targetAttachment
					beam.Width0 = 0.5
					beam.Width1 = 0.2
					beam.LightEmission = 1
					beam.Texture = "rbxassetid://447392540"
					beam.TextureSpeed = 5
					beam.TextureLength = 1
					beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
					beam.Parent = beamPart

					local sparks = Instance.new("ParticleEmitter")
					sparks.Texture = "rbxassetid://483750004"
					sparks.Rate = 500
					sparks.Lifetime = NumberRange.new(0.2)
					sparks.Speed = NumberRange.new(8, 12)
					sparks.Size = NumberSequence.new(0.5)
					sparks.Parent = primaryPart
					sparks:Emit(30)

					local thunder = Instance.new("Sound")
					thunder.SoundId = "rbxassetid://138186576"
					thunder.Volume = 2
					thunder.Parent = primaryPart
					thunder:Play()

					local originalColor = primaryPart.Color
					primaryPart.Color = Color3.fromRGB(0, 255, 255)
					task.delay(0.2, function()
						if primaryPart then
							primaryPart.Color = originalColor
						end
					end)

					task.delay(0.5, function()
						if beamPart then beamPart:Destroy() end
						if sparks then sparks.Enabled = false; sparks:Destroy() end
						if thunder then thunder:Destroy() end
					end)
				end
			end
			
		}
	},

	Loot = function(boss)
		print("🎁 Cranky dropped treasure!")
	end,

	RoundEnd = function(boss)
		print("📽 Cranky falls over defeated.")
	end,

	Sounds = {}
}

----------------------------------
-- Drac Boss
----------------------------------
BossConfigs["Drac"] = {
	Model = ReplicatedStorage.Bosses:WaitForChild("Drac"),
	SpawnPosition = Workspace:WaitForChild("DracSpawn").Position,
	BaseHP = 2500,
	BaseDamage = 30,
	AttackDelay = 4,

	Intro = function(boss)
		print("🎬 Drac cinematic starting...")
		DracCinematicHandler.PlayIntro(boss)
	end,

	Animate = function(boss)
		local animateScript = boss:FindFirstChild("Animate")
		if animateScript and animateScript:IsA("LocalScript") then
			animateScript.Disabled = false
		end
	end,

	Taunt = function(boss)
		print("🧛 Drac hisses in fury!")
	end,

	Attacks = {
		{
			Name = "Grab",
			AnimationId = "rbxassetid://75600533335248",
			Perform = function(boss, damage, player)
				print("🧛 Drac uses Grab on", player.Name)
				BossDamageHandler.DamagePlayer(player, damage)
				BossDamageHandler.ApplyKnockbackFrom(boss, player)

				local CameraFXRemote = ReplicatedStorage:WaitForChild("CameraFXRemote")
				if CameraFXRemote then
					CameraFXRemote:FireClient(player, "Shake", 3, 0.4)
				end
			end
		}
	},

	Loot = function(boss)
		print("🎁 Drac dropped treasure!")
	end,

	RoundEnd = function(boss)
		print("🌫 Drac flies into the mist...")
	end,

	Sounds = {}
}

----------------------------------
-- Wolfy Boss
----------------------------------
BossConfigs["Wolfy"] = {
	Model = ReplicatedStorage.Bosses:WaitForChild("Wolfy"),
	SpawnPosition = Workspace:WaitForChild("WolfySpawn").Position,
	BaseHP = 3000,
	BaseDamage = 35,
	AttackDelay = 2.5,

	Intro = function(boss)
		print("🎬 Wolfy howls into the night!")
	end,

	Animate = function(boss)
		local animateScript = boss:FindFirstChild("Animate")
		if animateScript and animateScript:IsA("LocalScript") then
			animateScript.Disabled = false
		end
	end,

	Taunt = function(boss)
		print("🐺 Wolfy growls and snarls!")
	end,

	Attacks = {
		{
			Name = "ClawSwipe",
			AnimationId = "rbxassetid://9373823847",
			Perform = function(boss, damage, player)
				print("🐾 Wolfy claws", player.Name)
				BossDamageHandler.DamagePlayer(player, damage)
				BossDamageHandler.ApplyKnockbackFrom(boss, player)

				local CameraFXRemote = ReplicatedStorage:WaitForChild("CameraFXRemote")
				if CameraFXRemote then
					CameraFXRemote:FireClient(player, "Shake", 3, 0.4)
				end
			end
		}
	},

	Loot = function(boss)
		print("🎁 Wolfy dropped fur and bones!")
	end,

	RoundEnd = function(boss)
		print("🌕 Wolfy limps back into the shadows.")
	end,

	Sounds = {}
}

return BossConfigs
