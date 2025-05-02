local gamePassID = 100336477061227 -- Replace with your actual Game Pass ID
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

Players.PlayerAdded:Connect(function(player)
	-- Check if player owns the Game Pass
	if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID) then
		-- Apply the upgrade (Example: Increase WalkSpeed)
		player.CharacterAdded:Connect(function(character)
			character:WaitForChild("Humanoid").WalkSpeed = 32 -- Default is 16
		end)
	end
end)

local marketplaceService = game:GetService("MarketplaceService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local purchaseEvent = Instance.new("RemoteEvent", replicatedStorage)
purchaseEvent.Name = "PurchaseSwordEvent"

local swordProducts = {
	["EpicSword"] = 12345678, -- Replace with actual Developer Product ID
	["LegendarySword"] = 87654321, -- Replace with actual Developer Product ID
}

purchaseEvent.OnServerEvent:Connect(function(player, swordName)
	local productId = swordProducts[swordName]
	if productId then
		marketplaceService:PromptProductPurchase(player, productId)
	end
end)

marketplaceService.ProcessReceipt = function(receiptInfo)
	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

	-- Give the player the sword after purchase
	local sword = game.ServerStorage:FindFirstChild(receiptInfo.ProductId)
	if sword then
		local clonedSword = sword:Clone()
		clonedSword.Parent = player.Backpack
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end
