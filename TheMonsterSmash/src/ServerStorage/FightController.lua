-- Module: FightController.lua (example location)

local Players = game:GetService("Players")

local function lockCharacterMovement(character: Model)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoidRootPart then
		humanoidRootPart.Anchored = true
	end

	if humanoid then
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.AutoRotate = false
	end
end

local function unlockCharacterMovement(character: Model)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoidRootPart then
		humanoidRootPart.Anchored = false
	end

	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
		humanoid.AutoRotate = true
	end
end

-- Example: Lock player and boss at start
local function startBossFight(player: Player, bossModel: Model)
	local playerChar = player.Character
	if playerChar then
		lockCharacterMovement(playerChar)
	end
	if bossModel then
		lockCharacterMovement(bossModel)
	end

	-- TODO: Trigger fight mechanics here...

	-- Call unlockCharacterMovement(...) after fight ends
end

return {
	StartFight = startBossFight,
	Unlock = unlockCharacterMovement,
}
