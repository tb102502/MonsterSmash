local player = game.Players.LocalPlayer
local rewardGui = script.Parent.RewardFrame
local claimButton = rewardGui.ClaimButton

-- RemoteEvent to request reward from the server
local rewardEvent = game.ReplicatedStorage:WaitForChild("DailyRewardEvent")

-- Function to show the GUI when a reward is available
local function showRewardPopup(rewardAmount)
	rewardGui.Visible = true
	rewardGui.RewardText.Text = "You received " .. rewardAmount .. " Coins!"
end

-- Listen for the server's notification
rewardEvent.OnClientEvent:Connect(showRewardPopup)

-- When player clicks the Claim button
claimButton.MouseButton1Click:Connect(function()
	rewardGui.Visible = false
	rewardEvent:FireServer() -- Send confirmation to the server
end)

