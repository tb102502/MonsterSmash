-- Script inside ShopTriggerPart

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local openShop = ReplicatedStorage:FindFirstChild("OpenShop") or Instance.new("RemoteEvent", ReplicatedStorage)
openShop.Name = "OpenShop"

local triggeredRecently = {} -- [player.UserId] = time

local cooldown = 2 -- seconds

script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return end

	local now = tick()
	local last = triggeredRecently[player.UserId] or 0

	if now - last >= cooldown then
		triggeredRecently[player.UserId] = now
		openShop:FireClient(player)
	end
end)
