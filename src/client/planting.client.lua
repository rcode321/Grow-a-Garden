-- SIMPLE PLANTING CLIENT
-- Put this in StarterPlayerScripts
-- Name it: "SimplePlantingClient"
print("🚨 SCRIPT STARTED - FIRST LINE!")

local Players = game:GetService("Players")
print("✅ Got Players service")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
print("✅ Got ReplicatedStorage service")
local UserInputService = game:GetService("UserInputService")
print("✅ Got UserInputService")
local StarterGui = game:GetService("StarterGui")
print("✅ Got StarterGui service")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
print("✅ Got player and mouse")

print("🌱 SIMPLE PLANTING: Starting TODAY!!!!!!! HOHOHOHOHOHOHO.")

-- Wait for RemoteEvents with debug
print("⏳ About to wait for SeedInventoryEvent...")
local seedInventoryEvent = ReplicatedStorage:WaitForChild("SeedInventoryEvent")
print("✅ Found SeedInventoryEvent!")

print("⏳ About to wait for PlantSeed...")
local plantSeedEvent = ReplicatedStorage:WaitForChild("PlantSeed")
print("✅ Found PlantSeed!")

print("🔍 seedInventoryEvent:", seedInventoryEvent)
print("🔍 plantSeedEvent:", plantSeedEvent)

if not seedInventoryEvent or not plantSeedEvent then
	warn("❌ SIMPLE PLANTING: Required RemoteEvents not found!")
	return
end

-- Planting mode variables
local isPlantingMode = false
local selectedSeedType = nil
local seedsToPlant = 0

-- GUI for planting mode indicator
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlantingModeGui"
screenGui.Parent = player.PlayerGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 300, 0, 50)
statusLabel.Position = UDim2.new(0.5, -150, 0, 20)
statusLabel.BackgroundColor3 = Color3.new(0, 0.5, 0)
statusLabel.BackgroundTransparency = 0.3
statusLabel.BorderSizePixel = 2
statusLabel.BorderColor3 = Color3.new(0, 1, 0)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.Visible = false
statusLabel.Parent = screenGui

-- Function to check if position is on a flower bed
local function isOnFlowerBed(position)
	-- Raycast downward to check what's beneath the click position
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

	-- Create a whitelist of flower bed parts
	local flowerBedParts = {}

	-- Look for the "Flower bed (Commercial)" model and get its parts
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "Flower bed (Commercial)" then
			-- Get all parts within this flower bed model
			for _, part in pairs(obj:GetDescendants()) do
				if part:IsA("BasePart") and part.Name == "Part" then
					table.insert(flowerBedParts, part)
				end
			end
		end
	end

	-- Also check for individual parts that might be flower beds
	if #flowerBedParts == 0 then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				-- Check if the part is named something related to flower beds
				local name = obj.Name:lower()
				if name:find("flower") or name:find("bed") or name:find("soil") or name:find("dirt") or name:find("garden") then
					table.insert(flowerBedParts, obj)
				end
				-- Check if the parent is a flower bed model
				if obj.Parent and obj.Parent.Name and obj.Parent.Name:lower():find("flower") then
					table.insert(flowerBedParts, obj)
				end
			end
		end
	end

	-- If still no flower bed parts found, check by material or color
	if #flowerBedParts == 0 then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				-- Check for brown/dirt colored parts or specific materials
				if obj.Material == Enum.Material.Ground or 
					obj.Material == Enum.Material.LeafyGrass or
					obj.Material == Enum.Material.Grass or
					(obj.BrickColor == BrickColor.new("Reddish brown") or 
						obj.BrickColor == BrickColor.new("Dark orange") or
						obj.BrickColor == BrickColor.new("Dirt brown")) then
					table.insert(flowerBedParts, obj)
				end
			end
		end
	end

	if #flowerBedParts == 0 then
		print("🌱 DEBUG: No flower bed parts found in workspace")
		return false -- No flower beds found
	end

	print("🌱 DEBUG: Found", #flowerBedParts, "flower bed parts")
	raycastParams.FilterDescendantsInstances = flowerBedParts

	-- Cast ray from above the position downward
	local raycastResult = workspace:Raycast(position + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0), raycastParams)

	if raycastResult then
		print("🌱 DEBUG: Hit flower bed part:", raycastResult.Instance.Name)
		return true
	else
		print("🌱 DEBUG: No flower bed hit at position:", position)
		return false
	end
end

-- Function to start planting mode
local function startPlantingMode(seedType, quantity)
	print("🌱 Starting planting mode for", quantity, seedType, "seeds")
	isPlantingMode = true
	selectedSeedType = seedType
	seedsToPlant = quantity or 1

	-- Change mouse cursor to indicate planting mode
	mouse.Icon = "rbxasset://textures/ArrowCursor.png"

	-- Show planting mode status
	statusLabel.Text = "🌱 PLANTING MODE ACTIVE 🌱\n" .. seedType .. " (" .. seedsToPlant .. " remaining)\nClick on flower beds to plant!"
	statusLabel.Visible = true

	-- Send notification
	StarterGui:SetCore("SendNotification", {
		Title = "Planting Mode Active";
		Text = "Click on flower beds to plant " .. seedType;
		Duration = 3;
	})

	print("🌱 PLANTING MODE ACTIVE - Click on flower beds to plant", seedType)
	print("🌱 Seeds remaining to plant:", seedsToPlant)
end

-- Function to stop planting mode
local function stopPlantingMode()
	isPlantingMode = false
	selectedSeedType = nil
	seedsToPlant = 0
	mouse.Icon = ""
	statusLabel.Visible = false

	-- Send notification
	StarterGui:SetCore("SendNotification", {
		Title = "Planting Mode Stopped";
		Text = "No longer in planting mode";
		Duration = 2;
	})

	print("🌱 Planting mode stopped")
end

-- Function to plant seed at position
local function plantSeedAtPosition(position)
	if not isPlantingMode or not selectedSeedType or seedsToPlant <= 0 then
		return
	end

	-- Check if position is on a flower bed
	if not isOnFlowerBed(position) then
		print("🌱 Cannot plant here - must plant on flower beds only!")
		StarterGui:SetCore("SendNotification", {
			Title = "Invalid Location";
			Text = "Seeds can only be planted on flower beds!";
			Duration = 2;
		})
		return
	end

	print("🌱 Planting", selectedSeedType, "at", position)

	-- Send plant request to server
	plantSeedEvent:FireServer(selectedSeedType, position)

	-- Reduce seeds to plant
	seedsToPlant = seedsToPlant - 1
	print("🌱 Seeds remaining to plant:", seedsToPlant)

	-- Update status label
	if seedsToPlant > 0 then
		statusLabel.Text = "🌱 PLANTING MODE ACTIVE 🌱\n" .. selectedSeedType .. " (" .. seedsToPlant .. " remaining)\nClick on flower beds to plant!"
	end

	-- Stop planting mode if no more seeds
	if seedsToPlant <= 0 then
		stopPlantingMode()
	end
end

-- Handle mouse clicks for planting
mouse.Button1Down:Connect(function()
	if not isPlantingMode then return end

	local hit = mouse.Hit
	if hit then
		local position = hit.Position
		-- Basic ground check (reasonable Y coordinate)
		if position.Y > -50 and position.Y < 100 then
			plantSeedAtPosition(position)
		else
			print("🌱 Cannot plant here - invalid location")
		end
	end
end)

-- Handle server events
seedInventoryEvent.OnClientEvent:Connect(function(action, ...)
	local args = {...}
	if action == "StartPlanting" then
		local seedType = args[1]
		local quantity = args[2] or 1
		startPlantingMode(seedType, quantity)
	elseif action == "PlantResult" then
		local success, message = args[1], args[2]
		print("🌱 Plant result:", message)
		if success then
			StarterGui:SetCore("SendNotification", {
				Title = "Plant Success";
				Text = message;
				Duration = 2;
			})
		else
			StarterGui:SetCore("SendNotification", {
				Title = "Plant Failed";
				Text = message;
				Duration = 3;
			})
		end
	end
end)

-- Handle escape key to cancel planting
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.C and isPlantingMode then
		print("🌱 Planting cancelled by player")
		stopPlantingMode()
	end
end)

print("✅ SIMPLE PLANTING: Loaded!")
print("🎮 CONTROLS:")
print("  - Convert seeds from inventory to enter planting mode")
print("  - Click on flower beds to plant seeds")
print("  - C = Cancel planting mode")