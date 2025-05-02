-- AutoFightHandler (Script in ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToggleAutoFight = ReplicatedStorage:WaitForChild("ToggleAutoFight")
local Players = game:GetService("Players")

local autoFighters = {}

-- 👇 RemoteEvent should be fired with current boss module assigned elsewhere
local bossModule = game.ReplicatedStorage.Bosses:WaitForChild("Cranky")

ToggleAutoFight.OnServerEvent:Connect(function(player, isEnabled)
	if isEnabled then
		if autoFighters[player] then return end -- Already running

		local running = true
		autoFighters[player] = running

		task.spawn(function()
			while running and player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 do
				local bossModule = bossModule.Value
				if bossModule and bossModule.ApplyDamage then
					bossModule.ApplyDamage(player)
				end
				task.wait(0.5) -- delay between hits
			end
		end)
	else
		autoFighters[player] = nil
	end
end)

-- Clean up on player leave
Players.PlayerRemoving:Connect(function(player)
	autoFighters[player] = nil
end)
