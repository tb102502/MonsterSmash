-- ServerScriptService/LoadManager.lua

local DataStoreService = game:GetService("DataStoreService")

local LoadManager = {}

-- Load a value safely with fallback
function LoadManager.Load(player, dataStoreName, key, defaultValue)
	local dataStore = DataStoreService:GetDataStore(dataStoreName)
	local fullKey = player.UserId .. "_" .. key

	local success, result = pcall(function()
		return dataStore:GetAsync(fullKey)
	end)

	if success and result ~= nil then
		return result
	else
		if not success then
			warn("⚠️ Failed to load", dataStoreName, key, "for", player.Name, result)
		end
		return defaultValue
	end
end

-- Optional: Load multiple keys at once
function LoadManager.LoadMany(player, dataStoreName, keyTable)
	local result = {}
	for _, key in ipairs(keyTable) do
		result[key] = LoadManager.Load(player, dataStoreName, key, nil)
	end
	return result
end

return LoadManager
