-- -- SEED INVENTORY - FINAL VERSION
-- -- PUT THIS IN StarterPlayer > StarterPlayerScripts
-- -- NAME IT: "SeedInventory" (different from "Planting")

-- local Players = game:GetService("Players")
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local TweenService = game:GetService("TweenService")
-- local UserInputService = game:GetService("UserInputService")
-- local Debris = game:GetService("Debris")

-- local player = Players.LocalPlayer
-- local playerGui = player:WaitForChild("PlayerGui")

-- print("🌱 SEED INVENTORY: Starting...")

-- -- Wait for RemoteEvent with safety
-- local seedInventoryEven
-- for i = 1, 50 do -- Try for 5 seconds
-- 	seedInventoryEvent = ReplicatedStorage:FindFirstChild("SeedInventoryEvent")
-- 	if seedInventoryEvent then break end
-- 	task.wait(0.1)
-- end

-- if not seedInventoryEvent then
-- 	warn("❌ SEED INVENTORY: SeedInventoryEvent not found after 5 seconds!")
-- 	return
-- else
-- 	print("✅ SEED INVENTORY: SeedInventoryEvent found!")
-- end

-- -- Variables
-- local inventoryGui = nil
-- local isInventoryOpen = false

-- -- Seed types that can be converted
-- local convertibleSeeds = {"Carrot", "Potato", "Tomato", "Wheat", "Corn"}

-- -- Function to get player's seed counts
-- local function getSeedCounts()
-- 	local leaderstats = player:FindFirstChild("leaderstats")
-- 	if not leaderstats then 
-- 		print("🌱 No leaderstats found")
-- 		return {} 
-- 	end

-- 	local seedCounts = {}
-- 	local totalSeeds = 0
-- 	for _, seedType in pairs(convertibleSeeds) do
-- 		local seedStat = leaderstats:FindFirstChild(seedType .. "_Seeds")
-- 		if seedStat then
-- 			seedCounts[seedType] = seedStat.Value
-- 			totalSeeds = totalSeeds + seedStat.Value
-- 		else
-- 			seedCounts[seedType] = 0
-- 		end
-- 	end

-- 	print("🌱 Total seeds available:", totalSeeds)
-- 	return seedCounts
-- end

-- -- Function to create inventory GUI
-- local function createInventoryGui()
-- 	print("🌱 Creating inventory GUI...")

-- 	-- Remove old GUI if it exists
-- 	local oldGui = playerGui:FindFirstChild("SeedInventoryGui")
-- 	if oldGui then
-- 		oldGui:Destroy()
-- 		print("🌱 Removed old GUI")
-- 	end

-- 	-- Create main ScreenGui
-- 	inventoryGui = Instance.new("ScreenGui")
-- 	inventoryGui.Name = "SeedInventoryGui"
-- 	inventoryGui.ResetOnSpawn = false
-- 	inventoryGui.Parent = playerGui

-- 	-- Main frame
-- 	local mainFrame = Instance.new("Frame")
-- 	mainFrame.Name = "MainFrame"
-- 	mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
-- 	mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
-- 	mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
-- 	mainFrame.BorderSizePixel = 0
-- 	mainFrame.Visible = false
-- 	mainFrame.Parent = inventoryGui

-- 	-- Corner rounding
-- 	local corner = Instance.new("UICorner")
-- 	corner.CornerRadius = UDim.new(0, 12)
-- 	corner.Parent = mainFrame

-- 	-- Title
-- 	local title = Instance.new("TextLabel")
-- 	title.Name = "Title"
-- 	title.Size = UDim2.new(1, 0, 0.15, 0)
-- 	title.Position = UDim2.new(0, 0, 0, 0)
-- 	title.BackgroundTransparency = 1
-- 	title.Text = "🌱 SEED INVENTORY"
-- 	title.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	title.TextScaled = true
-- 	title.Font = Enum.Font.GothamBold
-- 	title.Parent = mainFrame

-- 	-- Subtitle
-- 	local subtitle = Instance.new("TextLabel")
-- 	subtitle.Size = UDim2.new(1, 0, 0.08, 0)
-- 	subtitle.Position = UDim2.new(0, 0, 0.15, 0)
-- 	subtitle.BackgroundTransparency = 1
-- 	subtitle.Text = "Click to convert seeds to plantable items"
-- 	subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
-- 	subtitle.TextScaled = true
-- 	subtitle.Font = Enum.Font.Gotham
-- 	subtitle.Parent = mainFrame

-- 	-- Close button
-- 	local closeButton = Instance.new("TextButton")
-- 	closeButton.Name = "CloseButton"
-- 	closeButton.Size = UDim2.new(0.08, 0, 0.08, 0)
-- 	closeButton.Position = UDim2.new(0.9, 0, 0.02, 0)
-- 	closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
-- 	closeButton.Text = "✕"
-- 	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	closeButton.TextScaled = true
-- 	closeButton.Font = Enum.Font.GothamBold
-- 	closeButton.Parent = mainFrame

-- 	local closeCorner = Instance.new("UICorner")
-- 	closeCorner.CornerRadius = UDim.new(0, 8)
-- 	closeCorner.Parent = closeButton

-- 	-- Scroll frame for seeds
-- 	local scrollFrame = Instance.new("ScrollingFrame")
-- 	scrollFrame.Name = "SeedScrollFrame"
-- 	scrollFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
-- 	scrollFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
-- 	scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
-- 	scrollFrame.BorderSizePixel = 0
-- 	scrollFrame.ScrollBarThickness = 8
-- 	scrollFrame.Parent = mainFrame

-- 	local scrollCorner = Instance.new("UICorner")
-- 	scrollCorner.CornerRadius = UDim.new(0, 8)
-- 	scrollCorner.Parent = scrollFrame

-- 	-- Layout for scroll frame
-- 	local listLayout = Instance.new("UIListLayout")
-- 	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
-- 	listLayout.Padding = UDim.new(0, 5)
-- 	listLayout.Parent = scrollFrame

-- 	local padding = Instance.new("UIPadding")
-- 	padding.PaddingTop = UDim.new(0, 5)
-- 	padding.PaddingLeft = UDim.new(0, 5)
-- 	padding.PaddingRight = UDim.new(0, 5)
-- 	padding.PaddingBottom = UDim.new(0, 5)
-- 	padding.Parent = scrollFrame

-- 	-- Close button functionality - FIXED
-- 	closeButton.MouseButton1Click:Connect(function()
-- 		print("🌱 Close button clicked")
-- 		-- Force close without checking isInventoryOpen
-- 		if inventoryGui and inventoryGui.MainFrame then
-- 			local mainFrame = inventoryGui.MainFrame
-- 			if mainFrame.Visible then
-- 				print("🌱 Closing inventory via close button...")
-- 				local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
-- 					Size = UDim2.new(0, 0, 0, 0)
-- 				})
-- 				closeTween:Play()
-- 				closeTween.Completed:Connect(function()
-- 					mainFrame.Visible = false
-- 					isInventoryOpen = false
-- 					print("✅ SEED INVENTORY: Closed via close button!")
-- 				end)
-- 			end
-- 		end
-- 	end)

-- 	print("✅ SEED INVENTORY: GUI created successfully!")
-- 	return inventoryGui
-- end

-- -- Function to create seed item in inventory
-- local function createSeedInventoryItem(seedType, count, parent)
-- 	local icons = {
-- 		Carrot = "🥕",
-- 		Potato = "🥔", 
-- 		Tomato = "🍅",
-- 		Wheat = "🌾",
-- 		Corn = "🌽"
-- 	}

-- 	local itemFrame = Instance.new("Frame")
-- 	itemFrame.Name = seedType .. "_Item"
-- 	itemFrame.Size = UDim2.new(1, -10, 0, 70)
-- 	itemFrame.BackgroundColor3 = count > 0 and Color3.fromRGB(50, 55, 60) or Color3.fromRGB(35, 35, 40)
-- 	itemFrame.Parent = parent

-- 	local itemCorner = Instance.new("UICorner")
-- 	itemCorner.CornerRadius = UDim.new(0, 8)
-- 	itemCorner.Parent = itemFrame

-- 	-- Icon
-- 	local icon = Instance.new("TextLabel")
-- 	icon.Size = UDim2.new(0, 50, 0, 50)
-- 	icon.Position = UDim2.new(0, 10, 0, 10)
-- 	icon.BackgroundTransparency = 1
-- 	icon.Text = icons[seedType] or "🌱"
-- 	icon.TextScaled = true
-- 	icon.Parent = itemFrame

-- 	-- Name
-- 	local nameLabel = Instance.new("TextLabel")
-- 	nameLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
-- 	nameLabel.Position = UDim2.new(0.2, 0, 0, 0)
-- 	nameLabel.BackgroundTransparency = 1
-- 	nameLabel.Text = seedType .. " Seeds"
-- 	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	nameLabel.TextScaled = true
-- 	nameLabel.Font = Enum.Font.GothamBold
-- 	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
-- 	nameLabel.Parent = itemFrame

-- 	-- Count
-- 	local countLabel = Instance.new("TextLabel")
-- 	countLabel.Name = "CountLabel"
-- 	countLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
-- 	countLabel.Position = UDim2.new(0.2, 0, 0.4, 0)
-- 	countLabel.BackgroundTransparency = 1
-- 	countLabel.Text = "Available: " .. count
-- 	countLabel.TextColor3 = count > 0 and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(150, 150, 150)
-- 	countLabel.TextScaled = true
-- 	countLabel.Font = Enum.Font.Gotham
-- 	countLabel.TextXAlignment = Enum.TextXAlignment.Left
-- 	countLabel.Parent = itemFrame

-- 	-- Convert buttons
-- 	local buttonFrame = Instance.new("Frame")
-- 	buttonFrame.Size = UDim2.new(0.3, 0, 1, 0)
-- 	buttonFrame.Position = UDim2.new(0.7, 0, 0, 0)
-- 	buttonFrame.BackgroundTransparency = 1
-- 	buttonFrame.Parent = itemFrame

-- 	local buttonLayout = Instance.new("UIListLayout")
-- 	buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
-- 	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
-- 	buttonLayout.Padding = UDim.new(0, 5)
-- 	buttonLayout.Parent = buttonFrame

-- 	-- Convert 1 button
-- 	local convert1Button = Instance.new("TextButton")
-- 	convert1Button.Name = "Convert1"
-- 	convert1Button.Size = UDim2.new(0.45, 0, 0.7, 0)
-- 	convert1Button.BackgroundColor3 = count > 0 and Color3.fromRGB(70, 130, 70) or Color3.fromRGB(60, 60, 60)
-- 	convert1Button.Text = "1"
-- 	convert1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	convert1Button.TextScaled = true
-- 	convert1Button.Font = Enum.Font.GothamBold
-- 	convert1Button.Parent = buttonFrame

-- 	local button1Corner = Instance.new("UICorner")
-- 	button1Corner.CornerRadius = UDim.new(0, 6)
-- 	button1Corner.Parent = convert1Button

-- 	-- Convert All button
-- 	local convertAllButton = Instance.new("TextButton")
-- 	convertAllButton.Name = "ConvertAll"
-- 	convertAllButton.Size = UDim2.new(0.45, 0, 0.7, 0)
-- 	convertAllButton.BackgroundColor3 = count > 0 and Color3.fromRGB(50, 100, 150) or Color3.fromRGB(60, 60, 60)
-- 	convertAllButton.Text = "ALL"
-- 	convertAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	convertAllButton.TextScaled = true
-- 	convertAllButton.Font = Enum.Font.GothamBold
-- 	convertAllButton.Parent = buttonFrame

-- 	local buttonAllCorner = Instance.new("UICorner")
-- 	buttonAllCorner.CornerRadius = UDim.new(0, 6)
-- 	buttonAllCorner.Parent = convertAllButton

-- 	-- Button functionality
-- 	if count > 0 then
-- 		convert1Button.MouseButton1Click:Connect(function()
-- 			print("🌱 Converting 1", seedType, "seed")
-- 			convert1Button.Text = "..."
-- 			seedInventoryEvent:FireServer("ConvertSeeds", seedType, 1)
-- 		end)

-- 		convertAllButton.MouseButton1Click:Connect(function()
-- 			print("🌱 Converting ALL", seedType, "seeds")
-- 			convertAllButton.Text = "..."
-- 			seedInventoryEvent:FireServer("ConvertSeeds", seedType, count)
-- 		end)
-- 	end

-- 	return itemFrame
-- end

-- -- Function to update inventory display
-- local function updateInventory()
-- 	if not inventoryGui or not inventoryGui.MainFrame.SeedScrollFrame then 
-- 		print("🌱 Cannot update inventory - GUI not ready")
-- 		return 
-- 	end

-- 	print("🌱 Updating inventory...")
-- 	local scrollFrame = inventoryGui.MainFrame.SeedScrollFrame
-- 	local seedCounts = getSeedCounts()

-- 	-- Clear existing items
-- 	for _, child in pairs(scrollFrame:GetChildren()) do
-- 		if child:IsA("Frame") then
-- 			child:Destroy()
-- 		end
-- 	end

-- 	-- Create items for each seed type
-- 	for _, seedType in pairs(convertibleSeeds) do
-- 		local count = seedCounts[seedType] or 0
-- 		print("🌱 Creating item for", seedType, "with count", count)
-- 		createSeedInventoryItem(seedType, count, scrollFrame)
-- 	end

-- 	-- Update canvas size
-- 	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIListLayout.AbsoluteContentSize.Y + 10)
-- 	print("✅ SEED INVENTORY: Updated!")
-- end

-- -- Function to open inventory
-- local function openInventory()
-- 	print("🌱 OPENING INVENTORY...")

-- 	if not inventoryGui then
-- 		inventoryGui = createInventoryGui()
-- 	end

-- 	updateInventory()

-- 	local mainFrame = inventoryGui.MainFrame
-- 	mainFrame.Visible = true
-- 	mainFrame.Size = UDim2.new(0, 0, 0, 0)

-- 	local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
-- 		Size = UDim2.new(0.4, 0, 0.6, 0)
-- 	})
-- 	openTween:Play()

-- 	isInventoryOpen = true
-- 	print("✅ SEED INVENTORY: OPENED!")
-- end

-- -- Function to close inventory - IMPROVED
-- local function closeInventory()
-- 	if not inventoryGui or not inventoryGui.MainFrame then 
-- 		print("🌱 No inventory to close")
-- 		return 
-- 	end

-- 	-- Check if it's actually visible before trying to close
-- 	if not inventoryGui.MainFrame.Visible then
-- 		print("🌱 Inventory already closed")
-- 		isInventoryOpen = false
-- 		return 
-- 	end

-- 	print("🌱 Closing inventory...")
-- 	local mainFrame = inventoryGui.MainFrame
-- 	local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
-- 		Size = UDim2.new(0, 0, 0, 0)
-- 	})

-- 	closeTween:Play()
-- 	closeTween.Completed:Connect(function()
-- 		mainFrame.Visible = false
-- 		isInventoryOpen = false
-- 		print("✅ SEED INVENTORY: Closed!")
-- 	end)
-- end

-- -- Function to show notification
-- local function showNotification(message, isSuccess, duration)
-- 	duration = duration or 2.5

-- 	local notification = Instance.new("Frame")
-- 	notification.Size = UDim2.new(0.3, 0, 0.08, 0)
-- 	notification.Position = UDim2.new(0.35, 0, -0.1, 0)
-- 	notification.BackgroundColor3 = isSuccess and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
-- 	notification.Parent = playerGui

-- 	local notifCorner = Instance.new("UICorner")
-- 	notifCorner.CornerRadius = UDim.new(0, 8)
-- 	notifCorner.Parent = notification

-- 	local notifText = Instance.new("TextLabel")
-- 	notifText.Size = UDim2.new(1, 0, 1, 0)
-- 	notifText.BackgroundTransparency = 1
-- 	notifText.Text = message
-- 	notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	notifText.TextScaled = true
-- 	notifText.Font = Enum.Font.GothamBold
-- 	notifText.Parent = notification

-- 	-- Animate in
-- 	local slideIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
-- 		Position = UDim2.new(0.35, 0, 0.02, 0)
-- 	})
-- 	slideIn:Play()

-- 	-- Remove after delay
-- 	Debris:AddItem(notification, duration)
-- end

-- -- Handle server events
-- seedInventoryEvent.OnClientEvent:Connect(function(action, ...)
-- 	local args = {...}
-- 	print("🌱 Received event:", action)

-- 	if action == "ConvertResult" then
-- 		local success, message = args[1], args[2]

-- 		showNotification(message, success, 3)

-- 		if isInventoryOpen then
-- 			updateInventory()
-- 		end

-- 		-- Reset button texts
-- 		if inventoryGui and inventoryGui.MainFrame and inventoryGui.MainFrame.SeedScrollFrame then
-- 			for _, item in pairs(inventoryGui.MainFrame.SeedScrollFrame:GetChildren()) do
-- 				if item:IsA("Frame") then
-- 					local convert1 = item:FindFirstChild("Convert1")
-- 					local convertAll = item:FindFirstChild("ConvertAll")
-- 					if convert1 then convert1.Text = "1" end
-- 					if convertAll then convertAll.Text = "ALL" end
-- 				end
-- 			end
-- 		end

-- 	elseif action == "UpdateSeeds" then
-- 		local seedType, newCount = args[1], args[2]
-- 		if isInventoryOpen then
-- 			updateInventory()
-- 		end

-- 	elseif action == "PlantResult" then
-- 		local success, message = args[1], args[2]
-- 		showNotification(message, success, 2)
-- 	end
-- end)

-- -- Keyboard shortcuts (FIXED - Using non-Studio keys)
-- UserInputService.InputBegan:Connect(function(input, processed)
-- 	if processed then return end

-- 	-- Use X key for inventory (X = Seed Inventory)
-- 	if input.KeyCode == Enum.KeyCode.X then
-- 		print("🌱 X KEY PRESSED! Current state:", isInventoryOpen and "OPEN" or "CLOSED")
-- 		if isInventoryOpen then
-- 			closeInventory()
-- 		else
-- 			openInventory()
-- 		end
-- 	end

-- 	if input.KeyCode == Enum.KeyCode.Escape and isInventoryOpen then
-- 		closeInventory()
-- 	end
-- end)

-- print("✅ SEED INVENTORY: Loaded! Press X to open inventory")
-- print("🌱 SEED INVENTORY: Ready for testing!")
-- print("🎮 CONTROLS:")
-- print("  - X = Open/Close Inventory")