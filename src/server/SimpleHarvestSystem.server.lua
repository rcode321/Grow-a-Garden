-- FIXED HARVEST SYSTEM - SERVER SCRIPT
-- Put this in ServerScriptService
-- This will replace your current SimpleHarvestSystem

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

print("🌾 FIXED Harvest System starting...")

-- Create RemoteEvent for harvest notifications
local harvestEvent = ReplicatedStorage:FindFirstChild("HarvestPlant")
if not harvestEvent then
    harvestEvent = Instance.new("RemoteEvent")
    harvestEvent.Name = "HarvestPlant"
    harvestEvent.Parent = ReplicatedStorage
end

-- FIXED: Plant detection patterns
local PLANT_PATTERNS = {
    "Carrot",
    "Tomato", 
    "Potato",
    "Plant",
    "Wheat",
    "Corn"
}

-- Function to check if model is a plant
local function isPlantModel(model)
    if not model or not model:IsA("Model") then return false end
    
    for _, pattern in pairs(PLANT_PATTERNS) do
        if model.Name:find(pattern) then
            return true, pattern
        end
    end
    return false
end

-- FIXED: Harvest function with better error handling
local function harvestPlant(plant, player)
    print("🌾 HARVESTING:", plant.Name, "by", player.Name)
    
    -- Determine plant type and rewards
    local plantType = "Unknown"
    local coinReward = 20
    local expReward = 10
    
    if plant.Name:find("Carrot") then
        plantType = "Carrot"
        coinReward = 25
    elseif plant.Name:find("Tomato") then
        plantType = "Tomato"
        coinReward = 30
    elseif plant.Name:find("Potato") then
        plantType = "Potato"
        coinReward = 20
    elseif plant.Name:find("Plant") then
        plantType = "Plant"
        coinReward = 15
    end
    
    -- Give rewards to player
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local coins = leaderstats:FindFirstChild("Coins")
        if coins then
            coins.Value = coins.Value + coinReward
            print("💰 Gave", coinReward, "coins to", player.Name, "New total:", coins.Value)
        end
        
        -- Add experience if stat exists
        local exp = leaderstats:FindFirstChild("Experience") or leaderstats:FindFirstChild("XP")
        if exp then
            exp.Value = exp.Value + expReward
            print("⭐ Gave", expReward, "XP to", player.Name)
        end
    end
    
    -- Fire client event for notifications
    harvestEvent:FireClient(player, "HarvestSuccess", {
        plantType = plantType,
        coins = coinReward,
        experience = expReward
    })
    
    print("✅ Successfully harvested", plant.Name)
    
    -- Destroy the plant with safety check
    if plant and plant.Parent then
        print("🗑️ Destroying plant...")
        plant:Destroy()
        print("✅ Plant destroyed!")
    end
end

-- FIXED: Make any model harvestable with better part detection
local function makeModelHarvestable(model)
    if not model or not model:IsA("Model") then return false end
    
    local isPlant, plantType = isPlantModel(model)
    if not isPlant then return false end
    
    print("🔧 Making harvestable:", model.Name)
    
    -- FIXED: Better part detection priority
    local targetPart = nil
    
    -- Priority order for finding the best part to click
    local partPriority = {"Soil", "Part", "Handle", "HitBox", "Main"}
    
    -- Try priority parts first
    for _, partName in pairs(partPriority) do
        targetPart = model:FindFirstChild(partName)
        if targetPart and targetPart:IsA("BasePart") then
            print("✅ Found priority part:", partName)
            break
        end
    end
    
    -- If no priority part found, use PrimaryPart or any BasePart
    if not targetPart then
        targetPart = model.PrimaryPart or model:FindFirstChildOfClass("BasePart")
    end
    
    if not targetPart then
        print("❌ No suitable part found in:", model.Name)
        return false
    end
    
    print("🎯 Using part:", targetPart.Name, "for clicking")
    
    -- FIXED: Remove any existing ClickDetectors completely
    for _, descendant in pairs(model:GetDescendants()) do
        if descendant:IsA("ClickDetector") then
            descendant:Destroy()
        end
    end
    
    -- Create new ClickDetector
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 20  -- Increased for easier clicking
    clickDetector.CursorIcon = "rbxasset://textures/GunCursor.png"  -- Shows hand cursor
    clickDetector.Parent = targetPart
    
    print("✅ Added ClickDetector to:", targetPart.Name)
    
    -- FIXED: Better visual indicator
    local function addHarvestGlow()
        -- Remove old glow effects first
        for _, descendant in pairs(model:GetDescendants()) do
            if descendant.Name == "HarvestGlow" or descendant.Name == "HarvestEffect" then
                descendant:Destroy()
            end
        end
        
        -- Add green glow effect
        local pointLight = Instance.new("PointLight")
        pointLight.Name = "HarvestGlow"
        pointLight.Brightness = 2
        pointLight.Range = 8
        pointLight.Color = Color3.fromRGB(0, 255, 0)  -- Bright green
        pointLight.Parent = targetPart
        
        -- Add selection box for better visibility
        local selectionBox = Instance.new("SelectionBox")
        selectionBox.Name = "HarvestEffect"
        selectionBox.Adornee = targetPart
        selectionBox.Color3 = Color3.fromRGB(0, 255, 0)
        selectionBox.Transparency = 0.5
        selectionBox.LineThickness = 0.2
        selectionBox.Parent = targetPart
        
        print("✅ Added harvest effects to:", targetPart.Name)
    end
    
    addHarvestGlow()
    
    -- FIXED: Connect click event with error handling
    clickDetector.MouseClick:Connect(function(clickingPlayer)
        print("🖱️ CLICK DETECTED! Player:", clickingPlayer.Name, "clicked:", model.Name)
        
        -- Verify player and model still exist
        if not clickingPlayer or not clickingPlayer.Parent then
            print("❌ Invalid player")
            return
        end
        
        if not model or not model.Parent then
            print("❌ Model no longer exists")
            return
        end
        
        -- Call harvest function
        pcall(function()
            harvestPlant(model, clickingPlayer)
        end)
    end)
    
    print("✅ Model is now harvestable:", model.Name)
    return true
end

-- FIXED: Auto-setup existing plants with delay
local function setupExistingPlants()
    print("🔧 Setting up existing plants...")
    local count = 0
    
    for _, obj in pairs(workspace:GetChildren()) do
        if isPlantModel(obj) then
            if makeModelHarvestable(obj) then
                count = count + 1
            end
        end
    end
    
    print("✅ Made", count, "existing plants harvestable!")
end

-- FIXED: Monitor for new plants with proper checks
workspace.ChildAdded:Connect(function(obj)
    if not obj or not obj:IsA("Model") then return end
    
    -- Wait a moment for the plant to fully load
    task.wait(0.5)
    
    -- Check if it's still there and is a plant
    if obj.Parent and isPlantModel(obj) then
        print("🌱 New plant detected:", obj.Name)
        
        -- Additional wait for plant systems to finish loading
        task.wait(1)
        
        if obj.Parent then  -- Make sure it still exists
            makeModelHarvestable(obj)
        end
    end
end)

-- Debug commands
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        local msg = message:lower()
        
        if msg == "/makeharvest" or msg == "/fixharvest" then
            setupExistingPlants()
            
        elseif msg == "/listplants" then
            print("🔍 LISTING ALL PLANTS:")
            print("=" .. string.rep("=", 50))
            
            local plantCount = 0
            for _, obj in pairs(workspace:GetChildren()) do
                local isPlant, plantType = isPlantModel(obj)
                if isPlant then
                    plantCount = plantCount + 1
                    print("🌱 Plant #" .. plantCount .. ":", obj.Name, "(" .. plantType .. ")")
                    
                    -- Check for ClickDetector
                    local hasClick = false
                    for _, desc in pairs(obj:GetDescendants()) do
                        if desc:IsA("ClickDetector") then
                            hasClick = true
                            break
                        end
                    end
                    
                    print("   ClickDetector:", hasClick and "✅ YES" or "❌ NO")
                    
                    -- Check for parts
                    local parts = {}
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("BasePart") then
                            table.insert(parts, child.Name)
                        end
                    end
                    print("   Parts:", table.concat(parts, ", "))
                end
            end
            
            print("=" .. string.rep("=", 50))
            print("🌱 Total plants found:", plantCount)
            
        elseif msg == "/testclick" then
            print("🧪 TESTING HARVEST...")
            
            for _, obj in pairs(workspace:GetChildren()) do
                if isPlantModel(obj) then
                    print("🧪 Testing harvest on:", obj.Name)
                    harvestPlant(obj, player)
                    break
                end
            end
            
        elseif msg == "/forcefix" then
            print("🔧 FORCE FIXING ALL PLANTS...")
            
            for _, obj in pairs(workspace:GetChildren()) do
                if isPlantModel(obj) then
                    -- Remove all existing ClickDetectors
                    for _, desc in pairs(obj:GetDescendants()) do
                        if desc:IsA("ClickDetector") then
                            desc:Destroy()
                        end
                    end
                    
                    -- Re-add harvest capability
                    task.wait(0.1)
                    makeModelHarvestable(obj)
                end
            end
            
            print("✅ Force fix completed!")
        end
    end)
end)

-- Initial setup with delay
task.wait(3)
setupExistingPlants()

print("✅ FIXED Harvest System loaded!")
print("🔧 Commands:")
print("   /makeharvest or /fixharvest - Setup all plants")
print("   /listplants - Show all plants and their status") 
print("   /testclick - Test harvesting")
print("   /forcefix - Force fix all plants")
print("💡 Look for GREEN glow and selection boxes on harvestable plants!")
print("🎯 Plants should show hand cursor when hovering!")