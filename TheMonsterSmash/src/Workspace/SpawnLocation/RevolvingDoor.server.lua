local door = script.Parent
local rotationSpeed = 0.1  -- Adjust the speed of rotation

while true do
    door.CFrame = door.CFrame * CFrame.Angles(0, math.rad(rotationSpeed), 0)
    task.wait(0.1)  -- Adjust the wait time for smoother rotation
end

