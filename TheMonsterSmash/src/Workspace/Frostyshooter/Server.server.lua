--//Variables\\--
local tool = script.Parent
	local handle = tool:WaitForChild("Handle")

local tweenService = game:GetService("TweenService")

local fire = tool:WaitForChild("Fire")
local rigType = tool:WaitForChild("RigType")
local activateSpecial = tool:WaitForChild("ActivateSpecial")
local hit = tool:WaitForChild("Hit")

local debris = game:GetService("Debris")

local configs = tool:WaitForChild("Configurations")
	local fireRate = configs:FindFirstChild("FireRate")
	local maxDamage = configs:FindFirstChild("MaxDamage")
	local minDamage = configs:FindFirstChild("MinDamage")
	local velocity = configs:FindFirstChild("Velocity")
	local explosionRadius = configs:FindFirstChild("ExplosionRadius")
	local explosionDamage = configs:FindFirstChild("ExplosionDamage")
	local specialRechargeTime = configs:FindFirstChild("SpecialRechargeTime")
	local freezeChance = configs:FindFirstChild("FreezeChance")
	local freezeDuration = configs:FindFirstChild("FreezeDuration")
	
local showDamageText = true

local R6Anims = {
	1090079719, --First
	1131061690, --Second
	1131077402 -- Third
}

local R15Anims = {
	1092623018, --First
	1124408415, --Second
	1124419504 --Third
}

--//Custom Functions\\--
function TextEffects(element, floatAmount, direction, style, duration)
	element:TweenPosition(UDim2.new(0, math.random(-40, 40), 0, -floatAmount), direction, style, duration)
	wait(0.5)

	for i = 1, 60 do
		element.TextTransparency = element.TextTransparency + 1/60
		element.TextStrokeTransparency = element.TextStrokeTransparency + 1/60
		wait(1/60)
	end

	element.TextTransparency = element.TextTransparency + 1
	element.TextStrokeTransparency = element.TextStrokeTransparency + 1
	element.Parent:Destroy()
end

function DynamicText(damage, criticalPoint, humanoid)
	local bill = Instance.new("BillboardGui", humanoid.Parent.Head)
	bill.Size = UDim2.new(0, 50, 0, 100) 
	local part = Instance.new("TextLabel", bill) 
	bill.AlwaysOnTop = true
	part.TextColor3 = Color3.fromRGB(255, 0, 0)
	part.Text = damage
	part.Font = Enum.Font.SourceSans
	part.TextStrokeTransparency = 0
	part.Size = UDim2.new(1, 0, 1, 0) 
	part.Position = UDim2.new(0, 0, 0, 0) 
	part.BackgroundTransparency = 1
	bill.Adornee = bill.Parent
			
	if damage < criticalPoint then
		part.TextSize = 28
		part.TextColor3 = Color3.new(1, 0, 0)
	elseif damage >= criticalPoint then
		part.TextSize = 32
		part.TextColor3 = Color3.new(1, 1, 0)
	end 
	
	spawn(function()
		TextEffects(part, 85, Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.75)
	end)
end

function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	game.Debris:AddItem(Creator_Tag, 0.3)
	Creator_Tag.Parent = humanoid
end

function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end

function DamageAndTagHumanoid(player, humanoid, damage)
	hit:FireClient(player)
	UntagHumanoid(handle)
	humanoid:TakeDamage(damage) TagHumanoid(humanoid, player)
end

function CheckBodyType(player, tool)
	local character = player.Character
	local humanoid = character:FindFirstChild("Humanoid")
	
	if humanoid.RigType == Enum.HumanoidRigType.R15 then -- R15
		tool.Handle.Throw.AnimationId = "rbxassetid://"..R15Anims[math.random(1, #R15Anims)]
		return "R15"
	end
	
	if humanoid.RigType == Enum.HumanoidRigType.R6 then -- R6
		tool.Handle.Throw.AnimationId = "rbxassetid://"..R6Anims[math.random(1, #R6Anims)]
		return "R6"
	end
end

function ExplosionHit(part, distance, player, damage, chanceAmount)
	if part.Name == "Head" then
		local humanoid = part.Parent:FindFirstChild("Humanoid")
		if not humanoid then return nil
		elseif humanoid and humanoid.Health > 0 and not part:IsDescendantOf(player.Character) then

			DamageAndTagHumanoid(player, humanoid, damage)
			Freeze(humanoid.Parent, chanceAmount)
			
			if showDamageText then
				DynamicText(damage, 10, humanoid)
			else
			end
		end
	end
end

function CreateExplosion(position, player, damage, radius, chanceAmount)
	local explosion = Instance.new("Explosion", workspace)
	explosion.BlastPressure = 0
	explosion.BlastRadius = radius
	explosion.Position = position
	explosion.Visible = false

	explosion.Hit:Connect(function(part, distance)
		ExplosionHit(part, distance, player, damage, chanceAmount)
	end)
end

function Effects(otherEffects, position, radius)
	spawn(function()
		if otherEffects then
			for i = 1, radius do
				local partE = Instance.new("Part", workspace)
				partE.Name = "FireParticle #"..i
				partE.Shape = Enum.PartType.Ball
				partE.Size = Vector3.new(0.75, 0.75, 0.75)
				partE.CanCollide = false
				partE.Transparency = 1
				partE.Position = position
					local cloneEffect = handle.Effect:Clone()
					cloneEffect.Size = NumberSequence.new(3, 6)
					cloneEffect.Parent = partE
					cloneEffect.Rate = 150
			
				partE.Velocity = Vector3.new(math.random(-150, 150), math.random(225), math.random(-150, 150))
				debris:AddItem(partE, 5)
			end
		end
	end)
			
	local effect = Instance.new("Part", workspace)
	effect.Shape = Enum.PartType.Ball
	effect.Name = "Effect"
	effect.Size = Vector3.new(radius, radius, radius)
	effect.Transparency = 0
	effect.BrickColor = BrickColor.new("New Yeller")
	effect.Material = Enum.Material.Neon
	effect.CanCollide = false
	effect.Anchored = true
	effect.Position = position
	
	local tweenInfo = TweenInfo.new(
		1, --//Length
		Enum.EasingStyle.Quart, --//Style
		Enum.EasingDirection.Out, --//Direction
		0, --//Loop this many times
		false, --//Reverse Effect
		0 --//Delay
	)
			
	local partAftermath = {
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(radius * 5, radius * 5, radius * 5)
	}
			
	local createTween = tweenService:Create(effect, tweenInfo, partAftermath)
	createTween:Play()
	
	debris:AddItem(effect, 1)
end

function Freeze(model, chanceAmount)
	local chance1, chance2 = Chance(chanceAmount)
	
	if chance1 == chance2 or chance2 == chance1 then
		local block = Instance.new("Part", workspace)
		block.Material = Enum.Material.Neon
		block.Name = "IceBlock"
		block.Anchored = true
		block.CanCollide = false
		block.Locked = true
		block.CFrame = model.HumanoidRootPart.CFrame
		block.Transparency = 0.5
		block.Size = Vector3.new(5, 10, 5)
		block.TopSurface = 0
		block.BottomSurface = 0
		block.Reflectance = 0.5
		block.BrickColor = BrickColor.new("New Yeller")
			local iceWeld = Instance.new("Weld")
			iceWeld.Part0 = block
			iceWeld.Part1 = model.HumanoidRootPart
			iceWeld.Parent = block
			local sound = Instance.new("Sound", model)
			sound.SoundId = "rbxassetid://1221744047"
			sound.Volume = 3
			sound.PlayOnRemove = true
			sound.Name = "FreezeSound"
			sound:Play()
			
			sound.Ended:Connect(function() sound:Destroy() end)

		game.Debris:AddItem(block, freezeDuration.Value)
	end
end

function Chance(chanceAmount)
	local chance1 = math.random(-chanceAmount, chanceAmount)
	local chance2 = math.random(-chanceAmount, chanceAmount)
	
	return chance1, chance2
end

fire.OnServerEvent:Connect(function(player, mouseHit)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	
	if humanoid and humanoid.Health ~= 0 then
		rigType.OnServerInvoke = CheckBodyType
		
		local track = humanoid:LoadAnimation(handle:WaitForChild("Throw"))
		track:Play()

		local projectile = Instance.new("Part", workspace)
		projectile.Name = "Snowball"
		projectile.Shape = Enum.PartType.Ball
		projectile.Size = Vector3.new(1, 1, 1)	
		projectile.Transparency = 1
		projectile.CanCollide = false
		
			local ice = handle.Effect:Clone()
			ice.Size = NumberSequence.new(3, 6)
			ice.Parent = projectile
			ice.Rate = 140
			local sound = Instance.new("Sound", projectile)
			sound.SoundId = "rbxassetid://186130717"
			sound.Volume = 10
			sound.PlayOnRemove = true
			sound.Name = "BoomEffectSound"
			
		projectile.CFrame = handle.CFrame
		projectile.Velocity = mouseHit.lookVector * velocity.Value
		
		debris:AddItem(projectile, 20)
		handle.Cast.SoundId = "rbxassetid://2101658119"
		handle.Cast:Play()
		
		projectile.Touched:Connect(function(hit)
			local eHumanoid = hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid")
			local damage = math.random(minDamage.Value, maxDamage.Value)
			if not eHumanoid and not hit.Anchored and not hit:IsDescendantOf(player.Character) then

				local projectileCFrame = projectile.CFrame
				projectile:Destroy()	
					
				spawn(function()
					CreateExplosion(projectileCFrame.p, player, explosionDamage.Value, explosionRadius.Value, freezeChance.Value)
					Effects(true, projectileCFrame.p, explosionRadius.Value)
				end)
			elseif eHumanoid and eHumanoid ~= humanoid and eHumanoid.Health > 0 and hit ~= projectile then
					
				if hit.Name == "Head" or hit:IsA("Hat") then
					damage = damage * 1.5
				end
					
				local criticalPoint = maxDamage.Value
				DamageAndTagHumanoid(player, eHumanoid, damage)
				Freeze(eHumanoid.Parent, freezeChance.Value)
				
				if showDamageText then
					DynamicText(damage, criticalPoint, eHumanoid)
				else
				end
				
				local projectileCFrame = projectile.CFrame
				projectile:Destroy()	
					
				spawn(function()
					CreateExplosion(projectileCFrame.p, player, explosionDamage.Value, explosionRadius.Value, freezeChance.Value)
					Effects(true, projectileCFrame.p, explosionRadius.Value)
				end)
			elseif hit.CanCollide == true and not hit:IsDescendantOf(player.Character) and hit.Anchored == true then
				
				local projectileCFrame = projectile.CFrame
				projectile:Destroy()	
					
				spawn(function()
					CreateExplosion(projectileCFrame.p, player, explosionDamage.Value, explosionRadius.Value, freezeChance.Value)
					Effects(true, projectileCFrame.p, explosionRadius.Value)
				end)
			end	
		end)
	end
end)

activateSpecial.OnServerEvent:Connect(function(player, mouseHit)
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	
	spawn(function()
		local castSound = Instance.new("Sound", player.PlayerGui)
		castSound.Volume = 1
		castSound.Name = "CastSound"
		castSound.SoundId = "rbxassetid://1177475221"
		castSound:Play()

		castSound.Ended:Connect(function() castSound:Destroy() end)

		local activatedGui = Instance.new("ScreenGui", player.PlayerGui)
		activatedGui.Name = "SpecialActivated"
			local textLabel = Instance.new("TextLabel", activatedGui) 
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
			textLabel.Text = "Smite Triggered!"
			textLabel.Font = Enum.Font.SourceSans
			textLabel.TextScaled = true
			textLabel.TextStrokeTransparency = 0
			textLabel.Size = UDim2.new(0, 300, 0, 50) 
			textLabel.Position = UDim2.new(2.5, 0, 0.15, -10) 
			textLabel.BackgroundTransparency = 1
			textLabel:TweenPosition(UDim2.new(0.5, -(textLabel.Size.X.Offset / 2),  0.1, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 1)
		
		wait(3)
		TextEffects(textLabel, 200, Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 1)
	end)

	local ray = Ray.new(handle.CFrame.p, (mouseHit.p - handle.CFrame.p).Unit * 1000)
	local part, position = workspace:FindPartOnRay(ray, character, false, true)
	
	local partEffect = Instance.new("Part", workspace)
	partEffect.Name = "IceParticle"
	partEffect.BrickColor = BrickColor.new("New Yeller")
	partEffect.Shape = Enum.PartType.Ball
	partEffect.Anchored = true
	partEffect.CanCollide = false
	partEffect.Position = position
	partEffect.Size = Vector3.new(0, 0, 0)
	partEffect.Transparency = 0.25
	partEffect.Material = Enum.Material.Neon
	
	local ice = handle.Effect:Clone()
	ice.Size = NumberSequence.new(5, 10)
	ice.Parent = partEffect
	ice.Rate = 300
	
	debris:AddItem(partEffect, 2.5)
	
	local distance = (handle.CFrame.p - position).Magnitude
	local trace = Instance.new("Part", workspace)
	trace.Name = "Trace"
	trace.CanCollide = false
	trace.Anchored = true
	trace.Size = Vector3.new(0.25, 0.25, distance)
	trace.CFrame = CFrame.new(handle.CFrame.p, position) * CFrame.new(0, 0, - distance / 2)
	trace.Material = Enum.Material.Neon
	trace.TopSurface = 0
	trace.BottomSurface = 0
	trace.BrickColor = BrickColor.new("Olivine")
	trace.Locked = true
	
	debris:AddItem(trace, 0.75)
	
	local tweenInfo = TweenInfo.new(
		1.25, --//Length
		Enum.EasingStyle.Quart, --//Style
		Enum.EasingDirection.Out, --//Direction
		0, --//Loop this many times
		true, --//Reverse Effect
		0 --//Delay
	)
			
	local partAftermath = {
		Anchored = true,
		Size = Vector3.new(explosionRadius.Value * 10, explosionRadius.Value * 10, explosionRadius.Value * 10)
	}
		
	local createTween = tweenService:Create(partEffect, tweenInfo, partAftermath)
	createTween:Play()

	local tweenInfo2 = TweenInfo.new(
		0.75, --//Length
		Enum.EasingStyle.Quart, --//Style
		Enum.EasingDirection.Out, --//Direction
		0, --//Loop this many times
		true, --//Reverse Effect
		0 --//Delay
	)
			
	local partAftermath2 = {
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(5, 5, distance)
	}
		
	local createTween2 = tweenService:Create(trace, tweenInfo2, partAftermath2)
	createTween2:Play()
	
	activateSpecial:FireClient(player)
	
	local track = humanoid:LoadAnimation(handle:WaitForChild("Throw"))
	track:Play()
	
	delay(2.5, function()
		CreateExplosion(position, player, explosionDamage.Value * 40, explosionRadius.Value * 5, 0)
		Effects(true, position, explosionRadius.Value * 5)
	
		local explosionSound = Instance.new("Sound", workspace)
		explosionSound.Volume = 2.5
		explosionSound.Name = "Explosion"
		explosionSound.SoundId = "rbxassetid://1079408535"
		explosionSound:Play()
	
		explosionSound.Ended:Connect(function() explosionSound:Destroy() end)
	end)

end)

rigType.OnServerInvoke = CheckBodyType
