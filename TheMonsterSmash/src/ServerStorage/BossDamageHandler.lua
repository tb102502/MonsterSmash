-- ServerScriptService/BossSystems/BossDamageHandler.lua

local BossDamageHandler = {}

local activeBossModel = nil
local currentDamage = 10

-- ✅ Setter called by BossController
function BossDamageHandler.SetActiveBoss(bossModel: Model, damage: number)
	if not bossModel or not bossModel:IsA("Model") then
		warn("❌ Invalid boss model passed to SetActiveBoss!")
		return
	end
	if not bossModel.PrimaryPart then
		warn("❌ Boss model is missing PrimaryPart!")
		return
	end

	activeBossModel = bossModel
	currentDamage = damage
	print("✅ BossDamageHandler.SetActiveBoss:", bossModel.Name, "Damage:", damage)
end

-- ✅ Accessor used by other scripts
function BossDamageHandler.activeBoss()
	return activeBossModel
end

function BossDamageHandler.GetBossDamage()
	return currentDamage
end
function BossDamageHandler.DamageBoss(amount, player)
	if not activeBossModel or not activeBossModel:IsA("Model") then
		warn("⚠️ Cannot damage boss — no active boss.")
		return
	end

	local humanoid = activeBossModel:FindFirstChildWhichIsA("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(amount)
		print("⚔️ Boss took", amount, "damage from", player.Name)
	end
end

-- ✅ Optional: Knockback logic can go here (safe)
function BossDamageHandler.ApplyKnockbackFrom(player)
	local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not activeBossModel or not activeBossModel.PrimaryPart or not playerRoot then
		warn("⚠️ BossDamageHandler: activeBoss missing or missing PrimaryPart at knockback")
		return
	end

	local direction = (activeBossModel.PrimaryPart.Position - playerRoot.Position).Unit
	local knockback = Instance.new("BodyVelocity")
	knockback.Velocity = direction * 30
	knockback.MaxForce = Vector3.new(5000, 5000, 5000)
	knockback.P = 1000
	knockback.Name = "BossKnockback"
	knockback.Parent = activeBossModel.PrimaryPart
	game:GetService("Debris"):AddItem(knockback, 0.2)
end

return BossDamageHandler -- ✅ Final single return (no crash)
