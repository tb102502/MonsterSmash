local CrankyCinematicHandler = {}

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VFX = require(script.Parent.Parent.VFXHandlers:WaitForChild("CrankyVFXHandler"))

function CrankyCinematicHandler.PlayBossIntro(player, bossName, bossInterest, roundNumber, boss)
	local surgicalTable = Workspace:FindFirstChild("SurgicalTable")
	local cameraFocusPart = Workspace:FindFirstChild("CrankyCameraFocus")
	local headEnd = surgicalTable and surgicalTable:FindFirstChild("HeadPosition")

	if not (boss and boss.PrimaryPart and headEnd) then
		warn("⚠️ Missing boss model, PrimaryPart, or HeadPosition!")
		return
	end

	local pos = headEnd.Position + Vector3.new(0, 2, 0)
	local right = headEnd.CFrame.RightVector
	local up = -headEnd.CFrame.LookVector
	local back = right:Cross(up)
	boss:SetPrimaryPartCFrame(CFrame.fromMatrix(pos, right, up, back))

	if roundNumber > 1 then
		local explode = Instance.new("Explosion")
		explode.Position = boss:GetPivot().Position
		explode.BlastRadius = 6
		explode.BlastPressure = 0
		explode.DestroyJointRadiusPercent = 0
		explode.Parent = workspace
		task.wait(2)
	end

	VFX.LightningStrike(cameraFocusPart.Position + Vector3.new(0, 10, 0))
	local lightningSound1 = Instance.new("Sound")
	lightningSound1.SoundId = "rbxassetid://6734393210"
	lightningSound1.Volume = 1
	lightningSound1.Parent = boss.PrimaryPart
	lightningSound1:Play()
	task.wait(2)

	local humanoid = boss:FindFirstChildWhichIsA("Humanoid")
	local animator = humanoid and (humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid))

	if roundNumber == 1 and animator then
		local twitchAnim = Instance.new("Animation")
		twitchAnim.AnimationId = "rbxassetid://96222805183426"

		local attackAnim = Instance.new("Animation")
		attackAnim.AnimationId = "rbxassetid://83761091636986"

		local sitUpAnim = Instance.new("Animation")
		sitUpAnim.AnimationId = "rbxassetid://106752399841437"

		local twitch1 = animator:LoadAnimation(twitchAnim)
		local twitch2 = animator:LoadAnimation(twitchAnim)
		local attack = animator:LoadAnimation(attackAnim)
		local situp = animator:LoadAnimation(sitUpAnim)
		twitch1:Play()
		twitch1.Stopped:Wait()
		task.wait(2)

		VFX.LightningStrike(cameraFocusPart.Position + Vector3.new(0, 10, 0))
		local lightningSound2 = Instance.new("Sound")
		lightningSound2.SoundId = "rbxassetid://6734393210"
		lightningSound2.Volume = 1
		lightningSound2.Parent = boss.PrimaryPart
		lightningSound2:Play()
		task.wait(2)

		twitch2:Play()
		twitch2.Stopped:Wait()
		task.wait(2)

		VFX.LightningStrike(cameraFocusPart.Position + Vector3.new(0, 10, 0))
		local lightningSound3 = Instance.new("Sound")
		lightningSound3.SoundId = "rbxassetid://6734393210"
		lightningSound3.Volume = 1
		lightningSound3.Parent = boss.PrimaryPart
		lightningSound3:Play()
		task.wait(2)

		situp:Play()
		situp:AdjustSpeed(0.33)
		situp.Stopped:Wait()
		task.wait(2)

		VFX.LightningStrike(cameraFocusPart.Position + Vector3.new(0, 10, 0))
		local lightningSound3 = Instance.new("Sound")
		lightningSound3.SoundId = "rbxassetid://6734393210"
		lightningSound3.Volume = 1
		lightningSound3.Parent = boss.PrimaryPart
		lightningSound3:Play()
		task.wait(2)

		attack:Play()
		task.wait(2)
	end

	local flash = surgicalTable:FindFirstChild("FlashLight")
	if flash then
		flash.Enabled = true
		task.delay(0.2, function() flash.Enabled = false end)
	end

	local steam = surgicalTable:FindFirstChild("SteamEmitter")
	if steam then steam:Emit(40) end

	local zap = surgicalTable:FindFirstChild("ZapEmitter")
	if zap then zap:Emit(20) end

	local groan = Instance.new("Sound")
	groan.SoundId = "rbxassetid://95591849816350"
	groan.Volume = 3
	groan.Parent = boss.PrimaryPart
	groan:Play()

	local tween = TweenService:Create(boss.PrimaryPart, TweenInfo.new(2, Enum.EasingStyle.Sine), {
		CFrame = headEnd.CFrame
	})

	for _, part in ipairs(surgicalTable:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HeadPosition" then
			part.Transparency = 1
			for _, decal in ipairs(part:GetDescendants()) do
				if decal:IsA("Decal") then
					decal.Transparency = 1
				end
			end
		end
	end

	tween:Play()
	tween.Completed:Wait()
end

return CrankyCinematicHandler
