
Wolfy = {
	Model = ReplicatedStorage.Bosses:WaitForChild("Wolfy"),
	SpawnPosition = Workspace:WaitForChild("BossSpawn").Position,
	Intro = function(boss)
		print("🎬 Wolfy intro starts...")
	end,
	Animate = function(boss)
		local a = boss:FindFirstChild("Animate")
		if a then a:Play() end
	end,
	Taunt = function(boss) print("Wolfy howls!") end,
	Attacks = {
		function(boss, dmg) print("Wolfy Claws", dmg) end,
		function(boss, dmg) print("Wolfy Pounce", dmg) end
	},
	BaseHP = 1200,
	BaseDamage = 28,
	AttackDelay = 2.8,
	Loot = function(boss) print("🎁 Wolfy loot howls!") end,
	Sounds = {
		Intro = "rbxassetid://323456",
		Attack = "rbxassetid://323457",
		Death = "rbxassetid://323458"
	},
	XPReward = 35,
	RoundEnd = function(boss)
		print("📽 Wolfy fades into the night.")
	end
},

Mummy = {
	Model = ReplicatedStorage.Bosses:WaitForChild("Mummy"),
	SpawnPosition = Workspace:WaitForChild("BossSpawn").Position,
	Intro = function(boss) print("🎬 Mummy awakens...") end,
	Animate = function(boss)
		local a = boss:FindFirstChild("Animate")
		if a then a:Play() end
	end,
	Taunt = function(boss) print("Mummy screeches!") end,
	Attacks = {
		function(boss, dmg) print("Bandage Wrap", dmg) end,
		function(boss, dmg) print("Sarcophagus Slam", dmg) end
	},
	BaseHP = 1300,
	BaseDamage = 26,
	AttackDelay = 3,
	Loot = function(boss) print("🎁 Mummy dropped ancient loot!") end,
	Sounds = {
		Intro = "rbxassetid://423456",
		Attack = "rbxassetid://423457",
		Death = "rbxassetid://423458"
	},
	XPReward = 30,
	RoundEnd = function(boss) print("📽 Mummy crumbles to dust.") end
},

Jawzz = {
	Model = ReplicatedStorage.Bosses:WaitForChild("Jawzz"),
	SpawnPosition = Workspace:WaitForChild("BossSpawn").Position,
	Intro = function(boss) print("🎬 Jawzz rises from the deep...") end,
	Animate = function(boss)
		local a = boss:FindFirstChild("Animate")
		if a then a:Play() end
	end,
	Taunt = function(boss) print("Jawzz growls through jagged teeth!") end,
	Attacks = {
		function(boss, dmg) print("Jawzz Chomp", dmg) end,
		function(boss, dmg) print("Jawzz Tail Swipe", dmg) end
	},
	BaseHP = 1600,
	BaseDamage = 35,
	AttackDelay = 2.7,
	Loot = function(boss) print("🎁 Jawzz dropped aquatic treasure!") end,
	Sounds = {
		Intro = "rbxassetid://523456",
		Attack = "rbxassetid://523457",
		Death = "rbxassetid://523458"
	},
	XPReward = 50,
	RoundEnd = function(boss) print("📽 Jawzz sinks below the surface...") end
}
}
