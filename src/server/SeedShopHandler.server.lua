-- -- COMPLETE WORKING SEEDSHOPHANDLER
-- -- Replace your ENTIRE SeedShopHandler.server.lua with this

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ServerStorage = game:GetService("ServerStorage")
-- local Players = game:GetService("Players")
-- local RunService = game:GetService("RunService")

-- -- Create RemoteEvents if they don't exist
-- local function getOrCreateRemoteEvent(name)
--     local event = ReplicatedStorage:FindFirstChild(name)
--     if not event then
--         event = Instance.new("RemoteEvent")
--         event.Name = name
--         event.Parent = ReplicatedStorage
--         print("✅ Created RemoteEvent:", name)
--     end
--     return event
-- end

-- local seedShopEvent = getOrCreateRemoteEvent("SeedShopEvent")
-- local plantSeedEvent = getOrCreateRemoteEvent("PlantSeed")
-- local enterPlantingMode = getOrCreateRemoteEvent("EnterPlantingMode")

-- -- Create SeedItems folder if it doesn't exist
-- local seedItems = ReplicatedStorage:FindFirstChild("SeedItems")
-- if not seedItems then
--     seedItems = Instance.new("Folder")
--     seedItems.Name = "SeedItems"
--     seedItems.Parent = ReplicatedStorage
--     print("✅ Created SeedItems folder")
-- end

-- print("🌱 Enhanced 3D Visual Hotbar Seed System starting...")

-- -- PLANT TEMPLATES - Based on your debug script results
-- local PLANT_TEMPLATES = {
--     Carrot = "Carrot_grown",
--     Tomato = "tomato plant", 
--     Potato = "Plant",
--     Wheat = "Plant",
--     Corn = "Plant"
-- }

-- -- Debug function to find plant template
-- local function findPlantTemplate(plantType)
--     print("🔍 Looking for template for:", plantType)
    
--     local templateName = PLANT_TEMPLATES[plantType]
--     print("📝 Template name from table:", templateName)
    
--     if not templateName then
--         templateName = "Plant"
--         print("⚠️ Using fallback template name:", templateName)
--     end
    
--     -- Debug: Show what's in workspace
--     print("🌍 Current models in workspace:")
--     for _, obj in pairs(workspace:GetChildren()) do
--         if obj:IsA("Model") then
--             local name = obj.Name
--             if name:lower():find("plant") or name:lower():find("carrot") or name:lower():find("tomato") then
--                 print("  📦 Found model:", name)
--             end
--         end
--     end
    
--     -- Try workspace first
--     print("🔍 Searching workspace for:", templateName)
--     local template = workspace:FindFirstChild(templateName)
--     if template and template:IsA("Model") then
--         print("✅ Found template in workspace:", templateName)
        
--         -- Check components
--         local partCount = 0
--         local hasScript = false
--         for _, child in pairs(template:GetDescendants()) do
--             if child:IsA("BasePart") then
--                 partCount = partCount + 1
--             end
--             if child:IsA("Script") then
--                 hasScript = true
--             end
--         end
--         print("   📊 Parts:", partCount, "| Has Script:", hasScript)
--         print("   🎯 Primary Part:", template.PrimaryPart and template.PrimaryPart.Name or "None")
        
--         return template
--     else
--         print("❌ Not found in workspace or not a model")
--     end
    
--     -- Try case-insensitive search
--     print("🔍 Trying case-insensitive search in workspace...")
--     for _, obj in pairs(workspace:GetChildren()) do
--         if obj:IsA("Model") and obj.Name:lower() == templateName:lower() then
--             print("✅ Found with case-insensitive search:", obj.Name)
--             return obj
--         end
--     end
    
--     -- Last resort: find any matching plant
--     print("🔍 Last resort: searching for any plant matching", plantType)
--     for _, obj in pairs(workspace:GetChildren()) do
--         if obj:IsA("Model") then
--             local name = obj.Name:lower()
--             local plantTypeLower = plantType:lower()
            
--             if name:find(plantTypeLower) then
--                 print("✅ Found matching plant:", obj.Name)
--                 return obj
--             end
--         end
--     end
    
--     warn("❌ No plant template found for:", plantType, "after exhaustive search")
--     print("💡 Available models in workspace:")
--     for _, obj in pairs(workspace:GetChildren()) do
--         if obj:IsA("Model") then
--             print("   -", obj.Name)
--         end
--     end
    
--     return nil
-- end

-- -- Function to spawn plant at position
-- local function spawnPlant(plantType, position, player)
--     local template = findPlantTemplate(plantType)
--     if not template then
--         return false, "Plant template not found for " .. plantType
--     end

--     -- Clone the template
--     local newPlant = template:Clone()
--     newPlant.Name = plantType .. "_" .. player.Name .. "_" .. tick()

--     -- Position the plant
--     local success = false
--     local plantPosition = position + Vector3.new(0, 1, 0)
    
--     if newPlant.PrimaryPart then
--         newPlant:SetPrimaryPartCFrame(CFrame.new(plantPosition))
--         success = true
--     else
--         local anchorPart = newPlant:FindFirstChild("Soil") or 
--                           newPlant:FindFirstChild("Part") or
--                           newPlant:FindFirstChildOfClass("BasePart")
        
--         if anchorPart then
--             anchorPart.Position = plantPosition
--             newPlant.PrimaryPart = anchorPart
--             success = true
--         end
--     end
    
--     if not success then
--         warn("❌ Could not position plant")
--         newPlant:Destroy()
--         return false, "Could not position plant"
--     end

--     -- Setup parts
--     for _, part in pairs(newPlant:GetDescendants()) do
--         if part:IsA("BasePart") then
--             part.Anchored = true
--             part.CanCollide = false
--         end
--     end

--     -- Place in workspace
--     newPlant.Parent = workspace
    
--     print("✅ Successfully spawned", plantType, "for", player.Name)
--     return true, "Successfully planted " .. plantType .. "!"
-- end

-- -- Function to create 3D seed tools with proper models
-- local function createSeedTool(player, seedType, quantity)
--     if not player or not player.Parent then 
--         return 
--     end
    
--     local backpack = player:FindFirstChild("Backpack")
--     if not backpack then 
--         return 
--     end
    
--     print("🔧 Creating 3D tool:", seedType, "Seeds (", quantity, ") for", player.Name)
    
--     -- Remove old tools
--     for _, tool in pairs(backpack:GetChildren()) do
--         if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
--             tool:Destroy()
--         end
--     end
    
--     if player.Character then
--         for _, tool in pairs(player.Character:GetChildren()) do
--             if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
--                 tool:Destroy()
--             end
--         end
--     end
    
--     if quantity <= 0 then 
--         return 
--     end
    
--     -- Create the tool
--     local tool = Instance.new("Tool")
--     tool.Name = seedType .. " Seeds"
--     tool.RequiresHandle = true
--     tool.CanBeDropped = false
--     tool.Grip = CFrame.new(0, -1, 0)
    
--     local seedIcons = {
--         Carrot = "🥕",
--         Tomato = "🍅", 
--         Wheat = "🌾",
--         Corn = "🌽",
--         Potato = "🥔"
--     }
    
--     tool.ToolTip = (seedIcons[seedType] or "🌱") .. " " .. seedType .. " Seeds (" .. quantity .. ")"
    
--     -- Create 3D handle
--     local handle = Instance.new("Part")
--     handle.Name = "Handle"
--     handle.Size = Vector3.new(1, 1, 1)
--     handle.Material = Enum.Material.Neon
--     handle.Shape = Enum.PartType.Ball
--     handle.CanCollide = false
--     handle.Anchored = false
--     handle.Parent = tool
    
--     -- Seed colors
--     local seedColors = {
--         Carrot = Color3.fromRGB(255, 140, 50),
--         Potato = Color3.fromRGB(139, 117, 82),
--         Tomato = Color3.fromRGB(255, 80, 80),
--         Wheat = Color3.fromRGB(218, 165, 32),
--         Corn = Color3.fromRGB(255, 215, 0)
--     }
    
--     handle.Color = seedColors[seedType] or Color3.fromRGB(100, 200, 100)
    
--     -- Add glow effect
--     local pointLight = Instance.new("PointLight")
--     pointLight.Color = handle.Color
--     pointLight.Brightness = 1
--     pointLight.Range = 5
--     pointLight.Parent = handle
    
--     -- Add particles
--     local attachment = Instance.new("Attachment")
--     attachment.Parent = handle
    
--     local particles = Instance.new("ParticleEmitter")
--     particles.Parent = attachment
--     particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
--     particles.Color = ColorSequence.new(handle.Color)
--     particles.Size = NumberSequence.new{
--         NumberSequenceKeypoint.new(0, 0.2),
--         NumberSequenceKeypoint.new(1, 0.5)
--     }
--     particles.Lifetime = NumberRange.new(0.8, 2.0)
--     particles.Rate = 20
--     particles.SpreadAngle = Vector2.new(45, 45)
--     particles.Speed = NumberRange.new(2, 4)
--     particles.Enabled = true
    
--     -- Store seed info
--     local seedTypeValue = Instance.new("StringValue")
--     seedTypeValue.Name = "SeedType"
--     seedTypeValue.Value = seedType
--     seedTypeValue.Parent = tool
    
--     local quantityValue = Instance.new("IntValue")
--     quantityValue.Name = "Quantity"
--     quantityValue.Value = quantity
--     quantityValue.Parent = tool
    
--     -- Tool activation handling
--     tool.Activated:Connect(function()
--         print("🌱 Player", player.Name, "activated", seedType, "seeds tool")
        
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if leaderstats then
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             if seedStat and seedStat.Value > 0 then
--                 enterPlantingMode:FireClient(player, seedType, seedStat.Value)
--                 print("🎯 Sent planting mode to client for", player.Name, "with", seedType)
--             else
--                 print("❌ No seeds left for", seedType)
--                 tool:Destroy()
--             end
--         end
--     end)
    
--     tool.Equipped:Connect(function()
--         print("🔧 Player", player.Name, "equipped", seedType, "seeds")
--         if particles then
--             particles.Rate = 40
--         end
--     end)
    
--     tool.Unequipped:Connect(function()
--         print("🔄 Player", player.Name, "unequipped", seedType, "seeds")
--         if particles then
--             particles.Rate = 20
--         end
--     end)
    
--     tool.Parent = backpack
--     print("✅ Successfully created 3D tool:", tool.Name, "for", player.Name)
--     return tool
-- end

-- -- Function to update player seeds
-- local function updatePlayerSeeds(player, seedType, newQuantity)
--     print("📊 Updating", seedType, "seeds to", newQuantity, "for", player.Name)
    
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if leaderstats then
--         local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--         if seedStat then
--             seedStat.Value = newQuantity
--             print("✅ Updated leaderstat", seedType .. "_Seeds to", newQuantity)
--         end
--     end
    
--     createSeedTool(player, seedType, newQuantity)
-- end

-- -- Handle shop purchases
-- seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
--     if action == "PurchaseSeeds" then
--         print("🛒 Purchase request:", player.Name, "wants", seedType)
        
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if not leaderstats then
--             return
--         end
        
--         local coinsValue = leaderstats:FindFirstChild("Coins")
--         if not coinsValue then
--             return
--         end
        
--         local seedPrices = {
--             Carrot = 8,
--             Potato = 10,
--             Tomato = 5,
--             Wheat = 12,
--             Corn = 15
--         }
        
--         local price = seedPrices[seedType] or 10
        
--         if coinsValue.Value >= price then
--             coinsValue.Value = coinsValue.Value - price
            
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             local currentSeeds = seedStat and seedStat.Value or 0
--             local newSeedCount = currentSeeds + 1
            
--             updatePlayerSeeds(player, seedType, newSeedCount)
            
--             seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchased " .. seedType .. " seeds!")
--             print("✅ Purchase completed:", player.Name, "bought", seedType, "seeds")
--         else
--             seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!")
--         end
--     end
-- end)

-- -- Handle planting requests
-- plantSeedEvent.OnServerEvent:Connect(function(player, seedType, targetPosition)
--     print("🌱 Planting request:", player.Name, "wants to plant", seedType, "at", targetPosition)
    
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if not leaderstats then 
--         print("❌ No leaderstats found for", player.Name)
--         return 
--     end
    
--     local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--     if not seedStat or seedStat.Value <= 0 then
--         print("❌ No seeds available for planting")
--         local seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
--         if seedInventoryEvent then
--             seedInventoryEvent:FireClient(player, "PlantResult", false, "You need " .. seedType .. " seeds to plant!")
--         end
--         return
--     end
    
--     -- Spawn the plant
--     local success, message = spawnPlant(seedType, targetPosition, player)
    
--     if success then
--         -- Deduct seed and update tools
--         local newQuantity = seedStat.Value - 1
--         updatePlayerSeeds(player, seedType, newQuantity)
        
--         print("🌱 Successfully planted", seedType, "- Remaining seeds:", newQuantity)
        
--         -- Send success to client
--         local seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
--         if seedInventoryEvent then
--             seedInventoryEvent:FireClient(player, "PlantResult", true, message)
--         end
--     else
--         print("❌ Failed to plant:", message)
--         local seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
--         if seedInventoryEvent then
--             seedInventoryEvent:FireClient(player, "PlantResult", false, message)
--         end
--     end
-- end)

-- -- Player setup
-- local function setupPlayer(player)
--     print("🌱 Setting up player:", player.Name)
    
--     local leaderstats = Instance.new("Folder")
--     leaderstats.Name = "leaderstats"
--     leaderstats.Parent = player
    
--     local coins = Instance.new("IntValue")
--     coins.Name = "Coins"
--     coins.Value = 200
--     coins.Parent = leaderstats
--     print("🪙 Created Coins:", coins.Value)
    
--     local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--     for _, seedType in pairs(seedTypes) do
--         local seedStat = Instance.new("IntValue")
--         seedStat.Name = seedType .. "_Seeds"
--         seedStat.Value = 0
--         seedStat.Parent = leaderstats
--         print("📊 Created stat:", seedStat.Name)
--     end
    
--     player.CharacterAdded:Connect(function()
--         wait(2)
--         print("🔄 Character spawned - recreating tools...")
        
--         for _, seedType in pairs(seedTypes) do
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             if seedStat and seedStat.Value > 0 then
--                 createSeedTool(player, seedType, seedStat.Value)
--             end
--         end
--     end)
-- end

-- -- Handle players
-- Players.PlayerAdded:Connect(setupPlayer)

-- for _, player in pairs(Players:GetPlayers()) do
--     if not player:FindFirstChild("leaderstats") then
--         setupPlayer(player)
--     end
-- end

-- -- Debug commands
-- Players.PlayerAdded:Connect(function(player)
--     player.Chatted:Connect(function(message)
--         if message:lower() == "/giveseeds" then
--             local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--             local leaderstats = player:FindFirstChild("leaderstats")
--             if leaderstats then
--                 for _, seedType in pairs(seedTypes) do
--                     updatePlayerSeeds(player, seedType, 3)
--                 end
--                 print("✅ Test seeds given to", player.Name)
--             end
--         elseif message:lower() == "/cleartools" then
--             local backpack = player:FindFirstChild("Backpack")
--             if backpack then
--                 for _, tool in pairs(backpack:GetChildren()) do
--                     if tool:IsA("Tool") and tool.Name:find("Seeds") then
--                         tool:Destroy()
--                     end
--                 end
--             end
--         end
--     end)
-- end)

-- print("✅ Enhanced 3D Visual Hotbar Seed System loaded!")
-- print("🎮 Seeds now show as 3D glowing models in hotbar!")
-- print("🔧 Type /giveseeds for testing")
-- print("🧹 Type /cleartools to clear seed tools")



-- COMPLETE FIXED SEEDSHOPHANDLER - NO SYNTAX ERRORS
-- Replace your ENTIRE SeedShopHandler.server.lua with this



--------------------------------------------------------------------------------------------------------------------------------------------
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ServerStorage = game:GetService("ServerStorage")
-- local Players = game:GetService("Players")
-- local RunService = game:GetService("RunService")

-- -- Create RemoteEvents if they don't exist
-- local function getOrCreateRemoteEvent(name)
--     local event = ReplicatedStorage:FindFirstChild(name)
--     if not event then
--         event = Instance.new("RemoteEvent")
--         event.Name = name
--         event.Parent = ReplicatedStorage
--         print("✅ Created RemoteEvent:", name)
--     end
--     return event
-- end

-- local seedShopEvent = getOrCreateRemoteEvent("SeedShopEvent")
-- local plantSeedEvent = getOrCreateRemoteEvent("PlantSeed")
-- local enterPlantingMode = getOrCreateRemoteEvent("EnterPlantingMode")
-- local seedInventoryEvent = getOrCreateRemoteEvent("SeedInventoryEvent")  -- NEW LINE

-- -- Create SeedItems folder if it doesn't exist
-- local seedItems = ReplicatedStorage:FindFirstChild("SeedItems")
-- if not seedItems then
--     seedItems = Instance.new("Folder")
--     seedItems.Name = "SeedItems"
--     seedItems.Parent = ReplicatedStorage
--     print("✅ Created SeedItems folder")
-- end

-- print("🌱 Enhanced 3D Visual Hotbar Seed System starting...")

-- -- PLANT TEMPLATES
-- local PLANT_TEMPLATES = {
--     Carrot = "Carrot_grown",
--     Tomato = "tomato plant", 
--     Potato = "Plant",
--     Wheat = "Plant",
--     Corn = "Plant"
-- }

-- -- Function to find plant template
-- local function findPlantTemplate(plantType)
--     print("🔍 Looking for template for:", plantType)
    
--     local templateName = PLANT_TEMPLATES[plantType]
--     print("📝 Template name from table:", templateName)
    
--     if not templateName then
--         templateName = "Plant"
--         print("⚠️ Using fallback template name:", templateName)
--     end
    
--     -- Try workspace first
--     print("🔍 Searching workspace for:", templateName)
--     local template = workspace:FindFirstChild(templateName)
--     if template and template:IsA("Model") then
--         print("✅ Found template in workspace:", templateName)
--         return template
--     end
    
--     -- Try case-insensitive search
--     print("🔍 Trying case-insensitive search in workspace...")
--     for _, obj in pairs(workspace:GetChildren()) do
--         if obj:IsA("Model") and obj.Name:lower() == templateName:lower() then
--             print("✅ Found with case-insensitive search:", obj.Name)
--             return obj
--         end
--     end
    
--     print("❌ No plant template found for:", plantType)
--     return nil
-- end

-- -- Function to spawn plant at position
-- local function spawnPlant(plantType, position, player)
--     local template = findPlantTemplate(plantType)
--     if not template then
--         return false, "Plant template not found for " .. plantType
--     end

--     local newPlant = template:Clone()
--     newPlant.Name = plantType .. "_" .. player.Name .. "_" .. tick()

--     local success = false
--     local plantPosition = position + Vector3.new(0, 1, 0)
    
--     if newPlant.PrimaryPart then
--         newPlant:SetPrimaryPartCFrame(CFrame.new(plantPosition))
--         success = true
--     else
--         local anchorPart = newPlant:FindFirstChild("Soil") or 
--                           newPlant:FindFirstChild("Part") or
--                           newPlant:FindFirstChildOfClass("BasePart")
        
--         if anchorPart then
--             anchorPart.Position = plantPosition
--             newPlant.PrimaryPart = anchorPart
--             success = true
--         end
--     end
    
--     if not success then
--         warn("❌ Could not position plant")
--         newPlant:Destroy()
--         return false, "Could not position plant"
--     end

--     for _, part in pairs(newPlant:GetDescendants()) do
--         if part:IsA("BasePart") then
--             part.Anchored = true
--             part.CanCollide = false
--         end
--     end

--     newPlant.Parent = workspace
    
--     print("✅ Successfully spawned", plantType, "for", player.Name)
--     return true, "Successfully planted " .. plantType .. "!"
-- end

-- -- UPDATED: Use your existing Seeds model for hotbar tools
-- local function createSeedTool(player, seedType, quantity)
--     if not player or not player.Parent then return end
--     if quantity <= 0 then return end
    
--     local backpack = player:FindFirstChild("Backpack")
--     if not backpack then return end
    
--     print("🔧 Creating mesh-based hotbar tool:", seedType, "Seeds for", player.Name)
    
--     -- Clean up old tools completely
--     for _, tool in pairs(backpack:GetChildren()) do
--         if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
--             tool:Destroy()
--         end
--     end
    
--     if player.Character then
--         for _, tool in pairs(player.Character:GetChildren()) do
--             if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
--                 tool:Destroy()
--             end
--         end
--     end
    
--     -- Create the tool
--     local tool = Instance.new("Tool")
--     tool.Name = seedType .. " Seeds"
--     tool.ToolTip = seedType .. " Seeds ("..quantity..")"
--     tool.CanBeDropped = false
--     tool.ManualActivationOnly = false
    
--     -- Find and clone your existing Seeds model
--     local seedsModel = workspace:FindFirstChild("Seeds")
--     local handle
    
--     if seedsModel and seedsModel:IsA("Model") then
--         -- Clone the entire Seeds model
--         local clonedModel = seedsModel:Clone()
        
--         -- Find the mesh part inside the cloned model
--         local meshPart = clonedModel:FindFirstChild("Mesh")
--         if meshPart then
--             -- Use the mesh part as the handle
--             handle = meshPart
--             handle.Name = "Handle" -- MUST be exactly "Handle"
--             handle.Parent = nil -- Remove from cloned model
--             clonedModel:Destroy() -- Clean up the rest
--         end
--     end
    
--     -- Fallback if mesh not found
--     if not handle then
--         print("⚠️ Could not find Seeds model, using fallback handle")
--         handle = Instance.new("Part")
--         handle.Name = "Handle"
--         handle.Size = Vector3.new(1.5, 1.5, 1.5)
--         handle.Shape = Enum.PartType.Block
--     end
    
--     -- Configure handle properties
--     handle.Anchored = false
--     handle.CanCollide = false
--     handle.Material = Enum.Material.Neon
    
--     -- Resize for better hotbar display
--     if handle.Size.Magnitude > 3 then
--         handle.Size = Vector3.new(1.5, 1.5, 1.5)
--     end
    
--     -- Apply seed-specific colors
--     local seedColors = {
--         Carrot = Color3.fromRGB(255, 165, 0), -- Orange
--         Tomato = Color3.fromRGB(255, 50, 50), -- Red
--         Potato = Color3.fromRGB(139, 69, 19), -- Brown
--         Wheat = Color3.fromRGB(245, 222, 179), -- Wheat color
--         Corn = Color3.fromRGB(255, 255, 0) -- Yellow
--     }
--     handle.Color = seedColors[seedType] or Color3.fromRGB(0, 255, 0)
    
--     -- Add lighting effects
--     local pointLight = Instance.new("PointLight")
--     pointLight.Brightness = 5
--     pointLight.Range = 10
--     pointLight.Color = handle.Color
--     pointLight.Parent = handle
    
--     -- Add particle effect
--     local particles = Instance.new("ParticleEmitter")
--     particles.Texture = "rbxassetid://242487987" -- Sparkle texture
--     particles.LightEmission = 1
--     particles.Size = NumberSequence.new(0.3)
--     particles.Speed = NumberRange.new(2)
--     particles.Lifetime = NumberRange.new(1)
--     particles.Rate = 15
--     particles.Parent = handle
    
--     -- MUST parent handle to tool FIRST
--     handle.Parent = tool
    
--     -- Add seed data values
--     local seedValue = Instance.new("StringValue")
--     seedValue.Name = "SeedType"
--     seedValue.Value = seedType
--     seedValue.Parent = tool
    
--     local quantityValue = Instance.new("IntValue")
--     quantityValue.Name = "Quantity"
--     quantityValue.Value = quantity
--     quantityValue.Parent = tool
    
--     -- Tool activation
--     tool.Activated:Connect(function()
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if leaderstats then
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             if seedStat and seedStat.Value > 0 then
--                 enterPlantingMode:FireClient(player, seedType, seedStat.Value)
--             else
--                 tool:Destroy()
--             end
--         end
--     end)
    
--     -- FINAL STEP: Parent to backpack LAST
--     tool.Parent = backpack
    
--     -- Force hotbar refresh (critical for consistent display)
--     task.spawn(function()
--         task.wait(0.1)
--         local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
--         if humanoid then
--             humanoid:UnequipTools()
--             task.wait(0.1)
--             humanoid:EquipTool(tool)
--         end
--     end)
    
--     print("✅ MESH-BASED hotbar tool created:", tool.Name, "for", player.Name)
--     return tool
-- end

-- -- ALTERNATIVE: If you want to use your existing mesh from the Seeds folder
-- local function createSeedToolWithExistingMesh(player, seedType, quantity)
--     -- ... (same setup code as above)
    
--     -- Try to find and clone your existing seed mesh
--     local seedsFolder = game.ReplicatedStorage:FindFirstChild("Seeds")
--     local seedMesh = seedsFolder and seedsFolder:FindFirstChild("Mesh")
    
--     local handle
--     if seedMesh and seedMesh:IsA("MeshPart") then
--         -- Clone your existing mesh
--         handle = seedMesh:Clone()
--         handle.Name = "Handle"
--         handle.Size = Vector3.new(1.5, 1.5, 1.5) -- Resize for hotbar
--     else
--         -- Fallback to basic MeshPart
--         handle = Instance.new("MeshPart")
--         handle.Name = "Handle"
--         handle.Size = Vector3.new(1.5, 1.5, 1.5)
--     end
    
--     -- Apply seed-specific colors
--     local seedColors = {
--         Carrot = Color3.fromRGB(255, 165, 0),
--         Tomato = Color3.fromRGB(255, 50, 50),
--         Potato = Color3.fromRGB(139, 69, 19),
--         Wheat = Color3.fromRGB(245, 222, 179),
--         Corn = Color3.fromRGB(255, 255, 0)
--     }
    
--     handle.Color = seedColors[seedType] or Color3.fromRGB(0, 255, 0)
--     handle.Material = Enum.Material.Neon
--     handle.Anchored = false
--     handle.CanCollide = false
    
--     -- ... (rest of the function same as above)
-- end
-- -- Function to update player seeds
-- local function updatePlayerSeeds(player, seedType, newQuantity)
--     print("📊 Updating", seedType, "seeds to", newQuantity, "for", player.Name)
    
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if leaderstats then
--         local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--         if seedStat then
--             seedStat.Value = newQuantity
--             print("✅ Updated leaderstat", seedType .. "_Seeds to", newQuantity)
--         end
--     end
    
--     createSeedTool(player, seedType, newQuantity)
-- end

-- -- Handle shop purchases
-- seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
--     if action == "PurchaseSeeds" then
--         print("🛒 Purchase request:", player.Name, "wants", seedType)
        
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if not leaderstats then
--             return
--         end
        
--         local coinsValue = leaderstats:FindFirstChild("Coins")
--         if not coinsValue then
--             return
--         end
        
--         local seedPrices = {
--             Carrot = 8,
--             Potato = 10,
--             Tomato = 5,
--             Wheat = 12,
--             Corn = 15
--         }
        
--         local price = seedPrices[seedType] or 10
        
--         if coinsValue.Value >= price then
--             coinsValue.Value = coinsValue.Value - price
            
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             local currentSeeds = seedStat and seedStat.Value or 0
--             local newSeedCount = currentSeeds + 1
            
--             updatePlayerSeeds(player, seedType, newSeedCount)
            
--             seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchased " .. seedType .. " seeds!")
--             print("✅ Purchase completed:", player.Name, "bought", seedType, "seeds")
--         else
--             seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!")
--         end
--     end
-- end)

-- -- Handle planting requests
-- plantSeedEvent.OnServerEvent:Connect(function(player, seedType, targetPosition)
--     print("🌱 Planting request:", player.Name, "wants to plant", seedType, "at", targetPosition)
    
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if not leaderstats then 
--         print("❌ No leaderstats found for", player.Name)
--         return 
--     end
    
--     local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--     if not seedStat or seedStat.Value <= 0 then
--         print("❌ No seeds available for planting")
--         local seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
--         if seedInventoryEvent then
--             seedInventoryEvent:FireClient(player, "PlantResult", false, "You need " .. seedType .. " seeds to plant!")
--         end
--         return
--     end
    
--     local success, message = spawnPlant(seedType, targetPosition, player)
    
--     if success then
--         local newQuantity = seedStat.Value - 1
--         updatePlayerSeeds(player, seedType, newQuantity)
        
--         print("🌱 Successfully planted", seedType, "- Remaining seeds:", newQuantity)
        
--         local seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
--         if seedInventoryEvent then
--             seedInventoryEvent:FireClient(player, "PlantResult", true, message)
--         end
--     else
--         print("❌ Failed to plant:", message)
--         local seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
--         if seedInventoryEvent then
--             seedInventoryEvent:FireClient(player, "PlantResult", false, message)
--         end
--     end
-- end)

-- -- Player setup
-- local function setupPlayer(player)
--     print("🌱 Setting up player:", player.Name)
    
--     local leaderstats = Instance.new("Folder")
--     leaderstats.Name = "leaderstats"
--     leaderstats.Parent = player
    
--     local coins = Instance.new("IntValue")
--     coins.Name = "Coins"
--     coins.Value = 200
--     coins.Parent = leaderstats
--     print("🪙 Created Coins:", coins.Value)
    
--     local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--     for _, seedType in pairs(seedTypes) do
--         local seedStat = Instance.new("IntValue")
--         seedStat.Name = seedType .. "_Seeds"
--         seedStat.Value = 0
--         seedStat.Parent = leaderstats
--         print("📊 Created stat:", seedStat.Name)
--     end
    
--     player.CharacterAdded:Connect(function()
--         wait(2)
--         print("🔄 Character spawned - recreating tools...")
        
--         for _, seedType in pairs(seedTypes) do
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             if seedStat and seedStat.Value > 0 then
--                 createSeedTool(player, seedType, seedStat.Value)
--             end
--         end
--     end)
-- end

-- -- Handle players
-- Players.PlayerAdded:Connect(setupPlayer)

-- for _, player in pairs(Players:GetPlayers()) do
--     if not player:FindFirstChild("leaderstats") then
--         setupPlayer(player)
--     end
-- end

-- -- Debug commands - PROPER SYNTAX
-- -- Replace your entire player chat handler with this:

-- Players.PlayerAdded:Connect(function(player)
--     player.Chatted:Connect(function(message)
--         if message:lower() == "/giveseeds" then
--             local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--             local leaderstats = player:FindFirstChild("leaderstats")
--             if leaderstats then
--                 for _, seedType in pairs(seedTypes) do
--                     updatePlayerSeeds(player, seedType, 3)
--                 end
--                 print("✅ Test seeds given to", player.Name)
--             end
            
--         elseif message:lower() == "/cleartools" then
--             local backpack = player:FindFirstChild("Backpack")
--             if backpack then
--                 for _, tool in pairs(backpack:GetChildren()) do
--                     if tool:IsA("Tool") and tool.Name:find("Seeds") then
--                         tool:Destroy()
--                     end
--                 end
--             end
--             print("🧹 Cleared all seed tools for", player.Name)
            
--         elseif message:lower() == "/forcerefresh" then
--             local backpack = player:FindFirstChild("Backpack")
--             if backpack then
--                 for _, tool in pairs(backpack:GetChildren()) do
--                     if tool:IsA("Tool") then
--                         tool.Parent = workspace
--                         wait(0.1)
--                         tool.Parent = backpack
--                     end
--                 end
--             end
--             print("🔄 Forced hotbar refresh for", player.Name)
            
--         elseif message:lower() == "/debug" then
--             print("🔍 DEBUG: Searching for all plant-related models in workspace...")
--             print("==================================================")
            
--             local foundModels = {}
            
--             -- Search all models in workspace
--             for _, obj in pairs(workspace:GetChildren()) do
--                 if obj:IsA("Model") then
--                     local name = obj.Name:lower()
                    
--                     -- Check if it contains plant-related keywords
--                     local isPlantRelated = name:find("plant") or 
--                                          name:find("carrot") or 
--                                          name:find("tomato") or 
--                                          name:find("wheat") or 
--                                          name:find("corn") or 
--                                          name:find("potato") or
--                                          name:find("grown") or
--                                          name:find("seed")
                    
--                     if isPlantRelated then
--                         table.insert(foundModels, obj.Name)
--                         print("🌱 Found plant model:", obj.Name)
                        
--                         -- Check what's inside this model
--                         local partCount = 0
--                         local hasScript = false
--                         for _, child in pairs(obj:GetDescendants()) do
--                             if child:IsA("BasePart") then
--                                 partCount = partCount + 1
--                             end
--                             if child:IsA("Script") then
--                                 hasScript = true
--                             end
--                         end
--                         print("   📊 Parts:", partCount, "| Has Script:", hasScript)
--                         print("   🎯 Primary Part:", obj.PrimaryPart and obj.PrimaryPart.Name or "None")
--                         print("")
--                     else
--                         -- Still log all models for reference
--                         print("📦 Other model:", obj.Name)
--                     end
--                 end
--             end
            
--             print("==================================================")
--             print("🌱 Total plant-related models found:", #foundModels)
            
--             if #foundModels == 0 then
--                 print("❌ NO PLANT MODELS FOUND!")
--                 print("💡 You might need to:")
--                 print("   1. Place plant models in workspace")
--                 print("   2. Check if they're in ServerStorage instead")
--                 print("   3. Make sure they're named correctly")
--             else
--                 print("✅ Available plant models:")
--                 for i, modelName in pairs(foundModels) do
--                     print("   " .. i .. ". " .. modelName)
--                 end
                
--                 print("")
--                 print("💡 Suggested PLANT_TEMPLATES update:")
--                 print("local PLANT_TEMPLATES = {")
                
--                 for _, modelName in pairs(foundModels) do
--                     local name = modelName:lower()
--                     if name:find("carrot") then
--                         print("    Carrot = \"" .. modelName .. "\",")
--                     elseif name:find("tomato") then
--                         print("    Tomato = \"" .. modelName .. "\",")
--                     elseif name:find("wheat") then
--                         print("    Wheat = \"" .. modelName .. "\",")
--                     elseif name:find("corn") then
--                         print("    Corn = \"" .. modelName .. "\",")
--                     elseif name:find("potato") then
--                         print("    Potato = \"" .. modelName .. "\",")
--                     end
--                 end
--                 print("}")
--             end
            
--             print("🔧 Debug completed for", player.Name)
--         end
--     end)
-- end)

-- print("✅ Enhanced 3D Visual Hotbar Seed System loaded!")
-- print("🎮 Seeds now show as 3D glowing models in hotbar!")
-- print("🔧 Type /giveseeds for testing")
-- print("🧹 Type /cleartools to clear seed tools")
-- print("🔄 Type /forcerefresh to refresh hotbar display")


-- COMPLETE FIXED SEEDSHOPHANDLER - Replace your entire SeedShopHandler script with this
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Create RemoteEvents if they don't exist
local function getOrCreateRemoteEvent(name)
    local event = ReplicatedStorage:FindFirstChild(name)
    if not event then
        event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = ReplicatedStorage
        print("✅ Created RemoteEvent:", name)
    end
    return event
end

local seedShopEvent = getOrCreateRemoteEvent("SeedShopEvent")
local plantSeedEvent = getOrCreateRemoteEvent("PlantSeed")
local enterPlantingMode = getOrCreateRemoteEvent("EnterPlantingMode")
local seedInventoryEvent = getOrCreateRemoteEvent("SeedInventoryEvent")

-- Create SeedItems folder if it doesn't exist
local seedItems = ReplicatedStorage:FindFirstChild("SeedItems")
if not seedItems then
    seedItems = Instance.new("Folder")
    seedItems.Name = "SeedItems"
    seedItems.Parent = ReplicatedStorage
    print("✅ Created SeedItems folder")
end

print("🌱 Enhanced 3D Visual Hotbar Seed System starting...")

-- FIXED PLANT TEMPLATES - Based on what's actually in your workspace
local PLANT_TEMPLATES = {
    Carrot = "Carrot_grown",
    Tomato = "Tomato",
    Potato = "Plant",
    Wheat = "Plant",
    Corn = "Plant"
}

-- Function to find plant template
local function findPlantTemplate(plantType)
    print("🔍 Looking for template for:", plantType)
    
    local templateName = PLANT_TEMPLATES[plantType]
    print("📝 Template name from table:", templateName)
    
    -- Try exact name in workspace
    local template = workspace:FindFirstChild(templateName)
    if template and template:IsA("Model") then
        print("✅ Found template in workspace:", templateName)
        return template
    end
    
    -- Try case-insensitive search  
    print("🔍 Trying case-insensitive search...")
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower() == templateName:lower() then
            print("✅ Found with case-insensitive search:", obj.Name)
            return obj
        end
    end
    
    -- Try alternative names
    local alternativeNames = {
        Carrot = {"carrot", "Carrot", "carrot_grown", "Carrot_Grown"},
        Tomato = {"tomato", "Tomato", "tomato plant", "Tomato Plant", "TomatoPlant"},
        Potato = {"potato", "Potato", "plant", "Plant"},
        Wheat = {"wheat", "Wheat", "plant", "Plant"},
        Corn = {"corn", "Corn", "plant", "Plant"}
    }
    
    local alternatives = alternativeNames[plantType] or {"Plant"}
    print("🔍 Trying alternative names:", table.concat(alternatives, ", "))
    
    for _, altName in pairs(alternatives) do
        local altTemplate = workspace:FindFirstChild(altName)
        if altTemplate and altTemplate:IsA("Model") then
            print("✅ Found alternative template:", altName)
            return altTemplate
        end
    end
    
    print("❌ No plant template found for:", plantType)
    return nil
end

-- Function to spawn plant at position
local function spawnPlant(plantType, position, player)
    local template = findPlantTemplate(plantType)
    if not template then
        return false, "Plant template not found for " .. plantType
    end

    local newPlant = template:Clone()
    newPlant.Name = plantType .. "_" .. player.Name .. "_" .. tick()

    local success = false
    local plantPosition = position + Vector3.new(0, 1, 0)
    
    if newPlant.PrimaryPart then
        newPlant:SetPrimaryPartCFrame(CFrame.new(plantPosition))
        success = true
    else
        local anchorPart = newPlant:FindFirstChild("Soil") or 
                          newPlant:FindFirstChild("Part") or
                          newPlant:FindFirstChildOfClass("BasePart")
        
        if anchorPart then
            anchorPart.Position = plantPosition
            newPlant.PrimaryPart = anchorPart
            success = true
        end
    end
    
    if not success then
        warn("❌ Could not position plant")
        newPlant:Destroy()
        return false, "Could not position plant"
    end

    for _, part in pairs(newPlant:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = true
            part.CanCollide = false
        end
    end

    newPlant.Parent = workspace
    
    print("✅ Successfully spawned", plantType, "for", player.Name)
    return true, "Successfully planted " .. plantType .. "!"
end

-- FIXED: Create hotbar tools with proper API (NO MORE UnequipTool ERROR!)
local function createSeedTool(player, seedType, quantity)
    if not player or not player.Parent then return end
    if quantity <= 0 then return end
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    print("🔧 Creating mesh-based hotbar tool:", seedType, "Seeds for", player.Name)
    
    -- Clean up old tools completely
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
            tool:Destroy()
        end
    end
    
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
                tool:Destroy()
            end
        end
    end
    
    -- Create the tool
    local tool = Instance.new("Tool")
    tool.Name = seedType .. " Seeds"
    tool.ToolTip = seedType .. " Seeds ("..quantity..")"
    tool.CanBeDropped = false
    tool.ManualActivationOnly = false
    
    -- Find and use your actual Seeds model properly
    print("🔍 Looking for Seeds model in workspace...")
    local seedsModel = workspace:FindFirstChild("Seeds")
    local handle
    
    if seedsModel and seedsModel:IsA("Model") then
        print("✅ Found Seeds model:", seedsModel.Name)
        
        -- Clone the entire Seeds model first
        local clonedModel = seedsModel:Clone()
        print("✅ Found Seeds model!")
        
        -- Look for the main mesh part inside the model
        local meshPart = clonedModel:FindFirstChild("Seeds") or 
                        clonedModel:FindFirstChild("Mesh") or
                        clonedModel:FindFirstChildOfClass("MeshPart") or
                        clonedModel:FindFirstChildOfClass("Part")
        
        if meshPart then
            print("✅ Found mesh part:", meshPart.Name)
            -- Use the actual mesh as the handle
            handle = meshPart:Clone()
            handle.Name = "Handle" -- MUST be exactly "Handle"
            
            -- Clean up the cloned model
            clonedModel:Destroy()
            
            -- Resize for better hotbar display but keep the mesh
            local currentSize = handle.Size
            local maxSize = math.max(currentSize.X, currentSize.Y, currentSize.Z)
            if maxSize > 3 then
                local scale = 2 / maxSize
                handle.Size = currentSize * scale
            end
            
        else
            print("⚠️ No mesh found in Seeds model, using fallback")
            clonedModel:Destroy()
            handle = nil
        end
    else
        print("⚠️ Seeds model not found in workspace")
    end
    
    -- Fallback if no Seeds model found
    if not handle then
        print("⚠️ Creating fallback handle")
        handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(2, 2, 2)
        handle.Shape = Enum.PartType.Ball
    end
    
    -- Configure handle properties
    handle.Anchored = false
    handle.CanCollide = false
    handle.Material = Enum.Material.ForceField
    
    -- Apply seed-specific colors
    local seedColors = {
        Carrot = Color3.fromRGB(255, 140, 0),
        Tomato = Color3.fromRGB(255, 0, 0),
        Potato = Color3.fromRGB(139, 69, 19),
        Wheat = Color3.fromRGB(255, 215, 0),
        Corn = Color3.fromRGB(255, 255, 0)
    }
    handle.Color = seedColors[seedType] or Color3.fromRGB(0, 255, 0)
    
    -- Add lighting
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 1
    pointLight.Range = 3
    pointLight.Color = handle.Color
    pointLight.Parent = handle
    
    -- Parent handle to tool FIRST
    handle.Parent = tool
    
    -- Add seed data values
    local seedValue = Instance.new("StringValue")
    seedValue.Name = "SeedType"
    seedValue.Value = seedType
    seedValue.Parent = tool
    
    local quantityValue = Instance.new("IntValue")
    quantityValue.Name = "Quantity"
    quantityValue.Value = quantity
    quantityValue.Parent = tool
    
    -- Tool activation
    tool.Activated:Connect(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
            if seedStat and seedStat.Value > 0 then
                enterPlantingMode:FireClient(player, seedType, seedStat.Value)
            else
                tool:Destroy()
            end
        end
    end)
    
    -- Parent to backpack
    tool.Parent = backpack
    
    -- FIXED: Force thumbnail refresh with proper API (NO MORE UnequipTool ERROR!)
    task.spawn(function()
        task.wait(0.2)
        
        if tool.Parent == backpack then
            tool.TextureId = ""
            task.wait(0.1)
            
            -- Move to character briefly to force thumbnail generation
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                    task.wait(0.1)
                    -- FIXED: Use proper method to unequip (NO MORE ERROR!)
                    tool.Parent = backpack  -- This moves it back to backpack properly
                end
            end
        end
    end)
    
    print("✅ MESH-BASED hotbar tool created:", tool.Name, "for", player.Name)
    return tool
end

-- Function to update player seeds
local function updatePlayerSeeds(player, seedType, newQuantity)
    print("📊 Updating", seedType, "seeds to", newQuantity, "for", player.Name)
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
        if seedStat then
            seedStat.Value = newQuantity
            print("✅ Updated leaderstat", seedType .. "_Seeds to", newQuantity)
        end
    end
    
    createSeedTool(player, seedType, newQuantity)
end

-- Handle shop purchases
seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
    if action == "PurchaseSeeds" then
        print("🛒 Purchase request:", player.Name, "wants", seedType)
        
        local leaderstats = player:FindFirstChild("leaderstats")
        if not leaderstats then return end
        
        local coinsValue = leaderstats:FindFirstChild("Coins")
        if not coinsValue then return end
        
        local seedPrices = {
            Carrot = 8,
            Potato = 10,
            Tomato = 5,
            Wheat = 12,
            Corn = 15
        }
        
        local price = seedPrices[seedType] or 10
        
        if coinsValue.Value >= price then
            coinsValue.Value = coinsValue.Value - price
            
            local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
            local currentSeeds = seedStat and seedStat.Value or 0
            local newSeedCount = currentSeeds + 1
            
            updatePlayerSeeds(player, seedType, newSeedCount)
            
            seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchased " .. seedType .. " seeds!")
            print("✅ Purchase completed:", player.Name, "bought", seedType, "seeds")
        else
            seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!")
        end
    end
end)

-- Handle planting requests
plantSeedEvent.OnServerEvent:Connect(function(player, seedType, targetPosition)
    print("🌱 Planting request:", player.Name, "wants to plant", seedType, "at", targetPosition)
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then 
        print("❌ No leaderstats found for", player.Name)
        return 
    end
    
    local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
    if not seedStat or seedStat.Value <= 0 then
        print("❌ No seeds available for planting")
        seedInventoryEvent:FireClient(player, "PlantResult", false, "You need " .. seedType .. " seeds to plant!")
        return
    end
    
    local success, message = spawnPlant(seedType, targetPosition, player)
    
    if success then
        local newQuantity = seedStat.Value - 1
        updatePlayerSeeds(player, seedType, newQuantity)
        
        print("🌱 Successfully planted", seedType, "- Remaining seeds:", newQuantity)
        seedInventoryEvent:FireClient(player, "PlantResult", true, message)
    else
        print("❌ Failed to plant:", message)
        seedInventoryEvent:FireClient(player, "PlantResult", false, message)
    end
end)

-- Player setup function with duplicate check
local function setupPlayer(player)
    print("🌱 Setting up player:", player.Name)
    
    -- FIXED: Check if player already has leaderstats to prevent duplicates
    if player:FindFirstChild("leaderstats") then
        print("⚠️ Player", player.Name, "already has leaderstats, skipping setup")
        return -- Already setup
    end
    
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 200
    coins.Parent = leaderstats
    print("🪙 Created Coins:", coins.Value)
    
    local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
    for _, seedType in pairs(seedTypes) do
        local seedStat = Instance.new("IntValue")
        seedStat.Name = seedType .. "_Seeds"
        seedStat.Value = 0
        seedStat.Parent = leaderstats
        print("📊 Created stat:", seedStat.Name)
    end
    
    player.CharacterAdded:Connect(function()
        wait(2)
        print("🔄 Character spawned - recreating tools...")
        
        for _, seedType in pairs(seedTypes) do
            local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
            if seedStat and seedStat.Value > 0 then
                createSeedTool(player, seedType, seedStat.Value)
            end
        end
    end)
end

-- Handle players
Players.PlayerAdded:Connect(setupPlayer)

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- Debug commands for testing
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "/giveseeds" then
            local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                for _, seedType in pairs(seedTypes) do
                    updatePlayerSeeds(player, seedType, 3)
                end
                print("✅ Test seeds given to", player.Name)
            end
            
        elseif message:lower() == "/cleartools" then
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:find("Seeds") then
                        tool:Destroy()
                    end
                end
            end
            print("🧹 Cleared all seed tools for", player.Name)
            
        elseif message:lower() == "/debug" then
            print("🔍 DEBUG: Available plant models in workspace:")
            print("=" .. string.rep("=", 50))
            
            local plantModels = {}
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") then
                    table.insert(plantModels, obj.Name)
                    print("📦 Model found:", obj.Name)
                end
            end
            
            print("=" .. string.rep("=", 50))
            print("🌱 Total models:", #plantModels)
            print("🔧 Current PLANT_TEMPLATES:")
            for plantType, templateName in pairs(PLANT_TEMPLATES) do
                local exists = workspace:FindFirstChild(templateName) and "✅" or "❌"
                print("   " .. plantType .. " -> " .. templateName .. " " .. exists)
            end
        end
    end)
end)

print("✅ FIXED Enhanced 3D Visual Hotbar Seed System loaded!")
print("🎮 Seeds now show as 3D glowing models in hotbar!")
print("🔧 Type /giveseeds for testing")
print("🧹 Type /cleartools to clear seed tools")
print("🔄 Type /debug to check available models")