local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Reaper Hub",
    SubTitle = "Rewrite",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- Tab
local Tabs = {
    Main = v2:AddTab({ Title = "หน้าหลัก", Icon = "home" }),
    Sea = v2:AddTab({ Title = "อีเว้นท์", Icon = "moon" }),
    Item = v2:AddTab({ Title = "ไอเท็ม", Icon = "box" }),
    Setting = v2:AddTab({ Title = "ตั้งค่า", Icon = "settings" }),
    Stats = v2:AddTab({ Title = "ค่าพลัง", Icon = "bar-chart" }),
    Player = v2:AddTab({ Title = "ผู้เล่น", Icon = "user" }),
    Teleport = v2:AddTab({ Title = "เทเลพอร์ต", Icon = "map-pin" }),
    Fruit = v2:AddTab({ Title = "เครื่องมือ", Icon = "wrench" }),
    Raid = v2:AddTab({ Title = "ลงดัน", Icon = "sword" }),
    Race = v2:AddTab({ Title = "เผ่า", Icon = "award" }),
    Shop = v2:AddTab({ Title = "ร้านค้า", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
    
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Fluent:Notify({
    Title = "Reaper Hub",
    Content = "Wellcome to Reaper.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

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
