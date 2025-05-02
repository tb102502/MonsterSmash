local DracBossController = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local BossesFolder = ReplicatedStorage:WaitForChild("Bosses")
local DracSpawn = Workspace:WaitForChild("DracSpawn") -- Drac's unique arena spawn
local BossFaceTarget = Workspace:WaitForChild("BossFaceTarget")

local DracCinematicHandler = require(ServerScriptService.CinematicHandlers:WaitForChild("DracCinematicHandler"))
local DracDamageHandler = require(ServerScriptService.DamageHandlers:WaitForChild("DracDamageHandler"))

local BossTaunt = ReplicatedStorage:WaitForChild("BossTaunt")

local currentRound = 0
local MAX_ROUNDS = 5
local fightActive = false
local activeBoss = nil

function DracBossController.IsFightActive()
	return fightActive
end

function DracBossController.GetCurrentRound()
	return currentRound
end

local function fireTauntToAllPlayers(message)
	for _, player in ipairs(Players:GetPlayers()) do
		BossTaunt:FireClient(player, message)
	end
end

local function tryTaunt(boss, tauntName)
	local tauntFolder = boss:FindFirstChild("Taunts")
	if tauntFolder then
		local taunt = tauntFolder:FindFirstChild(tauntName)
		if taunt and taunt:IsA("StringValue") and taunt.Value ~= "" then
			fireTauntToAllPlayers(taunt.Value)
		end
	end
end

function DracBossController.StartRound(player)
	if fightActive then return end
	fightActive = true
	currentRound += 1

	if currentRound > MAX_ROUNDS then
		print("All rounds completed!")
		fightActive = false
		currentRound = 0
		return
	end

	local bossTemplate = BossesFolder:FindFirstChild("Drac")
	if not bossTemplate then
		warn("Drac not found!")
		return
	end

	activeBoss = bossTemplate:Clone()
	activeBoss.Name = "Drac"
	activeBoss.Parent = Workspace

	if not activeBoss.PrimaryPart then
		warn("Drac has no PrimaryPart!")
		return
	end

	-- Set spawn location using DracSpawn
	if DracSpawn and DracSpawn:IsA("BasePart") then
		local startPos = DracSpawn.Position + Vector3.new(0, 10, 0)
		activeBoss:SetPrimaryPartCFrame(CFrame.new(startPos))
	else
		warn("DracSpawn part not found or not valid!")
	end

	local humanoid = activeBoss:FindFirstChildWhichIsA("Humanoid")
	local scaledHealth = 500 * currentRound
	local scaledDamage = 20 * currentRound

	if humanoid then
		humanoid.MaxHealth = scaledHealth
		humanoid.Health = scaledHealth

		humanoid.HealthChanged:Connect(function(health)
			if health <= (scaledHealth / 2) and health > 0 then
				tryTaunt(activeBoss, "LowHealth")
			end
		end)

		humanoid.Died:Connect(function()
			tryTaunt(activeBoss, "Death")
			wait(2)
			fightActive = false
			DracBossController.StartRound(player)
		end)
	end

	-- Assign damage logic
	DracDamageHandler.SetActiveBoss(activeBoss, scaledDamage)

	-- Start cutscene
	tryTaunt(activeBoss, "Intro")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local FadeFromBlack = ReplicatedStorage:WaitForChild("FadeFromBlack")

	local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	FadeFromBlack.OnClientEvent:Connect(function()
		local screenGui = Instance.new("ScreenGui", PlayerGui)
		local frame = Instance.new("Frame", screenGui)

		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 0
		frame.ZIndex = 10

		game:GetService("TweenService"):Create(
			frame,
			TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 1 }
		):Play()

		task.delay(2.5, function()
			screenGui:Destroy()
		end)
	end)
	DracCinematicHandler.PlayBossIntro(player, activeBoss.Name, "Interests: Blood, Bats, Capes", currentRound, SpawnPart.Position)
end

return DracBossController