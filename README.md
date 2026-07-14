# V98 Cheat Menu - v2.0 ULTIMATE

![Version](https://img.shields.io/badge/Version-2.0_ULTIMATE-green)
![Roblox](https://img.shields.io/badge/Roblox-Cheat-orange)
![Status](https://img.shields.io/badge/Status-Working-brightgreen)
![Executor](https://img.shields.io/badge/Executor-Solara_V3-blue)

## Установка

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/VaskaYT98/CHRB/main/loader.lua", true))()
```

## Что нового в v2.0

- Полностью переработанное современное меню (UICorner, UIStroke, hover-эффекты)
- 5 вкладок: Основные | PVP | Визуалы | Скрипты | Настройки
- Footer с аватаром, никнеймом и ID игрока
- Loader с debug-выводом и прогресс-баром
- Система тем оформления (7 тем)
- Исправлен Freecam (персонаж стоит на месте)
- Исправлен перебинд клавиш (ПКМ + ESC отмена)
- Убраны нерабочие фичи и скрипты

## Особенности

### Основные
- Fly System - 4 режима (Normal, BHOP, Bounce, Glide) + настройка скорости
- Infinite Jump
- God Mode
- Noclip
- Speed Hack + настройка скорости
- Freecam (персонаж не двигается)
- Invisible (полная невидимость)
- Anti-AFK (событийный, не нагружает CPU)

### PVP
- Kill Aura + настройка радиуса
- Aimbot + настройка FOV
- Hitbox Expander + видимость хитбоксов
- Tracer Lines (линии к игрокам через Drawing API)
- Health Bars (полоски здоровья над игроками)

### Визуалы
- ESP (имя, дистанция, кастомный цвет RGB)
- Item ESP (подсветка оружия/предметов на карте)
- Fullbright
- Custom Skybox
- Настройка яркости и Ambient

### Скрипты
- 99 Nights in the Forest (работает)
- MM2 Script (работает)
- Script Editor (встроенный редактор + Execute)
- Outfit Copier (копирование внешности любого игрока локально)
- Troll Tools (Fling, Force Sit)

### Настройки
- Система тем: Тёмная, Светлая, Красная, Синяя, Фиолет, Зелёная, Закат
- Server Info (Game ID, JobId, кол-во игроков)
- Player Analytics (список игроков с пингом)
- FPS Boost (отключение теней, пост-эффектов, понижение качества)
- Server Private (поиск сервера с минимальным числом игроков)
- Music Player (ввод ID песни + Play/Pause/Stop)
- Кастомные цвета меню (RGB)
- Перебинд всех клавиш (ПКМ по кнопке)

## Горячие клавиши (по умолчанию)

| Клавиша | Функция |
|---------|---------|
| F | Fly |
| N | Noclip |
| G | God Mode |
| J | Infinite Jump |
| V | Speed |
| C | Freecam |
| K | Kill Aura |
| E | ESP |
| H | Hitbox |
| X | Aimbot |
| B | Fullbright |

> Все клавиши перебиндываются: ПКМ по кнопке -> нажми новую клавишу -> ESC для отмены

## Loader

Loader (`loader.lua`) показывает:
- Прогресс-бар загрузки
- Debug-лог каждого этапа (сервисы, player, GUI, функции)
- Время загрузки
- Ошибки с описанием

Пример вывода в консоли:
```
[Loader] 0.00s | Запуск лоадера...
[Loader] 0.10s | Сервис Players: OK
[Loader] 0.20s | Player: Username (ID: 12345678)
[Loader] 0.30s | Персонаж: Character
[Loader] 0.40s | Humanoid: OK
[Loader] 0.50s | Найден: cheat.lua (45000 bytes)
[Loader] 0.60s | Компиляция: OK
[Loader] 0.70s | Выполнение...
[Cheat V2] 0.00s | Загрузка сервисов...
[Cheat V2] 0.01s | Сервисы загружены
[Cheat V2] 0.35s | Cheat by V98 v2.0 ULTIMATE загружено!
```

## Совместимость

- Solara V3 (основной тест)
- Другие executors с поддержкой readfile/writefile

## Примечание

Используйте на свой страх и риск. Автор не несет ответственности за блокировки аккаунтов.
