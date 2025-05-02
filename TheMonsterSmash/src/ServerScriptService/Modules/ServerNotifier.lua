-- ServerNotifier.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvents if missing
local function getOrCreateEvent(name)
	local evt = ReplicatedStorage:FindFirstChild(name)
	if not evt then
		evt = Instance.new("RemoteEvent")
		evt.Name = name
		evt.Parent = ReplicatedStorage
	end
	return evt
end

local HPUpdateEvent = getOrCreateEvent("BossHPUpdateEvent")
local XPGainedEvent = getOrCreateEvent("XPGainedEvent")

local ServerNotifier = {}

function ServerNotifier:UpdateBossHP(player, currentHP, maxHP)
	HPUpdateEvent:FireClient(player, currentHP, maxHP)
end

function ServerNotifier:GrantXP(player, amount)
	XPGainedEvent:FireClient(player, amount)
	local stats = player:FindFirstChild("leaderstats")
	if stats then
		local xp = stats:FindFirstChild("XP")
		if xp then
			xp.Value += amount
		end
	end
end

return ServerNotifier
