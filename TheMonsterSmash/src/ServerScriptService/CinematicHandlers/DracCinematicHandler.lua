-- ServerScriptService/CinematicHandlers/DracCinematicHandler.lua

local DracCinematicHandler = {}

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DracVFX = require(script.Parent.Parent.VFXHandlers:WaitForChild("DracVFXHandler"))
local StartCinematicCamera = ReplicatedStorage:WaitForChild("StartCinematicCamera")
local FadeFromBlack = ReplicatedStorage:WaitForChild("FadeFromBlack")
local TrackCinematicTarget = ReplicatedStorage:WaitForChild("TrackCinematicTarget")

function DracCinematicHandler.PlayIntro(bossModel)
	print("🦇 Drac is floating down...")

	local player = Players:GetPlayers()[1]
	if not player or not bossModel or not bossModel.PrimaryPart then
		warn("DracCinematicHandler: Missing valid player or boss model")
		return
	end

	-- Fade and Setup
	FadeFromBlack:FireClient(player)

	local dracSpawn = workspace:WaitForChild("DracSpawn") -- or "DracSpawnFloat" if that’s where he hovers first

	-- safer Z+Y offset
	local startPos = dracSpawn.Position + Vector3.new(0, 30, 0)

	local endPos = bossModel.PrimaryPart.Position + Vector3.new(0, 8, 0)

	bossModel:SetPrimaryPartCFrame(CFrame.new(startPos))


	-- Camera follows target during float
	print("📍 Sending camera with:", bossModel.PrimaryPart.Name, bossModel.PrimaryPart.Name)
	TrackCinematicTarget:FireClient(player, bossModel.PrimaryPart)

	-- Bat Effect
	local spawnPos = bossModel.PrimaryPart.Position + Vector3.new(0, 10, 0)
	DracVFX.BatSwarmEffect(spawnPos)
	DracVFX.BatSwirlLoopAround(bossModel)

	-- Tween Drac Down
	local tween = TweenService:Create(
		bossModel.PrimaryPart,
		TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{ CFrame = CFrame.new(endPos) }
	)

	tween:Play()
	tween.Completed:Wait()

	print("🧛 Drac landed.")
end

return DracCinematicHandler
