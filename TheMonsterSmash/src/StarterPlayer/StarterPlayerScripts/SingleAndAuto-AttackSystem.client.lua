local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)

local attackEvent = ReplicatedStorage:WaitForChild("AttackEvent") -- RemoteEvent for attacks
local autoAttackButton = player:WaitForChild("PlayerGui"):WaitForChild("AutoAttack"):WaitForChild("AutoAttackButton")

local autoAttack = false  -- Tracks auto-attack state
local singleAttacking = false -- Prevents spamming single attack

-- Load swing animation
local swingAnimation = Instance.new("Animation")
swingAnimation.AnimationId = "rbxassetid://84374656073405" -- Replace with your swing animation ID
local swingTrack = animator:LoadAnimation(swingAnimation)

-- 🔥 Play Swing Animation
local function PlaySwingAnimation()
	if swingTrack then
		swingTrack:Play()
	end
end

-- 🎯 Single Attack (Press "F")
local function SingleAttack()
	if singleAttacking or autoAttack then return end -- Prevent spam & disable during auto-attack
	singleAttacking = true
	PlaySwingAnimation() -- Play swing animation
	attackEvent:FireServer() -- Fire attack event to server
	wait(0.5)  -- Cooldown (adjust as needed)
	singleAttacking = false
end
-- 🔥 Auto-Attack Function
local function StartAutoAttack()
	if autoAttack then return end -- Prevent multiple activations
	autoAttack = true
	autoAttackButton.Text = "Auto Attack: ON"
	autoAttackButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green when ON

	while autoAttack do
		PlaySwingAnimation() -- Play swing animation every auto attack
		attackEvent:FireServer() -- Fire attack event to server
		wait(0.5) -- Adjust attack speed
	end
end

local function StopAutoAttack()
	autoAttack = false
	autoAttackButton.Text = "Auto Attack: OFF"
	autoAttackButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red when OFF
end

-- 🖱️ Toggle Auto-Attack via GUI Button (With Color Change)
autoAttackButton.MouseButton1Click:Connect(function()
	if autoAttack then
		StopAutoAttack()
	else
		StartAutoAttack()
	end
end)

-- 🎮 Single Attack when pressing "F"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end  

	if input.KeyCode == Enum.KeyCode.F then
		SingleAttack()
	end
end)