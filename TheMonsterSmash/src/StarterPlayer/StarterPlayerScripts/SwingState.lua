-- SwingState.lua
local SwingState = {}

SwingState.CanSwing = true

function SwingState:Set(value)
	self.CanSwing = value
end

function SwingState:Get()
	return self.CanSwing
end

return SwingState
