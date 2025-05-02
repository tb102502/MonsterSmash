local player = game.Players.LocalPlayer

-- Wait for PlayerGui to load
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for leaderstats to be created
local leaderstats = player:WaitForChild("leaderstats", 5)  -- 5-second timeout to prevent infinite yield

if not leaderstats then
	warn("❌ leaderstats not found for", player.Name)
	return
end

-- Wait for Coins stat inside leaderstats
local coins = leaderstats:WaitForChild("Coins", 5)

if not coins then
	warn("❌ Coins stat not found inside leaderstats!")
	return
end

-- Function to update the coins label in UI
local function updateCoinsLabel()
	local coinsGui = playerGui:FindFirstChild("CoinsPopUpGui")
	if coinsGui then
		local coinsLabel = coinsGui:FindFirstChild("CoinsLabel")
		if coinsLabel then
			coinsLabel.Text = "Coins: " .. coins.Value  -- Update the text
		end
	end
end

-- Initial update and connect to .Changed event
updateCoinsLabel()
coins.Changed:Connect(updateCoinsLabel)
