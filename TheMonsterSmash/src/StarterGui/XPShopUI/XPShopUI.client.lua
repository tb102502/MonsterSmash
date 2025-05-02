-- StarterGui | XPShopUI.client.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remote = ReplicatedStorage:WaitForChild("XPShopRequest")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "XPShop"

local title = Instance.new("TextLabel", gui)
title.Size = UDim2.new(0.3, 0, 0.05, 0)
title.Position = UDim2.new(0.35, 0, 0.3, 0)
title.Text = "XP Upgrade Shop"
title.TextScaled = true

local function createButton(name, posY)
	local btn = Instance.new("TextButton", gui)
	btn.Size = UDim2.new(0.3, 0, 0.05, 0)
	btn.Position = UDim2.new(0.35, 0, posY, 0)
	btn.Text = "Upgrade " .. name
	btn.TextScaled = true
	btn.MouseButton1Click:Connect(function()
		local success, msg = Remote:InvokeServer(name)
		btn.Text = success and "✔️ " .. msg or "❌ " .. msg
		task.wait(2)
		btn.Text = "Upgrade " .. name
	end)
end

createButton("Strength", 0.4)
createButton("Health", 0.46)
createButton("Speed", 0.52)
