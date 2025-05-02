-- StarterPlayerScripts | CinematicCamera.client.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local StartCinematicCamera = ReplicatedStorage:WaitForChild("StartCinematicCamera")

StartCinematicCamera.OnClientEvent:Connect(function(data)
	local bossName = data.bossName
	local round = data.round
	local camStartPos = data.camStartPos
	local camEndPos = data.camEndPos

	if not camStartPos or not camEndPos then
		warn("🚫 Invalid camera positions received — camStartPos:", tostring(camStartPos), "camEndPos:", tostring(camEndPos))
		return
	end

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.lookAt(camStartPos, camEndPos)

	local finalCFrame = CFrame.lookAt(camEndPos + Vector3.new(0, 5, -12), camEndPos)

	local tween = TweenService:Create(camera, TweenInfo.new(3, Enum.EasingStyle.Sine), {
		CFrame = finalCFrame
	})
	tween:Play()
	tween.Completed:Wait()

	task.wait(2)
	camera.CameraType = Enum.CameraType.Custom
end)
