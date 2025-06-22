-- HARVEST TEST SCRIPT - Put in ServerScriptService
-- This will help us debug what's happening

local Players = game:GetService("Players")

-- Simple test function
local function testHarvest(player)
    print("🧪 STARTING HARVEST TEST for", player.Name)
    print("=" .. string.rep("=", 50))
    
    -- Find all plants
    local plants = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            if obj.Name:find("Carrot") or obj.Name:find("Plant") or obj.Name:find("Tomato") then
                table.insert(plants, obj)
            end
        end
    end
    
    print("🌱 Found", #plants, "plants in workspace:")
    
    for i, plant in pairs(plants) do
        print("  Plant #" .. i .. ":", plant.Name)
        
        -- Check for ClickDetector
        local clickDetectors = {}
        for _, desc in pairs(plant:GetDescendants()) do
            if desc:IsA("ClickDetector") then
                table.insert(clickDetectors, desc)
                print("    ✅ ClickDetector found on:", desc.Parent.Name)
            end
        end
        
        if #clickDetectors == 0 then
            print("    ❌ NO ClickDetector found!")
            
            -- Let's add one manually for testing
            local soil = plant:FindFirstChild("Soil") or plant:FindFirstChild("Part")
            if soil then
                print("    🔧 Adding test ClickDetector to:", soil.Name)
                
                local cd = Instance.new("ClickDetector")
                cd.MaxActivationDistance = 25
                cd.Parent = soil
                
                -- Add bright visual indicator
                local light = Instance.new("PointLight")
                light.Name = "TEST_GLOW"
                light.Brightness = 3
                light.Range = 15
                light.Color = Color3.fromRGB(255, 0, 255) -- BRIGHT PINK so you can't miss it
                light.Parent = soil
                
                -- Make it REALLY obvious
                local box = Instance.new("SelectionBox")
                box.Name = "TEST_BOX"
                box.Adornee = soil
                box.Color3 = Color3.fromRGB(255, 0, 255) -- BRIGHT PINK
                box.LineThickness = 1
                box.Transparency = 0
                box.Parent = soil
                
                cd.MouseClick:Connect(function(clickingPlayer)
                    print("🖱️ TEST CLICK WORKS! Player:", clickingPlayer.Name, "clicked:", plant.Name)
                    
                    -- Give coins
                    local leaderstats = clickingPlayer:FindFirstChild("leaderstats")
                    if leaderstats then
                        local coins = leaderstats:FindFirstChild("Coins")
                        if coins then
                            coins.Value = coins.Value + 50
                            print("💰 Gave 50 coins! New total:", coins.Value)
                        end
                    end
                    
                    print("🗑️ Destroying plant for test...")
                    plant:Destroy()
                    print("✅ Plant destroyed!")
                end)
                
                print("    ✅ Test ClickDetector added with BRIGHT PINK glow!")
            else
                print("    ❌ No suitable part found in plant")
            end
        end
        
        -- Check for visual effects
        local hasGlow = false
        local hasBox = false
        for _, desc in pairs(plant:GetDescendants()) do
            if desc.Name == "HarvestGlow" then hasGlow = true end
            if desc.Name == "HarvestEffect" then hasBox = true end
        end
        
        print("    Visual effects - Glow:", hasGlow and "✅" or "❌", "Box:", hasBox and "✅" or "❌")
    end
    
    print("=" .. string.rep("=", 50))
    print("🎯 Look for BRIGHT PINK glow and boxes!")
    print("🖱️ Click on the pink glowing parts to test harvesting!")
    print("💡 If you see pink glow, the clicking should work!")
end

-- Command to run test
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "/testme" then
            testHarvest(player)
        elseif message:lower() == "/clicktest" then
            print("🧪 MANUAL CLICK TEST")
            
            -- Find first plant and trigger click manually
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and (obj.Name:find("Carrot") or obj.Name:find("Plant")) then
                    local cd = nil
                    for _, desc in pairs(obj:GetDescendants()) do
                        if desc:IsA("ClickDetector") then
                            cd = desc
                            break
                        end
                    end
                    
                    if cd then
                        print("🖱️ Manually triggering click on:", obj.Name)
                        -- Manually fire the click event
                        cd.MouseClick:Fire(player)
                        return
                    else
                        print("❌ No ClickDetector found on:", obj.Name)
                    end
                end
            end
            
            print("❌ No plants with ClickDetectors found")
        end
    end)
end)

print("🧪 HARVEST TEST SCRIPT LOADED!")
print("💬 Type /testme to run harvest test")
print("💬 Type /clicktest to manually trigger a harvest")
print("🎯 Look for BRIGHT PINK glow if test ClickDetectors are added!")