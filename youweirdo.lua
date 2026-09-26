local soundName = "button_yerweirdosound"
local sizeFactor = 10
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local tweenService = game:GetService("TweenService")
local debris = game:GetService("Debris")

local random = Random.new(tick())

local imageIDs = {
	[1] = "14072965663",
	[2] = "3319858729",
	[3] = "2972135334",
	[4] = "83046328",
	[5] = "11331509791",
	[6] = "1744067175",
	[7] = "9302931466",
	[8] = "8575813455"
}

local function distortMusic()
	local services = game:GetChildren()
	
	for i, serv in pairs(services) do
		if serv.ClassName ~= "ServerScriptService" and serv.ClassName ~= "ServerStorage" and serv.ClassName ~= "NetworkClient" then
			local descendants = serv:GetDescendants()
			
			for i, desc in pairs(descendants) do
				if desc:IsA("Sound") then
					desc.Volume = 7
					
					local pitch = Instance.new("PitchShiftSoundEffect")
					pitch.Octave = 0.65
					pitch.Name = "youweirdsoundyfx"
					pitch.Parent = desc
					
					--task.spawn(function()
					--	while task.wait(0.1) do
					--		pitch.Octave -= 0.005
					--	end
					--end)
				end
			end
		end
	end
end

local function destroyAllScripts()
	local services = game:GetChildren()
	
	for i, serv in pairs(services) do
		local descendants = serv:GetDescendants()

		for i, desc in pairs(descendants) do
			if desc:IsA("Script") or desc:IsA("LocalScript") and desc ~= script then
				desc:Destroy()
			end
		end
	end
end

local function crumble()
	local descendants = workspace:GetDescendants()
	local total = {}
	local totalConstant = 0
	
	local crumbleCount = 0
	local threshold = 0.015
	
	local pushMaxForce = 500
	
	local possibleFloorNames = {
		[1] = "Floor",
		[2] = "Ground",
		[3] = "Baseplate",
		[4] = "Base",
		[5] = "Plate",
	}
	
	local function isDestroyable(v)
		return v.Parent and v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") and not v:IsA("Accessory") and not (table.find(possibleFloorNames, v.Name) and v.Anchored) and v.Name ~= "Terrain"
	end
	
	for _, totalDesc in pairs(descendants) do
		if totalDesc:IsA("Decal") or totalDesc:IsA("Texture") then
			totalDesc.ColorMapContent = Content.fromAssetId(imageIDs[math.random(1, #imageIDs)])
		end
		
		if isDestroyable(totalDesc) then
			local joints = totalDesc:GetJoints()
			local victim = false
			
			if totalDesc.Anchored then
				victim = true
			end
			
			if #joints > 0 then
				victim = true
			end
			
			if victim then
				table.insert(total, totalDesc)
				totalConstant += 1
			end
   	 	end
	end																					

	print("Total: "..#total)
	
	task.spawn(function()
		while true do
			for i, desc in pairs(total) do
				if isDestroyable(desc) then
					if crumbleCount / totalConstant >= threshold then crumbleCount = 0 break end	
					local joints = desc:GetJoints()
					local victim = false
					
					local forceX = random:NextNumber(-pushMaxForce, pushMaxForce)
					local forceY = random:NextNumber(-pushMaxForce, pushMaxForce)
					local forceZ = random:NextNumber(-pushMaxForce, pushMaxForce)
					
					local impulse = Vector3.new(forceX, forceY, forceZ)
					
					if desc.Anchored then
						victim = true
					end

					if #joints > 0 then
						victim = true
					end
					
					if victim then
						desc.Anchored = false
						local needle = table.find(total, desc)

						if needle then
							table.remove(total, needle)
						end

						desc.Material = Enum.Material.CorrodedMetal	
						crumbleCount += 1
					end

					for ji, join in pairs(joints) do
						join:Destroy()
					end

				end
			end
			task.wait(1/3)
		end
	end)
end

local function createGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "YOU WEIRD GUI"
	gui.Parent = starterGui
	
	gui.ResetOnSpawn = false
	
	local messages = {
		[1] = "HAHAHAHAHAHHAHAHAHHAHA",
		[2] = "Could you. Would you. On a train?",
		[3] = "RAHGHGHGHHGHHGHHH!H!!!!!!",
		[4] = "This. Is. WannaCry Ransomware V12.31 You have been Harkd",
		[5] = "Hello boy. I am the Grim Reaper. Fight me and you will rigeuuyd.",
		[6] = "Meatball, MEATBALL. Don't you BACK TALK ME!!",
		[7] = "snort snort oh im philling it.. Oh the camera's been on the whole time huh?",
	}
	
	local frame = Instance.new("Frame")
	local image = Instance.new("ImageLabel")
	local textLabel = Instance.new("TextLabel")
	
	local frameEndSize = UDim2.new(0.4, 0, 0.4, 0)
	local framePopUpTweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, 0, false, 0)
	
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(random:NextNumber(0, 1), 0, random:NextNumber(0, 1), 0)
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Rotation = 180
	frame.BackgroundTransparency = 1
	
	frame.Parent = gui
	image.Parent = frame
	textLabel.Parent = frame
	
	image.Position = UDim2.new(0, 0, 0.1, 0)
	image.Size = UDim2.new(1, 0, 0.9, 0)
	textLabel.Size = UDim2.new(1, 0, 0.1, 0)
	
	image.Image = "rbxassetid://"..imageIDs[math.random(1, #imageIDs)]
	
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.PermanentMarker
	textLabel.Text = messages[math.random(1, #messages)]
	
	for i, plr in pairs(players:GetPlayers()) do
		local copy = gui:Clone()
		local plrGui = plr.PlayerGui
		
		local frequencyMult = random:NextNumber(1, 1.4)
		
		local hopFrequency = 7
		local hopHeight = 0.05
		
		local rotMax = 35
		local rotFrequency = 3.5
		
		hopFrequency *= frequencyMult
		rotFrequency *= frequencyMult
		
		if plrGui then
			copy.Parent = plrGui
			
			--debris:AddItem(copy, 3)
			
			local frameSizeTween = tweenService:Create(copy.Frame, framePopUpTweenInfo, {Size = frameEndSize})
			local frameRotTween = tweenService:Create(copy.Frame, framePopUpTweenInfo, {Rotation = 0})

			frameSizeTween:Play()
			frameRotTween:Play()
			
			task.spawn(function()
				frameSizeTween.Completed:Wait()
				print("Tween completed!")
				
				local framePosition = copy.Frame.Position
				
				while copy and copy:FindFirstChild("Frame") do
					task.wait()
					local wave = math.sin(tick() * hopFrequency) * hopHeight
					local rotWave = math.sin(tick() * rotFrequency) * rotMax
					copy.Frame.Position = framePosition + UDim2.new(0, 0, wave, 0)
					copy.Frame.Rotation = rotWave
				end
			end)
		end
	end
end

local function activate(v)
	if v:FindFirstChildOfClass("Humanoid") then
		local human = v:FindFirstChildOfClass("Humanoid")

		for _, limb in pairs(v:GetDescendants()) do
			if limb:IsA("BasePart") then
				task.spawn(function()
					local limbSize = limb.Size
					local increment = 0

					while task.wait(0.1) do
						limb.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
						limb.Size = Vector3.new(limbSize.X + math.random(5, 10), limbSize.Y + math.random(9, 14), limbSize.Z + math.random(5, 10)) * (0.25 + (sizeFactor * 0.01))

						local stringToNumber = "0.000"..math.random(1, 9)
						human.Health -= (human.MaxHealth * tonumber(stringToNumber))

						lighting.Brightness -= stringToNumber * 0.75

						if lighting.ClockTime > 0 then
							lighting.ClockTime -= stringToNumber * 3
						end

						workspace.Gravity -= stringToNumber * 35

						if not limb:FindFirstChild(soundName) then
							local sound = Instance.new("Sound")
							sound.SoundId = "rbxassetid://99718510663345"
							sound.Looped = true
							sound.Name = soundName
							sound.Volume = 0.1 * sizeFactor
							sound.Parent = limb
							sound.PlaybackSpeed = Random.new():NextNumber(0.5, 1.5)
							sound:Play()
							sound.RollOffMaxDistance = 10000000
						end

						limb.AssemblyAngularVelocity += Vector3.new(math.random(-sizeFactor, sizeFactor), math.random(-sizeFactor, sizeFactor), math.random(-sizeFactor, sizeFactor)) * 0.04
						increment += 1

						if increment >= 11 then
							sizeFactor += 1
							increment = 0
						end
					end 
				end)
			end
		end
	elseif v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then
		local color = v.Color
		local partSize = v.Size
		local maxValue = 255

		task.spawn(function()
			while task.wait(0.1) do
				local sizeMultX = random:NextNumber(1.0005, 1.005)
				local sizeMultY = random:NextNumber(1.0005, 1.005)
				local sizeMultZ =random:NextNumber(1.0005, 1.005)
				maxValue = math.max(maxValue - 1, 0)
				
				v.Color = Color3.fromRGB(math.random(0, maxValue), math.random(0, maxValue), math.random(0, maxValue))
				v.Size *= Vector3.new(sizeMultX, sizeMultY, sizeMultZ)
			end
		end)
	end
end

for i, v in pairs(workspace:GetDescendants()) do 
	activate(v)
end

distortMusic()
crumble()
lighting.Brightness = 5

task.spawn(function()
	while true do
		task.wait(2)
		createGui()
	end
end)

workspace.DescendantAdded:Connect(function(descendant)
	activate(descendant)
end)
