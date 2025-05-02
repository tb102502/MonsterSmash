local teleportPad = script.Parent
local spawnlocation = Vector3.new(-85.65, 0.549, 181.1) -- Change to your boss arena's position

teleportPad.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.CFrame = CFrame.new(spawnlocation)
	end
end)

