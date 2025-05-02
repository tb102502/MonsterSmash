-- LocalScript inside PlayerGui/DamagePopupGui

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local damagePopupEvent = ReplicatedStorage:WaitForChild("DamagePopupEvent")
local bossActiveEvent = ReplicatedStorage:WaitForChild("BossActiveEvent")

local damagePopupGui = player:WaitForChild("PlayerGui"):WaitForChild("DamagePopupGui")
local damageTextLabel = damagePopupGui:WaitForChild("DamagePopupText")

-- Track boss fight state
local bossActive = false

-- Listen for boss state
bossActiveEvent.OnClientEvent:Connect(function(state)
	bossActive = state
end)

-- Function to spawn a CRITICAL HIT explosion effect
local function spawnCritEffect()
	local critBurst = Instance.new("ImageLabel")
	critBurst.Size = UDim2.new(0, 200, 0, 200)
	critBurst.Position = UDim2.new(0.5, -100, 0.5, -100)
	critBurst.AnchorPoint = Vector2.new(0.5, 0.5)
	critBurst.BackgroundTransparency = 1
	critBurst.Image = "rbxassetid://4922828329" -- Replace if you want
	critBurst.ImageColor3 = Color3.fromRGB(255, 223, 0)
	critBurst.ImageTransparency = 0
	critBurst.Parent = damagePopupGui

	local expandTween = TweenService:Create(critBurst, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 300, 0, 300),
		ImageTransparency = 1
	})

	expandTween:Play()
	expandTween.Completed:Connect(function()
		critBurst:Destroy()
	end)
end

-- Handle Damage Popups
damagePopupEvent.OnClientEvent:Connect(function(damageAmount)
	if not bossActive then
		return
	end

	-- 10% chance to crit
	local isCrit = math.random() < 0.1

	damageTextLabel.Text = tostring(damageAmount)
	damageTextLabel.Visible = true
	damageTextLabel.TextTransparency = 0
	damageTextLabel.TextStrokeTransparency = 0.5
	damageTextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	damageTextLabel.Size = UDim2.new(0.2, 0, 0.1, 0)

	-- 🎯 Random initial X and Y offset for popout
	local randomOffsetX = math.random(-20, 20)
	local randomOffsetY = math.random(-10, 10)
	local randomStartPosition = UDim2.new(0.5, randomOffsetX, 0.5, randomOffsetY)
	damageTextLabel.Position = randomStartPosition

	-- 🧨 If damage is BIG, do SHAKE
	if damageAmount >= 500 then
		coroutine.wrap(function()
			for i = 1, 5 do
				local shakeX = math.random(-10, 10)
				local shakeY = math.random(-5, 5)
				damageTextLabel.Position = UDim2.new(0.5, randomOffsetX + shakeX, 0.5, randomOffsetY + shakeY)
				task.wait(0.03)
			end
			damageTextLabel.Position = randomStartPosition
		end)()
	end

	-- ✨ If CRIT, special color + effect
	if isCrit then
		damageTextLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
		spawnCritEffect()
		damageTextLabel.Size = UDim2.new(0.3, 0, 0.15, 0)
	else
		damageTextLabel.TextColor3 = Color3.fromRGB(255, 85, 0) -- Normal orange
	end

	-- 🎯 RANDOM flying direction
	local endOffsetX = randomOffsetX + math.random(-40, 40)
	local endOffsetY = randomOffsetY - math.random(50, 100)

	local goalPosition = UDim2.new(0.5, endOffsetX, 0.5, endOffsetY)

	local floatTween = TweenService:Create(damageTextLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = goalPosition,
		TextTransparency = 1,
		TextStrokeTransparency = 1
	})

	-- Color fade back to normal white
	local colorTween = TweenService:Create(damageTextLabel, TweenInfo.new(0.3), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	})

	-- Play animations
	floatTween:Play()
	colorTween:Play()

	-- Hide after done
	floatTween.Completed:Wait()
	damageTextLabel.Visible = false
end)
