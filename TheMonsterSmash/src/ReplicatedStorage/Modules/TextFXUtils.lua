local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local TextFXUtils = {}

-- 🔁 Glitch glow clone + animation
function TextFXUtils.GlitchPreset(label, style)
	style = style:lower()

	local presets = {
		["red electric"] = {
			color = Color3.fromRGB(255, 0, 0),
			transparency = 0.3,
			jitter = 2,
			count = 2,
		},
		["cyber blue"] = {
			color = Color3.fromRGB(0, 255, 255),
			transparency = 0.2,
			jitter = 1,
			count = 3,
		},
		["plasma violet"] = {
			color = Color3.fromRGB(170, 0, 255),
			transparency = 0.25,
			jitter = 3,
			count = 2,
		},
	}

	local preset = presets[style] or presets["red electric"]

	for i = 1, preset.count do
		local glow = label:Clone()
		glow.Name = label.Name .. "_Glitch_" .. i
		glow.TextColor3 = preset.color
		glow.TextTransparency = preset.transparency
		glow.TextStrokeTransparency = 1
		glow.ZIndex = label.ZIndex - 1
		glow.Position = label.Position
		glow.Size = label.Size
		glow.Font = label.Font
		glow.BackgroundTransparency = 1
		glow.TextScaled = label.TextScaled
		glow.TextSize = label.TextSize
		glow.AnchorPoint = label.AnchorPoint
		glow.Parent = label.Parent

		local offsetTween = TweenService:Create(glow, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
			Position = label.Position + UDim2.new(0, math.random(-preset.jitter, preset.jitter), 0, math.random(-preset.jitter, preset.jitter))
		})

		local flickerTween = TweenService:Create(glow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
			TextTransparency = preset.transparency + math.random() * 0.2
		})

		offsetTween:Play()
		flickerTween:Play()
	end
end


return TextFXUtils
