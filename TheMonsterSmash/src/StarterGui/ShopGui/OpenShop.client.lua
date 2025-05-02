-- LocalScript under StarterGui or ShopGui
local replicatedStorage = game:GetService("ReplicatedStorage")
local openShop = replicatedStorage:WaitForChild("OpenShop")

local ShopGui = script.Parent -- should be the ScreenGui

openShop.OnClientEvent:Connect(function()
	ShopGui.Enabled = not ShopGui.Enabled
	print("Shop GUI toggled!")
end)
