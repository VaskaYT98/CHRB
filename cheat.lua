-- Cheat Menu V2.0 by V98 - Modern Edition
local loadStart = tick()
local function dbg(msg)
    print("[Cheat V2] " .. string.format("%.2f", tick() - loadStart) .. "s | " .. msg)
end

dbg("Загрузка сервисов...")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
dbg("Сервисы загружены")

dbg("Получение LocalPlayer...")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")
dbg("Player: " .. player.Name .. " | Char: " .. char.Name)

-- ============================================================
-- STATE
-- ============================================================
local flyEnabled = false
local infJumpEnabled = false
local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local fullbrightEnabled = false
local freecamEnabled = false
local killAuraEnabled = false
local espEnabled = false
local hitboxEnabled = false
local aimbotEnabled = false
local skyboxEnabled = false
local invisibleEnabled = false
local antiAfkEnabled = false
local itemEspEnabled = false
local tracerLinesEnabled = false
local healthBarsEnabled = false
local fpsBoostEnabled = false
local flingEnabled = false
local sitEnabled = false

local currentFlyType = "normal"
local defaultSpeed = 16
local customSpeed = 50
local flySpeed = 50
local killAuraRange = 20
local hitboxSize = 5
local aimbotFOV = 200
local hitboxVisible = false
local espShowName = true
local espShowDistance = true
local espColorR = 255
local espColorG = 50
local espColorB = 50

local espObjects = {}
local hitboxObjects = {}
local originalHitboxSize = {}
local originalLightingSettings = {}
local originalSky = nil
local noclipConnection = nil
local speedConnection = nil
local godConnection = nil
local killAuraConnection = nil
local espConnection = nil
local hitboxConnection = nil
local aimbotConnection = nil
local freecamConnection = nil
local tpClickConnection = nil
local antiAfkConnection = nil
local tracerConnection = nil
local healthBarConnection = nil
local itemEspConnection = nil
local flingConnection = nil

local waitingForBind = nil
local waitingForBindButton = nil
local bindPrefixes = {}
local bindingsLoaded = false
local currentTab = "main"
local selectedPlayerForTP = nil
local selectedOutfitPlayer = nil

local flyBind = Enum.KeyCode.F
local noclipBind = Enum.KeyCode.N
local godModeBind = Enum.KeyCode.G
local infJumpBind = Enum.KeyCode.J
local speedBind = Enum.KeyCode.V
local fullbrightBind = Enum.KeyCode.B
local freecamBind = Enum.KeyCode.C
local killAuraBind = Enum.KeyCode.K
local espBind = Enum.KeyCode.E
local hitboxBind = Enum.KeyCode.H
local aimbotBind = Enum.KeyCode.X

local musicSound = Instance.new("Sound")
musicSound.Looped = true
musicSound.Parent = SoundService

-- ============================================================
-- THEMES
-- ============================================================
local themes = {
    {name = "Тёмная", bg = Color3.fromRGB(22, 22, 32), panel = Color3.fromRGB(32, 32, 45), button = Color3.fromRGB(42, 42, 58), accent = Color3.fromRGB(50, 150, 50), topBar = Color3.fromRGB(18, 18, 28), text = Color3.fromRGB(255,255,255), textDim = Color3.fromRGB(140,140,160)},
    {name = "Светлая", bg = Color3.fromRGB(230, 230, 238), panel = Color3.fromRGB(242, 242, 248), button = Color3.fromRGB(210, 210, 220), accent = Color3.fromRGB(40, 120, 200), topBar = Color3.fromRGB(200, 200, 212), text = Color3.fromRGB(30,30,30), textDim = Color3.fromRGB(90,90,100)},
    {name = "Красная", bg = Color3.fromRGB(32, 18, 18), panel = Color3.fromRGB(45, 22, 22), button = Color3.fromRGB(58, 28, 28), accent = Color3.fromRGB(200, 50, 50), topBar = Color3.fromRGB(28, 14, 14), text = Color3.fromRGB(255,255,255), textDim = Color3.fromRGB(160,130,130)},
    {name = "Синяя", bg = Color3.fromRGB(18, 22, 38), panel = Color3.fromRGB(24, 30, 52), button = Color3.fromRGB(30, 38, 65), accent = Color3.fromRGB(50, 100, 220), topBar = Color3.fromRGB(14, 18, 32), text = Color3.fromRGB(255,255,255), textDim = Color3.fromRGB(130,140,180)},
    {name = "Фиолет", bg = Color3.fromRGB(28, 18, 38), panel = Color3.fromRGB(38, 24, 52), button = Color3.fromRGB(48, 30, 65), accent = Color3.fromRGB(150, 50, 200), topBar = Color3.fromRGB(22, 14, 32), text = Color3.fromRGB(255,255,255), textDim = Color3.fromRGB(150,130,170)},
    {name = "Зелёная", bg = Color3.fromRGB(18, 28, 18), panel = Color3.fromRGB(24, 38, 24), button = Color3.fromRGB(30, 48, 30), accent = Color3.fromRGB(50, 200, 50), topBar = Color3.fromRGB(14, 24, 14), text = Color3.fromRGB(255,255,255), textDim = Color3.fromRGB(130,160,130)},
    {name = "Закат", bg = Color3.fromRGB(35, 22, 15), panel = Color3.fromRGB(48, 30, 20), button = Color3.fromRGB(60, 38, 25), accent = Color3.fromRGB(230, 130, 40), topBar = Color3.fromRGB(30, 18, 12), text = Color3.fromRGB(255,255,255), textDim = Color3.fromRGB(170,145,120)},
}
local currentThemeIndex = 1
local T = themes[1]

-- ============================================================
-- HELPERS
-- ============================================================
local function addCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
end

local function addStroke(parent, color, t)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(55, 55, 75)
    s.Thickness = t or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
end

local function addPadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 4)
    p.PaddingBottom = UDim.new(0, b or 4)
    p.PaddingLeft = UDim.new(0, l or 6)
    p.PaddingRight = UDim.new(0, r or 6)
    p.Parent = parent
end

local function updateButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = T.accent
        button.Text = button.Text:gsub("OFF", "ON")
    else
        button.BackgroundColor3 = T.button
        button.Text = button.Text:gsub("ON", "OFF")
    end
end

-- ============================================================
-- GUI
-- ============================================================
dbg("Создание GUI...")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenuV2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = T.bg
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -235, 0.5, -265)
MainFrame.Size = UDim2.new(0, 470, 0, 530)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
addCorner(MainFrame, 10)
addStroke(MainFrame, Color3.fromRGB(60, 60, 85), 2)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = T.topBar
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 38)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Cheat by V98 | v2.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local HideButton = Instance.new("TextButton")
HideButton.Parent = TopBar
HideButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
HideButton.BorderSizePixel = 0
HideButton.Position = UDim2.new(1, -33, 0, 7)
HideButton.Size = UDim2.new(0, 24, 0, 24)
HideButton.Font = Enum.Font.GothamBold
HideButton.Text = "X"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 12
addCorner(HideButton, 6)

local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Parent = MainFrame
TabFrame.BackgroundColor3 = T.panel
TabFrame.BorderSizePixel = 0
TabFrame.Position = UDim2.new(0, 0, 0, 38)
TabFrame.Size = UDim2.new(1, 0, 0, 40)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabFrame
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0, 4)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local function createTabButton(name, text)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Parent = TabFrame
    b.BackgroundColor3 = T.button
    b.BorderSizePixel = 0
    b.Size = UDim2.new(0, 85, 0, 30)
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 10
    addCorner(b, 6)
    return b
end

local MainTabBtn = createTabButton("MainTab", "Основные")
local PvPTabBtn = createTabButton("PvPTab", "PVP")
local VisualsTabBtn = createTabButton("VisualsTab", "Визуалы")
local ScriptsTabBtn = createTabButton("ScriptsTab", "Скрипты")
local SettingsTabBtn = createTabButton("SettingsTab", "Настройки")

MainTabBtn.BackgroundColor3 = T.accent
dbg("GUI создано, создание контента...")

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 78)
ContentFrame.Size = UDim2.new(1, 0, 1, -118)

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentFrame
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 8, 0, 0)
    page.Size = UDim2.new(1, -16, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = T.accent
    page.BorderSizePixel = 0
    page.Visible = false
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = page
    return page
end

dbg("Создание вкладок...")
local MainPage = createPage("MainPage")
local PvPPage = createPage("PvPPage")
local VisualsPage = createPage("VisualsPage")
local ScriptsPage = createPage("ScriptsPage")
local SettingsPage = createPage("SettingsPage")
MainPage.Visible = true

-- Player footer
local Footer = Instance.new("Frame")
Footer.Name = "Footer"
Footer.Parent = MainFrame
Footer.BackgroundColor3 = T.topBar
Footer.BorderSizePixel = 0
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.Size = UDim2.new(1, 0, 0, 40)
addCorner(Footer, 6)

local AvatarFrame = Instance.new("Frame")
AvatarFrame.Parent = Footer
AvatarFrame.BackgroundColor3 = T.accent
AvatarFrame.Position = UDim2.new(0, 10, 0.5, -13)
AvatarFrame.Size = UDim2.new(0, 26, 0, 26)
addCorner(AvatarFrame, 13)

local AvatarLabel = Instance.new("TextLabel")
AvatarLabel.Parent = AvatarFrame
AvatarLabel.BackgroundTransparency = 1
AvatarLabel.Size = UDim2.new(1, 0, 1, 0)
AvatarLabel.Font = Enum.Font.GothamBold
AvatarLabel.Text = string.sub(player.Name, 1, 1):upper()
AvatarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AvatarLabel.TextSize = 14

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Parent = Footer
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Position = UDim2.new(0, 42, 0, 2)
PlayerNameLabel.Size = UDim2.new(0.5, 0, 0, 18)
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.Text = player.Name
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextSize = 12
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local PlayerIDLabel = Instance.new("TextLabel")
PlayerIDLabel.Parent = Footer
PlayerIDLabel.BackgroundTransparency = 1
PlayerIDLabel.Position = UDim2.new(0, 42, 0, 20)
PlayerIDLabel.Size = UDim2.new(0.5, 0, 0, 16)
PlayerIDLabel.Font = Enum.Font.Gotham
PlayerIDLabel.Text = "ID: " .. player.UserId
PlayerIDLabel.TextColor3 = T.textDim
PlayerIDLabel.TextSize = 10
PlayerIDLabel.TextXAlignment = Enum.TextXAlignment.Left

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Parent = Footer
VersionLabel.BackgroundTransparency = 1
VersionLabel.Position = UDim2.new(0.6, 0, 0, 2)
VersionLabel.Size = UDim2.new(0.38, 0, 1, 0)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Text = "v2.0 ULTIMATE"
VersionLabel.TextColor3 = T.textDim
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Show button
local ShowButton = Instance.new("TextButton")
ShowButton.Parent = ScreenGui
ShowButton.BackgroundColor3 = T.panel
ShowButton.BorderSizePixel = 0
ShowButton.Position = UDim2.new(0, 10, 0, 10)
ShowButton.Size = UDim2.new(0, 130, 0, 40)
ShowButton.Font = Enum.Font.GothamBold
ShowButton.Text = "Открыть меню"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextSize = 12
ShowButton.Visible = false
addCorner(ShowButton, 8)
addStroke(ShowButton, Color3.fromRGB(60, 60, 85))

-- ============================================================
-- UI CREATORS
-- ============================================================
local orderCounter = 0
local function createCheatButton(parent, name, text)
    orderCounter = orderCounter + 1
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = T.button
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 38)
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.LayoutOrder = orderCounter
    button.AutoButtonColor = false
    addCorner(button, 8)
    button.MouseEnter:Connect(function()
        if not button.Text:find("ON") then
            button.BackgroundColor3 = Color3.fromRGB(
                math.min(255, button.BackgroundColor3.R * 255 + 12),
                math.min(255, button.BackgroundColor3.G * 255 + 12),
                math.min(255, button.BackgroundColor3.B * 255 + 12)
            )
        end
    end)
    button.MouseLeave:Connect(function()
        if not button.Text:find("ON") then
            button.BackgroundColor3 = T.button
        end
    end)
    return button
end

local function createLabel(parent, text)
    orderCounter = orderCounter + 1
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = T.panel
    label.BorderSizePixel = 0
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Font = Enum.Font.GothamBold
    label.Text = "  " .. text
    label.TextColor3 = T.textDim
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = orderCounter
    addCorner(label, 6)
    return label
end

local function createSlider(parent, name, text, minVal, maxVal, defaultVal, callback)
    orderCounter = orderCounter + 1
    local container = Instance.new("Frame")
    container.Name = name
    container.Parent = parent
    container.BackgroundColor3 = T.button
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 50)
    container.LayoutOrder = orderCounter
    addCorner(container, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = container
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 8, 0, 2)
    lbl.Size = UDim2.new(1, -16, 0, 20)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text .. ": " .. defaultVal
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = container
    sliderBg.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    sliderBg.BorderSizePixel = 0
    sliderBg.Position = UDim2.new(0, 8, 0, 26)
    sliderBg.Size = UDim2.new(1, -16, 0, 16)
    addCorner(sliderBg, 6)

    local fraction = (defaultVal - minVal) / (maxVal - minVal)
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = T.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new(fraction, 0, 1, 0)
    addCorner(sliderFill, 6)

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Parent = sliderBg
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Position = UDim2.new(fraction, -6, 0.5, -6)
    sliderBtn.Size = UDim2.new(0, 12, 0, 12)
    sliderBtn.Text = ""
    addCorner(sliderBtn, 6)

    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local relX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local pct = relX / sliderBg.AbsoluteSize.X
            local val = math.floor(minVal + (maxVal - minVal) * pct)
            sliderFill.Size = UDim2.new(pct, 0, 1, 0)
            sliderBtn.Position = UDim2.new(pct, -6, 0.5, -6)
            lbl.Text = text .. ": " .. val
            callback(val)
        end
    end)
    return container
end

local function createSmallRow(parent)
    orderCounter = orderCounter + 1
    local f = Instance.new("Frame")
    f.Parent = parent
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 0, 36)
    f.LayoutOrder = orderCounter
    local layout = Instance.new("UIListLayout")
    layout.Parent = f
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 4)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    return f
end

local function createSmallButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.BackgroundColor3 = T.button
    b.BorderSizePixel = 0
    b.Size = UDim2.new(0, 70, 0, 30)
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 10
    b.AutoButtonColor = false
    addCorner(b, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function createTextInput(parent, name, placeholder)
    orderCounter = orderCounter + 1
    local tb = Instance.new("TextBox")
    tb.Name = name
    tb.Parent = parent
    tb.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    tb.BorderSizePixel = 0
    tb.Size = UDim2.new(1, 0, 0, 34)
    tb.Font = Enum.Font.Gotham
    tb.PlaceholderText = placeholder
    tb.Text = ""
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.TextSize = 12
    tb.ClearTextOnFocus = false
    tb.LayoutOrder = orderCounter
    addCorner(tb, 6)
    addPadding(tb, 0, 0, 8)
    return tb
end

-- ============================================================
-- TAB SWITCHING
-- ============================================================
local allPages = {MainPage, PvPPage, VisualsPage, ScriptsPage, SettingsPage}
local allTabBtns = {MainTabBtn, PvPTabBtn, VisualsTabBtn, ScriptsTabBtn, SettingsTabBtn}

local function switchTab(tab)
    currentTab = tab
    for _, p in pairs(allPages) do p.Visible = false end
    for _, b in pairs(allTabBtns) do b.BackgroundColor3 = T.button end
    local map = {main = 1, pvp = 2, visuals = 3, scripts = 4, settings = 5}
    local idx = map[tab]
    if idx then
        allPages[idx].Visible = true
        allTabBtns[idx].BackgroundColor3 = T.accent
    end
end

MainTabBtn.MouseButton1Click:Connect(function() switchTab("main") end)
PvPTabBtn.MouseButton1Click:Connect(function() switchTab("pvp") end)
VisualsTabBtn.MouseButton1Click:Connect(function() switchTab("visuals") end)
ScriptsTabBtn.MouseButton1Click:Connect(function() switchTab("scripts") end)
SettingsTabBtn.MouseButton1Click:Connect(function() switchTab("settings") end)

-- ============================================================
-- MAIN TAB
-- ============================================================
dbg("Main tab...")
createLabel(MainPage, "ОСНОВНЫЕ ЧИТЫ")
local FlyButton = createCheatButton(MainPage, "FlyButton", "Fly: OFF [F]")
local InfJumpButton = createCheatButton(MainPage, "InfJumpButton", "Inf Jump: OFF [J]")
local GodModeButton = createCheatButton(MainPage, "GodModeButton", "God Mode: OFF [G]")
local NoclipButton = createCheatButton(MainPage, "NoclipButton", "Noclip: OFF [N]")
local SpeedButton = createCheatButton(MainPage, "SpeedButton", "Speed: OFF [V]")
local FreecamButton = createCheatButton(MainPage, "FreecamButton", "Freecam: OFF [C]")
local InvisibleButton = createCheatButton(MainPage, "InvisibleButton", "Invisible: OFF")
local AntiAfkButton = createCheatButton(MainPage, "AntiAfkButton", "Anti-AFK: OFF")

createLabel(MainPage, "ТИП ПОЛЕТА")
local flyTypeRow = createSmallRow(MainPage)
local FlyNormalBtn, FlyBhopBtn, FlyBounceBtn, FlyGlideBtn
FlyNormalBtn = createSmallButton(flyTypeRow, "Normal", function() currentFlyType = "normal" FlyNormalBtn.BackgroundColor3 = T.accent FlyBhopBtn.BackgroundColor3 = T.button FlyBounceBtn.BackgroundColor3 = T.button FlyGlideBtn.BackgroundColor3 = T.button end)
FlyBhopBtn = createSmallButton(flyTypeRow, "BHOP", function() currentFlyType = "bhop" FlyBhopBtn.BackgroundColor3 = T.accent FlyNormalBtn.BackgroundColor3 = T.button FlyBounceBtn.BackgroundColor3 = T.button FlyGlideBtn.BackgroundColor3 = T.button end)
FlyBounceBtn = createSmallButton(flyTypeRow, "Bounce", function() currentFlyType = "bounce" FlyBounceBtn.BackgroundColor3 = T.accent FlyNormalBtn.BackgroundColor3 = T.button FlyBhopBtn.BackgroundColor3 = T.button FlyGlideBtn.BackgroundColor3 = T.button end)
FlyGlideBtn = createSmallButton(flyTypeRow, "Glide", function() currentFlyType = "glide" FlyGlideBtn.BackgroundColor3 = T.accent FlyNormalBtn.BackgroundColor3 = T.button FlyBhopBtn.BackgroundColor3 = T.button FlyBounceBtn.BackgroundColor3 = T.button end)
FlyNormalBtn.BackgroundColor3 = T.accent

createLabel(MainPage, "НАСТРОЙКИ")
createSlider(MainPage, "FlySpeedSlider", "Скорость полёта", 10, 200, 50, function(v) flySpeed = v end)
createSlider(MainPage, "WalkSpeedSlider", "Скорость ходьбы", 16, 200, 50, function(v) customSpeed = v if speedEnabled and hum then hum.WalkSpeed = v end end)

-- ============================================================
-- PVP TAB
-- ============================================================
dbg("PvP tab...")
createLabel(PvPPage, "PVP ЧИТЫ")
local KillAuraButton = createCheatButton(PvPPage, "KillAuraButton", "Kill Aura: OFF [K]")
local AimbotButton = createCheatButton(PvPPage, "AimbotButton", "Aimbot: OFF [X]")
local HitboxButton = createCheatButton(PvPPage, "HitboxButton", "Hitbox: OFF [H]")
local HitboxVisibleButton = createCheatButton(PvPPage, "HitboxVisibleButton", "Хитбокс видимый: OFF")
local TracerButton = createCheatButton(PvPPage, "TracerButton", "Tracer Lines: OFF")
local HealthBarBtn = createCheatButton(PvPPage, "HealthBarBtn", "Health Bars: OFF")

createLabel(PvPPage, "НАСТРОЙКИ PVP")
createSlider(PvPPage, "KARangeSlider", "Kill Aura радиус", 5, 50, 20, function(v) killAuraRange = v end)
createSlider(PvPPage, "AimbotFOVSlider", "Aimbot FOV", 50, 500, 200, function(v) aimbotFOV = v end)
createSlider(PvPPage, "HitboxSizeSlider", "Размер хитбокса", 1, 20, 5, function(v)
    hitboxSize = v
    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Size = Vector3.new(v, v, v) end
            end
        end
    end
end)

-- ============================================================
-- VISUALS TAB
-- ============================================================
dbg("Visuals tab...")
createLabel(VisualsPage, "ВИЗУАЛЬНЫЕ ЭФФЕКТЫ")
local ESPButton = createCheatButton(VisualsPage, "ESPButton", "ESP: OFF [E]")
local ItemEspBtn = createCheatButton(VisualsPage, "ItemEspBtn", "Item ESP: OFF")
local FullbrightButton = createCheatButton(VisualsPage, "FullbrightButton", "Fullbright: OFF [B]")
local SkyboxButton = createCheatButton(VisualsPage, "SkyboxButton", "Custom Skybox: OFF")

createLabel(VisualsPage, "НАСТРОЙКИ ESP")
local ESPShowNameBtn = createCheatButton(VisualsPage, "ESPShowNameBtn", "ESP Имя: ON")
local ESPShowDistBtn = createCheatButton(VisualsPage, "ESPShowDistBtn", "ESP Дистанция: ON")

createLabel(VisualsPage, "ЦВЕТ ESP (RGB)")
local ESP_R = createTextInput(VisualsPage, "ESP_R", "R (0-255)")
local ESP_G = createTextInput(VisualsPage, "ESP_G", "G (0-255)")
local ESP_B = createTextInput(VisualsPage, "ESP_B", "B (0-255)")
orderCounter = orderCounter + 1
local ApplyESPColorBtn = createCheatButton(VisualsPage, "ApplyESPColor", "Применить цвет ESP")
ApplyESPColorBtn.BackgroundColor3 = T.accent
ApplyESPColorBtn.LayoutOrder = orderCounter

createLabel(VisualsPage, "ОСВЕЩЕНИЕ")
createSlider(VisualsPage, "BrightnessSlider", "Яркость", 0, 10, 2, function(v) Lighting.Brightness = v end)
createSlider(VisualsPage, "AmbientSlider", "Ambient", 0, 255, 128, function(v) Lighting.Ambient = Color3.fromRGB(v, v, v) end)

-- ============================================================
-- SCRIPTS TAB
-- ============================================================
dbg("Scripts tab...")
createLabel(ScriptsPage, "ВСТРОЕННЫЕ СКРИПТЫ")
local NightScriptBtn = createCheatButton(ScriptsPage, "NightScriptBtn", "99 Nights in the Forest")
NightScriptBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
local MM2ScriptBtn = createCheatButton(ScriptsPage, "MM2ScriptBtn", "MM2 Script")
MM2ScriptBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 50)

createLabel(ScriptsPage, "ИНСТРУМЕНТЫ")
local ScriptEditorBtn = createCheatButton(ScriptsPage, "ScriptEditorBtn", "Script Editor")
ScriptEditorBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
local OutfitCopierBtn = createCheatButton(ScriptsPage, "OutfitCopierBtn", "Outfit Copier")
OutfitCopierBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)

createLabel(ScriptsPage, "TROLL TOOLS")
local FlingBtn = createCheatButton(ScriptsPage, "FlingBtn", "Fling: OFF")
FlingBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
local SitBtn = createCheatButton(ScriptsPage, "SitBtn", "Force Sit: OFF")
SitBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 50)

-- ============================================================
-- SETTINGS TAB
-- ============================================================
dbg("Settings tab...")
createLabel(SettingsPage, "ТЕМА ОФОРМЛЕНИЯ")
local themeRow = createSmallRow(SettingsPage)
for i, th in ipairs(themes) do
    local themeBtn = createSmallButton(themeRow, th.name, function()
        currentThemeIndex = i
        T = themes[i]
        MainFrame.BackgroundColor3 = T.bg
        TopBar.BackgroundColor3 = T.topBar
        TabFrame.BackgroundColor3 = T.panel
        Footer.BackgroundColor3 = T.topBar
        for _, b in pairs(allTabBtns) do b.BackgroundColor3 = T.button end
        switchTab(currentTab)
    end)
end

createLabel(SettingsPage, "СЕРВЕР И СТАТИСТИКА")
local ServerInfoBtn = createCheatButton(SettingsPage, "ServerInfoBtn", "Server Info")
ServerInfoBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
local PlayerAnalyticsBtn = createCheatButton(SettingsPage, "PlayerAnalyticsBtn", "Player Analytics")
PlayerAnalyticsBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 100)
local FPSBoostBtn = createCheatButton(ScriptsPage, "FPSBoostBtn", "FPS Boost: OFF")
FPSBoostBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
local ServerPrivateBtn = createCheatButton(SettingsPage, "ServerPrivateBtn", "Server Private (мало игроков)")
ServerPrivateBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)

createLabel(SettingsPage, "МУЗЫКА")
local MusicIDInput = createTextInput(SettingsPage, "MusicID", "ID песни (например: 123456789)")
local musicRow = createSmallRow(SettingsPage)
local MusicPlayBtn = createSmallButton(musicRow, "Play", function()
    local id = MusicIDInput.Text:match("%d+")
    if id then
        musicSound.SoundId = "rbxassetid://" .. id
        musicSound:Play()
    end
end)
MusicPlayBtn.BackgroundColor3 = T.accent
local MusicPauseBtn = createSmallButton(musicRow, "Pause", function() musicSound:Pause() end)
local MusicStopBtn = createSmallButton(musicRow, "Stop", function() musicSound:Stop() end)
MusicStopBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)

createLabel(SettingsPage, "БИНДЫ КЛАВИШ")
orderCounter = orderCounter + 1
local BindHint = Instance.new("TextLabel")
BindHint.Parent = SettingsPage
BindHint.BackgroundTransparency = 1
BindHint.Size = UDim2.new(1, 0, 0, 24)
BindHint.Font = Enum.Font.Gotham
BindHint.Text = "ПКМ по кнопке = перебинд | ESC = отмена"
BindHint.TextColor3 = T.textDim
BindHint.TextSize = 11
BindHint.LayoutOrder = orderCounter

createLabel(SettingsPage, "УПРАВЛЕНИЕ")
local UnloadButton = createCheatButton(SettingsPage, "UnloadButton", "ВЫГРУЗИТЬ ЧИТ")
UnloadButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

-- ============================================================
-- OVERLAYS
-- ============================================================
dbg("Overlays...")
local overlayFrame = Instance.new("Frame")
overlayFrame.Parent = ScreenGui
overlayFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
overlayFrame.BorderSizePixel = 0
overlayFrame.Position = UDim2.new(0.5, -200, 0.5, -220)
overlayFrame.Size = UDim2.new(0, 400, 0, 440)
overlayFrame.Visible = false
overlayFrame.ZIndex = 200
addCorner(overlayFrame, 10)
addStroke(overlayFrame, T.accent, 2)

local overlayTitle = Instance.new("TextLabel")
overlayTitle.Parent = overlayFrame
overlayTitle.BackgroundColor3 = T.topBar
overlayTitle.BorderSizePixel = 0
overlayTitle.Size = UDim2.new(1, 0, 0, 35)
overlayTitle.Font = Enum.Font.GothamBold
overlayTitle.Text = ""
overlayTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
overlayTitle.TextSize = 14
overlayTitle.ZIndex = 201

local overlayContent = Instance.new("Frame")
overlayContent.Parent = overlayFrame
overlayContent.BackgroundTransparency = 1
overlayContent.Position = UDim2.new(0, 10, 0, 40)
overlayContent.Size = UDim2.new(1, -20, 1, -50)
overlayContent.ZIndex = 200

local overlayCloseBtn = Instance.new("TextButton")
overlayCloseBtn.Parent = overlayTitle
overlayCloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
overlayCloseBtn.BorderSizePixel = 0
overlayCloseBtn.Position = UDim2.new(1, -30, 0, 6)
overlayCloseBtn.Size = UDim2.new(0, 24, 0, 24)
overlayCloseBtn.Font = Enum.Font.GothamBold
overlayCloseBtn.Text = "X"
overlayCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
overlayCloseBtn.TextSize = 12
overlayCloseBtn.ZIndex = 202
addCorner(overlayCloseBtn, 6)
overlayCloseBtn.MouseButton1Click:Connect(function() overlayFrame.Visible = false end)

local overlayScroll = Instance.new("ScrollingFrame")
overlayScroll.Parent = overlayContent
overlayScroll.BackgroundTransparency = 1
overlayScroll.Size = UDim2.new(1, 0, 1, 0)
overlayScroll.ScrollBarThickness = 4
overlayScroll.BorderSizePixel = 0
overlayScroll.ZIndex = 200
overlayScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local overlayLayout = Instance.new("UIListLayout")
overlayLayout.Parent = overlayScroll
overlayLayout.Padding = UDim.new(0, 4)

local function clearOverlay()
    for _, c in pairs(overlayScroll:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

local function showOverlay(title)
    overlayTitle.Text = title
    clearOverlay()
    overlayFrame.Visible = true
end

-- Script Editor overlay
local scriptEditorBox
ScriptEditorBtn.MouseButton1Click:Connect(function()
    showOverlay("Script Editor")
    scriptEditorBox = Instance.new("TextBox")
    scriptEditorBox.Parent = overlayScroll
    scriptEditorBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    scriptEditorBox.BorderSizePixel = 0
    scriptEditorBox.Size = UDim2.new(1, 0, 0, 250)
    scriptEditorBox.Font = Enum.Font.Code
    scriptEditorBox.Text = ""
    scriptEditorBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    scriptEditorBox.TextSize = 12
    scriptEditorBox.ClearTextOnFocus = false
    scriptEditorBox.MultiLine = true
    scriptEditorBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptEditorBox.TextYAlignment = Enum.TextYAlignment.Top
    scriptEditorBox.ZIndex = 201
    addCorner(scriptEditorBox, 6)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 8)
    pad.Parent = scriptEditorBox

    local btnRow = createSmallRow(overlayScroll)
    local execBtn = createSmallButton(btnRow, "Execute", function()
        pcall(function() loadstring(scriptEditorBox.Text)() end)
    end)
    execBtn.BackgroundColor3 = T.accent
    execBtn.Size = UDim2.new(0, 100, 0, 30)
    local clearBtn = createSmallButton(btnRow, "Clear", function() scriptEditorBox.Text = "" end)
    clearBtn.Size = UDim2.new(0, 100, 0, 30)
end)

-- Outfit Copier overlay
OutfitCopierBtn.MouseButton1Click:Connect(function()
    showOverlay("Outfit Copier - Выберите игрока")
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local row = Instance.new("Frame")
            row.Parent = overlayScroll
            row.BackgroundColor3 = T.button
            row.BorderSizePixel = 0
            row.Size = UDim2.new(1, 0, 0, 40)
            row.ZIndex = 201
            addCorner(row, 6)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = row
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = p.Name
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 202
            local copyBtn = Instance.new("TextButton")
            copyBtn.Parent = row
            copyBtn.BackgroundColor3 = T.accent
            copyBtn.BorderSizePixel = 0
            copyBtn.Position = UDim2.new(1, -80, 0, 5)
            copyBtn.Size = UDim2.new(0, 70, 0, 30)
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.Text = "Копировать"
            copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            copyBtn.TextSize = 10
            copyBtn.ZIndex = 202
            addCorner(copyBtn, 6)
            copyBtn.MouseButton1Click:Connect(function()
                local tChar = p.Character
                local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                local lHum = char and char:FindFirstChildOfClass("Humanoid")
                if tHum and lHum then
                    pcall(function()
                        local desc = tHum:GetAppliedDescription()
                        lHum:ApplyDescription(desc)
                    end)
                    copyBtn.Text = "Готово!"
                    wait(1)
                    copyBtn.Text = "Копировать"
                end
            end)
        end
    end
end)

-- Server Info overlay
local function showServerInfo()
    showOverlay("Server Info")
    local info = {
        {"Game", game.PlaceId},
        {"Server JobId", game.JobId},
        {"Players", #Players:GetPlayers() .. "/" .. Players.MaxPlayers},
        {"Local Player", player.Name .. " (" .. player.UserId .. ")"},
        {"Game Version", game.Version},
        {"Place Version", tostring(game.PlaceVersion)},
    }
    for _, pair in pairs(info) do
        local row = Instance.new("TextLabel")
        row.Parent = overlayScroll
        row.BackgroundColor3 = T.button
        row.BorderSizePixel = 0
        row.Size = UDim2.new(1, 0, 0, 30)
        row.Font = Enum.Font.Gotham
        row.Text = "  " .. pair[1] .. ": " .. tostring(pair[2])
        row.TextColor3 = Color3.fromRGB(255, 255, 255)
        row.TextSize = 11
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.ZIndex = 201
        addCorner(row, 6)
    end
end
ServerInfoBtn.MouseButton1Click:Connect(showServerInfo)

-- Player Analytics overlay
local function showPlayerAnalytics()
    showOverlay("Player Analytics")
    local totalPing = 0
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        local ping = p:GetNetworkPing() or 0
        totalPing = totalPing + ping
        count = count + 1
        local row = Instance.new("TextLabel")
        row.Parent = overlayScroll
        row.BackgroundColor3 = T.button
        row.BorderSizePixel = 0
        row.Size = UDim2.new(1, 0, 0, 28)
        row.Font = Enum.Font.Gotham
        row.Text = "  " .. p.Name .. " | Ping: " .. math.floor(ping * 1000) .. "ms"
        row.TextColor3 = Color3.fromRGB(255, 255, 255)
        row.TextSize = 11
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.ZIndex = 201
        addCorner(row, 6)
    end
    local summary = Instance.new("TextLabel")
    summary.Parent = overlayScroll
    summary.BackgroundColor3 = T.accent
    summary.BorderSizePixel = 0
    summary.Size = UDim2.new(1, 0, 0, 30)
    summary.Font = Enum.Font.GothamBold
    summary.Text = "  Всего: " .. count .. " | Средний пинг: " .. math.floor((count > 0 and totalPing / count or 0) * 1000) .. "ms"
    summary.TextColor3 = Color3.fromRGB(255, 255, 255)
    summary.TextSize = 11
    summary.TextXAlignment = Enum.TextXAlignment.Left
    summary.ZIndex = 201
    addCorner(summary, 6)
end
PlayerAnalyticsBtn.MouseButton1Click:Connect(showPlayerAnalytics)

-- ============================================================
-- FLY
-- ============================================================
dbg("Feature: Fly")
local flying = false
local flyConn = nil

local function toggleFly()
    flyEnabled = not flyEnabled
    updateButton(FlyButton, flyEnabled)
    if flyEnabled then
        flying = true
        flyConn = RunService.Heartbeat:Connect(function(delta)
            if not flyEnabled or not rootPart or not rootPart.Parent then
                if flyConn then flyConn:Disconnect() end
                return
            end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            local spd = flySpeed
            if currentFlyType == "bhop" then spd = flySpeed * 1.5
            elseif currentFlyType == "bounce" then spd = flySpeed * 0.8
            elseif currentFlyType == "glide" then spd = flySpeed * 0.6 end
            rootPart.CFrame = rootPart.CFrame + dir * spd * delta
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end)
    else
        flying = false
        if flyConn then flyConn:Disconnect() flyConn = nil end
    end
end

-- ============================================================
-- INFINITE JUMP
-- ============================================================
local function toggleInfJump()
    infJumpEnabled = not infJumpEnabled
    updateButton(InfJumpButton, infJumpEnabled)
end

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ============================================================
-- GOD MODE
-- ============================================================
local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    updateButton(GodModeButton, godModeEnabled)
    if godModeEnabled then
        godConnection = RunService.Heartbeat:Connect(function()
            if godModeEnabled and hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        if godConnection then godConnection:Disconnect() end
    end
end

-- ============================================================
-- NOCLIP
-- ============================================================
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    updateButton(NoclipButton, noclipEnabled)
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if noclipEnabled and char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end

-- ============================================================
-- SPEED
-- ============================================================
local function toggleSpeed()
    speedEnabled = not speedEnabled
    updateButton(SpeedButton, speedEnabled)
    if speedEnabled then
        speedConnection = RunService.Heartbeat:Connect(function()
            if speedEnabled and hum then hum.WalkSpeed = customSpeed end
        end)
    else
        if speedConnection then speedConnection:Disconnect() end
        if hum then hum.WalkSpeed = defaultSpeed end
    end
end

-- ============================================================
-- FREECAM (FIXED - character stays still)
-- ============================================================
local originalCFrame
local originalCameraSubject
local freecamRotation = CFrame.new()
local freecamPosition = Vector3.new()

local function toggleFreecam()
    freecamEnabled = not freecamEnabled
    updateButton(FreecamButton, freecamEnabled)
    local cam = workspace.CurrentCamera
    if freecamEnabled then
        if rootPart then rootPart.Anchored = true end
        originalCFrame = cam.CFrame
        originalCameraSubject = cam.CameraSubject
        freecamRotation = cam.CFrame - cam.CFrame.Position
        freecamPosition = cam.CFrame.Position
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CameraSubject = nil
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

        freecamConnection = RunService.RenderStepped:Connect(function(delta)
            if not freecamEnabled then return end
            local md = UserInputService:GetMouseDelta()
            local sens = 0.003
            freecamRotation = freecamRotation * CFrame.Angles(0, -md.X * sens, 0) * CFrame.Angles(-md.Y * sens, 0, 0)
            local mv = Vector3.new(0, 0, 0)
            local spd = 50
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + freecamRotation.LookVector * spd * delta end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - freecamRotation.LookVector * spd * delta end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - freecamRotation.RightVector * spd * delta end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + freecamRotation.RightVector * spd * delta end
            if UserInputService:IsKeyDown(Enum.KeyCode.R) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0, 1, 0) * spd * delta end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then mv = mv - Vector3.new(0, 1, 0) * spd * delta end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv = mv * 3 end
            freecamPosition = freecamPosition + mv
            cam.CFrame = CFrame.new(freecamPosition) * freecamRotation
        end)
    else
        if freecamConnection then freecamConnection:Disconnect() freecamConnection = nil end
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = originalCameraSubject or hum
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if rootPart then rootPart.Anchored = false end
    end
end

-- ============================================================
-- INVISIBLE
-- ============================================================
local invisibleConn
local function toggleInvisible()
    invisibleEnabled = not invisibleEnabled
    updateButton(InvisibleButton, invisibleEnabled)
    if invisibleEnabled then
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
        end
        invisibleConn = RunService.RenderStepped:Connect(function()
            if not invisibleEnabled or not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
        end)
    else
        if invisibleConn then invisibleConn:Disconnect() invisibleConn = nil end
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
        end
    end
end

-- ============================================================
-- ANTI-AFK
-- ============================================================
local function toggleAntiAfk()
    antiAfkEnabled = not antiAfkEnabled
    updateButton(AntiAfkButton, antiAfkEnabled)
    if antiAfkEnabled then
        antiAfkConnection = player.Idled:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton1(Vector2.new())
            end)
        end)
    else
        if antiAfkConnection then antiAfkConnection:Disconnect() antiAfkConnection = nil end
    end
end

-- ============================================================
-- KILL AURA
-- ============================================================
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    updateButton(KillAuraButton, killAuraEnabled)
    if killAuraEnabled then
        killAuraConnection = RunService.Heartbeat:Connect(function()
            if not killAuraEnabled or not rootPart then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local oRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    local oHum = p.Character:FindFirstChild("Humanoid")
                    if oRoot and oHum and oHum.Health > 0 then
                        if (rootPart.Position - oRoot.Position).Magnitude <= killAuraRange then
                            local tool = char and char:FindFirstChildOfClass("Tool")
                            if tool then pcall(function() tool:Activate() end) end
                            pcall(function() oHum:TakeDamage(10) end)
                        end
                    end
                end
            end
        end)
    else
        if killAuraConnection then killAuraConnection:Disconnect() killAuraConnection = nil end
    end
end

-- ============================================================
-- ESP
-- ============================================================
local function createESP(targetChar)
    if not targetChar or espObjects[targetChar] then return end
    local folder = Instance.new("Folder")
    folder.Name = "ESP_" .. targetChar.Name
    folder.Parent = targetChar
    espObjects[targetChar] = folder

    local hl = Instance.new("Highlight")
    hl.Name = "ESPHighlight"
    hl.Adornee = targetChar
    hl.FillColor = Color3.fromRGB(espColorR, espColorG, espColorB)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = folder

    local head = targetChar:FindFirstChild("Head")
    if head then
        local bb = Instance.new("BillboardGui")
        bb.Name = "ESPBillboard"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = folder

        local nameL = Instance.new("TextLabel")
        nameL.Name = "NameLabel"
        nameL.Parent = bb
        nameL.BackgroundTransparency = 1
        nameL.Size = UDim2.new(1, 0, 0.5, 0)
        nameL.Font = Enum.Font.GothamBold
        nameL.Text = targetChar.Name
        nameL.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameL.TextScaled = true
        nameL.TextStrokeTransparency = 0
        nameL.Visible = espShowName

        local distL = Instance.new("TextLabel")
        distL.Name = "DistanceLabel"
        distL.Parent = bb
        distL.BackgroundTransparency = 1
        distL.Position = UDim2.new(0, 0, 0.5, 0)
        distL.Size = UDim2.new(1, 0, 0.5, 0)
        distL.Font = Enum.Font.Gotham
        distL.Text = "0m"
        distL.TextColor3 = Color3.fromRGB(255, 255, 255)
        distL.TextScaled = true
        distL.TextStrokeTransparency = 0
        distL.Visible = espShowDistance

        spawn(function()
            while espEnabled and targetChar and targetChar.Parent and rootPart do
                local tRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if tRoot and distL then
                    distL.Text = math.floor((rootPart.Position - tRoot.Position).Magnitude) .. "m"
                end
                wait(0.15)
            end
        end)
    end
end

local function removeESP(targetChar)
    if espObjects[targetChar] then espObjects[targetChar]:Destroy() espObjects[targetChar] = nil end
end

local function updateESPForAll()
    for _, folder in pairs(espObjects) do
        if folder and folder.Parent then
            local hl = folder:FindFirstChild("ESPHighlight")
            if hl then hl.FillColor = Color3.fromRGB(espColorR, espColorG, espColorB) end
            local bb = folder:FindFirstChild("ESPBillboard")
            if bb then
                local n = bb:FindFirstChild("NameLabel")
                local d = bb:FindFirstChild("DistanceLabel")
                if n then n.Visible = espShowName end
                if d then d.Visible = espShowDistance end
            end
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    updateButton(ESPButton, espEnabled)
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then createESP(p.Character) end
        end
        espConnection = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if espEnabled then wait(0.5) createESP(c) end
            end)
        end)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                p.CharacterAdded:Connect(function(c)
                    if espEnabled then wait(0.5) createESP(c) end
                end)
            end
        end
    else
        if espConnection then espConnection:Disconnect() end
        for tc, _ in pairs(espObjects) do removeESP(tc) end
    end
end

-- ============================================================
-- ITEM ESP
-- ============================================================
local itemEspObjects = {}
local function toggleItemEsp()
    itemEspEnabled = not itemEspEnabled
    updateButton(ItemEspBtn, itemEspEnabled)
    if itemEspEnabled then
        local function highlightItem(item)
            if itemEspObjects[item] then return end
            local hl = Instance.new("Highlight")
            hl.Adornee = item
            hl.FillColor = Color3.fromRGB(255, 200, 50)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.4
            hl.OutlineTransparency = 0
            hl.Parent = item
            itemEspObjects[item] = hl
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") then highlightItem(obj) end
        end
        itemEspConnection = workspace.DescendantAdded:Connect(function(obj)
            if itemEspEnabled and obj:IsA("Tool") then wait(0.1) highlightItem(obj) end
        end)
    else
        if itemEspConnection then itemEspConnection:Disconnect() itemEspConnection = nil end
        for item, hl in pairs(itemEspObjects) do hl:Destroy() end
        itemEspObjects = {}
    end
end

-- ============================================================
-- FULLBRIGHT
-- ============================================================
local function toggleFullbright()
    fullbrightEnabled = not fullbrightEnabled
    updateButton(FullbrightButton, fullbrightEnabled)
    if fullbrightEnabled then
        if not originalLightingSettings.Ambient then
            originalLightingSettings = {
                Ambient = Lighting.Ambient, Brightness = Lighting.Brightness,
                ColorShift_Bottom = Lighting.ColorShift_Bottom, ColorShift_Top = Lighting.ColorShift_Top,
                OutdoorAmbient = Lighting.OutdoorAmbient, FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart, GlobalShadows = Lighting.GlobalShadows
            }
        end
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
    else
        if originalLightingSettings.Ambient then
            for k, v in pairs(originalLightingSettings) do Lighting[k] = v end
        end
    end
end

-- ============================================================
-- SKYBOX
-- ============================================================
local function toggleSkybox()
    skyboxEnabled = not skyboxEnabled
    updateButton(SkyboxButton, skyboxEnabled)
    if skyboxEnabled then
        originalSky = Lighting:FindFirstChildOfClass("Sky")
        local sky = Instance.new("Sky")
        sky.Name = "CustomSky"
        sky.SkyboxBk = "rbxassetid://48152005"
        sky.SkyboxDn = "rbxassetid://48152005"
        sky.SkyboxFt = "rbxassetid://48152005"
        sky.SkyboxLf = "rbxassetid://48152005"
        sky.SkyboxRt = "rbxassetid://48152005"
        sky.SkyboxUp = "rbxassetid://48152005"
        sky.Parent = Lighting
        if originalSky then originalSky.Parent = nil end
    else
        local cs = Lighting:FindFirstChild("CustomSky")
        if cs then cs:Destroy() end
        if originalSky then originalSky.Parent = Lighting end
    end
end

-- ============================================================
-- HITBOX EXPANDER
-- ============================================================
local function toggleHitbox()
    hitboxEnabled = not hitboxEnabled
    updateButton(HitboxButton, hitboxEnabled)
    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    originalHitboxSize[hrp] = hrp.Size
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = hitboxVisible and 0.7 or 1
                    hrp.CanCollide = false
                end
            end
        end
        hitboxConnection = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if hitboxEnabled then wait(0.5)
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        originalHitboxSize[hrp] = hrp.Size
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Transparency = hitboxVisible and 0.7 or 1
                        hrp.CanCollide = false
                    end
                end
            end)
        end)
    else
        if hitboxConnection then hitboxConnection:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and originalHitboxSize[hrp] then
                    hrp.Size = originalHitboxSize[hrp]
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
        originalHitboxSize = {}
    end
end

local function toggleHitboxVisible()
    hitboxVisible = not hitboxVisible
    updateButton(HitboxVisibleButton, hitboxVisible)
    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Transparency = hitboxVisible and 0.7 or 1 end
            end
        end
    end
end

-- ============================================================
-- AIMBOT
-- ============================================================
local function getClosestPlayer()
    local closest, shortest = nil, aimbotFOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local h = p.Character:FindFirstChild("Humanoid")
            if head and h and h.Health > 0 then
                local sp, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if d < shortest then closest = p shortest = d end
                end
            end
        end
    end
    return closest
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    updateButton(AimbotButton, aimbotEnabled)
    if aimbotEnabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then return end
            local t = getClosestPlayer()
            if t and t.Character then
                local head = t.Character:FindFirstChild("Head")
                if head then
                    local cam = workspace.CurrentCamera
                    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
                end
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end

-- ============================================================
-- TRACER LINES
-- ============================================================
local tracers = {}
local function toggleTracers()
    tracerLinesEnabled = not tracerLinesEnabled
    updateButton(TracerButton, tracerLinesEnabled)
    if tracerLinesEnabled then
        tracerConnection = RunService.RenderStepped:Connect(function()
            if not tracerLinesEnabled then return end
            local cam = workspace.CurrentCamera
            local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local sp, onScreen = cam:WorldToScreenPoint(hrp.Position)
                        if onScreen then
                            if not tracers[p] then
                                local line = Drawing.new("Line")
                                line.Thickness = 2
                                line.Color = Color3.fromRGB(espColorR, espColorG, espColorB)
                                line.Transparency = 0.8
                                line.Visible = true
                                tracers[p] = line
                            end
                            tracers[p].From = screenCenter
                            tracers[p].To = Vector2.new(sp.X, sp.Y)
                            tracers[p].Visible = true
                        else
                            if tracers[p] then tracers[p].Visible = false end
                        end
                    end
                end
            end
        end)
    else
        if tracerConnection then tracerConnection:Disconnect() tracerConnection = nil end
        for _, line in pairs(tracers) do line:Remove() end
        tracers = {}
    end
end

-- ============================================================
-- HEALTH BARS
-- ============================================================
local healthBarObjects = {}
local function toggleHealthBars()
    healthBarsEnabled = not healthBarsEnabled
    updateButton(HealthBarBtn, healthBarsEnabled)
    if healthBarsEnabled then
        local function addHealthBar(p)
            if healthBarObjects[p] or not p.Character then return end
            local head = p.Character:FindFirstChild("Head")
            if not head then return end
            local bb = Instance.new("BillboardGui")
            bb.Name = "HealthBar"
            bb.Adornee = head
            bb.Size = UDim2.new(0, 40, 0, 6)
            bb.StudsOffset = Vector3.new(0, -2.5, 0)
            bb.AlwaysOnTop = true
            bb.Parent = p.Character

            local bg = Instance.new("Frame")
            bg.Name = "BG"
            bg.Parent = bb
            bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            bg.Size = UDim2.new(1, 0, 1, 0)
            addCorner(bg, 3)

            local fill = Instance.new("Frame")
            fill.Name = "Fill"
            fill.Parent = bg
            fill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            fill.Size = UDim2.new(1, 0, 1, 0)
            addCorner(fill, 3)

            healthBarObjects[p] = bb
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then addHealthBar(p) end
        end

        healthBarConnection = RunService.Heartbeat:Connect(function()
            if not healthBarsEnabled then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local h = p.Character:FindFirstChild("Humanoid")
                    if h then
                        local bb = healthBarObjects[p]
                        if not bb then
                            local head = p.Character:FindFirstChild("Head")
                            if head then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "HealthBar"
                                bb.Adornee = head
                                bb.Size = UDim2.new(0, 40, 0, 6)
                                bb.StudsOffset = Vector3.new(0, -2.5, 0)
                                bb.AlwaysOnTop = true
                                bb.Parent = p.Character
                                local bg = Instance.new("Frame")
                                bg.Name = "BG"
                                bg.Parent = bb
                                bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                                bg.Size = UDim2.new(1, 0, 1, 0)
                                addCorner(bg, 3)
                                local fill = Instance.new("Frame")
                                fill.Name = "Fill"
                                fill.Parent = bg
                                fill.Size = UDim2.new(1, 0, 1, 0)
                                addCorner(fill, 3)
                                healthBarObjects[p] = bb
                                bb = healthBarObjects[p]
                            end
                        end
                        if bb then
                            local fill = bb:FindFirstChild("BG") and bb.BG:FindFirstChild("Fill")
                            if fill then
                                local pct = h.Health / h.MaxHealth
                                fill.Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
                                if pct > 0.5 then fill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                                elseif pct > 0.25 then fill.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
                                else fill.BackgroundColor3 = Color3.fromRGB(200, 50, 50) end
                            end
                        end
                    end
                end
            end
        end)
    else
        if healthBarConnection then healthBarConnection:Disconnect() healthBarConnection = nil end
        for _, bb in pairs(healthBarObjects) do if bb then bb:Destroy() end end
        healthBarObjects = {}
    end
end

-- ============================================================
-- FPS BOOST
-- ============================================================
local function toggleFpsBoost()
    fpsBoostEnabled = not fpsBoostEnabled
    updateButton(FPSBoostBtn, fpsBoostEnabled)
    if fpsBoostEnabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        for _, e in pairs(Lighting:GetDescendants()) do
            if e:IsA("PostEffect") then e.Enabled = false end
        end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        for _, e in pairs(Lighting:GetDescendants()) do
            if e:IsA("PostEffect") then e.Enabled = true end
        end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
    end
end

-- ============================================================
-- SERVER PRIVATE
-- ============================================================
local function joinLowServer()
    ServerPrivateBtn.Text = "Поиск сервера..."
    pcall(function()
        local gameId = game.PlaceId
        local servers = game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullServers=true")
        )
        if servers and servers.data then
            local bestServer = nil
            local lowestPlayers = 999
            for _, srv in pairs(servers.data) do
                if srv.playing and srv.playing < lowestPlayers and srv.id ~= game.JobId then
                    lowestPlayers = srv.playing
                    bestServer = srv
                end
            end
            if bestServer then
                TeleportService:TeleportToPlaceInstance(gameId, bestServer.id, player)
            else
                ServerPrivateBtn.Text = "Сервер не найден"
                wait(2)
                ServerPrivateBtn.Text = "Server Private"
            end
        end
    end)
    ServerPrivateBtn.Text = "Server Private"
end
ServerPrivateBtn.MouseButton1Click:Connect(joinLowServer)

-- ============================================================
-- FLING
-- ============================================================
local function toggleFling()
    flingEnabled = not flingEnabled
    updateButton(FlingBtn, flingEnabled)
    if flingEnabled then
        flingConnection = RunService.Heartbeat:Connect(function()
            if not flingEnabled or not rootPart or not rootPart.Parent then
                if flingConnection then flingConnection:Disconnect() end
                return
            end
            rootPart.Velocity = Vector3.new(9999, 9999, 0)
            rootPart.RotVelocity = Vector3.new(0, 9999, 0)
        end)
    else
        if flingConnection then flingConnection:Disconnect() flingConnection = nil end
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end

-- ============================================================
-- FORCE SIT
-- ============================================================
local function toggleSit()
    sitEnabled = not sitEnabled
    updateButton(SitBtn, sitEnabled)
    if hum then hum.Sit = sitEnabled end
end

-- ============================================================
-- ESP SETTINGS
-- ============================================================
local function toggleEspName()
    espShowName = not espShowName
    updateButton(ESPShowNameBtn, espShowName)
    updateESPForAll()
end

local function toggleEspDist()
    espShowDistance = not espShowDistance
    updateButton(ESPShowDistBtn, espShowDistance)
    updateESPForAll()
end

local function applyEspColor()
    local r = tonumber(ESP_R.Text) or 255
    local g = tonumber(ESP_G.Text) or 50
    local b = tonumber(ESP_B.Text) or 50
    espColorR = math.clamp(r, 0, 255)
    espColorG = math.clamp(g, 0, 255)
    espColorB = math.clamp(b, 0, 255)
    updateESPForAll()
end

-- ============================================================
-- SETUP BUTTONS
-- ============================================================
dbg("Подключение кнопок...")
local function setupCheatButton(button, toggleFunc, bindName)
    local prefix = button.Text:match("^[^:]+")
    bindPrefixes[bindName] = prefix
    button.MouseButton1Click:Connect(toggleFunc)
    button.MouseButton2Click:Connect(function()
        waitingForBind = bindName
        waitingForBindButton = button
        button.Text = "Нажмите клавишу... (ESC=отмена)"
    end)
end

setupCheatButton(FlyButton, toggleFly, "fly")
setupCheatButton(InfJumpButton, toggleInfJump, "infjump")
setupCheatButton(GodModeButton, toggleGodMode, "godmode")
setupCheatButton(NoclipButton, toggleNoclip, "noclip")
setupCheatButton(SpeedButton, toggleSpeed, "speed")
setupCheatButton(FreecamButton, toggleFreecam, "freecam")
setupCheatButton(InvisibleButton, toggleInvisible, "invisible")
setupCheatButton(AntiAfkButton, toggleAntiAfk, "antiafk")
setupCheatButton(KillAuraButton, toggleKillAura, "killaura")
setupCheatButton(AimbotButton, toggleAimbot, "aimbot")
setupCheatButton(HitboxButton, toggleHitbox, "hitbox")
setupCheatButton(FullbrightButton, toggleFullbright, "fullbright")
setupCheatButton(SkyboxButton, toggleSkybox, "skybox")
setupCheatButton(TracerButton, toggleTracers, "tracer")
setupCheatButton(HealthBarBtn, toggleHealthBars, "healthbar")
setupCheatButton(ESPButton, toggleESP, "esp")
setupCheatButton(ItemEspBtn, toggleItemEsp, "itemesp")
setupCheatButton(FPSBoostBtn, toggleFpsBoost, "fpsboost")

ESPShowNameBtn.MouseButton1Click:Connect(toggleEspName)
ESPShowDistBtn.MouseButton1Click:Connect(toggleEspDist)
ApplyESPColorBtn.MouseButton1Click:Connect(applyEspColor)
FlingBtn.MouseButton1Click:Connect(toggleFling)
SitBtn.MouseButton1Click:Connect(toggleSit)

NightScriptBtn.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua", true))()
    end)
    NightScriptBtn.Text = "99 Nights загружен!"
    wait(2)
    NightScriptBtn.Text = "99 Nights in the Forest"
end)

MM2ScriptBtn.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.smokingscripts.org/vertex.lua'))()
    end)
    MM2ScriptBtn.Text = "MM2 загружен!"
    wait(2)
    MM2ScriptBtn.Text = "MM2 Script"
end)

-- ============================================================
-- KEYBINDS
-- ============================================================
dbg("Настройка биндов...")
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if waitingForBind then
        if input.KeyCode == Enum.KeyCode.Escape then
            local prefix = bindPrefixes[waitingForBind] or waitingForBind
            if waitingForBindButton then
                local oldKey = waitingForBindButton.Text:match("%[(.+)%]$") or ""
                local status = waitingForBindButton.Text:find("ON") and "ON" or "OFF"
                if oldKey ~= "" then
                    waitingForBindButton.Text = prefix .. ": " .. status .. " [" .. oldKey .. "]"
                else
                    waitingForBindButton.Text = prefix .. ": " .. status
                end
            end
            waitingForBind = nil
            waitingForBindButton = nil
            return
        end
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            if waitingForBind == "fly" then flyBind = input.KeyCode
            elseif waitingForBind == "noclip" then noclipBind = input.KeyCode
            elseif waitingForBind == "godmode" then godModeBind = input.KeyCode
            elseif waitingForBind == "infjump" then infJumpBind = input.KeyCode
            elseif waitingForBind == "speed" then speedBind = input.KeyCode
            elseif waitingForBind == "fullbright" then fullbrightBind = input.KeyCode
            elseif waitingForBind == "freecam" then freecamBind = input.KeyCode
            elseif waitingForBind == "killaura" then killAuraBind = input.KeyCode
            elseif waitingForBind == "esp" then espBind = input.KeyCode
            elseif waitingForBind == "hitbox" then hitboxBind = input.KeyCode
            elseif waitingForBind == "aimbot" then aimbotBind = input.KeyCode end

            if waitingForBindButton then
                local prefix = bindPrefixes[waitingForBind] or waitingForBind
                local status = waitingForBindButton.Text:find("ON") and "ON" or "OFF"
                waitingForBindButton.Text = prefix .. ": " .. status .. " [" .. input.KeyCode.Name .. "]"
            end
            waitingForBind = nil
            waitingForBindButton = nil
        end
    else
        if not bindingsLoaded then bindingsLoaded = true return end
        if input.KeyCode == flyBind then toggleFly()
        elseif input.KeyCode == noclipBind then toggleNoclip()
        elseif input.KeyCode == godModeBind then toggleGodMode()
        elseif input.KeyCode == infJumpBind then toggleInfJump()
        elseif input.KeyCode == speedBind then toggleSpeed()
        elseif input.KeyCode == fullbrightBind then toggleFullbright()
        elseif input.KeyCode == freecamBind then toggleFreecam()
        elseif input.KeyCode == killAuraBind then toggleKillAura()
        elseif input.KeyCode == espBind then toggleESP()
        elseif input.KeyCode == hitboxBind then toggleHitbox()
        elseif input.KeyCode == aimbotBind then toggleAimbot() end
    end
end)

-- ============================================================
-- CHARACTER RESPAWN
-- ============================================================
dbg("Character respawn handler...")
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    if flyEnabled then toggleFly() end
    if infJumpEnabled then toggleInfJump() end
    if godModeEnabled then toggleGodMode() end
    if noclipEnabled then toggleNoclip() end
    if speedEnabled then toggleSpeed() end
    if killAuraEnabled then toggleKillAura() end
    if freecamEnabled then toggleFreecam() end
    if hitboxEnabled then toggleHitbox() end
    if aimbotEnabled then toggleAimbot() end
    if invisibleEnabled then toggleInvisible() end
    if flingEnabled then toggleFling() end
end)

-- ============================================================
-- HIDE / SHOW
-- ============================================================
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowButton.Visible = true
end)
ShowButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowButton.Visible = false
end)

-- ============================================================
-- UNLOAD
-- ============================================================
UnloadButton.MouseButton1Click:Connect(function()
    if flyEnabled then toggleFly() end
    if godModeEnabled then toggleGodMode() end
    if noclipEnabled then toggleNoclip() end
    if speedEnabled then toggleSpeed() end
    if fullbrightEnabled then toggleFullbright() end
    if freecamEnabled then toggleFreecam() end
    if killAuraEnabled then toggleKillAura() end
    if espEnabled then toggleESP() end
    if hitboxEnabled then toggleHitbox() end
    if aimbotEnabled then toggleAimbot() end
    if skyboxEnabled then toggleSkybox() end
    if invisibleEnabled then toggleInvisible() end
    if antiAfkEnabled then toggleAntiAfk() end
    if itemEspEnabled then toggleItemEsp() end
    if tracerLinesEnabled then toggleTracers() end
    if healthBarsEnabled then toggleHealthBars() end
    if fpsBoostEnabled then toggleFpsBoost() end
    if flingEnabled then toggleFling() end
    musicSound:Stop()
    ScreenGui:Destroy()
end)

-- ============================================================
-- ANTI-DETECTION
-- ============================================================
dbg("Anti-detection...")
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

dbg("Anti-detection: OK")
print("[Cheat V2] ============================================")
print("[Cheat V2] Cheat by V98 v2.0 ULTIMATE загружено!")
print("[Cheat V2] Время загрузки: " .. string.format("%.2f", tick() - loadStart) .. "s")
print("[Cheat V2] ============================================")
