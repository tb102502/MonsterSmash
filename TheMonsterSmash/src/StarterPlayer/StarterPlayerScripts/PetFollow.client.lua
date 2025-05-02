-- StarterPlayerScripts / PetFollowerScript
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local function findPet()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:FindFirstChild("Pet")
end

local function updatePetFollow(pet, target)
	if not pet or not target then return end

	local offset = Vector3.new(3, 2, 3) -- Customize: (X, Y, Z) offset from player

	RunService.RenderStepped:Connect(function()
		if pet and pet.Parent and target and target.Parent then
			local goalPosition = target.Position + offset
			local currentPosition = pet.PrimaryPart.Position
			local lerpedPosition = currentPosition:Lerp(goalPosition, 0.1) -- Smooth interpolation

			pet:PivotTo(CFrame.new(lerpedPosition))
		end
	end)
end

-- When player spawns or respawns
player.CharacterAdded:Connect(function(character)
	task.wait(1) -- Give time for pet to be cloned

	local pet = findPet()
	local hrp = character:WaitForChild("HumanoidRootPart")

	if pet and hrp then
		print("🐾 Found Pet! Starting smooth follow!")
		updatePetFollow(pet, hrp)
	else
		print("🐶 No Pet found in character!")
	end
end)
