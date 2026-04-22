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
SubTitle = "Beta 5.0",
TabWidth = 160,
Size = UDim2.fromOffset(520, 360),
Acrylic = true,
Theme = "Dark",
MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
Credit = Window:AddTab({ Title = "Credit", Icon = "code" }),
Main = Window:AddTab({ Title = "Main", Icon = "home" }),
Teleport = Window:AddTab({ Title = "Teleport", Icon = "menu" }),
ESP = Window:AddTab({ Title = "ESP", Icon = "box" }),
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

--=========================
-- 🔥 CHARACTER HOOK
--=========================
local function HookChar(char)
local hum = char:WaitForChild("Humanoid")
task.wait(0.1)

DefaultWS = hum.WalkSpeed  
DefaultJP = hum.UseJumpPower and hum.JumpPower or 50

end

if LP.Character then HookChar(LP.Character) end
LP.CharacterAdded:Connect(HookChar)

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

hum.WalkSpeed = State.WS and WSValue or DefaultWS  

hum.UseJumpPower = true  
hum.JumpPower = State.JP and JPValue or DefaultJP  

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
Tabs.Main:AddToggle("WS", {
Title = "WalkSpeed",
Default = false,
Callback = function(v) State.WS = v end
})

Tabs.Main:AddInput("WSV", {
Title = "Speed Value",
Default = "16",
Callback = function(v)
WSValue = tonumber(v) or 16
end
})

Tabs.Main:AddToggle("JP", {
Title = "JumpPower",
Default = false,
Callback = function(v) State.JP = v end
})

Tabs.Main:AddInput("JPV", {
Title = "Jump Value",
Default = "50",
Callback = function(v)
JPValue = tonumber(v) or 50
end
})

Tabs.Main:AddToggle("INFJ", {
Title = "Infinite Jump",
Default = false,
Callback = function(v) State.INFJ = v end
})

Tabs.Main:AddToggle("NC", {
Title = "Noclip",
Default = false,
Callback = function(v) State.NC = v end
})

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

-- Credit
Tabs.Credit:AddParagraph({
    Title = "Credit",
    Content = "Make by : x2sxqz"
})

Tabs.Credit:AddParagraph({
    Title = "Discord",
    Content = "https://discord.gg/krbmvBQhJD"
})

Tabs.Credit:AddParagraph({
    Title = "UX/UI",
    Content = "Fluent"
})

Tabs.Credit:AddParagraph({
    Title = "Optimize",
    Content = "Make by : x2sxqz"
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

-- Server ⚔️
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

--=========================
-- ⚙ SETTINGS TAB
--=========================

InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("FluentHub")
SaveManager:SetFolder("FluentHub/configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig() -- 🔥 ตัวนี้แหละ

--=========================
-- 🔥 TOGGLE BUTTON (PERFECT)
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
-- 🔳 BORDER (ขอบดำหนา)
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
-- 🔘 BUTTON
--=========================
local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0,50,0,50)
button.Position = UDim2.new(0,20,0.5,0)
button.Text = ""
button.BackgroundColor3 = Color3.fromRGB(0,255,0)
button.ZIndex = 999999
button.AnchorPoint = Vector2.new(0,0)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = button

--=========================
-- 🔥 AUTO ALIGN (เป๊ะจริง)
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
-- 🔥 DRAG SYSTEM
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
-- 🔥 TOGGLE
--=========================
local isOpen = true

button.MouseButton1Click:Connect(function()
    isOpen = not isOpen

    if Window then
        Window:Minimize(not isOpen)
    end

    button.BackgroundColor3 = isOpen 
        and Color3.fromRGB(0,255,0) 
        or Color3.fromRGB(255,0,0)
end)
