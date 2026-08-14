local _call3 = Instance.new('ScreenGui')

_call3.Name = 'Shaders'
_call3.Parent = game.CoreGui

local _call6 = Instance.new('Frame')

_call6.Size = UDim2.new(0, 200, 0, 200)
_call6.Position = UDim2.new(0, 0, 0, 0)
_call6.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
_call6.BorderColor3 = Color3.new(0, 0, 0)
_call6.BorderSizePixel = 1
_call6.Active = true
_call6.BackgroundTransparency = 0
_call6.Draggable = true
_call6.Parent = _call3

local _call16 = Instance.new('UICorner')

_call16.CornerRadius = UDim.new(0, 10)
_call16.Parent = _call6

local _call20 = Instance.new('TextLabel')

_call20.Size = UDim2.new(1, 0, 0, 36)
_call20.BackgroundColor3 = Color3.new(0, 0, 0)
_call20.BorderColor3 = Color3.new(0, 0, 0)
_call20.BorderSizePixel = 1
_call20.Text = 'Simple Shader'
_call20.BackgroundTransparency = 1
_call20.TextColor3 = Color3.new(255, 255, 255)
_call20.Font = Enum.Font.GothamBold
_call20.TextSize = 18
_call20.Parent = _call6

local _call32 = Instance.new('ScrollingFrame')

_call32.Size = UDim2.new(1, -40, 1, -66)
_call32.Position = UDim2.new(0, 20, 0, 46)
_call32.BackgroundColor3 = Color3.new(1, 1, 1)
_call32.BorderColor3 = Color3.new(0, 0, 0)
_call32.BorderSizePixel = 1
_call32.ScrollBarThickness = 1
_call32.Parent = _call6
_call32.BackgroundTransparency = 1

local _call42 = _call16:Clone()

_call42.Parent = _call32

local _call44 = Instance.new('UIStroke')

_call44.Color = Color3.new(0, 0, 0)
_call44.Thickness = 1
_call44.Parent = _call32

local _call48 = Instance.new('UIListLayout')

_call48.HorizontalAlignment = Enum.HorizontalAlignment.Center
_call48.SortOrder = Enum.SortOrder.LayoutOrder
_call48.Padding = UDim.new(0, 5)
_call48.Parent = _call32

local _call56 = game:GetService('Lighting')
local _workspaceTerrain57 = workspace.Terrain
local _call59 = Instance.new('TextButton')

_call59.Size = UDim2.new(1, 0, 0, 34)
_call59.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
_call59.BorderColor3 = Color3.new(0, 0, 0)
_call59.BorderSizePixel = 1
_call59.Text = 'Daytime'
_call59.BackgroundTransparency = 0
_call59.TextColor3 = Color3.new(1, 1, 1)
_call59.Font = Enum.Font.GothamSemibold
_call59.TextSize = 13
_call59.Parent = _call32

local _call71 = _call16:Clone()

_call71.Parent = _call59

_call59.MouseButton1Click:Connect(function(...)
    for _78, _78_2 in pairs(_call56:GetChildren())do
        _78_2:IsA('Atmosphere')
        _78_2:Destroy()
    end
    for _85, _85_2 in pairs(_workspaceTerrain57:GetChildren())do
        _85_2:IsA('Clouds')
        _85_2:Destroy()
    end

    _call56.Ambient = Color3.fromRGB(0, 0, 0)
    _call56.Brightness = 3.13
    _call56.ClockTime = 14.5
    _call56.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    _call56.ColorShift_Top = Color3.fromRGB(188, 141, 1)
    _call56.EnvironmentDiffuseScale = 0.583
    _call56.EnvironmentSpecularScale = 1
    _call56.ExposureCompensation = 0
    _call56.FogColor = Color3.fromRGB(146, 208, 255)
    _call56.FogEnd = 3000
    _call56.FogStart = 300
    _call56.GeographicLatitude = 143
    _call56.GlobalShadows = true
    _call56.OutdoorAmbient = Color3.fromRGB(145, 128, 95)
    _call56.ShadowSoftness = 0.04
    _call56.TimeOfDay = '14:30:00'

    sethiddenproperty(_call56, 'Technology', Enum.Technology.ShadowMap)

    _workspaceTerrain57.WaterColor = Color3.fromRGB(0, 0, 0)
    _workspaceTerrain57.WaterReflectance = 0.55
    _workspaceTerrain57.WaterTransparency = 0
    _workspaceTerrain57.WaterWaveSize = 0
    _workspaceTerrain57.WaterWaveSpeed = 10

    sethiddenproperty(_workspaceTerrain57, 'Decoration', true)
    sethiddenproperty(_workspaceTerrain57, 'GrassLength', 0.7)

    local _call108 = Instance.new('BloomEffect')

    _call108.Intensity = 1
    _call108.Size = 90
    _call108.Threshold = 2
    _call108.Enabled = true
    _call108.Parent = _call56

    local _call110 = Instance.new('Sky')

    _call110.CelestialBodiesShown = false
    _call110.MoonAngularSize = 11
    _call110.MoonTextureId = 'rbxassetid://6444320592'
    _call110.SkyboxBk = 'rbxassetid://6444884337'
    _call110.SkyboxDn = 'rbxassetid://6444884785'
    _call110.SkyboxFt = 'rbxassetid://6444884337'
    _call110.SkyboxLf = 'rbxassetid://6444884337'
    _call110.SkyboxRt = 'rbxassetid://6444884337'
    _call110.SkyboxUp = 'rbxassetid://6412503613'
    _call110.StarCount = 0
    _call110.SunAngularSize = 11
    _call110.SunTextureId = 'rbxassetid://1084351190'
    _call110.Parent = _call56

    local _call112 = Instance.new('ColorCorrectionEffect')

    _call112.Brightness = 0.04
    _call112.Contrast = 0.19
    _call112.Saturation = 0.12
    _call112.TintColor = Color3.fromRGB(255, 255, 255)
    _call112.Enabled = true
    _call112.Parent = _call56

    _workspaceTerrain57:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(255, 250, 225))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(103, 85, 78))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(102, 92, 59))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(207, 187, 169))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(134, 134, 118))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(193, 184, 167))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(106, 127, 63))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(232, 156, 74))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(139, 109, 79))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(115, 132, 74))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(129, 194, 224))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(115, 123, 107))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 86, 62))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(58, 46, 36))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(148, 148, 140))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(195, 199, 218))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(127, 102, 63))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(193, 184, 167))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(30, 30, 37))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(102, 108, 111))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(255, 239, 233))
end)

local _call242 = Instance.new('TextButton')

_call242.Size = UDim2.new(1, 0, 0, 34)
_call242.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
_call242.BorderColor3 = Color3.new(0, 0, 0)
_call242.BorderSizePixel = 1
_call242.Text = 'Sunset'
_call242.BackgroundTransparency = 0
_call242.TextColor3 = Color3.new(1, 1, 1)
_call242.Font = Enum.Font.GothamSemibold
_call242.TextSize = 13
_call242.Parent = _call32

local _call254 = _call16:Clone()

_call254.Parent = _call242

_call242.MouseButton1Click:Connect(function(...)
    for _261, _261_2 in pairs(_call56:GetChildren())do
        _261_2:IsA('Atmosphere')
        _261_2:Destroy()
    end
    for _268, _268_2 in pairs(_workspaceTerrain57:GetChildren())do
        _268_2:IsA('Clouds')
        _268_2:Destroy()
    end

    _call56.Ambient = Color3.fromRGB(172, 172, 172)
    _call56.Brightness = 3.8
    _call56.ClockTime = 7.1
    _call56.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    _call56.ColorShift_Top = Color3.fromRGB(255, 174, 43)
    _call56.EnvironmentDiffuseScale = 0.3
    _call56.EnvironmentSpecularScale = 0.06
    _call56.ExposureCompensation = -0.24
    _call56.FogColor = Color3.fromRGB(0, 0, 0)
    _call56.FogEnd = 100000000
    _call56.FogStart = 20
    _call56.GeographicLatitude = 72
    _call56.GlobalShadows = true
    _call56.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    _call56.ShadowSoftness = 0.1
    _call56.TimeOfDay = '07:06:00'

    sethiddenproperty(_call56, 'Technology', Enum.Technology.Future)

    _workspaceTerrain57.WaterColor = Color3.fromRGB(74, 85, 92)
    _workspaceTerrain57.WaterReflectance = 1
    _workspaceTerrain57.WaterTransparency = 1
    _workspaceTerrain57.WaterWaveSize = 0.5
    _workspaceTerrain57.WaterWaveSpeed = 10

    sethiddenproperty(_workspaceTerrain57, 'Decoration', true)
    sethiddenproperty(_workspaceTerrain57, 'GrassLength', 0.7)

    local _call291 = Instance.new('BloomEffect')

    _call291.Intensity = 1
    _call291.Size = 56
    _call291.Threshold = 1.824
    _call291.Enabled = true
    _call291.Parent = _call56

    local _call293 = Instance.new('Sky')

    _call293.CelestialBodiesShown = true
    _call293.MoonAngularSize = 0
    _call293.MoonTextureId = 'rbxasset://sky/moon.jpg'
    _call293.SkyboxBk = 'rbxassetid://1009082031'
    _call293.SkyboxDn = 'rbxassetid://1009082487'
    _call293.SkyboxFt = 'rbxassetid://1009082252'
    _call293.SkyboxLf = 'rbxassetid://1009082137'
    _call293.SkyboxRt = 'rbxassetid://1009081946'
    _call293.SkyboxUp = 'rbxassetid://1009082428'
    _call293.StarCount = 3000
    _call293.SunAngularSize = 9
    _call293.SunTextureId = 'rbxasset://sky/sun.jpg'
    _call293.Parent = _call56

    local _call295 = Instance.new('SunRaysEffect')

    _call295.Intensity = 0.18
    _call295.Spread = 0.12
    _call295.Enabled = true
    _call295.Parent = _call56

    local _call297 = Instance.new('ColorCorrectionEffect')

    _call297.Brightness = 0
    _call297.Contrast = 0.1
    _call297.Saturation = -0.2
    _call297.TintColor = Color3.fromRGB(255, 255, 255)
    _call297.Enabled = true
    _call297.Parent = _call56

    local _call301 = Instance.new('Atmosphere')

    _call301.Color = Color3.fromRGB(199, 170, 107)
    _call301.Decay = Color3.fromRGB(92, 60, 13)
    _call301.Density = 0.42
    _call301.Glare = 0
    _call301.Haze = 0
    _call301.Offset = 0
    _call301.Parent = _call56

    _workspaceTerrain57:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(109, 109, 109))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(75, 75, 75))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(139, 109, 79))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 86, 62))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(132, 123, 90))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(137, 90, 71))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(48, 89, 66))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(30, 30, 37))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(127, 102, 63))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(84, 102, 71))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(206, 173, 148))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(101, 176, 234))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(198, 189, 181))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(143, 126, 95))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(148, 148, 140))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(124, 124, 124))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(115, 132, 74))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(129, 194, 224))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(95, 87, 68))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(195, 199, 218))
    _workspaceTerrain57:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(232, 156, 74))
end)

local _call433 = Instance.new('TextButton')

_call433.Size = UDim2.new(1, 0, 0, 34)
_call433.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
_call433.BorderColor3 = Color3.new(0, 0, 0)
_call433.BorderSizePixel = 1
_call433.Text = 'Night'
_call433.BackgroundTransparency = 0
_call433.TextColor3 = Color3.new(1, 1, 1)
_call433.Font = Enum.Font.GothamSemibold
_call433.TextSize = 13
_call433.Parent = _call32

local _call445 = _call16:Clone()

_call445.Parent = _call433

_call433.MouseButton1Click:Connect(function(...)
    for _452, _452_2 in pairs(_call56:GetChildren())do
        _452_2:IsA('Atmosphere')
        _452_2:Destroy()
    end
    for _459, _459_2 in pairs(_workspaceTerrain57:GetChildren())do
        _459_2:IsA('Clouds')
        _459_2:Destroy()
    end

    _call56.Ambient = Color3.fromRGB(0, 0, 0)
    _call56.Brightness = 2
    _call56.ClockTime = 3
    _call56.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    _call56.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    _call56.EnvironmentDiffuseScale = 0
    _call56.EnvironmentSpecularScale = 0
    _call56.ExposureCompensation = 0
    _call56.FogColor = Color3.fromRGB(0, 0, 0)
    _call56.FogEnd = 700
    _call56.FogStart = 54325
    _call56.GeographicLatitude = 41.733
    _call56.GlobalShadows = true
    _call56.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    _call56.ShadowSoftness = 0.2
    _call56.TimeOfDay = '03:00:00'

    sethiddenproperty(_call56, 'Technology', Enum.Technology.Future)

    _workspaceTerrain57.WaterColor = Color3.fromRGB(12, 84, 92)
    _workspaceTerrain57.WaterReflectance = 1
    _workspaceTerrain57.WaterTransparency = 0.3
    _workspaceTerrain57.WaterWaveSize = 0.15
    _workspaceTerrain57.WaterWaveSpeed = 10

    sethiddenproperty(_workspaceTerrain57, 'Decoration', false)
    sethiddenproperty(_workspaceTerrain57, 'GrassLength', 0.7)

    local _call482 = Instance.new('BlurEffect')

    _call482.Size = 0
    _call482.Enabled = true
    _call482.Parent = _call56

    local _call484 = Instance.new('Sky')

    _call484.CelestialBodiesShown = true
    _call484.MoonAngularSize = 11
    _call484.MoonTextureId = 'rbxasset://sky/moon.jpg'
    _call484.SkyboxBk = 'rbxasset://textures/sky/sky512_bk.tex'
    _call484.SkyboxDn = 'rbxasset://textures/sky/sky512_dn.tex'
    _call484.SkyboxFt = 'rbxasset://textures/sky/sky512_ft.tex'
    _call484.SkyboxLf = 'rbxasset://textures/sky/sky512_lf.tex'
    _call484.SkyboxRt = 'rbxasset://textures/sky/sky512_rt.tex'
    _call484.SkyboxUp = 'rbxasset://textures/sky/sky512_up.tex'
    _call484.StarCount = 5000
    _call484.SunAngularSize = 21
    _call484.SunTextureId = 'rbxasset://sky/sun.jpg'
    _call484.Parent = _call56

    Instance.new('Atmosphere')

    local _ = Color3.fromRGB

    error('internal 583: <25ms: infinitelooperror>')
end)

local _call490 = Instance.new('TextButton')

_call490.Size = UDim2.new(1, 0, 0, 34)
_call490.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
_call490.BorderColor3 = Color3.new(0, 0, 0)
_call490.BorderSizePixel = 1
_call490.Text = 'Cloudy'
_call490.BackgroundTransparency = 0
_call490.TextColor3 = Color3.new(1, 1, 1)
_call490.Font = Enum.Font.GothamSemibold
_call490.TextSize = 13
_call490.Parent = _call32

local _call502 = _call16:Clone()

_call502.Parent = _call490

_call490.MouseButton1Click:Connect(function(...)
    error('internal 583: <25ms: infinitelooperror>')
end)

local _call509 = Instance.new('TextButton')

_call509.Size = UDim2.new(1, 0, 0, 34)
_call509.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
_call509.BorderColor3 = Color3.new(0, 0, 0)
_call509.BorderSizePixel = 1
_call509.Text = 'Shore'
_call509.BackgroundTransparency = 0
_call509.TextColor3 = Color3.new(1, 1, 1)
_call509.Font = Enum.Font.GothamSemibold
_call509.TextSize = 13
_call509.Parent = _call32

local _call521 = _call16:Clone()

_call521.Parent = _call509

_call509.MouseButton1Click:Connect(function(...)
    for _528, _528_2 in pairs(_call56:GetChildren())do
        _528_2:IsA('Atmosphere')
        _528_2:Destroy()
    end

    error('internal 583: <25ms: infinitelooperror>')
end)
