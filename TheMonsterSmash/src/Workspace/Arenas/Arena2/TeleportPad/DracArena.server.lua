
local teleportPad = script.Parent
local teleportDestinationPosition = Vector3.new(-64.774, -0.564, 457.72) -- Change to your boss arena's position

teleportPad.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.CFrame = CFrame.new(teleportDestinationPosition)
	end
end)


