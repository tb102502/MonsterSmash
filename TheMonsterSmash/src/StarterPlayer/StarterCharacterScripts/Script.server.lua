local player = game.Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

while true do
	local speedBoost = player:GetAttribute("SpeedBoost") or 20
	humanoid.WalkSpeed = 16 * speedBoost -- Normal speed is 16
	wait(0.5)
end
