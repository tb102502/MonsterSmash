-- ArenaTriggerScript

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local StartDracFightEvent = ReplicatedStorage:WaitForChild("StartDracFightEvent")
local ServerScriptService = game:GetService("ServerScriptService")
local BossController = require(ServerScriptService.BossController)

print("BossController loaded:", BossController)

local dracArenaTrigger = Workspace:WaitForChild("DracArenaTrigger")

dracArenaTrigger.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if player then
		StartDracFightEvent:FireClient(player)
	end
end)

StartDracFightEvent.OnServerEvent:Connect(function(player)
	if not BossController.IsFightActive() then
		print("Calling StartRound:", BossController.StartRound)
		BossController.StartRound(player) -- ✅ This matches the actual function name!
	else
		warn("Fight already active!")
	end
end)
