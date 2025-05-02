local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BossTaunt = ReplicatedStorage:WaitForChild("BossTaunt") -- RemoteEvent to client

-- Helper: Fire taunt to all players
local function fireTauntToAllPlayers(message)
	for _, player in ipairs(Players:GetPlayers()) do
		BossTaunt:FireClient(player, message)
	end
end

-- Trigger a taunt based on the round number (StartRound1, StartRound2, etc.)
local function fireRoundTaunt(boss, roundNumber)
	local tauntFolder = boss:FindFirstChild("Taunts")
	if tauntFolder then
		local roundTaunt = tauntFolder:FindFirstChild("StartRound" .. tostring(roundNumber))
		if roundTaunt and roundTaunt.Value ~= "" then
			fireTauntToAllPlayers(roundTaunt.Value)
		end
	end
end

-- Watch for low health and trigger taunt
local function monitorHealthChanges(boss)
	local humanoid = boss:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.HealthChanged:Connect(function(health)
			if health <= 50 then
				local tauntFolder = boss:FindFirstChild("Taunts")
				if tauntFolder then
					local lowHealthTaunt = tauntFolder:FindFirstChild("LowHealth")
					if lowHealthTaunt and lowHealthTaunt.Value ~= "" then
						fireTauntToAllPlayers(lowHealthTaunt.Value)
					end
				end
			end
		end)
	end
end

-- Watch for boss death and fire death taunt
local function monitorDeath(boss)
	local humanoid = boss:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			local tauntFolder = boss:FindFirstChild("Taunts")
			if tauntFolder then
				local deathTaunt = tauntFolder:FindFirstChild("Death")
				if deathTaunt and deathTaunt.Value ~= "" then
					fireTauntToAllPlayers(deathTaunt.Value)
				end
			end
		end)
	end
end

-- Random mid-fight taunts every 10–20 seconds
local function startMidFightTaunts(boss)
	local tauntFolder = boss:FindFirstChild("Taunts")
	if not tauntFolder then return end

	local midFightTaunts = {}
	for _, taunt in ipairs(tauntFolder:GetChildren()) do
		if taunt:IsA("StringValue") and string.find(taunt.Name, "MidFight") then
			table.insert(midFightTaunts, taunt)
		end
	end

	if #midFightTaunts == 0 then return end

	task.spawn(function()
		while boss.Parent and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 do
			wait(math.random(10, 20))
			local chosen = midFightTaunts[math.random(1, #midFightTaunts)]
			if chosen and chosen.Value ~= "" then
				fireTauntToAllPlayers(chosen.Value)
			end
		end
	end)
end

-- Called externally to start taunts for a new round
local function initializeBossTaunts(boss, roundNumber)
	if not boss then return end

	fireRoundTaunt(boss, roundNumber)
	monitorHealthChanges(boss)
	monitorDeath(boss)
	startMidFightTaunts(boss)
end

-- Bind to RemoteEvent (optional if you want this fired externally)
local StartBossCinematic = ReplicatedStorage:WaitForChild("StartBossCinematic")
StartBossCinematic.OnServerEvent:Connect(function(player, boss, roundNumber)
	initializeBossTaunts(boss, roundNumber)
end)

-- Optional: Expose the function globally (if using ModuleScript instead)
_G.InitializeBossTaunts = initializeBossTaunts
