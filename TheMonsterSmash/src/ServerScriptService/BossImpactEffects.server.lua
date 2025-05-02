-- ServerScriptService | BossImpactEffects.server.lua
local Debris = game:GetService("Debris")
local function createHitEffect(position)
	local part = Instance.new("Part")
	part.Size = Vector3.new(1, 1, 1)
	part.Anchored = true
	part.CanCollide = false
	part.Position = position
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 170, 0)
	part.Transparency = 0.2
	part.Parent = workspace
	Debris:AddItem(part, 0.5)
end

local function playHitSound(position)
	local sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://138087186" -- impact hit
	sfx.Volume = 1
	sfx.Position = position
	sfx.Parent = workspace.Terrain
	sfx:Play()
	Debris:AddItem(sfx, 2)
end

return function(victim)
	if victim:IsA("Model") and victim:FindFirstChild("HumanoidRootPart") then
		local pos = victim.HumanoidRootPart.Position
		createHitEffect(pos)
		playHitSound(pos)
	end
end
