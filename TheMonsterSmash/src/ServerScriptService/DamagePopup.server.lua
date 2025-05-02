-- ServerScript (BossController or related script)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local damagePopupEvent = ReplicatedStorage:WaitForChild("DamagePopupEvent")  -- RemoteEvent for damage popup

-- Example of handling damage dealt to the boss
local function onPlayerClickBoss(player, damageAmount)
	-- Trigger the damage popup on the client
	damagePopupEvent:FireClient(player, damageAmount)

	-- Handle boss health reduction (make sure the boss is set up correctly)
	local boss = workspace:FindFirstChild("CurrentBoss")  -- Make sure this is your current boss object
	if boss then
		local humanoid = boss:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(damageAmount)
		end
	end
end

-- Example of player clicking the boss (can be triggered by click event or other logic)
-- Assuming you have a way to detect clicks, like this:
game.ReplicatedStorage.ClickEvent.OnServerEvent:Connect(function(player)
	-- Assume damage is based on player's click
	local damageAmount = 10  -- Example damage (can be based on click multiplier or other factors)
	onPlayerClickBoss(player, damageAmount)
end)

