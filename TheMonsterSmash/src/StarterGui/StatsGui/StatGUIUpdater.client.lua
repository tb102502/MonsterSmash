-- LocalScript under StatsGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = script.Parent

local statsFrame = gui:WaitForChild("StatsFrame")
local toggleButton = gui:WaitForChild("ToggleButton")

-- Wait for stat hierarchy
local leaderstats = player:WaitForChild("leaderstats")

-- List of stats to show
local statNames = { "Health", "Damage", "ClickSpeed", "WalkSpeed", "HealthRegen", "CoinMultiplier" }

-- Helper: waits for stat inside leaderstats with timeout
local function waitForStat(folder, name, timeout)
	local start = tick()
	while not folder:FindFirstChild(name) do
		if tick() - start > timeout then
			warn("⏱️ Timed out waiting for stat:", name)
			return nil
		end
		wait(0.1)
	end
	return folder:FindFirstChild(name)
end

-- Hook up stat labels
for _, statName in ipairs(statNames) do
	local stat = waitForStat(leaderstats, statName, 5)
	local label = statsFrame:FindFirstChild(statName .. "Label")

	if label and stat then
		label.Text = statName .. ": " .. tostring(stat.Value)

		local lastValue = stat.Value

		stat.Changed:Connect(function(newVal)
			-- Update label text
			label.Text = statName .. ": " .. tostring(newVal)

			-- Only show popup if stat increased
			if newVal > lastValue then
				local popup = Instance.new("TextLabel")
				popup.Size = UDim2.new(0, 100, 0, 30)
				popup.Position = UDim2.new(0.5, -50, 0, -20)
				popup.BackgroundTransparency = 1
				popup.TextColor3 = Color3.fromRGB(0, 255, 0)
				popup.TextStrokeTransparency = 0.5
				popup.TextScaled = true
				popup.Font = Enum.Font.GothamBold
				popup.Text = "+" .. tostring(newVal - lastValue)
				popup.Parent = label

				local TweenService = game:GetService("TweenService")

				local popupTween = TweenService:Create(popup, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, -50, 0, -60),
					TextTransparency = 1,
					TextStrokeTransparency = 1
				})
				popupTween:Play()
				popupTween.Completed:Connect(function()
					popup:Destroy()
				end)

				-- ✨ Flash Glow Animation
				local flashIn = TweenService:Create(label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextStrokeTransparency = 0.2,
					TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow flash
				})
				local flashOut = TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					TextStrokeTransparency = 0.5,
					TextColor3 = Color3.fromRGB(255, 255, 255) -- Normal white
				})

				flashIn:Play()
				flashIn.Completed:Wait()
				flashOut:Play()
			end

			lastValue = newVal
		end)

	end -- 🛠️ THIS was missing in your code to close the "if label and stat then"
end -- 🛠️ THIS closes the "for _, statName in ipairs(statNames) do"

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
	statsFrame.Visible = not statsFrame.Visible
end)
