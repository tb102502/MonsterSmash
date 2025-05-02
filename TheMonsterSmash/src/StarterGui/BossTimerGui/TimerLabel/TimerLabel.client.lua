local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ToggleBossFight = ReplicatedStorage:WaitForChild("ToggleBossFight")

local timerLabel = script.Parent
local gui = timerLabel.Parent
local camera = workspace.CurrentCamera


local DEFAULT_DURATION = 60
local countdownRunning = false
local originalColor = Color3.new(1, 1, 1)
local warningColor = Color3.new(1, 0, 0)
local originalSize = timerLabel.Size

local function pulse()
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local grow = TweenService:Create(timerLabel, tweenInfo, {
		Size = originalSize + UDim2.new(0.05, 0, 0.05, 0)
	})
	local shrink = TweenService:Create(timerLabel, tweenInfo, {
		Size = originalSize
	})

	grow:Play()
	grow.Completed:Wait()
	shrink:Play()
end

local function screenShake(intensity, duration)
	local originalCFrame = camera.CFrame

	for i = 1, duration * 10 do
		local offset = Vector3.new(
			math.random(-10, 10) / 100 * intensity,
			math.random(-10, 10) / 100 * intensity,
			math.random(-10, 10) / 100 * intensity
		)
		camera.CFrame = originalCFrame * CFrame.new(offset)
		wait(0.03)
	end

	camera.CFrame = originalCFrame
end

local function startCountdown(duration)
	countdownRunning = true
	timerLabel.Visible = true
	timerLabel.TextColor3 = originalColor
	timerLabel.Size = originalSize

	for i = duration, 0, -1 do
		timerLabel.Text = tostring(i)

		if i <= 5 then
			timerLabel.TextColor3 = warningColor
			pulse()
			screenShake(1, 0.2)
		end


		wait(1)
	end

	timerLabel.Visible = false
	countdownRunning = false
	timerLabel.TextColor3 = originalColor
	timerLabel.Size = originalSize
end

ToggleBossFight.OnClientEvent:Connect(function(isActive)
	if isActive then
		if not countdownRunning then
			wait(3)
			startCountdown(DEFAULT_DURATION)
		end
	else
		-- Fight ended early
		timerLabel.Visible = false
		countdownRunning = false
		timerLabel.TextColor3 = originalColor
		timerLabel.Size = originalSize
	end
end)
