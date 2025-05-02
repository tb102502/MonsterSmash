-- SwordServer (Script inside SwordTool)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SwordAttack = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("SwordAttack")
local SwordSwingFX = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("SwordSwingFX")
local VFX = require(game.ServerScriptService.VFXHandlers:WaitForChild("CrankyVFXHandler"))
local ScreenFlashEvent = ReplicatedStorage:WaitForChild("ScreenFlashEvent")

local tool = script.Parent
local damageBase = 10
local swingRange = 30
local swingRadius = 4
local debounceTime = 0.4

local playerDebounce = {}

local function attack(player)
	if playerDebounce[player] then return end
	playerDebounce[player] = true

	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local swingRange = 30
	local swingRadius = 4
	local regionSize = Vector3.new(swingRange, 5, swingRadius)
	local regionCFrame = root.CFrame * CFrame.new(0, 0, -swingRange / 2)

	-- Set up OverlapParams to ignore the attacker
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {char}
	params.MaxParts = 100
	params.RespectCanCollide = false

	local parts = workspace:GetPartBoundsInBox(regionCFrame, regionSize, params)

	local hitSomething = false
	for _, part in pairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")
		local hum = model and model:FindFirstChildOfClass("Humanoid")

		if hum and hum.Health > 0 and hum ~= char:FindFirstChildOfClass("Humanoid") then
			local strength = player:GetAttribute("Upgrade_Strength") or 0
			local totalDamage = damageBase + strength
			hum:TakeDamage(totalDamage)
			hitSomething = true

			local hrp = model and model:FindFirstChild("HumanoidRootPart")

			if hrp then
				print("Firing VFX to client at position:", hrp.Position)
				VFX.HitEffect(hrp.Position)
				SwordSwingFX:FireClient(player, hrp.Position)
				ScreenFlashEvent:FireClient(player) -- ← ADD THIS
			end
		end
	end

	task.delay(debounceTime, function()
		playerDebounce[player] = false
	end)
end

SwordAttack.OnServerEvent:Connect(attack)
