local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local BossManager = require(ServerScriptService.BossSystems:WaitForChild("BossManager"))
local StartCrankyFightEvent = ReplicatedStorage:WaitForChild("StartCrankyFightEvent")
local StartDracFightEvent = ReplicatedStorage:WaitForChild("StartDracFightEvent")

local crankyArenaTrigger = Workspace:WaitForChild("CrankyArenaTrigger")
local dracArenaTrigger = Workspace:WaitForChild("DracArenaTrigger")

-- 🔁 Reusable trigger function
local function onArenaTouch(trigger, event)
	trigger.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player then
			event:FireClient(player) -- show UI to confirm
		end
	end)
end

onArenaTouch(crankyArenaTrigger, StartCrankyFightEvent)
onArenaTouch(dracArenaTrigger, StartDracFightEvent)

-- 🎮 Boss start trigger from client GUI
StartCrankyFightEvent.OnServerEvent:Connect(function(player)
		print("🔁 StartCrankyFightEvent received from", player.Name)

		if not BossManager:IsFightActive() then
			print("⚔️ Starting Cranky boss fight!")
			BossManager:StartBossFight("Cranky", 1)
		else
			warn("⚠️ Fight already active!")
		end
	end)

StartDracFightEvent.OnServerEvent:Connect(function(player)
	if not BossManager:IsFightActive() then
		BossManager:StartBossFight("Drac", 1)
	else
		warn("Fight already active!")
	end
end)

local StartWolfyFightEvent = ReplicatedStorage:WaitForChild("StartWolfyFightEvent")
local wolfyArenaTrigger = Workspace:WaitForChild("WolfyArenaTrigger")
onArenaTouch(wolfyArenaTrigger, StartWolfyFightEvent)
StartWolfyFightEvent.OnServerEvent:Connect(function(player)
	if not BossManager:IsFightActive() then
		BossManager:StartBossFight("Wolfy", 1)
	else
		warn("⚠️ Fight already active!")
	end
end)
