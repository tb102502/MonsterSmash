local CrankyCinematicHandler = {}

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local CameraFXRemote = ReplicatedStorage:WaitForChild("CameraFXRemote")
local VFX = require(script.Parent.Parent.VFXHandlers:WaitForChild("CrankyVFXHandler"))
local SkipIntroEvent = ReplicatedStorage:WaitForChild("SkipIntroEvent")
local StartCrankyCinematicCamera = ReplicatedStorage:WaitForChild("StartCrankyCinematicCamera")
local StartBossCinematic = ReplicatedStorage:WaitForChild("StartBossCinematic")
local CinematicFinished = ReplicatedStorage:WaitForChild("CinematicFinished")

local skipRequested = false
local activeBosses = {}

local function BeamLightningStrike(targetPart)
	local bolt = Instance.new("Part")
	bolt.Anchored = true
	bolt.CanCollide = false
	bolt.Transparency = 1
	bolt.Size = Vector3.new(1, 1, 1)
	bolt.Position = targetPart.Position + Vector3.new(0, 30, 0)
	bolt.Parent = Workspace

	local a0 = Instance.new("Attachment", bolt)
	local a1 = Instance.new("Attachment", targetPart)

	for i = 1, 3 do
		local beam = Instance.new("Beam")
		beam.Attachment0 = a0
		beam.Attachment1 = a1
		beam.Width0 = 1
		beam.Width1 = 0.5
		beam.Texture = "rbxassetid://447392540"
		beam.TextureSpeed = 5
		beam.LightEmission = 2
		beam.Transparency = NumberSequence.new(0.2)
		beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
		beam.CurveSize0 = math.random(-2, 2)
		beam.CurveSize1 = math.random(-2, 2)
		beam.Parent = bolt
	end

	local sparks = Instance.new("ParticleEmitter")
	sparks.Texture = "rbxassetid://483750004"
	sparks.Lifetime = NumberRange.new(0.3)
	sparks.Speed = NumberRange.new(12, 20)
	sparks.Size = NumberSequence.new(0.5)
	sparks.Parent = targetPart
	sparks:Emit(30)

	local smoke = Instance.new("ParticleEmitter")
	smoke.Texture = "rbxassetid://771221224"
	smoke.Lifetime = NumberRange.new(1.5, 2)
	smoke.Speed = NumberRange.new(3, 5)
	smoke.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 0) })
	smoke.Parent = targetPart
	smoke:Emit(25)

	local flashEvent = ReplicatedStorage:FindFirstChild("ScreenFlashEvent")
	if flashEvent then
		flashEvent:FireAllClients()
	end

	Debris:AddItem(bolt, 1)
	Debris:AddItem(sparks, 1)
	Debris:AddItem(smoke, 1)
end

function CrankyCinematicHandler.PlayBossIntro(player, bossName, bossInterest, roundNumber, boss)
	local hrp = boss:FindFirstChild("HumanoidRootPart")
	local surgicalTable = Workspace:FindFirstChild("SurgicalTable")
	local headEnd = surgicalTable and surgicalTable:FindFirstChild("HeadPosition")
	local arenaCenter = Workspace:FindFirstChild("BossArena") and Workspace.BossArena:FindFirstChild("ArenaCenter")

	skipRequested = false
	activeBosses[player] = boss -- ✅ properly placed

	local skipConn
	skipConn = SkipIntroEvent.OnServerEvent:Connect(function(p, action)
		if p == player and action == "Skip" then
			skipRequested = true
			if hrp then hrp.Anchored = false end
			if _G.EndBossIntro then _G.EndBossIntro() end
			if skipConn then skipConn:Disconnect() end
			if surgicalTable then surgicalTable:Destroy() end
		end
	end)

	if _G.StartBossIntro then
		_G.StartBossIntro(boss)
		for _, p in ipairs(game.Players:GetPlayers()) do
			SkipIntroEvent:FireClient(p, "Show")
		end
	end

	if roundNumber > 1 and hrp and arenaCenter then
		local existingTable = Workspace:FindFirstChild("SurgicalTable")
		if existingTable then
			existingTable:Destroy()
		end

		hrp.Anchored = true
		local spawnPos = arenaCenter.Position + Vector3.new(0, 5, 0)
		local lookAt = Vector3.new(spawnPos.X, spawnPos.Y, spawnPos.Z - 1)
		local uprightCFrame = CFrame.lookAt(spawnPos, lookAt)
		boss:SetPrimaryPartCFrame(uprightCFrame)

		task.delay(0.2, function()
			if hrp then hrp.Anchored = false end
			if _G.EndBossIntro then _G.EndBossIntro() end
		end)

		local boom = Instance.new("Explosion")
		boom.Position = hrp.Position
		boom.BlastRadius = 6
		boom.BlastPressure = 0
		boom.Parent = Workspace
		return
	end

	if not (hrp and headEnd) then
		warn("⚠️ Missing HRP or head position!")
		return
	end

	local pos = headEnd.Position + Vector3.new(0, 0.2, 0)
	local up = Vector3.new(0, 1, 0)
	local back = -headEnd.CFrame.LookVector
	local right = up:Cross(back)
	local layFlat = CFrame.fromMatrix(pos, right, up, back) * CFrame.Angles(math.rad(90), 0, 0)

	hrp.CFrame = layFlat
	hrp.Anchored = true

	task.wait(2)
	if skipRequested then return end
	BeamLightningStrike(hrp)

	local lightningSound = Instance.new("Sound", hrp)
	lightningSound.SoundId = "rbxassetid://6734393210"
	lightningSound.Volume = 1
	lightningSound:Play()

	task.wait(2)
	if skipRequested then return end

	local humanoid = boss:FindFirstChildWhichIsA("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

	if animator then
		-- FIX: Animation IDs were way too long - replaced with proper formatting
		local twitchAnim = Instance.new("Animation")
		twitchAnim.AnimationId = "rbxassetid://96222805183426" -- Fixed ID format
		local sitUpAnim = Instance.new("Animation")
		sitUpAnim.AnimationId = "rbxassetid://106752399841437" -- Fixed ID format
		local attackAnim = Instance.new("Animation")
		attackAnim.AnimationId = "rbxassetid://83761091636986" -- Fixed ID format

		local twitch1 = animator:LoadAnimation(twitchAnim)
		local twitch2 = animator:LoadAnimation(twitchAnim)
		local situp = animator:LoadAnimation(sitUpAnim)
		local attack = animator:LoadAnimation(attackAnim)

		twitch1:Play()
		twitch1.Stopped:Wait()

		if skipRequested then return end
		task.wait(2)
		BeamLightningStrike(hrp)
		lightningSound:Play()

		twitch2:Play()
		twitch2.Stopped:Wait()

		if skipRequested then return end
		task.wait(2)
		BeamLightningStrike(hrp)
		lightningSound:Play()

		situp:Play()
		situp:AdjustSpeed(0.4)
		situp.Stopped:Wait()

		if skipRequested then return end
		task.wait(1)
		BeamLightningStrike(hrp)
		lightningSound:Play()
		CameraFXRemote:FireAllClients("Shake", 3, 0.4)

		local heartbeat = Instance.new("Sound", hrp)
		heartbeat.SoundId = "rbxassetid://7188240609"
		heartbeat.Volume = 1
		heartbeat.Looped = true
		heartbeat:Play()

		attack:Play()

		task.delay(1, function()
			if hrp then hrp.Anchored = false end
			local groan = Instance.new("Sound", hrp)
			groan.SoundId = "rbxassetid://95591849816350" -- Fixed ID format
			groan.Volume = 3
			groan:Play()
		end)

		-- Fade and destroy surgical table
		task.delay(1, function()
			if surgicalTable then
				for _, part in ipairs(surgicalTable:GetDescendants()) do
					if part:IsA("BasePart") then
						TweenService:Create(part, TweenInfo.new(1), { Transparency = 1 }):Play()
					end
				end

				-- Wait for fade-out of table
				task.delay(1.5, function()
					surgicalTable:Destroy()

					-- FIX: Fire the CinematicFinished event AFTER the fadeout
					-- This notifies the client that the intro is done and to show the GUI
					for _, p in ipairs(game.Players:GetPlayers()) do
						CinematicFinished:FireClient(p)
					end

					-- FIX: We don't want any more fade-outs here, as it blocks the GUI
					-- task.wait(4.5)
					if _G.EndBossIntro then _G.EndBossIntro() end
				end)
			end
		end)
	end		
end

-- FIX: Changed the connection to receive from client and then handle boss GUI
-- Now the client signals when ready for GUI and taunts
CinematicFinished.OnServerEvent:Connect(function(player)
	local bossClone = activeBosses[player]
	if not bossClone then
		warn("❌ No active boss for player:", player.Name)
		return
	end

	local roundNumber = bossClone:GetAttribute("Round") or 1
	local health = bossClone:GetAttribute("HP") or 300
	local damage = bossClone:GetAttribute("DMG") or 25
	local bossName = bossClone:GetAttribute("BossName") or "Crankystein"
	local bossInterest = "Sleeping, Electricity, Cereal"
	local cameraFocus = Workspace:FindFirstChild("CrankyCameraFocus")

	if not cameraFocus then
		warn("❌ Missing CrankyCameraFocus in workspace!")
		return
	end

	-- FIX: Removed the fade event here as it was blocking the GUI
	-- Fire server event to prepare boss for combat
	StartBossCinematic:FireServer(bossClone, roundNumber)

	-- FIX: Added brief delay before starting cinematic camera to ensure timing
	task.delay(0.2, function()
		StartCrankyCinematicCamera:FireClient(player, bossName, bossInterest, roundNumber, cameraFocus.Position, health, damage)
		print("✅ Cranky intro + taunts started for", player.Name)
	end)
end)

return CrankyCinematicHandler

