local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local CONFIG = {
    Speed = 50,
    FastSpeed = 150,
    Sensitivity = 0.3,
    Smoothness = 0.1,
    FOV = 70,
    FreeCamFOV = 90
}

-- State
local isFreeCamActive = false
local freeCamPosition = Vector3.new()
local freeCamRotation = Vector2.new()
local velocity = Vector3.new()
local keysPressed = {}
local connection = nil

-- UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FreeCamUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Corner Radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🎥 Free Camera"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleButton.Position = UDim2.new(0.05, 0, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.Text = "Enable Free Cam"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamSemibold
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0.9, 0, 0, 35)
teleportButton.Position = UDim2.new(0.05, 0, 0, 100)
teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
teleportButton.Text = "📍 Teleport to Cam"
teleportButton.TextColor3 = Color3.fromRGB(200, 200, 200)
teleportButton.TextSize = 14
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.AutoButtonColor = false
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportButton

-- Status Indicator
local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 15, 0, 16)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
statusDot.BorderSizePixel = 0
statusDot.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusDot

-- Instructions Label
local instructions = Instance.new("TextLabel")
instructions.Name = "Instructions"
instructions.Size = UDim2.new(1, 0, 0, 20)
instructions.Position = UDim2.new(0, 0, 1, -20)
instructions.BackgroundTransparency = 1
instructions.Text = "WASD to move | Shift to sprint | Right-click to look"
instructions.TextColor3 = Color3.fromRGB(150, 150, 150)
instructions.TextSize = 10
instructions.Font = Enum.Font.Gotham
instructions.Parent = mainFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "Minimize"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 24
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame

-- Draggable functionality
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Button hover effects
local function addHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

addHoverEffect(toggleButton, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 140, 220))
addHoverEffect(teleportButton, Color3.fromRGB(40, 40, 50), Color3.fromRGB(60, 60, 80))

-- Free Camera Logic
local function enableFreeCam()
    if isFreeCamActive then return end
    
    isFreeCamActive = true
    
    -- Store current camera state
    freeCamPosition = camera.CFrame.Position
    freeCamRotation = Vector2.new(camera.CFrame:ToEulerAnglesYXZ())
    
    -- Disable character controls
    humanoid.PlatformStand = true
    
    -- Setup camera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = CONFIG.FreeCamFOV
    
    -- Lock mouse
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    
    -- Update UI
    toggleButton.Text = "Disable Free Cam"
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    statusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    
    -- Input handling
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.W then keysPressed["W"] = true end
        if input.KeyCode == Enum.KeyCode.A then keysPressed["A"] = true end
        if input.KeyCode == Enum.KeyCode.S then keysPressed["S"] = true end
        if input.KeyCode == Enum.KeyCode.D then keysPressed["D"] = true end
        if input.KeyCode == Enum.KeyCode.Space then keysPressed["Space"] = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then keysPressed["Shift"] = true end
        if input.KeyCode == Enum.KeyCode.LeftControl then keysPressed["Ctrl"] = true end
    end
    
    local function onInputEnded(input)
        if input.KeyCode == Enum.KeyCode.W then keysPressed["W"] = false end
        if input.KeyCode == Enum.KeyCode.A then keysPressed["A"] = false end
        if input.KeyCode == Enum.KeyCode.S then keysPressed["S"] = false end
        if input.KeyCode == Enum.KeyCode.D then keysPressed["D"] = false end
        if input.KeyCode == Enum.KeyCode.Space then keysPressed["Space"] = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then keysPressed["Shift"] = false end
        if input.KeyCode == Enum.KeyCode.LeftControl then keysPressed["Ctrl"] = false end
    end
    
    local function onMouseMove(input)
        if isFreeCamActive and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Delta
            freeCamRotation = freeCamRotation + Vector2.new(-delta.Y, -delta.X) * CONFIG.Sensitivity * 0.01
            freeCamRotation = Vector2.new(
                math.clamp(freeCamRotation.X, -math.pi/2, math.pi/2),
                freeCamRotation.Y
            )
        end
    end
    
    -- Connect inputs
    local inputBeganConn = UserInputService.InputBegan:Connect(onInputBegan)
    local inputEndedConn = UserInputService.InputEnded:Connect(onInputEnded)
    local mouseMoveConn = UserInputService.InputChanged:Connect(onMouseMove)
    
    -- Render loop
    connection = RunService.RenderStepped:Connect(function(dt)
        if not isFreeCamActive then return end
        
        -- Calculate movement direction
        local moveVector = Vector3.new()
        local camCF = CFrame.fromEulerAnglesYXZ(freeCamRotation.X, freeCamRotation.Y, 0)
        
        if keysPressed["W"] then moveVector = moveVector + camCF.LookVector end
        if keysPressed["S"] then moveVector = moveVector - camCF.LookVector end
        if keysPressed["A"] then moveVector = moveVector - camCF.RightVector end
        if keysPressed["D"] then moveVector = moveVector + camCF.RightVector end
        if keysPressed["Space"] then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if keysPressed["Ctrl"] then moveVector = moveVector - Vector3.new(0, 1, 0) end
        
        -- Apply speed
        local speed = keysPressed["Shift"] and CONFIG.FastSpeed or CONFIG.Speed
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * speed * dt
        end
        
        -- Smooth movement
        velocity = velocity:Lerp(moveVector, CONFIG.Smoothness)
        freeCamPosition = freeCamPosition + velocity
        
        -- Update camera
        camera.CFrame = CFrame.fromEulerAnglesYXZ(freeCamRotation.X, freeCamRotation.Y, 0) + freeCamPosition
        camera.Focus = camera.CFrame * CFrame.new(0, 0, -10)
    end)
    
    -- Store connections for cleanup
    toggleButton:SetAttribute("InputBegan", inputBeganConn)
    toggleButton:SetAttribute("InputEnded", inputEndedConn)
    toggleButton:SetAttribute("MouseMove", mouseMoveConn)
end

local function disableFreeCam()
    if not isFreeCamActive then return end
    
    isFreeCamActive = false
    
    -- Disconnect inputs
    local inputBeganConn = toggleButton:GetAttribute("InputBegan")
    local inputEndedConn = toggleButton:GetAttribute("InputEnded")
    local mouseMoveConn = toggleButton:GetAttribute("MouseMove")
    
    if inputBeganConn then inputBeganConn:Disconnect() end
    if inputEndedConn then inputEndedConn:Disconnect() end
    if mouseMoveConn then mouseMoveConn:Disconnect() end
    if connection then connection:Disconnect() end
    
    -- Restore character
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
    
    -- Restore camera
    camera.CameraType = Enum.CameraType.Custom
    camera.FieldOfView = CONFIG.FOV
    
    -- Unlock mouse
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    
    -- Update UI
    toggleButton.Text = "Enable Free Cam"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    teleportButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    -- Clear keys
    keysPressed = {}
    velocity = Vector3.new()
end

-- Button functionality
toggleButton.MouseButton1Click:Connect(function()
    if isFreeCamActive then
        disableFreeCam()
    else
        enableFreeCam()
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    if isFreeCamActive then
        -- Teleport character to camera position
        local newCFrame = CFrame.new(freeCamPosition)
        humanoidRootPart.CFrame = newCFrame
        disableFreeCam()
        
        -- Visual feedback
        local originalText = teleportButton.Text
        teleportButton.Text = "✓ Teleported!"
        teleportButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        wait(1)
        teleportButton.Text = originalText
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    end
end)

-- Minimize functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 40)}):Play()
        toggleButton.Visible = false
        teleportButton.Visible = false
        instructions.Visible = false
        minimizeButton.Text = "+"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 160)}):Play()
        toggleButton.Visible = true
        teleportButton.Visible = true
        instructions.Visible = true
        minimizeButton.Text = "−"
    end
end)

-- Parent UI
screenGui.Parent = CoreGui

-- Cleanup on character respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if isFreeCamActive then
        disableFreeCam()
    end
end)

-- Keybind to toggle (optional - F key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggleButton.MouseButton1Click:Fire()
    end
end)

print("Free Camera script loaded! Press F to toggle or use the UI.")
