-- ServerScriptService/BossSystems/BossAttackHandler.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")

local BossManager = require(ServerScriptService.BossManager)

local BossAttackHandler = {}

local ATTACK_INTERVAL = 3
local ATTACK_RANGE = 100
local lastAttackTime = 0
local dmg = 10
local attackAnimCache = {}
local currentAnimId = nil
local currentAnimTrack = nil
if currentAnimTrack then
	currentAnimTrack:Stop()
	currentAnimTrack:Destroy()
end

-- ✅ Set interval from BossController
function BossAttackHandler.SetAttackInterval(interval)
	if typeof(interval) ~= "number" or interval <= 0 then
		warn("⚠️ Invalid interval passed to SetAttackInterval:", interval)
		return
	end
	ATTACK_INTERVAL = interval
	print("✅ ATTACK_INTERVAL set to:", ATTACK_INTERVAL)
end

-- ✅ Optional: support animation per boss
function BossAttackHandler.SetAttackAnimation(animId)
	if not animId then
		warn("⚠️ SetAttackAnimation called with nil!")
		return
	end

	currentAnimId = animId

	if not attackAnimCache[animId] then
		local anim = Instance.new("Animation")
		anim.AnimationId = animId
		attackAnimCache[animId] = anim
	end
end

RunService.Heartbeat:Connect(function()
	local boss = BossManager.activeBoss()
	if not boss or not boss:IsA("Model") or not boss.PrimaryPart then return end

	local canAttackFlag = boss:FindFirstChild("CanAttack")
	if not canAttackFlag or not canAttackFlag.Value then return end

	if not ATTACK_INTERVAL then
		warn("⚠️ BossAttackHandler: ATTACK_INTERVAL not set!")
		return
	end

	if tick() - lastAttackTime < ATTACK_INTERVAL then return end

	local humanoid = boss:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then return end
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		local playerHumanoid = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if playerHumanoid and root and playerHumanoid.Health > 0 then
			local distance = (root.Position - boss.PrimaryPart.Position).Magnitude
			if distance <= ATTACK_RANGE then
				lastAttackTime = tick()

				-- ✅ Play attack animation if assigned
				local animId = boss:FindFirstChild("Punch") and boss.AttackAnimationId.Value
				local animToPlay = currentAnimId and attackAnimCache[currentAnimId]
				if animToPlay then
					if currentAnimTrack then currentAnimTrack:Stop() end
					currentAnimTrack = animator:LoadAnimation(animToPlay)
					currentAnimTrack:Play()
				end

				-- ✅ Deal damage
				local dmg = BossManager.GetBossDamage()
				local amount = math.max(dmg, 10)
				
				humanoid:TakeDamage(amount)

				break -- Stop after first hit per frame
			end
		end
	end
end)

return BossAttackHandler
