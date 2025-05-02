-- LocalScript (StarterPlayerScripts or StarterCharacterScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setupPetEffects(pet)
	if not pet then return end

	-- 🧽 Clean previous sparkle
	if pet:FindFirstChild("PoofEffect") then
		pet.PoofEffect:Destroy()
	end

	-- ✨ Create sparkle poof on spawn
	local poof = Instance.new("ParticleEmitter")
	poof.Name = "PoofEffect"
	poof.Texture = "rbxassetid://248625108" -- nice fluffy poof!
	poof.Lifetime = NumberRange.new(1)
	poof.Rate = 500
	poof.Speed = NumberRange.new(5,10)
	poof.SpreadAngle = Vector2.new(360,360)
	poof.Size = NumberSequence.new(1)
	poof.Parent = pet.PrimaryPart

	-- Emit once then clean up
	poof:Emit(50)
	game:GetService("Debris"):AddItem(poof, 1)

	-- 🐾 Setup idle animation if Humanoid exists
	local humanoid = pet:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		local animator = humanoid:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", humanoid)

		local idleAnim = Instance.new("Animation")
		idleAnim.AnimationId = "rbxassetid://123168590976280" -- 🔥 Replace this with your Corgi idle anim id
		local track = animator:LoadAnimation(idleAnim)
		track.Looped = true
		track:Play()
	end
end

-- 🐶 Watch for pets
local function onCharacterAdded(character)
	character.ChildAdded:Connect(function(child)
		if child:IsA("Model") and child.Name == "Pet" then
			-- Give a tiny delay to let PrimaryPart be set
			task.wait(0.1)
			setupPetEffects(child)
		end
	end)
end

-- Hook up to player spawning
if player.Character then
	onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)
