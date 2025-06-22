-- SeedShopServerHandler (place this in ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local seedShopEvent = ReplicatedStorage:WaitForChild("SeedShopEvent")

-- Example seed items stored in ReplicatedStorage
local seedModels = ReplicatedStorage:WaitForChild("SeedItems") -- Folder containing Tools or Models

-- Example: Player coins and seed data (you should replace with your data saving system)
local playerData = {}

-- Server handles the purchase request
seedShopEvent.OnServerEvent:Connect(function(player, action, seedType)
	if action == "PurchaseSeeds" then
		local coins = playerData[player] and playerData[player].coins or 0
		local seedInfo = {
			price = 50,
			seedsPerPack = 5
		}

		-- Check if player can afford
		if coins >= seedInfo.price then
			-- Deduct coins
			playerData[player] = playerData[player] or {}
			playerData[player].coins = coins - seedInfo.price

			-- Update seed ownership
			playerData[player].seeds = playerData[player].seeds or {}
			playerData[player].seeds[seedType] = (playerData[player].seeds[seedType] or 0) + seedInfo.seedsPerPack

			-- Clone and give the seed item
			local itemTemplate = seedModels:FindFirstChild(seedType)
			if itemTemplate then
				local itemClone = itemTemplate:Clone()
				itemClone.Parent = player.Backpack -- Or use Workspace or a custom inventory
			end

			-- Send success response
			seedShopEvent:FireClient(player, "PurchaseResult", true, "Purchase successful!", seedType)
			seedShopEvent:FireClient(player, "UpdateData", playerData[player].coins, seedType, playerData[player].seeds[seedType])
		else
			seedShopEvent:FireClient(player, "PurchaseResult", false, "Not enough coins!", seedType)
		end
	end
end)
