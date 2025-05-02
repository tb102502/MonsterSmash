-- LocalScript: DracCinematicCamera (StarterPlayerScripts or PlayerScripts)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local StartCinematicCamera = ReplicatedStorage:WaitForChild("StartCinematicCamera")

StartCinematicCamera.OnClientEvent:Connect(function(bossName, interest, roundNumber, camStartPos, bossPart)
	if typeof(camStartPos) ~= "Vector3" or typeof(bossPart) ~= "Instance" or not bossPart:IsA("BasePart") then
		warn("🚫 Invalid bossPart passed to camera.")
		return
	end

	print("📷 DracCinematicCamera: Beginning cinematic follow...")

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.new(camStartPos, bossPart.Position)

	-- Tween to follow boss from above
	local tween = TweenService:Create(camera, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = CFrame.new(bossPart.Position + Vector3.new(0, 10, -15), bossPart.Position)
	})
	tween:Play()
	tween.Completed:Wait()

	wait(2)
	camera.CameraType = Enum.CameraType.Custom
	print("📷 DracCinematicCamera: Cinematic complete.")
end)
