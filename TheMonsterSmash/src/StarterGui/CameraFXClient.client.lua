local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local camFX = ReplicatedStorage:WaitForChild("CameraFXRemote")

camFX.OnClientEvent:Connect(function(mode, intensity, duration)
	-- Default fallback safety
	intensity = tonumber(intensity) or 2
	duration = tonumber(duration) or 0.5

	if mode == "Shake" then
		local startCFrame = Camera.CFrame

		local function shake()
			local x = math.random(-100, 100) / 100 * intensity
			local y = math.random(-100, 100) / 100 * intensity
			local z = math.random(-100, 100) / 100 * intensity
			local offset = Vector3.new(x, y, z)

			Camera.CFrame = startCFrame * CFrame.new(offset)
		end

		local startTime = tick()
		while tick() - startTime < duration do
			shake()
			task.wait(0.03)
		end

		Camera.CFrame = startCFrame

	elseif mode == "Tilt" then
		local startCFrame = Camera.CFrame
		local tiltTween = TweenService:Create(Camera, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			CFrame = startCFrame * CFrame.Angles(0, 0, math.rad(intensity))
		})

		local unTiltTween = TweenService:Create(Camera, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			CFrame = startCFrame
		})

		tiltTween:Play()
		tiltTween.Completed:Wait()
		unTiltTween:Play()
	end
end)
