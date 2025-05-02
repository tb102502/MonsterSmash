-- DamageReceiver Script (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DamageBoss = ReplicatedStorage:WaitForChild("DamageBoss")

local BossDamageHandler = require(game.ServerScriptService.BossSystems:WaitForChild("BossDamageHandler"))

local function ApplyKnockback(character, originPosition)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local direction = (rootPart.Position - originPosition).Unit
	local knockbackForce = 5

	rootPart.Velocity = direction * knockbackForce + Vector3.new(0, 20, 0)
end

DamageBoss.OnServerEvent:Connect(function(player)
end)
