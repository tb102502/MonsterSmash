local label = script.Parent:WaitForChild("SavedLabel") -- or whatever your TextLabel is named
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local remote = ReplicatedStorage:WaitForChild("SavedIconEvent")

if not label:IsA("GuiObject") then
	warn("❌ SavedIconClient: Label is not a GuiObject! Got:", label.ClassName)
	return
end

-- Tween settings
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
print("SavedIcon type:", label.ClassName)

-- Scale-based tween: pulse in
local pulse = TweenService:Create(label, tweenInfo, {
	Size = UDim2.new(0.22, 0, 0.07, 0),
	TextTransparency = 0,
})

-- Fade out and shrink
local fadeOut = TweenService:Create(label, tweenInfo, {
	Size = UDim2.new(0.2, 0, 0.06, 0),
	TextTransparency = 1,
})

remote.OnClientEvent:Connect(function()
	label.Visible = true
	label.TextTransparency = 0
	label.Text = "✔ Saved!"
	label.Size = UDim2.new(0.2, 0, 0.06, 0)
	label.Position = UDim2.new(0.4, 0, 0.05, 0)

	pulse:Play()
	pulse.Completed:Wait()
	task.wait(1.5)

	fadeOut:Play()
	fadeOut.Completed:Wait()
	label.Visible = false
end)
