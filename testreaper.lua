local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Advanced/refs/heads/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--=========================
-- 🔥 SERVICES
--=========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--=========================
-- 🔥 WINDOW
--=========================
local Window = Fluent:CreateWindow({
Title = "Reaper Hub",
SubTitle = "lib Beta 14.7",
TabWidth = 160,
Size = UDim2.fromOffset(520, 360),
Theme = "Dark",
MinimizeKey = Enum.KeyCode.RightControl
})
-- Left icon ui
-- =========================
-- WAIT GUI
-- =========================
task.wait(1)

local GUI = Fluent.GUI
if not GUI then
    return warn("Fluent GUI not found")
end

-- =========================
-- FIND TITLE
-- =========================
local Title

for i = 1, 30 do
    for _, v in pairs(GUI:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(string.lower(v.Text), "reaper") then
            Title = v
            break
        end
    end
    if Title then break end
    task.wait(0.1)
end

if not Title then
    return warn("Title not found")
end

-- =========================
-- GET TOPBAR
-- =========================
local TopBar = Title.Parent
if not TopBar then
    return warn("TopBar not found")
end

-- =========================
-- FIX LAYOUT (สำคัญ)
-- =========================
local Layout
for _, v in pairs(TopBar:GetChildren()) do
    if v:IsA("UIListLayout") then
        Layout = v
        break
    end
end

if Layout then
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 6)
end

-- =========================
-- CREATE LOGO (เข้า Layout)
-- =========================
local Logo = Instance.new("ImageLabel")
Logo.Name = "ReaperLogo"
Logo.Parent = TopBar

Logo.Image = "rbxassetid://131279093559313"
Logo.BackgroundTransparency = 1
Logo.Size = UDim2.new(0, 30, 0, 30) -- ปรับให้บาลานซ์กับฟอนต์
Logo.ScaleType = Enum.ScaleType.Fit

-- ให้อยู่ซ้ายสุด
Logo.LayoutOrder = -1

-- =========================
-- ALIGN CENTER (ละเอียด)
-- =========================
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.Position = UDim2.new(0, 0, 0.5, 1) -- +1 ช่วยแก้ baseline ฟอนต์

-- =========================
-- OPTIONAL STYLE
-- =========================
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 0
Stroke.Transparency = 1
Stroke.Parent = Logo

-- Tab
local Tabs = {
Status = Window:AddTab({ Title = "Status", Icon = "signal-high" }),
Credit = Window:AddTab({ Title = "Credit", Icon = "code" }),
Main = Window:AddTab({ Title = "Main", Icon = "home" }),
Player = Window:AddTab({ Title = "Player", Icon = "user" }),
ESP = Window:AddTab({ Title = "ESP", Icon = "box" }),
Teleport = Window:AddTab({ Title = "Teleport", Icon = "menu" }),
Server = Window:AddTab({ Title = "Server", Icon = "server" }),
Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--=========================
-- 🔥 STATE
--=========================
local State = {
    WS = false,
    JP = false,
    INFJ = false,
    NC = false,
    ESP = false
}

local WSValue = 16
local JPValue = 50

local DefaultWS = 16
local DefaultJP = 50

local initialized = false

--=========================
-- 🔥 CHARACTER HOOK
--=========================
local function HookChar(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.1)

    -- 🔥 FIX: ล็อก default แค่ครั้งเดียว (กันค่าค้าง/เพี้ยนตอน respawn)
    if not initialized then
        DefaultWS = hum.WalkSpeed
        DefaultJP = hum.UseJumpPower and hum.JumpPower or 50
        initialized = true
    end
end

if LP.Character then HookChar(LP.Character) end
LP.CharacterAdded:Connect(HookChar)

--=========================
-- 🔥 GET HUM
--=========================
local function GetHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

--=========================
-- 🔥 MOVEMENT
--=========================
RunService.RenderStepped:Connect(function()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- WalkSpeed
    if State.WS then
        hum.WalkSpeed = WSValue
    else
        hum.WalkSpeed = DefaultWS
    end

    -- JumpPower
    hum.UseJumpPower = true
    if State.JP then
        hum.JumpPower = JPValue
    else
        hum.JumpPower = DefaultJP
    end

    -- NC (ไม่แก้ logic เดิม)
    if State.NC then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--=========================
-- 🔥 INFINITE JUMP
--=========================
UIS.JumpRequest:Connect(function()
    if State.INFJ then
        local hum = GetHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--=========================
-- 🔥 ESP SYSTEM (OPTIMIZED FINAL)
--=========================
local ESPObjects = {}
local Cache = {}

local BoxColor = Color3.fromRGB(255,0,0)
local LineColor = Color3.fromRGB(0,255,0)

local ESPConnection

--=========================
-- 🔥 CREATE ESP
--=========================
local function CreateESP()
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Filled = false

    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1

    return {box = box, line = line}
end

--=========================
-- 🔥 CLEAR ESP (NO LEAK)
--=========================
local function ClearESP()
    for plr,v in pairs(ESPObjects) do
        if v.box then v.box:Remove() end
        if v.line then v.line:Remove() end
        ESPObjects[plr] = nil
    end
    Cache = {}
end

--=========================
-- 🔥 CHARACTER CACHE
--=========================
local function SetupCharacter(plr, char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local head = char:WaitForChild("Head", 5)

    if not hrp or not head then return end

    Cache[plr] = {
        hrp = hrp,
        head = head
    }
end

--=========================
-- 🔥 INIT ESP
--=========================
local function InitESP()
    ClearESP()

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            ESPObjects[plr] = CreateESP()

            if plr.Character then
                SetupCharacter(plr, plr.Character)
            end

            plr.CharacterAdded:Connect(function(char)
                SetupCharacter(plr, char)
            end)
        end
    end
end

--=========================
-- 🔥 PLAYER EVENTS
--=========================
Players.PlayerAdded:Connect(function(plr)
    if plr == LP then return end

    if State.ESP then
        ESPObjects[plr] = CreateESP()
    end

    plr.CharacterAdded:Connect(function(char)
        SetupCharacter(plr, char)
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        ESPObjects[plr].box:Remove()
        ESPObjects[plr].line:Remove()
        ESPObjects[plr] = nil
    end
    Cache[plr] = nil
end)

--=========================
-- 🔥 START LOOP (ANTI DUPLICATE)
--=========================
local function StartESP()
    if ESPConnection then
        ESPConnection:Disconnect()
    end

    ESPConnection = RunService.RenderStepped:Connect(function()
        if not State.ESP then return end

        local camPos = Camera.ViewportSize

        for plr,obj in pairs(ESPObjects) do
            local data = Cache[plr]
            if not data then
                obj.box.Visible = false
                obj.line.Visible = false
                continue
            end

            local hrp = data.hrp
            local head = data.head

            if not hrp or not head then
                obj.box.Visible = false
                obj.line.Visible = false
                continue
            end

            local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local headPos = Camera:WorldToViewportPoint(head.Position)

                local height = math.abs(headPos.Y - rootPos.Y) * 2
                local width = height / 1.5

                -- BOX
                obj.box.Size = Vector2.new(width, height)
                obj.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                obj.box.Color = BoxColor
                obj.box.Visible = true

                -- LINE
                obj.line.From = Vector2.new(camPos.X/2, camPos.Y)
                obj.line.To = Vector2.new(rootPos.X, rootPos.Y)
                obj.line.Color = LineColor
                obj.line.Visible = true
            else
                obj.box.Visible = false
                obj.line.Visible = false
            end
        end
    end)
end

--=========================
-- 🔥 ENABLE ESP
--=========================
InitESP()
StartESP()

--=========================
-- 🔥 UI
--=========================
Tabs.Player:AddToggle("WS", {
Title = "WalkSpeed",
Default = false,
Callback = function(v) State.WS = v end
})

Tabs.Player:AddInput("WSV", {
Title = "Speed Value",
Default = "16",
Callback = function(v)
WSValue = tonumber(v) or 16
end
})

Tabs.Player:AddToggle("JP", {
Title = "JumpPower",
Default = false,
Callback = function(v) State.JP = v end
})

Tabs.Player:AddInput("JPV", {
Title = "Jump Value",
Default = "50",
Callback = function(v)
JPValue = tonumber(v) or 50
end
})

-- Fly Mode 🔥
-- === ตัวแปรระบบบิน ===
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local flying = false
local speed = 60
local bv, bg

-- === ฟังก์ชันหยุดบิน ===
local function stopFlying()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

-- === ฟังก์ชันเริ่มบิน ===
local function startFlying()
    local char = LocalPlayer.Character
    -- รอให้ชิ้นส่วนตัวละครโหลดครบก่อนเริ่มบิน (กันบัคตอนเกิดใหม่)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    
    if not root or not hum then return end
    
    -- ล้างของเก่าก่อนสร้างใหม่ (กันซ้อน)
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9e4
    bg.Parent = root
    
    hum.PlatformStand = true
    
    -- ลูปการเคลื่อนที่
    task.spawn(function()
        while flying and char == LocalPlayer.Character do
            RunService.RenderStepped:Wait()
            local cam = workspace.CurrentCamera
            
            local moveInput = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls():GetMoveVector()
            local direction = (cam.CFrame.LookVector * -moveInput.Z) + (cam.CFrame.RightVector * moveInput.X)
            
            if direction.Magnitude > 0 then
                bv.Velocity = direction * speed
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            bg.CFrame = cam.CFrame
        end
    end)
end

-- === ระบบทำงานต่ออัตโนมัติเมื่อเกิดใหม่ ===
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    if flying then
        -- รอแป๊บนึงให้ระบบฟิสิกส์ของตัวละครใหม่พร้อม
        task.wait(0.5) 
        if flying then startFlying() end
    end
end)

-- === เพิ่มเข้า Fluent UI (Tabs.Player) ===
Tabs.Player:AddToggle("FlyToggle", {
    Title = "Fly Mode", 
    Default = false,
    Callback = function(Value)
        flying = Value
        if flying then
            startFlying()
        else
            stopFlying()
        end
    end
})

Tabs.Player:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Description = "ปรับความเร็วการบิน",
    Default = 60,
    Min = 10,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        speed = Value
    end
})


Tabs.Player:AddToggle("INFJ", {
Title = "Infinite Jump",
Default = false,
Callback = function(v) State.INFJ = v end
})

Tabs.Player:AddToggle("NC", {
Title = "Noclip",
Default = false,
Callback = function(v) State.NC = v end
})

-- มึงอย่ามาล้อเล่นกับเดอะหมุน
--================ SPIN PLAYER FIX =================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local spinning = false
local spinSpeed = 20
local spinConnection

-- ดึง HRP แบบชัวร์
local function getHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- เริ่มหมุน (ใช้ dt กันเฟรมเรท)
local function startSpin()
    if spinConnection then
        spinConnection:Disconnect()
    end

    spinConnection = RunService.RenderStepped:Connect(function(dt)
        local hrp = getHRP()
        if not hrp then return end

        -- ใช้ dt ทำให้ลื่นขึ้น
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed * dt * 60), 0)
    end)
end

-- หยุด
local function stopSpin()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

-- รีตัวไม่พัง
LocalPlayer.CharacterAdded:Connect(function()
    if spinning then
        task.wait(1)
        startSpin()
    end
end)

-- Toggle
Tabs.Player:AddToggle("SpinPlayer", {
    Title = "Spin Player",
    Default = false,
    Callback = function(v)
        spinning = v

        if v then
            startSpin()
        else
            stopSpin()
        end
    end
})

-- Slider
Tabs.Player:AddSlider("SpinSpeed", {
    Title = "Spin Speed",
    Min = 1,
    Max = 100,
    Default = 20,
	Rounding = 0,
    Callback = function(v)
        spinSpeed = v
    end
})

--ESP
Tabs.ESP:AddToggle("ESP", {
Title = "ESP Enable",
Default = false,
Callback = function(v)
State.ESP = v

if v then  
        task.wait(0.1)  
        InitESP()  
    else  
        ClearESP()  
    end  
end

})

Tabs.ESP:AddColorpicker("BoxColor", {
Title = "Box Color",
Default = BoxColor,
Callback = function(v)
if typeof(v) == "Color3" then
BoxColor = v
end
end
})

Tabs.ESP:AddColorpicker("LineColor", {
Title = "Line Color",
Default = LineColor,
Callback = function(v)
if typeof(v) == "Color3" then
LineColor = v
end
end
})

-- ESP NAME & Health bar🔥
--========================
-- SERVICES
--========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

--========================
-- SETTINGS
--========================
local MaxDistance = 2500

_G.NameESPEnabled = false
_G.HealthESPEnabled = false

--========================
-- CACHE
--========================
local ESPCache = {}

--========================
-- CREATE ESP
--========================
local function CreateESP(Player)

    if Player == LocalPlayer then
        return
    end

    --========================
    -- NAME
    --========================
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Center = true
    Name.Outline = true
    Name.Font = 2
    Name.Size = 13
    Name.Color = Color3.fromRGB(255,255,255)
    Name.Transparency = 1

    --========================
    -- HEALTH OUTLINE
    --========================
    local HealthOutline = Drawing.new("Square")
    HealthOutline.Visible = false
    HealthOutline.Filled = true
    HealthOutline.Thickness = 0
    HealthOutline.Color = Color3.fromRGB(0,0,0)
    HealthOutline.Transparency = 0.6

    --========================
    -- HEALTH BAR
    --========================
    local HealthBar = Drawing.new("Square")
    HealthBar.Visible = false
    HealthBar.Filled = true
    HealthBar.Thickness = 0
    HealthBar.Color = Color3.fromRGB(0,255,100)
    HealthBar.Transparency = 1

    ESPCache[Player] = {
        Name = Name,
        HealthOutline = HealthOutline,
        HealthBar = HealthBar
    }
end

--========================
-- REMOVE ESP
--========================
local function RemoveESP(Player)

    local ESP = ESPCache[Player]

    if ESP then

        for _,v in pairs(ESP) do
            v:Remove()
        end

        ESPCache[Player] = nil
    end
end

--========================
-- HIDE ESP
--========================
local function HideESP(ESP)

    ESP.Name.Visible = false
    ESP.HealthOutline.Visible = false
    ESP.HealthBar.Visible = false
end

--========================
-- PLAYER HANDLING
--========================
for _,Player in ipairs(Players:GetPlayers()) do
    CreateESP(Player)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

--========================
-- MAIN RENDER
--========================
RunService.RenderStepped:Connect(function()

    for Player,ESP in pairs(ESPCache) do

        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
        local Head = Character and Character:FindFirstChild("Head")

        --========================
        -- VALIDATION
        --========================
        if not Character
        or not Humanoid
        or not Root
        or not Head
        or Humanoid.Health <= 0 then

            HideESP(ESP)
            continue
        end

        --========================
        -- DISTANCE
        --========================
        local Distance = (Camera.CFrame.Position - Root.Position).Magnitude

        if Distance > MaxDistance then
            HideESP(ESP)
            continue
        end

        --========================
        -- VIEWPORT
        --========================
        local RootPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)

        if not OnScreen then
            HideESP(ESP)
            continue
        end

        local HeadPos = Camera:WorldToViewportPoint(
            Head.Position + Vector3.new(0,0.6,0)
        )

        local LegPos = Camera:WorldToViewportPoint(
            Root.Position - Vector3.new(0,3,0)
        )

        --========================
        -- SCALE
        --========================
        local Height = math.abs(HeadPos.Y - LegPos.Y)
        local Width = Height / 2

        local X = RootPos.X - Width / 2
        local Y = RootPos.Y - Height / 2

        --========================
        -- NAME ESP
        --========================
        if _G.NameESPEnabled then

            ESP.Name.Visible = true

            local Size = math.clamp(
                16 - (Distance / 120),
                13,
                16
            )

            ESP.Name.Size = Size

            ESP.Name.Text = string.format(
                "%s [%dm]",
                Player.Name,
                math.floor(Distance)
            )

            ESP.Name.Position = Vector2.new(
                RootPos.X,
                Y - 16
            )

        else
            ESP.Name.Visible = false
        end

        --========================
        -- HEALTH BAR
        --========================
        if _G.HealthESPEnabled then

            local HealthPercent = math.clamp(
                Humanoid.Health / Humanoid.MaxHealth,
                0,
                1
            )

            local BarHeight = Height * HealthPercent

            local BarX = X - 7
            local BarY = Y

            -- OUTLINE
            ESP.HealthOutline.Visible = true
            ESP.HealthOutline.Size = Vector2.new(
                4,
                Height + 2
            )

            ESP.HealthOutline.Position = Vector2.new(
                BarX - 1,
                BarY - 1
            )

            -- BAR
            ESP.HealthBar.Visible = true
            ESP.HealthBar.Size = Vector2.new(
                2,
                BarHeight
            )

            ESP.HealthBar.Position = Vector2.new(
                BarX,
                BarY + (Height - BarHeight)
            )

            -- HEALTH COLOR
            ESP.HealthBar.Color = Color3.fromRGB(
                255 - (255 * HealthPercent),
                255 * HealthPercent,
                0
            )

        else

            ESP.HealthOutline.Visible = false
            ESP.HealthBar.Visible = false
        end
    end
end)

--========================
-- TOGGLES
--========================
Tabs.ESP:AddToggle("NameESP", {
    Title = "ESP Name",
    Default = false,
    Callback = function(v)
        _G.NameESPEnabled = v
    end
})

Tabs.ESP:AddToggle("HealthESP", {
    Title = "ESP Health",
    Default = false,
    Callback = function(v)
        _G.HealthESPEnabled = v
    end
})

-- Add Hitbox 🔥
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local hitboxEnabled = false
local hitboxSize = 6

local function applyHitbox(player)
    if player == LocalPlayer then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if hitboxEnabled then

        root.Size = Vector3.new(
            hitboxSize,
            hitboxSize,
            hitboxSize
        )

        root.Transparency = 0.6
        root.Material = Enum.Material.ForceField
        root.Color = Color3.fromRGB(255, 0, 0)
        root.CanCollide = false

    else

        root.Size = Vector3.new(2,2,1)
        root.Transparency = 1
        root.Material = Enum.Material.Plastic
    end
end

-- UPDATE LOOP
task.spawn(function()

    while true do

        for _,p in ipairs(Players:GetPlayers()) do
            pcall(applyHitbox, p)
        end

        task.wait(0.3)
    end
end)

-- TOGGLE
Tabs.ESP:AddToggle("Hitbox", {
    Title = "Hitbox Expand",
    Default = false,
    Callback = function(v)
        hitboxEnabled = v
    end
})

-- SLIDER
Tabs.ESP:AddSlider("HitboxSize", {
    Title = "Hitbox Size",
    Min = 5,
    Max = 30,
    Default = 6,
    Rounding = 0,

    Callback = function(v)
        hitboxSize = v
    end
})

-- Stats 🔥
--========================
-- SERVICES
--========================
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

--========================
-- TIME
--========================
local startTime = tick()

local function formatTime(s)
    local h = math.floor(s / 3600)
    local m = math.floor((s % 3600) / 60)
    local sec = math.floor(s % 60)
    return string.format("%02d:%02d:%02d", h, m, sec)
end

--========================
-- UI (Fluent)
--========================
local TimeLabel = Tabs.Status:AddParagraph({
    Title = "Time",
    Content = "Loading..."
})

local PlayerLabel = Tabs.Status:AddParagraph({
    Title = "Players",
    Content = "Loading..."
})

local PingLabel = Tabs.Status:AddParagraph({
    Title = "Ping",
    Content = "Loading..."
})

local FPSLabel = Tabs.Status:AddParagraph({
    Title = "FPS",
    Content = "Loading..."
})

--========================
-- FPS (REALISTIC)
--========================
local fps = 60
local frameCount = 0
local timeElapsed = 0

RunService.RenderStepped:Connect(function(dt)
    -- กันค่าเพี้ยน
    if dt <= 0 or dt > 0.1 then return end

    frameCount += 1
    timeElapsed += dt

    -- อัปเดตทุก 0.5 วิ
    if timeElapsed >= 0.5 then
        local rawFps = frameCount / timeElapsed

        -- จำกัดค่า
        rawFps = math.clamp(rawFps, 15, 240)

        fps = math.floor(rawFps + 0.5)

        frameCount = 0
        timeElapsed = 0
    end
end)

--========================
-- LOOP UPDATE
--========================
task.spawn(function()
    while true do
        pcall(function()

            -- TIME
            TimeLabel:SetDesc(formatTime(tick() - startTime))

            -- PLAYERS
            PlayerLabel:SetDesc(#Players:GetPlayers())

            -- PING (กันพัง)
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            PingLabel:SetDesc(ping .. " ms")

            -- FPS
            FPSLabel:SetDesc(fps)

        end)

        task.wait(0.5)
    end
end)

-- Credit
Tabs.Credit:AddParagraph({
    Title = "Credit",
    Content = "Made by x2sxqz"
})

Tabs.Credit:AddParagraph({
    Title = "UI Library",
    Content = "Fluent X Reaper"
})

local TweenService = game:GetService("TweenService")

local canClick = true

Tabs.Credit:AddButton({
    Title = "Discord",
    Description = "https://discord.gg/krbmvBQhJD",
    Callback = function()

        if not canClick then return end
        canClick = false

        local link = "https://discord.gg/krbmvBQhJD"
        setclipboard(link)

        local gui = Instance.new("ScreenGui")
        gui.Name = "CustomNotify"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui

        local frame = Instance.new("Frame")
        frame.Parent = gui
        frame.Size = UDim2.new(0, 280, 0, 70)
        frame.Position = UDim2.new(1, 300, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(70, 10, 10)
        frame.BackgroundTransparency = 0.25
        frame.BorderSizePixel = 0

        local stroke = Instance.new("UIStroke", frame)
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255, 60, 60)

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 12)

        local icon = Instance.new("ImageLabel", frame)
        icon.Size = UDim2.new(0, 40, 0, 40)
        icon.Position = UDim2.new(0, 12, 0, 15)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://131279093559313"

        local text = Instance.new("TextLabel", frame)
        text.Size = UDim2.new(1, -70, 1, 0)
        text.Position = UDim2.new(0, 60, 0, 0)
        text.BackgroundTransparency = 1
        text.Text = "Copied Success\n" .. link
        text.TextColor3 = Color3.fromRGB(255, 200, 200)
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Font = Enum.Font.SourceSansSemibold
        text.TextSize = 14

        -- 👉 เข้า
        local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -300, 0, 20)
        })
        tweenIn:Play()

        task.wait(2.5)

        -- 👉 ออก (สำคัญ: ต้องรอให้ tween จบก่อน destroy)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 300, 0, 20),
            BackgroundTransparency = 1
        })

        tweenOut:Play()
        tweenOut.Completed:Wait() -- 🔥 จุดสำคัญมาก

        gui:Destroy()

        task.wait(0.5)
        canClick = true
    end
})

-- Teleport
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local selectedPlayer
local teleportEnabled = false

local function getList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- =========================
-- DROPDOWN (ต้องมี ID + ห้ามมั่ว)
-- =========================
local Dropdown = Tabs.Teleport:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = getList(),
    Multi = false
})

-- 🔥 IMPORTANT: delay bind กัน Fluent บัค
task.defer(function()
    Dropdown:OnChanged(function(value)
        selectedPlayer = Players:FindFirstChild(value)
    end)
end)

-- =========================
-- REFRESH (แบบไม่พัง)
-- =========================
Tabs.Teleport:AddButton({
    Title = "Refresh Players",
    Callback = function()
        task.wait(0.1)

        if Dropdown and Dropdown.SetValues then
            pcall(function()
                Dropdown:SetValues(getList())
            end)
        end
    end
})

-- =========================
-- TELEPORT
-- =========================
Tabs.Teleport:AddToggle("tp", {
    Title = "Teleport",
    Default = false
}):OnChanged(function(state)
    teleportEnabled = state

    if state then
        task.spawn(function()
            while teleportEnabled do
                if selectedPlayer and selectedPlayer.Character then
                    local char = Players.LocalPlayer.Character
                    local target = selectedPlayer.Character

                    if char and target then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        local tRoot = target:FindFirstChild("HumanoidRootPart")

                        if root and tRoot then
                            TweenService:Create(
                                root,
                                TweenInfo.new(0.4),
                                {CFrame = tRoot.CFrame + Vector3.new(0, 3, 0)}
                            ):Play()
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

local spectating = false
local originalCameraSubject = nil
local Camera = workspace.CurrentCamera

-- =========================
-- SPECTATE TOGGLE
-- =========================
Tabs.Teleport:AddToggle("spec", {
    Title = "Spectate Player",
    Default = false
}):OnChanged(function(state)
    spectating = state

    local localPlayer = Players.LocalPlayer

    if state then
        if selectedPlayer and selectedPlayer.Character then
            local humanoid = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                -- เก็บของเดิมไว้
                originalCameraSubject = Camera.CameraSubject

                -- เปลี่ยนไปดูเป้า
                Camera.CameraSubject = humanoid
            end
        end
    else
        -- กลับมาที่ตัวเรา
        if localPlayer.Character then
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end
end)

-- =========================
-- UPDATE TARGET (เวลาเปลี่ยน dropdown)
-- =========================
task.defer(function()
    Dropdown:OnChanged(function(value)
        selectedPlayer = Players:FindFirstChild(value)

        -- ถ้ากำลัง spectate อยู่ → เปลี่ยนทันที
        if spectating and selectedPlayer and selectedPlayer.Character then
            local humanoid = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end)
end)

-- Server 🌟
-- Join low server
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url .. "&cursor=" .. cursor
    end

    local response = game:HttpGet(url)
    return HttpService:JSONDecode(response)
end

local function findLowServer()
    local cursor = nil

    for i = 1, 5 do -- ลองดึงหลายหน้า
        local data = getServers(cursor)

        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                return server.id
            end
        end

        cursor = data.nextPageCursor
        if not cursor then break end
    end
end

-- 🔘 ปุ่ม
Tabs.Server:AddButton({
    Title = "Low Server",
    Description = "Server low players",
    Callback = function()
        local serverId = findLowServer()

        if serverId then
            TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
        end
    end
})

-- Server ⚔️ Rejoim
Tabs.Server:AddButton({
    Title = "Rejoin",
    Description = "กลับเข้าเซิร์ฟเดิม",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            game.Players.LocalPlayer
        )
    end
})

Tabs.Server:AddButton({
    Title = "Server Hop",
    Description = "ไปเซิร์ฟใหม่",
    Callback = function()
        game:GetService("TeleportService"):Teleport(
            game.PlaceId,
            game.Players.LocalPlayer
        )
    end
})

-- JobID
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local currentJobIdInput = ""

-- 📋 Copy JobId
Tabs.Server:AddButton({
    Title = "Copy Job ID",
    Description = "Copy current server Job ID",
    Callback = function()
        if setclipboard then
            setclipboard(game.JobId)
        end
    end
})

-- ⌨️ Input JobId
Tabs.Server:AddInput("JobIdInput", {
    Title = "Job ID",
    Default = "",
    Placeholder = "Paste Job ID here...",
    Callback = function(text)
        currentJobIdInput = text
    end
})

-- 🚀 Join JobId
Tabs.Server:AddButton({
    Title = "Join Server",
    Description = "Join server using Job ID",
    Callback = function()
        if currentJobIdInput == "" then return end

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            currentJobIdInput,
            LocalPlayer
        )
    end
})

-- main tab
-- === ตัวแปรหลัก (ควรมีอยู่แล้วในสคริปต์) ===
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- === ค่าเริ่มต้นของ Aimbot ===
local AimbotSettings = {
    Enabled = false,
    WallCheck = true,
    TargetPart = "Head"
}

-- === ฟังก์ชันตรวจสอบชิ้นส่วน (R6/R15) ===
local function getActualPart(character, choice)
    if choice == "Head" then
        return character:FindFirstChild("Head")
    elseif choice == "Body" then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    elseif choice == "Leg" then
        return character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftFoot")
    end
    return nil
end

-- === ฟังก์ชันเช็คกำแพง (Wall Check) ===
local function IsVisible(targetPart)
    if not AimbotSettings.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {char, targetPart.Parent}
    
    local direction = (targetPart.Position - Camera.CFrame.Position)
    local rayResult = workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
    
    return rayResult == nil
end

-- === ฟังก์ชันสุ่มหาเป้าหมาย ===
local function GetRandomTarget()
    local players = game:GetService("Players"):GetPlayers()
    local visiblePlayers = {}

    for _, player in pairs(players) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = getActualPart(player.Character, AimbotSettings.TargetPart)
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 and IsVisible(targetPart) then
                table.insert(visiblePlayers, player)
            end
        end
    end

    if #visiblePlayers > 0 then
        return visiblePlayers[math.random(1, #visiblePlayers)]
    end
    return nil
end

local CurrentTarget = nil

-- === ลูปการทำงาน Aimbot (Hard Lock) ===
RunService.RenderStepped:Connect(function()
    if AimbotSettings.Enabled then
        local targetPart = CurrentTarget and CurrentTarget.Character and getActualPart(CurrentTarget.Character, AimbotSettings.TargetPart)
        
        -- ถ้าเป้าหมายเดิมไม่อยู่แล้ว หรือตาย หรือโดนบัง ให้หาใหม่
        if not CurrentTarget or not targetPart or 
           CurrentTarget.Character.Humanoid.Health <= 0 or 
           (AimbotSettings.WallCheck and not IsVisible(targetPart)) then
            
            CurrentTarget = GetRandomTarget()
        end

        -- ล็อคมุมกล้องทันที (Hard Lock)
        if CurrentTarget and CurrentTarget.Character then
            local p = getActualPart(CurrentTarget.Character, AimbotSettings.TargetPart)
            if p then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position)
            end
        end
    else
        CurrentTarget = nil
    end
end)

-- === ส่วนของ UI (Tabs.Main) ===

-- Toggle เปิด/ปิด Aimbot
local AimbotToggle = Tabs.Main:AddToggle("AimbotToggle", {
    Title = "Enable Aimbot (Hard Lock)",
    Default = false
})

AimbotToggle:OnChanged(function(Value)
    AimbotSettings.Enabled = Value
end)

-- Toggle เปิด/ปิด Wall Check
local WallCheckToggle = Tabs.Main:AddToggle("WallCheckToggle", {
    Title = "Wall Check",
    Default = true
})

WallCheckToggle:OnChanged(function(Value)
    AimbotSettings.WallCheck = Value
end)

-- Dropdown เลือกจุดที่ต้องการล็อคเป้า
local PartDropdown = Tabs.Main:AddDropdown("PartDropdown", {
    Title = "Target Part",
    Values = {"Head", "Body", "Leg"},
    Multi = false,
    Default = 1, -- เลือก Head เป็นค่าเริ่มต้น
})

PartDropdown:OnChanged(function(Value)
    AimbotSettings.TargetPart = Value
end)



-- Max Zoom
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local DefaultZoom = LocalPlayer.CameraMaxZoomDistance

Tabs.Settings:AddToggle("MaxZoom", {
    Title = "Max Zoom",
    Default = false,

    Callback = function(v)

        if v then
            LocalPlayer.CameraMaxZoomDistance = 999999
        else
            LocalPlayer.CameraMaxZoomDistance = DefaultZoom
        end
    end
})

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- สร้าง UI Timer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiAFK_Timer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0, 220, 0, 50)
Label.Position = UDim2.new(0.5, -110, 0.15, 0) -- กลางจอด้านบน
Label.BackgroundTransparency = 0.3
Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Label.TextColor3 = Color3.fromRGB(0, 255, 0)
Label.TextScaled = true
Label.Visible = false
Label.Font = Enum.Font.GothamBold
Label.Text = "Anti AFK: 00:00"
Label.Parent = ScreenGui

local function formatTime(sec)
    local m = math.floor(sec / 60)
    local s = sec % 60
    return string.format("%02d:%02d", m, s)
end

local running = false
local startTime = 0

Tabs.Settings:AddToggle("AntiAFK", {
    Title = "Anti AFK",
    Default = false,
    Callback = function(v)
        if v then
            getgenv().AntiAFK = true
            running = true
            startTime = os.time()
            Label.Visible = true

            -- อัปเดตเวลา
            task.spawn(function()
                while getgenv().AntiAFK do
                    local elapsed = os.time() - startTime
                    Label.Text = "Anti AFK: " .. formatTime(elapsed)
                    task.wait(1)
                end
            end)

            -- Anti AFK loop
            task.spawn(function()
                while getgenv().AntiAFK do
                    task.wait(1080)

                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)

        else
            getgenv().AntiAFK = false
            running = false
            Label.Visible = false
        end
    end
})

-- FPS BOOST
local optimized = false
local saved = {}

local function applyOptimize(state)
    if state then
        for _, v in ipairs(game:GetDescendants()) do
            
            if v:IsA("Texture") or v:IsA("Decal") then
                saved[v] = v.Transparency
                v.Transparency = 1

            elseif v:IsA("BasePart") then
                saved[v] = {
                    Material = v.Material,
                    Reflectance = v.Reflectance
                }

                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end

        end
    else
        for obj, data in pairs(saved) do
            if obj and obj.Parent then
                if typeof(data) == "table" then
                    obj.Material = data.Material
                    obj.Reflectance = data.Reflectance
                else
                    obj.Transparency = data
                end
            end
        end
        saved = {}
    end
end


--FPS
Tabs.Settings:AddToggle("FPSBoost", {
    Title = "FPS BOOST",
    Default = false
}):OnChanged(function(v)
    optimized = v
    applyOptimize(v)
end)

-- Console
--// SERVICES
local LogService = game:GetService("LogService")

--// STATE
local consoleEnabled = false
local MAX_LOGS = 1000
local logItems = {}

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ReaperConsole"
gui.Parent = game.CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 270)
main.Position = UDim2.new(0.5, -210, 0.5, -135)
main.BackgroundColor3 = Color3.fromRGB(18,18,22)
main.Visible = false
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", main)
stroke.Transparency = 0.85

--// HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,32)
header.BackgroundColor3 = Color3.fromRGB(28,28,34)

Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Reaper Console"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)

--// SCROLL
local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0,34)
scroll.Size = UDim2.new(1,0,1,-70)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", scroll)
padding.PaddingLeft = UDim.new(0,6)
padding.PaddingTop = UDim.new(0,6)

--// BOTTOM
local bottom = Instance.new("Frame", main)
bottom.Size = UDim2.new(1,0,0,32)
bottom.Position = UDim2.new(0,0,1,-32)
bottom.BackgroundColor3 = Color3.fromRGB(24,24,30)

--// CLEAR BUTTON
local clear = Instance.new("TextButton", bottom)
clear.Size = UDim2.new(0,70,0,24)
clear.Position = UDim2.new(1,-80,0.5,-12)
clear.Text = "Clear"
clear.Font = Enum.Font.Gotham
clear.TextSize = 13
clear.BackgroundColor3 = Color3.fromRGB(40,40,50)
clear.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", clear)

--// CLEAR FUNCTION
clear.MouseButton1Click:Connect(function()

	for _,v in ipairs(logItems) do
		if v then
			v:Destroy()
		end
	end

	table.clear(logItems)

	scroll.CanvasPosition = Vector2.new(0,0)
end)

--// CREATE LOG UI
local function createLog(text, msgType)

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-6,0,0)
	container.AutomaticSize = Enum.AutomaticSize.Y

	local prefix = "[INFO]"
	local color = Color3.fromRGB(220,220,220)
	local bg = Color3.fromRGB(30,30,35)

	if msgType == Enum.MessageType.MessageError then

		prefix = "[ERROR]"
		color = Color3.fromRGB(255,80,80)
		bg = Color3.fromRGB(55,25,25)

	elseif msgType == Enum.MessageType.MessageWarning then

		prefix = "[WARN]"
		color = Color3.fromRGB(255,200,0)
		bg = Color3.fromRGB(55,50,20)
	end

	container.BackgroundColor3 = bg

	Instance.new("UICorner", container).CornerRadius = UDim.new(0,6)

	local pad = Instance.new("UIPadding", container)
	pad.PaddingLeft = UDim.new(0,6)
	pad.PaddingRight = UDim.new(0,6)
	pad.PaddingTop = UDim.new(0,4)
	pad.PaddingBottom = UDim.new(0,4)

	local time = os.date("%H:%M:%S")

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1,0,0,0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Code
	label.TextSize = 13
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.RichText = false

	label.Text = "["..time.."] "..prefix.."  "..tostring(text)
	label.TextColor3 = color

	-- hover effect
	container.MouseEnter:Connect(function()
		container.BackgroundColor3 = bg:Lerp(Color3.new(1,1,1), 0.05)
	end)

	container.MouseLeave:Connect(function()
		container.BackgroundColor3 = bg
	end)

	label.Parent = container

	return container
end

--// ADD LOG
local function addLog(text, msgType)

	local item = createLog(text, msgType)
	item.Parent = scroll

	table.insert(logItems, item)

	-- LIMIT
	if #logItems > MAX_LOGS then

		local old = table.remove(logItems, 1)

		if old then
			old:Destroy()
		end
	end

	-- AUTO SCROLL
	task.defer(function()

		scroll.CanvasPosition = Vector2.new(
			0,
			math.max(0, layout.AbsoluteContentSize.Y)
		)
	end)
end

--// LOAD OLD LOGS
for _,log in ipairs(LogService:GetLogHistory()) do
	addLog(log.message, log.messageType)
end

--// LISTEN NEW LOGS
LogService.MessageOut:Connect(function(message, messageType)
	addLog(message, messageType)
end)

--// TOGGLE
Tabs.Settings:AddToggle("Console", {
	Title = "Console",
	Default = false,

	Callback = function(v)
		consoleEnabled = v
		main.Visible = v
	end
})

--=========================
-- ⚙ SETTINGS TAB
--=========================

InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("ReaperHub")
SaveManager:SetFolder("ReaperHub/configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig() -- 🔥 ตัวนี้แหละ

--=========================
-- TOGGLE BUTTON + PURE BLUR
--=========================
if game.CoreGui:FindFirstChild("ToggleUI") then
    game.CoreGui.ToggleUI:Destroy()
end

pcall(function()
    game:GetService("Lighting"):FindFirstChild("MenuBlur"):Destroy()
end)

--=========================
-- SERVICES
--=========================
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

--=========================
-- BLUR
--=========================
local Blur = Instance.new("BlurEffect")
Blur.Name = "MenuBlur"
Blur.Size = 40
Blur.Parent = Lighting

--=========================
-- GUI
--=========================
local gui = Instance.new("ScreenGui")
gui.Name = "ToggleUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = game.CoreGui

--=========================
-- BORDER
--=========================
local border = Instance.new("Frame")
border.Parent = gui
border.Size = UDim2.new(0,0,0,0)
border.BackgroundColor3 = Color3.fromRGB(0,0,0)
border.ZIndex = 1
border.AnchorPoint = Vector2.new(0,0)

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0,14)
borderCorner.Parent = border

--=========================
-- BUTTON
--=========================
local button = Instance.new("ImageButton")
button.Parent = gui
button.Size = UDim2.new(0,60,0,60)
button.Position = UDim2.new(0,20,0.5,0)
button.AnchorPoint = Vector2.new(0,0)

button.BackgroundTransparency = 1
button.ZIndex = 999999
button.AutoButtonColor = false

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = button

--=========================
-- IMAGE
--=========================
local imgOn = "rbxassetid://86279908104891"
local imgOff = "rbxassetid://86279908104891"

button.Image = imgOn
button.ScaleType = Enum.ScaleType.Fit

--=========================
-- AUTO ALIGN
--=========================
local function UpdateBorder()

    local offset = (border.Size.X.Offset - button.Size.X.Offset) / 2

    border.Position = UDim2.new(
        button.Position.X.Scale,
        button.Position.X.Offset - offset,
        button.Position.Y.Scale,
        button.Position.Y.Offset - offset
    )
end

UpdateBorder()

--=========================
-- DRAG SYSTEM
--=========================
local dragging = false
local dragStart, startPos

button.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = button.Position
    end
end)

UIS.InputChanged:Connect(function(input)

    if dragging then

        local delta = input.Position - dragStart

        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        UpdateBorder()
    end
end)

UIS.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

--=========================
-- BLUR FUNCTIONS
--=========================
local function OpenBlur()

    TweenService:Create(
        Blur,
        TweenInfo.new(
            0.3,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Size = 40
        }
    ):Play()
end

local function CloseBlur()

    TweenService:Create(
        Blur,
        TweenInfo.new(
            0.25,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Size = 0
        }
    ):Play()
end

--=========================
-- TOGGLE
--=========================
local isOpen = true

button.MouseButton1Click:Connect(function()

    isOpen = not isOpen

    if Window then
        Window:Minimize(not isOpen)
    end

    button.Image = isOpen and imgOn or imgOff

    -- BLUR
    if isOpen then
        OpenBlur()
    else
        CloseBlur()
    end
end)
