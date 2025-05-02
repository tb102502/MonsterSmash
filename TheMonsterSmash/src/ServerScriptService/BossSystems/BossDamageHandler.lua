-- ServerScriptService/BossSystems/BossDamageHandler.lua

local BossDamageHandler = {}

local activeBossModel = nil
local currentDamage = 0

-- Sets the currently active boss and its base damage
function BossDamageHandler.SetActiveBoss(bossModel: Model, damage: number)
	if not bossModel or not bossModel:IsA("Model") then
		warn("❌ Invalid boss model passed to SetActiveBoss!")
		return
	end
	if not bossModel.PrimaryPart then
		warn("❌ Boss model missing PrimaryPart!")
		return
	end
	activeBossModel = bossModel
	currentDamage = damage
	print("✅ SetActiveBoss:", bossModel.Name, "Damage:", damage)
end

-- Gets the currently active boss
function BossDamageHandler.GetActiveBoss()
	return activeBossModel
end

-- Gets the current boss's base damage
function BossDamageHandler.GetBossDamage()
	return currentDamage
end

-- Deals raw damage to the active boss (from player taps, etc.)
function BossDamageHandler.DamageBoss(amount: number, player)
	if not activeBossModel or not activeBossModel:IsA("Model") then
		warn("⚠️ Cannot damage boss — no active boss.")
		return
	end

	local humanoid = activeBossModel:FindFirstChildWhichIsA("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(amount)
		activeBossModel:SetAttribute("HP", math.max(0, humanoid.Health))
		print("💢 Boss took", amount, "damage from", player.Name)

		-- Push Boss backward when hit
		local hrp = activeBossModel:FindFirstChild("HumanoidRootPart")
		if hrp then
			local pushDirection = hrp.CFrame.LookVector * -1 -- Push backward
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = pushDirection * 10 -- Adjust strength
			bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
			bodyVelocity.P = 2000
			bodyVelocity.Parent = hrp

			game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
		end
	end
end

-- Deals damage to a player (from boss attacks)
function BossDamageHandler.DamagePlayer(player: Player, damage: number)
	if not player or not player.Character then return end

	local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(damage)
		print("💢 Player", player.Name, "took", damage, "damage from Boss!")
	end
end

-- Applies knockback to a player away from the boss
function BossDamageHandler.ApplyKnockbackFrom(bossModel, player)
	local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not bossModel or not bossModel.PrimaryPart or not playerRoot then
		warn("⚠️ Missing boss or player parts for knockback")
		return
	end

	local direction = (playerRoot.Position - bossModel.PrimaryPart.Position).Unit
	local knockback = Instance.new("BodyVelocity")
	knockback.Velocity = direction * 40
	knockback.MaxForce = Vector3.new(4000, 4000, 4000)
	knockback.P = 1500
	knockback.Name = "BossKnockback"
	knockback.Parent = playerRoot

	game:GetService("Debris"):AddItem(knockback, 0.2)
end

return BossDamageHandler
