local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local SwingState = require(script.Parent:WaitForChild("SwingState"))

-- Create countdown GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CountdownGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.3, 0)
label.Position = UDim2.new(0, 0, 0.35, 0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBlack
label.TextColor3 = Color3.new(1, 1, 1)
label.TextStrokeTransparency = 0
label.Text = ""
label.ZIndex = 999
label.Parent = gui

local function countdown(from)
	for i = from, 1, -1 do
		label.Text = tostring(i)
		wait(1)
	end
	label.Text = "FIGHT!"
	wait(1)
	label.Text = ""

	-- ✅ Re-enable swinging
	SwingState:Set(true)
end

-- 🟨 Listen for round countdown trigger
local CountdownEvent = ReplicatedStorage:WaitForChild("StartRoundCountdown")

CountdownEvent.OnClientEvent:Connect(function(startFrom)
	print("🕒 Countdown starting from", startFrom)
	SwingState:Set(false)
	countdown(startFrom or 3)
end)
