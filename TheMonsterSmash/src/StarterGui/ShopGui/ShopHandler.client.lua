-- LocalScript under ShopGui

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeFeedback = ReplicatedStorage:WaitForChild("UpgradeFeedback")
local PurchaseUpgrade = ReplicatedStorage:WaitForChild("PurchaseUpgrade")

local Players = game:GetService("Players")
local CritPopupEvent = ReplicatedStorage:WaitForChild("CritPopupEvent") -- Make sure you have this
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")

local coinsStat = leaderstats:WaitForChild("Coins")
local gui = script.Parent
local frame = gui:WaitForChild("Frame")
local coinDisplay = gui:WaitForChild("CoinDisplay")
coinsStat:GetPropertyChangedSignal("Value"):Connect(function()
	coinDisplay.Text = "Coins: " .. tostring(coinsStat.Value)
end)

local lastCoinValue = coinsStat.Value
local targetCoinValue = coinsStat.Value
local coinTweenRunning = false

local chaChingSound = gui:WaitForChild("ChaChingSound")
local bonkSound = gui:WaitForChild("BonkSound")
local resetButton = gui:WaitForChild("ResetStatsButton")
local notEnoughLabel = gui:WaitForChild("NotEnoughCoinsLabel")

-- Only show Reset Button for you
if player.Name ~= "TommySalami311" then
	resetButton.Visible = false
end

-- Button mappings
local buttons = {
	Health = frame:WaitForChild("Health"),
	Damage = frame:WaitForChild("Damage"),
	HealthRegen = frame:WaitForChild("HealthRegen"),
	WalkSpeed = frame:WaitForChild("WalkSpeed"),
	ClickSpeed = frame:WaitForChild("ClickSpeed"),
	CoinMultiplier = frame:WaitForChild("CoinMultiplier"),
}

-- 🛠️ Hook up all upgrade buttons
for upgradeType, button in pairs(buttons) do
	button.MouseButton1Click:Connect(function()
		print("🛒 Attempting to purchase:", upgradeType)
		PurchaseUpgrade:FireServer(upgradeType)
	end)
end

-- Random CoinDisplay Shake
local function shakeDisplayRandom(label)
	local originalPos = label.Position
	local tweens = {}

	for i = 1, 4 do
		local randomOffsetX = math.random(-5, 5)
		local randomOffsetY = math.random(-2, 2)

		local newPos = UDim2.new(
			originalPos.X.Scale,
			originalPos.X.Offset + randomOffsetX,
			originalPos.Y.Scale,
			originalPos.Y.Offset + randomOffsetY
		)

		local tween = TweenService:Create(label, TweenInfo.new(0.05), { Position = newPos })
		table.insert(tweens, tween)
	end

	local tweenBack = TweenService:Create(label, TweenInfo.new(0.05), { Position = originalPos })
	table.insert(tweens, tweenBack)

	coroutine.wrap(function()
		for _, tween in ipairs(tweens) do
			tween:Play()
			tween.Completed:Wait()
		end
	end)()
end

-- Random Frame Shake (bonk)
local function shakeGuiRandom(guiElement)
	local originalPos = guiElement.Position
	local tweens = {}

	for i = 1, 4 do
		local randomOffsetX = math.random(-10, 10)
		local randomOffsetY = math.random(-6, 6)

		local newPos = UDim2.new(
			originalPos.X.Scale,
			originalPos.X.Offset + randomOffsetX,
			originalPos.Y.Scale,
			originalPos.Y.Offset + randomOffsetY
		)

		local tween = TweenService:Create(guiElement, TweenInfo.new(0.05), { Position = newPos })
		table.insert(tweens, tween)
	end

	local tweenBack = TweenService:Create(guiElement, TweenInfo.new(0.05), { Position = originalPos })
	table.insert(tweens, tweenBack)

	coroutine.wrap(function()
		for _, tween in ipairs(tweens) do
			tween:Play()
			tween.Completed:Wait()
		end
	end)()
end

-- Upgrade Feedback Event
UpgradeFeedback.OnClientEvent:Connect(function(upgradeType, newCost, newValue, isMaxed, updatedCoins, purchaseSuccess)
	print("🛒 Upgrade feedback received:", upgradeType)
	if purchaseSuccess then
		-- update CoinDisplay
		coinDisplay.Text = "Coins: " .. tostring(updatedCoins)
	end
	CritPopupEvent.OnClientEvent:Connect(function()
		-- Flash CoinDisplay to Gold
		if coinDisplay then
			local flashTween = TweenService:Create(coinDisplay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
			})

			local returnTween = TweenService:Create(coinDisplay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextColor3 = Color3.fromRGB(255, 255, 255) -- Back to white
			})

			flashTween:Play()
			flashTween.Completed:Wait()
			returnTween:Play()
		end
	end)
	if not purchaseSuccess then
		if notEnoughLabel then
			notEnoughLabel.Visible = true
			shakeGuiRandom(frame)

			if bonkSound then
				bonkSound:Play()
			end

			local flashTween = TweenService:Create(notEnoughLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 3, true), {
				TextTransparency = 0.5
			})
			flashTween:Play()

			task.delay(2, function()
				notEnoughLabel.Visible = false
			end)
		end
		return
	end

	-- Successful purchase!
	targetCoinValue = updatedCoins

	if not coinTweenRunning then
		coinTweenRunning = true
		while math.abs(lastCoinValue - targetCoinValue) > 0 do
			lastCoinValue = lastCoinValue + math.clamp(targetCoinValue - lastCoinValue, -50, 50)
			coinDisplay.Text = "Coins: " .. tostring(lastCoinValue)
			task.wait(0.03)
		end
		lastCoinValue = targetCoinValue
		coinDisplay.Text = "Coins: " .. tostring(targetCoinValue)
		coinTweenRunning = false
	end


	-- (and then all the upgrade text, button flash, cha-ching, etc)
	local feedbackLabel = gui:FindFirstChild("UpgradeFeedbackLabel")
	if feedbackLabel then
		feedbackLabel.Text = upgradeType .. " upgraded!\nCost: " .. newCost .. "\nValue: " .. tostring(newValue)
		feedbackLabel.Visible = true
		task.delay(2.5, function()
			feedbackLabel.Visible = false
		end)
	end

	local button = buttons[upgradeType]
	if button and button:IsA("TextButton") then
		local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 1, true)
		local goal = { BackgroundColor3 = Color3.fromRGB(255, 230, 0) }
		TweenService:Create(button, info, goal):Play()

		local costLabel = button:FindFirstChild("Cost")
		if costLabel then
			costLabel.Text = isMaxed and "MAX" or (tostring(newCost) .. " Coins")
		end

		if isMaxed then
			button.AutoButtonColor = false
			button.Text = upgradeType .. " (MAX)"
			button.Active = false
		end
	end

	-- Cha-ching + shake if coins spent
	if chaChingSound then
		chaChingSound:Play()
	end
	shakeDisplayRandom(coinDisplay)
end)

-- Reset Button
resetButton.MouseButton1Click:Connect(function()
	print("🔁 Reset Button Clicked!")

	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			coins.Value = 0
		end

		for _, statName in ipairs({"Health", "Damage", "WalkSpeed", "ClickSpeed", "HealthRegen", "CoinMultiplier"}) do
			local stat = leaderstats:FindFirstChild(statName)
			if stat then
				stat.Value = (statName == "WalkSpeed") and 16 or 1
				if statName == "Health" then stat.Value = 50 end
				if statName == "Damage" then stat.Value = 10 end
			end
		end
	end

	local upgrades = player:FindFirstChild("UpgradeLevels")
	if upgrades then
		for _, level in ipairs(upgrades:GetChildren()) do
			if level:IsA("IntValue") then
				level.Value = 0
			end
		end
	end

	coinDisplay.Text = "Coins: " .. tostring(coinsStat.Value)
	lastCoinValue = coinsStat.Value
end)
