-- -- HYBRID HOTBAR SYSTEM - Works with your existing tool system
-- -- Replace your hotbarsystemserver script with this

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Players = game:GetService("Players")
-- local StarterGui = game:GetService("StarterGui")

-- -- Create RemoteEvents
-- local function getOrCreateRemoteEvent(name)
--     local event = ReplicatedStorage:FindFirstChild(name)
--     if not event then
--         event = Instance.new("RemoteEvent")
--         event.Name = name
--         event.Parent = ReplicatedStorage
--     end
--     return event
-- end

-- local updateHotbarEvent = getOrCreateRemoteEvent("UpdateHotbar")
-- local selectHotbarSlot = getOrCreateRemoteEvent("SelectHotbarSlot")
-- local enterPlantingMode = getOrCreateRemoteEvent("EnterPlantingMode")

-- -- Seed data with emojis for GUI
-- local SEED_DATA = {
--     Carrot = {
--         name = "Carrot Seeds",
--         emoji = "🥕",
--         color = Color3.fromRGB(255, 140, 0),
--         price = 8
--     },
--     Tomato = {
--         name = "Tomato Seeds", 
--         emoji = "🍅",
--         color = Color3.fromRGB(255, 69, 0),
--         price = 5
--     },
--     Potato = {
--         name = "Potato Seeds",
--         emoji = "🥔",
--         color = Color3.fromRGB(139, 69, 19),
--         price = 10
--     },
--     Wheat = {
--         name = "Wheat Seeds",
--         emoji = "🌾",
--         color = Color3.fromRGB(255, 215, 0), 
--         price = 12
--     },
--     Corn = {
--         name = "Corn Seeds",
--         emoji = "🌽",
--         color = Color3.fromRGB(255, 255, 0),
--         price = 15
--     }
-- }

-- -- Function to update player hotbar GUI
-- local function updatePlayerHotbar(player)
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if not leaderstats then return end
    
--     local hotbarData = {}
    
--     -- Build hotbar data from leaderstats
--     for seedType, data in pairs(SEED_DATA) do
--         local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--         if seedStat and seedStat.Value > 0 then
--             table.insert(hotbarData, {
--                 seedType = seedType,
--                 name = data.name,
--                 emoji = data.emoji,
--                 color = data.color,
--                 quantity = seedStat.Value,
--                 slot = #hotbarData + 1
--             })
--         end
--     end
    
--     -- Send to client GUI
--     updateHotbarEvent:FireClient(player, hotbarData)
--     print("📊 Sent hotbar data to", player.Name, "- Items:", #hotbarData)
-- end

-- -- Handle hotbar slot selection from GUI
-- selectHotbarSlot.OnServerEvent:Connect(function(player, slotNumber, seedType)
--     print("🎯 Player", player.Name, "selected slot", slotNumber, "with", seedType)
    
--     local leaderstats = player:FindFirstChild("leaderstats") 
--     if leaderstats then
--         local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--         if seedStat and seedStat.Value > 0 then
--             -- Find and equip the existing tool (created by SeedShopHandler)
--             local backpack = player:FindFirstChild("Backpack")
--             local character = player.Character
            
--             if backpack and character then
--                 local humanoid = character:FindFirstChildOfClass("Humanoid")
                
--                 -- Look for the tool in backpack
--                 local seedTool = backpack:FindFirstChild(seedType .. " Seeds")
                
--                 if seedTool and humanoid then
--                     -- Equip the tool first
--                     humanoid:EquipTool(seedTool)
--                     print("✅ Equipped tool:", seedTool.Name)
                    
--                     -- Then activate planting mode
--                     task.wait(0.1)
--                     enterPlantingMode:FireClient(player, seedType, seedStat.Value)
--                     print("🌱 Activated planting mode:", seedType)
--                 else
--                     print("⚠️ Tool not found:", seedType .. " Seeds")
--                     -- Fallback - just activate planting mode
--                     enterPlantingMode:FireClient(player, seedType, seedStat.Value)
--                 end
--             end
--         end
--     end
-- end)

-- -- Function to monitor leaderstats changes and update hotbar
-- local function setupLeaderstatMonitoring(player)
--     local leaderstats = player:FindFirstChild("leaderstats")
--     if not leaderstats then return end
    
--     -- Monitor seed changes
--     for seedType, _ in pairs(SEED_DATA) do
--         local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--         if seedStat then
--             seedStat.Changed:Connect(function()
--                 -- Small delay to let tool creation finish
--                 task.wait(0.1)
--                 updatePlayerHotbar(player)
--             end)
--         end
--     end
-- end

-- -- Player setup - HYBRID VERSION
-- local function setupPlayer(player)
--     print("🌱 Setting up hybrid hotbar for:", player.Name)
    
--     -- Disable default backpack GUI but keep tools working
--     player.CharacterAdded:Connect(function(character)
--         task.wait(1) -- Wait for character to load
        
--         -- Hide default backpack GUI but keep tools functional
--         local playerGui = player:FindFirstChildOfClass("PlayerGui")
--         if playerGui then
--             pcall(function()
--                 StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
--             end)
--         end
        
--         -- Setup leaderstat monitoring
--         task.wait(1)
--         setupLeaderstatMonitoring(player)
--         updatePlayerHotbar(player)
--     end)
    
--     -- Setup monitoring for existing character
--     if player.Character then
--         task.wait(1)
--         setupLeaderstatMonitoring(player)
--         updatePlayerHotbar(player)
--     end
-- end

-- -- Handle shop purchases (works with existing SeedShopHandler)
-- local seedShopEvent = getOrCreateRemoteEvent("SeedShopEvent")
-- seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
--     if action == "PurchaseSeeds" then
--         local leaderstats = player:FindFirstChild("leaderstats")
--         if not leaderstats then return end
        
--         local coinsValue = leaderstats:FindFirstChild("Coins")
--         if not coinsValue then return end
        
--         local seedData = SEED_DATA[seedType]
--         if not seedData then return end
        
--         local price = seedData.price
        
--         if coinsValue.Value >= price then
--             coinsValue.Value = coinsValue.Value - price
            
--             local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--             if seedStat then
--                 seedStat.Value = seedStat.Value + 1
--             end
            
--             seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchased " .. seedData.name .. "!")
--             print("✅ Purchase completed:", player.Name, "bought", seedType, "seeds")
--         else
--             seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!")
--         end
--     end
-- end)

-- -- Handle players
-- Players.PlayerAdded:Connect(setupPlayer)

-- -- Setup existing players
-- for _, player in pairs(Players:GetPlayers()) do
--     setupPlayer(player)
-- end

-- -- Test commands
-- Players.PlayerAdded:Connect(function(player)
--     player.Chatted:Connect(function(message)
--         if message:lower() == "/giveseeds" then
--             local leaderstats = player:FindFirstChild("leaderstats")
--             if leaderstats then
--                 for seedType, _ in pairs(SEED_DATA) do
--                     local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
--                     if seedStat then
--                         seedStat.Value = seedStat.Value + 3
--                     end
--                 end
--                 print("✅ Test seeds given to", player.Name)
--             end
            
--         elseif message:lower() == "/refreshhotbar" then
--             updatePlayerHotbar(player)
--             print("🔄 Hotbar refreshed for", player.Name)
            
--         elseif message:lower() == "/cleartools" then
--             -- Clear tools but keep the system working
--             local backpack = player:FindFirstChild("Backpack")
--             if backpack then
--                 for _, tool in pairs(backpack:GetChildren()) do
--                     if tool:IsA("Tool") and tool.Name:find("Seeds") then
--                         tool:Destroy()
--                     end
--                 end
--             end
--             if player.Character then
--                 for _, tool in pairs(player.Character:GetChildren()) do
--                     if tool:IsA("Tool") and tool.Name:find("Seeds") then
--                         tool:Destroy()
--                     end
--                 end
--             end
--             print("🧹 Cleared tools for", player.Name)
--         end
--     end)
-- end)

-- print("✅ Hybrid Hotbar System loaded!")
-- print("🎮 Custom GUI + Working Tools!")
-- print("🔧 Type /giveseeds for testing")
-- print("🔄 Type /refreshhotbar to refresh")
-- print("🧹 Type /cleartools to clear tools")

-- HYBRID HOTBAR SYSTEM - Works with your existing tool system
-- Replace your hotbarsystemserver script with this

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Create RemoteEvents
local function getOrCreateRemoteEvent(name)
    local event = ReplicatedStorage:FindFirstChild(name)
    if not event then
        event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = ReplicatedStorage
    end
    return event
end

local updateHotbarEvent = getOrCreateRemoteEvent("UpdateHotbar")
local selectHotbarSlot = getOrCreateRemoteEvent("SelectHotbarSlot")
local enterPlantingMode = getOrCreateRemoteEvent("EnterPlantingMode")

-- Seed data with emojis for GUI
local SEED_DATA = {
    Carrot = {
        name = "Carrot Seeds",
        emoji = "🥕",
        color = Color3.fromRGB(255, 140, 0),
        price = 8
    },
    Tomato = {
        name = "Tomato Seeds", 
        emoji = "🍅",
        color = Color3.fromRGB(255, 69, 0),
        price = 5
    },
    Potato = {
        name = "Potato Seeds",
        emoji = "🥔",
        color = Color3.fromRGB(139, 69, 19),
        price = 10
    },
    Wheat = {
        name = "Wheat Seeds",
        emoji = "🌾",
        color = Color3.fromRGB(255, 215, 0), 
        price = 12
    },
    Corn = {
        name = "Corn Seeds",
        emoji = "🌽",
        color = Color3.fromRGB(255, 255, 0),
        price = 15
    }
}

-- Function to update player hotbar GUI
local function updatePlayerHotbar(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local hotbarData = {}
    
    -- Build hotbar data from leaderstats
    for seedType, data in pairs(SEED_DATA) do
        local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
        if seedStat and seedStat.Value > 0 then
            table.insert(hotbarData, {
                seedType = seedType,
                name = data.name,
                emoji = data.emoji,
                color = data.color,
                quantity = seedStat.Value,
                slot = #hotbarData + 1
            })
        end
    end
    
    -- Send to client GUI
    updateHotbarEvent:FireClient(player, hotbarData)
    print("📊 Sent hotbar data to", player.Name, "- Items:", #hotbarData)
end

-- Handle hotbar slot selection from GUI
selectHotbarSlot.OnServerEvent:Connect(function(player, slotNumber, seedType)
    print("🎯 Player", player.Name, "selected slot", slotNumber, "with", seedType)
    
    local leaderstats = player:FindFirstChild("leaderstats") 
    if leaderstats then
        local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
        if seedStat and seedStat.Value > 0 then
            -- Find and equip the existing tool (created by SeedShopHandler)
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character
            
            if backpack and character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                -- Look for the tool in backpack
                local seedTool = backpack:FindFirstChild(seedType .. " Seeds")
                
                if seedTool and humanoid then
                    -- Equip the tool first
                    humanoid:EquipTool(seedTool)
                    print("✅ Equipped tool:", seedTool.Name)
                    
                    -- Then activate planting mode
                    task.wait(0.1)
                    enterPlantingMode:FireClient(player, seedType, seedStat.Value)
                    print("🌱 Activated planting mode:", seedType)
                else
                    print("⚠️ Tool not found:", seedType .. " Seeds")
                    -- Fallback - just activate planting mode
                    enterPlantingMode:FireClient(player, seedType, seedStat.Value)
                end
            end
        end
    end
end)

-- Function to monitor leaderstats changes and update hotbar
local function setupLeaderstatMonitoring(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    -- Monitor seed changes
    for seedType, _ in pairs(SEED_DATA) do
        local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
        if seedStat then
            seedStat.Changed:Connect(function()
                -- Small delay to let tool creation finish
                task.wait(0.1)
                updatePlayerHotbar(player)
            end)
        end
    end
end

-- Player setup - HYBRID VERSION
local function setupPlayer(player)
    print("🌱 Setting up hybrid hotbar for:", player.Name)
    
    -- IMMEDIATELY disable default backpack GUI
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    end)
    
    -- Also disable for this specific player
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5) -- Shorter wait
        
        -- Double-disable the backpack GUI
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        end)
        
        -- Force hide any backpack GUI that appears
        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            task.spawn(function()
                -- Keep checking and removing default backpack GUI
                while player.Parent do
                    local backpackGui = playerGui:FindFirstChild("Backpack")
                    if backpackGui then
                        backpackGui.Enabled = false
                        backpackGui:Destroy()
                    end
                    
                    -- Also check for CoreGui backpack
                    local coreBackpack = playerGui:FindFirstChild("BackpackGui")
                    if coreBackpack then
                        coreBackpack.Enabled = false
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
        
        -- Setup leaderstat monitoring
        task.wait(0.5)
        setupLeaderstatMonitoring(player)
        updatePlayerHotbar(player)
    end)
    
    -- Setup monitoring for existing character
    if player.Character then
        task.wait(1)
        setupLeaderstatMonitoring(player)
        updatePlayerHotbar(player)
    end
end

-- Handle shop purchases (works with existing SeedShopHandler)
local seedShopEvent = getOrCreateRemoteEvent("SeedShopEvent")
seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
    if action == "PurchaseSeeds" then
        local leaderstats = player:FindFirstChild("leaderstats")
        if not leaderstats then return end
        
        local coinsValue = leaderstats:FindFirstChild("Coins")
        if not coinsValue then return end
        
        local seedData = SEED_DATA[seedType]
        if not seedData then return end
        
        local price = seedData.price
        
        if coinsValue.Value >= price then
            coinsValue.Value = coinsValue.Value - price
            
            local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
            if seedStat then
                seedStat.Value = seedStat.Value + 1
            end
            
            seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchased " .. seedData.name .. "!")
            print("✅ Purchase completed:", player.Name, "bought", seedType, "seeds")
        else
            seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!")
        end
    end
end)

-- Handle players
Players.PlayerAdded:Connect(setupPlayer)

-- Setup existing players
for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- FORCE DISABLE DEFAULT HOTBAR GLOBALLY
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

-- Also disable for all current players immediately
for _, player in pairs(Players:GetPlayers()) do
    task.spawn(function()
        pcall(function()
            local playerGui = player:FindFirstChildOfClass("PlayerGui")
            if playerGui then
                local backpackGui = playerGui:FindFirstChild("Backpack")
                if backpackGui then
                    backpackGui.Enabled = false
                    backpackGui:Destroy()
                end
            end
        end)
    end)
end

-- Test commands
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "/giveseeds" then
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                for seedType, _ in pairs(SEED_DATA) do
                    local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
                    if seedStat then
                        seedStat.Value = seedStat.Value + 3
                    end
                end
                print("✅ Test seeds given to", player.Name)
            end
            
        elseif message:lower() == "/refreshhotbar" then
            updatePlayerHotbar(player)
            print("🔄 Hotbar refreshed for", player.Name)
            
        elseif message:lower() == "/cleartools" then
            -- Clear tools but keep the system working
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:find("Seeds") then
                        tool:Destroy()
                    end
                end
            end
            if player.Character then
                for _, tool in pairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:find("Seeds") then
                        tool:Destroy()
                    end
                end
            end
            print("🧹 Cleared tools for", player.Name)
        end
    end)
end)

print("✅ Hybrid Hotbar System loaded!")
print("🎮 Custom GUI + Working Tools!")
print("🔧 Type /giveseeds for testing")
print("🔄 Type /refreshhotbar to refresh")
print("🧹 Type /cleartools to clear tools")