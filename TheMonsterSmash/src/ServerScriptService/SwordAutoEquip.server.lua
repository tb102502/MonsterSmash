
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Wait for the Backpack and Tool to exist
		local backpack = player:WaitForChild("Backpack")
		local tool = backpack:FindFirstChildOfClass("Tool")

		if tool then
			-- Wait for Humanoid to exist before equipping
			local humanoid = character:WaitForChild("Humanoid")
			humanoid:EquipTool(tool)
		end
	end)
end)
