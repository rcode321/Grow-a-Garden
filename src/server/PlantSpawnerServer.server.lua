-- -- PLANT SPAWNER SERVER - SPAWNS PLANTS WITH YOUR EXISTING SCRIPTS
-- -- PUT THIS IN ServerScriptService
-- -- Name it: "PlantSpawnerServer"

-- local Players = game:GetService("Players")
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ServerStorage = game:GetService("ServerStorage")

-- print("🌱 PLANT SPAWNER: Starting...")

-- -- Wait for seed inventory event
-- local seedInventoryEvent = ReplicatedStorage:WaitForChild("SeedInventoryEvent", 10)
-- if not seedInventoryEvent then
-- 	warn("❌ PLANT SPAWNER: SeedInventoryEvent not found!")
-- 	return
-- end

-- -- Create PlantSeed RemoteEvent for client communication
-- local plantSeedEvent = ReplicatedStorage:FindFirstChild("PlantSeed")
-- if not plantSeedEvent then
-- 	plantSeedEvent = Instance.new("RemoteEvent")
-- 	plantSeedEvent.Name = "PlantSeed"
-- 	plantSeedEvent.Parent = ReplicatedStorage
-- 	print("✅ PLANT SPAWNER: Created PlantSeed RemoteEvent")
-- end

-- -- Plant template locations - CHANGE THESE TO MATCH YOUR GAME
-- local PLANT_TEMPLATES = {
-- 	Carrot = "Carrot_grown",        -- Change to your carrot model name
-- 	Tomato = "tomato plant",        -- Change to your tomato model name
-- 	Plant = "Plant",                -- Change to your generic plant model name
-- 	Potato = "Plant",               -- Uses generic plant model
-- 	Wheat = "Plant",                -- Uses generic plant model
-- 	Corn = "Plant"                  -- Uses generic plant model
-- }

-- -- Function to find plant template
-- local function findPlantTemplate(plantType)
-- 	local templateName = PLANT_TEMPLATES[plantType]
-- 	if not templateName then
-- 		warn("❌ No template defined for plant type:", plantType)
-- 		return nil
-- 	end

-- 	-- Try ReplicatedStorage first
-- 	local template = ReplicatedStorage:FindFirstChild(templateName)
-- 	if template then
-- 		print("✅ Found template in ReplicatedStorage:", templateName)
-- 		return template
-- 	end

-- 	-- Try ServerStorage
-- 	template = ServerStorage:FindFirstChild(templateName)
-- 	if template then
-- 		print("✅ Found template in ServerStorage:", templateName)
-- 		return template
-- 	end

-- 	-- Try workspace
-- 	template = workspace:FindFirstChild(templateName)
-- 	if template then
-- 		print("✅ Found template in workspace:", templateName)
-- 		return template
-- 	end

-- 	warn("❌ Plant template not found:", templateName, "for plant type:", plantType)
-- 	return nil
-- end

-- -- Function to spawn plant at position
-- local function spawnPlant(plantType, position, player)
-- 	local template = findPlantTemplate(plantType)
-- 	if not template then
-- 		return false, "Plant template not found for " .. plantType
-- 	end

-- 	-- Clone the template
-- 	local newPlant = template:Clone()
-- 	newPlant.Name = plantType .. "_Growing_" .. tick() -- Unique name

-- 	-- Position the plant
-- 	if newPlant.PrimaryPart then
-- 		newPlant:SetPrimaryPartCFrame(CFrame.new(position))
-- 	else
-- 		-- Try to find a main part to position
-- 		local mainPart = newPlant:FindFirstChild("Part") or newPlant:FindFirstChildOfClass("Part")
-- 		if mainPart then
-- 			mainPart.Position = position
-- 			newPlant.PrimaryPart = mainPart
-- 		else
-- 			warn("❌ Cannot position plant - no parts found")
-- 			newPlant:Destroy()
-- 			return false, "Cannot position plant"
-- 		end
-- 	end

-- 	-- Make sure the plant script exists and is configured correctly
-- 	local plantScript = newPlant:FindFirstChildOfClass("Script")
-- 	if plantScript then
-- 		-- You can modify the PLANT_TYPE here if needed
-- 		-- For now, we'll let the script auto-detect or use default
-- 		print("✅ Plant has growth script")
-- 	else
-- 		-- If no script, add the multi-plant script
-- 		warn("⚠️ Plant has no growth script - adding default")
-- 		-- You could add your multi-plant script here if needed
-- 	end

-- 	-- Place in workspace
-- 	newPlant.Parent = workspace

-- 	print("✅ Spawned", plantType, "at", position, "for", player.Name)
-- 	return true, "Successfully planted " .. plantType .. "!"
-- end

-- -- Handle planting requests from client
-- plantSeedEvent.OnServerEvent:Connect(function(player, seedType, position)
-- 	print("🌱 PLANT SPAWNER: Plant request from", player.Name, "for", seedType)

-- 	-- Check if player has seeds
-- 	local leaderstats = player:FindFirstChild("leaderstats")
-- 	if not leaderstats then
-- 		seedInventoryEvent:FireClient(player, "PlantResult", false, "Player data not found!")
-- 		return
-- 	end

-- 	local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
-- 	if not seedStat or seedStat.Value <= 0 then
-- 		seedInventoryEvent:FireClient(player, "PlantResult", false, "You need " .. seedType .. " seeds to plant!")
-- 		return
-- 	end

-- 	-- Remove one seed
-- 	seedStat.Value = seedStat.Value - 1
-- 	print("🌱 Removed 1", seedType, "seed from", player.Name, "- Remaining:", seedStat.Value)

-- 	-- Spawn the plant
-- 	local success, message = spawnPlant(seedType, position, player)

-- 	if success then
-- 		-- Notify client of success
-- 		seedInventoryEvent:FireClient(player, "PlantResult", true, message)
-- 		seedInventoryEvent:FireClient(player, "UpdateSeeds", seedType, seedStat.Value)
-- 		print("✅ Successfully planted", seedType, "for", player.Name)
-- 	else
-- 		-- Return the seed if planting failed
-- 		seedStat.Value = seedStat.Value + 1
-- 		seedInventoryEvent:FireClient(player, "PlantResult", false, message)
-- 		warn("❌ Failed to plant", seedType, "for", player.Name, "-", message)
-- 	end
-- end)

-- print("✅ PLANT SPAWNER: Loaded successfully!")