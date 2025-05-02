-- ServerScriptService.Modules.XPService.lua

local XPService = {}

local Players = game:GetService("Players")
local SaveManager = require(game.ServerScriptService:WaitForChild("SaveManager"))

-- Setup XP in leaderstats if missing
function XPService.SetupLeaderstats(player)
	local stats = player:FindFirstChild("leaderstats") or Instance.new("Folder", player)
	stats.Name = "leaderstats"

	local xp = stats:FindFirstChild("XP") or Instance.new("IntValue")
	xp.Name = "XP"
	xp.Value = 0
	xp.Parent = stats

	-- Automatically queue XP saving when it changes
	xp.Changed:Connect(function(newVal)
		SaveManager.Queue(player, "XPData", "XP", newVal)
	end)
end

-- Load XP from SaveManager (optional use)
function XPService.LoadData(player)
	local stats = player:WaitForChild("leaderstats", 5)
	if not stats then return end

	local xp = stats:FindFirstChild("XP")
	if not xp then return end

	print("✅ XPService: Loaded XP for", player.Name, ":", xp.Value)
end

-- SaveData compatibility stub (flush not needed if queued)
function XPService.SaveData(player)
	SaveManager.FlushPlayer(player)
end

-- Add XP and automatically save it
function XPService.AddXP(player, amount)
	local stats = player:FindFirstChild("leaderstats")
	local xp = stats and stats:FindFirstChild("XP")
	if xp then
		xp.Value += amount
		-- XP is automatically queued due to .Changed
		print("✨", player.Name, "gained", amount, "XP →", xp.Value)
	end
end

-- Optional: Reset XP
function XPService.ResetXP(player)
	local stats = player:FindFirstChild("leaderstats")
	local xp = stats and stats:FindFirstChild("XP")
	if xp then
		xp.Value = 0
	end
end

return XPService
