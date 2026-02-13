-- Fishing Script Generator UI - Landscape Dark Theme
-- Place this in StarterGui or StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishingScriptUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame (Landscape oriented)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 750, 0, 400)
mainFrame.Position = UDim2.new(0.5, -375, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Add neon glow effect
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 240, 255)
mainStroke.Thickness = 3
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- Animated glow effect
task.spawn(function()
    while mainFrame.Parent do
        TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Transparency = 0.6,
            Color = Color3.fromRGB(138, 43, 226)
        }):Play()
        wait(0.1)
    end
end)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

-- Accent line under title
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, -2)
accentLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
accentLine.BorderSizePixel = 0
accentLine.Parent = titleBar

local accentGradient = Instance.new("UIGradient")
accentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
accentGradient.Parent = accentLine

-- Title Text with icon
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎣 FISHING SCRIPT GENERATOR"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Version label
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 80, 0, 20)
versionLabel.Position = UDim2.new(1, -180, 0, 20)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.0 PRO"
versionLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
versionLabel.TextSize = 12
versionLabel.Font = Enum.Font.GothamBold
versionLabel.Parent = titleBar

-- Credit label
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(0, 300, 0, 18)
creditLabel.Position = UDim2.new(0, 20, 1, -23)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "👨‍💻 This Script Made By DevSnow"
creditLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
creditLabel.TextSize = 11
creditLabel.Font = Enum.Font.GothamMedium
creditLabel.TextXAlignment = Enum.TextXAlignment.Left
creditLabel.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 45, 0, 45)
closeButton.Position = UDim2.new(1, -55, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 40, 80)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 22
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(255, 40, 80)
closeStroke.Thickness = 2
closeStroke.Transparency = 0.5
closeStroke.Parent = closeButton

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -40, 1, -80)
contentFrame.Position = UDim2.new(0, 20, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Left Panel (Inputs)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0.55, -10, 1, 0)
leftPanel.Position = UDim2.new(0, 0, 0, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = contentFrame

-- Right Panel (Actions)
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0.45, -10, 1, 0)
rightPanel.Position = UDim2.new(0.55, 10, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = contentFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 12)
rightCorner.Parent = rightPanel

local rightStroke = Instance.new("UIStroke")
rightStroke.Color = Color3.fromRGB(138, 43, 226)
rightStroke.Thickness = 2
rightStroke.Transparency = 0.7
rightStroke.Parent = rightPanel

-- Function to create modern input field
local function createInputField(name, labelText, icon, yPosition, defaultValue, isNumber)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, 0, 0, 65)
    container.Position = UDim2.new(0, 0, 0, yPosition)
    container.BackgroundTransparency = 1
    container.Parent = leftPanel
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. labelText
    label.TextColor3 = Color3.fromRGB(150, 150, 200)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local inputBox = Instance.new("TextBox")
    inputBox.Name = name
    inputBox.Size = UDim2.new(1, 0, 0, 38)
    inputBox.Position = UDim2.new(0, 0, 0, 22)
    inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    inputBox.BorderSizePixel = 0
    inputBox.Text = tostring(defaultValue)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 15
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Enter " .. labelText:lower()
    inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputBox
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(50, 50, 70)
    inputStroke.Thickness = 2
    inputStroke.Transparency = 0.5
    inputStroke.Parent = inputBox
    
    -- Add padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = inputBox
    
    -- Focus effects with neon glow
    inputBox.Focused:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.3), {
            Transparency = 0, 
            Color = Color3.fromRGB(0, 240, 255),
            Thickness = 3
        }):Play()
        TweenService:Create(inputBox, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        }):Play()
    end)
    
    inputBox.FocusLost:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.3), {
            Transparency = 0.5, 
            Color = Color3.fromRGB(50, 50, 70),
            Thickness = 2
        }):Play()
        TweenService:Create(inputBox, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        }):Play()
    end)
    
    return inputBox
end

-- Create input fields (2x2 grid)
local sellPriceInput = createInputField("SellPrice", "Sell Price/KG", "💰", 0, 2, true)
local weightInput = createInputField("Weight", "Weight (KG)", "⚖️", 70, 3, true)
local fishNameInput = createInputField("FishName", "Fish Name", "🐟", 140, "Northern Pike", false)
local fishImageInput = createInputField("FishImage", "Image Asset ID", "🖼️", 210, "rbxassetid://17398142712", false)

-- Tips Container
local tipsContainer = Instance.new("Frame")
tipsContainer.Size = UDim2.new(1, 0, 0, 50)
tipsContainer.Position = UDim2.new(0, 0, 0, 280)
tipsContainer.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
tipsContainer.BorderSizePixel = 0
tipsContainer.Parent = leftPanel

local tipsCorner = Instance.new("UICorner")
tipsCorner.CornerRadius = UDim.new(0, 10)
tipsCorner.Parent = tipsContainer

local tipsStroke = Instance.new("UIStroke")
tipsStroke.Color = Color3.fromRGB(255, 200, 50)
tipsStroke.Thickness = 2
tipsStroke.Transparency = 0.3
tipsStroke.Parent = tipsContainer

local tipsGradient = Instance.new("UIGradient")
tipsGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0))
}
tipsGradient.Rotation = 45
tipsGradient.Parent = tipsContainer

local tipsLabel = Instance.new("TextLabel")
tipsLabel.Size = UDim2.new(1, -20, 1, 0)
tipsLabel.Position = UDim2.new(0, 10, 0, 0)
tipsLabel.BackgroundTransparency = 1
tipsLabel.Text = "💡 Tips: You must have the Rod paid with Robux first before using this!"
tipsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tipsLabel.TextSize = 12
tipsLabel.Font = Enum.Font.GothamBold
tipsLabel.TextWrapped = true
tipsLabel.TextXAlignment = Enum.TextXAlignment.Left
tipsLabel.TextYAlignment = Enum.TextYAlignment.Center
tipsLabel.Parent = tipsContainer

-- Right Panel Content
local rightPadding = Instance.new("UIPadding")
rightPadding.PaddingTop = UDim.new(0, 15)
rightPadding.PaddingBottom = UDim.new(0, 15)
rightPadding.PaddingLeft = UDim.new(0, 20)
rightPadding.PaddingRight = UDim.new(0, 20)
rightPadding.Parent = rightPanel

-- Stats Header
local statsHeader = Instance.new("TextLabel")
statsHeader.Size = UDim2.new(1, 0, 0, 25)
statsHeader.BackgroundTransparency = 1
statsHeader.Text = "⚡ QUICK STATS"
statsHeader.TextColor3 = Color3.fromRGB(0, 240, 255)
statsHeader.TextSize = 16
statsHeader.Font = Enum.Font.GothamBold
statsHeader.TextXAlignment = Enum.TextXAlignment.Left
statsHeader.Parent = rightPanel

-- Total Value Display with glow
local totalValueContainer = Instance.new("Frame")
totalValueContainer.Size = UDim2.new(1, 0, 0, 55)
totalValueContainer.Position = UDim2.new(0, 0, 0, 35)
totalValueContainer.BackgroundColor3 = Color3.fromRGB(0, 180, 150)
totalValueContainer.BorderSizePixel = 0
totalValueContainer.Parent = rightPanel

local totalCorner = Instance.new("UICorner")
totalCorner.CornerRadius = UDim.new(0, 12)
totalCorner.Parent = totalValueContainer

local totalStroke = Instance.new("UIStroke")
totalStroke.Color = Color3.fromRGB(0, 255, 200)
totalStroke.Thickness = 2
totalStroke.Transparency = 0.3
totalStroke.Parent = totalValueContainer

local totalGradient = Instance.new("UIGradient")
totalGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 120))
}
totalGradient.Rotation = 45
totalGradient.Parent = totalValueContainer

local totalValueLabel = Instance.new("TextLabel")
totalValueLabel.Size = UDim2.new(1, 0, 1, 0)
totalValueLabel.BackgroundTransparency = 1
totalValueLabel.Text = "💵 Total: $6.00"
totalValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
totalValueLabel.TextSize = 20
totalValueLabel.Font = Enum.Font.GothamBold
totalValueLabel.Parent = totalValueContainer

-- Execute Button with gradient
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(1, 0, 0, 55)
executeButton.Position = UDim2.new(0, 0, 0, 105)
executeButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
executeButton.Text = "🚀 EXECUTE SCRIPT"
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 17
executeButton.Font = Enum.Font.GothamBold
executeButton.Parent = rightPanel

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0, 12)
executeCorner.Parent = executeButton

local executeStroke = Instance.new("UIStroke")
executeStroke.Color = Color3.fromRGB(180, 100, 255)
executeStroke.Thickness = 2
executeStroke.Transparency = 0.3
executeStroke.Parent = executeButton

local executeGradient = Instance.new("UIGradient")
executeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 30, 180))
}
executeGradient.Rotation = 45
executeGradient.Parent = executeButton

-- Copy Button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(1, 0, 0, 50)
copyButton.Position = UDim2.new(0, 0, 0, 170)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
copyButton.Text = "📋 COPY TO CLIPBOARD"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 15
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = rightPanel

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 12)
copyCorner.Parent = copyButton

local copyStroke = Instance.new("UIStroke")
copyStroke.Color = Color3.fromRGB(100, 220, 255)
copyStroke.Thickness = 2
copyStroke.Transparency = 0.3
copyStroke.Parent = copyButton

local copyGradient = Instance.new("UIGradient")
copyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 200))
}
copyGradient.Rotation = 45
copyGradient.Parent = copyButton

-- Status Label with modern styling
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 235)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.Parent = rightPanel

-- Functions
local function updateTotalValue()
    local sellPrice = tonumber(sellPriceInput.Text) or 0
    local weight = tonumber(weightInput.Text) or 0
    local total = sellPrice * weight
    totalValueLabel.Text = string.format("💵 Total: $%.2f", total)
    
    -- Animate value change
    TweenService:Create(totalValueContainer, TweenInfo.new(0.3), {
        Size = UDim2.new(1, 5, 0, 55)
    }):Play()
    wait(0.1)
    TweenService:Create(totalValueContainer, TweenInfo.new(0.3), {
        Size = UDim2.new(1, 0, 0, 55)
    }):Play()
end

local function generateScript()
    local sellPrice = tonumber(sellPriceInput.Text) or 2
    local weight = tonumber(weightInput.Text) or 3
    local fishName = fishNameInput.Text
    local fishImage = fishImageInput.Text
    
    local scriptText = string.format([[
local args = {
    game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Fishing Rod"),
    {
        Sell_Price_KG = %s,
        Fish_Name = "%s",
        FishImage = "%s",
        Weight = %s
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Fishing_System"):WaitForChild("Remotes"):WaitForChild("FinalTask"):FireServer(unpack(args))
]], tostring(sellPrice), fishName, fishImage, tostring(weight))
    
    return scriptText
end

local function executeScript()
    local sellPrice = tonumber(sellPriceInput.Text) or 2
    local weight = tonumber(weightInput.Text) or 3
    local fishName = fishNameInput.Text
    local fishImage = fishImageInput.Text
    
    local args = {
        game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Fishing Rod"),
        {
            Sell_Price_KG = sellPrice,
            Fish_Name = fishName,
            FishImage = fishImage,
            Weight = weight
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Fishing_System"):WaitForChild("Remotes"):WaitForChild("FinalTask"):FireServer(unpack(args))
    
    statusLabel.Text = "✅ Executed!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    
    wait(3)
    statusLabel.Text = ""
end

-- Enhanced button animations with glow
local function animateButton(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 5, button.Size.Y.Scale, button.Size.Y.Offset + 2)
        }):Play()
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 5, button.Size.Y.Scale, button.Size.Y.Offset - 2)
        }):Play()
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 3, button.Size.Y.Scale, button.Size.Y.Offset - 1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 3, button.Size.Y.Scale, button.Size.Y.Offset + 1)
        }):Play()
    end)
end

animateButton(executeButton)
animateButton(copyButton)
animateButton(closeButton)

-- Event connections
sellPriceInput:GetPropertyChangedSignal("Text"):Connect(updateTotalValue)
weightInput:GetPropertyChangedSignal("Text"):Connect(updateTotalValue)

executeButton.MouseButton1Click:Connect(function()
    executeScript()
end)

copyButton.MouseButton1Click:Connect(function()
    local script = generateScript()
    setclipboard(script)
    statusLabel.Text = "📋 Copied!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
    
    wait(3)
    statusLabel.Text = ""
end)

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    wait(0.3)
    screenGui:Destroy()
end)

-- Make draggable
local dragging = false
local dragInput, mousePos, framePos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Initial setup
updateTotalValue()

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 750, 0, 400)
}):Play()

print("🎣 Fishing Script UI (Landscape Dark Theme) loaded successfully!")
