Local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GETKEY_URL = "https://lastreaperx.netlify.app/"
local DATABASE_URL = "https://keysystem-reaper-default-rtdb.asia-southeast1.firebasedatabase.app/keys/"
local SAVE_FILE_NAME = "reaper_saved_key.txt"

-- ฟังก์ชันดึง HWID ให้ตรงกับ Webhook ทันที (ใช้ gethwid ตัวเดียวกัน)
local function GetHWID()
    local success, hwidValue = pcall(function()
        return gethwid and gethwid() or nil
    end)
    if success and hwidValue and hwidValue ~= "Not Supported" then
        return hwidValue
    end
    -- Fallback เผื่อ Executor ตัวไหนไม่รองรับ gethwid
    local successClient, clientId = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if successClient and clientId then 
        return clientId 
    end
    return tostring(LocalPlayer.UserId)
end

local function SafeHttpRequest(requestData)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local success, result = pcall(function() return req(requestData) end)
        if success then return result end
    end
    return nil
end

-- ===================================================
-- 🟢 ฟังก์ชันรันสคริปต์หลัก (รวมสคริปต์ภาษาและ Webhook)
-- ===================================================
local function RunMainScript()
    
    if _G.Script_Language == "Thai" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Normal/refs/heads/main/Thai.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Normal/refs/heads/main/kingxyz.lua"))()
    end
    
    task.wait(2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Swiftz007/Libwtf/refs/heads/main/libwebhook2.lua"))() -- Webhook
end

local function ValidateKey(userKey)
    if not userKey or not string.match(userKey, "^REAPER%-[A-Z0-9]+%-[A-Z0-9]+%-[A-Z0-9]+$") then
        return false
    end

    local requestUrl = DATABASE_URL .. userKey .. ".json"
    local success, responseRaw = pcall(function() return game:HttpGet(requestUrl) end)

    if not success or not responseRaw or responseRaw == "null" then return false end

    local decodeSuccess, keyData = pcall(function() return HttpService:JSONDecode(responseRaw) end)
    if not decodeSuccess or not keyData or (os.time() * 1000) > (keyData.expiresAt or 0) then
        return false
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
        return false
    end

    return true
end

-- ===================================================
-- ⚡ AUTO LOAD CHECK (ตรวจสอบคีย์เดิมในเครื่อง)
-- ===================================================
if readfile and writefile and isfile and isfile(SAVE_FILE_NAME) then
    local savedKey = readfile(SAVE_FILE_NAME)
    if savedKey and savedKey ~= "" and ValidateKey(savedKey) then
        RunMainScript()
        return
    end
end

-- ===================================================
-- 💻 UI CREATION (หน้าต่าง Key System พร้อมอนิเมชั่น)
-- ===================================================
if PlayerGui:FindFirstChild("ReaperHubRedKeyUI") then
    PlayerGui.ReaperHubRedKeyUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHubRedKeyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local targetSize = UDim2.new(0, 380, 0, 265)
local targetPos = UDim2.new(0.5, -190, 0.5, -132.5)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 9, 17)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(239, 68, 68)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Position = UDim2.new(0, 0, 0, 72)
Title.BackgroundTransparency = 1
Title.Text = "REAPER HUB | Key System"
Title.TextColor3 = Color3.fromRGB(248, 250, 252)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 320, 0, 44)
KeyBox.Position = UDim2.new(0.5, -160, 0, 104)
KeyBox.BackgroundColor3 = Color3.fromRGB(13, 19, 33)
KeyBox.PlaceholderText = "Paste key here..."
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

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0, 152, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, 8, 0, 158)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
VerifyBtn.Text = "Verify"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
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

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 24)
StatusLabel.Position = UDim2.new(0, 0, 0, 210)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = MainFrame

-- อนิเมชั่นเปิดตัว
local openTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local openTween = TweenService:Create(MainFrame, openTweenInfo, {
    Size = targetSize,
    Position = targetPos
})
openTween:Play()

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(GETKEY_URL)
        StatusLabel.Text = "link copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(52, 211, 153)
    else
        StatusLabel.Text = "setclipboard Error."
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
    end
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyBox.Text
    if userKey == "" then
        StatusLabel.Text = "Please enter key!"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    StatusLabel.Text = "Verifying..."
    StatusLabel.TextColor3 = Color3.fromRGB(250, 204, 21)

    local requestUrl = DATABASE_URL .. userKey .. ".json"
    local success, responseRaw = pcall(function() return game:HttpGet(requestUrl) end)

    if not success or not responseRaw or responseRaw == "null" then
        StatusLabel.Text = "Key not found!"
        StatusLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        return
    end

    local decodeSuccess, keyData = pcall(function() return HttpService:JSONDecode(responseRaw) end)
    if not decodeSuccess or not keyData or (os.time() * 1000) > (keyData.expiresAt or 0) then
        StatusLabel.Text = "Key expired or invalid!"
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

    if writefile then
        pcall(function() writefile(SAVE_FILE_NAME, userKey) end)
    end

    StatusLabel.Text = "Loading..."
    StatusLabel.TextColor3 = Color3.fromRGB(52, 211, 153)
    
    -- อนิเมชั่นตอนปิดหน้าต่าง
    local closeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local closeTween = TweenService:Create(MainFrame, closeTweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        ScreenGui:Destroy()
        RunMainScript()
    end)
end)
