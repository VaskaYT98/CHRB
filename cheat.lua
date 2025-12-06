-- Roblox Cheat Menu by V98 - Версия 7.0
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

-- Переменные состояния
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
local currentFlyType = "normal"  -- normal, bhop, bounce, glide
local teleportByClickEnabled = false
local teleportToPlayerEnabled = false
local espShowName = true
local espShowDistance = true
local hitboxVisible = false
local espColorR = 255
local espColorG = 50
local espColorB = 50
local menuColorR = 35
local menuColorG = 35
local menuColorB = 45
local defaultSpeed = 16
local customSpeed = 50
local flySpeed = 50
local killAuraRange = 20
local hitboxSize = 5
local aimbotFOV = 200
local originalLightingSettings = {}
local freecamCFrame = nil
local espObjects = {}
local hitboxObjects = {}
local bindingsLoaded = false
local currentTab = "main"
local originalHitboxSize = {}
local aimbotConnection = nil
local originalSky = nil
local walljumpEnabled = false
local fakeLagEnabled = false
local autoClickerEnabled = false
local autoClickerSpeed = 10
local selectedPlayerForTP = nil
local invisibilityEnabled = false
local itemESPEnabled = false
local fpsBoostEnabled = false
local serverPrivateEnabled = false
local antiAFKEnabled = false
local tracerLinesEnabled = false
local healthBarsEnabled = false
local outfitCopierEnabled = false
local trollToolsEnabled = false
local musicID = ""
local currentTheme = "dark"
local scriptEditorCode = ""

-- Биндинги
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

local waitingForBind = nil

-- GUI Создание
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ResizeHandle = Instance.new("TextButton")
local TopBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local HideButton = Instance.new("TextButton")
local TabButtonsFrame = Instance.new("Frame")
local MainTabButton = Instance.new("TextButton")
local PvPTabButton = Instance.new("TextButton")
local VisualsTabButton = Instance.new("TextButton")
local SettingsTabButton = Instance.new("TextButton")
local ExtrasTabButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local MainPage = Instance.new("ScrollingFrame")
local PvPPage = Instance.new("ScrollingFrame")
local VisualsPage = Instance.new("ScrollingFrame")
local SettingsPage = Instance.new("ScrollingFrame")
local ExtrasPage = Instance.new("ScrollingFrame")
local ShowButton = Instance.new("TextButton")

-- Настройка GUI
ScreenGui.Name = "CheatMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Главный фрейм
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(menuColorR, menuColorG, menuColorB)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false

-- Ручка изменения размера
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Parent = MainFrame
ResizeHandle.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.Text = "⬀"
ResizeHandle.TextColor3 = Color3.fromRGB(200, 200, 200)
ResizeHandle.TextSize = 14
ResizeHandle.ZIndex = 10

-- Система изменения размера
local resizing = false
local resizeStart = nil
local startSize = nil

ResizeHandle.MouseButton1Down:Connect(function()
    resizing = true
    resizeStart = game:GetService("UserInputService"):GetMouseLocation()
    startSize = MainFrame.Size
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if resizing then
        local mouse = game:GetService("UserInputService"):GetMouseLocation()
        local delta = mouse - resizeStart
        local newWidth = math.max(400, startSize.X.Offset + delta.X)
        local newHeight = math.max(400, startSize.Y.Offset + delta.Y)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Верхняя панель
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Cheat by V98 | v8.0 ULTIMATE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

HideButton.Name = "HideButton"
HideButton.Parent = TopBar
HideButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HideButton.BorderSizePixel = 0
HideButton.Position = UDim2.new(1, -35, 0, 5)
HideButton.Size = UDim2.new(0, 30, 0, 25)
HideButton.Font = Enum.Font.GothamBold
HideButton.Text = "X"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 14

-- Фрейм для кнопок вкладок
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Parent = MainFrame
TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TabButtonsFrame.BorderSizePixel = 0
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 35)
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 85)

-- Кнопки вкладок
MainTabButton.Name = "MainTabButton"
MainTabButton.Parent = TabButtonsFrame
MainTabButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
MainTabButton.BorderSizePixel = 0
MainTabButton.Position = UDim2.new(0, 5, 0, 5)
MainTabButton.Size = UDim2.new(0.23, 0, 0, 35)
MainTabButton.Font = Enum.Font.GothamBold
MainTabButton.Text = "🎮 ОСНОВНЫЕ"
MainTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabButton.TextSize = 11

PvPTabButton.Name = "PvPTabButton"
PvPTabButton.Parent = TabButtonsFrame
PvPTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
PvPTabButton.BorderSizePixel = 0
PvPTabButton.Position = UDim2.new(0.25, 0, 0, 5)
PvPTabButton.Size = UDim2.new(0.23, 0, 0, 35)
PvPTabButton.Font = Enum.Font.GothamBold
PvPTabButton.Text = "⚔️ PVP"
PvPTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PvPTabButton.TextSize = 11

VisualsTabButton.Name = "VisualsTabButton"
VisualsTabButton.Parent = TabButtonsFrame
VisualsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
VisualsTabButton.BorderSizePixel = 0
VisualsTabButton.Position = UDim2.new(0.5, 0, 0, 5)
VisualsTabButton.Size = UDim2.new(0.23, 0, 0, 35)
VisualsTabButton.Font = Enum.Font.GothamBold
VisualsTabButton.Text = "💡 ВИЗУАЛЫ"
VisualsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualsTabButton.TextSize = 11

SettingsTabButton.Name = "SettingsTabButton"
SettingsTabButton.Parent = TabButtonsFrame
SettingsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SettingsTabButton.BorderSizePixel = 0
SettingsTabButton.Position = UDim2.new(0.75, 0, 0, 5)
SettingsTabButton.Size = UDim2.new(0.23, -5, 0, 35)
SettingsTabButton.Font = Enum.Font.GothamBold
SettingsTabButton.Text = "⚙️ НАСТРОЙКИ"
SettingsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTabButton.TextSize = 11

ExtrasTabButton.Name = "ExtrasTabButton"
ExtrasTabButton.Parent = TabButtonsFrame
ExtrasTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ExtrasTabButton.BorderSizePixel = 0
ExtrasTabButton.Position = UDim2.new(0, 5, 0, 47)
ExtrasTabButton.Size = UDim2.new(0.196, 0, 0, 35)
ExtrasTabButton.Font = Enum.Font.GothamBold
ExtrasTabButton.Text = "🎁 ДОПОЛНИТЕЛЬНО"
ExtrasTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExtrasTabButton.TextSize = 10

-- Фрейм контента
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 120)
ContentFrame.Size = UDim2.new(1, 0, 1, -160)

-- Панель информации об игроке
local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Name = "PlayerInfoFrame"
PlayerInfoFrame.Parent = MainFrame
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerInfoFrame.BorderSizePixel = 0
PlayerInfoFrame.Position = UDim2.new(0, 0, 1, -40)
PlayerInfoFrame.Size = UDim2.new(1, 0, 0, 40)

local PlayerAvatar = Instance.new("ImageLabel")
PlayerAvatar.Name = "PlayerAvatar"
PlayerAvatar.Parent = PlayerInfoFrame
PlayerAvatar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
PlayerAvatar.BorderSizePixel = 0
PlayerAvatar.Position = UDim2.new(0, 5, 0, 3)
PlayerAvatar.Size = UDim2.new(0, 34, 0, 34)
PlayerAvatar.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Name = "PlayerLabel"
PlayerLabel.Parent = PlayerInfoFrame
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.Position = UDim2.new(0, 45, 0, 2)
PlayerLabel.Size = UDim2.new(1, -50, 0, 18)
PlayerLabel.Font = Enum.Font.GothamBold
PlayerLabel.Text = game.Players.LocalPlayer.Name .. " [" .. game.Players.LocalPlayer.UserId .. "]"
PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerLabel.TextSize = 11
PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left

local PlayerStatsLabel = Instance.new("TextLabel")
PlayerStatsLabel.Name = "PlayerStatsLabel"
PlayerStatsLabel.Parent = PlayerInfoFrame
PlayerStatsLabel.BackgroundTransparency = 1
PlayerStatsLabel.Position = UDim2.new(0, 45, 0, 20)
PlayerStatsLabel.Size = UDim2.new(1, -50, 0, 16)
PlayerStatsLabel.Font = Enum.Font.Gotham
PlayerStatsLabel.Text = "Версия 9.0 ULTIMATE | Авто"
PlayerStatsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PlayerStatsLabel.TextSize = 10
PlayerStatsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Функция создания страницы
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentFrame
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 10, 0, 0)
    page.Size = UDim2.new(1, -20, 1, -10)
    page.CanvasSize = UDim2.new(0, 0, 0, 1000)
    page.ScrollBarThickness = 6
    page.BorderSizePixel = 0
    page.Visible = false
    return page
end

MainPage = createPage("MainPage")
PvPPage = createPage("PvPPage")
VisualsPage = createPage("VisualsPage")
SettingsPage = createPage("SettingsPage")
ExtrasPage = createPage("ExtrasPage")
MainPage.Visible = true

-- Кнопка показать
ShowButton.Name = "ShowButton"
ShowButton.Parent = ScreenGui
ShowButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ShowButton.BorderSizePixel = 0
ShowButton.Position = UDim2.new(0, 10, 0, 10)
ShowButton.Size = UDim2.new(0, 130, 0, 45)
ShowButton.Font = Enum.Font.GothamBold
ShowButton.Text = "📂 Открыть меню"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextSize = 12
ShowButton.Visible = false

-- Функции создания элементов
local function createCheatButton(parent, name, text, yPos)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.Size = UDim2.new(1, 0, 0, 45)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    return button
end

local function createLabel(parent, text, yPos)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    label.BorderSizePixel = 0
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    return label
end

local function createSlider(parent, name, text, minVal, maxVal, defaultVal, yPos, callback)
    local container = Instance.new("Frame")
    container.Name = name
    container.Parent = parent
    container.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.Size = UDim2.new(1, 0, 0, 60)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = container
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sliderBg.BorderSizePixel = 0
    sliderBg.Position = UDim2.new(0.05, 0, 0, 30)
    sliderBg.Size = UDim2.new(0.9, 0, 0, 20)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderBg
    sliderButton.BackgroundColor3 = Color3.fromRGB(70, 170, 70)
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -5, 0.5, -10)
    sliderButton.Size = UDim2.new(0, 10, 0, 20)
    sliderButton.Text = ""
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local relativeX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relativeX / sliderBg.AbsoluteSize.X
            local value = math.floor(minVal + (maxVal - minVal) * percent)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderButton.Position = UDim2.new(percent, -5, 0.5, -10)
            label.Text = text .. ": " .. value
            
            callback(value)
        end
    end)
    
    return container
end

local function createTextBox(parent, name, placeholder, yPos)
    local textBox = Instance.new("TextBox")
    textBox.Name = name
    textBox.Parent = parent
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    textBox.BorderSizePixel = 0
    textBox.Position = UDim2.new(0, 0, 0, yPos)
    textBox.Size = UDim2.new(1, 0, 0, 35)
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 12
    textBox.ClearTextOnFocus = false
    return textBox
end

local function updateButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        button.Text = button.Text:gsub("OFF", "ON")
    else
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        button.Text = button.Text:gsub("ON", "OFF")
    end
end

-- Создание страниц
local mainY = 0
local pvpY = 0
local visualsY = 0
local settingsY = 0

-- ОСНОВНЫЕ ЧИТЫ
createLabel(MainPage, "🎮 ОСНОВНЫЕ ЧИТЫ", mainY)
mainY = mainY + 35
local FlyButton = createCheatButton(MainPage, "FlyButton", "✈️ Fly: OFF [F]", mainY)
mainY = mainY + 50
local InfJumpButton = createCheatButton(MainPage, "InfJumpButton", "🦘 Inf Jump: OFF [J]", mainY)
mainY = mainY + 50
local GodModeButton = createCheatButton(MainPage, "GodModeButton", "🛡️ God Mode: OFF [G]", mainY)
mainY = mainY + 50
local NoclipButton = createCheatButton(MainPage, "NoclipButton", "👻 Noclip: OFF [N]", mainY)
mainY = mainY + 50
local SpeedButton = createCheatButton(MainPage, "SpeedButton", "🏃 Speed: OFF [V]", mainY)
mainY = mainY + 50
local FreecamButton = createCheatButton(MainPage, "FreecamButton", "📷 Freecam: OFF [C]", mainY)
mainY = mainY + 50
MainPage.CanvasSize = UDim2.new(0, 0, 0, mainY)

-- PVP ЧИТЫ
createLabel(PvPPage, "⚔️ PVP ЧИТЫ", pvpY)
pvpY = pvpY + 35
local KillAuraButton = createCheatButton(PvPPage, "KillAuraButton", "⚔️ Kill Aura: OFF [K]", pvpY)
pvpY = pvpY + 50
local ESPButton = createCheatButton(PvPPage, "ESPButton", "👁️ ESP: OFF [E]", pvpY)
pvpY = pvpY + 50
local HitboxButton = createCheatButton(PvPPage, "HitboxButton", "📦 Hitbox: OFF [H]", pvpY)
pvpY = pvpY + 50
local AimbotButton = createCheatButton(PvPPage, "AimbotButton", "🎯 Aimbot: OFF [X]", pvpY)
pvpY = pvpY + 55

createLabel(PvPPage, "⚙️ НАСТРОЙКИ PVP", pvpY)
pvpY = pvpY + 35
createSlider(PvPPage, "KillAuraSlider", "Kill Aura радиус", 5, 50, 20, pvpY, function(value)
    killAuraRange = value
end)
pvpY = pvpY + 65
createSlider(PvPPage, "HitboxSlider", "Размер хитбокса", 1, 20, 5, pvpY, function(value)
    hitboxSize = value
    if hitboxEnabled then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                end
            end
        end
    end
end)
pvpY = pvpY + 65
local HitboxVisibleButton = createCheatButton(PvPPage, "HitboxVisibleButton", "Видимость хитбокса: OFF", pvpY)
pvpY = pvpY + 50
createSlider(PvPPage, "AimbotFOVSlider", "Aimbot FOV", 50, 500, 200, pvpY, function(value)
    aimbotFOV = value
end)
pvpY = pvpY + 65
PvPPage.CanvasSize = UDim2.new(0, 0, 0, pvpY)

-- ВИЗУАЛЫ
createLabel(VisualsPage, "💡 ВИЗУАЛЬНЫЕ ЭФФЕКТЫ", visualsY)
visualsY = visualsY + 35
local FullbrightButton = createCheatButton(VisualsPage, "FullbrightButton", "💡 Fullbright: OFF [B]", visualsY)
visualsY = visualsY + 50
local SkyboxButton = createCheatButton(VisualsPage, "SkyboxButton", "🌌 Custom Skybox: OFF", visualsY)
visualsY = visualsY + 55

createLabel(VisualsPage, "🎨 НАСТРОЙКИ ESP", visualsY)
visualsY = visualsY + 35
local ESPShowNameButton = createCheatButton(VisualsPage, "ESPShowNameButton", "ESP - Имя: ON", visualsY)
visualsY = visualsY + 50
local ESPShowDistanceButton = createCheatButton(VisualsPage, "ESPShowDistanceButton", "ESP - Дистанция: ON", visualsY)
visualsY = visualsY + 55

createLabel(VisualsPage, "🌈 ЦВЕТ ESP (RGB)", visualsY)
visualsY = visualsY + 35
local RTextBox = createTextBox(VisualsPage, "RTextBox", "R (0-255): 255", visualsY)
visualsY = visualsY + 40
local GTextBox = createTextBox(VisualsPage, "GTextBox", "G (0-255): 50", visualsY)
visualsY = visualsY + 40
local BTextBox = createTextBox(VisualsPage, "BTextBox", "B (0-255): 50", visualsY)
visualsY = visualsY + 40
local ApplyESPColorButton = createCheatButton(VisualsPage, "ApplyESPColorButton", "✅ Применить цвет ESP", visualsY)
ApplyESPColorButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
visualsY = visualsY + 55

createLabel(VisualsPage, "🎨 НАСТРОЙКИ ОСВЕЩЕНИЯ", visualsY)
visualsY = visualsY + 35
createSlider(VisualsPage, "BrightnessSlider", "Яркость", 0, 10, 2, visualsY, function(value)
    game:GetService("Lighting").Brightness = value
end)
visualsY = visualsY + 65
createSlider(VisualsPage, "AmbientSlider", "Ambient (освещение)", 0, 255, 128, visualsY, function(value)
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.fromRGB(value, value, value)
end)
visualsY = visualsY + 65
VisualsPage.CanvasSize = UDim2.new(0, 0, 0, visualsY)

-- НАСТРОЙКИ
createLabel(SettingsPage, "⚙️ ОСНОВНЫЕ НАСТРОЙКИ", settingsY)
settingsY = settingsY + 35
createSlider(SettingsPage, "FlySpeedSlider", "Скорость полёта", 10, 200, 50, settingsY, function(value)
    flySpeed = value
end)
settingsY = settingsY + 65
createSlider(SettingsPage, "SpeedSlider", "Скорость ходьбы", 16, 200, 50, settingsY, function(value)
    customSpeed = value
    if speedEnabled then
        hum.WalkSpeed = customSpeed
    end
end)
settingsY = settingsY + 70

createLabel(SettingsPage, "🎨 ЦВЕТ МЕНЮ (RGB)", settingsY)
settingsY = settingsY + 35
local MenuRTextBox = createTextBox(SettingsPage, "MenuRTextBox", "R (0-255): 35", settingsY)
settingsY = settingsY + 40
local MenuGTextBox = createTextBox(SettingsPage, "MenuGTextBox", "G (0-255): 35", settingsY)
settingsY = settingsY + 40
local MenuBTextBox = createTextBox(SettingsPage, "MenuBTextBox", "B (0-255): 45", settingsY)
settingsY = settingsY + 40
local ApplyMenuColorButton = createCheatButton(SettingsPage, "ApplyMenuColorButton", "✅ Применить цвет меню", settingsY)
ApplyMenuColorButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
settingsY = settingsY + 55

createLabel(SettingsPage, "🗑️ УПРАВЛЕНИЕ", settingsY)
settingsY = settingsY + 35
local UnloadButton = createCheatButton(SettingsPage, "UnloadButton", "❌ ВЫГРУЗИТЬ ЧИТ", settingsY)
UnloadButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
settingsY = settingsY + 50
SettingsPage.CanvasSize = UDim2.new(0, 0, 0, settingsY)

-- ДОПОЛНИТЕЛЬНО (СКРИПТЫ)
createLabel(ExtrasPage, "🎁 ВСТРОЕННЫЕ СКРИПТЫ", 0)
local extrasY = 35

createLabel(ExtrasPage, "🎯 ТЕЛЕПОРТАЦИЯ", extrasY)
extrasY = extrasY + 35

local TPClickButton
local PlayerListButton
local SelectedPlayerLabel
local TPSelectedButton
local NightScriptButton
local BloxFruitScriptButton
local FlyNormalButton
local FlyBhopButton
local FlyBounceButton
local FlyGlideButton
local InvisibilityButton
local ItemESPButton
local FPSBoostButton
local ServerPrivateButton
local AntiAFKButton
local TracerLinesButton
local HealthBarsButton
local OutfitCopierButton
local TrollToolsButton
local MusicIDTextBox
local PlayMusicButton
local StopMusicButton
local ServerInfoButton
local PlayerAnalyticsButton
local ScriptEditorButton
local ThemeDarkButton
local ThemeLightButton
local ThemeCyberpunkButton
local SaveConfigButton
local LoadConfigButton
local DupeItemsButton

TPClickButton = createCheatButton(ExtrasPage, "TPClickButton", "📍 ТП по клику: OFF", extrasY)
extrasY = extrasY + 50

PlayerListButton = createCheatButton(ExtrasPage, "PlayerListButton", "📋 Показать игроков", extrasY)
PlayerListButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
extrasY = extrasY + 50

SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Name = "SelectedPlayerLabel"
SelectedPlayerLabel.Parent = ExtrasPage
SelectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SelectedPlayerLabel.BorderSizePixel = 0
SelectedPlayerLabel.Position = UDim2.new(0, 0, 0, extrasY)
SelectedPlayerLabel.Size = UDim2.new(1, 0, 0, 30)
SelectedPlayerLabel.Font = Enum.Font.Gotham
SelectedPlayerLabel.Text = "❌ Игрок не выбран"
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
SelectedPlayerLabel.TextSize = 12
extrasY = extrasY + 35

TPSelectedButton = createCheatButton(ExtrasPage, "TPSelectedButton", "✅ Телепортироваться", extrasY)
TPSelectedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
extrasY = extrasY + 55

createLabel(ExtrasPage, "📜 ПОПУЛЯРНЫЕ СКРИПТЫ", extrasY)
extrasY = extrasY + 35

NightScriptButton = createCheatButton(ExtrasPage, "NightScriptButton", "🌙 99 Nights in the Forest", extrasY)
NightScriptButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
extrasY = extrasY + 50

BloxFruitScriptButton = createCheatButton(ExtrasPage, "BloxFruitScriptButton", "👹 Forsaken Script", extrasY)
BloxFruitScriptButton.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
extrasY = extrasY + 55

createLabel(ExtrasPage, "✈️ ТИПЫ ПОЛЕТА", extrasY)
extrasY = extrasY + 35

FlyNormalButton = createCheatButton(ExtrasPage, "FlyNormalButton", "🔵 Обычный полет", extrasY)
extrasY = extrasY + 50
FlyBhopButton = createCheatButton(ExtrasPage, "FlyBhopButton", "🟠 BHOP (анти-чит)", extrasY)
extrasY = extrasY + 50
FlyBounceButton = createCheatButton(ExtrasPage, "FlyBounceButton", "🟡 Bounce полет", extrasY)
extrasY = extrasY + 50
FlyGlideButton = createCheatButton(ExtrasPage, "FlyGlideButton", "🟢 Glide парящий", extrasY)
extrasY = extrasY + 55

createLabel(ExtrasPage, "⚡ ПРОДВИНУТЫЕ ЧИТЫ", extrasY)
extrasY = extrasY + 35

local InvisibilityButton = createCheatButton(ExtrasPage, "InvisibilityButton", "👻 Невидимость: OFF", extrasY)
extrasY = extrasY + 50

local ItemESPButton = createCheatButton(ExtrasPage, "ItemESPButton", "📦 Item ESP: OFF", extrasY)
extrasY = extrasY + 50

local FPSBoostButton = createCheatButton(ExtrasPage, "FPSBoostButton", "⚡ FPS Boost: OFF", extrasY)
extrasY = extrasY + 50

local ServerPrivateButton = createCheatButton(ExtrasPage, "ServerPrivateButton", "🔒 Server Private: OFF", extrasY)
extrasY = extrasY + 50

local AntiAFKButton = createCheatButton(ExtrasPage, "AntiAFKButton", "🔄 Anti-AFK: OFF", extrasY)
extrasY = extrasY + 50

local TracerLinesButton = createCheatButton(ExtrasPage, "TracerLinesButton", "📍 Tracer Lines: OFF", extrasY)
extrasY = extrasY + 50

local HealthBarsButton = createCheatButton(ExtrasPage, "HealthBarsButton", "❤️ Health Bars: OFF", extrasY)
extrasY = extrasY + 50

local OutfitCopierButton = createCheatButton(ExtrasPage, "OutfitCopierButton", "👕 Outfit Copier: OFF", extrasY)
extrasY = extrasY + 50

local TrollToolsButton = createCheatButton(ExtrasPage, "TrollToolsButton", "😈 Troll Tools: OFF", extrasY)
extrasY = extrasY + 55

createLabel(ExtrasPage, "💾 СОХРАНЕНИЕ КОНФИГОВ", extrasY)
extrasY = extrasY + 35

SaveConfigButton = createCheatButton(ExtrasPage, "SaveConfigButton", "💾 Сохранить конфиг", extrasY)
SaveConfigButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
extrasY = extrasY + 50

LoadConfigButton = createCheatButton(ExtrasPage, "LoadConfigButton", "📂 Загрузить конфиг", extrasY)
LoadConfigButton.BackgroundColor3 = Color3.fromRGB(100, 150, 50)
extrasY = extrasY + 55

createLabel(ExtrasPage, "🎵 МУЗЫКА", extrasY)
extrasY = extrasY + 35

local MusicIDTextBox = createTextBox(ExtrasPage, "MusicIDTextBox", "Введите ID музыки...", extrasY)
extrasY = extrasY + 40

local PlayMusicButton = createCheatButton(ExtrasPage, "PlayMusicButton", "▶️ Проиграть музыку", extrasY)
PlayMusicButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
extrasY = extrasY + 50

local StopMusicButton = createCheatButton(ExtrasPage, "StopMusicButton", "⏹️ Остановить музыку", extrasY)
StopMusicButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
extrasY = extrasY + 55

createLabel(ExtrasPage, "📊 ИНФОРМАЦИЯ О СЕРВЕРЕ", extrasY)
extrasY = extrasY + 35

local ServerInfoButton = createCheatButton(ExtrasPage, "ServerInfoButton", "ℹ️ Информация сервера", extrasY)
ServerInfoButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
extrasY = extrasY + 50

local PlayerAnalyticsButton = createCheatButton(ExtrasPage, "PlayerAnalyticsButton", "📈 Аналитика игроков", extrasY)
PlayerAnalyticsButton.BackgroundColor3 = Color3.fromRGB(100, 150, 50)
extrasY = extrasY + 55

createLabel(ExtrasPage, "🎨 РЕДАКТОР СКРИПТОВ", extrasY)
extrasY = extrasY + 35

local ScriptEditorButton = createCheatButton(ExtrasPage, "ScriptEditorButton", "✍️ Редактор скриптов", extrasY)
ScriptEditorButton.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
extrasY = extrasY + 50

createLabel(ExtrasPage, "🎨 СИСТЕМА ТЕМ", extrasY)
extrasY = extrasY + 35

local ThemeDarkButton = createCheatButton(ExtrasPage, "ThemeDarkButton", "🌙 Тёмная тема", extrasY)
ThemeDarkButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
extrasY = extrasY + 50

local ThemeLightButton = createCheatButton(ExtrasPage, "ThemeLightButton", "☀️ Светлая тема", extrasY)
ThemeLightButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
extrasY = extrasY + 50

local ThemeCyberpunkButton = createCheatButton(ExtrasPage, "ThemeCyberpunkButton", "⚡ Киберпанк тема", extrasY)
ThemeCyberpunkButton.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
extrasY = extrasY + 55

createLabel(ExtrasPage, "🎁 ДОПОЛНИТЕЛЬНО", extrasY)
extrasY = extrasY + 35

DupeItemsButton = createCheatButton(ExtrasPage, "DupeItemsButton", "📦 Дюп предметов (v2)", extrasY)
DupeItemsButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
extrasY = extrasY + 50

ExtrasPage.CanvasSize = UDim2.new(0, 0, 0, extrasY)

-- Функция переключения вкладок
local function switchTab(tab)
    currentTab = tab
    MainPage.Visible = false
    PvPPage.Visible = false
    VisualsPage.Visible = false
    SettingsPage.Visible = false
    ExtrasPage.Visible = false
    
    MainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    PvPTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    VisualsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SettingsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ExtrasTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    
    if tab == "main" then
        MainPage.Visible = true
        MainTabButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif tab == "pvp" then
        PvPPage.Visible = true
        PvPTabButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif tab == "visuals" then
        VisualsPage.Visible = true
        VisualsTabButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif tab == "settings" then
        SettingsPage.Visible = true
        SettingsTabButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif tab == "extras" then
        ExtrasPage.Visible = true
        ExtrasTabButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    end
end

-- ФУНКЦИИ ЧИТОВ

-- Fly
local flying = false
local function toggleFly()
    flyEnabled = not flyEnabled
    updateButton(FlyButton, flyEnabled)
    
    if flyEnabled then
        flying = true
        spawn(function()
            local uis = game:GetService("UserInputService")
            local runService = game:GetService("RunService")
            wait(0.1)
            
            local connection
            connection = runService.Heartbeat:Connect(function(delta)
                if not flying or not flyEnabled or not rootPart then
                    connection:Disconnect()
                    return
                end
                
                local cam = workspace.CurrentCamera
                local direction = Vector3.new(0, 0, 0)
                
                if uis:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                
                if direction.Magnitude > 0 then direction = direction.Unit end
                
                local speed = flySpeed
                if currentFlyType == "bhop" then speed = flySpeed * 1.5 end
                if currentFlyType == "bounce" then speed = flySpeed * 0.8 end
                if currentFlyType == "glide" then speed = flySpeed * 0.6 end
                
                local newPos = rootPart.Position + (direction * speed * delta)
                rootPart.CFrame = CFrame.new(newPos)
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
            end)
        end)
    else
        flying = false
    end
end

-- Функции типов полета
local function setFlyType(flyType)
    currentFlyType = flyType
    
    FlyNormalButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    FlyBhopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    FlyBounceButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    FlyGlideButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    
    if flyType == "normal" then
        FlyNormalButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif flyType == "bhop" then
        FlyBhopButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif flyType == "bounce" then
        FlyBounceButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif flyType == "glide" then
        FlyGlideButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end

-- Invisibility (Невидимость)
local function toggleInvisibility()
    invisibilityEnabled = not invisibilityEnabled
    updateButton(InvisibilityButton, invisibilityEnabled)
    
    if invisibilityEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

-- Item ESP
local itemESPObjects = {}
local function toggleItemESP()
    itemESPEnabled = not itemESPEnabled
    updateButton(ItemESPButton, itemESPEnabled)
    
    if itemESPEnabled then
        spawn(function()
            while itemESPEnabled do
                for _, item in pairs(workspace:FindPartBySelectorAll("[class=Model]")) do
                    if not itemESPObjects[item] and item:FindFirstChild("Handle") then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = item
                        highlight.FillColor = Color3.fromRGB(100, 200, 100)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineTransparency = 0
                        highlight.Parent = item
                        itemESPObjects[item] = highlight
                    end
                end
                wait(0.5)
            end
        end)
    else
        for _, highlight in pairs(itemESPObjects) do
            if highlight then highlight:Destroy() end
        end
        itemESPObjects = {}
    end
end

-- FPS Boost
local fpsBoostConnection
local function toggleFPSBoost()
    fpsBoostEnabled = not fpsBoostEnabled
    updateButton(FPSBoostButton, fpsBoostEnabled)
    
    if fpsBoostEnabled then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 9e9
        
        for _, obj in pairs(workspace:FindPartBySelectorAll("[class=BasePart]")) do
            if obj and obj:IsA("BasePart") then
                obj.CanCollide = obj:IsDescendantOf(char) or obj:IsDescendantOf(game.Players)
            end
        end
        
        fpsBoostConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not fpsBoostEnabled then return end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if fpsBoostConnection then fpsBoostConnection:Disconnect() end
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").FogEnd = 500
    end
end

-- Server Private (приватный сервер)
local function joinPrivateServer()
    serverPrivateEnabled = not serverPrivateEnabled
    updateButton(ServerPrivateButton, serverPrivateEnabled)
    
    if serverPrivateEnabled then
        pcall(function()
            local players = game:GetService("Players"):GetPlayers()
            if #players > 1 then
                local targetPlayer = nil
                for _, p in pairs(players) do
                    if p ~= game.Players.LocalPlayer then
                        targetPlayer = p
                        break
                    end
                end
                
                if targetPlayer and targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        rootPart.CFrame = CFrame.new(targetRoot.Position + Vector3.new(100, 100, 100))
                    end
                end
            end
        end)
        ServerPrivateButton.Text = "✅ Перемещение..."
        wait(1)
        ServerPrivateButton.Text = "🔒 Server Private: ON"
    end
end

-- Anti-AFK
local antiAFKConnection
local function toggleAntiAFK()
    antiAFKEnabled = not antiAFKEnabled
    updateButton(AntiAFKButton, antiAFKEnabled)
    
    if antiAFKEnabled then
        antiAFKConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not antiAFKEnabled then return end
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0))
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0))
            end)
        end)
    else
        if antiAFKConnection then antiAFKConnection:Disconnect() end
    end
end

-- Tracer Lines
local tracerObjects = {}
local function toggleTracerLines()
    tracerLinesEnabled = not tracerLinesEnabled
    updateButton(TracerLinesButton, tracerLinesEnabled)
    
    if tracerLinesEnabled then
        spawn(function()
            while tracerLinesEnabled do
                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= game.Players.LocalPlayer and otherPlayer.Character then
                        local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if otherRoot and rootPart then
                            if not tracerObjects[otherPlayer] then
                                local line = Drawing.new("Line")
                                line.Color = Color3.fromRGB(255, 0, 0)
                                line.Thickness = 2
                                tracerObjects[otherPlayer] = line
                            end
                            
                            local screenPos1, onScreen1 = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
                            local screenPos2, onScreen2 = workspace.CurrentCamera:WorldToScreenPoint(otherRoot.Position)
                            
                            if onScreen1 and onScreen2 then
                                tracerObjects[otherPlayer].From = Vector2.new(screenPos1.X, screenPos1.Y)
                                tracerObjects[otherPlayer].To = Vector2.new(screenPos2.X, screenPos2.Y)
                                tracerObjects[otherPlayer].Visible = true
                            else
                                tracerObjects[otherPlayer].Visible = false
                            end
                        end
                    end
                end
                wait(0.016)
            end
        end)
    else
        for _, line in pairs(tracerObjects) do
            if line then line:Remove() end
        end
        tracerObjects = {}
    end
end

-- Health Bars
local healthBarObjects = {}
local function toggleHealthBars()
    healthBarsEnabled = not healthBarsEnabled
    updateButton(HealthBarsButton, healthBarsEnabled)
    
    if healthBarsEnabled then
        spawn(function()
            while healthBarsEnabled do
                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= game.Players.LocalPlayer and otherPlayer.Character then
                        local head = otherPlayer.Character:FindFirstChild("Head")
                        local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                        
                        if head and humanoid then
                            if not healthBarObjects[otherPlayer] then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Parent = head
                                billboard.Size = UDim2.new(3, 0, 0.5, 0)
                                billboard.StudsOffset = Vector3.new(0, 2, 0)
                                billboard.AlwaysOnTop = true
                                
                                local healthBar = Instance.new("Frame")
                                healthBar.Parent = billboard
                                healthBar.Size = UDim2.new(1, 0, 1, 0)
                                healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                healthBar.BorderSizePixel = 0
                                
                                healthBarObjects[otherPlayer] = {billboard = billboard, bar = healthBar}
                            end
                            
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            healthBarObjects[otherPlayer].bar.Size = UDim2.new(healthPercent, 0, 1, 0)
                            healthBarObjects[otherPlayer].bar.BackgroundColor3 = Color3.fromRGB(
                                255 * (1 - healthPercent),
                                255 * healthPercent,
                                0
                            )
                        end
                    end
                end
                wait(0.1)
            end
        end)
    else
        for _, obj in pairs(healthBarObjects) do
            if obj.billboard then obj.billboard:Destroy() end
        end
        healthBarObjects = {}
    end
end

-- Outfit Copier
local function copyOutfit()
    local mouse = game:GetService("UserInputService"):GetMouseLocation()
    local camera = workspace.CurrentCamera
    local rayOrigin = camera.CFrame.Position
    local rayDirection = (camera.CFrame * CFrame.new(0, 0, -1)).Position - rayOrigin
    
    local raycastResult = workspace:FindPartOnRay(Ray.new(rayOrigin, rayDirection.Unit * 1000))
    
    if raycastResult then
        local targetPlayer = game.Players:FindFirstChild(raycastResult.Parent.Name)
        if targetPlayer and targetPlayer.Character then
            for _, clothing in pairs(targetPlayer.Character:GetChildren()) do
                if clothing:IsA("Accessory") or clothing:IsA("Clothing") or clothing:IsA("BodyColors") then
                    local clone = clothing:Clone()
                    clone.Parent = char
                end
            end
            OutfitCopierButton.Text = "✅ Внешность скопирована!"
            wait(1)
            OutfitCopierButton.Text = "👕 Outfit Copier: OFF"
        end
    end
end

-- Troll Tools
local function showTrollTools()
    trollToolsEnabled = not trollToolsEnabled
    updateButton(TrollToolsButton, trollToolsEnabled)
    
    if trollToolsEnabled then
        TrollToolsButton.Text = "✅ Инструменты активированы!"
        wait(1)
        TrollToolsButton.Text = "😈 Troll Tools: ON"
    end
end

-- Music Player
local currentMusic = nil
local function playMusic()
    if musicID == "" then
        musicID = MusicIDTextBox.Text
    end
    
    if musicID ~= "" then
        if currentMusic then
            currentMusic:Destroy()
        end
        
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. musicID
        sound.Volume = 0.5
        sound.Parent = workspace
        sound:Play()
        
        currentMusic = sound
        PlayMusicButton.Text = "▶️ Проигрывается..."
        wait(1)
        PlayMusicButton.Text = "▶️ Проиграть музыку"
    end
end

local function stopMusic()
    if currentMusic then
        currentMusic:Stop()
        currentMusic:Destroy()
        currentMusic = nil
        StopMusicButton.Text = "⏹️ Остановлено"
        wait(1)
        StopMusicButton.Text = "⏹️ Остановить музыку"
    end
end

-- Server Info
local function showServerInfo()
    local players = game.Players:GetPlayers()
    local info = {
        "═══ ИНФОРМАЦИЯ СЕРВЕРА ═══",
        "🎮 Игроков: " .. #players,
        "⏱️ Время игры: " .. math.floor(game.Workspace.DistributedGameTime) .. "с",
        "📍 Место: " .. game.PlaceId,
        "👤 Вы: " .. game.Players.LocalPlayer.Name,
        "═════════════════════════"
    }
    
    for _, msg in pairs(info) do
        print(msg)
    end
    
    ServerInfoButton.Text = "ℹ️ Информация загружена"
    wait(2)
    ServerInfoButton.Text = "ℹ️ Информация сервера"
end

-- Player Analytics
local function showPlayerAnalytics()
    local players = game.Players:GetPlayers()
    print("═══ АНАЛИТИКА ИГРОКОВ ═══")
    
    for _, p in pairs(players) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            print("👤 " .. p.Name .. " | ❤️ " .. (hum and hum.Health or 0) .. "/" .. (hum and hum.MaxHealth or 0))
        end
    end
    
    print("═════════════════════════")
    PlayerAnalyticsButton.Text = "✅ Аналитика загружена"
    wait(2)
    PlayerAnalyticsButton.Text = "📈 Аналитика игроков"
end

-- Script Editor
local function showScriptEditor()
    local editorFrame = Instance.new("Frame")
    editorFrame.Name = "ScriptEditor"
    editorFrame.Parent = ScreenGui
    editorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    editorFrame.BorderSizePixel = 1
    editorFrame.BorderColor3 = Color3.fromRGB(100, 100, 150)
    editorFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    editorFrame.Size = UDim2.new(0, 600, 0, 500)
    editorFrame.ZIndex = 100
    
    local title = Instance.new("TextLabel")
    title.Parent = editorFrame
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    title.BorderSizePixel = 0
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Font = Enum.Font.GothamBold
    title.Text = "✍️ Script Editor"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = editorFrame
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    textBox.BorderSizePixel = 0
    textBox.Position = UDim2.new(0, 5, 0, 35)
    textBox.Size = UDim2.new(1, -10, 1, -80)
    textBox.Font = Enum.Font.Code
    textBox.Text = scriptEditorCode
    textBox.TextColor3 = Color3.fromRGB(200, 255, 200)
    textBox.TextSize = 11
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextYAlignment = Enum.TextYAlignment.Top
    textBox.ClipsDescendants = true
    textBox.MultiLine = true
    
    local executeButton = Instance.new("TextButton")
    executeButton.Parent = editorFrame
    executeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    executeButton.BorderSizePixel = 0
    executeButton.Position = UDim2.new(0, 5, 1, -40)
    executeButton.Size = UDim2.new(0.45, -5, 0, 35)
    executeButton.Font = Enum.Font.GothamBold
    executeButton.Text = "▶️ Выполнить"
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.TextSize = 12
    
    executeButton.MouseButton1Click:Connect(function()
        scriptEditorCode = textBox.Text
        pcall(function() loadstring(scriptEditorCode)() end)
    end)
    
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = editorFrame
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(0.5, 5, 1, -40)
    closeButton.Size = UDim2.new(0.45, -5, 0, 35)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "❌ Закрыть"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 12
    
    closeButton.MouseButton1Click:Connect(function()
        editorFrame:Destroy()
    end)
end

-- Theme System
local function applyTheme(theme)
    currentTheme = theme
    
    if theme == "dark" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ThemeDarkButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        ThemeLightButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        ThemeCyberpunkButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    elseif theme == "light" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        ThemeLightButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        ThemeDarkButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        ThemeCyberpunkButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    elseif theme == "cyberpunk" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
        ThemeCyberpunkButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        ThemeDarkButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        ThemeLightButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end

-- Improved Dupe Items
local function dupeItemsV2()
    if not char then return end
    
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    
    local allTools = {}
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(allTools, item)
        end
    end
    
    for _, item in pairs(allTools) do
        for i = 1, 5 do
            local cloned = item:Clone()
            cloned.Parent = backpack
            wait(0.1)
        end
    end
    
    DupeItemsButton.Text = "✅ Дюплицировано (5x каждый)"
    wait(2)
    DupeItemsButton.Text = "📦 Дюп предметов (v2)"
end

-- Config Management
local configData = {
    flyEnabled = false,
    flySpeed = 50,
    currentFlyType = "normal",
    customSpeed = 50,
    killAuraRange = 20,
    hitboxSize = 5,
    aimbotFOV = 200,
    autoClickerSpeed = 10
}

local function saveConfig()
    configData = {
        flyEnabled = flyEnabled,
        flySpeed = flySpeed,
        currentFlyType = currentFlyType,
        customSpeed = customSpeed,
        killAuraRange = killAuraRange,
        hitboxSize = hitboxSize,
        aimbotFOV = aimbotFOV,
        autoClickerSpeed = autoClickerSpeed,
        espColorR = espColorR,
        espColorG = espColorG,
        espColorB = espColorB
    }
    SaveConfigButton.Text = "✅ Конфиг сохранён!"
    wait(2)
    SaveConfigButton.Text = "💾 Сохранить конфиг"
end

local function loadConfig()
    if configData.flySpeed then
        flySpeed = configData.flySpeed
    end
    if configData.currentFlyType then
        setFlyType(configData.currentFlyType)
    end
    if configData.customSpeed then
        customSpeed = configData.customSpeed
    end
    if configData.killAuraRange then
        killAuraRange = configData.killAuraRange
    end
    if configData.hitboxSize then
        hitboxSize = configData.hitboxSize
    end
    if configData.aimbotFOV then
        aimbotFOV = configData.aimbotFOV
    end
    if configData.autoClickerSpeed then
        autoClickerSpeed = configData.autoClickerSpeed
    end
    LoadConfigButton.Text = "✅ Конфиг загружен!"
    wait(2)
    LoadConfigButton.Text = "📂 Загрузить конфиг"
end

-- Dupe Items
local function dupeItems()
    if not char then return end
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            local clonedItem = item:Clone()
            clonedItem.Parent = backpack
        end
    end
    
    DupeItemsButton.Text = "✅ Предметы продублированы!"
    wait(1)
    DupeItemsButton.Text = "📦 Дюп предметов"
end

-- Brainrot Script Handler
local function loadBrainrotScript()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BrainrotGaming/BrainrotUI/main/loader.lua", true))()
    end)
    BrainrotScriptButton.Text = "✅ Brainrot загружен!"
    wait(2)
    BrainrotScriptButton.Text = "🧠 Brainrot Script"
end

-- Deadrels Script Handler
local function loadDeadrelsScript()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Deadrels/DeadScript/main/main.lua", true))()
    end)
    DeadrelScriptButton.Text = "✅ Deadrels загружен!"
    wait(2)
    DeadrelScriptButton.Text = "💀 Deadrels Script"
end

-- Телепортация
local function teleportToCoords(x, y, z)
    if rootPart then
        rootPart.CFrame = CFrame.new(x, y, z)
    end
end

local function teleportToPlayer(playerName)
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer.Name:lower():find(playerName:lower()) then
            local targetRoot = otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and rootPart then
                rootPart.CFrame = targetRoot.CFrame + Vector3.new(5, 0, 0)
                return true
            end
        end
    end
    return false
end

local function showPlayerList()
    -- Создаем временное окно со списком игроков
    local listFrame = Instance.new("Frame")
    listFrame.Name = "PlayerListFrame"
    listFrame.Parent = ScreenGui
    listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    listFrame.BorderSizePixel = 1
    listFrame.BorderColor3 = Color3.fromRGB(100, 50, 150)
    listFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    listFrame.Size = UDim2.new(0, 300, 0, 400)
    listFrame.ZIndex = 100
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = listFrame
    titleLabel.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    titleLabel.BorderSizePixel = 0
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, 0, 0, 35)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🎮 ВЫБЕРИТЕ ИГРОКА"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = listFrame
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Position = UDim2.new(0, 0, 0, 35)
    scrollFrame.Size = UDim2.new(1, 0, 1, -85)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.BorderSizePixel = 0
    
    local playerY = 0
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Parent = scrollFrame
            playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            playerButton.BorderSizePixel = 0
            playerButton.Position = UDim2.new(0.05, 0, 0, playerY)
            playerButton.Size = UDim2.new(0.9, 0, 0, 40)
            playerButton.Font = Enum.Font.Gotham
            playerButton.Text = otherPlayer.Name
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.TextSize = 12
            
            playerButton.MouseButton1Click:Connect(function()
                selectedPlayerForTP = otherPlayer
                SelectedPlayerLabel.Text = "✅ " .. otherPlayer.Name
                SelectedPlayerLabel.TextColor3 = Color3.fromRGB(50, 150, 50)
                listFrame:Destroy()
            end)
            
            playerY = playerY + 45
        end
    end
    
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = listFrame
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(0.05, 0, 1, -40)
    closeButton.Size = UDim2.new(0.9, 0, 0, 35)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "❌ ЗАКРЫТЬ"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 12
    closeButton.ZIndex = 101
    
    closeButton.MouseButton1Click:Connect(function()
        listFrame:Destroy()
    end)
end

local function enableTPByClick()
    teleportByClickEnabled = not teleportByClickEnabled
    updateButton(TPClickButton, teleportByClickEnabled)
    
    if teleportByClickEnabled then
        local mouse = player:GetMouse()
        local connection
        connection = mouse.Button1Down:Connect(function()
            if teleportByClickEnabled and mouse.Target then
                local targetPos = mouse.Hit.Position
                teleportToCoords(targetPos.X, targetPos.Y + 3, targetPos.Z)
            end
        end)
    end
end

-- Infinite Jump
local function toggleInfJump()
    infJumpEnabled = not infJumpEnabled
    updateButton(InfJumpButton, infJumpEnabled)
end

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- God Mode
local godConnection
local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    updateButton(GodModeButton, godModeEnabled)
    
    if godModeEnabled then
        godConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if godModeEnabled and hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        if godConnection then godConnection:Disconnect() end
    end
end

-- Noclip
local noclipConnection
local originalCollisionStates = {}

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    updateButton(NoclipButton, noclipEnabled)
    
    if noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisionStates[part] = part.CanCollide
            end
        end
        
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if noclipEnabled and char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and originalCollisionStates[part] ~= nil then
                part.CanCollide = originalCollisionStates[part]
            end
        end
        originalCollisionStates = {}
    end
end

-- Speed
local speedConnection
local function toggleSpeed()
    speedEnabled = not speedEnabled
    updateButton(SpeedButton, speedEnabled)
    
    if speedEnabled then
        speedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if speedEnabled and hum then hum.WalkSpeed = customSpeed end
        end)
    else
        if speedConnection then speedConnection:Disconnect() end
        if hum then hum.WalkSpeed = defaultSpeed end
    end
end

-- Freecam
local freecamConnection
local originalCFrame
local originalCameraSubject
local freecamRotation = CFrame.new()

local function toggleFreecam()
    freecamEnabled = not freecamEnabled
    updateButton(FreecamButton, freecamEnabled)
    
    local cam = workspace.CurrentCamera
    local uis = game:GetService("UserInputService")
    
    if freecamEnabled then
        originalCFrame = cam.CFrame
        originalCameraSubject = cam.CameraSubject
        freecamRotation = cam.CFrame - cam.CFrame.Position
        
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CameraSubject = nil
        
        local freecamPosition = cam.CFrame.Position
        uis.MouseBehavior = Enum.MouseBehavior.LockCenter
        
        freecamConnection = game:GetService("RunService").RenderStepped:Connect(function(delta)
            if not freecamEnabled then return end
            
            if char and rootPart then
                rootPart.CanCollide = false
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
            
            local mouseDelta = uis:GetMouseDelta()
            local sensitivity = 0.003
            
            freecamRotation = freecamRotation * CFrame.Angles(0, -mouseDelta.X * sensitivity, 0)
            freecamRotation = freecamRotation * CFrame.Angles(-mouseDelta.Y * sensitivity, 0, 0)
            
            local movement = Vector3.new(0, 0, 0)
            local speed = 50
            
            if uis:IsKeyDown(Enum.KeyCode.W) then movement = movement + (freecamRotation.LookVector * speed * delta) end
            if uis:IsKeyDown(Enum.KeyCode.S) then movement = movement - (freecamRotation.LookVector * speed * delta) end
            if uis:IsKeyDown(Enum.KeyCode.A) then movement = movement - (freecamRotation.RightVector * speed * delta) end
            if uis:IsKeyDown(Enum.KeyCode.D) then movement = movement + (freecamRotation.RightVector * speed * delta) end
            if uis:IsKeyDown(Enum.KeyCode.E) or uis:IsKeyDown(Enum.KeyCode.Space) then movement = movement + (Vector3.new(0, 1, 0) * speed * delta) end
            if uis:IsKeyDown(Enum.KeyCode.Q) then movement = movement - (Vector3.new(0, 1, 0) * speed * delta) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then movement = movement * 3 end
            
            freecamPosition = freecamPosition + movement
            cam.CFrame = CFrame.new(freecamPosition) * freecamRotation
        end)
    else
        if freecamConnection then freecamConnection:Disconnect() end
        if char and rootPart then
            rootPart.CanCollide = true
        end
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = originalCameraSubject or hum
        uis.MouseBehavior = Enum.MouseBehavior.Default
    end
end

-- Kill Aura
local killAuraConnection
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    updateButton(KillAuraButton, killAuraEnabled)
    
    if killAuraEnabled then
        killAuraConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not killAuraEnabled or not rootPart then return end
            
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local otherHum = otherPlayer.Character:FindFirstChild("Humanoid")
                    
                    if otherRoot and otherHum and otherHum.Health > 0 then
                        local distance = (rootPart.Position - otherRoot.Position).Magnitude
                        if distance <= killAuraRange then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                            pcall(function() otherHum:TakeDamage(10) end)
                        end
                    end
                end
            end
        end)
    else
        if killAuraConnection then killAuraConnection:Disconnect() end
    end
end

-- ESP
local espConnection
local function updateESPForAll()
    for targetChar, folder in pairs(espObjects) do
        if folder and folder.Parent then
            local highlight = folder:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.FillColor = Color3.fromRGB(espColorR, espColorG, espColorB)
            end
            
            local billboard = folder:FindFirstChild("ESPBillboard")
            if billboard then
                local nameLabel = billboard:FindFirstChild("NameLabel")
                local distanceLabel = billboard:FindFirstChild("DistanceLabel")
                if nameLabel then nameLabel.Visible = espShowName end
                if distanceLabel then distanceLabel.Visible = espShowDistance end
            end
        end
    end
end

local function createESP(targetChar)
    if not targetChar or espObjects[targetChar] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. targetChar.Name
    espFolder.Parent = targetChar
    espObjects[targetChar] = espFolder
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = targetChar
    highlight.FillColor = Color3.fromRGB(espColorR, espColorG, espColorB)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = espFolder
    
    local head = targetChar:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPBillboard"
        billboard.Parent = espFolder
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = billboard
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = targetChar.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Visible = espShowName
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "DistanceLabel"
        distanceLabel.Parent = billboard
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Text = "0 м"
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceLabel.TextScaled = true
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.Visible = espShowDistance
        
        spawn(function()
            while espEnabled and targetChar and targetChar.Parent and rootPart do
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot and distanceLabel then
                    local distance = (rootPart.Position - targetRoot.Position).Magnitude
                    distanceLabel.Text = math.floor(distance) .. " м"
                end
                wait(0.1)
            end
        end)
    end
end

local function removeESP(targetChar)
    if espObjects[targetChar] then
        espObjects[targetChar]:Destroy()
        espObjects[targetChar] = nil
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    updateButton(ESPButton, espEnabled)
    
    if espEnabled then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                createESP(otherPlayer.Character)
            end
        end
        
        espConnection = game.Players.PlayerAdded:Connect(function(otherPlayer)
            otherPlayer.CharacterAdded:Connect(function(char)
                if espEnabled then wait(0.5) createESP(char) end
            end)
        end)
        
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                otherPlayer.CharacterAdded:Connect(function(char)
                    if espEnabled then wait(0.5) createESP(char) end
                end)
            end
        end
    else
        if espConnection then espConnection:Disconnect() end
        for targetChar, _ in pairs(espObjects) do removeESP(targetChar) end
    end
end

-- Hitbox Expander
local hitboxConnection
local function toggleHitbox()
    hitboxEnabled = not hitboxEnabled
    updateButton(HitboxButton, hitboxEnabled)
    
    if hitboxEnabled then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    originalHitboxSize[hrp] = hrp.Size
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = hitboxVisible and 0.7 or 1
                    hrp.CanCollide = false
                end
            end
        end
        
        hitboxConnection = game.Players.PlayerAdded:Connect(function(otherPlayer)
            otherPlayer.CharacterAdded:Connect(function(char)
                if hitboxEnabled then
                    wait(0.5)
                    local hrp = char:FindFirstChild("HumanoidRootPart")
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
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and originalHitboxSize[hrp] then
                    hrp.Size = originalHitboxSize[hrp]
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
    end
end

local function toggleHitboxVisible()
    hitboxVisible = not hitboxVisible
    updateButton(HitboxVisibleButton, hitboxVisible)
    
    if hitboxEnabled then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Transparency = hitboxVisible and 0.7 or 1
                end
            end
        end
    end
end

-- Aimbot
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = aimbotFOV
    
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherHead = otherChar:FindFirstChild("Head")
            local otherHum = otherChar:FindFirstChild("Humanoid")
            
            if otherHead and otherHum and otherHum.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(otherHead.Position)
                if onScreen then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        closestPlayer = otherPlayer
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    updateButton(AimbotButton, aimbotEnabled)
    
    if aimbotEnabled then
        aimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not aimbotEnabled then return end
            
            local targetPlayer = getClosestPlayer()
            if targetPlayer and targetPlayer.Character then
                local targetHead = targetPlayer.Character:FindFirstChild("Head")
                if targetHead then
                    local cam = workspace.CurrentCamera
                    cam.CFrame = CFrame.new(cam.CFrame.Position, targetHead.Position)
                end
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() end
    end
end

-- Fullbright
local lighting = game:GetService("Lighting")
local function toggleFullbright()
    fullbrightEnabled = not fullbrightEnabled
    updateButton(FullbrightButton, fullbrightEnabled)
    
    if fullbrightEnabled then
        if not originalLightingSettings.Ambient then
            originalLightingSettings = {
                Ambient = lighting.Ambient,
                Brightness = lighting.Brightness,
                ColorShift_Bottom = lighting.ColorShift_Bottom,
                ColorShift_Top = lighting.ColorShift_Top,
                OutdoorAmbient = lighting.OutdoorAmbient,
                FogEnd = lighting.FogEnd,
                FogStart = lighting.FogStart,
                GlobalShadows = lighting.GlobalShadows
            }
        end
        
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 3
        lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        lighting.FogEnd = 1000000
        lighting.FogStart = 0
        lighting.GlobalShadows = false
        
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or 
               effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or
               effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
    else
        if originalLightingSettings.Ambient then
            for property, value in pairs(originalLightingSettings) do
                lighting[property] = value
            end
        end
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or 
               effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or
               effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = true
            end
        end
    end
end

-- Skybox
local function toggleSkybox()
    skyboxEnabled = not skyboxEnabled
    updateButton(SkyboxButton, skyboxEnabled)
    
    if skyboxEnabled then
        originalSky = lighting:FindFirstChildOfClass("Sky")
        
        local sky = Instance.new("Sky")
        sky.Name = "CustomSky"
        sky.SkyboxBk = "rbxassetid://48152005"
        sky.SkyboxDn = "rbxassetid://48152005"
        sky.SkyboxFt = "rbxassetid://48152005"
        sky.SkyboxLf = "rbxassetid://48152005"
        sky.SkyboxRt = "rbxassetid://48152005"
        sky.SkyboxUp = "rbxassetid://48152005"
        sky.Parent = lighting
        
        if originalSky then originalSky.Parent = nil end
    else
        local customSky = lighting:FindFirstChild("CustomSky")
        if customSky then customSky:Destroy() end
        if originalSky then originalSky.Parent = lighting end
    end
end

-- ESP настройки
local function toggleESPName()
    espShowName = not espShowName
    updateButton(ESPShowNameButton, espShowName)
    updateESPForAll()
end

local function toggleESPDistance()
    espShowDistance = not espShowDistance
    updateButton(ESPShowDistanceButton, espShowDistance)
    updateESPForAll()
end

local function applyESPColor()
    local r = tonumber(RTextBox.Text) or 255
    local g = tonumber(GTextBox.Text) or 50
    local b = tonumber(BTextBox.Text) or 50
    
    espColorR = math.clamp(r, 0, 255)
    espColorG = math.clamp(g, 0, 255)
    espColorB = math.clamp(b, 0, 255)
    
    updateESPForAll()
end

local function applyMenuColor()
    local r = tonumber(MenuRTextBox.Text) or 35
    local g = tonumber(MenuGTextBox.Text) or 35
    local b = tonumber(MenuBTextBox.Text) or 45
    
    menuColorR = math.clamp(r, 0, 255)
    menuColorG = math.clamp(g, 0, 255)
    menuColorB = math.clamp(b, 0, 255)
    
    MainFrame.BackgroundColor3 = Color3.fromRGB(menuColorR, menuColorG, menuColorB)
end

-- Выгрузка
local function unloadCheat()
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
    if invisibilityEnabled then toggleInvisibility() end
    if itemESPEnabled then toggleItemESP() end
    if fpsBoostEnabled then toggleFPSBoost() end
    if antiAFKEnabled then toggleAntiAFK() end
    if tracerLinesEnabled then toggleTracerLines() end
    if healthBarsEnabled then toggleHealthBars() end
    if trollToolsEnabled then showTrollTools() end
    
    stopMusic()
    ScreenGui:Destroy()
end

-- Подключение кнопок
local function setupCheatButton(button, toggleFunc, bindName)
    button.MouseButton1Click:Connect(toggleFunc)
    button.MouseButton2Click:Connect(function()
        waitingForBind = bindName
        button.Text = "⌨️ Нажмите клавишу..."
    end)
end

FlyNormalButton.MouseButton1Click:Connect(function() setFlyType("normal") end)
FlyBhopButton.MouseButton1Click:Connect(function() setFlyType("bhop") end)
FlyBounceButton.MouseButton1Click:Connect(function() setFlyType("bounce") end)
FlyGlideButton.MouseButton1Click:Connect(function() setFlyType("glide") end)

setupCheatButton(FlyButton, toggleFly, "fly")
setupCheatButton(InfJumpButton, toggleInfJump, "infjump")
setupCheatButton(GodModeButton, toggleGodMode, "godmode")
setupCheatButton(NoclipButton, toggleNoclip, "noclip")
setupCheatButton(SpeedButton, toggleSpeed, "speed")
setupCheatButton(FreecamButton, toggleFreecam, "freecam")
setupCheatButton(KillAuraButton, toggleKillAura, "killaura")
setupCheatButton(ESPButton, toggleESP, "esp")
setupCheatButton(HitboxButton, toggleHitbox, "hitbox")
setupCheatButton(AimbotButton, toggleAimbot, "aimbot")
setupCheatButton(FullbrightButton, toggleFullbright, "fullbright")
setupCheatButton(SkyboxButton, toggleSkybox, "skybox")

TPClickButton.MouseButton1Click:Connect(enableTPByClick)
PlayerListButton.MouseButton1Click:Connect(showPlayerList)

NightScriptButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()
    end)
    NightScriptButton.Text = "✅ 99 Nights загружен!"
    wait(2)
    NightScriptButton.Text = "🌙 99 Nights in the Forest"
end)

BloxFruitScriptButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/forsaken.lua", true))()
    end)
    BloxFruitScriptButton.Text = "✅ Forsaken загружен!"
    wait(2)
    BloxFruitScriptButton.Text = "👹 Forsaken Script"
end)

PetSimScriptButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/PetSimulator/main/Main.lua", true))()
    end)
    PetSimScriptButton.Text = "✅ Pet Sim загружен!"
    wait(2)
    PetSimScriptButton.Text = "🐕 Pet Sim Script"
end)

BrainrotScriptButton.MouseButton1Click:Connect(loadBrainrotScript)
DeadrelScriptButton.MouseButton1Click:Connect(loadDeadrelsScript)
    if selectedPlayerForTP and selectedPlayerForTP.Character then
        local targetRoot = selectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and rootPart then
            rootPart.CFrame = targetRoot.CFrame + Vector3.new(5, 0, 0)
            TPSelectedButton.Text = "✅ Телепортировались!"
            wait(1)
            TPSelectedButton.Text = "✅ Телепортироваться"
        end
    end
end)

WalljumpButton.MouseButton1Click:Connect(toggleWalljump)
FakeLagButton.MouseButton1Click:Connect(toggleFakeLag)
AutoClickerButton.MouseButton1Click:Connect(toggleAutoClicker)
SaveConfigButton.MouseButton1Click:Connect(saveConfig)
LoadConfigButton.MouseButton1Click:Connect(loadConfig)
DupeItemsButton.MouseButton1Click:Connect(dupeItemsV2)

InvisibilityButton.MouseButton1Click:Connect(toggleInvisibility)
ItemESPButton.MouseButton1Click:Connect(toggleItemESP)
FPSBoostButton.MouseButton1Click:Connect(toggleFPSBoost)
ServerPrivateButton.MouseButton1Click:Connect(joinPrivateServer)
AntiAFKButton.MouseButton1Click:Connect(toggleAntiAFK)
TracerLinesButton.MouseButton1Click:Connect(toggleTracerLines)
HealthBarsButton.MouseButton1Click:Connect(toggleHealthBars)
OutfitCopierButton.MouseButton1Click:Connect(copyOutfit)
TrollToolsButton.MouseButton1Click:Connect(showTrollTools)

PlayMusicButton.MouseButton1Click:Connect(playMusic)
StopMusicButton.MouseButton1Click:Connect(stopMusic)
ServerInfoButton.MouseButton1Click:Connect(showServerInfo)
PlayerAnalyticsButton.MouseButton1Click:Connect(showPlayerAnalytics)
ScriptEditorButton.MouseButton1Click:Connect(showScriptEditor)

ThemeDarkButton.MouseButton1Click:Connect(function() applyTheme("dark") end)
ThemeLightButton.MouseButton1Click:Connect(function() applyTheme("light") end)
ThemeCyberpunkButton.MouseButton1Click:Connect(function() applyTheme("cyberpunk") end)

HitboxVisibleButton.MouseButton1Click:Connect(toggleHitboxVisible)
ESPShowNameButton.MouseButton1Click:Connect(toggleESPName)
ESPShowDistanceButton.MouseButton1Click:Connect(toggleESPDistance)
ApplyESPColorButton.MouseButton1Click:Connect(applyESPColor)
ApplyMenuColorButton.MouseButton1Click:Connect(applyMenuColor)
UnloadButton.MouseButton1Click:Connect(unloadCheat)

-- Переключение вкладок
MainTabButton.MouseButton1Click:Connect(function() switchTab("main") end)
PvPTabButton.MouseButton1Click:Connect(function() switchTab("pvp") end)
VisualsTabButton.MouseButton1Click:Connect(function() switchTab("visuals") end)
SettingsTabButton.MouseButton1Click:Connect(function() switchTab("settings") end)
ExtrasTabButton.MouseButton1Click:Connect(function() switchTab("extras") end)

-- Скрыть/Показать
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowButton.Visible = false
end)

-- Обработка биндов
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if waitingForBind then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            local buttons = {
                fly = FlyButton, noclip = NoclipButton, godmode = GodModeButton,
                infjump = InfJumpButton, speed = SpeedButton, fullbright = FullbrightButton,
                freecam = FreecamButton, killaura = KillAuraButton, esp = ESPButton,
                hitbox = HitboxButton, aimbot = AimbotButton, skybox = SkyboxButton
            }
            
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
            elseif waitingForBind == "aimbot" then aimbotBind = input.KeyCode
            end
            
            local button = buttons[waitingForBind]
            if button then
                local status = button.Text:match("ON") and "ON" or "OFF"
                button.Text = button.Text:match("^[^:]+") .. ": " .. status .. " [" .. input.KeyCode.Name .. "]"
            end
            
            waitingForBind = nil
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
        elseif input.KeyCode == aimbotBind then toggleAimbot()
        end
    end
end)

-- Обновление персонажа
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    flyEnabled = false
    infJumpEnabled = false
    godModeEnabled = false
    noclipEnabled = false
    speedEnabled = false
    killAuraEnabled = false
    freecamEnabled = false
    hitboxEnabled = false
    aimbotEnabled = false
    invisibilityEnabled = false
    itemESPEnabled = false
    fpsBoostEnabled = false
    antiAFKEnabled = false
    tracerLinesEnabled = false
    healthBarsEnabled = false
    trollToolsEnabled = false
    
    updateButton(FlyButton, false)
    updateButton(InfJumpButton, false)
    updateButton(GodModeButton, false)
    updateButton(NoclipButton, false)
    updateButton(SpeedButton, false)
    updateButton(KillAuraButton, false)
    updateButton(FreecamButton, false)
    updateButton(HitboxButton, false)
    updateButton(AimbotButton, false)
    updateButton(InvisibilityButton, false)
    updateButton(ItemESPButton, false)
    updateButton(FPSBoostButton, false)
    updateButton(AntiAFKButton, false)
    updateButton(TracerLinesButton, false)
    updateButton(HealthBarsButton, false)
    updateButton(TrollToolsButton, false)
end)

-- Защита от обнаружения
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

print("✅ Cheat by V98 v8.0 ULTIMATE загружено!")
