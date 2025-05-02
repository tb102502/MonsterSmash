local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FadeFromBlack = ReplicatedStorage:WaitForChild("FadeFromBlack")

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

FadeFromBlack.OnClientEvent:Connect(function()
	local screenGui = Instance.new("ScreenGui", PlayerGui)
	local frame = Instance.new("Frame", screenGui)

	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 0
	frame.ZIndex = 10

	game:GetService("TweenService"):Create(
		frame,
		TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 1 }
	):Play()

	task.delay(2.5, function()
		screenGui:Destroy()
	end)
end)
