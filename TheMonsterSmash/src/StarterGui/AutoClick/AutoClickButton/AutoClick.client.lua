local replicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

-- Wait for ClickEvent in ReplicatedStorage
local clickEvent = replicatedStorage:WaitForChild("ClickEvent")

-- Get the button
local autoClickButton = script.Parent

-- AutoClick settings
local autoClickEnabled = false
local autoClickSpeed = 0.5 -- Time in seconds per auto-click
local autoClickLoop = nil

-- Function to toggle AutoClicker
local function toggleAutoClick()
	autoClickEnabled = not autoClickEnabled -- Toggle state

	if autoClickEnabled then
		autoClickButton.Text = "AutoClick: ON"
		-- Change the background color to green
		autoClickButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green

		-- Start auto-click loop
		autoClickLoop = task.spawn(function()
			while autoClickEnabled do
				clickEvent:FireServer() -- Fire click event
				wait(autoClickSpeed) -- Wait before next click
			end
		end)
	else
		autoClickButton.Text = "AutoClick: OFF"
		-- Change the background color back to its original color (e.g., red)
		autoClickButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red

		-- Stop auto-click loop
		if autoClickLoop then
			task.cancel(autoClickLoop)
			autoClickLoop = nil
		end
	end
end

-- Connect button click to toggle function
autoClickButton.MouseButton1Click:Connect(toggleAutoClick)
