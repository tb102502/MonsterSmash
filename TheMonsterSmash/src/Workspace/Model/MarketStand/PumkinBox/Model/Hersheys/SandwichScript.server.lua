local Tool = script.Parent;

enabled = true

counter = 5


function onActivated()
	if not enabled  then
		return
	end

	enabled = false
	counter = counter - 1
	Tool.GripForward = Vector3.new(-0.976,0,-0.217)
	Tool.GripPos = Vector3.new(.95,-0.76,1.4)
	Tool.GripRight = Vector3.new(0.217,0, 0.976)
	Tool.GripUp = Vector3.new(0,1,0)


	Tool.Handle.DrinkSound:Play()

	wait(.8)
	
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		if (h.MaxHealth > h.Health + 5) then
			h.Health = h.Health + 5
		else	
			h.Health = h.MaxHealth
		end
	end

	Tool.GripForward = Vector3.new(-0.976,0,-0.217)
	Tool.GripPos = Vector3.new(0.3,0,0)
	Tool.GripRight = Vector3.new(0.217,0,-0.976)
	Tool.GripUp = Vector3.new(0,1,0)
	if counter == 0 then
	Tool:remove()
	end

	enabled = true

end

function onEquipped()
	Tool.Handle.OpenSound:play()
end

script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
