local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraFXRemote = ReplicatedStorage:WaitForChild("CameraFXRemote")
local CameraFXUtils = require(ReplicatedStorage.Modules.CameraFXUtils)

CameraFXRemote.OnClientEvent:Connect(function(mode, ...)
	if mode == "Shake" then
		local intensity, duration = ...
		CameraFXUtils.ShakeCamera(intensity, duration)
	elseif mode == "Tilt" then
		local intensity = ...
		CameraFXUtils.TiltCamera(intensity)
	elseif mode == "Flash" then
		CameraFXUtils.FlashScreen()
	else
		warn("⚠️ Unknown CameraFX mode received:", mode)
	end
end)
