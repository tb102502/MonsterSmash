-- ServerScriptService/BossSystems/BossDamageReceiver.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BossDamageHandler = require(game.ServerScriptService.BossSystems.BossDamageHandler)

-- RemoteEvent for dealing boss damage
local BossDamageEvent = ReplicatedStorage:FindFirstChild("BossDamageEvent")
if not BossDamageEvent then
	BossDamageEvent = Instance.new("RemoteEvent")
	BossDamageEvent.Name = "BossDamageEvent"
	BossDamageEvent.Parent = ReplicatedStorage
end

-- When a player attacks the boss
BossDamageEvent.OnServerEvent:Connect(function(player, damageAmount)
	if not player or not player:IsA("Player") then
		warn("⚠️ Invalid player in BossDamageEvent!")
		return
	end

	if type(damageAmount) ~= "number" or damageAmount <= 0 then
		warn("⚠️ Invalid damage amount sent:", damageAmount)
		return
	end

	-- Pass the damage to the BossDamageHandler
	BossDamageHandler.DamageBoss(damageAmount, player)
end)

print("✅ BossDamageReceiver loaded and listening for attacks!")
