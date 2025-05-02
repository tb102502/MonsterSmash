-- XPGrant Script inside RewardChest

local chest = script.Parent
local chestPart = chest:FindFirstChildWhichIsA("BasePart") -- Find any part inside model
if not chestPart then
	warn("⚠️ No valid part in RewardChest!")
	return
end

-- Ensure a ProximityPrompt exists
local prompt = chestPart:FindFirstChildOfClass("ProximityPrompt")
if not prompt then
	prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Open Chest"
	prompt.ObjectText = "Reward Chest"
	prompt.MaxActivationDistance = 8
	prompt.Parent = chestPart
end

prompt.Triggered:Connect(function(player)
	print(player.Name .. " opened the Reward Chest!")

	-- 💥 Give XP
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local xp = leaderstats:FindFirstChild("XP")
		if xp then
			xp.Value += 100 -- Give 100 XP
		else
			warn("⚠️ No XP stat found for", player.Name)
		end
	end

	-- 🎉 Optional: Play chest open sound / particles here

	-- Destroy chest after reward
	chest:Destroy()
end)
