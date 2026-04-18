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
