local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local equipPetEvent = ReplicatedStorage:WaitForChild("EquipPet")
local player = Players.LocalPlayer
local gui = script.Parent

-- Optional: Sound feedback
--local clickSound = Instance.new("Sound")
--clickSound.Volume = 0.5
--clickSound.Parent = gui

-- Set up all pet buttons automatically
for _, button in ipairs(gui:GetChildren()) do
	if button:IsA("TextButton") then
		button.MouseButton1Click:Connect(function()
			local petName = button.Name
			print("🖱️ Clicked pet button:", petName)

			-- Play click
			--if clickSound then
				--clickSound:Play()
			--end

			-- Tell the server to equip pet
			if equipPetEvent then
				equipPetEvent:FireServer(petName)
			else
				warn("⚠️ EquipPetEvent missing!")
			end
		end)
	end
end
