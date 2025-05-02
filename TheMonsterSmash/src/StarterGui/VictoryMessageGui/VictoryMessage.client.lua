-- LocalScript inside Player's PlayerGui or within VictoryMessageGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local victoryMessageEvent = ReplicatedStorage:WaitForChild("VictoryMessageEvent")  -- RemoteEvent for victory message
local victoryTextLabel = player.PlayerGui:WaitForChild("VictoryMessageGui"):WaitForChild("VictoryText")

-- Function to show the Victory message
victoryMessageEvent.OnClientEvent:Connect(function()
	-- Set the TextLabel's text to show Victory message
	victoryTextLabel.Visible = true
	wait(2)  -- Display the message for 2 seconds (adjust as needed)
	victoryTextLabel.Visible = false
end)
