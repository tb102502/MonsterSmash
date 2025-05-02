local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SkipIntroEvent = ReplicatedStorage:WaitForChild("SkipIntroEvent")

-- Store reference to the current boss and intro state
local currentBoss = nil
local introInProgress = false

-- Function for CrankyCinematicHandler or BossManager to call when intro starts
function _G.StartBossIntro(boss)
	currentBoss = boss
	introInProgress = true
end

-- Function for CrankyCinematicHandler to call when intro finishes normally
function _G.EndBossIntro()
	currentBoss = nil
	introInProgress = false
end

-- Player clicks Skip button
SkipIntroEvent.OnServerEvent:Connect(function(player, action)
	if action == "Skip" and introInProgress and currentBoss then
		print(player.Name .. " skipped the intro!")

		-- 🛑 Force end intro
		introInProgress = false

		local humanoidRoot = currentBoss:FindFirstChild("HumanoidRootPart")
		if humanoidRoot then
			humanoidRoot.Anchored = false
		end

		-- OPTIONAL: stop animations, sounds if needed

		-- Hide skip button on client
		for _, p in ipairs(game.Players:GetPlayers()) do
			SkipIntroEvent:FireClient(p, "Hide")
		end


		-- Let fight proceed immediately
	end
end)
