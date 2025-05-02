-- ServerScriptService | XPAttributeManager.server.lua
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(0.1)

		local ws = character:FindFirstChildOfClass("Humanoid")
		if not ws then return end

		local str = player:GetAttribute("Upgrade_Strength") or 0
		local hp = player:GetAttribute("Upgrade_Health") or 0
		local spd = player:GetAttribute("Upgrade_Speed") or 0

		ws.WalkSpeed = 16 + spd
		ws.MaxHealth = 100 + hp
		ws.Health = ws.MaxHealth

		local ui = Instance.new("BillboardGui")
		ui.Adornee = character:WaitForChild("Head")
		ui.Size = UDim2.new(0, 200, 0, 50)
		ui.StudsOffset = Vector3.new(0, 3, 0)
		ui.AlwaysOnTop = true

		local label = Instance.new("TextLabel", ui)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.TextScaled = true
		label.Text = "Upgrades Applied: +" .. str .. " STR, +" .. hp .. " HP, +" .. spd .. " SPD"
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 0)

		ui.Parent = character
		task.delay(3, function() ui:Destroy() end)
	end)
end)
