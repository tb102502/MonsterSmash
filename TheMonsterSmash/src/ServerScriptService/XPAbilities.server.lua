-- ServerScriptService | XPAbilities.server.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent for triggering abilities
local abilityRemote = Instance.new("RemoteEvent")
abilityRemote.Name = "AbilityTrigger"
abilityRemote.Parent = ReplicatedStorage

-- Level gated ability effects
local function powerSlam(player)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local blast = Instance.new("Part")
	blast.Shape = Enum.PartType.Ball
	blast.Anchored = true
	blast.CanCollide = false
	blast.Material = Enum.Material.Neon
	blast.Size = Vector3.new(10, 10, 10)
	blast.CFrame = root.CFrame
	blast.BrickColor = BrickColor.new("Bright orange")
	blast.Transparency = 0.4
	blast.Parent = workspace

	game:GetService("Debris"):AddItem(blast, 1.5)

	-- damage logic here (AOE)
	print("Power Slam activated by", player.Name)
end

abilityRemote.OnServerEvent:Connect(function(player, abilityName)
	local level = player:GetAttribute("XP_Level") or 1
	if abilityName == "PowerSlam" and level >= 3 then
		powerSlam(player)
	end
end)
