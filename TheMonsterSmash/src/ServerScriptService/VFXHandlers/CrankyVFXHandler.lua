-- VFXHandler ModuleScript

local VFX = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local VFXFolder = ReplicatedStorage:WaitForChild("VFX")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local AnimeSlash = Assets:WaitForChild("AnimeSlash")

-- 💥 Hit Effect on Boss Hit
function VFX.HitEffect(position)
	local effectClone = AnimeSlash:Clone()
	effectClone.Parent = Workspace
	effectClone.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
	-- Position the effect
	effectClone.Position = position

	-- Emit all particles attached to the part
	for _, emitter in ipairs(effectClone:GetChildren()) do
		if emitter:IsA("ParticleEmitter") then
			emitter:Emit(50)
		end
	end

	-- Clean up
	Debris:AddItem(effectClone, 2)
end


return VFX
