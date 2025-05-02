

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StartBossCamera = ReplicatedStorage:WaitForChild("StartBossCamera")

local arenaSpawn = workspace.Arenas.Arena1:WaitForChild("TeleportDestination") -- where player appears

-- Example teleport trigger
local teleportPart = workspace.Arenas.Arena1:WaitForChild("TeleportPad") -- like a TouchPart

teleportPart.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and player.Character then
		player.Character:MoveTo(arenaSpawn.Position)

		-- Fire to client to start the drone camera!
		StartBossCamera:FireClient(player)
	end
end)

