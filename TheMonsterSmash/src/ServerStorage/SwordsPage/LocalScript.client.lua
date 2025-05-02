local purchaseEvent = game.ReplicatedStorage:WaitForChild("PurchaseSwordEvent")

script.Parent.EpicSwordButton.MouseButton1Click:Connect(function()
	purchaseEvent:FireServer("EpicSword")
end)

script.Parent.LegendarySwordButton.MouseButton1Click:Connect(function()
	purchaseEvent:FireServer("LegendarySword")
end)

