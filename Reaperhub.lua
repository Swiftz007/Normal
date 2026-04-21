-- Loading Screen Script (LocalScript)
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- BLUR
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 50}):Play()

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 0.4
bg.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,80)
title.Position = UDim2.new(0,0,0.25,0)
title.BackgroundTransparency = 1
title.Text = "Reaper Hub"
title.TextSize = 44
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextStrokeTransparency = 0.5
title.Parent = bg

-- BAR BG
local barBG = Instance.new("Frame")
barBG.Size = UDim2.new(0.4,0,0,8)
barBG.Position = UDim2.new(0.3,0,0.5,0)
barBG.BackgroundColor3 = Color3.fromRGB(60,60,60)
barBG.BorderSizePixel = 0
barBG.Parent = bg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = barBG

-- BAR
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
bar.BorderSizePixel = 0
bar.Parent = barBG

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(1,0)
corner2.Parent = bar

-- PERCENT TEXT
local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1,0,0,30)
percentText.Position = UDim2.new(0,0,1,5)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextSize = 20
percentText.Font = Enum.Font.GothamBold
percentText.TextColor3 = Color3.fromRGB(255,255,255)
percentText.Parent = barBG

-- CHANGING TEXT
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1,0,0,30)
infoText.Position = UDim2.new(0,0,0.6,0)
infoText.BackgroundTransparency = 1
infoText.Text = ""
infoText.TextSize = 18
infoText.Font = Enum.Font.Gotham
infoText.TextColor3 = Color3.fromRGB(200,200,200)
infoText.Parent = bg

-- TEXT LIST
local messages = {
	"Reaper Hub better",
	"Credit : Quantum X Reaper",
	"Code : Lua"
}

-- TEXT LOOP
task.spawn(function()
	local i = 1
	while true do
		infoText.Text = messages[i]
		i = i + 1
		if i > #messages then i = 1 end
		task.wait(1.5)
	end
end)

-- LOADING ANIMATION
for i = 1,100 do
	local progress = i/100
	
	TweenService:Create(bar, TweenInfo.new(0.05), {
		Size = UDim2.new(progress,0,1,0)
	}):Play()
	
	percentText.Text = i.."%"
	task.wait(0.05)
end

-- WAIT นิดให้เต็ม 100%
task.wait(0.3)

-- FADE OUT
TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(bar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(barBG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(percentText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(infoText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()

task.wait(0.6)

screenGui:Destroy()
blur:Destroy()

task.wait(2)

--=========================
-- 🔥 FLUENT LOAD
--=========================
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
SubTitle = "Premium X",
TabWidth = 160,
Size = UDim2.fromOffset(520, 360),
Acrylic = true,
Theme = "Dark",
MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
Main = Window:AddTab({ Title = "Main", Icon = "user" }),
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

Tabs.Main:AddToggle("ESP", {
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

Tabs.Main:AddColorpicker("BoxColor", {
Title = "Box Color",
Default = BoxColor,
Callback = function(v)
if typeof(v) == "Color3" then
BoxColor = v
end
end
})

Tabs.Main:AddColorpicker("LineColor", {
Title = "Line Color",
Default = LineColor,
Callback = function(v)
if typeof(v) == "Color3" then
LineColor = v
end
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
