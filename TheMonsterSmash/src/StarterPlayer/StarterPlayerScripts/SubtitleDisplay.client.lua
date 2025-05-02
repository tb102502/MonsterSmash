local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local SubtitleEvent = ReplicatedStorage:WaitForChild("SubtitleEvent")

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "SubtitleDisplay"

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0.6, 0, 0.08, 0)
label.Position = UDim2.new(0.2, 0, 0.85, 0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.GothamBold
label.Text = ""
label.Visible = false

SubtitleEvent.OnClientEvent:Connect(function(text)
	label.Text = text
	label.Visible = true
	task.wait(3)
	label.Visible = false
end)
