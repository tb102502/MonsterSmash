local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("CritPopupGui")
local critLabel = gui:WaitForChild("CritLabel")

local critPopupEvent = ReplicatedStorage:WaitForChild("CritPopupEvent")

critPopupEvent.OnClientEvent:Connect(function()
	-- Setup starting values
	critLabel.Visible = true
	critLabel.TextTransparency = 0
	critLabel.TextStrokeTransparency = 0.4
	critLabel.Size = UDim2.new(0.202, 0 , 0.103, 0)
	critLabel.Position = UDim2.new(0.349, 0, 0.4, 0)
	critLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold

	-- ✨ First tween: Pop bigger
	local popUpTween = TweenService:Create(critLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 350, 0, 120),
		TextColor3 = Color3.fromRGB(255, 230, 100) -- Even shinier for a moment
	})

	-- ✨ Second tween: Shrink and fade
	local shrinkFadeTween = TweenService:Create(critLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 200, 0, 70),
		TextTransparency = 1,
		TextStrokeTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255) -- Fade back to white
	})

	-- Chain tweens
	popUpTween:Play()
	popUpTween.Completed:Wait()
	shrinkFadeTween:Play()
	shrinkFadeTween.Completed:Wait()

	critLabel.Visible = false
end)
