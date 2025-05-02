local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local StartCrankyFightEvent = ReplicatedStorage:WaitForChild("StartCrankyFightEvent")
local StartCrankyCinematicCamera = ReplicatedStorage:WaitForChild("StartCrankyCinematicCamera")
local StartBossCinematic = ReplicatedStorage:WaitForChild("StartBossCinematic")
local CinematicFinished = ReplicatedStorage:WaitForChild("CinematicFinished")
local BossTemplates = ReplicatedStorage:WaitForChild("Bosses")

-- Track player-boss state
local activeBosses = {}

-- Step 1: Player clicks "Start Fight" button
StartCrankyFightEvent.OnServerEvent:Connect(function(player)
	local crankyTemplate = BossTemplates:FindFirstChild("Cranky")
	if not crankyTemplate then
		warn("❌ Cranky not found in ReplicatedStorage.Bosses!")
		return
	end

	local bossClone = crankyTemplate:Clone()
	bossClone.Name = "Cranky_Active"
	bossClone.Parent = Workspace

	-- Optional: Move him into the scene
	bossClone:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 5, 0))) -- Update to match your table position

	-- Store this boss for the player
	activeBosses[player] = bossClone
end)
