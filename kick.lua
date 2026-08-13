local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าถ้ามีค้างอยู่
if CoreGui:FindFirstChild("TestKickUI") then
    CoreGui.TestKickUI:Destroy()
end

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestKickUI"
ScreenGui.Parent = CoreGui

-- ปุ่มกด
local KickButton = Instance.new("TextButton")
KickButton.Size = UDim2.new(0, 150, 0, 50)
KickButton.Position = UDim2.new(0.5, -75, 0.1, 0) -- อยู่ด้านบนกลางหน้าจอ
KickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
KickButton.Text = "KICK"
KickButton.TextColor3 = Color3.new(1, 1, 1)
KickButton.Font = Enum.Font.GothamBold
KickButton.TextSize = 14
KickButton.Parent = ScreenGui

-- ใส่ขอบมน
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = KickButton

-- ระบบลากปุ่มได้ (เผื่อบังจอ)
KickButton.Active = true
KickButton.Draggable = true

-- คำสั่งเตะเมื่อกดปุ่ม
KickButton.MouseButton1Click:Connect(function()
    LocalPlayer:Kick("\n[TEST KICK]\nคุณทำการเตะตัวเองสำเร็จ!")
end)
