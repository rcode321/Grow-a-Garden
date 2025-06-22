-- LOCAL SCRIPT: Inventory UI System
-- PUT THIS SCRIPT IN StarterPlayer > StarterPlayerScripts AS A LOCAL SCRIPT

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Variables
local inventoryGui = nil
local isInventoryOpen = false
local inventoryButton = nil

-- Function to get current PlayerGui (handles respawning)
local function getPlayerGui()
	return player:WaitForChild("PlayerGui")
end

-- Wait for RemoteEvents
local harvestPlant = ReplicatedStorage:WaitForChild("HarvestPlant")
local updateInventory = ReplicatedStorage:WaitForChild("UpdateInventory")

-- Function to create inventory GUI
local function createInventoryGui()
	local playerGui = getPlayerGui()

	-- Remove old GUI if it exists
	local oldGui = playerGui:FindFirstChild("InventoryGui")
	if oldGui then
		oldGui:Destroy()
	end

	-- Main ScreenGui
	inventoryGui = Instance.new("ScreenGui")
	inventoryGui.Name = "InventoryGui"
	inventoryGui.ResetOnSpawn = false  -- Prevent GUI from being destroyed on death
	inventoryGui.Parent = playerGui

	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
	mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
	mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = inventoryGui

	-- Corner rounding
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0.7, 0, 0.12, 0)
	title.Position = UDim2.new(0.05, 0, 0.02, 0)
	title.BackgroundTransparency = 1
	title.Text = "🎒 INVENTORY"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 36
	title.Font = Enum.Font.SourceSansBold
	title.Parent = mainFrame

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0.08, 0, 0.08, 0)
	closeButton.Position = UDim2.new(0.88, 0, 0.03, 0)
	closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
	closeButton.Text = "✕"
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.Parent = mainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeButton

	-- Items collected display
	local coinsFrame = Instance.new("Frame")
	coinsFrame.Name = "CoinsFrame"
	coinsFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
	coinsFrame.Position = UDim2.new(0.05, 0, 0.16, 0)
	coinsFrame.BackgroundColor3 = Color3.new(1, 0.8, 0)
	coinsFrame.Parent = mainFrame

	local coinsCorner = Instance.new("UICorner")
	coinsCorner.CornerRadius = UDim.new(0, 8)
	coinsCorner.Parent = coinsFrame

	local coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, 0, 1, 0)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.Text = "💰 Items Collected: 0"
	coinsLabel.TextColor3 = Color3.new(0, 0, 0)
	coinsLabel.TextSize = 18
	coinsLabel.Font = Enum.Font.SourceSansBold
	coinsLabel.Parent = coinsFrame

	-- Inventory items scroll frame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ItemsScroll"
	scrollFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
	scrollFrame.Position = UDim2.new(0.05, 0, 0.26, 0)
	scrollFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.Parent = mainFrame

	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 8)
	scrollCorner.Parent = scrollFrame

	-- Layout for items
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.Name
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = scrollFrame

	-- Close button functionality
	closeButton.MouseButton1Click:Connect(function()
		toggleInventory()
	end)

	return mainFrame
end

-- Function to update inventory display
-- local function updateInventoryDisplay()
-- 	if not inventoryGui or not inventoryGui:FindFirstChild("MainFrame") then
-- 		return
-- 	end

-- 	local mainFrame = inventoryGui.MainFrame
-- 	local scrollFrame = mainFrame:FindFirstChild("ItemsScroll")
-- 	local coinsLabel = mainFrame:FindFirstChild("CoinsFrame"):FindFirstChild("CoinsLabel")

-- 	-- Update total items collected counter
-- 	local totalItems = 0
-- 	local inventory = player:FindFirstChild("Inventory")
-- 	if inventory then
-- 		local plantItems = inventory:FindFirstChild("PlantItems")
-- 		if plantItems then
-- 			for _, item in ipairs(plantItems:GetChildren()) do
-- 				if item:IsA("IntValue") then
-- 					totalItems = totalItems + item.Value
-- 				end
-- 			end
-- 		end
-- 	end
-- 	coinsLabel.Text = "💰 Items Collected: " .. totalItems

-- 	-- Clear existing items
-- 	for _, child in ipairs(scrollFrame:GetChildren()) do
-- 		if child:IsA("Frame") then
-- 			child:Destroy()
-- 		end
-- 	end

-- 	-- Add inventory items
-- 	if inventory then
-- 		local plantItems = inventory:FindFirstChild("PlantItems")
-- 		if plantItems then
-- 			for _, item in ipairs(plantItems:GetChildren()) do
-- 				if item:IsA("IntValue") and item.Value > 0 then
-- 					-- Create item frame
-- 					local itemFrame = Instance.new("Frame")
-- 					itemFrame.Name = item.Name .. "Frame"
-- 					itemFrame.Size = UDim2.new(1, -10, 0, 50)
-- 					itemFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
-- 					itemFrame.Parent = scrollFrame

-- 					local itemCorner = Instance.new("UICorner")
-- 					itemCorner.CornerRadius = UDim.new(0, 6)
-- 					itemCorner.Parent = itemFrame

-- 					-- Item icon (emoji based on type)
-- 					local icons = {
-- 						Tomato = "🍅",
-- 						Carrot = "🥕", 
-- 						Wheat = "🌾",
-- 						Corn = "🌽",
-- 						Potato = "🥔"
-- 					}

-- 					local itemIcon = Instance.new("TextLabel")
-- 					itemIcon.Size = UDim2.new(0.2, 0, 1, 0)
-- 					itemIcon.BackgroundTransparency = 1
-- 					itemIcon.Text = icons[item.Name] or "🌱"
-- 					itemIcon.TextScaled = true
-- 					itemIcon.Parent = itemFrame

-- 					-- Item name and count
-- 					local itemLabel = Instance.new("TextLabel")
-- 					itemLabel.Size = UDim2.new(0.8, 0, 1, 0)
-- 					itemLabel.Position = UDim2.new(0.2, 0, 0, 0)
-- 					itemLabel.BackgroundTransparency = 1
-- 					itemLabel.Text = item.Name .. ": " .. item.Value
-- 					itemLabel.TextColor3 = Color3.new(1, 1, 1)
-- 					itemLabel.TextXAlignment = Enum.TextXAlignment.Left
-- 					itemLabel.TextScaled = true
-- 					itemLabel.Font = Enum.Font.SourceSans
-- 					itemLabel.Parent = itemFrame
-- 				end
-- 			end
-- 		end
-- 	end

-- 	-- Update scroll canvas size
-- 	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIListLayout.AbsoluteContentSize.Y + 10)
-- end
local function updateInventoryDisplay()
    if not inventoryGui or not inventoryGui:FindFirstChild("MainFrame") then
        return
    end

    local mainFrame = inventoryGui.MainFrame
    local scrollFrame = mainFrame:FindFirstChild("ItemsScroll")
    local coinsLabel = mainFrame:FindFirstChild("CoinsFrame"):FindFirstChild("CoinsLabel")

    -- Update total items collected counter (unchanged)
    local totalItems = 0
    local inventory = player:FindFirstChild("Inventory")
    if inventory then
        local plantItems = inventory:FindFirstChild("PlantItems")
        if plantItems then
            for _, item in ipairs(plantItems:GetChildren()) do
                if item:IsA("IntValue") then
                    totalItems = totalItems + item.Value
                end
            end
        end
    end
    coinsLabel.Text = "💰 Items Collected: " .. totalItems

    -- Clear existing items
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Add inventory items
    if inventory then
        local plantItems = inventory:FindFirstChild("PlantItems")
        if plantItems then
            for _, item in ipairs(plantItems:GetChildren()) do
                if item:IsA("IntValue") and item.Value > 0 then
                    -- Create item frame
                    local itemFrame = Instance.new("Frame")
                    itemFrame.Name = item.Name .. "Frame"
                    itemFrame.Size = UDim2.new(1, -10, 0, 50)
                    itemFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                    itemFrame.Parent = scrollFrame

                    local itemCorner = Instance.new("UICorner")
                    itemCorner.CornerRadius = UDim.new(0, 6)
                    itemCorner.Parent = itemFrame

                    -- Item icon (emoji based on type - unchanged)
                    local icons = {
                        Tomato = "🍅",
                        Carrot = "🥕", 
                        Wheat = "🌾",
                        Corn = "🌽",
                        Potato = "🥔"
                    }

                    local itemIcon = Instance.new("TextLabel")
                    itemIcon.Size = UDim2.new(0.2, 0, 1, 0)
                    itemIcon.BackgroundTransparency = 1
                    itemIcon.Text = icons[item.Name] or "🌱"
                    itemIcon.TextScaled = true
                    itemIcon.Parent = itemFrame

                    -- Item name and count (unchanged)
                    local itemLabel = Instance.new("TextLabel")
                    itemLabel.Size = UDim2.new(0.8, 0, 1, 0)
                    itemLabel.Position = UDim2.new(0.2, 0, 0, 0)
                    itemLabel.BackgroundTransparency = 1
                    itemLabel.Text = item.Name .. ": " .. item.Value
                    itemLabel.TextColor3 = Color3.new(1, 1, 1)
                    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                    itemLabel.TextScaled = true
                    itemLabel.Font = Enum.Font.SourceSans
                    itemLabel.Parent = itemFrame
                end
            end
        end
    end

    -- Update scroll canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIListLayout.AbsoluteContentSize.Y + 10)
end
-- Function to toggle inventory
function toggleInventory()
	if not inventoryGui then
		createInventoryGui()
	end

	local mainFrame = inventoryGui.MainFrame
	isInventoryOpen = not isInventoryOpen

	if isInventoryOpen then
		mainFrame.Visible = true
		updateInventoryDisplay()

		-- Tween in
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local tween = TweenService:Create(mainFrame, tweenInfo, {
			Size = UDim2.new(0.4, 0, 0.6, 0),
			Position = UDim2.new(0.3, 0, 0.2, 0)
		})
		tween:Play()
	else
		-- Tween out
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tween = TweenService:Create(mainFrame, tweenInfo, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween:Play()

		tween.Completed:Connect(function()
			mainFrame.Visible = false
		end)
	end
end

-- Create inventory button
local function createInventoryButton()
	local playerGui = getPlayerGui()

	-- Remove old button if it exists
	local oldButton = playerGui:FindFirstChild("InventoryButton")
	if oldButton then
		oldButton:Destroy()
	end

	local buttonGui = Instance.new("ScreenGui")
	buttonGui.Name = "InventoryButton"
	buttonGui.ResetOnSpawn = false  -- Prevent button from being destroyed on death
	buttonGui.Parent = playerGui

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.1, 0, 0.08, 0)
	button.Position = UDim2.new(0.85, 0, 0.1, 0)
	button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	button.Text = "🎒"
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Font = Enum.Font.SourceSansBold
	button.Parent = buttonGui

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 10)
	buttonCorner.Parent = button

	button.MouseButton1Click:Connect(toggleInventory)

	inventoryButton = buttonGui
end

-- Handle harvest results
harvestPlant.OnClientEvent:Connect(function(harvestData)
	if harvestData and harvestData.items then
		local playerGui = getPlayerGui()  -- Get current PlayerGui

		-- Show harvest success message with animation
		local successGui = Instance.new("ScreenGui")
		successGui.Name = "HarvestSuccess"
		successGui.Parent = playerGui

		local successFrame = Instance.new("Frame")
		successFrame.Size = UDim2.new(0.25, 0, 0.12, 0)
		successFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
		successFrame.BackgroundColor3 = Color3.new(0.1, 0.7, 0.2)
		successFrame.BackgroundTransparency = 0.1
		successFrame.Parent = successGui

		-- Add border glow effect
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(0.4, 1, 0.4)
		stroke.Thickness = 3
		stroke.Parent = successFrame

		local successCorner = Instance.new("UICorner")
		successCorner.CornerRadius = UDim.new(0, 12)
		successCorner.Parent = successFrame

		-- Icon based on plant type
		local plantIcons = {
			Tomato = "🍅",
			Carrot = "🥕", 
			Wheat = "🌾",
			Corn = "🌽",
			Potato = "🥔"
		}

		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(0.3, 0, 0.6, 0)
		icon.Position = UDim2.new(0.05, 0, 0.2, 0)
		icon.BackgroundTransparency = 1
		icon.Text = plantIcons[harvestData.items.type] or "🌱"
		icon.TextScaled = true
		icon.Parent = successFrame

		local successLabel = Instance.new("TextLabel")
		successLabel.Size = UDim2.new(0.6, 0, 1, 0)
		successLabel.Position = UDim2.new(0.35, 0, 0, 0)
		successLabel.BackgroundTransparency = 1
		successLabel.Text = "✨ Harvested!\n" .. harvestData.items.quantity .. " " .. harvestData.items.type
		successLabel.TextColor3 = Color3.new(1, 1, 1)
		successLabel.TextScaled = true
		successLabel.Font = Enum.Font.SourceSansBold
		successLabel.Parent = successFrame

		-- Entrance animation: slide down from top with bounce
		successFrame.Position = UDim2.new(0.5, -100, -0.2, 0)
		successFrame.Size = UDim2.new(0, 0, 0, 0)

		local tweenInfo1 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local entranceTween = TweenService:Create(successFrame, tweenInfo1, {
			Position = UDim2.new(0.5, -100, 0.3, 0),
			Size = UDim2.new(0.25, 0, 0.12, 0)
		})
		entranceTween:Play()

		-- Glow pulse animation
		local glowTween = TweenService:Create(stroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Transparency = 0.7
		})
		glowTween:Play()

		-- Exit animation after 2.5 seconds: fade out and slide up
		wait(2.5)

		local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		local exitTween = TweenService:Create(successFrame, tweenInfo2, {
			Position = UDim2.new(0.5, -100, -0.15, 0),
			BackgroundTransparency = 1
		})

		local fadeTextTween = TweenService:Create(successLabel, tweenInfo2, {
			TextTransparency = 1
		})

		local fadeIconTween = TweenService:Create(icon, tweenInfo2, {
			TextTransparency = 1
		})

		local fadeStrokeTween = TweenService:Create(stroke, tweenInfo2, {
			Transparency = 1
		})

		exitTween:Play()
		fadeTextTween:Play()
		fadeIconTween:Play()
		fadeStrokeTween:Play()
		glowTween:Cancel()

		exitTween.Completed:Connect(function()
			successGui:Destroy()
		end)

		-- Update inventory if it's open
		if isInventoryOpen then
			wait(0.1) -- Small delay to ensure server has updated values
			updateInventoryDisplay()
		end
	end
end)

-- Handle inventory updates
updateInventory.OnClientEvent:Connect(function()
	if isInventoryOpen then
		updateInventoryDisplay()
	end
end)

-- Handle player respawning
player.CharacterAdded:Connect(function()
	print("Player respawned, recreating inventory UI...")
	wait(1) -- Small delay to ensure PlayerGui is ready

	-- Recreate the inventory button (GUI persists but we ensure it exists)
	if not getPlayerGui():FindFirstChild("InventoryButton") then
		createInventoryButton()
	end

	-- Recreate inventory GUI if it doesn't exist
	if not getPlayerGui():FindFirstChild("InventoryGui") then
		createInventoryGui()
	end
end)

-- Initial setup
createInventoryButton()

-- Keyboard shortcut (E key) to toggle inventory
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.E then
		toggleInventory()
	end
end)