local player = game.Players.LocalPlayer
local skipButton = script.Parent
local replicatedStorage = game:GetService("ReplicatedStorage")
local skipEvent = replicatedStorage:WaitForChild("SkipIntroEvent")

-- Make button visible when intro starts
skipEvent.OnClientEvent:Connect(function(action)
	if action == "Show" then
		skipButton.Visible = true
	elseif action == "Hide" then
		skipButton.Visible = false
	end
end)

skipButton.MouseButton1Click:Connect(function()
	skipButton.Visible = false
	skipEvent:FireServer("Skip")
end)
