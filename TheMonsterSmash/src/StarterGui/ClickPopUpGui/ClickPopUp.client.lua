local replicatedStorage = game:GetService("ReplicatedStorage")
local clickEvent = replicatedStorage:FindFirstChild("ClickEvent")
print("Clicked! New text should appear.")
if not clickEvent then
	clickEvent = Instance.new("RemoteEvent", replicatedStorage)
	clickEvent.Name = "ClickEvent"
end

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ClickPopUpGui")
local baseText = gui:WaitForChild("ClickText")

local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
	clickEvent:FireServer(1)  -- Send amount to the server

	-- Clone click effect
	local newText = baseText:Clone()
	newText.Parent = gui
	newText.Text = "+1"
	newText.Position = UDim2.new(math.random(), 0, math.random(), 0)
	newText.Visible = true

	-- Animate it upwards & fade out
	game:GetService("TweenService"):Create(newText, TweenInfo.new(1), {
		TextTransparency = 1,
		Position = newText.Position + UDim2.new(0, 0, -0.1, 0)
	}):Play()

	wait(1)
	newText:Destroy()
end)

