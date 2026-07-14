-- ============================================
-- Loader by V98 | Solara V3
-- Инструкция: положи этот файл и cheat.lua в одну папку
-- Затем выполни этот лоадер через Solara
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local startTime = tick()

-- Debug функция
local function log(msg)
    local elapsed = string.format("%.2f", tick() - startTime)
    print("[Loader] " .. elapsed .. "s | " .. msg)
end

log("Запуск лоадера...")

-- Удаляем старое GUI если есть
local oldGui = CoreGui:FindFirstChild("LoaderGUI")
if oldGui then oldGui:Destroy() end

-- ============ LOADING SCREEN ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoaderGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
MainFrame.Size = UDim2.new(0, 300, 0, 160)
MainFrame.ClipsDescendants = true
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = MainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(50, 150, 50)
stroke.Thickness = 2
stroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 15)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Cheat by V98 | Loader"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 15, 0, 60)
StatusLabel.Size = UDim2.new(1, -30, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Инициализация..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local ProgressBg = Instance.new("Frame")
ProgressBg.Parent = MainFrame
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
ProgressBg.BorderSizePixel = 0
ProgressBg.Position = UDim2.new(0, 15, 0, 90)
ProgressBg.Size = UDim2.new(1, -30, 0, 8)
local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 4)
pCorner.Parent = ProgressBg

local ProgressFill = Instance.new("Frame")
ProgressFill.Parent = ProgressBg
ProgressFill.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ProgressFill.BorderSizePixel = 0
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 4)
fCorner.Parent = ProgressFill

local DebugLabel = Instance.new("TextLabel")
DebugLabel.Parent = MainFrame
DebugLabel.BackgroundTransparency = 1
DebugLabel.Position = UDim2.new(0, 15, 0, 110)
DebugLabel.Size = UDim2.new(1, -30, 0, 40)
DebugLabel.Font = Enum.Font.Code
DebugLabel.Text = ""
DebugLabel.TextColor3 = Color3.fromRGB(80, 180, 80)
DebugLabel.TextSize = 9
DebugLabel.TextXAlignment = Enum.TextXAlignment.Left
DebugLabel.TextYAlignment = Enum.TextYAlignment.Top
DebugLabel.TextWrapped = true

local debugLog = ""

local function updateUI(status, progress, debug)
    StatusLabel.Text = status
    ProgressFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
    if debug then
        debugLog = debugLog .. debug .. "\n"
        DebugLabel.Text = debugLog
    end
    log(status)
end

-- ============ LOADING STEPS ============

-- Шаг 1: Проверка окружения
updateUI("Проверка Solara V3...", 0.1, "Solara: OK")
task.wait(0.3)

-- Шаг 2: Проверка сервисов
local function checkService(name)
    local ok, svc = pcall(function() return game:GetService(name) end)
    return ok and svc ~= nil
end

local services = {"Players", "RunService", "UserInputService", "Lighting", "CoreGui"}
local allOk = true
for _, svc in ipairs(services) do
    if checkService(svc) then
        updateUI("Сервис " .. svc .. ": OK", 0.15)
    else
        updateUI("Сервис " .. svc .. ": ОШИБКА!", 0.15, "[ERR] " .. svc .. " not found")
        allOk = false
    end
end
task.wait(0.2)

-- Шаг 3: Проверка LocalPlayer
updateUI("Получение LocalPlayer...", 0.25)
local player = Players.LocalPlayer
if not player then
    updateUI("ОШИБКА: LocalPlayer = nil!", 0.25, "[ERR] LocalPlayer is nil")
    task.wait(3)
    ScreenGui:Destroy()
    return
end
updateUI("Player: " .. player.Name .. " (ID: " .. player.UserId .. ")", 0.3, "Player: " .. player.Name)
task.wait(0.2)

-- Шаг 4: Ожидание персонажа
updateUI("Ожидание персонажа...", 0.4)
local char = player.Character
if not char then
    updateUI("Waiting for CharacterAdded...", 0.4, "Char not loaded, waiting...")
    char = player.CharacterAdded:Wait()
end
updateUI("Персонаж: " .. char.Name, 0.5, "Char loaded: " .. char.Name)
task.wait(0.2)

-- Шаг 5: Проверка Humanoid
updateUI("Проверка Humanoid...", 0.55)
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then
    hum = char:WaitForChild("Humanoid", 10)
end
if hum then
    updateUI("Humanoid: OK (HP: " .. math.floor(hum.Health) .. ")", 0.6, "Humanoid: OK")
else
    updateUI("Humanoid: ОШИБКА!", 0.6, "[ERR] Humanoid not found")
end
task.wait(0.2)

-- Шаг 6: Поиск cheat.lua
updateUI("Поиск cheat.lua...", 0.7, "Searching for cheat.lua...")
task.wait(0.3)

local scriptCode = nil
local loaded = false

-- Способ 1: readfile (Solara V3)
local paths = {
    "cheat.lua",
    "RB-v98/cheat.lua",
    "scripts/cheat.lua",
    "autoexec/cheat.lua",
}

for _, path in ipairs(paths) do
    local ok, content = pcall(readfile, path)
    if ok and content and content ~= "" then
        scriptCode = content
        updateUI("Найден: " .. path, 0.8, "Found: " .. path .. " (" .. #content .. " bytes)")
        loaded = true
        break
    end
end

-- Способ 2: Если не нашли файл — вставь код сюда
if not loaded then
    updateUI("Файл не найден! Вставь код в scriptCode...", 0.8, "[WARN] File not found, trying inline...")
    task.wait(1)
    -- Если Solara не поддерживает readfile, можно вставить содержимое cheat.lua сюда:
    -- scriptCode = [==[ ... код cheat.lua ... ]==]
end

if not scriptCode then
    updateUI("ОШИБКА: cheat.lua не найден!", 0.9, "[ERR] Cannot find cheat.lua")
    updateUI("Положи cheat.lua рядом с loader.lua", 0.9)
    task.wait(5)
    ScreenGui:Destroy()
    return
end

-- Шаг 7: Загрузка скрипта
updateUI("Загрузка cheat.lua...", 0.85, "Compiling " .. #scriptCode .. " bytes...")
task.wait(0.3)

local compileOk, compileErr = pcall(function()
    -- Проверяем что код компилируется
    local fn, compileMsg = loadstring(scriptCode)
    if not fn then
        error("Compile error: " .. tostring(compileMsg))
    end
    updateUI("Компиляция: OK", 0.9, "Compile: OK")
end)

if not compileOk then
    updateUI("ОШИБКА КОМПИЛЯЦИИ!", 0.9, "[ERR] " .. tostring(compileErr))
    task.wait(5)
    ScreenGui:Destroy()
    return
end

-- Шаг 8: Запуск
updateUI("Запуск cheat.lua...", 0.95, "Executing...")
task.wait(0.2)

local execOk, execErr = pcall(function()
    loadstring(scriptCode)()
end)

if execOk then
    updateUI("Готово! Cheat загружен.", 1.0, "SUCCESS! Loaded in " .. string.format("%.1f", tick() - startTime) .. "s")
    task.wait(1.5)
    ScreenGui:Destroy()
else
    updateUI("ОШИБКА ВЫПОЛНЕНИЯ!", 1.0, "[ERR] " .. tostring(execErr))
    task.wait(5)
    ScreenGui:Destroy()
end
