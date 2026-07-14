-- Cheat Menu V2.1 by V98 - Modern Edition (register-optimized)
local loadStart = tick()
local function dbg(msg) print("[Cheat V2] " .. string.format("%.2f", tick() - loadStart) .. "s | " .. msg) end

dbg("Загрузка сервисов...")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
dbg("Сервисы загружены")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")
dbg("Player: " .. player.Name)

-- STATE + SETTINGS + CONNECTIONS + BINDS in tables (saves registers)
local S = {
    fly=false, infJump=false, god=false, noclip=false, speed=false,
    fullbright=false, freecam=false, killAura=false, esp=false,
    hitbox=false, aimbot=false, skybox=false, invisible=false, antiAfk=false,
    itemEsp=false, tracer=false, healthBar=false, fpsBoost=false,
    fling=false, sit=false, flying=false, hitboxVis=false,
}
local C = {
    flyType="normal", defSpeed=16, speed=50, flySpeed=50,
    kaRange=20, hbSize=5, aimFOV=200,
    espR=255, espG=50, espB=50, espName=true, espDist=true,
}
local CON = {} -- connections
local B = {
    fly=Enum.KeyCode.F, noclip=Enum.KeyCode.N, god=Enum.KeyCode.G,
    infJump=Enum.KeyCode.J, speed=Enum.KeyCode.V, fullbright=Enum.KeyCode.B,
    freecam=Enum.KeyCode.C, killAura=Enum.KeyCode.K, esp=Enum.KeyCode.E,
    hitbox=Enum.KeyCode.H, aimbot=Enum.KeyCode.X,
}
local espObjs = {}
local hbSizes = {}
local origLight = {}
local origSky = nil
local waitingBind = nil
local waitBindBtn = nil
local bindPrefix = {}
local bindsLoaded = false
local curTab = "main"

local musicSound = Instance.new("Sound")
musicSound.Looped = true
musicSound.Parent = SoundService

-- THEMES
local themes = {
    {name="Тёмная",bg=Color3.fromRGB(22,22,32),panel=Color3.fromRGB(32,32,45),btn=Color3.fromRGB(42,42,58),acc=Color3.fromRGB(50,150,50),top=Color3.fromRGB(18,18,28),txt=Color3.fromRGB(255,255,255),dim=Color3.fromRGB(140,140,160)},
    {name="Светлая",bg=Color3.fromRGB(230,230,238),panel=Color3.fromRGB(242,242,248),btn=Color3.fromRGB(210,210,220),acc=Color3.fromRGB(40,120,200),top=Color3.fromRGB(200,200,212),txt=Color3.fromRGB(30,30,30),dim=Color3.fromRGB(90,90,100)},
    {name="Красная",bg=Color3.fromRGB(32,18,18),panel=Color3.fromRGB(45,22,22),btn=Color3.fromRGB(58,28,28),acc=Color3.fromRGB(200,50,50),top=Color3.fromRGB(28,14,14),txt=Color3.fromRGB(255,255,255),dim=Color3.fromRGB(160,130,130)},
    {name="Синяя",bg=Color3.fromRGB(18,22,38),panel=Color3.fromRGB(24,30,52),btn=Color3.fromRGB(30,38,65),acc=Color3.fromRGB(50,100,220),top=Color3.fromRGB(14,18,32),txt=Color3.fromRGB(255,255,255),dim=Color3.fromRGB(130,140,180)},
    {name="Фиолет",bg=Color3.fromRGB(28,18,38),panel=Color3.fromRGB(38,24,52),btn=Color3.fromRGB(48,30,65),acc=Color3.fromRGB(150,50,200),top=Color3.fromRGB(22,14,32),txt=Color3.fromRGB(255,255,255),dim=Color3.fromRGB(150,130,170)},
    {name="Зелёная",bg=Color3.fromRGB(18,28,18),panel=Color3.fromRGB(24,38,24),btn=Color3.fromRGB(30,48,30),acc=Color3.fromRGB(50,200,50),top=Color3.fromRGB(14,24,14),txt=Color3.fromRGB(255,255,255),dim=Color3.fromRGB(130,160,130)},
    {name="Закат",bg=Color3.fromRGB(35,22,15),panel=Color3.fromRGB(48,30,20),btn=Color3.fromRGB(60,38,25),acc=Color3.fromRGB(230,130,40),top=Color3.fromRGB(30,18,12),txt=Color3.fromRGB(255,255,255),dim=Color3.fromRGB(170,145,120)},
}
local T = themes[1]

-- HELPERS
local function addC(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p end
local function addS(p,cl,t) local s=Instance.new("UIStroke");s.Color=cl or Color3.fromRGB(55,55,75);s.Thickness=t or 1;s.Parent=p end
local function addP(p,t,b,l,r) local pv=Instance.new("UIPadding");pv.PaddingTop=UDim.new(0,t or 4);pv.PaddingBottom=UDim.new(0,b or 4);pv.PaddingLeft=UDim.new(0,l or 6);pv.PaddingRight=UDim.new(0,r or 6);pv.Parent=p end

local function updBtn(b,en)
    if en then b.BackgroundColor3=T.acc; b.Text=b.Text:gsub("OFF","ON")
    else b.BackgroundColor3=T.btn; b.Text=b.Text:gsub("ON","OFF") end
end

-- GUI
dbg("Создание GUI...")
local SG = Instance.new("ScreenGui"); SG.Name="CheatMenuV2"; SG.Parent=game.CoreGui; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.ResetOnSpawn=false
local MF = Instance.new("Frame"); MF.Name="MF"; MF.Parent=SG; MF.BackgroundColor3=T.bg; MF.BorderSizePixel=0; MF.Position=UDim2.new(0.5,-235,0.5,-265); MF.Size=UDim2.new(0,470,0,530); MF.ClipsDescendants=true; addC(MF,10); addS(MF,Color3.fromRGB(60,60,85),2)

local TB = Instance.new("Frame"); TB.Parent=MF; TB.BackgroundColor3=T.top; TB.BorderSizePixel=0; TB.Size=UDim2.new(1,0,0,38)
do
    local dragging, dragStart, startPos = false, nil, nil
    TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=MF.Position end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dragStart; MF.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
end
local TL = Instance.new("TextLabel"); TL.Parent=TB; TL.BackgroundTransparency=1; TL.Position=UDim2.new(0,12,0,0); TL.Size=UDim2.new(1,-50,1,0); TL.Font=Enum.Font.GothamBold; TL.Text="Cheat by V98 | v2.1"; TL.TextColor3=Color3.fromRGB(255,255,255); TL.TextSize=15; TL.TextXAlignment=Enum.TextXAlignment.Left

local HB = Instance.new("TextButton"); HB.Parent=TB; HB.BackgroundColor3=Color3.fromRGB(180,50,50); HB.BorderSizePixel=0; HB.Position=UDim2.new(1,-33,0,7); HB.Size=UDim2.new(0,24,0,24); HB.Font=Enum.Font.GothamBold; HB.Text="X"; HB.TextColor3=Color3.fromRGB(255,255,255); HB.TextSize=12; addC(HB,6)

local TF = Instance.new("Frame"); TF.Parent=MF; TF.BackgroundColor3=T.panel; TF.BorderSizePixel=0; TF.Position=UDim2.new(0,0,0,38); TF.Size=UDim2.new(1,0,0,40)
local TLy = Instance.new("UIListLayout"); TLy.Parent=TF; TLy.FillDirection=Enum.FillDirection.Horizontal; TLy.HorizontalAlignment=Enum.HorizontalAlignment.Center; TLy.Padding=UDim.new(0,4); TLy.VerticalAlignment=Enum.VerticalAlignment.Center

local function mkTab(n,txt) local b=Instance.new("TextButton");b.Name=n;b.Parent=TF;b.BackgroundColor3=T.btn;b.BorderSizePixel=0;b.Size=UDim2.new(0,85,0,30);b.Font=Enum.Font.GothamBold;b.Text=txt;b.TextColor3=Color3.fromRGB(255,255,255);b.TextSize=10;addC(b,6);return b end
local tMB,tPB,tVB,tSB,tTB2 = mkTab("MT","Основные"),mkTab("PT","PVP"),mkTab("VT","Визуалы"),mkTab("ST","Скрипты"),mkTab("ST2","Настройки")
tMB.BackgroundColor3=T.acc
dbg("GUI создано")

local CF = Instance.new("Frame"); CF.Parent=MF; CF.BackgroundTransparency=1; CF.Position=UDim2.new(0,0,0,78); CF.Size=UDim2.new(1,0,1,-118)

local function mkPage(n) local p=Instance.new("ScrollingFrame");p.Name=n;p.Parent=CF;p.BackgroundTransparency=1;p.Position=UDim2.new(0,8,0,0);p.Size=UDim2.new(1,-16,1,0);p.AutomaticCanvasSize=Enum.AutomaticSize.Y;p.ScrollBarThickness=4;p.BorderSizePixel=0;p.Visible=false;p.ScrollingDirection=Enum.ScrollingDirection.Y;local l=Instance.new("UIListLayout");l.Parent=p;l.Padding=UDim.new(0,4);l.SortOrder=Enum.SortOrder.LayoutOrder;local pd=Instance.new("UIPadding");pd.PaddingBottom=UDim.new(0,10);pd.Parent=p;return p end

dbg("Создание вкладок...")
local MP,PP,VP,SP,XP = mkPage("MP"),mkPage("PP"),mkPage("VP"),mkPage("SP"),mkPage("XP")
MP.Visible=true

-- Footer
local FT = Instance.new("Frame"); FT.Parent=MF; FT.BackgroundColor3=T.top; FT.BorderSizePixel=0; FT.Position=UDim2.new(0,0,1,-40); FT.Size=UDim2.new(1,0,0,40); addC(FT,6)
local AF = Instance.new("Frame"); AF.Parent=FT; AF.BackgroundColor3=T.acc; AF.Position=UDim2.new(0,10,0.5,-13); AF.Size=UDim2.new(0,26,0,26); addC(AF,13)
local AL = Instance.new("TextLabel"); AL.Parent=AF; AL.BackgroundTransparency=1; AL.Size=UDim2.new(1,0,1,0); AL.Font=Enum.Font.GothamBold; AL.Text=string.sub(player.Name,1,1):upper(); AL.TextColor3=Color3.fromRGB(255,255,255); AL.TextSize=14
local NL = Instance.new("TextLabel"); NL.Parent=FT; NL.BackgroundTransparency=1; NL.Position=UDim2.new(0,42,0,2); NL.Size=UDim2.new(0.5,0,0,18); NL.Font=Enum.Font.GothamBold; NL.Text=player.Name; NL.TextColor3=Color3.fromRGB(255,255,255); NL.TextSize=12; NL.TextXAlignment=Enum.TextXAlignment.Left
local IL = Instance.new("TextLabel"); IL.Parent=FT; IL.BackgroundTransparency=1; IL.Position=UDim2.new(0,42,0,20); IL.Size=UDim2.new(0.5,0,0,16); IL.Font=Enum.Font.Gotham; IL.Text="ID: "..player.UserId; IL.TextColor3=T.dim; IL.TextSize=10; IL.TextXAlignment=Enum.TextXAlignment.Left
local VL = Instance.new("TextLabel"); VL.Parent=FT; VL.BackgroundTransparency=1; VL.Position=UDim2.new(0.6,0,0,2); VL.Size=UDim2.new(0.38,0,1,0); VL.Font=Enum.Font.Gotham; VL.Text="v2.1"; VL.TextColor3=T.dim; VL.TextSize=10; VL.TextXAlignment=Enum.TextXAlignment.Right

local SB2 = Instance.new("TextButton"); SB2.Parent=SG; SB2.BackgroundColor3=T.panel; SB2.BorderSizePixel=0; SB2.Position=UDim2.new(0,10,0,10); SB2.Size=UDim2.new(0,130,0,40); SB2.Font=Enum.Font.GothamBold; SB2.Text="Открыть меню"; SB2.TextColor3=Color3.fromRGB(255,255,255); SB2.TextSize=12; SB2.Visible=false; addC(SB2,8); addS(SB2)

-- UI CREATORS
local ord = 0
local function mkBtn(par,nm,txt)
    ord=ord+1; local b=Instance.new("TextButton");b.Name=nm;b.Parent=par;b.BackgroundColor3=T.btn;b.BorderSizePixel=0;b.Size=UDim2.new(1,0,0,38);b.Font=Enum.Font.GothamBold;b.Text=txt;b.TextColor3=Color3.fromRGB(255,255,255);b.TextSize=13;b.LayoutOrder=ord;b.AutoButtonColor=false;addC(b,8)
    return b
end

local function mkLbl(par,txt)
    ord=ord+1; local l=Instance.new("TextLabel");l.Parent=par;l.BackgroundColor3=T.panel;l.BorderSizePixel=0;l.Size=UDim2.new(1,0,0,30);l.Font=Enum.Font.GothamBold;l.Text="  "..txt;l.TextColor3=T.dim;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left;l.LayoutOrder=ord;addC(l,6);return l
end

local function mkSlider(par,nm,txt,mn,mx,def,cb)
    ord=ord+1
    local ct=Instance.new("Frame");ct.Name=nm;ct.Parent=par;ct.BackgroundColor3=T.btn;ct.BorderSizePixel=0;ct.Size=UDim2.new(1,0,0,50);ct.LayoutOrder=ord;addC(ct,8)
    local lb=Instance.new("TextLabel");lb.Parent=ct;lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,8,0,2);lb.Size=UDim2.new(1,-16,0,20);lb.Font=Enum.Font.Gotham;lb.Text=txt..": "..def;lb.TextColor3=Color3.fromRGB(255,255,255);lb.TextSize=11;lb.TextXAlignment=Enum.TextXAlignment.Left
    local bg=Instance.new("Frame");bg.Parent=ct;bg.BackgroundColor3=Color3.fromRGB(28,28,38);bg.BorderSizePixel=0;bg.Position=UDim2.new(0,8,0,26);bg.Size=UDim2.new(1,-16,0,16);addC(bg,6)
    local fr=(def-mn)/(mx-mn)
    local fl=Instance.new("Frame");fl.Parent=bg;fl.BackgroundColor3=T.acc;fl.BorderSizePixel=0;fl.Size=UDim2.new(fr,0,1,0);addC(fl,6)
    local sb=Instance.new("TextButton");sb.Parent=bg;sb.BackgroundColor3=Color3.fromRGB(255,255,255);sb.BorderSizePixel=0;sb.Position=UDim2.new(fr,-6,0.5,-6);sb.Size=UDim2.new(0,12,0,12);sb.Text="";addC(sb,6)
    local drag=false; local sConn=nil
    sb.MouseButton1Down:Connect(function() drag=true
        sConn=RunService.RenderStepped:Connect(function()
            if not drag then if sConn then sConn:Disconnect() sConn=nil end return end
            local mx2=player:GetMouse();local rx=math.clamp(mx2.X-bg.AbsolutePosition.X,0,bg.AbsoluteSize.X)
            local pc=rx/bg.AbsoluteSize.X;local v=math.floor(mn+(mx-mn)*pc)
            fl.Size=UDim2.new(pc,0,1,0);sb.Position=UDim2.new(pc,-6,0.5,-6);lb.Text=txt..": "..v;cb(v)
        end)
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    return ct
end

local function mkRow(par) ord=ord+1; local f=Instance.new("Frame");f.Parent=par;f.BackgroundTransparency=1;f.Size=UDim2.new(1,0,0,36);f.LayoutOrder=ord;local l=Instance.new("UIListLayout");l.Parent=f;l.FillDirection=Enum.FillDirection.Horizontal;l.Padding=UDim.new(0,4);l.VerticalAlignment=Enum.VerticalAlignment.Center;return f end
local function mkSmBtn(par,txt,cb) local b=Instance.new("TextButton");b.Parent=par;b.BackgroundColor3=T.btn;b.BorderSizePixel=0;b.Size=UDim2.new(0,70,0,30);b.Font=Enum.Font.GothamBold;b.Text=txt;b.TextColor3=Color3.fromRGB(255,255,255);b.TextSize=10;b.AutoButtonColor=false;addC(b,6);b.MouseButton1Click:Connect(cb);return b end
local function mkInput(par,nm,ph) ord=ord+1; local t=Instance.new("TextBox");t.Name=nm;t.Parent=par;t.BackgroundColor3=Color3.fromRGB(28,28,38);t.BorderSizePixel=0;t.Size=UDim2.new(1,0,0,34);t.Font=Enum.Font.Gotham;t.PlaceholderText=ph;t.Text="";t.TextColor3=Color3.fromRGB(255,255,255);t.TextSize=12;t.ClearTextOnFocus=false;t.LayoutOrder=ord;addC(t,6);addP(t,0,0,8);return t end

-- TAB SWITCHING
local allP={MP,PP,VP,SP,XP}
local allB={tMB,tPB,tVB,tSB,tTB2}
local tabMap={main=1,pvp=2,visuals=3,scripts=4,settings=5}
local function swTab(t) curTab=t;for _,p in pairs(allP) do p.Visible=false end;for _,b in pairs(allB) do b.BackgroundColor3=T.btn end;local i=tabMap[t];if i then allP[i].Visible=true;allB[i].BackgroundColor3=T.acc end end
tMB.MouseButton1Click:Connect(function() swTab("main") end)
tPB.MouseButton1Click:Connect(function() swTab("pvp") end)
tVB.MouseButton1Click:Connect(function() swTab("visuals") end)
tSB.MouseButton1Click:Connect(function() swTab("scripts") end)
tTB2.MouseButton1Click:Connect(function() swTab("settings") end)

-- ====================== MAIN TAB ======================
dbg("Main tab...")
mkLbl(MP,"ОСНОВНЫЕ ЧИТЫ")
local bFly=mkBtn(MP,"Fly","Fly: OFF [F]")
local bInfJ=mkBtn(MP,"InfJ","Inf Jump: OFF [J]")
local bGod=mkBtn(MP,"God","God Mode: OFF [G]")
local bNocl=mkBtn(MP,"Nocl","Noclip: OFF [N]")
local bSpd=mkBtn(MP,"Spd","Speed: OFF [V]")
local bFree=mkBtn(MP,"Free","Freecam: OFF [C]")
local bInv=mkBtn(MP,"Inv","Invisible: OFF")
local bAnti=mkBtn(MP,"Anti","Anti-AFK: OFF")

mkLbl(MP,"ТИП ПОЛЕТА")
local ftr=mkRow(MP)
local bFN,bFBH,bFBO,bFG
bFN=mkSmBtn(ftr,"Normal",function() C.flyType="normal" bFN.BackgroundColor3=T.acc bFBH.BackgroundColor3=T.btn bFBO.BackgroundColor3=T.btn bFG.BackgroundColor3=T.btn end)
bFBH=mkSmBtn(ftr,"BHOP",function() C.flyType="bhop" bFBH.BackgroundColor3=T.acc bFN.BackgroundColor3=T.btn bFBO.BackgroundColor3=T.btn bFG.BackgroundColor3=T.btn end)
bFBO=mkSmBtn(ftr,"Bounce",function() C.flyType="bounce" bFBO.BackgroundColor3=T.acc bFN.BackgroundColor3=T.btn bFBH.BackgroundColor3=T.btn bFG.BackgroundColor3=T.btn end)
bFG=mkSmBtn(ftr,"Glide",function() C.flyType="glide" bFG.BackgroundColor3=T.acc bFN.BackgroundColor3=T.btn bFBH.BackgroundColor3=T.btn bFBO.BackgroundColor3=T.btn end)
bFN.BackgroundColor3=T.acc

mkLbl(MP,"НАСТРОЙКИ")
mkSlider(MP,"FlySpd","Скорость полёта",10,200,50,function(v) C.flySpeed=v end)
mkSlider(MP,"WalkSpd","Скорость ходьбы",16,200,50,function(v) C.speed=v if S.speed and hum then hum.WalkSpeed=v end end)

-- ====================== PVP TAB ======================
dbg("PvP tab...")
mkLbl(PP,"PVP ЧИТЫ")
local bKA=mkBtn(PP,"KA","Kill Aura: OFF [K]")
local bAim=mkBtn(PP,"Aim","Aimbot: OFF [X]")
local bHB=mkBtn(PP,"HB","Hitbox: OFF [H]")
local bHBV=mkBtn(PP,"HBV","Хитбокс видимый: OFF")
local bTrc=mkBtn(PP,"Trc","Tracer Lines: OFF")
local bHpB=mkBtn(PP,"HpB","Health Bars: OFF")

mkLbl(PP,"НАСТРОЙКИ PVP")
mkSlider(PP,"KAR","Kill Aura радиус",5,50,20,function(v) C.kaRange=v end)
mkSlider(PP,"AimFOV","Aimbot FOV",50,500,200,function(v) C.aimFOV=v end)
mkSlider(PP,"HBS","Размер хитбокса",1,20,5,function(v)
    C.hbSize=v
    if S.hitbox then for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart") if h then h.Size=Vector3.new(v,v,v) end end end end
end)

-- ====================== VISUALS TAB ======================
dbg("Visuals tab...")
mkLbl(VP,"ВИЗУАЛЬНЫЕ ЭФФЕКТЫ")
local bESP=mkBtn(VP,"ESP","ESP: OFF [E]")
local bIE=mkBtn(VP,"IE","Item ESP: OFF")
local bFB=mkBtn(VP,"FB","Fullbright: OFF [B]")
local bSky=mkBtn(VP,"Sky","Custom Skybox: OFF")
mkLbl(VP,"НАСТРОЙКИ ESP")
local bESN=mkBtn(VP,"ESN","ESP Имя: ON")
local bESD=mkBtn(VP,"ESD","ESP Дистанция: ON")
mkLbl(VP,"ЦВЕТ ESP (RGB)")
local iR=mkInput(VP,"R","R (0-255)")
local iG=mkInput(VP,"G","G (0-255)")
local iB=mkInput(VP,"B","B (0-255)")
local bAEC=mkBtn(VP,"AEC","Применить цвет ESP"); bAEC.BackgroundColor3=T.acc
mkLbl(VP,"ОСВЕЩЕНИЕ")
mkSlider(VP,"Bright","Яркость",0,10,2,function(v) Lighting.Brightness=v end)
mkSlider(VP,"Amb","Ambient",0,255,128,function(v) Lighting.Ambient=Color3.fromRGB(v,v,v) end)

-- ====================== SCRIPTS TAB ======================
dbg("Scripts tab...")
mkLbl(SP,"ВСТРОЕННЫЕ СКРИПТЫ")
local b99=mkBtn(SP,"99","99 Nights in the Forest"); b99.BackgroundColor3=Color3.fromRGB(100,50,150)
local bMM2=mkBtn(SP,"MM2","MM2 Script"); bMM2.BackgroundColor3=Color3.fromRGB(255,100,50)
mkLbl(SP,"ИНСТРУМЕНТЫ")
local bSE=mkBtn(SP,"SE","Script Editor"); bSE.BackgroundColor3=Color3.fromRGB(50,100,150)
local bOC=mkBtn(SP,"OC","Outfit Copier"); bOC.BackgroundColor3=Color3.fromRGB(150,100,50)
mkLbl(SP,"TROLL TOOLS")
local bFL=mkBtn(SP,"FL","Fling: OFF"); bFL.BackgroundColor3=Color3.fromRGB(180,60,60)
local bSIT=mkBtn(SP,"SIT","Force Sit: OFF"); bSIT.BackgroundColor3=Color3.fromRGB(150,80,50)

-- ====================== SETTINGS TAB ======================
dbg("Settings tab...")
mkLbl(XP,"ТЕМА ОФОРМЛЕНИЯ")
local thr=mkRow(XP)
for i,th in ipairs(themes) do mkSmBtn(thr,th.name,function() T=themes[i] MF.BackgroundColor3=T.bg TB.BackgroundColor3=T.top TF.BackgroundColor3=T.panel FT.BackgroundColor3=T.top for _,b in pairs(allB) do b.BackgroundColor3=T.btn end swTab(curTab) end) end

mkLbl(XP,"СЕРВЕР И СТАТИСТИКА")
local bSI=mkBtn(XP,"SI","Server Info"); bSI.BackgroundColor3=Color3.fromRGB(50,100,150)
local bPA=mkBtn(XP,"PA","Player Analytics"); bPA.BackgroundColor3=Color3.fromRGB(50,120,100)
local bFPS=mkBtn(XP,"FPS","FPS Boost: OFF"); bFPS.BackgroundColor3=Color3.fromRGB(50,150,100)
local bSP2=mkBtn(XP,"SP","Server Private (мало игроков)"); bSP2.BackgroundColor3=Color3.fromRGB(100,50,150)

mkLbl(XP,"МУЗЫКА")
local iMID=mkInput(XP,"MID","ID песни (например: 123456789)")
local mr=mkRow(XP)
mkSmBtn(mr,"Play",function() local id=iMID.Text:match("%d+") if id then musicSound.SoundId="rbxassetid://"..id musicSound:Play() end end).BackgroundColor3=T.acc
mkSmBtn(mr,"Pause",function() musicSound:Pause() end)
mkSmBtn(mr,"Stop",function() musicSound:Stop() end).BackgroundColor3=Color3.fromRGB(180,60,60)

mkLbl(XP,"БИНДЫ КЛАВИШ")
ord=ord+1; local bh=Instance.new("TextLabel");bh.Parent=XP;bh.BackgroundTransparency=1;bh.Size=UDim2.new(1,0,0,24);bh.Font=Enum.Font.Gotham;bh.Text="ПКМ по кнопке = перебинд | ESC = отмена";bh.TextColor3=T.dim;bh.TextSize=11;bh.LayoutOrder=ord

mkLbl(XP,"УПРАВЛЕНИЕ")
local bUnload=mkBtn(XP,"Unload","ВЫГРУЗИТЬ ЧИТ"); bUnload.BackgroundColor3=Color3.fromRGB(180,50,50)

-- ====================== OVERLAYS ======================
dbg("Overlays...")
local oF=Instance.new("Frame");oF.Parent=SG;oF.BackgroundColor3=Color3.fromRGB(15,15,22);oF.BorderSizePixel=0;oF.Position=UDim2.new(0.5,-200,0.5,-220);oF.Size=UDim2.new(0,400,0,440);oF.Visible=false;oF.ZIndex=200;addC(oF,10);addS(oF,T.acc,2)
local oT=Instance.new("TextLabel");oT.Parent=oF;oT.BackgroundColor3=T.top;oT.BorderSizePixel=0;oT.Size=UDim2.new(1,0,0,35);oT.Font=Enum.Font.GothamBold;oT.Text="";oT.TextColor3=Color3.fromRGB(255,255,255);oT.TextSize=14;oT.ZIndex=201
local oC=Instance.new("Frame");oC.Parent=oF;oC.BackgroundTransparency=1;oC.Position=UDim2.new(0,10,0,40);oC.Size=UDim2.new(1,-20,1,-50);oC.ZIndex=200
local oCL=Instance.new("TextButton");oCL.Parent=oT;oCL.BackgroundColor3=Color3.fromRGB(180,50,50);oCL.BorderSizePixel=0;oCL.Position=UDim2.new(1,-30,0,6);oCL.Size=UDim2.new(0,24,0,24);oCL.Font=Enum.Font.GothamBold;oCL.Text="X";oCL.TextColor3=Color3.fromRGB(255,255,255);oCL.TextSize=12;oCL.ZIndex=202;addC(oCL,6)
oCL.MouseButton1Click:Connect(function() oF.Visible=false end)
local oS=Instance.new("ScrollingFrame");oS.Parent=oC;oS.BackgroundTransparency=1;oS.Size=UDim2.new(1,0,1,0);oS.ScrollBarThickness=4;oS.BorderSizePixel=0;oS.ZIndex=200;oS.CanvasSize=UDim2.new(0,0,0,0)
local oLy=Instance.new("UIListLayout");oLy.Parent=oS;oLy.Padding=UDim.new(0,4)

local function clrOv() for _,c in pairs(oS:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end end
local function shOv(t) oT.Text=t;clrOv();oF.Visible=true end

-- ====================== FEATURE IMPLEMENTATIONS ======================

-- FLY
dbg("Feature: Fly")
local flyConn=nil
local function toggleFly()
    S.fly=not S.fly; updBtn(bFly,S.fly)
    if S.fly then
        S.flying=true
        flyConn=RunService.Heartbeat:Connect(function(d)
            if not S.fly or not rootPart or not rootPart.Parent then if flyConn then flyConn:Disconnect() end return end
            local cam=workspace.CurrentCamera; local dir=Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if dir.Magnitude>0 then dir=dir.Unit end
            local sp=C.flySpeed
            if C.flyType=="bhop" then sp=C.flySpeed*1.5 elseif C.flyType=="bounce" then sp=C.flySpeed*0.8 elseif C.flyType=="glide" then sp=C.flySpeed*0.6 end
            rootPart.CFrame=rootPart.CFrame+dir*sp*d
            rootPart.Velocity=Vector3.new(0,0,0); rootPart.RotVelocity=Vector3.new(0,0,0)
        end)
    else S.flying=false if flyConn then flyConn:Disconnect() flyConn=nil end end
end

-- INF JUMP
local function toggleInfJump() S.infJump=not S.infJump; updBtn(bInfJ,S.infJump) end
UIS.JumpRequest:Connect(function() if S.infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- GOD MODE
local function toggleGod()
    S.god=not S.god; updBtn(bGod,S.god)
    if S.god then CON.god=RunService.Heartbeat:Connect(function() if S.god and hum and hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end end)
    else if CON.god then CON.god:Disconnect() end end
end

-- NOCLIP
local function toggleNoclip()
    S.noclip=not S.noclip; updBtn(bNocl,S.noclip)
    if S.noclip then CON.noclip=RunService.Stepped:Connect(function() if S.noclip and char then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
    else if CON.noclip then CON.noclip:Disconnect() end end
end

-- SPEED
local function toggleSpeed()
    S.speed=not S.speed; updBtn(bSpd,S.speed)
    if S.speed then CON.speed=RunService.Heartbeat:Connect(function() if S.speed and hum then hum.WalkSpeed=C.speed end end)
    else if CON.speed then CON.speed:Disconnect() end if hum then hum.WalkSpeed=C.defSpeed end end
end

-- FREECAM (FIXED)
local fcRot=CFrame.new(); local fcPos=Vector3.new()
local function toggleFreecam()
    S.freecam=not S.freecam; updBtn(bFree,S.freecam)
    local cam=workspace.CurrentCamera
    if S.freecam then
        if rootPart then rootPart.Anchored=true end
        fcRot=cam.CFrame-cam.CFrame.Position; fcPos=cam.CFrame.Position
        cam.CameraType=Enum.CameraType.Scriptable; cam.CameraSubject=nil
        UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
        CON.freecam=RunService.RenderStepped:Connect(function(d)
            if not S.freecam then return end
            local md=UIS:GetMouseDelta(); local sn=0.003
            fcRot=fcRot*CFrame.Angles(0,-md.X*sn,0)*CFrame.Angles(-md.Y*sn,0,0)
            local mv=Vector3.new(0,0,0); local sp=50
            if UIS:IsKeyDown(Enum.KeyCode.W) then mv=mv+fcRot.LookVector*sp*d end
            if UIS:IsKeyDown(Enum.KeyCode.S) then mv=mv-fcRot.LookVector*sp*d end
            if UIS:IsKeyDown(Enum.KeyCode.A) then mv=mv-fcRot.RightVector*sp*d end
            if UIS:IsKeyDown(Enum.KeyCode.D) then mv=mv+fcRot.RightVector*sp*d end
            if UIS:IsKeyDown(Enum.KeyCode.R) or UIS:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0)*sp*d end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then mv=mv-Vector3.new(0,1,0)*sp*d end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then mv=mv*3 end
            fcPos=fcPos+mv; cam.CFrame=CFrame.new(fcPos)*fcRot
        end)
    else
        if CON.freecam then CON.freecam:Disconnect() CON.freecam=nil end
        cam.CameraType=Enum.CameraType.Custom; cam.CameraSubject=hum
        UIS.MouseBehavior=Enum.MouseBehavior.Default
        if rootPart then rootPart.Anchored=false end
    end
end

-- INVISIBLE
local function toggleInvisible()
    S.invisible=not S.invisible; updBtn(bInv,S.invisible)
    local function setTr(t) for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=t elseif p:IsA("Decal") then p.Transparency=t end end end
    if S.invisible then setTr(1); CON.invis=char.DescendantAdded:Connect(function(p) if S.invisible and (p:IsA("BasePart") or p:IsA("Decal")) then p.Transparency=1 end end)
    else if CON.invis then CON.invis:Disconnect() CON.invis=nil end if char then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.Transparency=0 elseif p:IsA("Decal") then p.Transparency=0 end end end end
end

-- ANTI-AFK
local function toggleAntiAfk()
    S.antiAfk=not S.antiAfk; updBtn(bAnti,S.antiAfk)
    if S.antiAfk then CON.antiAfk=player.Idled:Connect(function() pcall(function() local v=game:GetService("VirtualUser"); v:CaptureController(); v:ClickButton1(Vector2.new()) end) end)
    else if CON.antiAfk then CON.antiAfk:Disconnect() end end
end

-- KILL AURA
local function toggleKillAura()
    S.killAura=not S.killAura; updBtn(bKA,S.killAura)
    if S.killAura then CON.ka=RunService.Heartbeat:Connect(function()
        if not S.killAura or not rootPart then return end
        for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local oR=p.Character:FindFirstChild("HumanoidRootPart") local oH=p.Character:FindFirstChild("Humanoid") if oR and oH and oH.Health>0 then if (rootPart.Position-oR.Position).Magnitude<=C.kaRange then local tl=char and char:FindFirstChildOfClass("Tool") if tl then pcall(function() tl:Activate() end) end pcall(function() oH:TakeDamage(10) end) end end end end
    end) else if CON.ka then CON.ka:Disconnect() end end
end

-- ESP
local espDistLabels = {}
local function mkESP(tc)
    if not tc or espObjs[tc] then return end
    local fo=Instance.new("Folder"); fo.Name="ESP_"..tc.Name; fo.Parent=tc; espObjs[tc]=fo
    local hl=Instance.new("Highlight"); hl.Adornee=tc; hl.FillColor=Color3.fromRGB(C.espR,C.espG,C.espB); hl.OutlineColor=Color3.fromRGB(255,255,255); hl.FillTransparency=0.5; hl.OutlineTransparency=0; hl.Parent=fo
    local hd=tc:FindFirstChild("Head")
    if hd then
        local bb=Instance.new("BillboardGui"); bb.Name="BB"; bb.Adornee=hd; bb.Size=UDim2.new(0,200,0,50); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=fo
        local nl=Instance.new("TextLabel"); nl.Name="NL"; nl.Parent=bb; nl.BackgroundTransparency=1; nl.Size=UDim2.new(1,0,0.5,0); nl.Font=Enum.Font.GothamBold; nl.Text=tc.Name; nl.TextColor3=Color3.fromRGB(255,255,255); nl.TextScaled=true; nl.TextStrokeTransparency=0; nl.Visible=C.espName
        local dl=Instance.new("TextLabel"); dl.Name="DL"; dl.Parent=bb; dl.BackgroundTransparency=1; dl.Position=UDim2.new(0,0,0.5,0); dl.Size=UDim2.new(1,0,0.5,0); dl.Font=Enum.Font.Gotham; dl.Text="0m"; dl.TextColor3=Color3.fromRGB(255,255,255); dl.TextScaled=true; dl.TextStrokeTransparency=0; dl.Visible=C.espDist
        espDistLabels[tc] = dl
    end
end

local function rmESP(tc) if espObjs[tc] then espObjs[tc]:Destroy() espObjs[tc]=nil end espDistLabels[tc]=nil end

local function updAllESP()
    for _,fo in pairs(espObjs) do if fo and fo.Parent then local hl=fo:FindFirstChild("Highlight") if hl then hl.FillColor=Color3.fromRGB(C.espR,C.espG,C.espB) end local bb=fo:FindFirstChild("BB") if bb then local n=bb:FindFirstChild("NL") local d=bb:FindFirstChild("DL") if n then n.Visible=C.espName end if d then d.Visible=C.espDist end end end end
end

local function toggleESP()
    S.esp=not S.esp; updBtn(bESP,S.esp)
    if S.esp then
        for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then mkESP(p.Character) end end
        CON.esp=Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function(c) if S.esp then wait(0.5) mkESP(c) end end) end)
        for _,p in pairs(Players:GetPlayers()) do if p~=player then p.CharacterAdded:Connect(function(c) if S.esp then wait(0.5) mkESP(c) end end) end end
        CON.espDist=RunService.Heartbeat:Connect(function()
            if not S.esp or not rootPart or not rootPart.Parent then return end
            for tc,dl in pairs(espDistLabels) do
                if tc and tc.Parent and dl and dl.Parent then
                    local tr=tc:FindFirstChild("HumanoidRootPart")
                    if tr then dl.Text=math.floor((rootPart.Position-tr.Position).Magnitude).."m" end
                else espDistLabels[tc]=nil end
            end
        end)
    else
        if CON.esp then CON.esp:Disconnect() end
        if CON.espDist then CON.espDist:Disconnect() CON.espDist=nil end
        for tc,_ in pairs(espObjs) do rmESP(tc) end
        espDistLabels={}
    end
end

-- ITEM ESP
local ieObjs={}
local function toggleItemEsp()
    S.itemEsp=not S.itemEsp; updBtn(bIE,S.itemEsp)
    if S.itemEsp then
        local function hlItem(i) if ieObjs[i] then return end local h=Instance.new("Highlight");h.Adornee=i;h.FillColor=Color3.fromRGB(255,200,50);h.OutlineColor=Color3.fromRGB(255,255,255);h.FillTransparency=0.4;h.OutlineTransparency=0;h.Parent=i;ieObjs[i]=h end
        for _,o in pairs(workspace:GetDescendants()) do if o:IsA("Tool") then hlItem(o) end end
        CON.ie=workspace.DescendantAdded:Connect(function(o) if S.itemEsp and o:IsA("Tool") then wait(0.1) hlItem(o) end end)
    else if CON.ie then CON.ie:Disconnect() CON.ie=nil end for i,h in pairs(ieObjs) do h:Destroy() end ieObjs={} end
end

-- FULLBRIGHT
local function toggleFullbright()
    S.fullbright=not S.fullbright; updBtn(bFB,S.fullbright)
    if S.fullbright then
        if not origLight.Amb then origLight={Amb=Lighting.Ambient,Bri=Lighting.Brightness,CSB=Lighting.ColorShift_Bottom,CST=Lighting.ColorShift_Top,OA=Lighting.OutdoorAmbient,FE=Lighting.FogEnd,FS=Lighting.FogStart,GS=Lighting.GlobalShadows} end
        Lighting.Ambient=Color3.fromRGB(255,255,255);Lighting.Brightness=3;Lighting.ColorShift_Bottom=Color3.fromRGB(255,255,255);Lighting.ColorShift_Top=Color3.fromRGB(255,255,255);Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255);Lighting.FogEnd=1000000;Lighting.FogStart=0;Lighting.GlobalShadows=false
    else if origLight.Amb then for k,v in pairs(origLight) do Lighting[k]=v end end end
end

-- SKYBOX
local function toggleSkybox()
    S.skybox=not S.skybox; updBtn(bSky,S.skybox)
    if S.skybox then origSky=Lighting:FindFirstChildOfClass("Sky") local sk=Instance.new("Sky");sk.Name="CSky";sk.SkyboxBk="rbxassetid://48152005";sk.SkyboxDn="rbxassetid://48152005";sk.SkyboxFt="rbxassetid://48152005";sk.SkyboxLf="rbxassetid://48152005";sk.SkyboxRt="rbxassetid://48152005";sk.SkyboxUp="rbxassetid://48152005";sk.Parent=Lighting;if origSky then origSky.Parent=nil end
    else local cs=Lighting:FindFirstChild("CSky") if cs then cs:Destroy() end if origSky then origSky.Parent=Lighting end end
end

-- HITBOX
local function toggleHitbox()
    S.hitbox=not S.hitbox; updBtn(bHB,S.hitbox)
    if S.hitbox then
        for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart") if h then hbSizes[h]=h.Size;h.Size=Vector3.new(C.hbSize,C.hbSize,C.hbSize);h.Transparency=S.hitboxVis and 0.7 or 1;h.CanCollide=false end end end
        CON.hb=Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function(c) if S.hitbox then wait(0.5) local h=c:FindFirstChild("HumanoidRootPart") if h then hbSizes[h]=h.Size;h.Size=Vector3.new(C.hbSize,C.hbSize,C.hbSize);h.Transparency=S.hitboxVis and 0.7 or 1;h.CanCollide=false end end end) end)
    else
        if CON.hb then CON.hb:Disconnect() end
        for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart") if h and hbSizes[h] then h.Size=hbSizes[h];h.Transparency=1;h.CanCollide=true end end end hbSizes={}
    end
end

local function toggleHBVis()
    S.hitboxVis=not S.hitboxVis; updBtn(bHBV,S.hitboxVis)
    if S.hitbox then for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart") if h then h.Transparency=S.hitboxVis and 0.7 or 1 end end end end
end

-- AIMBOT
local function getClosest()
    local cl,sh=nil,C.aimFOV
    for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local hd=p.Character:FindFirstChild("Head") local hm=p.Character:FindFirstChild("Humanoid") if hd and hm and hm.Health>0 then local sp,on=workspace.CurrentCamera:WorldToScreenPoint(hd.Position) if on then local d=(Vector2.new(sp.X,sp.Y)-UIS:GetMouseLocation()).Magnitude if d<sh then cl=p;sh=d end end end end end
    return cl
end

local function toggleAimbot()
    S.aimbot=not S.aimbot; updBtn(bAim,S.aimbot)
    if S.aimbot then CON.aim=RunService.RenderStepped:Connect(function() if not S.aimbot then return end local t=getClosest() if t and t.Character then local hd=t.Character:FindFirstChild("Head") if hd then local cam=workspace.CurrentCamera;cam.CFrame=CFrame.new(cam.CFrame.Position,hd.Position) end end end)
    else if CON.aim then CON.aim:Disconnect() CON.aim=nil end end
end

-- TRACER LINES (Drawing API)
local tracers={}
local function toggleTracers()
    S.tracer=not S.tracer; updBtn(bTrc,S.tracer)
    if S.tracer then
        CON.trc=RunService.RenderStepped:Connect(function()
            if not S.tracer then return end
            local cam=workspace.CurrentCamera; local sc=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y)
            for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local hr=p.Character:FindFirstChild("HumanoidRootPart") if hr then local sp,on=cam:WorldToScreenPoint(hr.Position) if on then if not tracers[p] then local ln=Drawing.new("Line");ln.Thickness=2;ln.Color=Color3.fromRGB(C.espR,C.espG,C.espB);ln.Transparency=0.8;ln.Visible=true;tracers[p]=ln end tracers[p].From=sc;tracers[p].To=Vector2.new(sp.X,sp.Y);tracers[p].Visible=true else if tracers[p] then tracers[p].Visible=false end end end end end
        end)
    else if CON.trc then CON.trc:Disconnect() CON.trc=nil end for _,l in pairs(tracers) do l:Remove() end tracers={} end
end

-- HEALTH BARS
local hpBars={}
local function toggleHealthBars()
    S.healthBar=not S.healthBar; updBtn(bHpB,S.healthBar)
    if S.healthBar then
        CON.hp=RunService.Heartbeat:Connect(function()
            if not S.healthBar then return end
            for _,p in pairs(Players:GetPlayers()) do if p~=player and p.Character then local hm=p.Character:FindFirstChild("Humanoid") local hd=p.Character:FindFirstChild("Head") if hm and hd then
                if not hpBars[p] then local bb=Instance.new("BillboardGui");bb.Name="HP";bb.Adornee=hd;bb.Size=UDim2.new(0,40,0,6);bb.StudsOffset=Vector3.new(0,-2.5,0);bb.AlwaysOnTop=true;bb.Parent=p.Character;local bg=Instance.new("Frame");bg.Name="B";bg.Parent=bb;bg.BackgroundColor3=Color3.fromRGB(40,40,40);bg.Size=UDim2.new(1,0,1,0);addC(bg,3);local fl=Instance.new("Frame");fl.Name="F";fl.Parent=bg;fl.Size=UDim2.new(1,0,1,0);addC(fl,3);hpBars[p]=bb end
                local fl2=hpBars[p]:FindFirstChild("B") and hpBars[p].B:FindFirstChild("F")
                if fl2 then local pc=hm.Health/hm.MaxHealth;fl2.Size=UDim2.new(math.clamp(pc,0,1),0,1,0);if pc>0.5 then fl2.BackgroundColor3=Color3.fromRGB(50,200,50) elseif pc>0.25 then fl2.BackgroundColor3=Color3.fromRGB(200,200,50) else fl2.BackgroundColor3=Color3.fromRGB(200,50,50) end end
            end end end
        end)
    else if CON.hp then CON.hp:Disconnect() CON.hp=nil end for _,b in pairs(hpBars) do if b then b:Destroy() end end hpBars={} end
end

-- FPS BOOST
local function toggleFpsBoost()
    S.fpsBoost=not S.fpsBoost; updBtn(bFPS,S.fpsBoost)
    if S.fpsBoost then Lighting.GlobalShadows=false;Lighting.FogEnd=1000000;for _,e in pairs(Lighting:GetDescendants()) do if e:IsA("PostEffect") then e.Enabled=false end end pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
    else Lighting.GlobalShadows=true;Lighting.FogEnd=100000;for _,e in pairs(Lighting:GetDescendants()) do if e:IsA("PostEffect") then e.Enabled=true end end pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic end) end
end

-- FLING
local function toggleFling()
    S.fling=not S.fling; updBtn(bFL,S.fling)
    if S.fling then CON.fl=RunService.Heartbeat:Connect(function() if not S.fling or not rootPart or not rootPart.Parent then if CON.fl then CON.fl:Disconnect() end return end rootPart.Velocity=Vector3.new(9999,9999,0);rootPart.RotVelocity=Vector3.new(0,9999,0) end)
    else if CON.fl then CON.fl:Disconnect() CON.fl=nil end if rootPart then rootPart.Velocity=Vector3.new(0,0,0);rootPart.RotVelocity=Vector3.new(0,0,0) end end
end

-- FORCE SIT
local function toggleSit() S.sit=not S.sit; updBtn(bSIT,S.sit) if hum then hum.Sit=S.sit end end

-- ESP SETTINGS
local function toggleEspName() C.espName=not C.espName; updBtn(bESN,C.espName); updAllESP() end
local function toggleEspDist() C.espDist=not C.espDist; updBtn(bESD,C.espDist); updAllESP() end
local function applyEspCol() C.espR=math.clamp(tonumber(iR.Text) or 255,0,255);C.espG=math.clamp(tonumber(iG.Text) or 50,0,255);C.espB=math.clamp(tonumber(iB.Text) or 50,0,255);updAllESP() end

-- SERVER PRIVATE
local function joinLowServer()
    bSP2.Text="Поиск сервера..."
    pcall(function()
        local s=game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&excludeFullServers=true"))
        if s and s.data then local best,low=nil,999;for _,sv in pairs(s.data) do if sv.playing and sv.playing<low and sv.id~=game.JobId then low=sv.playing;best=sv end end; if best then TeleportService:TeleportToPlaceInstance(game.PlaceId,best.id,player) else bSP2.Text="Не найден";wait(2);bSP2.Text="Server Private" end end
    end)
    bSP2.Text="Server Private"
end

-- SCRIPT EDITOR OVERLAY
bSE.MouseButton1Click:Connect(function()
    shOv("Script Editor")
    local tb=Instance.new("TextBox");tb.Parent=oS;tb.BackgroundColor3=Color3.fromRGB(20,20,30);tb.BorderSizePixel=0;tb.Size=UDim2.new(1,0,0,250);tb.Font=Enum.Font.Code;tb.Text="";tb.TextColor3=Color3.fromRGB(0,255,0);tb.TextSize=12;tb.ClearTextOnFocus=false;tb.MultiLine=true;tb.TextXAlignment=Enum.TextXAlignment.Left;tb.TextYAlignment=Enum.TextYAlignment.Top;tb.ZIndex=201;addC(tb,6)
    local pd=Instance.new("UIPadding");pd.PaddingLeft=UDim.new(0,8);pd.PaddingTop=UDim.new(0,8);pd.Parent=tb
    local rw=mkRow(oS) local eb=mkSmBtn(rw,"Execute",function() pcall(function() loadstring(tb.Text)() end) end);eb.BackgroundColor3=T.acc;eb.Size=UDim2.new(0,100,0,30)
    local cb=mkSmBtn(rw,"Clear",function() tb.Text="" end);cb.Size=UDim2.new(0,100,0,30)
end)

-- OUTFIT COPIER OVERLAY
bOC.MouseButton1Click:Connect(function()
    shOv("Outfit Copier - Выберите игрока")
    for _,p in pairs(Players:GetPlayers()) do if p~=player then
        local rw=Instance.new("Frame");rw.Parent=oS;rw.BackgroundColor3=T.btn;rw.BorderSizePixel=0;rw.Size=UDim2.new(1,0,0,40);rw.ZIndex=201;addC(rw,6)
        local lb=Instance.new("TextLabel");lb.Parent=rw;lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,10,0,0);lb.Size=UDim2.new(0.6,0,1,0);lb.Font=Enum.Font.GothamBold;lb.Text=p.Name;lb.TextColor3=Color3.fromRGB(255,255,255);lb.TextSize=12;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.ZIndex=202
        local cp=Instance.new("TextButton");cp.Parent=rw;cp.BackgroundColor3=T.acc;cp.BorderSizePixel=0;cp.Position=UDim2.new(1,-80,0,5);cp.Size=UDim2.new(0,70,0,30);cp.Font=Enum.Font.GothamBold;cp.Text="Копировать";cp.TextColor3=Color3.fromRGB(255,255,255);cp.TextSize=10;cp.ZIndex=202;addC(cp,6)
        cp.MouseButton1Click:Connect(function() local tc=p.Character;local th=tc and tc:FindFirstChildOfClass("Humanoid");local lh=char and char:FindFirstChildOfClass("Humanoid") if th and lh then pcall(function() lh:ApplyDescription(th:GetAppliedDescription()) end);cp.Text="Готово!";wait(1);cp.Text="Копировать" end end)
    end end
end)

-- SERVER INFO OVERLAY
bSI.MouseButton1Click:Connect(function()
    shOv("Server Info")
    local info={{"Game",game.PlaceId},{"JobId",game.JobId},{"Players",#Players:GetPlayers().."/"..Players.MaxPlayers},{"Player",player.Name.." ("..player.UserId..")"},{"Version",game.Version},{"Place",tostring(game.PlaceVersion)}}
    for _,pr in pairs(info) do local rw=Instance.new("TextLabel");rw.Parent=oS;rw.BackgroundColor3=T.btn;rw.BorderSizePixel=0;rw.Size=UDim2.new(1,0,0,30);rw.Font=Enum.Font.Gotham;rw.Text="  "..pr[1]..": "..tostring(pr[2]);rw.TextColor3=Color3.fromRGB(255,255,255);rw.TextSize=11;rw.TextXAlignment=Enum.TextXAlignment.Left;rw.ZIndex=201;addC(rw,6) end
end)

-- PLAYER ANALYTICS OVERLAY
bPA.MouseButton1Click:Connect(function()
    shOv("Player Analytics")
    local tp,cnt=0,0
    for _,p in pairs(Players:GetPlayers()) do local pg=p:GetNetworkPing() or 0;tp=tp+pg;cnt=cnt+1;local rw=Instance.new("TextLabel");rw.Parent=oS;rw.BackgroundColor3=T.btn;rw.BorderSizePixel=0;rw.Size=UDim2.new(1,0,0,28);rw.Font=Enum.Font.Gotham;rw.Text="  "..p.Name.." | Ping: "..math.floor(pg*1000).."ms";rw.TextColor3=Color3.fromRGB(255,255,255);rw.TextSize=11;rw.TextXAlignment=Enum.TextXAlignment.Left;rw.ZIndex=201;addC(rw,6) end
    local sm=Instance.new("TextLabel");sm.Parent=oS;sm.BackgroundColor3=T.acc;sm.BorderSizePixel=0;sm.Size=UDim2.new(1,0,0,30);sm.Font=Enum.Font.GothamBold;sm.Text="  Всего: "..cnt.." | Avg: "..math.floor((cnt>0 and tp/cnt or 0)*1000).."ms";sm.TextColor3=Color3.fromRGB(255,255,255);sm.TextSize=11;sm.TextXAlignment=Enum.TextXAlignment.Left;sm.ZIndex=201;addC(sm,6)
end)

-- ====================== SETUP BUTTONS ======================
dbg("Подключение кнопок...")
local function setupBtn(b,fn,bn)
    local pf=bn and bindPrefix[bn] or b.Text:match("^[^:]+")
    if bn then bindPrefix[bn]=pf end
    b.MouseButton1Click:Connect(fn)
    b.MouseButton2Click:Connect(function() waitingBind=bn;waitBindBtn=b;b.Text="Нажмите клавишу... (ESC)" end)
end
setupBtn(bFly,toggleFly,"fly");setupBtn(bInfJ,toggleInfJump,"infJump");setupBtn(bGod,toggleGod,"god")
setupBtn(bNocl,toggleNoclip,"noclip");setupBtn(bSpd,toggleSpeed,"speed");setupBtn(bFree,toggleFreecam,"freecam")
setupBtn(bInv,toggleInvisible,"invisible");setupBtn(bAnti,toggleAntiAfk,"antiAfk")
setupBtn(bKA,toggleKillAura,"killAura");setupBtn(bAim,toggleAimbot,"aimbot");setupBtn(bHB,toggleHitbox,"hitbox")
setupBtn(bFB,toggleFullbright,"fullbright");setupBtn(bSky,toggleSkybox,"skybox")
setupBtn(bTrc,toggleTracers,"tracer");setupBtn(bHpB,toggleHealthBars,"healthBar")
setupBtn(bESP,toggleESP,"esp");setupBtn(bIE,toggleItemEsp,"itemEsp");setupBtn(bFPS,toggleFpsBoost,"fpsBoost")
bESN.MouseButton1Click:Connect(toggleEspName)
bESD.MouseButton1Click:Connect(toggleEspDist)
bAEC.MouseButton1Click:Connect(applyEspCol)
bFL.MouseButton1Click:Connect(toggleFling)
bSIT.MouseButton1Click:Connect(toggleSit)
bSP2.MouseButton1Click:Connect(joinLowServer)

b99.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua",true))() end);b99.Text="99 Nights загружен!";wait(2);b99.Text="99 Nights in the Forest" end)
bMM2.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet('https://raw.smokingscripts.org/vertex.lua'))() end);bMM2.Text="MM2 загружен!";wait(2);bMM2.Text="MM2 Script" end)

-- ====================== KEYBINDS ======================
dbg("Бинды...")
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if waitingBind then
        if i.KeyCode==Enum.KeyCode.Escape then
            if waitBindBtn then local pf=bindPrefix[waitingBind] or "" local ok=waitBindBtn.Text:find("ON") and "ON" or "OFF" local ok2=waitBindBtn.Text:match("%[(.+)%]$") or "" if ok2~="" then waitBindBtn.Text=pf..": "..ok.." ["..ok2.."]" else waitBindBtn.Text=pf..": "..ok end end
            waitingBind=nil;waitBindBtn=nil;return
        end
        if i.KeyCode~=Enum.KeyCode.Unknown then
            local map={fly="fly",noclip="noclip",god="god",infJump="infJump",speed="speed",fullbright="fullbright",freecam="freecam",killAura="killAura",esp="esp",hitbox="hitbox",aimbot="aimbot"}
            local bn=map[waitingBind] if bn then B[bn]=i.KeyCode end
            if waitBindBtn then local pf=bindPrefix[waitingBind] or "" local ok=waitBindBtn.Text:find("ON") and "ON" or "OFF" waitBindBtn.Text=pf..": "..ok.." ["..i.KeyCode.Name.."]" end
            waitingBind=nil;waitBindBtn=nil
        end
    else
        if not bindsLoaded then bindsLoaded=true return end
        local kc=i.KeyCode
        if kc==B.fly then toggleFly() elseif kc==B.noclip then toggleNoclip() elseif kc==B.god then toggleGod()
        elseif kc==B.infJump then toggleInfJump() elseif kc==B.speed then toggleSpeed() elseif kc==B.fullbright then toggleFullbright()
        elseif kc==B.freecam then toggleFreecam() elseif kc==B.killAura then toggleKillAura() elseif kc==B.esp then toggleESP()
        elseif kc==B.hitbox then toggleHitbox() elseif kc==B.aimbot then toggleAimbot() end
    end
end)

-- ====================== CHARACTER RESPAWN ======================
dbg("Respawn handler...")
player.CharacterAdded:Connect(function(nc)
    char=nc;hum=char:WaitForChild("Humanoid");rootPart=char:WaitForChild("HumanoidRootPart")
    if S.fly then toggleFly() end; if S.infJump then toggleInfJump() end; if S.god then toggleGod() end
    if S.noclip then toggleNoclip() end; if S.speed then toggleSpeed() end; if S.killAura then toggleKillAura() end
    if S.freecam then toggleFreecam() end; if S.hitbox then toggleHitbox() end; if S.aimbot then toggleAimbot() end
    if S.invisible then toggleInvisible() end; if S.fling then toggleFling() end
end)

-- ====================== HIDE / SHOW ======================
HB.MouseButton1Click:Connect(function() MF.Visible=false;SB2.Visible=true end)
SB2.MouseButton1Click:Connect(function() MF.Visible=true;SB2.Visible=false end)

-- ====================== UNLOAD ======================
bUnload.MouseButton1Click:Connect(function()
    if S.fly then toggleFly() end;if S.god then toggleGod() end;if S.noclip then toggleNoclip() end
    if S.speed then toggleSpeed() end;if S.fullbright then toggleFullbright() end;if S.freecam then toggleFreecam() end
    if S.killAura then toggleKillAura() end;if S.esp then toggleESP() end;if S.hitbox then toggleHitbox() end
    if S.aimbot then toggleAimbot() end;if S.skybox then toggleSkybox() end;if S.invisible then toggleInvisible() end
    if S.antiAfk then toggleAntiAfk() end;if S.itemEsp then toggleItemEsp() end;if S.tracer then toggleTracers() end
    if S.healthBar then toggleHealthBars() end;if S.fpsBoost then toggleFpsBoost() end;if S.fling then toggleFling() end
    musicSound:Stop();SG:Destroy()
end)

-- ANTI-DETECTION
pcall(function() local mt=getrawmetatable(game) local oc=mt.__namecall setreadonly(mt,false) mt.__namecall=newcclosure(function(self,...) local m=getnamecallmethod() if m=="Kick" or m=="kick" then return end return oc(self,...) end) setreadonly(mt,true) end)

dbg("Anti-detection: OK")
print("[Cheat V2] ============================================")
print("[Cheat V2] Cheat by V98 v2.1 ULTIMATE загружено!")
print("[Cheat V2] Время загрузки: "..string.format("%.2f",tick()-loadStart).."s")
print("[Cheat V2] ============================================")
