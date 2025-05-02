-- ServerScriptService/BossFactory.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local BossConfig = require(ReplicatedStorage:WaitForChild("BossConfig"))

local BossFactory = {}

function BossFactory.newBoss(bossName: string, roundNumber: number)
	local config = BossConfig[bossName]
	if not config then error("No config found for boss: " .. bossName) end

	local template = ReplicatedStorage.Bosses:FindFirstChild(bossName)
	if not template then error("Boss template missing in ReplicatedStorage.Bosses: " .. bossName) end

	local boss = template:Clone()
	boss.Name = bossName
	boss.Parent = Workspace

	local canAttack = Instance.new("BoolValue")
	canAttack.Name = "CanAttack"
	canAttack.Value = false
	canAttack.Parent = boss

	local humanoid = boss:FindFirstChildWhichIsA("Humanoid")

	if bossName == "Cranky" then
		local tableModel = Workspace:FindFirstChild("SurgicalTable")
		local headEnd = tableModel and tableModel:FindFirstChild("HeadPosition")
		if headEnd and boss.PrimaryPart then
			if roundNumber == 1 then
				local pos = headEnd.Position + Vector3.new(0, 2, 0)
				local right = headEnd.CFrame.RightVector
				local up = -headEnd.CFrame.LookVector
				local back = right:Cross(up)
				local flatCFrame = CFrame.fromMatrix(pos, right, up, back)
				boss:SetPrimaryPartCFrame(flatCFrame)
			else
				boss:SetPrimaryPartCFrame(headEnd.CFrame + Vector3.new(0, 5, 0))
			end
		else
			warn("⚠️ Cranky missing table or PrimaryPart!")
		end
	else
		if boss.PrimaryPart then
			local startPos = config.SpawnPart.Position + Vector3.new(0, 10, 0)
			boss:SetPrimaryPartCFrame(CFrame.new(startPos))
		end
	end

	local scaledHealth = config.HealthScale + (roundNumber * 100)
	local scaledDamage = config.DamageScale + (roundNumber * 5)
	local scaledInterval = config.AttackInterval and math.max(0.8, config.AttackInterval - (roundNumber * 0.2))

	if humanoid then
		humanoid.MaxHealth = scaledHealth
		humanoid.Health = scaledHealth
	end

	return {
		Model = boss,
		Humanoid = humanoid,
		Health = scaledHealth,
		Damage = scaledDamage,
		AttackInterval = scaledInterval,
	}
end

return BossFactory
