-- FIXED CLIENT PLANTING SCRIPT
-- Put this in StarterPlayerScripts
-- Name it: "FixedPlantingClient"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

print("🌱 FIXED PLANTING CLIENT: Starting...")

-- Wait for RemoteEvents
local plantSeedEvent = ReplicatedStorage:WaitForChild("PlantSeed")
local enterPlantingMode = ReplicatedStorage:WaitForChild("EnterPlantingMode")
local seedInventoryEvent = ReplicatedStorage:WaitForChild("SeedInventoryEvent")

-- Variables
local isPlantingMode = false
local selectedSeedType = nil
local seedsRemaining = 0
local plantingGui = nil

-- Create GUI for planting mode
local function createPlantingGui()
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Remove old GUI
    local oldGui = playerGui:FindFirstChild("PlantingModeGui")
    if oldGui then
        oldGui:Destroy()
    end
    
    plantingGui = Instance.new("ScreenGui")
    plantingGui.Name = "PlantingModeGui"
    plantingGui.Parent = playerGui
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Name = "StatusFrame"
    statusFrame.Size = UDim2.new(0, 350, 0, 80)
    statusFrame.Position = UDim2.new(0.5, -175, 0, 20)
    statusFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.BorderSizePixel = 0
    statusFrame.Visible = false
    statusFrame.Parent = plantingGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = statusFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.Parent = statusFrame
    
    return statusFrame
end

-- Function to check if clicking on flower bed
local function isValidPlantingSpot(position)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    -- Cast ray downward from click position
    local raycastResult = workspace:Raycast(position + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0), raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        local hitName = hitPart.Name:lower()
        local parentName = hitPart.Parent.Name:lower()
        
        -- Check if it's a flower bed or soil
        if hitName:find("flower") or hitName:find("bed") or hitName:find("soil") or 
           hitName:find("dirt") or hitName:find("garden") or
           parentName:find("flower") or parentName:find("bed") then
            print("✅ Valid planting spot found:", hitPart.Name)
            return true, raycastResult.Position
        end
        
        -- Check by material
        if hitPart.Material == Enum.Material.Ground or 
           hitPart.Material == Enum.Material.LeafyGrass or
           hitPart.Material == Enum.Material.Grass then
            print("✅ Valid planting spot (by material):", hitPart.Material.Name)
            return true, raycastResult.Position
        end
        
        -- Check by color (brown/dirt colors)
        local color = hitPart.Color
        if (color.R > 0.3 and color.R < 0.7) and (color.G > 0.2 and color.G < 0.6) and (color.B < 0.4) then
            print("✅ Valid planting spot (by color)")
            return true, raycastResult.Position
        end
        
        print("❌ Invalid planting spot:", hitPart.Name, "Material:", hitPart.Material.Name)
        return false, nil
    end
    
    print("❌ No surface found to plant on")
    return false, nil
end

-- Function to start planting mode
local function startPlantingMode(seedType, quantity)
    if isPlantingMode then
        print("⚠️ Already in planting mode, stopping current mode first")
        stopPlantingMode()
        wait(0.1)
    end
    
    print("🌱 Starting planting mode:", seedType, "with", quantity, "seeds")
    
    isPlantingMode = true
    selectedSeedType = seedType
    seedsRemaining = quantity
    
    -- Create GUI if needed
    if not plantingGui then
        createPlantingGui()
    end
    
    local statusFrame = plantingGui:FindFirstChild("StatusFrame")
    local statusLabel = statusFrame:FindFirstChild("StatusLabel")
    
    -- Update GUI
    local seedIcons = {
        Carrot = "🥕",
        Tomato = "🍅",
        Wheat = "🌾", 
        Corn = "🌽",
        Potato = "🥔"
    }
    
    statusLabel.Text = "🌱 PLANTING MODE: " .. (seedIcons[seedType] or "🌱") .. " " .. seedType .. "\n" .. 
                      "Seeds: " .. seedsRemaining .. " | Click flower beds to plant! | Press C to cancel"
    statusFrame.Visible = true
    
    -- Change cursor
    mouse.Icon = "rbxasset://textures/ArrowCursor.png"
    
    print("✅ Planting mode activated")
end

-- Function to stop planting mode
function stopPlantingMode()
    if not isPlantingMode then return end
    
    print("🛑 Stopping planting mode")
    
    isPlantingMode = false
    selectedSeedType = nil
    seedsRemaining = 0
    
    -- Reset cursor
    mouse.Icon = ""
    
    -- Hide GUI
    if plantingGui then
        local statusFrame = plantingGui:FindFirstChild("StatusFrame")
        if statusFrame then
            statusFrame.Visible = false
        end
    end
    
    print("✅ Planting mode stopped")
end

-- Function to plant seed
local function plantSeed(position)
    if not isPlantingMode or not selectedSeedType or seedsRemaining <= 0 then
        print("❌ Cannot plant: not in planting mode or no seeds")
        return
    end
    
    local isValid, plantPosition = isValidPlantingSpot(position)
    if not isValid then
        -- Show error message
        StarterGui:SetCore("SendNotification", {
            Title = "❌ Invalid Location";
            Text = "Seeds can only be planted on flower beds!";
            Duration = 2;
        })
        return
    end
    
    print("🌱 Planting", selectedSeedType, "at", plantPosition)
    
    -- Send to server
    plantSeedEvent:FireServer(selectedSeedType, plantPosition)
    
    -- Update local count
    seedsRemaining = seedsRemaining - 1
    
    -- Update GUI
    if plantingGui then
        local statusFrame = plantingGui:FindFirstChild("StatusFrame")
        local statusLabel = statusFrame:FindFirstChild("StatusLabel")
        
        local seedIcons = {
            Carrot = "🥕",
            Tomato = "🍅", 
            Wheat = "🌾",
            Corn = "🌽",
            Potato = "🥔"
        }
        
        if seedsRemaining > 0 then
            statusLabel.Text = "🌱 PLANTING MODE: " .. (seedIcons[selectedSeedType] or "🌱") .. " " .. selectedSeedType .. "\n" .. 
                              "Seeds: " .. seedsRemaining .. " | Click flower beds to plant! | Press C to cancel"
        else
            statusLabel.Text = "✅ All seeds planted! Exiting planting mode..."
            wait(1)
            stopPlantingMode()
        end
    end
    
    -- Show success notification
    StarterGui:SetCore("SendNotification", {
        Title = "🌱 Planted!";
        Text = "Planted " .. selectedSeedType .. " seed!";
        Duration = 1.5;
    })
end

-- Handle mouse clicks
mouse.Button1Down:Connect(function()
    if not isPlantingMode then return end
    
    local hit = mouse.Hit
    if hit then
        plantSeed(hit.Position)
    end
end)

-- Handle keyboard input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.C and isPlantingMode then
        print("🛑 Player cancelled planting mode")
        stopPlantingMode()
    end
end)

-- Handle server events
enterPlantingMode.OnClientEvent:Connect(function(seedType, quantity)
    print("📨 Received planting mode request:", seedType, quantity)
    startPlantingMode(seedType, quantity)
end)

-- Handle plant results
seedInventoryEvent.OnClientEvent:Connect(function(action, ...)
    local args = {...}
    
    if action == "PlantResult" then
        local success, message = args[1], args[2]
        
        if success then
            print("✅ Plant success:", message)
        else
            print("❌ Plant failed:", message)
            StarterGui:SetCore("SendNotification", {
                Title = "❌ Planting Failed";
                Text = message;
                Duration = 3;
            })
        end
    end
end)

-- Create initial GUI
createPlantingGui()

print("✅ FIXED PLANTING CLIENT: Loaded successfully!")
print("🎮 Controls:")
print("  - Use seed tools from hotbar to enter planting mode")
print("  - Click on flower beds to plant")
print("  - Press C to cancel planting")