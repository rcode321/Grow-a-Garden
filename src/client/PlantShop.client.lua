-- SHOP CLIENT SCRIPT
-- ADD THIS TO YOUR EXISTING INVENTORY SCRIPT IN StarterPlayerScripts
-- OR CREATE A NEW LOCALSCRIPT IN StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Wait for RemoteEvents
local openShop = ReplicatedStorage:WaitForChild("OpenShop")
local sellPlant = ReplicatedStorage:WaitForChild("SellPlant")

-- Variables
local shopGui = nil
local isShopOpen = false

-- Function to get current PlayerGui
local function getPlayerGui()
	return player:WaitForChild("PlayerGui")
end

-- Function to create shop GUI
local function createShopGui(playerInventory, plantPrices)
	local playerGui = getPlayerGui()

	-- Remove old shop GUI if it exists
	local oldGui = playerGui:FindFirstChild("ShopGui")
	if oldGui then
		oldGui:Destroy()
	end

	-- Main ScreenGui
	shopGui = Instance.new("ScreenGui")
	shopGui.Name = "ShopGui"
	shopGui.ResetOnSpawn = false
	shopGui.Parent = playerGui

	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
	mainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
	mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = shopGui

	-- Corner rounding
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0.7, 0, 0.1, 0)
	title.Position = UDim2.new(0.05, 0, 0.02, 0)
	title.BackgroundTransparency = 1
	title.Text = "🏪 PLANT SHOP"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 32
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

	-- Coins display
	local coinsFrame = Instance.new("Frame")
	coinsFrame.Name = "CoinsFrame"
	coinsFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
	coinsFrame.Position = UDim2.new(0.05, 0, 0.13, 0)
	coinsFrame.BackgroundColor3 = Color3.new(1, 0.8, 0)
	coinsFrame.Parent = mainFrame

	local coinsCorner = Instance.new("UICorner")
	coinsCorner.CornerRadius = UDim.new(0, 8)
	coinsCorner.Parent = coinsFrame

	local coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, 0, 1, 0)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.Text = "💰 Your Coins: " .. (player.leaderstats and player.leaderstats.Coins.Value or 0)
	coinsLabel.TextColor3 = Color3.new(0, 0, 0)
	coinsLabel.TextSize = 18
	coinsLabel.Font = Enum.Font.SourceSansBold
	coinsLabel.Parent = coinsFrame

	-- Shop items scroll frame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ItemsScroll"
	scrollFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
	scrollFrame.Position = UDim2.new(0.05, 0, 0.23, 0)
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

	-- Plant icons
	local plantIcons = {
		Plant = "🌱",
		Tomato = "🍅",
		Carrot = "🥕",
		Wheat = "🌾",
		Corn = "🌽",
		Potato = "🥔"
	}

	-- Create shop items
	for plantType, quantity in pairs(playerInventory) do
		if quantity > 0 and plantPrices[plantType] then
			-- Create item frame
			local itemFrame = Instance.new("Frame")
			itemFrame.Name = plantType .. "Frame"
			itemFrame.Size = UDim2.new(1, -10, 0, 60)
			itemFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			itemFrame.Parent = scrollFrame

			local itemCorner = Instance.new("UICorner")
			itemCorner.CornerRadius = UDim.new(0, 6)
			itemCorner.Parent = itemFrame

			-- Plant icon
			local itemIcon = Instance.new("TextLabel")
			itemIcon.Size = UDim2.new(0.1, 0, 1, 0)
			itemIcon.BackgroundTransparency = 1
			itemIcon.Text = plantIcons[plantType] or "🌱"
			itemIcon.TextScaled = true
			itemIcon.Parent = itemFrame

			-- Plant info
			local itemInfo = Instance.new("TextLabel")
			itemInfo.Size = UDim2.new(0.5, 0, 1, 0)
			itemInfo.Position = UDim2.new(0.1, 0, 0, 0)
			itemInfo.BackgroundTransparency = 1
			itemInfo.Text = plantType .. "\nYou have: " .. quantity .. "\nPrice: " .. plantPrices[plantType] .. " coins each"
			itemInfo.TextColor3 = Color3.new(1, 1, 1)
			itemInfo.TextXAlignment = Enum.TextXAlignment.Left
			itemInfo.TextSize = 14
			itemInfo.Font = Enum.Font.SourceSans
			itemInfo.Parent = itemFrame

			-- Sell button
			local sellButton = Instance.new("TextButton")
			sellButton.Size = UDim2.new(0.15, 0, 0.7, 0)
			sellButton.Position = UDim2.new(0.82, 0, 0.15, 0)
			sellButton.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
			sellButton.Text = "Sell 1"
			sellButton.TextColor3 = Color3.new(1, 1, 1)
			sellButton.TextScaled = true
			sellButton.Font = Enum.Font.SourceSansBold
			sellButton.Parent = itemFrame

			local sellCorner = Instance.new("UICorner")
			sellCorner.CornerRadius = UDim.new(0, 4)
			sellCorner.Parent = sellButton

			-- Sell All button
			local sellAllButton = Instance.new("TextButton")
			sellAllButton.Size = UDim2.new(0.15, 0, 0.7, 0)
			sellAllButton.Position = UDim2.new(0.65, 0, 0.15, 0)
			sellAllButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.8)
			sellAllButton.Text = "Sell All"
			sellAllButton.TextColor3 = Color3.new(1, 1, 1)
			sellAllButton.TextScaled = true
			sellAllButton.Font = Enum.Font.SourceSansBold
			sellAllButton.Parent = itemFrame

			local sellAllCorner = Instance.new("UICorner")
			sellAllCorner.CornerRadius = UDim.new(0, 4)
			sellAllCorner.Parent = sellAllButton

			-- Button functionality
			sellButton.MouseButton1Click:Connect(function()
				sellPlant:FireServer(plantType, 1)
			end)

			sellAllButton.MouseButton1Click:Connect(function()
				sellPlant:FireServer(plantType, quantity)
			end)
		end
	end

	-- Update scroll canvas size
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)

	-- Close button functionality
	closeButton.MouseButton1Click:Connect(function()
		closeShop()
	end)

	return mainFrame
end

-- Function to open shop
local function openShopGui(playerInventory, plantPrices)
	if isShopOpen then
		closeShop()
		return
	end

	local mainFrame = createShopGui(playerInventory, plantPrices)
	isShopOpen = true

	-- Animate shop opening
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(mainFrame, tweenInfo, {
		Size = UDim2.new(0.5, 0, 0.7, 0),
		Position = UDim2.new(0.25, 0, 0.15, 0)
	})
	tween:Play()
end

-- Function to close shop
function closeShop()
	if not shopGui or not isShopOpen then return end

	local mainFrame = shopGui.MainFrame
	isShopOpen = false

	-- Animate shop closing
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

-- Handle shop opening from server
openShop.OnClientEvent:Connect(function(playerInventory, plantPrices)
	openShopGui(playerInventory, plantPrices)
end)

-- Handle sell results
sellPlant.OnClientEvent:Connect(function(success, message)
	-- Create notification
	local playerGui = getPlayerGui()
	local notificationGui = Instance.new("ScreenGui")
	notificationGui.Name = "SellNotification"
	notificationGui.Parent = playerGui

	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0.3, 0, 0.1, 0)
	notification.Position = UDim2.new(0.35, 0, 0.05, 0)
	notification.BackgroundColor3 = success and Color3.new(0.2, 0.7, 0.2) or Color3.new(0.7, 0.2, 0.2)
	notification.Parent = notificationGui

	local notificationCorner = Instance.new("UICorner")
	notificationCorner.CornerRadius = UDim.new(0, 8)
	notificationCorner.Parent = notification

	local notificationLabel = Instance.new("TextLabel")
	notificationLabel.Size = UDim2.new(1, 0, 1, 0)
	notificationLabel.BackgroundTransparency = 1
	notificationLabel.Text = message
	notificationLabel.TextColor3 = Color3.new(1, 1, 1)
	notificationLabel.TextScaled = true
	notificationLabel.Font = Enum.Font.SourceSansBold
	notificationLabel.Parent = notification

	-- Remove notification after 3 seconds
	game:GetService("Debris"):AddItem(notificationGui, 3)
end)

print("🏪 Shop client system loaded!")
print("🏪 BREAKING BAD!!!!! SEASON 100!!!!!!!")