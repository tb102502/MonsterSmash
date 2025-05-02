local DracDamageHandler = {}

function DracDamageHandler.Grab(boss, dmg, target)
	print("🧛 Drac uses Grab on", target and target.Name or "nil")

	local humanoid = target and target:FindFirstChildWhichIsA("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(dmg)
		print("🦷 Bite attack triggered!", dmg)
	end

	-- Optional: Apply lift effect
	local root = target and target:FindFirstChild("HumanoidRootPart")
	if root then
		local lift = Instance.new("BodyVelocity")
		lift.Velocity = Vector3.new(0, 50, 0)
		lift.MaxForce = Vector3.new(0, 100000, 0)
		lift.P = 1000
		lift.Parent = root
		game:GetService("Debris"):AddItem(lift, 0.3)
	end
end

return DracDamageHandler
