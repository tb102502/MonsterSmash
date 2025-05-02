local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- RemoteEvent for click
local ClickEvent = ReplicatedStorage:FindFirstChild("ClickEvent")
if not ClickEvent then
	ClickEvent = Instance.new("RemoteEvent")
	ClickEvent.Name = "ClickEvent"
	ClickEvent.Parent = ReplicatedStorage
end

-- Variables to track active boss
local currentBoss = nil

-- BossController can set the boss reference
ReplicatedStorage:WaitForChild("SetCurrentBoss").OnServerEvent:Connect(function(_, boss)
	currentBoss = boss
end)

ClickEvent.OnServerEvent:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local coins = leaderstats and leaderstats:FindFirstChild("Coins")
	local coinMultiplier = leaderstats and leaderstats:FindFirstChild("CoinMultiplier")

	if coins and coinMultiplier then
		-- 🛠️ Base coin reward per click
		local baseCoins = 1
		local finalMultiplier = coinMultiplier.Value

		-- 🎯 Critical Coin Click System
		local critChance = 0.05 -- 5% chance
		local critMultiplier = 5 -- 5x bonus

		if math.random() < critChance then
			-- 🔥 Critical hit! Increase the multiplier
			finalMultiplier = finalMultiplier * critMultiplier

			-- (Optional) Fire a crit popup effect if you have a CritPopupEvent
			local critPopupEvent = ReplicatedStorage:FindFirstChild("CritPopupEvent")
			if critPopupEvent then
				critPopupEvent:FireClient(player)
			end
		end

		-- ✅ Add coins
		coins.Value += baseCoins * finalMultiplier
	end

	-- 🧠 Apply damage if a boss is active
	if currentBoss and currentBoss:FindFirstChild("Humanoid") then
		local damage = player:GetAttribute("TapBoss")
		if damage then
			currentBoss.Humanoid:TakeDamage(damage)

			-- Fire popup effect
			local showDamage = ReplicatedStorage:FindFirstChild("DamagePopupEvent")
			if showDamage then
				showDamage:FireClient(player, currentBoss.HumanoidRootPart.Position, damage)
			end
		end
	end
end)
