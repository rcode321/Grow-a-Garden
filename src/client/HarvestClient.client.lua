-- CLIENT SCRIPT: HarvestClient
-- Put this in StarterPlayerScripts
-- Handles harvest notifications and effects

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui")

-- Wait for RemoteEvent
local harvestEvent = ReplicatedStorage:WaitForChild("HarvestPlant")

print("🌾 Harvest Client loaded!")

-- Function to create harvest effect
local function createHarvestEffect(plantType, rewards)
    -- Create GUI for harvest notification
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HarvestNotification"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0, -120) -- Start above screen
    frame.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Plant type label
    local plantLabel = Instance.new("TextLabel")
    plantLabel.Size = UDim2.new(1, -20, 0, 30)
    plantLabel.Position = UDim2.new(0, 10, 0, 5)
    plantLabel.BackgroundTransparency = 1
    plantLabel.Text = "🌾 " .. plantType .. " Harvested!"
    plantLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    plantLabel.TextSize = 16
    plantLabel.Font = Enum.Font.GothamBold
    plantLabel.TextStrokeTransparency = 0
    plantLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    plantLabel.Parent = frame
    
    -- Rewards label
    local rewardLabel = Instance.new("TextLabel")
    rewardLabel.Size = UDim2.new(1, -20, 0, 25)
    rewardLabel.Position = UDim2.new(0, 10, 0, 35)
    rewardLabel.BackgroundTransparency = 1
    rewardLabel.Text = "💰 +" .. rewards.coins .. " coins"
    rewardLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    rewardLabel.TextSize = 14
    rewardLabel.Font = Enum.Font.Gotham
    rewardLabel.TextStrokeTransparency = 0
    rewardLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    rewardLabel.Parent = frame
    
    -- Experience label (if applicable)
    if rewards.experience then
        local expLabel = Instance.new("TextLabel")
        expLabel.Size = UDim2.new(1, -20, 0, 25)
        expLabel.Position = UDim2.new(0, 10, 0, 60)
        expLabel.BackgroundTransparency = 1
        expLabel.Text = "⭐ +" .. rewards.experience .. " XP"
        expLabel.TextColor3 = Color3.fromRGB(135, 206, 235)
        expLabel.TextSize = 12
        expLabel.Font = Enum.Font.Gotham
        expLabel.TextStrokeTransparency = 0
        expLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        expLabel.Parent = frame
    end
    
    -- Animate the notification
    local slideIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 20)
    })
    
    local slideOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -150, 0, -120),
        BackgroundTransparency = 1
    })
    
    -- Play animations
    slideIn:Play()
    
    -- Auto-hide after 3 seconds
    task.wait(3)
    slideOut:Play()
    slideOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Handle harvest events from server
harvestEvent.OnClientEvent:Connect(function(action, data)
    if action == "HarvestSuccess" then
        print("🌾 Harvest successful:", data.plantType)
        
        -- Create visual effect
        task.spawn(function()
            createHarvestEffect(data.plantType, data)
        end)
        
        -- Send system notification
        StarterGui:SetCore("SendNotification", {
            Title = "Harvest Complete!";
            Text = "Harvested " .. data.plantType .. " for " .. data.coins .. " coins!";
            Duration = 4;
        })
        
    elseif action == "HarvestFailed" then
        print("❌ Harvest failed:", data.reason)
        
        StarterGui:SetCore("SendNotification", {
            Title = "Harvest Failed";
            Text = data.reason or "Cannot harvest this plant";
            Duration = 3;
        })
    end
end)

print("✅ Harvest Client ready!")
print("🌾 Click on fully grown plants to harvest them!")