local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

local CameraFXUtils = {}

function CameraFXUtils.ShakeCamera(intensity, duration)
	if typeof(intensity) ~= "number" then
		warn("⚠️ ShakeCamera expects a NUMBER for intensity, got", typeof(intensity))
		return
	end

	local originalCFrame = Camera.CFrame
	local startTime = tick()

	while tick() - startTime < (duration or 0.5) do
		local offset = Vector3.new(
			math.random(-100, 100) / 100 * intensity,
			math.random(-100, 100) / 100 * intensity,
			math.random(-100, 100) / 100 * intensity
		)
		Camera.CFrame = originalCFrame * CFrame.new(offset)
		task.wait(0.03)
	end

	Camera.CFrame = originalCFrame
end

function CameraFXUtils.TiltCamera(degrees)
	local startCFrame = Camera.CFrame

	local tiltTween = TweenService:Create(Camera, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = startCFrame * CFrame.Angles(0, 0, math.rad(degrees))
	})

	local unTiltTween = TweenService:Create(Camera, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = startCFrame
	})

	tiltTween:Play()
	tiltTween.Completed:Wait()
	unTiltTween:Play()
end

function CameraFXUtils.FlashScreen()
	local flash = Instance.new("ColorCorrectionEffect")
	flash.Name = "FlashEffect"
	flash.Brightness = 1
	flash.Contrast = 2
	flash.Saturation = -1
	flash.TintColor = Color3.new(0, 1, 1) -- Bright white flash
	flash.Parent = Lighting

	task.delay(0.15, function()
		flash:Destroy()
	end)
end

return CameraFXUtils
