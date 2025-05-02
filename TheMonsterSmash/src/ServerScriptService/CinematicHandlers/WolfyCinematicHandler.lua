-- ServerScriptService/BossSystems/BossConfigs.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VFX = require(script.Parent.Parent.VFXHandlers:WaitForChild("WolfyVFXHandler"))
local WolfyCinematicHandler = require(script.Parent.Parent.CinematicHandlers:WaitForChild("WolfyCinematicHandler"))
local BossDamageHandler = require(script.Parent.Parent.BossSystems:WaitForChild("BossDamageHandler"))

local BossConfigs = {}

BossConfigs["Wolfy"] = {
	Name = "Wolfy",
	Model = ReplicatedStorage.Bosses:WaitForChild("Wolfy"),
	SpawnPosition = workspace:WaitForChild("WolfySpawn").Position,

	BaseHP = 1000,
	BaseDamage = 25,
	AttackDelay = 3,

	Sounds = {
		Intro = "rbxassetid://9251843621",
		Attack = "rbxassetid://9274192380",
		Death = "rbxassetid://9274197109",
	},

	Intro = function(boss)
		print("🐺 Wolfy cinematic starting...")
		WolfyCinematicHandler.PlayIntro(boss)
	end,

	Taunt = function(boss)
		print("🐾 Wolfy howls menacingly!")
	end,

	Animate = function(boss)
		local animator = boss:FindFirstChildWhichIsA("Humanoid") and boss:FindFirstChildWhichIsA("Humanoid"):FindFirstChildOfClass("Animator")
		if animator then
			local idle = Instance.new("Animation")
			idle.AnimationId = "rbxassetid://9284201143"
			local track = animator:LoadAnimation(idle)
			track.Looped = true
			track:Play()
		end
	end,

	Attacks = {
		{
			Name = "ClawSwipe",
			AnimationId = "rbxassetid://9284203299",
			Perform = function(boss, dmg, target)
				print("🦴 ClawSwipe hit!")
				BossDamageHandler.DamagePlayer(target, dmg)
			end,
		},
		{
			Name = "Leap",
			AnimationId = "rbxassetid://9284206212",
			Perform = function(boss, dmg, target)
				print("🐾 Wolfy leaps at", target.Name)
				BossDamageHandler.ApplyKnockbackFrom(boss, target)
				BossDamageHandler.DamagePlayer(target, dmg)
			end,
		},
	},

	Loot = function(boss)
		print("🎁 Wolfy dropped loot!")
		-- Optional: Add loot logic
	end,

	RoundEnd = function(boss)
		print("📽 Wolfy retreats into the forest...")
	end,
}

return BossConfigs
