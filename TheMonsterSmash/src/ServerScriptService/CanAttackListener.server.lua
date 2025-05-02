-- ServerScriptService/CanAttackListener.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local cinematicFinished = ReplicatedStorage:WaitForChild("CinematicFinished")

cinematicFinished.OnServerEvent:Connect(function(player)
	for _, bossName in pairs({"Cranky", "Drac"}) do
		local boss = Workspace:FindFirstChild(bossName)
		if boss then
			local canAttack = boss:FindFirstChild("CanAttack")
			if canAttack then
				canAttack.Value = true
			end
		end
	end
end)
