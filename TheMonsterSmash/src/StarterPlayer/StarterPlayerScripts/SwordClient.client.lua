print("✅ SwordClient running")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local SwingState = require(script.Parent:WaitForChild("SwingState"))

local function waitForTool()
	local character = player.Character or player.CharacterAdded:Wait()
	local tool = character:FindFirstChild("SwordTool")
	if tool then return tool end
	return player:WaitForChild("Backpack"):WaitForChild("SwordTool")
end

local tool = waitForTool()
print("🗡️ Tool found:", tool.Name)

-- Tool internals
local animObj = tool:WaitForChild("SwingAnimation")
local swingSound = tool:FindFirstChild("SwingSound")
local hitSound = tool:FindFirstChild("SwordHit")
local trail = tool:FindFirstChild("Trail")
local slashEffect = tool:FindFirstChild("SlashEffect")

local SwordAttack = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("SwordAttack")
local SwordSwingFX = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("SwordSwingFX")

-- === Helpers ===
local function playSound(sound)
	if sound then sound:Play() end
end

local function playVFX()
	if trail then
		trail.Enabled = true
		task.delay(0.3, function()
			trail.Enabled = false
		end)
	end
	if slashEffect then
		slashEffect:Emit(20)
	end
end

local function screenShake(intensity, duration)
	local original = camera.CFrame
	for i = 1, duration do
		camera.CFrame = original * CFrame.new(
			math.random(-1, 1) * intensity,
			math.random(-1, 1) * intensity,
			math.random(-1, 1) * intensity
		)
		task.wait(0.02)
	end
	camera.CFrame = original
end

-- === Main Attack Logic ===
tool.Activated:Connect(function()
	print("⚔️ Swing triggered!")

	if not SwingState:Get() then
		print("⛔ Can't swing yet — waiting for countdown!")
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("No humanoid found!")
		return
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local track = animator:LoadAnimation(animObj)
	track:Play()

	playSound(swingSound)
	playVFX()

	SwordAttack:FireServer()
end)

-- === Server-Triggered Hit FX ===
SwordSwingFX.OnClientEvent:Connect(function(hitPosition)
	print("💥 SwordSwingFX fired on client!")
	screenShake(0.2, 5)
	playSound(hitSound)
end)
