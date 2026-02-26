local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Player Info
local playerName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName

-- Configuration
local Config = {
    ESP = {
        Enabled = false,
        BoxColor = Color3.fromRGB(180, 180, 180),
        DistanceColor = Color3.fromRGB(200, 200, 200),
        UsernameColor = Color3.fromRGB(220, 220, 220),
        HealthGradient = {
            Color3.new(0, 1, 0),
            Color3.new(1, 1, 0),
            Color3.new(1, 0, 0)
        },
        SnaplineEnabled = true,
        SnaplinePosition = "Center",
        RainbowEnabled = false,
        ShowUsername = true
    },
    Aimbot = {
        Enabled = false,
        FOV = 30,
        MaxDistance = 200,
        ShowFOV = false,
        TargetPart = "Head",
        BigHead = {
            Enabled = false,
            Size = 15
        }
    }
}

-- Variables
local RainbowSpeed = 0.5
local ESPDrawings = {}
local BigHeadEnabled = Config.Aimbot.BigHead.Enabled
local BigHeadSize = Config.Aimbot.BigHead.Size

-- Prevent duplicate open buttons (fix duplication bug)
local _openButtonCreated = false

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPDrawings[player] then return end -- prevent duplicate ESP creation

    local drawings = {
        Box = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Distance = Drawing.new("Text"),
        Username = Drawing.new("Text"),
        Snapline = Drawing.new("Line")
    }

    for _, drawing in pairs(drawings) do
        drawing.Visible = false
        if drawing.Type == "Square" then
            drawing.Thickness = 2
            drawing.Filled = false
        end
    end

    drawings.Box.Color = Config.ESP.BoxColor
    drawings.HealthBar.Filled = true
    drawings.Distance.Size = 16
    drawings.Distance.Center = true
    drawings.Distance.Color = Config.ESP.DistanceColor

    drawings.Username.Size = 16
    drawings.Username.Center = true
    drawings.Username.Color = Config.ESP.UsernameColor
    drawings.Username.Text = player.Name

    drawings.Snapline.Color = Config.ESP.BoxColor

    ESPDrawings[player] = drawings
end

local function RemoveESP(player)
    if ESPDrawings[player] then
        for _, drawing in pairs(ESPDrawings[player]) do
            pcall(function() drawing:Remove() end)
        end
        ESPDrawings[player] = nil
    end
end

local function UpdateESP(player, drawings)
    if not Config.ESP.Enabled or not player.Character then
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
        end
        return
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local head = player.Character:FindFirstChild("Head")

    if not humanoid or humanoid.Health <= 0 or not head then
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
        end
        return
    end

    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
    if not onScreen then
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
        end
        return
    end

    local distance = (head.Position - Camera.CFrame.Position).Magnitude
    local scale = 1000 / distance

    drawings.Box.Size = Vector2.new(scale, scale * 1.5)
    drawings.Box.Position = Vector2.new(headPos.X - (scale / 2), headPos.Y - (scale * 0.75))
    drawings.Box.Visible = true

    local healthRatio = humanoid.Health / humanoid.MaxHealth
    local healthColorIndex = math.clamp(3 - (healthRatio * 2), 1, 3)
    local healthColor = Config.ESP.HealthGradient[math.floor(healthColorIndex)]:Lerp(
        Config.ESP.HealthGradient[math.ceil(healthColorIndex)],
        healthColorIndex % 1
    )

    drawings.HealthBar.Size = Vector2.new(4, scale * 1.5 * healthRatio)
    drawings.HealthBar.Position = Vector2.new(
        headPos.X + (scale / 2) + 5,
        (headPos.Y - (scale * 0.75)) + (scale * 1.5 * (1 - healthRatio))
    )
    drawings.HealthBar.Color = healthColor
    drawings.HealthBar.Visible = true

    drawings.Distance.Text = math.floor(distance) .. "m"
    drawings.Distance.Position = Vector2.new(headPos.X, headPos.Y + (scale * 0.75) + 10)
    drawings.Distance.Visible = true

    if Config.ESP.ShowUsername then
        drawings.Username.Text = player.Name
        drawings.Username.Position = Vector2.new(headPos.X, headPos.Y - (scale * 0.75) - 20)
        drawings.Username.Visible = true
    else
        drawings.Username.Visible = false
    end

    if Config.ESP.RainbowEnabled then
        local hue = (tick() * RainbowSpeed) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        drawings.Snapline.Color = rainbowColor
        drawings.Box.Color = rainbowColor
        drawings.Username.Color = rainbowColor
    else
        drawings.Snapline.Color = Config.ESP.BoxColor
        drawings.Box.Color = Config.ESP.BoxColor
        drawings.Username.Color = Config.ESP.UsernameColor
    end

    if Config.ESP.SnaplineEnabled then
        local lineYPosition
        if Config.ESP.SnaplinePosition == "Bottom" then
            lineYPosition = Camera.ViewportSize.Y
        elseif Config.ESP.SnaplinePosition == "Top" then
            lineYPosition = 0
        else
            lineYPosition = Camera.ViewportSize.Y / 2
        end

        drawings.Snapline.From = Vector2.new(headPos.X, headPos.Y + (scale * 0.75))
        drawings.Snapline.To = Vector2.new(Camera.ViewportSize.X / 2, lineYPosition)
        drawings.Snapline.Visible = true
    else
        drawings.Snapline.Visible = false
    end
end

local function FindAimbotTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    local fov = Config.Aimbot.FOV or 30

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local direction = (head.Position - Camera.CFrame.Position).Unit
            local lookVector = Camera.CFrame.LookVector
            local angle = math.deg(math.acos(direction:Dot(lookVector)))

            if angle <= (fov / 2) then
                local distance = (Camera.CFrame.Position - head.Position).Magnitude

                if distance <= Config.Aimbot.MaxDistance then
                    local ray = Ray.new(Camera.CFrame.Position, direction * 500)
                    local hitPart, _ = workspace:FindPartOnRay(ray, LocalPlayer.Character)

                    if hitPart and hitPart:IsDescendantOf(player.Character) then
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = player
                        end
                    end
                end
            end
        end
    end

    return closestTarget
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Filled = false
FOVCircle.Visible = Config.Aimbot.ShowFOV
FOVCircle.Color = Color3.fromRGB(180, 180, 180)

-- Big Head Function
local function UpdateBigHead()
    if not BigHeadEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            pcall(function()
                local head = player.Character.Head
                head.Size = Vector3.new(BigHeadSize, BigHeadSize, BigHeadSize)
                head.Transparency = 1
                head.BrickColor = BrickColor.new("Dark stone grey")
                head.Material = "Neon"
                head.CanCollide = false
                head.Massless = true
            end)
        end
    end
end

-- Gradient Function
local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / math.max(#text - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

-- Welcome Popup
WindUI:Popup({
    Title = gradient("Ryxel", Color3.fromHex("#888888"), Color3.fromHex("#CCCCCC")),
    Icon = "shield-check",
    Content = "Hello " .. displayName .. ", welcome to Ryxel!",
    Buttons = {
        {
            Title = "Get Started",
            Icon = "arrow-right",
            Callback = function() end
        }
    }
})

-- Create Window (OpenButton created only once here — no duplicates)
local Window = WindUI:CreateWindow({
    Title = "Ryxel",
    Icon = "shield-check",
    Author = "by Trickx",
    Folder = "RyxelHub",
    Size = UDim2.fromOffset(520, 450),
    Theme = "Dark",
    Transparency = 0.15, -- semi-transparent background
    User = {
        Enabled = true,
        Anonymous = false,
        Username = playerName,
        UserId = LocalPlayer.UserId,
        Callback = function()
            WindUI:Notify({
                Title = "User Profile",
                Content = "Hello, " .. displayName .. "!",
                Duration = 3
            })
        end
    },
    SideBarWidth = 180,
    OpenButton = {
        Title = "Open Ryxel",
        CornerRadius = UDim.new(0, 8),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.6,
        Color = ColorSequence.new(
            Color3.fromHex("#333333"),
            Color3.fromHex("#888888")
        )
    },
})

-- Topbar Buttons
Window:CreateTopbarButton("minimize", "minus", function()
    Window:Minimize()
end, 991)

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: " .. WindUI:GetCurrentTheme(),
    })
end, 990)

-- Color Definitions (Gray & Black palette)
local LightGrey  = Color3.fromHex("#CCCCCC")
local MidGrey    = Color3.fromHex("#888888")
local DarkGrey   = Color3.fromHex("#444444")
local White      = Color3.fromHex("#EEEEEE")
local Black      = Color3.fromHex("#111111")
local AccentGrey = Color3.fromHex("#666666")

-- ============================================================
-- SECTION: ESP
-- ============================================================
local ESPSection = Window:Section({
    Title = "ESP",
})

local ESPTab = ESPSection:Tab({
    Title = "ESP",
    Icon = "eye",
    IconColor = LightGrey,
    IconShape = "Square",
    Border = true,
})

ESPTab:Section({
    Title = "Visibility",
    Desc = "Control what is shown on screen",
})

ESPTab:Toggle({
    Flag = "ESP_Enabled",
    Title = "Enable ESP",
    Desc = "Toggle ESP visibility",
    Value = Config.ESP.Enabled,
    Callback = function(state)
        Config.ESP.Enabled = state

        if not state then
            for _, drawings in pairs(ESPDrawings) do
                for _, drawing in pairs(drawings) do
                    drawing.Visible = false
                end
            end
        end

        WindUI:Notify({
            Title = "ESP",
            Content = state and "ESP Enabled" or "ESP Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

ESPTab:Space()

ESPTab:Toggle({
    Flag = "ESP_Username",
    Title = "Show Username",
    Desc = "Display player names above box",
    Value = Config.ESP.ShowUsername,
    Callback = function(state)
        Config.ESP.ShowUsername = state

        if not state then
            for _, drawings in pairs(ESPDrawings) do
                if drawings.Username then
                    drawings.Username.Visible = false
                end
            end
        end
    end
})

ESPTab:Space()

ESPTab:Toggle({
    Flag = "ESP_Snapline",
    Title = "Snaplines",
    Desc = "Draw lines to players",
    Value = Config.ESP.SnaplineEnabled,
    Callback = function(state)
        Config.ESP.SnaplineEnabled = state
    end
})

ESPTab:Space()

ESPTab:Toggle({
    Flag = "ESP_Rainbow",
    Title = "Rainbow Mode",
    Desc = "Cycle colors over time",
    Value = Config.ESP.RainbowEnabled,
    Callback = function(state)
        Config.ESP.RainbowEnabled = state
    end
})

ESPTab:Space()

ESPTab:Dropdown({
    Flag = "ESP_SnaplinePos",
    Title = "Snapline Origin",
    Values = {"Center", "Top", "Bottom"},
    Value = Config.ESP.SnaplinePosition,
    Callback = function(option)
        Config.ESP.SnaplinePosition = option
    end
})

ESPTab:Space()

ESPTab:Colorpicker({
    Flag = "ESP_BoxColor",
    Title = "Box Color",
    Default = Config.ESP.BoxColor,
    Callback = function(color)
        Config.ESP.BoxColor = color
    end
})

ESPTab:Space()

ESPTab:Colorpicker({
    Flag = "ESP_UsernameColor",
    Title = "Username Color",
    Default = Config.ESP.UsernameColor,
    Callback = function(color)
        Config.ESP.UsernameColor = color
    end
})

-- ============================================================
-- SECTION: Aimbot
-- ============================================================
local AimbotSection = Window:Section({
    Title = "Aimbot",
})

local AimbotTab = AimbotSection:Tab({
    Title = "Aimbot",
    Icon = "crosshair",
    IconColor = MidGrey,
    IconShape = "Square",
    Border = true,
})

AimbotTab:Section({
    Title = "Auto-Aim",
    Desc = "Configure targeting behaviour",
})

AimbotTab:Toggle({
    Flag = "Aimbot_Enabled",
    Title = "Enable Aimbot",
    Desc = "Toggle aimbot on/off",
    Value = Config.Aimbot.Enabled,
    Callback = function(state)
        Config.Aimbot.Enabled = state

        WindUI:Notify({
            Title = "Aimbot",
            Content = state and "Aimbot Enabled" or "Aimbot Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

AimbotTab:Space()

AimbotTab:Toggle({
    Flag = "Aimbot_ShowFOV",
    Title = "Show FOV Circle",
    Desc = "Visual field-of-view indicator",
    Value = Config.Aimbot.ShowFOV,
    Callback = function(state)
        Config.Aimbot.ShowFOV = state
        FOVCircle.Visible = state
    end
})

AimbotTab:Space()

AimbotTab:Slider({
    Flag = "Aimbot_FOV",
    Title = "FOV Size",
    Desc = "Field of view angle",
    Step = 1,
    Value = {
        Min = 5,
        Max = 100,
        Default = Config.Aimbot.FOV,
    },
    Callback = function(value)
        Config.Aimbot.FOV = value
    end
})

AimbotTab:Space()

AimbotTab:Slider({
    Flag = "Aimbot_Distance",
    Title = "Max Distance",
    Desc = "Maximum target range (studs)",
    Step = 10,
    Value = {
        Min = 50,
        Max = 1000,
        Default = Config.Aimbot.MaxDistance,
    },
    Callback = function(value)
        Config.Aimbot.MaxDistance = value
    end
})

AimbotTab:Space()

AimbotTab:Dropdown({
    Flag = "Aimbot_TargetPart",
    Title = "Target Part",
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Value = Config.Aimbot.TargetPart,
    Callback = function(option)
        Config.Aimbot.TargetPart = option
    end
})

-- ============================================================
-- SECTION: Misc
-- ============================================================
local MiscSection = Window:Section({
    Title = "Misc",
})

local MiscTab = MiscSection:Tab({
    Title = "Big Head",
    Icon = "user",
    IconColor = AccentGrey,
    IconShape = "Square",
    Border = true,
})

MiscTab:Section({
    Title = "Big Head",
    Desc = "Enlarge enemy heads for easier targeting",
})

MiscTab:Toggle({
    Flag = "Aimbot_BigHead",
    Title = "Enable Big Head",
    Desc = "Enlarges all enemy heads",
    Value = Config.Aimbot.BigHead.Enabled,
    Callback = function(state)
        Config.Aimbot.BigHead.Enabled = state
        BigHeadEnabled = state

        if not state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    pcall(function()
                        player.Character.Head.Size = Vector3.new(2, 1, 1)
                        player.Character.Head.Transparency = 0
                        player.Character.Head.BrickColor = BrickColor.new("Pastel brown")
                        player.Character.Head.Material = "Plastic"
                    end)
                end
            end
        end
    end
})

MiscTab:Space()

MiscTab:Slider({
    Flag = "Aimbot_HeadSize",
    Title = "Head Size",
    Desc = "How large the heads become",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = Config.Aimbot.BigHead.Size,
    },
    Callback = function(value)
        Config.Aimbot.BigHead.Size = value
        BigHeadSize = value
    end
})

-- ============================================================
-- SECTION: Settings
-- ============================================================
local SettingsSection = Window:Section({
    Title = "Settings",
})

local SettingsTab = SettingsSection:Tab({
    Title = "Settings",
    Icon = "settings",
    IconColor = DarkGrey,
    IconShape = "Square",
    Border = true,
})

SettingsTab:Section({
    Title = "User Information",
})

SettingsTab:Section({
    Title = "Player: " .. displayName,
    Desc = "Username: @" .. playerName .. "\nUser ID: " .. LocalPlayer.UserId,
})

SettingsTab:Space()

SettingsTab:Section({
    Title = "UI Controls",
})

SettingsTab:Keybind({
    Flag = "UI_Toggle",
    Title = "Toggle UI Key",
    Desc = "Keybind to show/hide UI",
    Value = "RightShift",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})

-- ============================================================
-- MAIN LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.Aimbot.ShowFOV
    FOVCircle.Radius = (Config.Aimbot.FOV / 2) * (Camera.ViewportSize.Y / 90)
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if Config.ESP.RainbowEnabled and Config.Aimbot.ShowFOV then
        local hue = (tick() * RainbowSpeed) % 1
        FOVCircle.Color = Color3.fromHSV(hue, 1, 1)
    elseif Config.Aimbot.ShowFOV then
        FOVCircle.Color = Color3.fromRGB(180, 180, 180)
    end

    for player, drawings in pairs(ESPDrawings) do
        UpdateESP(player, drawings)
    end

    if Config.Aimbot.Enabled then
        local target = FindAimbotTarget()
        if target and target.Character and target.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[Config.Aimbot.TargetPart].Position)
        end
    end

    UpdateBigHead()
end)

-- ============================================================
-- INITIALIZE ESP
-- ============================================================
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Player Events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        RemoveESP(player)
        CreateESP(player)
    end)

    player.CharacterRemoving:Connect(function()
        RemoveESP(player)
    end)

    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Welcome Notification
WindUI:Notify({
    Title = "Ryxel Loaded",
    Content = "Welcome, " .. displayName .. "! All features ready.",
    Icon = "check",
    Duration = 5
})
