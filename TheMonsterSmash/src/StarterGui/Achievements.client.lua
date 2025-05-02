local ReplicatedStorage = game:GetService("ReplicatedStorage")
local achievementEvent = ReplicatedStorage:WaitForChild("AchievementUnlocked")

-- Function to display achievement popups
achievementEvent.OnClientEvent:Connect(function(title, description)
	local achievementGui = Instance.new("ScreenGui")
	achievementGui.Parent = game.Players.LocalPlayer.PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.3, 0, 0.15, 0)
	frame.Position = UDim2.new(0.35, 0, 0.1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	frame.Parent = achievementGui

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = "🏆 Achievement Unlocked!"
	titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
	titleLabel.Parent = frame

	local achievementTitle = Instance.new("TextLabel")
	achievementTitle.Text = title
	achievementTitle.Size = UDim2.new(1, 0, 0.4, 0)
	achievementTitle.Position = UDim2.new(0, 0, 0.3, 0)
	achievementTitle.TextScaled = true
	achievementTitle.Parent = frame

	local descriptionLabel = Instance.new("TextLabel")
	descriptionLabel.Text = description
	descriptionLabel.Size = UDim2.new(1, 0, 0.3, 0)
	descriptionLabel.Position = UDim2.new(0, 0, 0.7, 0)
	descriptionLabel.TextScaled = true
	descriptionLabel.Parent = frame

	wait(3) -- Show for 3 seconds
	achievementGui:Destroy()
end)

