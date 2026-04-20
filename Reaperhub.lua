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
-- 🔥 ESP SYSTEM (ACCURATE FIX)
--=========================
local ESPObjects = {}
local BoxColor = Color3.fromRGB(255,0,0)
local LineColor = Color3.fromRGB(0,255,0)

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

local function ClearESP()
for _,v in pairs(ESPObjects) do
pcall(function()
v.box:Remove()
v.line:Remove()
end)
end
ESPObjects = {}
end

local function InitESP()
ClearESP()

for _,p in ipairs(Players:GetPlayers()) do  
    if p ~= LP then  
        ESPObjects[p] = CreateESP()  
    end  
end

end

Players.PlayerAdded:Connect(function(p)
if State.ESP and p ~= LP then
ESPObjects[p] = CreateESP()
end
end)

Players.PlayerRemoving:Connect(function(p)
if ESPObjects[p] then
pcall(function()
ESPObjects[p].box:Remove()
ESPObjects[p].line:Remove()
end)
ESPObjects[p] = nil
end
end)

--=========================
-- 🔥 BOX SIZE CALC (FIXED REAL)
--=========================
local function GetBox(char)
local hrp = char:FindFirstChild("HumanoidRootPart")
local head = char:FindFirstChild("Head")
if not hrp or not head then return nil end

local headPos = Camera:WorldToViewportPoint(head.Position)  
local rootPos = Camera:WorldToViewportPoint(hrp.Position)  

local height = math.abs(headPos.Y - rootPos.Y) * 2  
local width = height / 1.5  

return width, height, rootPos

end

--=========================
-- 🔥 ESP LOOP (FIXED ACCURATE)
--=========================
RunService.RenderStepped:Connect(function()
if not State.ESP then return end

for plr,obj in pairs(ESPObjects) do  
    pcall(function()  
        local char = plr.Character  
        if not char then return end  

        local hrp = char:FindFirstChild("HumanoidRootPart")  
        if not hrp then return end  

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)  

        if onScreen then  
            local w,h,root2D = GetBox(char)  
            if not w or not h then return end  

            -- ✔ BOX (accurate head-to-root)  
            obj.box.Size = Vector2.new(w, h)  
            obj.box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)  
            obj.box.Color = BoxColor  
            obj.box.Visible = true  

            -- ✔ LINE (perfect center bottom)  
            obj.line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)  
            obj.line.To = Vector2.new(root2D.X, root2D.Y)  
            obj.line.Color = LineColor  
            obj.line.Visible = true  
        else  
            obj.box.Visible = false  
            obj.line.Visible = false  
        end  
    end)  
end

end)

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
-- 🔥 TOGGLE BUTTON (TOP LAYER)
--=========================
if game.CoreGui:FindFirstChild("ToggleUI") then
    game.CoreGui.ToggleUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ToggleUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = game.CoreGui

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0,50,0,50)
button.Position = UDim2.new(0,20,0.5,0)
button.Text = ""
button.BackgroundColor3 = Color3.fromRGB(0,255,0)

Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

local isOpen = true
local dragging=false
local dragStart,startPos

button.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=i.Position
        startPos=button.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging then
        local delta=i.Position-dragStart
        button.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

button.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Window:Minimize(not isOpen)
    button.BackgroundColor3 = isOpen and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

task.wait(1)
--// มุดดิน V2

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local toggled = false
local savedCFrame
local lockConnection

local OFFSET_Y = 6

--================ GUI =================--

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "InvisClean"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 95)
frame.Position = UDim2.new(0.42, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,55)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- ขอบเข้ม
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(10,10,15)
stroke.Transparency = 0.1

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "มุดดิน V2"
title.TextColor3 = Color3.fromRGB(220,220,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Button (ล่าง)
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.7,0,0,32)
button.Position = UDim2.new(0.15,0,0.55,0)
button.Text = "ปิด"
button.BackgroundColor3 = Color3.fromRGB(255,0,0)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 16

Instance.new("UICorner", button).CornerRadius = UDim.new(0,10)

--================ SYSTEM =================--

local function refresh()
	char = player.Character or player.CharacterAdded:Wait()
	hrp = char:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(function()
	task.wait(1)
	refresh()
end)

-- ล็อกตำแหน่ง
local function lockPosition(cf)
	if lockConnection then lockConnection:Disconnect() end

	lockConnection = RunService.RenderStepped:Connect(function()
		if hrp then
			hrp.CFrame = cf
			hrp.Velocity = Vector3.zero
			hrp.RotVelocity = Vector3.zero
		end
	end)
end

local function unlock()
	if lockConnection then
		lockConnection:Disconnect()
		lockConnection = nil
	end
end

--================ TOGGLE =================--

button.MouseButton1Click:Connect(function()
	refresh()

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

task.wait(1)
--// Services Tp Fly
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local TWEEN_SPEED = 2
local SKY_HEIGHT = 150

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPFlyUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 85) -- เล็กลง
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

-- ชื่อ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 22)
Title.Position = UDim2.new(0, 0, 0, 3)
Title.BackgroundTransparency = 1
Title.Text = "TP Fly"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- ปุ่ม
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 140, 0, 36)
Button.Position = UDim2.new(0.5, -70, 0, 35)
Button.Text = "Tween"
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- เขียว
Button.BorderSizePixel = 0
Button.Parent = Frame
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

--// Random Player
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

--// Action
local working = false

Button.MouseButton1Click:Connect(function()
    if working then return end
    working = true

    -- เปลี่ยนสถานะปุ่ม
    Button.Text = "Tween..."
    Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- แดง

    local targetPlayer = getRandomPlayer()
    if not targetPlayer then
        working = false
        Button.Text = "Tween"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        return
    end

    local char = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if not char or not targetChar then
        working = false
        Button.Text = "Tween"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        return
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetHRP then
        working = false
        Button.Text = "Tween"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        return
    end

    -- 1: วาปขึ้นฟ้า
    hrp.CFrame = hrp.CFrame + Vector3.new(0, SKY_HEIGHT, 0)
    task.wait(0.2)

    -- 2: Tween ไปเหนือเป้า
    local above = targetHRP.Position + Vector3.new(0, 120, 0)
    local tween1 = TweenService:Create(
        hrp,
        TweenInfo.new(TWEEN_SPEED, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(above)}
    )
    tween1:Play()
    tween1.Completed:Wait()

    -- 3: วาปลงใกล้ๆ
    hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 10, 0))
    task.wait(0.1)

    -- 4: Tween เข้าเป้า
    local tween2 = TweenService:Create(
        hrp,
        TweenInfo.new(TWEEN_SPEED / 2, Enum.EasingStyle.Quad),
        {CFrame = targetHRP.CFrame}
    )
    tween2:Play()
    tween2.Completed:Wait()

    -- กลับสถานะปุ่ม
    Button.Text = "Tween"
    Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    working = false
end)
