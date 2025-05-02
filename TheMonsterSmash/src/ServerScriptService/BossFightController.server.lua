local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local SwordName = "SwordTool" -- ⚔️ Name of your sword tool (adjust if needed)

local function LockPlayer(player)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
	end
end

local function UnlockPlayer(player)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16 -- Default Roblox WalkSpeed
		humanoid.JumpPower = 50 -- Default Roblox JumpPower
	end
end

local function AutoEquipSword(player)
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character

	if backpack and character then
		local hasSwordEquipped = character:FindFirstChild(SwordName)
		local swordInBackpack = backpack:FindFirstChild(SwordName)

		if not hasSwordEquipped and swordInBackpack then
			swordInBackpack.Parent = character
		end
	end
end

-- 💥 Call this when Boss Fight begins
function BeginBossFight(player)
	LockPlayer(player)
	AutoEquipSword(player)

	-- Optional small delay for camera zoom or intro music
	task.wait(3) -- Your cinematic length
	UnlockPlayer(player)
end

-- Example Usage:
Players.PlayerAdded:Connect(function(player)
	-- Hook to whatever triggers the fight for your player
	ReplicatedStorage:WaitForChild("StartBossFightEvent").OnServerEvent:Connect(function(plr)
		if plr == player then
			BeginBossFight(player)
		end
	end)
end)
