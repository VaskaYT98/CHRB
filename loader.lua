-- V98 Loader v2 | Solara V3
-- Просто выполни этот скрипт в Solara

local URL = "https://raw.githubusercontent.com/VaskaYT98/CHRB/main/cheat.lua"

print("[Loader] Загрузка cheat.lua из GitHub...")
print("[Loader] URL: " .. URL)

local ok, content = pcall(game.HttpGet, game, URL, true)

if not ok then
    warn("[Loader] ОШИБКА ЗАГРУЗКИ: " .. tostring(content))
    return
end

if not content or content == "" then
    warn("[Loader] Файл пустой!")
    return
end

print("[Loader] Скачано: " .. #content .. " байт")
print("[Loader] Первые 80 символов: " .. string.sub(content, 1, 80))

print("[Loader] Компиляция...")
local fn, err = loadstring(content)

if not fn then
    warn("[Loader] ОШИБКА КОМПИЛЯЦИИ: " .. tostring(err))
    -- Показываем строку с ошибкой
    local lineNum = tostring(err):match(":(%d+):")
    if lineNum then
        local lines = content:split("\n")
        local line = tonumber(lineNum)
        if line and lines[line] then
            warn("[Loader] Строка " .. line .. ": " .. lines[line])
        end
    end
    return
end

print("[Loader] Запуск...")
local execOk, execErr = pcall(fn)

if execOk then
    print("[Loader] Cheat загружен!")
else
    warn("[Loader] ОШИБКА ВЫПОЛНЕНИЯ: " .. tostring(execErr))
end
