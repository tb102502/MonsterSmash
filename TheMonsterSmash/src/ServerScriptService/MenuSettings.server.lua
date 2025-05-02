local DataStoreService = game:GetService("DataStoreService")
local settingsStore = DataStoreService:GetDataStore("PlayerSettings")

game.Players.PlayerAdded:Connect(function(player)
	local playerKey = "Player_" .. player.UserId

	-- Create leaderstats for settings
	local settingsFolder = Instance.new("Folder")
	settingsFolder.Name = "Settings"
	settingsFolder.Parent = player

	-- Default values
	local volume = Instance.new("IntValue")
	volume.Name = "Volume"
	volume.Value = 50
	volume.Parent = settingsFolder

	local graphics = Instance.new("IntValue")
	graphics.Name = "Graphics"
	graphics.Value = 50
	graphics.Parent = settingsFolder

	local sensitivity = Instance.new("IntValue")
	sensitivity.Name = "Sensitivity"
	sensitivity.Value = 50
	sensitivity.Parent = settingsFolder

	-- Load saved data
	local success, savedData = pcall(function()
		return settingsStore:GetAsync(playerKey)
	end)

	if success and savedData then
		volume.Value = savedData.Volume or 50
		graphics.Value = savedData.Graphics or 50
		sensitivity.Value = savedData.Sensitivity or 50
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local playerKey = "Player_" .. player.UserId

	local settingsData = {
		Volume = player:FindFirstChild("Settings") and player.Settings.Volume.Value or 50,
		Graphics = player:FindFirstChild("Settings") and player.Settings.Graphics.Value or 50,
		Sensitivity = player:FindFirstChild("Settings") and player.Settings.Sensitivity.Value or 50
	}

	pcall(function()
		settingsStore:SetAsync(playerKey, settingsData)
	end)
end)

