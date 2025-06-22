-- -- SERVER SCRIPT: Enhanced SeedShopHandler with Hotbar Integration
-- -- Replace your existing SeedShopHandler with this version

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

-- print("🌱 Enhanced Hotbar Seed System starting...")

-- -- Function to create 3D seed models for tools
-- local function createSeedModel(seedType)
--     local model = Instance.new("Model")
--     model.Name = seedType .. "SeedModel"
    
--     -- Create the main seed part
--     local seedPart = Instance.new("Part")
--     seedPart.Name = "SeedPart"
--     seedPart.Size = Vector3.new(0.5, 0.5, 0.5)
--     seedPart.Material = Enum.Material.Neon
--     seedPart.Shape = Enum.PartType.Ball
--     seedPart.CanCollide = false
--     seedPart.Anchored = true
--     seedPart.Parent = model
    
--     -- Seed colors based on type
--     local seedColors = {
--         Carrot = Color3.fromRGB(255, 140, 50),   -- Orange
--         Potato = Color3.fromRGB(139, 117, 82),   -- Brown
--         Tomato = Color3.fromRGB(255, 80, 80),    -- Red
--         Wheat = Color3.fromRGB(218, 165, 32),    -- Golden
--         Corn = Color3.fromRGB(255, 215, 0)       -- Yellow
--     }
    
--     seedPart.Color = seedColors[seedType] or Color3.fromRGB(100, 200, 100)
    
--     -- Add a glow effect
--     local pointLight = Instance.new("PointLight")
--     pointLight.Color = seedPart.Color
--     pointLight.Brightness = 0.8
--     pointLight.Range = 3
--     pointLight.Parent = seedPart
    
--     -- Add particles for extra visual appeal
--     local attachment = Instance.new("Attachment")
--     attachment.Parent = seedPart
    
--     local particles = Instance.new("ParticleEmitter")
--     particles.Parent = attachment
--     particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
--     particles.Color = ColorSequence.new(seedPart.Color)
--     particles.Size = NumberSequence.new{
--         NumberSequenceKeypoint.new(0, 0.1),
--         NumberSequenceKeypoint.new(1, 0.3)
--     }
--     particles.Lifetime = NumberRange.new(0.5, 1.5)
--     particles.Rate = 30
--     particles.SpreadAngle = Vector2.new(45, 45)
--     particles.Speed = NumberRange.new(1, 3)
    
--     -- Set PrimaryPart for easier manipulation
--     model.PrimaryPart = seedPart
    
--     return model
-- end

-- -- Function to create seed tools with 3D models that appear in hotbar
-- local function createSeedTool(player, seedType, quantity)
--     if not player or not player.Parent then 
--         print("❌ Player not valid for tool creation")
--         return 
--     end
    
--     local backpack = player:FindFirstChild("Backpack")
--     if not backpack then 
--         print("❌ No backpack found for", player.Name)
--         return 
--     end
    
--     print("🔧 Creating 3D visual hotbar tool:", seedType, "Seeds (", quantity, ") for", player.Name)
    
--     -- Remove old seed tool of same type
--     for _, tool in pairs(backpack:GetChildren()) do
--         if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
--             print("🗑️ Removing old tool:", tool.Name)
--             tool:Destroy()
--         end
--     end
    
--     -- Also check character's currently equipped tool
--     if player.Character then
--         for _, tool in pairs(player.Character:GetChildren()) do
--             if tool:IsA("Tool") and tool.Name:find(seedType .. " Seeds") then
--                 print("🗑️ Removing equipped tool:", tool.Name)
--                 tool:Destroy()
--             end
--         end
--     end
    
--     -- Only create tool if player has seeds
--     if quantity <= 0 then 
--         print("⚠️ Not creating tool for", seedType, "- quantity is", quantity)
--         return 
--     end
    
--     -- Create the seed tool with 3D model
--     local tool = Instance.new("Tool")
--     tool.Name = seedType .. " Seeds"  -- Clean name for hotbar
--     tool.RequiresHandle = true  -- We need a handle for the 3D model
--     tool.CanBeDropped = false
--     tool.Grip = CFrame.new(0, -0.8, 0) * CFrame.Angles(0, 0, 0)  -- Adjust grip position
    
--     -- Set tool properties
--     local seedIcons = {
--         Carrot = "🥕",
--         Tomato = "🍅", 
--         Wheat = "🌾",
--         Corn = "🌽",
--         Potato = "🥔"
--     }
    
--     tool.ToolTip = (seedIcons[seedType] or "🌱") .. " " .. seedType .. " Seeds (" .. quantity .. ") - Click to plant!"
    
--     -- Create the 3D seed model as the handle
--     local seedModel = createSeedModel(seedType)
--     local handle = seedModel.PrimaryPart:Clone()
--     handle.Name = "Handle"
--     handle.Size = Vector3.new(1.2, 1.2, 1.2)  -- Bigger for visibility in hotbar
--     handle.Anchored = false
--     handle.CanCollide = false
--     handle.Parent = tool
    
--     -- Copy visual effects to handle
--     local originalLight = seedModel.PrimaryPart:FindFirstChild("PointLight")
--     if originalLight then
--         originalLight:Clone().Parent = handle
--     end
    
--     local originalAttachment = seedModel.PrimaryPart:FindFirstChild("Attachment")
--     if originalAttachment then
--         originalAttachment:Clone().Parent = handle
--     end
    
--     -- Clean up the temporary model
--     seedModel:Destroy()
    
--     -- Create a StringValue to store seed type
--     local seedTypeValue = Instance.new("StringValue")
--     seedTypeValue.Name = "SeedType"
--     seedTypeValue.Value = seedType
--     seedTypeValue.Parent = tool
    
--     -- Create an IntValue to store quantity
--     local quantityValue = Instance.new("IntValue")
--     quantityValue.Name = "Quantity"
--     quantityValue.Value = quantity
--     quantityValue.Parent = tool
    
--     -- Handle tool activation (when player clicks while holding the tool)
--     tool.Activated:Connect(function()
--         print("🌱 Player", player.Name, "activated", seedType, "seeds tool")
        
--         -- Check if they still have seeds
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if leaderstats then
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             if seedStat and seedStat.Value > 0 then
--                 -- Enter planting mode - let the client handle targeting
--                 local plantingEvent = ReplicatedStorage:FindFirstChild("EnterPlantingMode")
--                 if plantingEvent then
--                     plantingEvent:FireClient(player, seedType, seedStat.Value)
--                     print("🎯 Entered planting mode for", player.Name, "with", seedType)
--                 else
--                     print("❌ EnterPlantingMode event not found")
--                 end
--             else
--                 print("❌ No seeds left for", seedType)
--                 -- Remove the tool since they have no seeds
--                 tool:Destroy()
--             end
--         end
--     end)
    
--     -- Handle tool equipped (when player selects it from hotbar)
--     tool.Equipped:Connect(function()
--         print("🔧 Player", player.Name, "equipped", seedType, "seeds")
--         -- Could add visual effects here, like highlighting plantable areas
--     end)
    
--     -- Handle tool unequipped
--     tool.Unequipped:Connect(function()
--         print("🔄 Player", player.Name, "unequipped", seedType, "seeds")
--         -- Could remove visual effects here
--     end)
    
--     -- Add floating animation to make it look magical
--     local floatConnection
--     tool.Equipped:Connect(function()
--         -- Start floating animation when equipped
--         if handle and handle.Parent then
--             floatConnection = game:GetService("RunService").Heartbeat:Connect(function()
--                 if handle and handle.Parent then
--                     handle.CFrame = handle.CFrame * CFrame.new(0, math.sin(tick() * 3) * 0.1, 0)
--                 end
--             end)
--         end
--     end)
    
--     tool.Unequipped:Connect(function()
--         if floatConnection then
--             floatConnection:Disconnect()
--             floatConnection = nil
--         end
--     end)
    
--     -- Add tool to backpack (will automatically appear in hotbar as 3D model)
--     tool.Parent = backpack
    
--     print("✅ Successfully created 3D visual hotbar tool:", tool.Name, "for", player.Name)
--     return tool
-- end

-- -- Function to update player seeds and visual tools
-- local function updatePlayerSeeds(player, seedType, newQuantity)
--     print("📊 Updating", seedType, "seeds to", newQuantity, "for", player.Name)
    
--     -- Update leaderstats
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if leaderstats then
--         local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--         if seedStat then
--             seedStat.Value = newQuantity
--             print("✅ Updated leaderstat", seedType .. "_Seeds to", newQuantity)
--         end
--     end
    
--     -- Create/update the 3D visual hotbar tool
--     createSeedTool(player, seedType, newQuantity)
-- end

-- -- Handle shop purchases
-- seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
--     if action == "PurchaseSeeds" then
--         print("🛒 Purchase request:", player.Name, "wants", seedType)
        
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if not leaderstats then
--             print("❌ No leaderstats found")
--             return
--         end
        
--         local coinsValue = leaderstats:FindFirstChild("Coins")
--         if not coinsValue then
--             print("❌ No Coins found")
--             return
--         end
        
--         -- Seed prices and quantities
--         local seedPrices = {
--             Carrot = 8,
--             Potato = 10,
--             Tomato = 5,
--             Wheat = 12,
--             Corn = 15
--         }
        
--         local price = seedPrices[seedType] or 10
--         local seedsPerPack = 1
        
--         if coinsValue.Value >= price then
--             -- Deduct coins
--             coinsValue.Value = coinsValue.Value - price
            
--             -- Get current seed count
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             local currentSeeds = seedStat and seedStat.Value or 0
--             local newSeedCount = currentSeeds + seedsPerPack
            
--             -- Update seeds and create hotbar tool
--             updatePlayerSeeds(player, seedType, newSeedCount)
            
--             -- Notify client
--             seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchased "..seedType.." seeds!")
            
--             print("✅ Purchase completed:", player.Name, "bought", seedType, "seeds")
--         else
--             print("❌ Purchase failed - insufficient coins")
--             seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!")
--         end
--     end
-- end)

-- -- Create RemoteEvent for planting mode
-- local enterPlantingMode = getOrCreateRemoteEvent("EnterPlantingMode")

-- -- Handle planting
-- plantSeedEvent.OnServerEvent:Connect(function(player, seedType, targetPosition)
--     print("🌱 Planting request:", player.Name, "wants to plant", seedType, "at", targetPosition)
    
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if not leaderstats then return end
    
--     local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--     if not seedStat or seedStat.Value <= 0 then
--         print("❌ No seeds available for planting")
--         return
--     end
    
--     -- Deduct one seed
--     local newQuantity = seedStat.Value - 1
--     seedStat.Value = newQuantity
    
--     -- Update the hotbar tool with new quantity
--     updatePlayerSeeds(player, seedType, newQuantity)
    
--     -- Here you would spawn the actual plant
--     -- This depends on your existing plant spawning system
--     print("🌱 Planted", seedType, "at", targetPosition, "- Remaining seeds:", newQuantity)
-- end)

-- -- Player setup
-- local function setupPlayer(player)
--     print("🌱 Setting up player:", player.Name)
    
--     -- Create leaderstats
--     local leaderstats = Instance.new("Folder")
--     leaderstats.Name = "leaderstats"
--     leaderstats.Parent = player
    
--     -- Create Coins
--     local coins = Instance.new("IntValue")
--     coins.Name = "Coins"
--     coins.Value = 200  -- Starting coins (increased for testing)
--     coins.Parent = leaderstats
--     print("🪙 Created Coins:", coins.Value)
    
--     -- Create seed stats
--     local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--     for _, seedType in pairs(seedTypes) do
--         local seedStat = Instance.new("IntValue")
--         seedStat.Name = seedType .. "_Seeds"
--         seedStat.Value = 0
--         seedStat.Parent = leaderstats
--         print("📊 Created stat:", seedStat.Name)
--     end
    
--     -- Handle character spawning
--     player.CharacterAdded:Connect(function()
--         wait(2) -- Wait for backpack to load
        
--         print("🔄 Character spawned - recreating hotbar tools...")
        
--         -- Recreate all 3D seed tools based on current stats
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

-- -- Handle existing players (for Studio testing)
-- for _, player in pairs(Players:GetPlayers()) do
--     if not player:FindFirstChild("leaderstats") then
--         setupPlayer(player)
--     else
--         -- Recreate tools for existing players
--         wait(1)
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if leaderstats then
--             local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--             for _, seedType in pairs(seedTypes) do
--                 local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--                 if seedStat and seedStat.Value > 0 then
--                     createSeedTool(player, seedType, seedStat.Value)
--                 end
--             end
--         end
--     end
-- end

-- -- Debug command
-- Players.PlayerAdded:Connect(function(player)
--     player.Chatted:Connect(function(message)
--         if message:lower() == "/giveseeds" then
--             print("🎁 Giving test seeds to", player.Name)
--             local seedTypes = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}
--             local leaderstats = player:FindFirstChild("leaderstats")
--             if leaderstats then
--                 for _, seedType in pairs(seedTypes) do
--                     updatePlayerSeeds(player, seedType, 3) -- Give 3 of each seed
--                 end
--                 print("✅ Test seeds given!")
--             end
--         elseif message:lower() == "/cleartools" then
--             print("🧹 Clearing tools for", player.Name)
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
-- print("✨ Features: Colored seeds, particles, floating animation!")
-- print("🔧 Type /giveseeds for testing")


-- CUSTOM HOTBAR CLIENT - This goes in StarterPlayer > StarterPlayerScripts
-- This creates a visual hotbar like other successful games

-- CUSTOM HOTBAR CLIENT - This goes in StarterPlayer > StarterPlayerScripts
-- This creates a visual hotbar like other successful games

-- Add this to the TOP of your CustomHotbar client script
-- local StarterGui = game:GetService("StarterGui")

-- -- Disable default backpack on client side
-- task.spawn(function()
--     while true do
--         pcall(function()
--             StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
--         end)
--         task.wait(1)
--     end
-- end)

-- local Players = game:GetService("Players")
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local UserInputService = game:GetService("UserInputService")
-- local TweenService = game:GetService("TweenService")

-- local player = Players.LocalPlayer
-- local playerGui = player:FindFirstChildOfClass("PlayerGui")

-- -- Wait for remote events
-- local updateHotbarEvent = ReplicatedStorage:WaitForChild("UpdateHotbar")
-- local selectHotbarSlot = ReplicatedStorage:WaitForChild("SelectHotbarSlot")

-- -- Variables
-- local hotbarGui
-- local hotbarFrame
-- local slotFrames = {}
-- local currentHotbarData = {}
-- local selectedSlot = nil

-- -- Create the hotbar GUI
-- local function createHotbarGui()
--     -- Main ScreenGui
--     hotbarGui = Instance.new("ScreenGui")
--     hotbarGui.Name = "CustomHotbar"
--     hotbarGui.ResetOnSpawn = false
--     hotbarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
--     -- Main hotbar frame
--     hotbarFrame = Instance.new("Frame")
--     hotbarFrame.Name = "HotbarFrame"
--     hotbarFrame.Size = UDim2.new(0, 520, 0, 80)
--     hotbarFrame.Position = UDim2.new(0.5, -260, 1, -100) -- Bottom center
--     hotbarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
--     hotbarFrame.BorderSizePixel = 0
--     hotbarFrame.Parent = hotbarGui
    
--     -- Rounded corners
--     local corner = Instance.new("UICorner")
--     corner.CornerRadius = UDim.new(0, 8)
--     corner.Parent = hotbarFrame
    
--     -- Drop shadow effect
--     local shadow = Instance.new("Frame")
--     shadow.Name = "Shadow"
--     shadow.Size = UDim2.new(1, 6, 1, 6)
--     shadow.Position = UDim2.new(0, -3, 0, -3)
--     shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
--     shadow.BackgroundTransparency = 0.8
--     shadow.ZIndex = hotbarFrame.ZIndex - 1
--     shadow.Parent = hotbarFrame
    
--     local shadowCorner = Instance.new("UICorner")
--     shadowCorner.CornerRadius = UDim.new(0, 8)
--     shadowCorner.Parent = shadow
    
--     -- Create 5 slots
--     for i = 1, 5 do
--         local slotFrame = Instance.new("Frame")
--         slotFrame.Name = "Slot" .. i
--         slotFrame.Size = UDim2.new(0, 80, 0, 80)
--         slotFrame.Position = UDim2.new(0, (i-1) * 90 + 20, 0, 0)
--         slotFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
--         slotFrame.BorderSizePixel = 0
--         slotFrame.Parent = hotbarFrame
        
--         local slotCorner = Instance.new("UICorner")
--         slotCorner.CornerRadius = UDim.new(0, 6)
--         slotCorner.Parent = slotFrame
        
--         -- Slot number label
--         local numberLabel = Instance.new("TextLabel")
--         numberLabel.Name = "Number"
--         numberLabel.Size = UDim2.new(0, 20, 0, 20)
--         numberLabel.Position = UDim2.new(0, 2, 0, 2)
--         numberLabel.BackgroundTransparency = 1
--         numberLabel.Text = tostring(i)
--         numberLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
--         numberLabel.TextSize = 12
--         numberLabel.Font = Enum.Font.GothamBold
--         numberLabel.Parent = slotFrame
        
--         -- Seed visual (using emoji/text instead of images)
--         local seedLabel = Instance.new("TextLabel")
--         seedLabel.Name = "SeedVisual"
--         seedLabel.Size = UDim2.new(0, 50, 0, 50)
--         seedLabel.Position = UDim2.new(0.5, -25, 0.5, -25)
--         seedLabel.BackgroundTransparency = 1
--         seedLabel.Text = ""
--         seedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
--         seedLabel.TextSize = 32
--         seedLabel.Font = Enum.Font.GothamBold
--         seedLabel.TextStrokeTransparency = 0
--         seedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
--         seedLabel.Parent = slotFrame
        
--         -- Quantity label
--         local quantityLabel = Instance.new("TextLabel")
--         quantityLabel.Name = "Quantity"
--         quantityLabel.Size = UDim2.new(0, 25, 0, 20)
--         quantityLabel.Position = UDim2.new(1, -27, 1, -22)
--         quantityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
--         quantityLabel.BackgroundTransparency = 0.3
--         quantityLabel.Text = ""
--         quantityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
--         quantityLabel.TextSize = 10
--         quantityLabel.Font = Enum.Font.GothamBold
--         quantityLabel.TextStrokeTransparency = 0
--         quantityLabel.Parent = slotFrame
        
--         local quantityCorner = Instance.new("UICorner")
--         quantityCorner.CornerRadius = UDim.new(0, 4)
--         quantityCorner.Parent = quantityLabel
        
--         -- Selection highlight
--         local highlight = Instance.new("Frame")
--         highlight.Name = "Highlight"
--         highlight.Size = UDim2.new(1, 4, 1, 4)
--         highlight.Position = UDim2.new(0, -2, 0, -2)
--         highlight.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
--         highlight.BackgroundTransparency = 1
--         highlight.BorderSizePixel = 0
--         highlight.ZIndex = slotFrame.ZIndex - 1
--         highlight.Parent = slotFrame
        
--         local highlightCorner = Instance.new("UICorner")
--         highlightCorner.CornerRadius = UDim.new(0, 8)
--         highlightCorner.Parent = highlight
        
--         -- Click detection
--         local clickButton = Instance.new("TextButton")
--         clickButton.Name = "ClickButton"
--         clickButton.Size = UDim2.new(1, 0, 1, 0)
--         clickButton.Position = UDim2.new(0, 0, 0, 0)
--         clickButton.BackgroundTransparency = 1
--         clickButton.Text = ""
--         clickButton.Parent = slotFrame
        
--         -- Store reference
--         slotFrames[i] = {
--             frame = slotFrame,
--             visual = seedLabel,
--             quantity = quantityLabel,
--             highlight = highlight,
--             button = clickButton
--         }
        
--         -- Click handler
--         clickButton.MouseButton1Click:Connect(function()
--             selectSlot(i)
--         end)
        
--         -- Hover effects
--         clickButton.MouseEnter:Connect(function()
--             if selectedSlot ~= i then
--                 local tween = TweenService:Create(slotFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
--                 tween:Play()
--             end
--         end)
        
--         clickButton.MouseLeave:Connect(function()
--             if selectedSlot ~= i then
--                 local tween = TweenService:Create(slotFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
--                 tween:Play()
--             end
--         end)
--     end
    
--     hotbarGui.Parent = playerGui
--     print("✅ Custom hotbar GUI created!")
-- end

-- -- Function to update hotbar display
-- local function updateHotbarDisplay(hotbarData)
--     currentHotbarData = hotbarData
    
--     -- Clear all slots first
--     for i = 1, 5 do
--         local slot = slotFrames[i]
--         slot.visual.Text = ""
--         slot.visual.TextColor3 = Color3.fromRGB(255, 255, 255)
--         slot.quantity.Text = ""
--         slot.quantity.Visible = false
--     end
    
--     -- Seed emojis and colors
--     local seedVisuals = {
--         Carrot = {emoji = "🥕", color = Color3.fromRGB(255, 140, 0)},
--         Tomato = {emoji = "🍅", color = Color3.fromRGB(255, 69, 0)},
--         Potato = {emoji = "🥔", color = Color3.fromRGB(139, 69, 19)},
--         Wheat = {emoji = "🌾", color = Color3.fromRGB(255, 215, 0)},
--         Corn = {emoji = "🌽", color = Color3.fromRGB(255, 255, 0)}
--     }
    
--     -- Fill slots with data
--     for _, item in ipairs(hotbarData) do
--         if item.slot <= 5 then
--             local slot = slotFrames[item.slot]
--             local visual = seedVisuals[item.seedType] or {emoji = "🌱", color = Color3.fromRGB(100, 255, 100)}
            
--             slot.visual.Text = visual.emoji
--             slot.visual.TextColor3 = visual.color
--             slot.quantity.Text = tostring(item.quantity)
--             slot.quantity.Visible = true
            
--             print("📊 Updated slot", item.slot, "with", item.name, "x" .. item.quantity, visual.emoji)
--         end
--     end
-- end

-- -- Function to select a slot
-- function selectSlot(slotNumber)
--     -- Deselect previous slot
--     if selectedSlot then
--         local oldSlot = slotFrames[selectedSlot]
--         oldSlot.frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
--         oldSlot.highlight.BackgroundTransparency = 1
--     end
    
--     -- Check if slot has an item
--     local itemData = nil
--     for _, item in ipairs(currentHotbarData) do
--         if item.slot == slotNumber then
--             itemData = item
--             break
--         end
--     end
    
--     if itemData then
--         -- Select new slot
--         selectedSlot = slotNumber
--         local newSlot = slotFrames[slotNumber]
--         newSlot.frame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
--         newSlot.highlight.BackgroundTransparency = 0.5
        
--         -- Animation
--         local tween = TweenService:Create(newSlot.highlight, TweenInfo.new(0.2), {BackgroundTransparency = 0.3})
--         tween:Play()
        
--         -- Tell server
--         selectHotbarSlot:FireServer(slotNumber, itemData.seedType)
--         print("🎯 Selected slot", slotNumber, "with", itemData.name)
--     else
--         selectedSlot = nil
--         print("⚠️ Slot", slotNumber, "is empty")
--     end
-- end

-- -- Keyboard input
-- UserInputService.InputBegan:Connect(function(input, gameProcessed)
--     if gameProcessed then return end
    
--     -- Number keys 1-5
--     if input.KeyCode == Enum.KeyCode.One then
--         selectSlot(1)
--     elseif input.KeyCode == Enum.KeyCode.Two then
--         selectSlot(2)
--     elseif input.KeyCode == Enum.KeyCode.Three then
--         selectSlot(3)
--     elseif input.KeyCode == Enum.KeyCode.Four then
--         selectSlot(4)
--     elseif input.KeyCode == Enum.KeyCode.Five then
--         selectSlot(5)
--     end
-- end)

-- -- Listen for hotbar updates
-- updateHotbarEvent.OnClientEvent:Connect(function(hotbarData)
--     print("📨 Received hotbar update with", #hotbarData, "items")
--     updateHotbarDisplay(hotbarData)
-- end)

-- -- Initialize
-- createHotbarGui()

-- print("✅ Custom Hotbar Client loaded!")
-- print("🎮 Click slots or press 1-5 keys to select seeds!")
-- print("🌈 Now showing actual seed images with quantities!")


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui")

-- Disable default backpack GUI immediately and keep it disabled
task.spawn(function()
    while true do
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        end)
        task.wait(1)
    end
end)

-- Wait for remote events
local updateHotbarEvent = ReplicatedStorage:WaitForChild("UpdateHotbar")
local selectHotbarSlot = ReplicatedStorage:WaitForChild("SelectHotbarSlot")

-- Variables
local hotbarGui
local hotbarFrame
local slotFrames = {}
local currentHotbarData = {}
local selectedSlot = nil
local hotbarVisible = true -- Track visibility state

-- Create the hotbar GUI
local function createHotbarGui()
    -- Main ScreenGui
    hotbarGui = Instance.new("ScreenGui")
    hotbarGui.Name = "CustomHotbar"
    hotbarGui.ResetOnSpawn = false
    hotbarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main hotbar frame
    hotbarFrame = Instance.new("Frame")
    hotbarFrame.Name = "HotbarFrame"
    hotbarFrame.Size = UDim2.new(0, 520, 0, 80)
    hotbarFrame.Position = UDim2.new(0.5, -260, 1, -100) -- Bottom center
    hotbarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    hotbarFrame.BorderSizePixel = 0
    hotbarFrame.Parent = hotbarGui
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = hotbarFrame
    
    -- Drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = hotbarFrame.ZIndex - 1
    shadow.Parent = hotbarFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 8)
    shadowCorner.Parent = shadow
    
    -- Add toggle hint
    local toggleHint = Instance.new("TextLabel")
    toggleHint.Name = "ToggleHint"
    toggleHint.Size = UDim2.new(0, 100, 0, 20)
    toggleHint.Position = UDim2.new(0.5, -50, 0, -25)
    toggleHint.BackgroundTransparency = 1
    toggleHint.Text = "Press ~ to hide"
    toggleHint.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleHint.TextSize = 12
    toggleHint.Font = Enum.Font.Gotham
    toggleHint.TextTransparency = 0.7
    toggleHint.Parent = hotbarFrame
    
    -- Create 5 slots
    for i = 1, 5 do
        local slotFrame = Instance.new("Frame")
        slotFrame.Name = "Slot" .. i
        slotFrame.Size = UDim2.new(0, 80, 0, 80)
        slotFrame.Position = UDim2.new(0, (i-1) * 90 + 20, 0, 0)
        slotFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        slotFrame.BorderSizePixel = 0
        slotFrame.Parent = hotbarFrame
        
        local slotCorner = Instance.new("UICorner")
        slotCorner.CornerRadius = UDim.new(0, 6)
        slotCorner.Parent = slotFrame
        
        -- Slot number label
        local numberLabel = Instance.new("TextLabel")
        numberLabel.Name = "Number"
        numberLabel.Size = UDim2.new(0, 20, 0, 20)
        numberLabel.Position = UDim2.new(0, 2, 0, 2)
        numberLabel.BackgroundTransparency = 1
        numberLabel.Text = tostring(i)
        numberLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        numberLabel.TextSize = 12
        numberLabel.Font = Enum.Font.GothamBold
        numberLabel.Parent = slotFrame
        
        -- Seed visual (using emoji/text instead of images)
        local seedLabel = Instance.new("TextLabel")
        seedLabel.Name = "SeedVisual"
        seedLabel.Size = UDim2.new(0, 50, 0, 50)
        seedLabel.Position = UDim2.new(0.5, -25, 0.5, -25)
        seedLabel.BackgroundTransparency = 1
        seedLabel.Text = ""
        seedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        seedLabel.TextSize = 32
        seedLabel.Font = Enum.Font.GothamBold
        seedLabel.TextStrokeTransparency = 0
        seedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        seedLabel.Parent = slotFrame
        
        -- Quantity label
        local quantityLabel = Instance.new("TextLabel")
        quantityLabel.Name = "Quantity"
        quantityLabel.Size = UDim2.new(0, 25, 0, 20)
        quantityLabel.Position = UDim2.new(1, -27, 1, -22)
        quantityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        quantityLabel.BackgroundTransparency = 0.3
        quantityLabel.Text = ""
        quantityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        quantityLabel.TextSize = 10
        quantityLabel.Font = Enum.Font.GothamBold
        quantityLabel.TextStrokeTransparency = 0
        quantityLabel.Parent = slotFrame
        
        local quantityCorner = Instance.new("UICorner")
        quantityCorner.CornerRadius = UDim.new(0, 4)
        quantityCorner.Parent = quantityLabel
        
        -- Selection highlight
        local highlight = Instance.new("Frame")
        highlight.Name = "Highlight"
        highlight.Size = UDim2.new(1, 4, 1, 4)
        highlight.Position = UDim2.new(0, -2, 0, -2)
        highlight.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        highlight.BackgroundTransparency = 1
        highlight.BorderSizePixel = 0
        highlight.ZIndex = slotFrame.ZIndex - 1
        highlight.Parent = slotFrame
        
        local highlightCorner = Instance.new("UICorner")
        highlightCorner.CornerRadius = UDim.new(0, 8)
        highlightCorner.Parent = highlight
        
        -- Click detection
        local clickButton = Instance.new("TextButton")
        clickButton.Name = "ClickButton"
        clickButton.Size = UDim2.new(1, 0, 1, 0)
        clickButton.Position = UDim2.new(0, 0, 0, 0)
        clickButton.BackgroundTransparency = 1
        clickButton.Text = ""
        clickButton.Parent = slotFrame
        
        -- Store reference
        slotFrames[i] = {
            frame = slotFrame,
            visual = seedLabel,
            quantity = quantityLabel,
            highlight = highlight,
            button = clickButton
        }
        
        -- Click handler
        clickButton.MouseButton1Click:Connect(function()
            selectSlot(i)
        end)
        
        -- Hover effects
        clickButton.MouseEnter:Connect(function()
            if selectedSlot ~= i then
                local tween = TweenService:Create(slotFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
                tween:Play()
            end
        end)
        
        clickButton.MouseLeave:Connect(function()
            if selectedSlot ~= i then
                local tween = TweenService:Create(slotFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
                tween:Play()
            end
        end)
    end
    
    hotbarGui.Parent = playerGui
    print("✅ Custom hotbar GUI created with toggle feature!")
end

-- Function to toggle hotbar visibility
local function toggleHotbar()
    if not hotbarFrame then return end
    
    hotbarVisible = not hotbarVisible
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if hotbarVisible then
        -- Show hotbar - slide up from bottom
        local showTween = TweenService:Create(hotbarFrame, tweenInfo, {
            Position = UDim2.new(0.5, -260, 1, -100),
            BackgroundTransparency = 0
        })
        
        -- Show shadow
        local shadowTween = TweenService:Create(hotbarFrame.Shadow, tweenInfo, {
            BackgroundTransparency = 0.8
        })
        
        showTween:Play()
        shadowTween:Play()
        
        -- Show all child elements
        for _, slotData in pairs(slotFrames) do
            slotData.frame.BackgroundTransparency = 0
            slotData.visual.TextTransparency = 0
            slotData.visual.TextStrokeTransparency = 0
            slotData.quantity.BackgroundTransparency = 0.3
            slotData.quantity.TextTransparency = 0
        end
        
        -- Update hint text
        hotbarFrame.ToggleHint.Text = "Press ~ to hide"
        hotbarFrame.ToggleHint.TextTransparency = 0.7
        
        print("🌱 Hotbar shown")
        
    else
        -- Hide hotbar - slide down
        local hideTween = TweenService:Create(hotbarFrame, tweenInfo, {
            Position = UDim2.new(0.5, -260, 1, 20),
            BackgroundTransparency = 1
        })
        
        -- Hide shadow
        local shadowTween = TweenService:Create(hotbarFrame.Shadow, tweenInfo, {
            BackgroundTransparency = 1
        })
        
        hideTween:Play()
        shadowTween:Play()
        
        -- Hide all child elements
        for _, slotData in pairs(slotFrames) do
            slotData.frame.BackgroundTransparency = 1
            slotData.visual.TextTransparency = 1
            slotData.visual.TextStrokeTransparency = 1
            slotData.quantity.BackgroundTransparency = 1
            slotData.quantity.TextTransparency = 1
        end
        
        -- Update hint text
        hotbarFrame.ToggleHint.Text = "Press ~ to show"
        hotbarFrame.ToggleHint.TextTransparency = 0.3
        
        print("🙈 Hotbar hidden")
    end
end

-- Function to update hotbar display
local function updateHotbarDisplay(hotbarData)
    currentHotbarData = hotbarData
    
    -- Clear all slots first
    for i = 1, 5 do
        local slot = slotFrames[i]
        slot.visual.Text = ""
        slot.visual.TextColor3 = Color3.fromRGB(255, 255, 255)
        slot.quantity.Text = ""
        slot.quantity.Visible = false
    end
    
    -- Seed emojis and colors
    local seedVisuals = {
        Carrot = {emoji = "🥕", color = Color3.fromRGB(255, 140, 0)},
        Tomato = {emoji = "🍅", color = Color3.fromRGB(255, 69, 0)},
        Potato = {emoji = "🥔", color = Color3.fromRGB(139, 69, 19)},
        Wheat = {emoji = "🌾", color = Color3.fromRGB(255, 215, 0)},
        Corn = {emoji = "🌽", color = Color3.fromRGB(255, 255, 0)}
    }
    
    -- Fill slots with data
    for _, item in ipairs(hotbarData) do
        if item.slot <= 5 then
            local slot = slotFrames[item.slot]
            local visual = seedVisuals[item.seedType] or {emoji = "🌱", color = Color3.fromRGB(100, 255, 100)}
            
            slot.visual.Text = visual.emoji
            slot.visual.TextColor3 = visual.color
            slot.quantity.Text = tostring(item.quantity)
            slot.quantity.Visible = true
            
            print("📊 Updated slot", item.slot, "with", item.name, "x" .. item.quantity, visual.emoji)
        end
    end
end

-- Function to select a slot
function selectSlot(slotNumber)
    -- Don't allow selection if hotbar is hidden
    if not hotbarVisible then
        print("⚠️ Hotbar is hidden - press ~ to show")
        return
    end
    
    -- Deselect previous slot
    if selectedSlot then
        local oldSlot = slotFrames[selectedSlot]
        oldSlot.frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        oldSlot.highlight.BackgroundTransparency = 1
    end
    
    -- Check if slot has an item
    local itemData = nil
    for _, item in ipairs(currentHotbarData) do
        if item.slot == slotNumber then
            itemData = item
            break
        end
    end
    
    if itemData then
        -- Select new slot
        selectedSlot = slotNumber
        local newSlot = slotFrames[slotNumber]
        newSlot.frame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        newSlot.highlight.BackgroundTransparency = 0.5
        
        -- Animation
        local tween = TweenService:Create(newSlot.highlight, TweenInfo.new(0.2), {BackgroundTransparency = 0.3})
        tween:Play()
        
        -- Tell server
        selectHotbarSlot:FireServer(slotNumber, itemData.seedType)
        print("🎯 Selected slot", slotNumber, "with", itemData.name)
    else
        selectedSlot = nil
        print("⚠️ Slot", slotNumber, "is empty")
    end
end

-- Keyboard input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Tilde key (~) to toggle hotbar
    if input.KeyCode == Enum.KeyCode.Backquote then -- This is the tilde key (~)
        toggleHotbar()
        return
    end
    
    -- Number keys 1-5 (only work when hotbar is visible)
    if hotbarVisible then
        if input.KeyCode == Enum.KeyCode.One then
            selectSlot(1)
        elseif input.KeyCode == Enum.KeyCode.Two then
            selectSlot(2)
        elseif input.KeyCode == Enum.KeyCode.Three then
            selectSlot(3)
        elseif input.KeyCode == Enum.KeyCode.Four then
            selectSlot(4)
        elseif input.KeyCode == Enum.KeyCode.Five then
            selectSlot(5)
        end
    end
end)

-- Listen for hotbar updates
updateHotbarEvent.OnClientEvent:Connect(function(hotbarData)
    print("📨 Received hotbar update with", #hotbarData, "items")
    updateHotbarDisplay(hotbarData)
end)

-- Initialize
createHotbarGui()

print("✅ Custom Hotbar Client loaded with toggle feature!")
print("🎮 Click slots or press 1-5 keys to select seeds!")
print("🔄 Press ~ (tilde) to show/hide the hotbar!")
print("🌈 Now showing actual seed emojis with quantities!")