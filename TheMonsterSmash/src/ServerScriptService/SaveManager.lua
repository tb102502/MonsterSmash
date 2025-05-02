-- ServerScriptService/SaveManager.lua

local DataStoreService = game:GetService("DataStoreService")

local SaveManager = {}

local SAVE_INTERVAL = 30
local SaveQueue = {} -- SaveQueue[player] = { [dataStoreName] = { key = value } }

-- Helper: ensure table exists
local function getPlayerStore(player, dataStoreName)
	SaveQueue[player] = SaveQueue[player] or {}
	SaveQueue[player][dataStoreName] = SaveQueue[player][dataStoreName] or {}
	return SaveQueue[player][dataStoreName]
end

-- Queue a save for any stat or key
function SaveManager.Queue(player, dataStoreName, key, value)
	local store = getPlayerStore(player, dataStoreName)
	store[key] = value
end

-- Flush all saves for a player
function SaveManager.FlushPlayer(player)
	local playerSaves = SaveQueue[player]
	if not playerSaves then return end

	for storeName, keyMap in pairs(playerSaves) do
		local store = DataStoreService:GetDataStore(storeName)
		for key, value in pairs(keyMap) do
			local success, err = pcall(function()
				store:SetAsync(player.UserId .. "_" .. key, value)
			end)
			if not success then
				warn("❌ Failed to save", storeName, key, "for", player.Name, err)
			end
		end
	end

	SaveQueue[player] = nil
end

-- Periodic auto-save
task.spawn(function()
	while true do
		task.wait(SAVE_INTERVAL)
		for player in pairs(SaveQueue) do
			SaveManager.FlushPlayer(player)
		end
	end
end)

return SaveManager

