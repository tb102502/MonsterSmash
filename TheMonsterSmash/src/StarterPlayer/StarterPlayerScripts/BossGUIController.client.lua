warn("BossGuiController loaded.")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextFXUtils = require(ReplicatedStorage.Modules:WaitForChild("TextFXUtils"))
local StartCinematicCamera = ReplicatedStorage:WaitForChild("StartCinematicCamera")
local BossTaunt = ReplicatedStorage:WaitForChild("BossTaunt")


local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local HPUpdate = ReplicatedStorage:WaitForChild("BossHPUpdateEvent")
local XPGained = ReplicatedStorage:WaitForChild("XPGainedEvent")


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BossUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

local hpBar = Instance.new("Frame")
hpBar.Name = "HPBar"
hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
hpBar.Position = UDim2.new(0.25, 0, 0.05, 0)
hpBar.Size = UDim2.new(0, 0, 0.03, 0)
hpBar.BackgroundTransparency = 1
hpBar.Parent = screenGui

local hpLabel = Instance.new("TextLabel")
hpLabel.Size = UDim2.new(1, 0, 1, 0)
hpLabel.BackgroundTransparency = 1
hpLabel.TextColor3 = Color3.new(1, 1, 1)
hpLabel.TextScaled = true
hpLabel.Font = Enum.Font.GothamBold
hpLabel.Text = ""
hpLabel.Parent = hpBar

local bossNameLabel = Instance.new("TextLabel")
bossNameLabel.Name = "BossNameLabel"
bossNameLabel.Size = UDim2.new(0.5, 0, 0.03, 0)
bossNameLabel.Position = UDim2.new(0.25, 0, 0.01, 0)
bossNameLabel.BackgroundTransparency = 1
bossNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bossNameLabel.TextScaled = true
bossNameLabel.Font = Enum.Font.GothamBold
bossNameLabel.Text = ""
bossNameLabel.Parent = screenGui

local xpPopup = Instance.new("TextLabel")
xpPopup.Position = UDim2.new(0.4, 0, 0.1, 0)
xpPopup.Size = UDim2.new(0.2, 0, 0.05, 0)
xpPopup.Text = ""
xpPopup.TextScaled = true
xpPopup.BackgroundTransparency = 1
xpPopup.TextColor3 = Color3.fromRGB(255, 255, 255)
xpPopup.Font = Enum.Font.GothamBold
xpPopup.Visible = false
xpPopup.TextTransparency = 1
xpPopup.Parent = screenGui

-- Cinematic GUI Elements
local cinematicLabel = Instance.new("TextLabel")
cinematicLabel.Size = UDim2.new(1, 0, 0.2, 0)
cinematicLabel.Position = UDim2.new(0, 0, 0.4, 0)
cinematicLabel.BackgroundTransparency = 1
cinematicLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
cinematicLabel.TextScaled = true
cinematicLabel.Font = Enum.Font.GothamBlack
cinematicLabel.Text = ""
cinematicLabel.Visible = false
cinematicLabel.Parent = screenGui

-- Taunt Label
local tauntLabel = Instance.new("TextLabel")
tauntLabel.Size = UDim2.new(1, 0, 0.05, 0)
tauntLabel.Position = UDim2.new(0, 0, 0.85, 0)
tauntLabel.BackgroundTransparency = 1
tauntLabel.TextScaled = true
tauntLabel.TextColor3 = Color3.new(1, 0, 0)
tauntLabel.Font = Enum.Font.GothamBlack
tauntLabel.Text = ""
tauntLabel.Visible = false
tauntLabel.Parent = screenGui

local function getColorForPercent(pct)
	if pct > 0.5 then
		return Color3.fromRGB(0, 255, 0)
	elseif pct > 0.25 then
		return Color3.fromRGB(255, 165, 0)
	else
		return Color3.fromRGB(255, 0, 0)
	end
end

HPUpdate.OnClientEvent:Connect(function(currentHP, maxHP, bossName)
	if currentHP and maxHP then
		screenGui.Enabled = true

		local percent = math.clamp(currentHP / maxHP, 0, 1)
		hpLabel.Text = string.format("%d / %d", currentHP, maxHP)
		bossNameLabel.Text = bossName or "Boss"

		local barColor = getColorForPercent(percent)
		hpBar.BackgroundColor3 = barColor

		TweenService:Create(hpBar, TweenInfo.new(0.3), {
			Size = UDim2.new(0.5 * percent, 0, 0.03, 0),
			BackgroundTransparency = 0
		}):Play()
	else
		TweenService:Create(hpBar, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 0, 0.03, 0),
			BackgroundTransparency = 1
		}):Play()
		bossNameLabel.Text = ""
		task.delay(0.4, function()
			screenGui.Enabled = false
		end)
	end
end)

XPGained.OnClientEvent:Connect(function(amount)
	xpPopup.Text = "+" .. tostring(amount) .. " XP"
	xpPopup.Visible = true
	TweenService:Create(xpPopup, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
	task.wait(1.5)
	TweenService:Create(xpPopup, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
	task.wait(0.5)
	xpPopup.Visible = false
end)

-- 🎥 Handle Cinematic Start
StartCinematicCamera.OnClientEvent:Connect(function(bossName, bossInterest)
	screenGui.Enabled = true
	cinematicLabel.Text = bossName .. "\n[" .. bossInterest .. "]"
	cinematicLabel.Visible = true

	TextFXUtils.GlitchPreset(cinematicLabel, "plasma violet")

	task.wait(3)
	cinematicLabel.Visible = false
end)

-- 😈 Handle Boss Taunts
BossTaunt.OnClientEvent:Connect(function(text)
	tauntLabel.Text = text
	tauntLabel.Visible = true

	TextFXUtils.GlitchPreset(tauntLabel, "red electric")

	task.delay(3, function()
		tauntLabel.Visible = false
	end)
end)
