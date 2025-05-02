local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ServerScriptService = game:GetService("ServerScriptService")
local StartDracCinematicCamera = ReplicatedStorage:WaitForChild("StartDracCinematicCamera")
local FadeFromBlack = ReplicatedStorage:WaitForChild("FadeFromBlack")
local DracVFXHandler = require(ServerScriptService.VFXHandlers:WaitForChild("DracVFXHandler"))

local BossEffects = {}

function BossEffects.PlayBossIntro(player, bossName, interest, round, startPos, endPos, bossModel, vfxHandler, config)


	FadeFromBlack:FireClient(player)
	DracVFXHandler.BatSwarmEffect(startPos)

	task.wait(1)

	assert(bossModel and bossModel:IsA("Model"), "Invalid bossModel")
	assert(bossModel.PrimaryPart, "Boss model missing PrimaryPart!")

	bossModel:SetPrimaryPartCFrame(CFrame.new(startPos))
	local tween = TweenService:Create(
		bossModel.PrimaryPart,
		TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{ CFrame = CFrame.new(endPos) }
	)

	tween:Play()
	tween.Completed:Wait()

	StartDracCinematicCamera:FireClient(player, bossName, interest, round, config.CameraFocus.Position)
end
 
 return BossEffects