--[[
    TRICKXEL POWER - PREMIUM ADMIN UI
    Features: Player Spectating, Teleportation, Scrolling Player List, P Key Toggle
    Press 'P' to toggle UI (won't trigger while typing)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")A

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- State Management
local State = {
    IsSpectating = false,
    SpectatingPlayer = nil,
    OriginalCameraSubject = nil,
    OriginalCameraType = nil,
    SelectedPlayer = nil,
    UIVisible = false,
    IsTyping = false
}

-- Configuration
local Config = {
    CameraTransitionTime = 0.8,
    CameraOffset = Vector3.new(0, 2, 8)
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Frame (Premium Design)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 920, 0, 480)
MainFrame.Position = UDim2.new(0.5, -460, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Outer Glow Effect
local OuterGlow = Instance.new("ImageLabel")
OuterGlow.Name = "OuterGlow"
OuterGlow.Size = UDim2.new(1, 40, 1, 40)
OuterGlow.Position = UDim2.new(0, -20, 0, -20)
OuterGlow.BackgroundTransparency = 1
OuterGlow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
OuterGlow.ImageColor3 = Color3.fromRGB(138, 43, 226)
OuterGlow.ImageTransparency = 0.7
OuterGlow.ScaleType = Enum.ScaleType.Slice
OuterGlow.SliceCenter = Rect.new(10, 10, 118, 118)
OuterGlow.ZIndex = 0
OuterGlow.Parent = MainFrame

-- Premium Gradient Background
local GradientUI = Instance.new("UIGradient")
GradientUI.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 12, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 18, 40))
}
GradientUI.Rotation = 45
GradientUI.Parent = MainFrame

-- Animated Border Glow
local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderGlow"
BorderFrame.Size = UDim2.new(1, 4, 1, 4)
BorderFrame.Position = UDim2.new(0, -2, 0, -2)
BorderFrame.BackgroundTransparency = 1
BorderFrame.ZIndex = 0
BorderFrame.Parent = MainFrame

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
BorderGradient.Rotation = 0
BorderGradient.Parent = BorderFrame

-- Animate border gradient
task.spawn(function()
    while true do
        TweenService:Create(BorderGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360
        }):Play()
        wait(3)
    end
end)

-- Premium Top Accent
local TopAccent = Instance.new("Frame")
TopAccent.Name = "TopAccent"
TopAccent.Size = UDim2.new(1, 0, 0, 80)
TopAccent.Position = UDim2.new(0, 0, 0, 0)
TopAccent.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
TopAccent.BorderSizePixel = 0
TopAccent.Parent = MainFrame

local TopAccentCorner = Instance.new("UICorner")
TopAccentCorner.CornerRadius = UDim.new(0, 20)
TopAccentCorner.Parent = TopAccent

local TopAccentGradient = Instance.new("UIGradient")
TopAccentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
TopAccentGradient.Rotation = 90
TopAccentGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 0.9)
}
TopAccentGradient.Parent = TopAccent

-- Bottom cutoff for top accent
local TopCutoff = Instance.new("Frame")
TopCutoff.Size = UDim2.new(1, 0, 0, 20)
TopCutoff.Position = UDim2.new(0, 0, 1, -20)
TopCutoff.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TopCutoff.BorderSizePixel = 0
TopCutoff.Parent = TopAccent

-- Logo/Icon Area
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 50, 0, 50)
LogoFrame.Position = UDim2.new(0, 20, 0, 15)
LogoFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = MainFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = LogoFrame

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
LogoGradient.Rotation = 135
LogoGradient.Parent = LogoFrame

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(1, 0, 1, 0)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.Text = "⚡"
LogoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoIcon.TextSize = 28
LogoIcon.Parent = LogoFrame

-- Title with premium styling
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 350, 0, 28)
TitleLabel.Position = UDim2.new(0, 80, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "TRICKXEL POWER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 26
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Add text gradient effect
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
TitleGradient.Parent = TitleLabel

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(0, 400, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 80, 0, 45)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "Advanced Control System • Press 'P' to toggle"
SubtitleLabel.TextColor3 = Color3.fromRGB(186, 85, 211)
SubtitleLabel.TextSize = 11
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.TextTransparency = 0.3
SubtitleLabel.Parent = MainFrame

-- Close Button (Premium Style)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 45, 0, 45)
CloseButton.Position = UDim2.new(1, -60, 0, 15)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 20, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 22
CloseButton.AutoButtonColor = false
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

local CloseGradient = Instance.new("UIGradient")
CloseGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 60, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 80))
}
CloseGradient.Rotation = 135
CloseGradient.Parent = CloseButton

-- Status Frame (Premium)
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0, 360, 0, 50)
StatusFrame.Position = UDim2.new(1, -380, 0, 95)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 12)
StatusCorner.Parent = StatusFrame

local StatusBorder = Instance.new("UIStroke")
StatusBorder.Color = Color3.fromRGB(138, 43, 226)
StatusBorder.Thickness = 1.5
StatusBorder.Transparency = 0.6
StatusBorder.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "⚡ Ready | Select a player to begin"
StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

-- Search Bar (Premium)
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(0, 290, 0, 45)
SearchFrame.Position = UDim2.new(0, 20, 0, 95)
SearchFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 12)
SearchCorner.Parent = SearchFrame

local SearchBorder = Instance.new("UIStroke")
SearchBorder.Color = Color3.fromRGB(138, 43, 226)
SearchBorder.Thickness = 1.5
SearchBorder.Transparency = 0.6
SearchBorder.Parent = SearchFrame

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 45, 1, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Font = Enum.Font.GothamBold
SearchIcon.Text = "🔍"
SearchIcon.TextColor3 = Color3.fromRGB(186, 85, 211)
SearchIcon.TextSize = 18
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -55, 1, 0)
SearchBox.Position = UDim2.new(0, 50, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Font = Enum.Font.GothamBold
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 100, 140)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

-- Player List Container (Premium)
local ListContainer = Instance.new("Frame")
ListContainer.Size = UDim2.new(0, 290, 0, 315)
ListContainer.Position = UDim2.new(0, 20, 0, 150)
ListContainer.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
ListContainer.BorderSizePixel = 0
ListContainer.Parent = MainFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 12)
ListCorner.Parent = ListContainer

local ListBorder = Instance.new("UIStroke")
ListBorder.Color = Color3.fromRGB(138, 43, 226)
ListBorder.Thickness = 1.5
ListBorder.Transparency = 0.7
ListBorder.Parent = ListContainer

-- ScrollingFrame for player list
local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -10)
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 5
PlayerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(186, 85, 211)
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = ListContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = PlayerScrollFrame

-- Info Panel (Premium)
local InfoPanel = Instance.new("Frame")
InfoPanel.Size = UDim2.new(0, 570, 0, 145)
InfoPanel.Position = UDim2.new(0, 330, 0, 150)
InfoPanel.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
InfoPanel.BorderSizePixel = 0
InfoPanel.Parent = MainFrame

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 12)
InfoCorner.Parent = InfoPanel

local InfoBorder = Instance.new("UIStroke")
InfoBorder.Color = Color3.fromRGB(138, 43, 226)
InfoBorder.Thickness = 1.5
InfoBorder.Transparency = 0.6
InfoBorder.Parent = InfoPanel

local InfoTitle = Instance.new("TextLabel")
InfoTitle.Size = UDim2.new(1, -20, 0, 28)
InfoTitle.Position = UDim2.new(0, 15, 0, 12)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.Text = "📋 PLAYER INFORMATION"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.TextSize = 16
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.Parent = InfoPanel

local InfoContent = Instance.new("TextLabel")
InfoContent.Name = "InfoContent"
InfoContent.Size = UDim2.new(1, -30, 1, -50)
InfoContent.Position = UDim2.new(0, 15, 0, 45)
InfoContent.BackgroundTransparency = 1
InfoContent.Font = Enum.Font.Gotham
InfoContent.Text = "No player selected\n\nClick on a player from the list to view details and control options."
InfoContent.TextColor3 = Color3.fromRGB(200, 180, 220)
InfoContent.TextSize = 13
InfoContent.TextXAlignment = Enum.TextXAlignment.Left
InfoContent.TextYAlignment = Enum.TextYAlignment.Top
InfoContent.TextWrapped = true
InfoContent.Parent = InfoPanel

-- Action Buttons Container
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(0, 570, 0, 160)
ButtonsFrame.Position = UDim2.new(0, 330, 0, 305)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Parent = MainFrame

-- Spectate Button (Premium)
local SpectateButton = Instance.new("TextButton")
SpectateButton.Size = UDim2.new(0, 275, 0, 72)
SpectateButton.Position = UDim2.new(0, 0, 0, 0)
SpectateButton.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
SpectateButton.BorderSizePixel = 0
SpectateButton.Font = Enum.Font.GothamBold
SpectateButton.Text = "👁️ SPECTATE"
SpectateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpectateButton.TextSize = 17
SpectateButton.AutoButtonColor = false
SpectateButton.Parent = ButtonsFrame

local SpectateCorner = Instance.new("UICorner")
SpectateCorner.CornerRadius = UDim.new(0, 12)
SpectateCorner.Parent = SpectateButton

local SpectateBorder = Instance.new("UIStroke")
SpectateBorder.Color = Color3.fromRGB(100, 149, 237)
SpectateBorder.Thickness = 2
SpectateBorder.Transparency = 0.5
SpectateBorder.Parent = SpectateButton

local SpectateGradient = Instance.new("UIGradient")
SpectateGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 105, 225)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 144, 255))
}
SpectateGradient.Rotation = 135
SpectateGradient.Parent = SpectateButton

-- Teleport Button (Premium)
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 275, 0, 72)
TeleportButton.Position = UDim2.new(1, -275, 0, 0)
TeleportButton.BackgroundColor3 = Color3.fromRGB(30, 50, 35)
TeleportButton.BorderSizePixel = 0
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.Text = "⚡ TELEPORT"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 17
TeleportButton.AutoButtonColor = false
TeleportButton.Parent = ButtonsFrame

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 12)
TeleportCorner.Parent = TeleportButton

local TeleportBorder = Instance.new("UIStroke")
TeleportBorder.Color = Color3.fromRGB(50, 205, 50)
TeleportBorder.Thickness = 2
TeleportBorder.Transparency = 0.5
TeleportBorder.Parent = TeleportButton

local TeleportGradient = Instance.new("UIGradient")
TeleportGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 139, 34)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 205, 50))
}
TeleportGradient.Rotation = 135
TeleportGradient.Parent = TeleportButton

-- Refresh Button (Premium)
local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 275, 0, 72)
RefreshButton.Position = UDim2.new(0, 0, 1, -72)
RefreshButton.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
RefreshButton.BorderSizePixel = 0
RefreshButton.Font = Enum.Font.GothamBold
RefreshButton.Text = "🔄 REFRESH"
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshButton.TextSize = 17
RefreshButton.AutoButtonColor = false
RefreshButton.Parent = ButtonsFrame

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 12)
RefreshCorner.Parent = RefreshButton

local RefreshBorder = Instance.new("UIStroke")
RefreshBorder.Color = Color3.fromRGB(147, 112, 219)
RefreshBorder.Thickness = 2
RefreshBorder.Transparency = 0.5
RefreshBorder.Parent = RefreshButton

local RefreshGradient = Instance.new("UIGradient")
RefreshGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 112, 219))
}
RefreshGradient.Rotation = 135
RefreshGradient.Parent = RefreshButton

-- Clear Button (Premium)
local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0, 275, 0, 72)
ClearButton.Position = UDim2.new(1, -275, 1, -72)
ClearButton.BackgroundColor3 = Color3.fromRGB(50, 25, 30)
ClearButton.BorderSizePixel = 0
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Text = "✕ CLEAR"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 17
ClearButton.AutoButtonColor = false
ClearButton.Parent = ButtonsFrame

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 12)
ClearCorner.Parent = ClearButton

local ClearBorder = Instance.new("UIStroke")
ClearBorder.Color = Color3.fromRGB(255, 99, 71)
ClearBorder.Thickness = 2
ClearBorder.Transparency = 0.5
ClearBorder.Parent = ClearButton

local ClearGradient = Instance.new("UIGradient")
ClearGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 20, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 99, 71))
}
ClearGradient.Rotation = 135
ClearGradient.Parent = ClearButton

-- Functions
local function CreatePlayerCard(player)
    local card = Instance.new("Frame")
    card.Name = "PlayerCard_" .. player.Name
    card.Size = UDim2.new(1, 0, 0, 68)
    card.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
    card.BorderSizePixel = 0
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local cardBorder = Instance.new("UIStroke")
    cardBorder.Color = Color3.fromRGB(138, 43, 226)
    cardBorder.Thickness = 1
    cardBorder.Transparency = 0.8
    cardBorder.Parent = card
    
    -- Avatar thumbnail
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 56, 0, 56)
    avatarFrame.Position = UDim2.new(0, 6, 0, 6)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = card
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 10)
    avatarCorner.Parent = avatarFrame
    
    local avatarBorder = Instance.new("UIStroke")
    avatarBorder.Color = Color3.fromRGB(186, 85, 211)
    avatarBorder.Thickness = 2
    avatarBorder.Transparency = 0.6
    avatarBorder.Parent = avatarFrame
    
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatarFrame
    
    local avatarImageCorner = Instance.new("UICorner")
    avatarImageCorner.CornerRadius = UDim.new(0, 10)
    avatarImageCorner.Parent = avatarImage
    
    -- Load avatar asynchronously
    task.spawn(function()
        local success, result = pcall(function()
            return Players:GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if success then
            avatarImage.Image = result
        end
    end)
    
    -- Player name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -150, 0, 26)
    nameLabel.Position = UDim2.new(0, 72, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = card
    
    -- Player display name
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Size = UDim2.new(1, -150, 0, 20)
    displayLabel.Position = UDim2.new(0, 72, 0, 36)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Font = Enum.Font.Gotham
    displayLabel.Text = "@" .. player.DisplayName
    displayLabel.TextColor3 = Color3.fromRGB(186, 85, 211)
    displayLabel.TextSize = 11
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.TextTruncate = Enum.TextTruncate.AtEnd
    displayLabel.Parent = card
    
    -- Selection indicator (Glowing bar)
    local selectionIndicator = Instance.new("Frame")
    selectionIndicator.Name = "SelectionIndicator"
    selectionIndicator.Size = UDim2.new(0, 5, 1, 0)
    selectionIndicator.Position = UDim2.new(0, 0, 0, 0)
    selectionIndicator.BackgroundColor3 = Color3.fromRGB(186, 85, 211)
    selectionIndicator.BorderSizePixel = 0
    selectionIndicator.Visible = false
    selectionIndicator.Parent = card
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 10)
    indicatorCorner.Parent = selectionIndicator
    
    -- Button functionality
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = card
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 35, 60)
        }):Play()
        TweenService:Create(cardBorder, TweenInfo.new(0.2), {
            Transparency = 0.4
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if State.SelectedPlayer ~= player then
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 25, 45)
            }):Play()
            TweenService:Create(cardBorder, TweenInfo.new(0.2), {
                Transparency = 0.8
            }):Play()
        end
    end)
    
    -- Selection functionality
    button.MouseButton1Click:Connect(function()
        -- Deselect previous
        for _, otherCard in pairs(PlayerScrollFrame:GetChildren()) do
            if otherCard:IsA("Frame") and otherCard.Name:match("PlayerCard_") then
                local indicator = otherCard:FindFirstChild("SelectionIndicator")
                if indicator then
                    indicator.Visible = false
                end
                local otherBorder = otherCard:FindFirstChildOfClass("UIStroke")
                TweenService:Create(otherCard, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 25, 45)
                }):Play()
                if otherBorder then
                    TweenService:Create(otherBorder, TweenInfo.new(0.2), {
                        Transparency = 0.8
                    }):Play()
                end
            end
        end
        
        -- Select this player
        State.SelectedPlayer = player
        selectionIndicator.Visible = true
        TweenService:Create(card, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 40, 75)
        }):Play()
        TweenService:Create(cardBorder, TweenInfo.new(0.2), {
            Transparency = 0.2
        }):Play()
        
        StatusLabel.Text = "✓ Selected: " .. player.Name
        StatusLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
        
        -- Update info panel
        local health = "N/A"
        local team = "None"
        
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                health = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            end
        end
        
        if player.Team then
            team = player.Team.Name
        end
        
        InfoContent.Text = string.format(
            "Username: %s\nDisplay Name: %s\nUser ID: %d\n\nHealth: %s\nTeam: %s\n\nUse the buttons below to interact.",
            player.Name,
            player.DisplayName,
            player.UserId,
            health,
            team
        )
        
        -- Pulse animation
        local originalSize = card.Size
        TweenService:Create(card, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 6, 0, 68)
        }):Play()
        wait(0.1)
        TweenService:Create(card, TweenInfo.new(0.1), {
            Size = originalSize
        }):Play()
    end)
    
    return card
end

local function UpdatePlayerList()
    -- Clear existing cards
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("PlayerCard_") then
            child:Destroy()
        end
    end
    
    -- Get search term
    local searchTerm = SearchBox.Text:lower()
    
    -- Add player cards
    local cardCount = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if searchTerm == "" or player.Name:lower():find(searchTerm) or player.DisplayName:lower():find(searchTerm) then
                local card = CreatePlayerCard(player)
                card.Parent = PlayerScrollFrame
                cardCount = cardCount + 1
            end
        end
    end
    
    -- Update canvas size
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, cardCount * 76)
end

local function SmoothSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        StatusLabel.Text = "⚠️ Cannot spectate: Player not loaded"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end
    
    local targetChar = targetPlayer.Character
    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
    
    if not targetHumanoid then
        StatusLabel.Text = "⚠️ Cannot spectate: Player model not found"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end
    
    -- Save original camera settings
    if not State.IsSpectating then
        State.OriginalCameraSubject = Camera.CameraSubject
        State.OriginalCameraType = Camera.CameraType
    end
    
    State.IsSpectating = true
    State.SpectatingPlayer = targetPlayer
    
    -- Set camera to follow player
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = targetHumanoid
    
    StatusLabel.Text = "👁️ Spectating: " .. targetPlayer.Name
    StatusLabel.TextColor3 = Color3.fromRGB(100, 149, 237)
    SpectateButton.Text = "⬅️ STOP"
end

local function StopSpectating()
    if not State.IsSpectating then
        return
    end
    
    State.IsSpectating = false
    State.SpectatingPlayer = nil
    
    -- Restore original camera
    Camera.CameraType = State.OriginalCameraType or Enum.CameraType.Custom
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Camera.CameraSubject = humanoid
        end
    end
    
    StatusLabel.Text = "⚡ Spectating stopped"
    StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SpectateButton.Text = "👁️ SPECTATE"
end

local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        StatusLabel.Text = "⚠️ Cannot teleport: Player not found"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end
    
    local targetChar = targetPlayer.Character
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    if not targetHRP or not localHRP then
        StatusLabel.Text = "⚠️ Cannot teleport: Model not found"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end
    
    -- Stop spectating if active
    if State.IsSpectating then
        StopSpectating()
    end
    
    -- Teleport with offset to avoid collision
    localHRP.CFrame = targetHRP.CFrame * CFrame.new(3, 0, 3)
    
    StatusLabel.Text = "⚡ Teleported to: " .. targetPlayer.Name
    StatusLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
end

local function ToggleUI()
    if State.IsTyping then
        return
    end
    
    State.UIVisible = not State.UIVisible
    
    if State.UIVisible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 920, 0, 480),
            Position = UDim2.new(0.5, -460, 0.5, -240)
        }):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        MainFrame.Visible = false
    end
end

-- Button hover effects with glow
local function AddButtonHover(button, hoverColor)
    local originalColor = button.BackgroundColor3
    local border = button:FindFirstChildOfClass("UIStroke")
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
        if border then
            TweenService:Create(border, TweenInfo.new(0.2), {
                Transparency = 0.2,
                Thickness = 2.5
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        }):Play()
        if border then
            TweenService:Create(border, TweenInfo.new(0.2), {
                Transparency = 0.5,
                Thickness = 2
            }):Play()
        end
    end)
end

-- Setup typing detection
SearchBox.Focused:Connect(function()
    State.IsTyping = true
    TweenService:Create(SearchBorder, TweenInfo.new(0.2), {
        Transparency = 0.2,
        Thickness = 2
    }):Play()
end)

SearchBox.FocusLost:Connect(function()
    State.IsTyping = false
    TweenService:Create(SearchBorder, TweenInfo.new(0.2), {
        Transparency = 0.6,
        Thickness = 1.5
    }):Play()
end)

UserInputService.TextBoxFocused:Connect(function()
    State.IsTyping = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    State.IsTyping = false
end)

-- P Key Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P and not State.IsTyping then
        ToggleUI()
    end
end)

-- Button Connections
SpectateButton.MouseButton1Click:Connect(function()
    if State.IsSpectating then
        StopSpectating()
    else
        if State.SelectedPlayer then
            SmoothSpectate(State.SelectedPlayer)
        else
            StatusLabel.Text = "⚠️ Please select a player first"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        end
    end
end)

TeleportButton.MouseButton1Click:Connect(function()
    if State.SelectedPlayer then
        TeleportToPlayer(State.SelectedPlayer)
    else
        StatusLabel.Text = "⚠️ Please select a player first"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    end
end)

RefreshButton.MouseButton1Click:Connect(function()
    UpdatePlayerList()
    StatusLabel.Text = "🔄 Player list refreshed"
    StatusLabel.TextColor3 = Color3.fromRGB(147, 112, 219)
end)

ClearButton.MouseButton1Click:Connect(function()
    if State.IsSpectating then
        StopSpectating()
    end
    
    for _, otherCard in pairs(PlayerScrollFrame:GetChildren()) do
        if otherCard:IsA("Frame") and otherCard.Name:match("PlayerCard_") then
            local indicator = otherCard:FindFirstChild("SelectionIndicator")
            if indicator then
                indicator.Visible = false
            end
            local border = otherCard:FindFirstChildOfClass("UIStroke")
            TweenService:Create(otherCard, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 25, 45)
            }):Play()
            if border then
                TweenService:Create(border, TweenInfo.new(0.2), {
                    Transparency = 0.8
                }):Play()
            end
        end
    end
    
    State.SelectedPlayer = nil
    StatusLabel.Text = "⚡ Ready | Select a player to begin"
    StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    InfoContent.Text = "No player selected\n\nClick on a player from the list to view details and control options."
end)

CloseButton.MouseButton1Click:Connect(function()
    if State.IsSpectating then
        StopSpectating()
    end
    ToggleUI()
end)

-- Add hover effects to buttons
AddButtonHover(SpectateButton, Color3.fromRGB(40, 35, 70))
AddButtonHover(TeleportButton, Color3.fromRGB(40, 70, 45))
AddButtonHover(RefreshButton, Color3.fromRGB(50, 40, 75))
AddButtonHover(ClearButton, Color3.fromRGB(70, 35, 40))
AddButtonHover(CloseButton, Color3.fromRGB(70, 30, 70))

-- Search functionality
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    UpdatePlayerList()
end)

-- Player events
Players.PlayerAdded:Connect(function()
    wait(1)
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if State.SelectedPlayer == player then
        State.SelectedPlayer = nil
        StatusLabel.Text = "⚡ Ready | Select a player to begin"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        InfoContent.Text = "No player selected\n\nClick on a player from the list to view details and control options."
    end
    if State.SpectatingPlayer == player then
        StopSpectating()
    end
    UpdatePlayerList()
end)

-- Initial setup
UpdatePlayerList()

print("✅ Trickxel Power UI loaded! Press 'P' to toggle the interface.")
