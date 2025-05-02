while true do
	for _, player in pairs(game.Players:GetPlayers()) do
		local character = player.Character
		local humanoid = character and character:FindFirstChild("Humanoid")
		local regen = player:GetAttribute("HealthRegen") or 0

		if humanoid and humanoid.Health < humanoid.MaxHealth and regen > 0 then
			humanoid.Health = math.min(humanoid.Health + regen, humanoid.MaxHealth)
		end
	end
	wait(1) -- Apply regeneration every second
end

