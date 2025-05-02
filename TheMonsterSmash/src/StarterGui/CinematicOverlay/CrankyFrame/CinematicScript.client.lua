
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local StartCrankyCinematicCamera = ReplicatedStorage:WaitForChild("StartCrankyCinematicCamera")
local TextFXUtils = require(ReplicatedStorage.Modules:WaitForChild("TextFXUtils"))
local CountdownEvent = ReplicatedStorage:WaitForChild("StartRoundCountdown") -- for countdown reuse
local fadeEvent = ReplicatedStorage:WaitForChild("ScreenFadeEvent")
local CinematicFinished = ReplicatedStorage:WaitForChild("CinematicFinished")

-- UI Elements
local overlay = player:WaitForChild("PlayerGui"):WaitForChild("CinematicOverlay")
local frame = overlay:WaitForChild("CrankyFrame")
local bossNameLabel = frame:WaitForChild("BossName")
local bossInterestLabel = frame:WaitForChild("BossInterest")
local healthLabel = frame:WaitForChild("HealthLabel")
local damageLabel = frame:WaitForChild("DamageLabel")

-- FIX: Add a round label to show which round it is
local roundLabel = frame:FindFirstChild("RoundLabel") or Instance.new("TextLabel")
roundLabel.Name = "RoundLabel"
roundLabel.Size = UDim2.new(1, 0, 0.1, 0)
roundLabel.Position = UDim2.new(0, 0, 0.65, 0)
roundLabel.BackgroundTransparency = 1
roundLabel.TextColor3 = Color3.new(1, 1, 0)
roundLabel.Font = Enum.Font.LuckiestGuy
roundLabel.TextScaled = true
roundLabel.Visible = false
roundLabel.ZIndex = 999
roundLabel.Parent = frame

-- Countdown Label
local countdownLabel = frame:FindFirstChild("CountdownLabel") or Instance.new("TextLabel")
countdownLabel.Name = "CountdownLabel"
countdownLabel.Size = UDim2.new(1, 0, 0.3, 0)
countdownLabel.Position = UDim2.new(0, 0, 0.35, 0)
countdownLabel.BackgroundTransparency = 1
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Font = Enum.Font.LuckiestGuy
countdownLabel.TextScaled = true
countdownLabel.Visible = false
countdownLabel.ZIndex = 999
countdownLabel.Parent = frame

local function typewriter(label, fullText, delay)
	label.Text = ""
	label.Visible = true
	for i = 1, #fullText do
		label.Text = string.sub(fullText, 1, i)
		task.wait(delay)
	end
end

local function showCountdown()
	local countdown = 3
	countdownLabel.Visible = true
	for i = countdown, 1, -1 do
		countdownLabel.Text = tostring(i)
		task.wait(1)
	end
	countdownLabel.Text = "FIGHT!"
	task.wait(1)
	countdownLabel.Visible = false

	-- FIX: Tell server that countdown is complete
	-- This ensures the server knows when to start the boss AI
	ReplicatedStorage:WaitForChild("CountdownComplete"):FireServer()
end

StartCrankyCinematicCamera.OnClientEvent:Connect(function(bossName, bossInterest, roundNumber, focusPosition, health, damage)
	print("🎬 Cranky cinematic UI triggered for:", bossName)

	-- FIX: Make sure frame is visible before any effects or fades
	frame.Visible = true
	frame.BackgroundTransparency = 0.3

	-- FIX: If there's a fade, ensure we fade IN only
	if fadeEvent then
		fadeEvent:Fire("In", 0.5)
	end

	-- Reset all UI elements first
	for _, label in pairs({ bossNameLabel, bossInterestLabel, healthLabel, damageLabel, countdownLabel, roundLabel }) do
		label.Visible = false
	end

	-- Set the camera position
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.new(focusPosition + Vector3.new(0, 2, 0)) * CFrame.Angles(0, math.rad(30), 0)

	-- Fire server event to notify we're ready to show the full UI
	task.wait(0.5)
	CinematicFinished:FireServer()

	-- Show boss info with proper typing effect
	typewriter(bossNameLabel, bossName, 0.05)
	typewriter(bossInterestLabel, bossInterest, 0.04)

	-- Show stats immediately
	healthLabel.Text = "HP: " .. tostring(health)
	damageLabel.Text = "DMG: " .. tostring(damage)

	-- FIX: Show round number prominently
	if roundNumber > 1 then
		roundLabel.Text = "ROUND " .. tostring(roundNumber)
		roundLabel.Visible = true
		TextFXUtils.GlitchPreset(roundLabel, "plasma violet")
	end

	-- Make all elements visible
	bossNameLabel.Visible = true
	bossInterestLabel.Visible = true
	healthLabel.Visible = true
	damageLabel.Visible = true

	-- Apply special text effects
	TextFXUtils.GlitchPreset(bossNameLabel, "red electric")
	TextFXUtils.GlitchPreset(bossInterestLabel, "cyber blue")
	TextFXUtils.GlitchPreset(healthLabel, "plasma violet")
	TextFXUtils.GlitchPreset(damageLabel, "cyber blue")

	-- Wait before showing countdown
	task.wait(2)

	-- Show countdown (3..2..1..FIGHT!)
	showCountdown()

	-- Clean up UI after countdown
	for _, label in pairs({ bossNameLabel, bossInterestLabel, healthLabel, damageLabel, roundLabel }) do
		label.Visible = false
	end

	-- Fade out UI frame
	TweenService:Create(frame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
	task.wait(0.5)

	-- Return to normal camera
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
	frame.Visible = false
end)
