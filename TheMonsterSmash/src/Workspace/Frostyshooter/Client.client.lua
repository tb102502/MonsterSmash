--//Variables\\--
local tool = script.Parent
	local handle = tool:WaitForChild("Handle")
local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	local character = player.Character or player.CharacterAdded:Wait()	
	
local enabled = true
local specialDB = true

local contextActionService = game:GetService("ContextActionService")

local cursorId = "http://www.roblox.com/asset/?id=251497633"
local hitmarkerId = "http://www.roblox.com/asset/?id=70785856"

local configs = tool:WaitForChild("Configurations")
	local specialRechargeTime = configs:FindFirstChild("SpecialRechargeTime")
	local fireRate = configs:FindFirstChild("FireRate")
	
local fire = tool:WaitForChild("Fire")
local activateSpecial = tool:WaitForChild("ActivateSpecial")
local rigType = tool:WaitForChild("RigType")
local hit = tool:WaitForChild("Hit")
local characterRigType =  nil

--//Custom Functions\\--
function FindRigType() 
	characterRigType = rigType:InvokeServer(tool)
	print(characterRigType.." rig found.")
end

function activate()
	if specialDB then
		specialDB = false
		activateSpecial:FireServer(mouse.Hit)
	else
	end
end

--//Tool Functions\\--
tool.Equipped:Connect(function()
	contextActionService:BindAction("ActivateSpecial", activate, true, Enum.KeyCode.E)
	contextActionService:SetImage("ActivateSpecial", tool.TextureId)
	contextActionService:SetPosition("ActivateSpecial", UDim2.new(0.72, -25, 0.20, -25))
	enabled =  true
	mouse.Icon = cursorId
	FindRigType(tool)
end)

tool.Unequipped:Connect(function()
	contextActionService:UnbindAction("ActivateSpecial")
	enabled =  true
	mouse.Icon = ""
end)

tool.Activated:Connect(function()
	if not enabled then return end
	
	enabled = false
	fire:FireServer(mouse.Hit)
	wait(fireRate.Value)
	enabled = true
end)

hit.OnClientEvent:Connect(function()
	mouse.Icon = hitmarkerId
	handle.Hitmark:Play()
	wait(0.075)
	mouse.Icon = cursorId
end)

activateSpecial.OnClientEvent:Connect(function()
	
	for i = specialRechargeTime.Value, 0, -1 do
		wait(1)
		specialDB = false
		print("Recharging: "..i)
	end
	
	specialDB = true
end)