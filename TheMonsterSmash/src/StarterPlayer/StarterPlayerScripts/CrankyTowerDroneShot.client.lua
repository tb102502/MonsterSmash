local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local StartBossCamera = ReplicatedStorage:WaitForChild("StartBossCamera")

-- Define camera targets
local bottomPart = workspace:WaitForChild("TowerBottom")
local topPart = workspace:WaitForChild("TowerTop")

local function playDroneShot()
	camera.CameraType = Enum.CameraType.Scriptable

	local startCFrame = CFrame.new(bottomPart.Position + Vector3.new(0, 5, -10), bottomPart.Position)
	local endCFrame = CFrame.new(topPart.Position + Vector3.new(0, 5, -10), topPart.Position)

	camera.CFrame = startCFrame

	local tweenInfo = TweenInfo.new(
		5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out
	)

	local goal = {CFrame = endCFrame}
	local tween = TweenService:Create(camera, tweenInfo, goal)
	tween:Play()

	tween.Completed:Connect(function()
		wait(1)
		camera.CameraType = Enum.CameraType.Custom
	end)
end

-- Listen for the remote event
StartBossCamera.OnClientEvent:Connect(playDroneShot)
