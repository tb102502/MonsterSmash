-- ServerScriptService/ArenaTriggerScript

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local StartBossFightEvent = ReplicatedStorage:WaitForChild("StartCrankyFightEvent")
local BossManager = require(ServerScriptService.BossSystems.BossManager)

local arenaTrigger = Workspace:WaitForChild("CrankyArenaTrigger")

-- When a player touches the arena trigger
arenaTrigger.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if player then
		StartBossFightEvent:FireClient(player)
	end
end)

-- When player clicks "Start Fight" on client (or automatic)
StartBossFightEvent.OnServerEvent:Connect(function(player)
	if not BossManager:IsFightActive() then
		print("⚔️ Starting Cranky boss fight!")
		BossManager:StartBossFight("Cranky", 1) -- Start Cranky fight at round 1
	else
		warn("⚠️ Fight already active!")
	end
end)
