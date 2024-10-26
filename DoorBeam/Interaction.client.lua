local Players = game:GetService("Players")
local player = Players.LocalPlayer
local doorsFolder = game.Workspace:WaitForChild("Doors")

local function createBeam(PlayerHRP: BasePart, DoorPart: BasePart): Beam
	local attachment0 = Instance.new("Attachment")
	local attachment1 = Instance.new("Attachment")
	attachment0.Parent = PlayerHRP
	attachment1.Parent = DoorPart

	local beam = Instance.new("Beam")
	beam.Attachment0 = attachment0
	beam.Attachment1 = attachment1
	beam.Parent = DoorPart

	beam.Width0 = 0.1
	beam.Width1 = 0.1
	
	beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
	beam.Transparency = NumberSequence.new(0)

	return beam
end

local function createOutline(door: Model): Highlight
	local Highlight = Instance.new("Highlight")
	Highlight.OutlineColor = Color3.new(255, 255, 255)
	Highlight.FillTransparency = 1
	Highlight.Parent = door
	
	return Highlight
end

for _, door in next, doorsFolder:GetChildren() do
	local proximityPrompt = door:WaitForChild("InteractionPart") and door.InteractionPart:WaitForChild("DoorPrompt")
	if proximityPrompt then
		local beam, highlight = nil, nil

		proximityPrompt.PromptShown:Connect(function()
			local character = player.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					beam = createBeam(humanoidRootPart, door.InteractionPart)
					highlight = createOutline(door)
				end
			end
		end)

		proximityPrompt.PromptHidden:Connect(function()
			if beam then
				beam:Destroy(); beam = nil
				highlight:Destroy(); highlight = nil
			end
		end)
	end
end