--[[
    ===================================================
    REAPER HUB | KEY SYSTEM + MAIN SCRIPT HUB (TEXT FIXED)
    ===================================================
]]--

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 🔗 ลิงก์เว็บไซต์ Get Key ของคุณ
local GETKEY_URL = "https://reapersystem.netlify.app/"

-- 🔗 ลิงก์ Firebase Realtime Database ของคุณ
local DATABASE_URL = "https://keysystem-reaper-default-rtdb.asia-southeast1.firebasedatabase.app/keys/"

-- ลบ UI เก่าทิ้งถ้ามีอยู่
if PlayerGui:FindFirstChild("ReaperHubRedKeyUI") then
    PlayerGui.ReaperHubRedKeyUI:Destroy()
end

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHubRedKeyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- สร้างหน้าต่างหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 265)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -132.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 9, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- ทำมุมโค้ง (UICorner)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = MainFrame

-- ขอบเรืองแสงสีแดงเข้มเด่นชัด (UIStroke)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(239, 68, 68)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- โลโก้สี่เหลี่ยมขอบมน (Rounded Square Logo Container)
local LogoContainer = Instance.new("ImageLabel")
LogoContainer.Size = UDim2.new(0, 48, 0, 48)
LogoContainer.Position = UDim2.new(0.5, -24, 0, 16)
LogoContainer.BackgroundTransparency = 1
LogoContainer.Image = "rbxassetid://86279908104891"
LogoContainer.Parent = MainFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = LogoContainer

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(239, 68, 68)
LogoStroke.Thickness = 1
LogoStroke.Parent = LogoContainer

-- หัวข้อ (Title: REAPER HUB | Key System)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Position = UDim2.new(0, 0, 0, 72)
Title.BackgroundTransparency = 1
Title.Text = "REAPER HUB | Key System"
Title.TextColor3 = Color3.fromRGB(248, 250, 252)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- กล่องกรอกคีย์ (TextBox)
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 320, 0, 44)
KeyBox.Position = UDim2.new(0.5, -160, 0, 104)
KeyBox.BackgroundColor3 = Color3.fromRGB(13, 19, 33)
KeyBox.PlaceholderText = "Paste your key here..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(248, 113, 113)
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
KeyBox.TextSize = 12
KeyBox.Font = Enum.Font.Code
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 12)
BoxCorner.Parent = KeyBox

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Color3.fromRGB(30, 41, 59)
BoxStroke.Thickness = 1.5
BoxStroke.Parent = KeyBox

-- ปุ่ม Get Key button
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0, 152, 0, 40)
GetKeyBtn.Position = UDim2.new(0.5, -160, 0, 158)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.TextSize = 12
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Parent = MainFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 12)
GetKeyCorner.Parent = GetKeyBtn

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(51, 65, 85)
GetKeyStroke.Thickness = 1
GetKeyStroke.Parent = GetKeyBtn

-- ปุ่ม Verify Button (ปรับ TextColor3 เป็นสีขาวชัดเจน)
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0, 152, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, 8, 0, 158)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
VerifyBtn.Text = "Verify"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- แก้ไขให้เป็นสีขาว
VerifyBtn.TextSize = 12
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Parent = MainFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 12)
VerifyCorner.Parent = VerifyBtn

local VerifyGradient = Instance.new("UIGradient")
VerifyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(239, 68, 68)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 27, 27))
})
VerifyGradient.Parent = VerifyBtn

-- สถานะแจ้งเตือน (Status Label)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 24)
StatusLabel.Position = UDim2.new(0, 0, 0, 210)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = MainFrame

-- ===================================================
-- ⚙️ LOGIC & FUNCTIONS (ระบบการทำงานของปุ่ม)
-- ===================================================

local function GetHWID()
    local success, clientId = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if success and clientId then
        return clientId
    end
    return tostring(LocalPlayer.UserId)
end

-- ฟังก์ชันส่ง HTTP Request ที่รองรับทุก Executor อย่างปลอดภัย
local function SafeHttpRequest(requestData)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local success, result = pcall(function()
            return req(requestData)
        end)
        if success then
            return result
        end
    end
    return nil
end

-- กดปุ่ม Get Key (คัดลอกลิงก์)
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(GETKEY_URL)
        StatusLabel.Text = "Link Copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(52, 211, 153)
    else
        StatusLabel.Text = "Executor not Support!"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
    end
end)

-- กดปุ่ม Verify (ตรวจสอบคีย์กับ Firebase)
VerifyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyBox.Text
    
    if userKey == "" or userKey == " " then
        StatusLabel.Text = "Please enter Key!"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    if not string.match(userKey, "^REAPER%-[A-Z0-9]+%-[A-Z0-9]+%-[A-Z0-9]+$") then
        StatusLabel.Text = "Invalid Key"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    StatusLabel.Text = "Verifying key..."
    StatusLabel.TextColor3 = Color3.fromRGB(250, 204, 21)

    local requestUrl = DATABASE_URL .. userKey .. ".json"
    local success, responseRaw = pcall(function()
        return game:HttpGet(requestUrl)
    end)

    if not success or not responseRaw or responseRaw == "null" then
        StatusLabel.Text = "Key not found"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    local decodeSuccess, keyData = pcall(function()
        return HttpService:JSONDecode(responseRaw)
    end)

    if not decodeSuccess or not keyData then
        StatusLabel.Text = "DataBase Error!"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    local currentTime = os.time() * 1000
    if currentTime > (keyData.expiresAt or 0) then
        StatusLabel.Text = "Key has expired!"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    local currentHWID = GetHWID()
    if not keyData.hwid or keyData.hwid == "" then
        SafeHttpRequest({
            Url = requestUrl,
            Method = "PATCH",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ hwid = currentHWID })
        })
    elseif keyData.hwid ~= currentHWID then
        StatusLabel.Text = "Invalid HWID"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    StatusLabel.Text = "Loading script..."
    StatusLabel.TextColor3 = Color3.fromRGB(52, 211, 153)
    
    task.wait(1)
    ScreenGui:Destroy()

    -- ===============================================
    -- 🟢 รันสคริปต์หลักของคุณหลังจากผ่านการ Verify 🟢
    -- ===============================================
    if _G.Script_Language == "Thai" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Normal/refs/heads/main/Thai.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Normal/refs/heads/main/testreaper.lua"))()
    end
    
    task.wait(2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Libwtf/refs/heads/main/libwebhook2.lua"))() -- webhook
end)
