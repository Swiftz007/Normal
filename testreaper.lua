local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
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
SubTitle = "lib Beta 10.7",
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
-- FIND TITLE (Reaper Hub)
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
-- GET TOPBAR FROM TITLE
-- =========================
local TopBar = Title.Parent
if not TopBar then
    return warn("TopBar not found")
end

-- =========================
-- ADD PADDING TO TITLE
-- =========================
local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 32) -- ปรับได้ตามขนาดโลโก้
Padding.Parent = Title

-- =========================
-- CREATE LOGO
-- =========================
local Logo = Instance.new("ImageLabel")
Logo.Name = "ReaperLogo"
Logo.Parent = TopBar

Logo.Image = "rbxassetid://86279908104891"
Logo.BackgroundTransparency = 1

Logo.Size = UDim2.new(0, 24, 0, 24)
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.Position = UDim2.new(0, 6, 0.5, -12)

Logo.ScaleType = Enum.ScaleType.Fit

-- =========================
-- FORCE LEFT (IMPORTANT)
-- =========================
Logo.LayoutOrder = -1

-- =========================
-- OPTIONAL STYLE
-- =========================
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1
Stroke.Transparency = 0.3
Stroke.Parent = Logo

-- Tab
local Tabs = {
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

--================ WALK TP (DASH REAL) =================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local enabled = false
local canDash = true

local DASH_POWER = 600 -- แรงพุ่ง
local COOLDOWN = 2   -- กัน spam

local connection

local function getChar()
    return LocalPlayer.Character
end

local function getHRP()
    local char = getChar()
    if not char then return end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getChar()
    if not char then return end
    return char:FindFirstChildOfClass("Humanoid")
end

local function start()
    if connection then connection:Disconnect() end

    connection = RunService.RenderStepped:Connect(function()
        if not enabled or not canDash then return end

        local humanoid = getHumanoid()
        local hrp = getHRP()
        if not humanoid or not hrp then return end

        local moveDir = humanoid.MoveDirection

        -- ถ้ามีการกดเดิน
        if moveDir.Magnitude > 0 then
            canDash = false

            -- 🔥 พุ่งไปตามทิศที่กด
            hrp.Velocity = moveDir.Unit * DASH_POWER + Vector3.new(0, hrp.Velocity.Y, 0)

            -- cooldown
            task.delay(COOLDOWN, function()
                canDash = true
            end)
        end
    end)
end

local function stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- รีตัว
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if enabled then
        start()
    end
end)

-- UI
Tabs.Player:AddToggle("WalkTP", {
    Title = "WalkTP",
    Default = false,
    Callback = function(v)
        enabled = v

        if v then
            start()
        else
            stop()
        end
    end
})

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
    Min = 0,
    Max = 100,
    Default = 20,
	Rounding = 0,
    Callback = function(v)
        spinSpeed = v
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

-- Add Hitbox
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local hitboxEnabled = false

local function applyHitbox(player)
    if player == LocalPlayer then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if hitboxEnabled then
        root.Size = Vector3.new(6,6,6)
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

task.spawn(function()
    while true do
        for _, p in ipairs(Players:GetPlayers()) do
            pcall(applyHitbox, p)
        end
        task.wait(0.3)
    end
end)

Tabs.ESP:AddToggle("Hitbox", {
    Title = "Hitbox Expand",
    Default = false
}):OnChanged(function(v)
    hitboxEnabled = v
end)

-- Credit
Tabs.Credit:AddParagraph({
    Title = "Credit",
    Content = "Made by x2sxqz"
})

Tabs.Credit:AddParagraph({
    Title = "Discord",
    Content = "https://discord.gg/krbmvBQhJD"
})

Tabs.Credit:AddParagraph({
    Title = "UI Library",
    Content = "Fluent UI"
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
    Title = "Teleport Tween",
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
--================ TP FLY =================--

local tpGui = nil

function createTPFly()
    if tpGui then return end

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer

    local TWEEN_SPEED = 2
    local SKY_HEIGHT = 150

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TPFlyUI"
    ScreenGui.Parent = game.CoreGui
    tpGui = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 180, 0, 85)
    Frame.Position = UDim2.new(0.5, -90, 0.5, -42)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BackgroundTransparency = 0.35
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(10,10,10)
    Stroke.Thickness = 2
    Stroke.Transparency = 0.1
    Stroke.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 22)
    Title.Position = UDim2.new(0, 0, 0, 3)
    Title.BackgroundTransparency = 1
    Title.Text = "TP Fly"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 140, 0, 36)
    Button.Position = UDim2.new(0.5, -70, 0, 35)
    Button.Text = "Tween"
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    Button.BorderSizePixel = 0
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 14)

    local function getRandomPlayer()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p)
            end
        end
        if #list == 0 then return nil end
        return list[math.random(1, #list)]
    end

    local working = false

    Button.MouseButton1Click:Connect(function()
        if working then return end
        working = true

        Button.Text = "Tween..."
        Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

        local targetPlayer = getRandomPlayer()
        if not targetPlayer or not targetPlayer.Character then
            Button.Text = "Tween"
            Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            working = false
            return
        end

        local char = LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then return end

        hrp.CFrame = hrp.CFrame + Vector3.new(0, SKY_HEIGHT, 0)
        task.wait(0.2)

        local above = targetHRP.Position + Vector3.new(0, 120, 0)
        local tween1 = TweenService:Create(hrp, TweenInfo.new(TWEEN_SPEED), {CFrame = CFrame.new(above)})
        tween1:Play()
        tween1.Completed:Wait()

        hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 10, 0))
        task.wait(0.1)

        local tween2 = TweenService:Create(hrp, TweenInfo.new(TWEEN_SPEED/2), {CFrame = targetHRP.CFrame})
        tween2:Play()
        tween2.Completed:Wait()

        Button.Text = "Tween"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        working = false
    end)
end

function removeTPFly()
    if tpGui then
        tpGui:Destroy()
        tpGui = nil
    end
end

--================ INVIS V2 =================--

local invisGui = nil
local lockConnection = nil
local toggled = false
local savedCFrame = nil

function createInvis()
    if invisGui then return end

    local player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")

    local OFFSET_Y = 6

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "InvisClean"
    gui.ResetOnSpawn = false
    invisGui = gui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 180, 0, 95)
    frame.Position = UDim2.new(0.42, 0, 0.35, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,55)
    frame.BackgroundTransparency = 0.2
    frame.Active = true
    frame.Draggable = true

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(10,10,15)
    stroke.Transparency = 0.1

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,28)
    title.BackgroundTransparency = 1
    title.Text = "มุดดิน V2"
    title.TextColor3 = Color3.fromRGB(220,220,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.7,0,0,32)
    button.Position = UDim2.new(0.15,0,0.55,0)
    button.Text = "ปิด"
    button.BackgroundColor3 = Color3.fromRGB(255,0,0)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16

    Instance.new("UICorner", button).CornerRadius = UDim.new(0,10)

    local function lockPosition(cf)
        if lockConnection then lockConnection:Disconnect() end

        lockConnection = RunService.RenderStepped:Connect(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            hrp.CFrame = cf
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end)
    end

    local function unlock()
        if lockConnection then
            lockConnection:Disconnect()
            lockConnection = nil
        end
    end

    button.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if not toggled then
            savedCFrame = hrp.CFrame
            local target = hrp.CFrame - Vector3.new(0, OFFSET_Y, 0)

            lockPosition(target)

            button.Text = "เปิด"
            button.BackgroundColor3 = Color3.fromRGB(0,255,0)
            toggled = true
        else
            unlock()

            if savedCFrame then
                hrp.CFrame = savedCFrame
            end

            button.Text = "ปิด"
            button.BackgroundColor3 = Color3.fromRGB(255,0,0)
            toggled = false
        end
    end)
end

function removeInvis()
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end

    if invisGui then
        invisGui:Destroy()
        invisGui = nil
    end

    toggled = false
end

--================ TOGGLE (ใช้ Callback เท่านั้น) =================--

Tabs.Main:AddToggle("TPFlyUI", {
    Title = "Floating TpFly ",
    Default = false,
    Callback = function(v)
        if v then
            createTPFly()
        else
            removeTPFly()
        end
    end
})

Tabs.Main:AddToggle("InvisUI", {
    Title = "Floating มุดดิน V2",
    Default = false,
    Callback = function(v)
        if v then
            createInvis()
        else
            removeInvis()
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
local MAX_LOGS = 60
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

-- CLEAR
local clear = Instance.new("TextButton", bottom)
clear.Size = UDim2.new(0,70,0,24)
clear.Position = UDim2.new(1,-80,0.5,-12)
clear.Text = "Clear"
clear.Font = Enum.Font.Gotham
clear.TextSize = 13
clear.BackgroundColor3 = Color3.fromRGB(40,40,50)
clear.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", clear)

-- CLEAR FUNCTION
clear.MouseButton1Click:Connect(function()
	for _, v in ipairs(logItems) do
		if v then v:Destroy() end
	end
	logItems = {}
	scroll.CanvasSize = UDim2.new(0,0,0,0)
end)

--// CREATE LOG UI
local function createLog(text, msgType)

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 0)
	container.AutomaticSize = Enum.AutomaticSize.Y

	local prefix = "[INFO]"
	local color = Color3.fromRGB(200,200,200)
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

	label.Text = "["..time.."] "..prefix.."  "..text
	label.TextColor3 = color

	-- hover effect
	container.MouseEnter:Connect(function()
		container.BackgroundColor3 = bg:lerp(Color3.new(1,1,1), 0.05)
	end)
	container.MouseLeave:Connect(function()
		container.BackgroundColor3 = bg
	end)

	return container
end

--// ADD LOG
local function addLog(text, msgType)
	if not consoleEnabled then return end

	local item = createLog(text, msgType)
	item.Parent = scroll

	table.insert(logItems, item)

	-- limit logs
	if #logItems > MAX_LOGS then
		logItems[1]:Destroy()
		table.remove(logItems, 1)
	end

	scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 6)
end

--// LISTEN
LogService.MessageOut:Connect(function(message, messageType)
	addLog(message, messageType)
end)

--// FLUENT TOGGLE
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
-- 🔥 TOGGLE BUTTON (PERFECT - IMAGE ONLY CHANGE)
--=========================
if game.CoreGui:FindFirstChild("ToggleUI") then
    game.CoreGui.ToggleUI:Destroy()
end

local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "ToggleUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = game.CoreGui

--=========================
-- 🔳 BORDER (เหมือนเดิม)
--=========================
local border = Instance.new("Frame")
border.Parent = gui
border.Size = UDim2.new(0,56,0,56)
border.BackgroundColor3 = Color3.fromRGB(0,0,0)
border.ZIndex = 999998
border.AnchorPoint = Vector2.new(0,0)

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0,14)
borderCorner.Parent = border

--=========================
-- 🔘 BUTTON (เปลี่ยนจาก TextButton → ImageButton)
--=========================
local button = Instance.new("ImageButton")
button.Parent = gui
button.Size = UDim2.new(0,70,0,70)
button.Position = UDim2.new(0,20,0.5,0)
button.AnchorPoint = Vector2.new(0,0)

button.BackgroundTransparency = 1
button.ZIndex = 999999
button.AutoButtonColor = false

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = button

-- 🔥 รูป ON / OFF
local imgOn = "rbxassetid://86279908104891"
local imgOff = "rbxassetid://86279908104891" -- ถ้ามีรูปปิดค่อยเปลี่ยน

button.Image = imgOn
button.ScaleType = Enum.ScaleType.Fit

--=========================
-- 🔥 AUTO ALIGN (เหมือนเดิม)
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
-- 🔥 DRAG SYSTEM (เหมือนเดิม)
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
-- 🔥 TOGGLE (เหมือนเดิม + เปลี่ยนแค่รูป)
--=========================
local isOpen = true

button.MouseButton1Click:Connect(function()
    isOpen = not isOpen

    if Window then
        Window:Minimize(not isOpen)
    end

    -- 🔥 เปลี่ยนจากสี → รูป
    button.Image = isOpen and imgOn or imgOff
end)
