-- SEED SHOP CLIENT SCRIPT
-- PUT THIS IN StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvent
local seedShopEvent = ReplicatedStorage:WaitForChild("SeedShopEvent")

-- Variables
local shopGui = nil
local isShopOpen = false

-- Function to get or create shop GUI
local function getShopGui()
	if shopGui and shopGui.Parent then
		return shopGui
	end

	-- Remove old GUI if it exists
	local oldGui = playerGui:FindFirstChild("SeedShopGui")
	if oldGui then
		oldGui:Destroy()
	end

	-- Create main ScreenGui
	shopGui = Instance.new("ScreenGui")
	shopGui.Name = "SeedShopGui"
	shopGui.ResetOnSpawn = false
	shopGui.Parent = playerGui

	-- Main frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
	mainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
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
	title.Size = UDim2.new(1, 0, 0.15, 0)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "🌱 SEED SHOP 🌱"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = mainFrame

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0.08, 0, 0.08, 0)
	closeButton.Position = UDim2.new(0.9, 0, 0.02, 0)
	closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	closeButton.Text = "✕"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = mainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton

	-- Coins display
	local coinsFrame = Instance.new("Frame")
	coinsFrame.Name = "CoinsFrame"
	coinsFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
	coinsFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
	coinsFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
	coinsFrame.Parent = mainFrame

	local coinsCorner = Instance.new("UICorner")
	coinsCorner.CornerRadius = UDim.new(0, 8)
	coinsCorner.Parent = coinsFrame

	local coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, 0, 1, 0)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.Text = "💰 Coins: 0"
	coinsLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	coinsLabel.TextScaled = true
	coinsLabel.Font = Enum.Font.GothamBold
	coinsLabel.Parent = coinsFrame

	-- Scroll frame for seeds
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "SeedScrollFrame"
	scrollFrame.Size = UDim2.new(0.9, 0, 0.65, 0)
	scrollFrame.Position = UDim2.new(0.05, 0, 0.28, 0)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.Parent = mainFrame

	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 8)
	scrollCorner.Parent = scrollFrame

	-- Layout for scroll frame
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = scrollFrame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.Parent = scrollFrame

	-- Close button functionality
	closeButton.MouseButton1Click:Connect(function()
		closeShop()
	end)

	return shopGui
end

-- Function to create seed item
local function createSeedItem(seedType, seedData, parent)
	local itemFrame = Instance.new("Frame")
	itemFrame.Name = seedType .. "_Item"
	itemFrame.Size = UDim2.new(1, -10, 0, 80)
	itemFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
	itemFrame.Parent = parent

	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 8)
	itemCorner.Parent = itemFrame

	-- Icon
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 60, 0, 60)
	icon.Position = UDim2.new(0, 10, 0, 10)
	icon.BackgroundTransparency = 1
	icon.Text = seedData.icon
	icon.TextScaled = true
	icon.Parent = itemFrame

	-- Name and description
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
	nameLabel.Position = UDim2.new(0.2, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = seedData.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = itemFrame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(0.4, 0, 0.3, 0)
	descLabel.Position = UDim2.new(0.2, 0, 0.4, 0)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = seedData.description .. " (" .. seedData.seedsPerPack .. " seeds)"
	descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	descLabel.TextScaled = true
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = itemFrame

	-- Owned amount
	local ownedLabel = Instance.new("TextLabel")
	ownedLabel.Name = "OwnedLabel"
	ownedLabel.Size = UDim2.new(0.15, 0, 0.3, 0)
	ownedLabel.Position = UDim2.new(0.6, 0, 0.1, 0)
	ownedLabel.BackgroundTransparency = 1
	ownedLabel.Text = "Owned: " .. seedData.owned
	ownedLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
	ownedLabel.TextScaled = true
	ownedLabel.Font = Enum.Font.Gotham
	ownedLabel.Parent = itemFrame

	-- Price and buy button
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0.15, 0, 0.4, 0)
	priceLabel.Position = UDim2.new(0.6, 0, 0.45, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = "💰 " .. seedData.price
	priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	priceLabel.TextScaled = true
	priceLabel.Font = Enum.Font.GothamBold
	priceLabel.Parent = itemFrame

	local buyButton = Instance.new("TextButton")
	buyButton.Name = "BuyButton"
	buyButton.Size = UDim2.new(0.15, 0, 0.6, 0)
	buyButton.Position = UDim2.new(0.8, 0, 0.2, 0)
	buyButton.BackgroundColor3 = seedData.canAfford and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(100, 100, 100)
	buyButton.Text = "BUY"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.TextScaled = true
	buyButton.Font = Enum.Font.GothamBold
	buyButton.Parent = itemFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = buyButton

	-- Buy button functionality
	if seedData.canAfford then
		buyButton.MouseButton1Click:Connect(function()
			buyButton.Text = "..."
			seedShopEvent:FireServer("PurchaseSeeds", seedType)
		end)
	end

	return itemFrame
end

-- Function to open shop
local function openShop(shopData, playerCoins)
	local gui = getShopGui()
	local mainFrame = gui.MainFrame
	local coinsLabel = mainFrame.CoinsFrame.CoinsLabel
	local scrollFrame = mainFrame.SeedScrollFrame

	-- Update coins display
	coinsLabel.Text = "💰 Coins: " .. playerCoins

	-- Clear existing items
	for _, child in pairs(scrollFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	-- Create seed items
	for seedType, seedData in pairs(shopData) do
		createSeedItem(seedType, seedData, scrollFrame)
	end

	-- Update canvas size
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIListLayout.AbsoluteContentSize.Y + 10)

	-- Show GUI with animation
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0, 0, 0, 0)

	local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0.5, 0, 0.7, 0)
	})
	openTween:Play()

	isShopOpen = true
end

-- Function to close shop
function closeShop()
	if not isShopOpen or not shopGui then return end

	local mainFrame = shopGui.MainFrame
	local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0)
	})

	closeTween:Play()
	closeTween.Completed:Connect(function()
		mainFrame.Visible = false
		isShopOpen = false
	end)
end

-- Handle server events
seedShopEvent.OnClientEvent:Connect(function(action, ...)
	local args = {...}

	if action == "OpenShop" then
		local shopData, playerCoins = args[1], args[2]
		openShop(shopData, playerCoins)

	elseif action == "PurchaseResult" then
		local success, message, seedType = args[1], args[2], args[3]

		-- Show notification
		local gui = getShopGui()
		local notification = Instance.new("Frame")
		notification.Size = UDim2.new(0.3, 0, 0.1, 0)
		notification.Position = UDim2.new(0.35, 0, -0.15, 0)
		notification.BackgroundColor3 = success and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
		notification.Parent = gui

		local notifCorner = Instance.new("UICorner")
		notifCorner.CornerRadius = UDim.new(0, 8)
		notifCorner.Parent = notification

		local notifText = Instance.new("TextLabel")
		notifText.Size = UDim2.new(1, 0, 1, 0)
		notifText.BackgroundTransparency = 1
		notifText.Text = message
		notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifText.TextScaled = true
		notifText.Font = Enum.Font.GothamBold
		notifText.Parent = notification

		-- Animate notification
		local slideTween = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.35, 0, 0.02, 0)
		})
		slideTween:Play()

		-- Remove after delay
		wait(2)
		local fadeOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.35, 0, -0.15, 0)
		})
		fadeOut:Play()
		fadeOut.Completed:Connect(function()
			notification:Destroy()
		end)

		-- Reset buy button
		if shopGui and shopGui.MainFrame.SeedScrollFrame:FindFirstChild(seedType .. "_Item") then
			local buyButton = shopGui.MainFrame.SeedScrollFrame[seedType .. "_Item"].BuyButton
			buyButton.Text = "BUY"
		end

	elseif action == "UpdateData" then
		local newCoins, seedType, newSeedCount = args[1], args[2], args[3]

		if shopGui and isShopOpen then
			-- Update coins display
			shopGui.MainFrame.CoinsFrame.CoinsLabel.Text = "💰 Coins: " .. newCoins

			-- Update owned count
			local seedItem = shopGui.MainFrame.SeedScrollFrame:FindFirstChild(seedType .. "_Item")
			if seedItem then
				seedItem.OwnedLabel.Text = "Owned: " .. newSeedCount
			end
		end
	end
end)

-- Close shop on ESC key
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.Escape and isShopOpen then
		closeShop()
	end
end)

print("Seed Shop UI loaded!")

function closeShop()
	if not isShopOpen or not shopGui then return end

	local mainFrame = shopGui.MainFrame
	local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0)
	})

	closeTween:Play()
	closeTween.Completed:Connect(function()
		mainFrame.Visible = false
	end)

	isShopOpen = false
end
