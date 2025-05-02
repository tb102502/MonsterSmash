-- DracVFXHandler.lua
local DracVFXHandler = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function DracVFXHandler.BatSwarmEffect(position: Vector3)
	local template = ReplicatedStorage:WaitForChild("VFX"):FindFirstChild("BatSwarmEffect")
	if not template then
		warn("⚠️ BatSwarmEffect not found in ReplicatedStorage.VFX")
		return
	end

	if not position or typeof(position) ~= "Vector3" then
		warn("⚠️ Invalid position passed to BatSwarmEffect")
		return
	end

	local clone = template:Clone()
	clone.Anchored = true
	clone.Position = position
	clone.Parent = workspace

	local emitter = clone:FindFirstChildWhichIsA("ParticleEmitter")
	if emitter then
		emitter:Emit(80)
	end

	game:GetService("Debris"):AddItem(clone, 3)
end


function DracVFXHandler.BatSwirlLoopAround(boss)
	local primary = boss and boss:FindFirstChild("HumanoidRootPart")
	if not primary then return end

	local attachment = Instance.new("Attachment", primary)

	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxassetid://241837157"
	emitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0.6) })
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Lifetime = NumberRange.new(1.2, 2)
	emitter.Speed = NumberRange.new(6, 10)
	emitter.Rate = 80
	emitter.Rotation = NumberRange.new(0, 360)
	emitter.RotSpeed = NumberRange.new(200, 300)
	emitter.LightEmission = 1
	emitter.LockedToPart = true
	emitter.Parent = attachment

	game:GetService("Debris"):AddItem(emitter, 5)
end

return DracVFXHandler
