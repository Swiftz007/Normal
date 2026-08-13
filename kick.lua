local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- === 1. ระบบ Auto Rejoin (รันดักไว้ก่อน) ===
GuiService.ErrorMessageChanged:Connect(function()
    local message = GuiService:GetErrorMessage()
    if message ~= "" then
        warn("Detected Kick: " .. message)
        task.wait(2) -- รอ 2 วินาทีก่อนเริ่ม Rejoin
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

-- === 2. สร้าง GUI สำหรับทดสอบ ===
-- ลบ GUI เก่าถ้ามีอยู่
if CoreGui:FindFirstChild("RejoinTestUI") then
    CoreGui.RejoinTestUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RejoinTestUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากไปมาได้
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame

local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(0, 180, 0, 80)
TestButton.Position = UDim2.new(0, 10, 0, 10)
TestButton.Text = "CLICK TO KICK\n(TEST REJOIN)"
TestButton.TextColor3 = Color3.new(1, 1, 1)
TestButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
TestButton.Font = Enum.Font.GothamBold
TestButton.TextSize = 14
TestButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.Parent = TestButton

-- === 3. คำสั่ง Kick เมื่อกดปุ่ม ===
TestButton.MouseButton1Click:Connect(function()
    LocalPlayer:Kick("\n[Rejoin System Test]\nคุณถูกเตะเพื่อทดสอบระบบ Auto Rejoin")
end)

print("Rejoin Test Script Loaded! (ปุ่มอยู่กลางหน้าจอ)")
