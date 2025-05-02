local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Intro camera points in Workspace
local points = {
	workspace:WaitForChild("IntroCamera1"),
	workspace:WaitForChild("IntroCamera2"),
	workspace:WaitForChild("IntroCamera3")
}

-- UI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CinematicOverlay"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BackgroundTransparency = 0
blackFrame.ZIndex = 10
blackFrame.Parent = screenGui

local logo = Instance.new("TextLabel")
logo.Text = "THE MONSTER SMASH"
logo.Size = UDim2.new(1, 0, 0.2, 0)
logo.Position = UDim2.new(0, 0, 0.4, 0)
logo.TextScaled = true
logo.TextColor3 = Color3.new(1, 1, 1)
logo.BackgroundTransparency = 1
logo.Font = Enum.Font.FredokaOne
logo.TextTransparency = 1
logo.ZIndex = 11
logo.Parent = screenGui

local skipText = Instance.new("TextLabel")
skipText.Text = "Press SPACE to skip"
skipText.Size = UDim2.new(1, 0, 0.05, 0)
skipText.Position = UDim2.new(0, 0, 0.95, 0)
skipText.BackgroundTransparency = 1
skipText.TextColor3 = Color3.new(1, 1, 1)
skipText.Font = Enum.Font.LuckiestGuy
skipText.TextScaled = true
skipText.TextTransparency = 0
skipText.ZIndex = 11
skipText.Parent = screenGui

local topBar = Instance.new("Frame")
topBar.BackgroundColor3 = Color3.new(0, 0, 0)
topBar.Size = UDim2.new(1, 0, 0.1, 0)
topBar.Position = UDim2.new(0, 0, 0, -50)
topBar.ZIndex = 11
topBar.Parent = screenGui

local bottomBar = topBar:Clone()
bottomBar.Position = UDim2.new(0, 0, 1, 50)
bottomBar.Parent = screenGui

-- Music
local music = Instance.new("Sound")
music.SoundId = "rbxassetid://1837467339"
music.Volume = 1
music.Looped = false
music.Parent = workspace

-- UI tween helper
local function fadeUI(element, toTransparency, duration)
	TweenService:Create(element, TweenInfo.new(duration), {
		BackgroundTransparency = toTransparency,
		TextTransparency = toTransparency
	}):Play()
end

local skipRequested = false
-- Smooth camera lerp
local function tweenCamera(fromCFrame, toCFrame, duration)
	local startTime = tick()
	while tick() - startTime < duration do
		if skipRequested then return end
		local alpha = (tick() - startTime) / duration
		camera.CFrame = fromCFrame:Lerp(toCFrame, alpha)
		RunService.RenderStepped:Wait()
	end
	camera.CFrame = toCFrame
end

-- Skip input
local skipRequested = false
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Space then
		skipRequested = true
	end
end)

-- Run cinematic
local function playCinematic()
	camera.CameraType = Enum.CameraType.Scriptable
	music:Play()

	fadeUI(blackFrame, 0, 2) wait(2)
	fadeUI(logo, 0, 1) wait(1.5)

	-- Logo zoom-in
	TweenService:Create(logo, TweenInfo.new(1.5), {
		Size = UDim2.new(1.1, 0, 0.22, 0)
	}):Play()
	fadeUI(logo, 1, 1) wait(1.5)

	-- Bars
	TweenService:Create(topBar, TweenInfo.new(1), { Position = UDim2.new(0, 0, 0, 0) }):Play()
	TweenService:Create(bottomBar, TweenInfo.new(1), { Position = UDim2.new(0, 0, 0.9, 0) }):Play()

	for i = 1, #points - 1 do
		if skipRequested then break end
		tweenCamera(points[i].CFrame, points[i + 1].CFrame, 3)
		wait(0.5)
	end

	-- Outro
	TweenService:Create(topBar, TweenInfo.new(1), { Position = UDim2.new(0, 0, 0, -50) }):Play()
	TweenService:Create(bottomBar, TweenInfo.new(1), { Position = UDim2.new(0, 0, 1, 50) }):Play()
	fadeUI(blackFrame, 1, 2) wait(2.5)

	music:Stop()
	screenGui:Destroy()
	camera.CameraType = Enum.CameraType.Custom
end

playCinematic()
