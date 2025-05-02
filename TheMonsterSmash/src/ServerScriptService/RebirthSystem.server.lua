local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local rebirthEvent = replicatedStorage:WaitForChild("RebirthEvent")

local function onRebirthRequest(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local rebirths = leaderstats:FindFirstChild("Rebirths")
        local coins = leaderstats:FindFirstChild("Coins")
        
        if rebirths and coins and coins.Value >= 1000 then -- Assuming 1000 coins are needed for rebirth
            coins.Value = 0 -- Reset coins
            rebirths.Value = rebirths.Value + 1 -- Increment rebirth count
            
            -- Reset other stats as needed
            -- Example: Reset health, damage, etc.
        end
    end
end

rebirthEvent.OnServerEvent:Connect(onRebirthRequest)

