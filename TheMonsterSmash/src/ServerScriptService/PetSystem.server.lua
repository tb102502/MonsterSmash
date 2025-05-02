local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")

local equipPetEvent = ReplicatedStorage:WaitForChild("EquipPet")
local petData = require(ReplicatedStorage:WaitForChild("PetData"))

-- 🌀 Pet Summon Effect
local function summonEffect(position)
	local part = Instance.new("Part")
	part.Size = Vector3.new(1,1,1)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Parent = workspace

	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxassetid://1323306" -- Poof texture
	emitter.Rate = 200
	emitter.Lifetime = NumberRange.new(0.5)
	emitter.Speed = NumberRange.new(8)
	emitter.SpreadAngle = Vector2.new(360, 360)
	emitter.Parent = part

	emitter:Emit(50)

	Debris:AddItem(part, 1) -- Remove after 1s
end

-- 🐾 Equip Pet Logic
local function equipPet(player, petName)
	print("🚀 equipPet called:", player.Name, petName)

	if not petData[petName] then
		warn("❌ No pet data for:", petName)
		return
	end

	local char = player.Character
	if not char then
		warn("❌ No character found for:", player.Name)
		return
	end

	local currentPet = char:FindFirstChild("Pet")

	-- Unequip if same pet
	if currentPet and currentPet:GetAttribute("PetName") == petName then
		currentPet:Destroy()
		player:SetAttribute("SpeedBoost", nil)
		player:SetAttribute("CoinMultiplier", nil)
		print("🧹 Unequipped:", petName)
		return
	end

	-- Remove old pet if different
	if currentPet then
		currentPet:Destroy()
	end

	local petModel = ServerStorage:WaitForChild("Pets"):FindFirstChild(petData[petName].Model)
	if not petModel then
		warn("❌ Missing pet model:", petName)
		return
	end

	-- 🛠 Summon new pet
	local pet = petModel:Clone()
	pet.Name = "Pet"
	pet:SetAttribute("PetName", petName)
	pet.Parent = char

	local hrp = char:WaitForChild("HumanoidRootPart")
	local petPrimary = pet.PrimaryPart
	if not petPrimary then
		warn("❌ Pet missing PrimaryPart:", pet.Name)
		return
	end

	-- Smooth Follow Setup
	local alignPos = Instance.new("AlignPosition")
	local attachment0 = Instance.new("Attachment", petPrimary)
	local attachment1 = Instance.new("Attachment", hrp)

	alignPos.Attachment0 = attachment0
	alignPos.Attachment1 = attachment1
	alignPos.RigidityEnabled = false
	alignPos.Responsiveness = 25 -- Lower = smoother, slower follow
	alignPos.MaxForce = 5000
	alignPos.Parent = petPrimary

	-- Rotation Follow
	local alignOri = Instance.new("AlignOrientation")
	alignOri.Attachment0 = attachment0
	alignOri.Attachment1 = attachment1
	alignOri.RigidityEnabled = false
	alignOri.Responsiveness = 15
	alignOri.MaxTorque = 5000
	alignOri.Parent = petPrimary

	-- Offset the pet to the side of player
	attachment1.Position = Vector3.new(3, 2, 3)

	-- Poof Summon
	summonEffect(petPrimary.Position)

	-- Boosts
	player:SetAttribute("SpeedBoost", petData[petName].SpeedBoost)
	player:SetAttribute("CoinMultiplier", petData[petName].CoinMultiplier)

	print("✅ Equipped Pet:", petName, "for", player.Name)
end

equipPetEvent.OnServerEvent:Connect(equipPet)
