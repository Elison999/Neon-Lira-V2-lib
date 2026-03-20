-- ╔══════════════════════════════════════════════════════════════╗
-- ║              NEON LIRA V2 - UI LIBRARY FOR ROBLOX           ║
-- ║                     Made with ❤ by Elison999                ║
-- ╚══════════════════════════════════════════════════════════════╝

local NeonLira = {}
NeonLira.__index = NeonLira

-- ══════════════════════════════════════════════
--              SERVICES
-- ══════════════════════════════════════════════
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local CoreGui         = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════════════
--              THEMES
-- ══════════════════════════════════════════════
local Themes = {
    ["Neon Dark"] = {
        Background     = Color3.fromRGB(15, 15, 20),
        TopBar         = Color3.fromRGB(20, 20, 28),
        Accent         = Color3.fromRGB(100, 60, 255),
        AccentHover    = Color3.fromRGB(130, 90, 255),
        Text           = Color3.fromRGB(240, 240, 255),
        SubText        = Color3.fromRGB(150, 150, 180),
        Tab            = Color3.fromRGB(25, 25, 35),
        TabSelected    = Color3.fromRGB(35, 35, 50),
        Element        = Color3.fromRGB(22, 22, 32),
        ElementHover   = Color3.fromRGB(30, 30, 45),
        Border         = Color3.fromRGB(60, 40, 140),
        Toggle         = Color3.fromRGB(40, 200, 120),
        ToggleOff      = Color3.fromRGB(60, 60, 80),
        Slider         = Color3.fromRGB(100, 60, 255),
        Input          = Color3.fromRGB(18, 18, 28),
        Shadow         = Color3.fromRGB(0, 0, 0),
    },
    ["Midnight Blue"] = {
        Background     = Color3.fromRGB(8, 12, 28),
        TopBar         = Color3.fromRGB(12, 18, 40),
        Accent         = Color3.fromRGB(40, 120, 255),
        AccentHover    = Color3.fromRGB(70, 150, 255),
        Text           = Color3.fromRGB(220, 235, 255),
        SubText        = Color3.fromRGB(130, 155, 200),
        Tab            = Color3.fromRGB(14, 22, 48),
        TabSelected    = Color3.fromRGB(20, 32, 65),
        Element        = Color3.fromRGB(12, 18, 42),
        ElementHover   = Color3.fromRGB(18, 28, 60),
        Border         = Color3.fromRGB(30, 80, 180),
        Toggle         = Color3.fromRGB(40, 160, 255),
        ToggleOff      = Color3.fromRGB(30, 45, 80),
        Slider         = Color3.fromRGB(40, 120, 255),
        Input          = Color3.fromRGB(10, 16, 38),
        Shadow         = Color3.fromRGB(0, 0, 10),
    },
    ["Crimson"] = {
        Background     = Color3.fromRGB(18, 8, 8),
        TopBar         = Color3.fromRGB(28, 12, 12),
        Accent         = Color3.fromRGB(220, 40, 60),
        AccentHover    = Color3.fromRGB(255, 70, 90),
        Text           = Color3.fromRGB(255, 230, 230),
        SubText        = Color3.fromRGB(180, 140, 140),
        Tab            = Color3.fromRGB(28, 12, 12),
        TabSelected    = Color3.fromRGB(42, 18, 18),
        Element        = Color3.fromRGB(24, 10, 10),
        ElementHover   = Color3.fromRGB(36, 16, 16),
        Border         = Color3.fromRGB(140, 30, 40),
        Toggle         = Color3.fromRGB(220, 40, 60),
        ToggleOff      = Color3.fromRGB(70, 30, 30),
        Slider         = Color3.fromRGB(220, 40, 60),
        Input          = Color3.fromRGB(20, 8, 8),
        Shadow         = Color3.fromRGB(10, 0, 0),
    },
    ["Forest"] = {
        Background     = Color3.fromRGB(8, 18, 10),
        TopBar         = Color3.fromRGB(12, 26, 14),
        Accent         = Color3.fromRGB(50, 200, 80),
        AccentHover    = Color3.fromRGB(80, 230, 110),
        Text           = Color3.fromRGB(220, 255, 225),
        SubText        = Color3.fromRGB(140, 190, 148),
        Tab            = Color3.fromRGB(12, 26, 14),
        TabSelected    = Color3.fromRGB(18, 40, 22),
        Element        = Color3.fromRGB(10, 22, 12),
        ElementHover   = Color3.fromRGB(16, 34, 18),
        Border         = Color3.fromRGB(30, 120, 50),
        Toggle         = Color3.fromRGB(50, 200, 80),
        ToggleOff      = Color3.fromRGB(30, 60, 35),
        Slider         = Color3.fromRGB(50, 200, 80),
        Input          = Color3.fromRGB(8, 20, 10),
        Shadow         = Color3.fromRGB(0, 8, 0),
    },
    ["Cyber Gold"] = {
        Background     = Color3.fromRGB(14, 12, 5),
        TopBar         = Color3.fromRGB(22, 18, 6),
        Accent         = Color3.fromRGB(255, 200, 30),
        AccentHover    = Color3.fromRGB(255, 220, 70),
        Text           = Color3.fromRGB(255, 248, 220),
        SubText        = Color3.fromRGB(190, 175, 120),
        Tab            = Color3.fromRGB(22, 18, 6),
        TabSelected    = Color3.fromRGB(35, 28, 8),
        Element        = Color3.fromRGB(18, 15, 5),
        ElementHover   = Color3.fromRGB(28, 22, 8),
        Border         = Color3.fromRGB(160, 120, 20),
        Toggle         = Color3.fromRGB(255, 200, 30),
        ToggleOff      = Color3.fromRGB(70, 55, 15),
        Slider         = Color3.fromRGB(255, 200, 30),
        Input          = Color3.fromRGB(14, 12, 4),
        Shadow         = Color3.fromRGB(8, 6, 0),
    },
    ["Ice"] = {
        Background     = Color3.fromRGB(230, 240, 255),
        TopBar         = Color3.fromRGB(210, 225, 248),
        Accent         = Color3.fromRGB(60, 130, 240),
        AccentHover    = Color3.fromRGB(90, 155, 255),
        Text           = Color3.fromRGB(20, 30, 60),
        SubText        = Color3.fromRGB(80, 110, 160),
        Tab            = Color3.fromRGB(215, 228, 250),
        TabSelected    = Color3.fromRGB(195, 215, 245),
        Element        = Color3.fromRGB(225, 236, 252),
        ElementHover   = Color3.fromRGB(210, 225, 250),
        Border         = Color3.fromRGB(140, 175, 235),
        Toggle         = Color3.fromRGB(60, 130, 240),
        ToggleOff      = Color3.fromRGB(170, 190, 220),
        Slider         = Color3.fromRGB(60, 130, 240),
        Input          = Color3.fromRGB(228, 238, 254),
        Shadow         = Color3.fromRGB(150, 170, 210),
    },
    ["Synthwave"] = {
        Background     = Color3.fromRGB(10, 5, 22),
        TopBar         = Color3.fromRGB(18, 8, 35),
        Accent         = Color3.fromRGB(255, 50, 180),
        AccentHover    = Color3.fromRGB(255, 90, 210),
        Text           = Color3.fromRGB(255, 220, 255),
        SubText        = Color3.fromRGB(180, 130, 200),
        Tab            = Color3.fromRGB(18, 8, 35),
        TabSelected    = Color3.fromRGB(28, 12, 55),
        Element        = Color3.fromRGB(14, 6, 28),
        ElementHover   = Color3.fromRGB(22, 10, 45),
        Border         = Color3.fromRGB(150, 30, 120),
        Toggle         = Color3.fromRGB(255, 50, 180),
        ToggleOff      = Color3.fromRGB(70, 20, 70),
        Slider         = Color3.fromRGB(255, 50, 180),
        Input          = Color3.fromRGB(12, 5, 25),
        Shadow         = Color3.fromRGB(5, 0, 15),
    },
    ["Obsidian"] = {
        Background     = Color3.fromRGB(12, 12, 12),
        TopBar         = Color3.fromRGB(18, 18, 18),
        Accent         = Color3.fromRGB(200, 200, 200),
        AccentHover    = Color3.fromRGB(230, 230, 230),
        Text           = Color3.fromRGB(240, 240, 240),
        SubText        = Color3.fromRGB(155, 155, 155),
        Tab            = Color3.fromRGB(18, 18, 18),
        TabSelected    = Color3.fromRGB(28, 28, 28),
        Element        = Color3.fromRGB(15, 15, 15),
        ElementHover   = Color3.fromRGB(24, 24, 24),
        Border         = Color3.fromRGB(55, 55, 55),
        Toggle         = Color3.fromRGB(200, 200, 200),
        ToggleOff      = Color3.fromRGB(55, 55, 55),
        Slider         = Color3.fromRGB(200, 200, 200),
        Input          = Color3.fromRGB(13, 13, 13),
        Shadow         = Color3.fromRGB(0, 0, 0),
    },
    ["Ocean Depth"] = {
        Background     = Color3.fromRGB(5, 18, 30),
        TopBar         = Color3.fromRGB(8, 25, 42),
        Accent         = Color3.fromRGB(0, 180, 200),
        AccentHover    = Color3.fromRGB(30, 210, 230),
        Text           = Color3.fromRGB(210, 245, 255),
        SubText        = Color3.fromRGB(120, 185, 210),
        Tab            = Color3.fromRGB(8, 25, 42),
        TabSelected    = Color3.fromRGB(12, 38, 60),
        Element        = Color3.fromRGB(6, 20, 35),
        ElementHover   = Color3.fromRGB(10, 32, 52),
        Border         = Color3.fromRGB(0, 110, 140),
        Toggle         = Color3.fromRGB(0, 180, 200),
        ToggleOff      = Color3.fromRGB(15, 55, 75),
        Slider         = Color3.fromRGB(0, 180, 200),
        Input          = Color3.fromRGB(5, 18, 30),
        Shadow         = Color3.fromRGB(0, 5, 12),
    },
    ["Sakura"] = {
        Background     = Color3.fromRGB(30, 12, 20),
        TopBar         = Color3.fromRGB(42, 18, 30),
        Accent         = Color3.fromRGB(255, 130, 170),
        AccentHover    = Color3.fromRGB(255, 160, 195),
        Text           = Color3.fromRGB(255, 230, 240),
        SubText        = Color3.fromRGB(200, 160, 180),
        Tab            = Color3.fromRGB(42, 18, 30),
        TabSelected    = Color3.fromRGB(60, 25, 42),
        Element        = Color3.fromRGB(35, 14, 24),
        ElementHover   = Color3.fromRGB(52, 20, 36),
        Border         = Color3.fromRGB(160, 70, 110),
        Toggle         = Color3.fromRGB(255, 130, 170),
        ToggleOff      = Color3.fromRGB(80, 35, 55),
        Slider         = Color3.fromRGB(255, 130, 170),
        Input          = Color3.fromRGB(30, 12, 20),
        Shadow         = Color3.fromRGB(12, 4, 8),
    },
}

-- ══════════════════════════════════════════════
--              UTILITY FUNCTIONS
-- ══════════════════════════════════════════════
local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function MakeDraggable(topbar, frame)
    local dragging  = false
    local dragInput = nil
    local dragStart = nil
    local startPos  = nil

    local function BeginDrag(inputPos)
        dragging  = true
        dragStart = inputPos
        startPos  = frame.Position
    end

    local function UpdateDrag(inputPos)
        if not dragging then return end
        local delta = inputPos - dragStart
        local vp    = workspace.CurrentCamera.ViewportSize
        local newX  = math.clamp(startPos.X.Offset + delta.X, -frame.AbsoluteSize.X + 60, vp.X - 60)
        local newY  = math.clamp(startPos.Y.Offset + delta.Y, 0, vp.Y - 40)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end

    local function EndDrag()
        dragging  = false
        dragInput = nil
    end

    -- PC: Mouse
    topbar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            BeginDrag(inp.Position)
        end
    end)
    topbar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            EndDrag()
        end
    end)
    topbar.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = inp
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            UpdateDrag(inp.Position)
        end
    end)

    -- Mobile: Touch
    topbar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            BeginDrag(inp.Position)
        end
    end)
    topbar.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch and dragging then
            UpdateDrag(inp.Position)
        end
    end)
    topbar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            EndDrag()
        end
    end)
    -- Safety: soltar dedo em qualquer lugar da tela cancela o drag
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            EndDrag()
        end
    end)
end

local function ReadFile(path)
    if readfile then
        local ok, data = pcall(readfile, path)
        if ok then return data end
    end
    return nil
end

local function WriteFile(path, data)
    if writefile then
        pcall(writefile, path, data)
    end
end

local function FileExists(path)
    if isfile then
        local ok, res = pcall(isfile, path)
        return ok and res
    end
    return false
end

local function GetFromSite(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and res then
        return res:match("^%s*(.-)%s*$") -- trim
    end
    return nil
end

local function Round(n, d)
    local m = 10^(d or 0)
    return math.floor(n * m + 0.5) / m
end

-- ══════════════════════════════════════════════
--              LIBRARY CONSTRUCTOR
-- ══════════════════════════════════════════════
function NeonLira:New(config)
    config = config or {}

    local lib = {
        Name          = config.Name or "NeonLira",
        ThemeName     = config.Theme or "Neon Dark",
        Theme         = Themes[config.Theme] or Themes["Neon Dark"],
        Windows       = {},
        SaveData      = {},
        AutoSave      = config["AutoSave&load"] ~= false and (config["AutoSave&load"] == true),
        SaveFile      = (config.Name or "NeonLira") .. "_save.json",
        _open         = true,
    }
    setmetatable(lib, {__index = NeonLira})

    -- Load autosave data
    if lib.AutoSave then
        local raw = ReadFile(lib.SaveFile)
        if raw then
            local ok, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and decoded then
                lib.SaveData = decoded
            end
        end
    end

    return lib
end

-- ══════════════════════════════════════════════
--              KEY SYSTEM
-- ══════════════════════════════════════════════
function NeonLira:KeySystem(config, callback)
    config = config or {}
    if not config.KeyEnable then
        if callback then callback() end
        return
    end

    local KeyName     = config.KeyName     or "Key System"
    local Key         = config.Key         or ""
    local KeySave     = config.KeySave     or false
    local KeyFileName = config.KeyFileName or "key.json"
    local GetFromWeb  = config.GetKeyFromSite or false
    local KeySite     = config.KeySite     or ""
    local Theme       = self.Theme

    -- Check saved key
    if KeySave and FileExists(KeyFileName) then
        local raw = ReadFile(KeyFileName)
        if raw then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and data and data.key then
                local correctKey = Key
                if GetFromWeb and KeySite ~= "" then
                    local siteKey = GetFromSite(KeySite)
                    if siteKey then correctKey = siteKey end
                end
                if data.key == correctKey then
                    if callback then callback() end
                    return
                end
            end
        end
    end

    -- Build Key UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonLiraKey"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = ScreenGui

    local Box = Instance.new("Frame")
    Box.Size = UDim2.fromOffset(360, 220)
    Box.AnchorPoint = Vector2.new(0.5, 0.5)
    Box.Position = UDim2.fromScale(0.5, 0.5)
    Box.BackgroundColor3 = Theme.Background
    Box.BorderSizePixel = 0
    Box.ZIndex = 11
    Box.Parent = ScreenGui
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)

    local Border = Instance.new("UIStroke", Box)
    Border.Color = Theme.Accent
    Border.Thickness = 1.5

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Theme.TopBar
    Title.BorderSizePixel = 0
    Title.Text = "🔑  " .. KeyName
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.ZIndex = 12
    Title.Parent = Box
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)
    -- Mask bottom corners
    local TitleFix = Instance.new("Frame", Title)
    TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
    TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
    TitleFix.BackgroundColor3 = Theme.TopBar
    TitleFix.BorderSizePixel = 0
    TitleFix.ZIndex = 12

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, -30, 0, 20)
    Sub.Position = UDim2.fromOffset(15, 50)
    Sub.BackgroundTransparency = 1
    Sub.Text = "Digite a key correta para continuar"
    Sub.TextColor3 = Theme.SubText
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 12
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.ZIndex = 12
    Sub.Parent = Box

    local InputBG = Instance.new("Frame")
    InputBG.Size = UDim2.new(1, -30, 0, 36)
    InputBG.Position = UDim2.fromOffset(15, 78)
    InputBG.BackgroundColor3 = Theme.Input
    InputBG.BorderSizePixel = 0
    InputBG.ZIndex = 12
    InputBG.Parent = Box
    Instance.new("UICorner", InputBG).CornerRadius = UDim.new(0, 6)
    local InputStroke = Instance.new("UIStroke", InputBG)
    InputStroke.Color = Theme.Border
    InputStroke.Thickness = 1

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -20, 1, 0)
    Input.Position = UDim2.fromOffset(10, 0)
    Input.BackgroundTransparency = 1
    Input.PlaceholderText = "Insira sua key aqui..."
    Input.PlaceholderColor3 = Theme.SubText
    Input.Text = ""
    Input.TextColor3 = Theme.Text
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 13
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.ZIndex = 13
    Input.Parent = InputBG

    local ErrLabel = Instance.new("TextLabel")
    ErrLabel.Size = UDim2.new(1, -30, 0, 18)
    ErrLabel.Position = UDim2.fromOffset(15, 120)
    ErrLabel.BackgroundTransparency = 1
    ErrLabel.Text = ""
    ErrLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    ErrLabel.Font = Enum.Font.Gotham
    ErrLabel.TextSize = 11
    ErrLabel.TextXAlignment = Enum.TextXAlignment.Left
    ErrLabel.ZIndex = 12
    ErrLabel.Parent = Box

    local SiteLabel
    if GetFromWeb and KeySite ~= "" then
        SiteLabel = Instance.new("TextLabel")
        SiteLabel.Size = UDim2.new(1, -30, 0, 18)
        SiteLabel.Position = UDim2.fromOffset(15, 138)
        SiteLabel.BackgroundTransparency = 1
        SiteLabel.Text = "🔗 Pegue sua key em: " .. KeySite
        SiteLabel.TextColor3 = Theme.Accent
        SiteLabel.Font = Enum.Font.Gotham
        SiteLabel.TextSize = 10
        SiteLabel.TextXAlignment = Enum.TextXAlignment.Left
        SiteLabel.TextTruncate = Enum.TextTruncate.AtEnd
        SiteLabel.ZIndex = 12
        SiteLabel.Parent = Box
    end

    local ConfirmBtn = Instance.new("TextButton")
    ConfirmBtn.Size = UDim2.new(1, -30, 0, 34)
    ConfirmBtn.Position = UDim2.fromOffset(15, 172)
    ConfirmBtn.BackgroundColor3 = Theme.Accent
    ConfirmBtn.Text = "Confirmar"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmBtn.Font = Enum.Font.GothamBold
    ConfirmBtn.TextSize = 13
    ConfirmBtn.BorderSizePixel = 0
    ConfirmBtn.ZIndex = 12
    ConfirmBtn.Parent = Box
    Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 6)

    ConfirmBtn.MouseEnter:Connect(function()
        Tween(ConfirmBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.AccentHover})
    end)
    ConfirmBtn.MouseLeave:Connect(function()
        Tween(ConfirmBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent})
    end)

    ConfirmBtn.MouseButton1Click:Connect(function()
        local entered = Input.Text

        local correctKey = Key
        if GetFromWeb and KeySite ~= "" then
            local siteKey = GetFromSite(KeySite)
            if siteKey then correctKey = siteKey end
        end

        if entered == correctKey then
            if KeySave then
                local saveData = HttpService:JSONEncode({key = entered})
                WriteFile(KeyFileName, saveData)
            end
            ScreenGui:Destroy()
            if callback then callback() end
        else
            ErrLabel.Text = "❌  Key incorreta! Tente novamente."
            Input.Text = ""
            Tween(InputStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(255,60,60)})
            task.delay(1.5, function()
                ErrLabel.Text = ""
                Tween(InputStroke, TweenInfo.new(0.3), {Color = Theme.Border})
            end)
        end
    end)

    -- Animate in
    Box.Position = UDim2.new(0.5, 0, 0.6, 0)
    Box.BackgroundTransparency = 1
    Tween(Box, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 0,
    })
end

-- ══════════════════════════════════════════════
--              LOADING SCREEN
-- ══════════════════════════════════════════════
function NeonLira:Loading(config, callback)
    config = config or {}
    local LoadName = config.LoadingName or "Loading..."
    local ImageId  = config.ImageId and ("rbxassetid://" .. config.ImageId) or ""
    local Theme    = self.Theme
    local Duration = config.Duration or 2.5

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonLiraLoading"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 998
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

    local BG = Instance.new("Frame")
    BG.Size = UDim2.fromScale(1, 1)
    BG.BackgroundColor3 = Theme.Background
    BG.BorderSizePixel = 0
    BG.ZIndex = 5
    BG.Parent = ScreenGui

    local Center = Instance.new("Frame")
    Center.Size = UDim2.fromOffset(260, 180)
    Center.AnchorPoint = Vector2.new(0.5, 0.5)
    Center.Position = UDim2.fromScale(0.5, 0.5)
    Center.BackgroundTransparency = 1
    Center.ZIndex = 6
    Center.Parent = ScreenGui

    if ImageId ~= "" then
        local Img = Instance.new("ImageLabel")
        Img.Size = UDim2.fromOffset(80, 80)
        Img.AnchorPoint = Vector2.new(0.5, 0)
        Img.Position = UDim2.fromScale(0.5, 0)
        Img.BackgroundTransparency = 1
        Img.Image = ImageId
        Img.ZIndex = 7
        Img.Parent = Center
        Instance.new("UICorner", Img).CornerRadius = UDim.new(0, 10)

        -- Spin animation
        local rot = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            rot = rot + dt * 60
            if Img and Img.Parent then
                Img.Rotation = rot
            else
                conn:Disconnect()
            end
        end)
    end

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0, 30)
    NameLabel.Position = UDim2.fromOffset(0, 90)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = LoadName
    NameLabel.TextColor3 = Theme.Text
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 18
    NameLabel.ZIndex = 7
    NameLabel.Parent = Center

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, 0, 0, 20)
    SubLabel.Position = UDim2.fromOffset(0, 122)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = "Inicializando..."
    SubLabel.TextColor3 = Theme.SubText
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 12
    SubLabel.ZIndex = 7
    SubLabel.Parent = Center

    local BarBG = Instance.new("Frame")
    BarBG.Size = UDim2.new(1, 0, 0, 4)
    BarBG.Position = UDim2.fromOffset(0, 152)
    BarBG.BackgroundColor3 = Theme.Element
    BarBG.BorderSizePixel = 0
    BarBG.ZIndex = 7
    BarBG.Parent = Center
    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.fromScale(0, 1)
    Bar.BackgroundColor3 = Theme.Accent
    Bar.BorderSizePixel = 0
    Bar.ZIndex = 8
    Bar.Parent = BarBG
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local steps = {
        {t=0.2, text="Carregando assets..."},
        {t=0.5, text="Inicializando módulos..."},
        {t=0.75, text="Verificando integridade..."},
        {t=1.0, text="Pronto!"},
    }

    local start = tick()
    local stepIdx = 1
    local conn2
    conn2 = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - start
        local pct = math.min(elapsed / Duration, 1)
        Bar.Size = UDim2.fromScale(pct, 1)

        if stepIdx <= #steps and pct >= steps[stepIdx].t then
            SubLabel.Text = steps[stepIdx].text
            stepIdx = stepIdx + 1
        end

        if pct >= 1 then
            conn2:Disconnect()
            task.wait(0.4)
            Tween(BG, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            Tween(Center, TweenInfo.new(0.5), {})
            task.wait(0.5)
            ScreenGui:Destroy()
            if callback then callback() end
        end
    end)
end

-- ══════════════════════════════════════════════
--              CREATE WINDOW
-- ══════════════════════════════════════════════
function NeonLira:CreateWindow(config)
    config = config or {}
    local WindowName  = config.Name    or "Window"
    local ImageId     = config.ImageId and ("rbxassetid://" .. config.ImageId) or ""
    local Theme       = self.Theme
    local lib         = self

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonLira_" .. WindowName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.fromOffset(550, 400)
    Main.Position = UDim2.fromOffset(
        math.floor((workspace.CurrentCamera.ViewportSize.X - 550) / 2),
        math.floor((workspace.CurrentCamera.ViewportSize.Y - 400) / 2)
    )
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.ZIndex = 2
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1

    -- Shadow (posição e tamanho controlados via RenderStepped abaixo)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Theme.Shadow
    Shadow.ImageTransparency = 0.38
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 1
    Shadow.Parent = ScreenGui

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.ZIndex = 3
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
    -- Fix bottom corners of topbar
    local TBFix = Instance.new("Frame", TopBar)
    TBFix.Size = UDim2.new(1, 0, 0.5, 0)
    TBFix.Position = UDim2.new(0, 0, 0.5, 0)
    TBFix.BackgroundColor3 = Theme.TopBar
    TBFix.BorderSizePixel = 0
    TBFix.ZIndex = 3

    local TopStroke = Instance.new("UIStroke", TopBar)
    TopStroke.Color = Theme.Border
    TopStroke.Thickness = 1
    TopStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Icon
    if ImageId ~= "" then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.fromOffset(26, 26)
        Icon.Position = UDim2.fromOffset(10, 8)
        Icon.BackgroundTransparency = 1
        Icon.Image = ImageId
        Icon.ZIndex = 4
        Icon.Parent = TopBar
        Instance.new("UICorner", Icon).CornerRadius = UDim.new(0, 4)
    end

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -180, 1, 0)
    TitleLabel.Position = UDim2.fromOffset(ImageId ~= "" and 42 or 12, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 4
    TitleLabel.Parent = TopBar

    -- Buttons container
    local BtnHolder = Instance.new("Frame")
    BtnHolder.Size = UDim2.fromOffset(90, 28)
    BtnHolder.AnchorPoint = Vector2.new(1, 0.5)
    BtnHolder.Position = UDim2.new(1, -8, 0.5, 0)
    BtnHolder.BackgroundTransparency = 1
    BtnHolder.ZIndex = 4
    BtnHolder.Parent = TopBar
    local BtnLayout = Instance.new("UIListLayout", BtnHolder)
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnLayout.Padding = UDim.new(0, 4)
    BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

    local function MakeBtn(icon, color, tip)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(26, 26)
        b.BackgroundColor3 = Theme.Element
        b.Text = icon
        b.TextColor3 = color
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.ZIndex = 5
        b.Parent = BtnHolder
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseEnter:Connect(function()
            Tween(b, TweenInfo.new(0.12), {BackgroundColor3 = Theme.ElementHover})
        end)
        b.MouseLeave:Connect(function()
            Tween(b, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Element})
        end)
        return b
    end

    local ResizeBtn  = MakeBtn("⤡", Theme.SubText, "Resize")
    local MinBtn     = MakeBtn("─", Color3.fromRGB(255, 200, 50), "Minimize")
    local CloseBtn   = MakeBtn("✕", Color3.fromRGB(255, 80, 80), "Fechar")

    -- Content area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -42)
    Content.Position = UDim2.fromOffset(0, 42)
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    Content.ZIndex = 2
    Content.Parent = Main

    -- Tab Sidebar
    local TabSide = Instance.new("Frame")
    TabSide.Name = "TabSide"
    TabSide.Size = UDim2.new(0, 130, 1, 0)
    TabSide.BackgroundColor3 = Theme.Tab
    TabSide.BorderSizePixel = 0
    TabSide.ZIndex = 2
    TabSide.Parent = Content
    local TabLayout = Instance.new("UIListLayout", TabSide)
    TabLayout.Padding = UDim.new(0, 3)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local TabPadding = Instance.new("UIPadding", TabSide)
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 6)
    TabPadding.PaddingRight = UDim.new(0, 6)

    -- Tab Content area
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -130, 1, 0)
    TabContent.Position = UDim2.fromOffset(130, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ClipsDescendants = true
    TabContent.ZIndex = 2
    TabContent.Parent = Content

    -- Divider line
    local Div = Instance.new("Frame")
    Div.Size = UDim2.new(0, 1, 1, 0)
    Div.Position = UDim2.fromOffset(130, 0)
    Div.BackgroundColor3 = Theme.Border
    Div.BorderSizePixel = 0
    Div.ZIndex = 3
    Div.Parent = Content

    -- Dragging (PC + Mobile)
    MakeDraggable(TopBar, Main)

    -- Shadow: acompanha posição E tamanho do Main em tempo real
    local shadowPad = 35  -- quanto a sombra extrapola em cada lado
    RunService.RenderStepped:Connect(function()
        if not Main or not Main.Parent then return end
        local mw = Main.Size.X.Offset
        local mh = Main.Size.Y.Offset
        local mx = Main.Position.X.Offset
        local my = Main.Position.Y.Offset
        Shadow.Size     = UDim2.fromOffset(mw + shadowPad * 2, mh + shadowPad * 2)
        Shadow.Position = UDim2.fromOffset(mx - shadowPad, my - shadowPad + 8)
        Shadow.AnchorPoint = Vector2.new(0, 0)
    end)

    -- Window state
    local Window = {
        _gui       = ScreenGui,
        _main      = Main,
        _topbar    = TopBar,
        _tabSide   = TabSide,
        _tabContent= TabContent,
        _tabs      = {},
        _activeTab = nil,
        _minimized = false,
        _opacity   = false,
        _lib       = lib,
        _theme     = Theme,
    }

    -- ── Minimize ──
    MinBtn.MouseButton1Click:Connect(function()
        Window._minimized = not Window._minimized
        if Window._minimized then
            Tween(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(Main.Size.X.Offset, 42)})
            MinBtn.Text = "□"
        else
            Tween(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(Main.Size.X.Offset, 400)})
            MinBtn.Text = "─"
        end
    end)

    -- ── Resize (PC + Mobile) ──
    local resizing    = false
    local resizeStart = nil
    local resizeSize  = nil

    local function BeginResize(pos)
        resizing     = true
        resizeStart  = pos
        resizeSize   = Main.Size
    end
    local function UpdateResize(pos)
        if not resizing then return end
        local delta = pos - resizeStart
        local newW  = math.clamp(resizeSize.X.Offset + delta.X, 380, 900)
        local newH  = math.clamp(resizeSize.Y.Offset + delta.Y, 280, 700)
        Main.Size = UDim2.fromOffset(newW, newH)
    end
    local function EndResize()
        resizing = false
    end

    -- Mouse
    ResizeBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            BeginResize(inp.Position)
        end
    end)
    ResizeBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            EndResize()
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement and resizing then
            UpdateResize(inp.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            EndResize()
        end
    end)

    -- Touch
    ResizeBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            BeginResize(inp.Position)
        end
    end)
    ResizeBtn.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch and resizing then
            UpdateResize(inp.Position)
        end
    end)
    ResizeBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            EndResize()
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            EndResize()
        end
    end)

    -- ── Close Dialog ──
    local function ShowCloseDialog()
        local Overlay = Instance.new("Frame")
        Overlay.Size = UDim2.fromScale(1, 1)
        Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        Overlay.BackgroundTransparency = 0.55
        Overlay.BorderSizePixel = 0
        Overlay.ZIndex = 20
        Overlay.Parent = ScreenGui

        local Dialog = Instance.new("Frame")
        Dialog.Size = UDim2.fromOffset(280, 130)
        Dialog.AnchorPoint = Vector2.new(0.5, 0.5)
        Dialog.Position = UDim2.fromScale(0.5, 0.5)
        Dialog.BackgroundColor3 = Theme.Background
        Dialog.BorderSizePixel = 0
        Dialog.ZIndex = 21
        Dialog.Parent = ScreenGui
        Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0, 10)
        local DS = Instance.new("UIStroke", Dialog)
        DS.Color = Color3.fromRGB(255,80,80)
        DS.Thickness = 1.2

        local DTitle = Instance.new("TextLabel")
        DTitle.Size = UDim2.new(1, 0, 0, 38)
        DTitle.BackgroundColor3 = Theme.TopBar
        DTitle.Text = "⚠  Fechar Interface?"
        DTitle.TextColor3 = Theme.Text
        DTitle.Font = Enum.Font.GothamBold
        DTitle.TextSize = 13
        DTitle.BorderSizePixel = 0
        DTitle.ZIndex = 22
        DTitle.Parent = Dialog
        Instance.new("UICorner", DTitle).CornerRadius = UDim.new(0, 10)
        local DTFix = Instance.new("Frame", DTitle)
        DTFix.Size = UDim2.new(1, 0, 0.5, 0)
        DTFix.Position = UDim2.new(0, 0, 0.5, 0)
        DTFix.BackgroundColor3 = Theme.TopBar
        DTFix.BorderSizePixel = 0
        DTFix.ZIndex = 22

        local DSub = Instance.new("TextLabel")
        DSub.Size = UDim2.new(1, -20, 0, 30)
        DSub.Position = UDim2.fromOffset(10, 44)
        DSub.BackgroundTransparency = 1
        DSub.Text = "Tem certeza que deseja fechar a UI?"
        DSub.TextColor3 = Theme.SubText
        DSub.Font = Enum.Font.Gotham
        DSub.TextSize = 12
        DSub.ZIndex = 22
        DSub.Parent = Dialog

        local function MakeDialogBtn(text, col, xpos)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(110, 30)
            b.Position = xpos
            b.BackgroundColor3 = col
            b.Text = text
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 12
            b.BorderSizePixel = 0
            b.ZIndex = 22
            b.Parent = Dialog
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            return b
        end

        local CancelBtn = MakeDialogBtn("Cancelar", Color3.fromRGB(60,65,80), UDim2.fromOffset(12, 86))
        local YesBtn    = MakeDialogBtn("Sim, fechar", Color3.fromRGB(200,50,50), UDim2.fromOffset(130, 86))

        -- Animate in
        Dialog.Position = UDim2.new(0.5, 0, 0.6, 0)
        Tween(Dialog, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.fromScale(0.5, 0.5)})

        CancelBtn.MouseButton1Click:Connect(function()
            Tween(Dialog, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.6, 0)})
            task.wait(0.2)
            Dialog:Destroy()
            Overlay:Destroy()
        end)

        YesBtn.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
    end

    CloseBtn.MouseButton1Click:Connect(ShowCloseDialog)

    -- ══════════════════════════════════════════════
    --          ADD TAB
    -- ══════════════════════════════════════════════
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or ""

        -- Tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Theme.Tab
        TabBtn.Text = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.BorderSizePixel = 0
        TabBtn.LayoutOrder = #self._tabs + 1
        TabBtn.ZIndex = 3
        TabBtn.Parent = self._tabSide
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        local TabPad = Instance.new("UIPadding", TabBtn)
        TabPad.PaddingLeft = UDim.new(0, 10)

        -- Tab content page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "_Page"
        Page.Size = UDim2.fromScale(1, 1)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.CanvasSize = UDim2.fromScale(0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.ZIndex = 2
        Page.Parent = self._tabContent
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local PagePad = Instance.new("UIPadding", Page)
        PagePad.PaddingTop = UDim.new(0, 8)
        PagePad.PaddingLeft = UDim.new(0, 10)
        PagePad.PaddingRight = UDim.new(0, 10)

        local tab = {
            _btn     = TabBtn,
            _page    = Page,
            _win     = self,
            _lib     = lib,
            _theme   = Theme,
            _order   = 0,
        }

        local function SelectTab()
            -- Deselect all
            for _, t in ipairs(self._tabs) do
                t._page.Visible = false
                Tween(t._btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Tab, TextColor3 = Theme.SubText})
                t._btn.Font = Enum.Font.Gotham
            end
            -- Select this
            tab._page.Visible = true
            Tween(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.TabSelected, TextColor3 = Theme.Text})
            TabBtn.Font = Enum.Font.GothamBold
            self._activeTab = tab
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)
        TabBtn.MouseEnter:Connect(function()
            if self._activeTab ~= tab then
                Tween(TabBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ElementHover})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if self._activeTab ~= tab then
                Tween(TabBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Tab})
            end
        end)

        table.insert(self._tabs, tab)

        -- Auto-select first tab
        if #self._tabs == 1 then
            SelectTab()
        end

        -- ══════════════════════════════════════════════
        --              ELEMENTS
        -- ══════════════════════════════════════════════

        local function NextOrder()
            tab._order = tab._order + 1
            return tab._order
        end

        local function SaveAll()
            if lib.AutoSave then
                local raw = HttpService:JSONEncode(lib.SaveData)
                WriteFile(lib.SaveFile, raw)
            end
        end

        -- ── Section Label ──
        function tab:AddSection(name)
            local sec = Instance.new("TextLabel")
            sec.Size = UDim2.new(1, 0, 0, 22)
            sec.BackgroundTransparency = 1
            sec.Text = name
            sec.TextColor3 = Theme.Accent
            sec.Font = Enum.Font.GothamBold
            sec.TextSize = 11
            sec.TextXAlignment = Enum.TextXAlignment.Left
            sec.LayoutOrder = NextOrder()
            sec.ZIndex = 3
            sec.Parent = Page
            local Pad = Instance.new("UIPadding", sec)
            Pad.PaddingLeft = UDim.new(0, 4)
            return sec
        end

        -- ── Button ──
        function tab:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local name     = btnConfig.Name     or "Button"
            local desc     = btnConfig.Description or ""
            local callback = btnConfig.Callback or function() end

            local H = desc ~= "" and 50 or 36

            local Wrap = Instance.new("TextButton")
            Wrap.Size = UDim2.new(1, 0, 0, H)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.Text = ""
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -16, 0, 20)
            NameL.Position = UDim2.fromOffset(12, desc ~= "" and 6 or 8)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            if desc ~= "" then
                local DescL = Instance.new("TextLabel", Wrap)
                DescL.Size = UDim2.new(1, -16, 0, 16)
                DescL.Position = UDim2.fromOffset(12, 26)
                DescL.BackgroundTransparency = 1
                DescL.Text = desc
                DescL.TextColor3 = Theme.SubText
                DescL.Font = Enum.Font.Gotham
                DescL.TextSize = 10
                DescL.TextXAlignment = Enum.TextXAlignment.Left
                DescL.ZIndex = 4
            end

            local AccentBar = Instance.new("Frame", Wrap)
            AccentBar.Size = UDim2.fromOffset(3, H - 14)
            AccentBar.Position = UDim2.fromOffset(0, 7)
            AccentBar.BackgroundColor3 = Theme.Accent
            AccentBar.BorderSizePixel = 0
            AccentBar.ZIndex = 4
            Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)

            Wrap.MouseEnter:Connect(function()
                Tween(Wrap, TweenInfo.new(0.12), {BackgroundColor3 = Theme.ElementHover})
            end)
            Wrap.MouseLeave:Connect(function()
                Tween(Wrap, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Element})
            end)
            Wrap.MouseButton1Click:Connect(function()
                Tween(Wrap, TweenInfo.new(0.05), {BackgroundColor3 = Theme.Accent})
                task.wait(0.1)
                Tween(Wrap, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Element})
                callback()
            end)

            return Wrap
        end

        -- ── Toggle ──
        function tab:AddToggle(togConfig)
            togConfig = togConfig or {}
            local name     = togConfig.Name     or "Toggle"
            local desc     = togConfig.Description or ""
            local default  = togConfig.Default  or false
            local saveKey  = togConfig.Flag     or name
            local callback = togConfig.Callback or function() end

            -- Load saved state
            if lib.AutoSave and lib.SaveData[saveKey] ~= nil then
                default = lib.SaveData[saveKey]
            end

            local state = default
            local H = desc ~= "" and 50 or 36

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, H)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -70, 0, 20)
            NameL.Position = UDim2.fromOffset(12, desc ~= "" and 6 or 8)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            if desc ~= "" then
                local DescL = Instance.new("TextLabel", Wrap)
                DescL.Size = UDim2.new(1, -70, 0, 16)
                DescL.Position = UDim2.fromOffset(12, 26)
                DescL.BackgroundTransparency = 1
                DescL.Text = desc
                DescL.TextColor3 = Theme.SubText
                DescL.Font = Enum.Font.Gotham
                DescL.TextSize = 10
                DescL.TextXAlignment = Enum.TextXAlignment.Left
                DescL.ZIndex = 4
            end

            -- Switch track
            local Track = Instance.new("TextButton", Wrap)
            Track.Size = UDim2.fromOffset(42, 22)
            Track.AnchorPoint = Vector2.new(1, 0.5)
            Track.Position = UDim2.new(1, -12, 0.5, 0)
            Track.BackgroundColor3 = state and Theme.Toggle or Theme.ToggleOff
            Track.Text = ""
            Track.BorderSizePixel = 0
            Track.ZIndex = 4
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", Track)
            Knob.Size = UDim2.fromOffset(16, 16)
            Knob.Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
            Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Knob.BorderSizePixel = 0
            Knob.ZIndex = 5
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local function SetToggle(val)
                state = val
                lib.SaveData[saveKey] = state
                SaveAll()
                Tween(Track, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Toggle or Theme.ToggleOff})
                Tween(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = state and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)})
                callback(state)
            end

            local function ClickToggle()
                SetToggle(not state)
            end

            Track.MouseButton1Click:Connect(ClickToggle)
            -- Also clickable on whole row
            local ClickDet = Instance.new("TextButton", Wrap)
            ClickDet.Size = UDim2.new(1, -65, 1, 0)
            ClickDet.BackgroundTransparency = 1
            ClickDet.Text = ""
            ClickDet.ZIndex = 4
            ClickDet.MouseButton1Click:Connect(ClickToggle)

            Wrap.MouseEnter:Connect(function()
                Tween(Wrap, TweenInfo.new(0.12), {BackgroundColor3 = Theme.ElementHover})
            end)
            Wrap.MouseLeave:Connect(function()
                Tween(Wrap, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Element})
            end)

            -- Call initial callback
            task.spawn(function() callback(state) end)

            local ctrl = {
                Set = function(_, v) SetToggle(v) end,
                Get = function(_) return state end,
            }
            return ctrl
        end

        -- ── Slider ──
        function tab:AddSlider(slConfig)
            slConfig = slConfig or {}
            local name     = slConfig.Name     or "Slider"
            local desc     = slConfig.Description or ""
            local min      = slConfig.Min      or 0
            local max      = slConfig.Max      or 100
            local default  = slConfig.Default  or min
            local suffix   = slConfig.Suffix   or ""
            local dec      = slConfig.Decimals or 0
            local saveKey  = slConfig.Flag     or name
            local callback = slConfig.Callback or function() end

            if lib.AutoSave and lib.SaveData[saveKey] ~= nil then
                default = lib.SaveData[saveKey]
            end

            local value = math.clamp(default, min, max)

            local H = desc ~= "" and 58 or 46

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, H)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -80, 0, 18)
            NameL.Position = UDim2.fromOffset(12, 6)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            local ValL = Instance.new("TextLabel", Wrap)
            ValL.Size = UDim2.fromOffset(70, 18)
            ValL.AnchorPoint = Vector2.new(1, 0)
            ValL.Position = UDim2.new(1, -12, 0, 6)
            ValL.BackgroundTransparency = 1
            ValL.Text = tostring(Round(value, dec)) .. suffix
            ValL.TextColor3 = Theme.Accent
            ValL.Font = Enum.Font.GothamBold
            ValL.TextSize = 13
            ValL.TextXAlignment = Enum.TextXAlignment.Right
            ValL.ZIndex = 4

            if desc ~= "" then
                local DescL = Instance.new("TextLabel", Wrap)
                DescL.Size = UDim2.new(1, -16, 0, 14)
                DescL.Position = UDim2.fromOffset(12, 22)
                DescL.BackgroundTransparency = 1
                DescL.Text = desc
                DescL.TextColor3 = Theme.SubText
                DescL.Font = Enum.Font.Gotham
                DescL.TextSize = 10
                DescL.TextXAlignment = Enum.TextXAlignment.Left
                DescL.ZIndex = 4
            end

            local trackY = desc ~= "" and 38 or 28

            local TrackBG = Instance.new("Frame", Wrap)
            TrackBG.Size = UDim2.new(1, -24, 0, 5)
            TrackBG.Position = UDim2.fromOffset(12, trackY)
            TrackBG.BackgroundColor3 = Theme.ToggleOff
            TrackBG.BorderSizePixel = 0
            TrackBG.ZIndex = 4
            Instance.new("UICorner", TrackBG).CornerRadius = UDim.new(1, 0)

            local TrackFill = Instance.new("Frame", TrackBG)
            TrackFill.Size = UDim2.fromScale((value - min)/(max - min), 1)
            TrackFill.BackgroundColor3 = Theme.Slider
            TrackFill.BorderSizePixel = 0
            TrackFill.ZIndex = 5
            Instance.new("UICorner", TrackFill).CornerRadius = UDim.new(1, 0)

            local Handle = Instance.new("Frame", TrackBG)
            Handle.Size = UDim2.fromOffset(13, 13)
            Handle.AnchorPoint = Vector2.new(0.5, 0.5)
            Handle.Position = UDim2.new((value-min)/(max-min), 0, 0.5, 0)
            Handle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Handle.BorderSizePixel = 0
            Handle.ZIndex = 6
            Instance.new("UICorner", Handle).CornerRadius = UDim.new(1, 0)

            local draggingSlider = false
            local function SetSlider(pct)
                pct = math.clamp(pct, 0, 1)
                value = Round(min + (max - min) * pct, dec)
                TrackFill.Size = UDim2.fromScale(pct, 1)
                Handle.Position = UDim2.new(pct, 0, 0.5, 0)
                ValL.Text = tostring(value) .. suffix
                lib.SaveData[saveKey] = value
                SaveAll()
                callback(value)
            end

            TrackBG.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    local rel = inp.Position.X - TrackBG.AbsolutePosition.X
                    SetSlider(rel / TrackBG.AbsoluteSize.X)
                end
            end)
            TrackBG.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement and draggingSlider then
                    local rel = inp.Position.X - TrackBG.AbsolutePosition.X
                    SetSlider(rel / TrackBG.AbsoluteSize.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            Handle.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                end
            end)

            task.spawn(function() callback(value) end)

            local ctrl = {
                Set = function(_, v)
                    v = math.clamp(v, min, max)
                    SetSlider((v - min) / (max - min))
                end,
                Get = function(_) return value end,
            }
            return ctrl
        end

        -- ── TextBox ──
        function tab:AddTextBox(tbConfig)
            tbConfig = tbConfig or {}
            local name       = tbConfig.Name        or "TextBox"
            local desc       = tbConfig.Description or ""
            local placeholder= tbConfig.Placeholder or "Digite aqui..."
            local default    = tbConfig.Default     or ""
            local saveKey    = tbConfig.Flag        or name
            local callback   = tbConfig.Callback    or function() end

            if lib.AutoSave and lib.SaveData[saveKey] ~= nil then
                default = lib.SaveData[saveKey]
            end

            local H = desc ~= "" and 68 or 56

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, H)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -16, 0, 18)
            NameL.Position = UDim2.fromOffset(12, 6)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            if desc ~= "" then
                local DescL = Instance.new("TextLabel", Wrap)
                DescL.Size = UDim2.new(1, -16, 0, 14)
                DescL.Position = UDim2.fromOffset(12, 22)
                DescL.BackgroundTransparency = 1
                DescL.Text = desc
                DescL.TextColor3 = Theme.SubText
                DescL.Font = Enum.Font.Gotham
                DescL.TextSize = 10
                DescL.TextXAlignment = Enum.TextXAlignment.Left
                DescL.ZIndex = 4
            end

            local inputY = desc ~= "" and 38 or 28

            local InputBG = Instance.new("Frame", Wrap)
            InputBG.Size = UDim2.new(1, -24, 0, 26)
            InputBG.Position = UDim2.fromOffset(12, inputY)
            InputBG.BackgroundColor3 = Theme.Input
            InputBG.BorderSizePixel = 0
            InputBG.ZIndex = 4
            Instance.new("UICorner", InputBG).CornerRadius = UDim.new(0, 5)
            local IS = Instance.new("UIStroke", InputBG)
            IS.Color = Theme.Border
            IS.Thickness = 0.8

            local InputBox = Instance.new("TextBox", InputBG)
            InputBox.Size = UDim2.new(1, -16, 1, 0)
            InputBox.Position = UDim2.fromOffset(8, 0)
            InputBox.BackgroundTransparency = 1
            InputBox.PlaceholderText = placeholder
            InputBox.PlaceholderColor3 = Theme.SubText
            InputBox.Text = default
            InputBox.TextColor3 = Theme.Text
            InputBox.Font = Enum.Font.Gotham
            InputBox.TextSize = 12
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.ZIndex = 5
            InputBox.ClearTextOnFocus = false

            InputBox.Focused:Connect(function()
                Tween(IS, TweenInfo.new(0.15), {Color = Theme.Accent})
            end)
            InputBox.FocusLost:Connect(function(enter)
                Tween(IS, TweenInfo.new(0.15), {Color = Theme.Border})
                lib.SaveData[saveKey] = InputBox.Text
                SaveAll()
                callback(InputBox.Text, enter)
            end)

            local ctrl = {
                Set = function(_, v) InputBox.Text = v end,
                Get = function(_) return InputBox.Text end,
            }
            return ctrl
        end

        -- ── Dropdown ──
        function tab:AddDropdown(ddConfig)
            ddConfig = ddConfig or {}
            local name     = ddConfig.Name    or "Dropdown"
            local desc     = ddConfig.Description or ""
            local options  = ddConfig.Options or {}
            local default  = ddConfig.Default or (options[1] or "")
            local saveKey  = ddConfig.Flag    or name
            local callback = ddConfig.Callback or function() end
            local multi    = ddConfig.Multi   or false

            if lib.AutoSave and lib.SaveData[saveKey] ~= nil then
                default = lib.SaveData[saveKey]
            end

            local selected = default
            local open = false

            local H = desc ~= "" and 52 or 40

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, H)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.ClipsDescendants = false
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -16, 0, 18)
            NameL.Position = UDim2.fromOffset(12, desc ~= "" and 4 or 3)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            if desc ~= "" then
                local DescL = Instance.new("TextLabel", Wrap)
                DescL.Size = UDim2.new(1, -16, 0, 14)
                DescL.Position = UDim2.fromOffset(12, 22)
                DescL.BackgroundTransparency = 1
                DescL.Text = desc
                DescL.TextColor3 = Theme.SubText
                DescL.Font = Enum.Font.Gotham
                DescL.TextSize = 10
                DescL.TextXAlignment = Enum.TextXAlignment.Left
                DescL.ZIndex = 4
            end

            -- Selector row
            local SelectBtn = Instance.new("TextButton", Wrap)
            SelectBtn.Size = UDim2.new(1, -24, 0, 22)
            SelectBtn.Position = UDim2.fromOffset(12, desc ~= "" and 26 or 12)
            SelectBtn.BackgroundColor3 = Theme.Input
            SelectBtn.Text = ""
            SelectBtn.BorderSizePixel = 0
            SelectBtn.ZIndex = 4
            Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 5)
            local SS = Instance.new("UIStroke", SelectBtn)
            SS.Color = Theme.Border
            SS.Thickness = 0.8

            local SelLabel = Instance.new("TextLabel", SelectBtn)
            SelLabel.Size = UDim2.new(1, -30, 1, 0)
            SelLabel.Position = UDim2.fromOffset(8, 0)
            SelLabel.BackgroundTransparency = 1
            SelLabel.Text = tostring(selected)
            SelLabel.TextColor3 = Theme.Text
            SelLabel.Font = Enum.Font.Gotham
            SelLabel.TextSize = 12
            SelLabel.TextXAlignment = Enum.TextXAlignment.Left
            SelLabel.ZIndex = 5

            local Arrow = Instance.new("TextLabel", SelectBtn)
            Arrow.Size = UDim2.fromOffset(20, 22)
            Arrow.AnchorPoint = Vector2.new(1, 0)
            Arrow.Position = UDim2.new(1, 0, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▾"
            Arrow.TextColor3 = Theme.SubText
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 13
            Arrow.ZIndex = 5

            -- Dropdown list
            local ListFrame = Instance.new("Frame")
            ListFrame.Size = UDim2.new(1, -24, 0, 0)
            ListFrame.Position = UDim2.new(0, 12, 1, 4)
            ListFrame.BackgroundColor3 = Theme.TabSelected
            ListFrame.BorderSizePixel = 0
            ListFrame.ClipsDescendants = true
            ListFrame.ZIndex = 20
            ListFrame.Visible = false
            ListFrame.Parent = Wrap
            Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 7)
            local LS = Instance.new("UIStroke", ListFrame)
            LS.Color = Theme.Border
            LS.Thickness = 0.8
            local ListLayout = Instance.new("UIListLayout", ListFrame)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local ListPad = Instance.new("UIPadding", ListFrame)
            ListPad.PaddingTop = UDim.new(0, 4)
            ListPad.PaddingBottom = UDim.new(0, 4)

            local function CloseDropdown()
                open = false
                Arrow.Text = "▾"
                Tween(ListFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, -24, 0, 0)})
                task.wait(0.15)
                ListFrame.Visible = false
            end

            local function OpenDropdown()
                open = true
                Arrow.Text = "▴"
                ListFrame.Visible = true
                local itemH = #options * 26 + 8
                itemH = math.min(itemH, 150)
                Tween(ListFrame, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = UDim2.new(1, -24, 0, itemH)})
            end

            -- Build list items
            for i, opt in ipairs(options) do
                local Item = Instance.new("TextButton", ListFrame)
                Item.Size = UDim2.new(1, 0, 0, 26)
                Item.BackgroundTransparency = 1
                Item.Text = tostring(opt)
                Item.TextColor3 = tostring(opt) == tostring(selected) and Theme.Accent or Theme.Text
                Item.Font = Enum.Font.Gotham
                Item.TextSize = 12
                Item.BorderSizePixel = 0
                Item.LayoutOrder = i
                Item.ZIndex = 21

                Item.MouseEnter:Connect(function()
                    Tween(Item, TweenInfo.new(0.1), {BackgroundTransparency = 0, BackgroundColor3 = Theme.ElementHover})
                end)
                Item.MouseLeave:Connect(function()
                    Tween(Item, TweenInfo.new(0.1), {BackgroundTransparency = 1})
                end)
                Item.MouseButton1Click:Connect(function()
                    selected = tostring(opt)
                    SelLabel.Text = selected
                    lib.SaveData[saveKey] = selected
                    SaveAll()
                    -- Reset all item colors
                    for _, child in ipairs(ListFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = Theme.Text
                        end
                    end
                    Item.TextColor3 = Theme.Accent
                    callback(selected)
                    CloseDropdown()
                end)
            end

            SelectBtn.MouseButton1Click:Connect(function()
                if open then CloseDropdown() else OpenDropdown() end
            end)

            -- Close when clicking elsewhere
            UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 and open then
                    local pos = inp.Position
                    local abs = ListFrame.AbsolutePosition
                    local siz = ListFrame.AbsoluteSize
                    if not (pos.X >= abs.X and pos.X <= abs.X + siz.X and pos.Y >= abs.Y and pos.Y <= abs.Y + siz.Y) then
                        CloseDropdown()
                    end
                end
            end)

            task.spawn(function() callback(selected) end)

            local ctrl = {
                Set = function(_, v)
                    selected = tostring(v)
                    SelLabel.Text = selected
                    callback(selected)
                end,
                Get = function(_) return selected end,
                Refresh = function(_, newOptions)
                    -- clear and rebuild
                    for _, c in ipairs(ListFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    options = newOptions
                    for i, opt in ipairs(options) do
                        local Item = Instance.new("TextButton", ListFrame)
                        Item.Size = UDim2.new(1, 0, 0, 26)
                        Item.BackgroundTransparency = 1
                        Item.Text = tostring(opt)
                        Item.TextColor3 = tostring(opt) == selected and Theme.Accent or Theme.Text
                        Item.Font = Enum.Font.Gotham
                        Item.TextSize = 12
                        Item.BorderSizePixel = 0
                        Item.LayoutOrder = i
                        Item.ZIndex = 21
                        Item.MouseButton1Click:Connect(function()
                            selected = tostring(opt)
                            SelLabel.Text = selected
                            lib.SaveData[saveKey] = selected
                            SaveAll()
                            callback(selected)
                            CloseDropdown()
                        end)
                    end
                end,
            }
            return ctrl
        end

        -- ── ColorPicker ──
        function tab:AddColorPicker(cpConfig)
            cpConfig = cpConfig or {}
            local name     = cpConfig.Name    or "Color"
            local default  = cpConfig.Default or Color3.fromRGB(255, 100, 100)
            local saveKey  = cpConfig.Flag    or name
            local callback = cpConfig.Callback or function() end

            if lib.AutoSave and lib.SaveData[saveKey] ~= nil then
                local sv = lib.SaveData[saveKey]
                if type(sv) == "table" and sv.r then
                    default = Color3.fromRGB(sv.r, sv.g, sv.b)
                end
            end

            local color = default
            local open = false

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, 36)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -60, 1, 0)
            NameL.Position = UDim2.fromOffset(12, 0)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            local Preview = Instance.new("TextButton", Wrap)
            Preview.Size = UDim2.fromOffset(36, 22)
            Preview.AnchorPoint = Vector2.new(1, 0.5)
            Preview.Position = UDim2.new(1, -12, 0.5, 0)
            Preview.BackgroundColor3 = color
            Preview.Text = ""
            Preview.BorderSizePixel = 0
            Preview.ZIndex = 4
            Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 5)
            local PS = Instance.new("UIStroke", Preview)
            PS.Color = Theme.Border
            PS.Thickness = 0.8

            -- Simple HSV picker popup
            local Picker = Instance.new("Frame")
            Picker.Size = UDim2.fromOffset(200, 160)
            Picker.Position = UDim2.new(0, 12, 1, 4)
            Picker.BackgroundColor3 = Theme.TabSelected
            Picker.BorderSizePixel = 0
            Picker.ZIndex = 25
            Picker.Visible = false
            Picker.Parent = Wrap
            Instance.new("UICorner", Picker).CornerRadius = UDim.new(0, 8)
            local PKS = Instance.new("UIStroke", Picker)
            PKS.Color = Theme.Accent
            PKS.Thickness = 1

            local function UpdateColor(h, s, v)
                color = Color3.fromHSV(h, s, v)
                Preview.BackgroundColor3 = color
                lib.SaveData[saveKey] = {r = math.floor(color.R*255), g = math.floor(color.G*255), b = math.floor(color.B*255)}
                SaveAll()
                callback(color)
            end

            local h0, s0, v0 = Color3.toHSV(color)

            -- Hue bar
            local HueBar = Instance.new("ImageLabel", Picker)
            HueBar.Size = UDim2.new(1, -16, 0, 16)
            HueBar.Position = UDim2.fromOffset(8, 8)
            HueBar.Image = "rbxassetid://6020299385" -- hue gradient
            HueBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
            HueBar.BorderSizePixel = 0
            HueBar.ZIndex = 26
            Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)

            local HueHandle = Instance.new("Frame", HueBar)
            HueHandle.Size = UDim2.fromOffset(4, 20)
            HueHandle.AnchorPoint = Vector2.new(0.5, 0.5)
            HueHandle.Position = UDim2.new(h0, 0, 0.5, 0)
            HueHandle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            HueHandle.BorderSizePixel = 0
            HueHandle.ZIndex = 27
            Instance.new("UICorner", HueHandle).CornerRadius = UDim.new(0, 2)

            -- SV field
            local SVField = Instance.new("ImageLabel", Picker)
            SVField.Size = UDim2.new(1, -16, 0, 90)
            SVField.Position = UDim2.fromOffset(8, 32)
            SVField.Image = "rbxassetid://6020299461"
            SVField.BackgroundColor3 = Color3.fromHSV(h0, 1, 1)
            SVField.BorderSizePixel = 0
            SVField.ZIndex = 26
            Instance.new("UICorner", SVField).CornerRadius = UDim.new(0, 4)

            local SVHandle = Instance.new("Frame", SVField)
            SVHandle.Size = UDim2.fromOffset(10, 10)
            SVHandle.AnchorPoint = Vector2.new(0.5, 0.5)
            SVHandle.Position = UDim2.new(s0, 0, 1-v0, 0)
            SVHandle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            SVHandle.BorderSizePixel = 0
            SVHandle.ZIndex = 27
            Instance.new("UICorner", SVHandle).CornerRadius = UDim.new(1, 0)
            local SVS = Instance.new("UIStroke", SVHandle)
            SVS.Color = Color3.fromRGB(0,0,0)
            SVS.Thickness = 1

            local hue, sat, val = h0, s0, v0

            local function dragHue(inp)
                local rel = math.clamp((inp.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                hue = rel
                HueHandle.Position = UDim2.new(rel, 0, 0.5, 0)
                SVField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                UpdateColor(hue, sat, val)
            end

            local function dragSV(inp)
                local rx = math.clamp((inp.Position.X - SVField.AbsolutePosition.X) / SVField.AbsoluteSize.X, 0, 1)
                local ry = math.clamp((inp.Position.Y - SVField.AbsolutePosition.Y) / SVField.AbsoluteSize.Y, 0, 1)
                sat = rx
                val = 1 - ry
                SVHandle.Position = UDim2.new(rx, 0, ry, 0)
                UpdateColor(hue, sat, val)
            end

            local draggingH, draggingS = false, false
            HueBar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingH = true; dragHue(inp)
                end
            end)
            HueBar.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingH = false end
            end)
            SVField.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingS = true; dragSV(inp)
                end
            end)
            SVField.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingS = false end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    if draggingH then dragHue(inp) end
                    if draggingS then dragSV(inp) end
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingH = false; draggingS = false
                end
            end)

            -- Hex input
            local HexBG = Instance.new("Frame", Picker)
            HexBG.Size = UDim2.new(1, -16, 0, 24)
            HexBG.Position = UDim2.fromOffset(8, 130)
            HexBG.BackgroundColor3 = Theme.Input
            HexBG.BorderSizePixel = 0
            HexBG.ZIndex = 26
            Instance.new("UICorner", HexBG).CornerRadius = UDim.new(0, 5)
            local HS = Instance.new("UIStroke", HexBG)
            HS.Color = Theme.Border
            HS.Thickness = 0.8

            local HexBox = Instance.new("TextBox", HexBG)
            HexBox.Size = UDim2.new(1, -10, 1, 0)
            HexBox.Position = UDim2.fromOffset(5, 0)
            HexBox.BackgroundTransparency = 1
            HexBox.Text = string.format("#%02X%02X%02X", color.R*255, color.G*255, color.B*255)
            HexBox.TextColor3 = Theme.Text
            HexBox.Font = Enum.Font.Code
            HexBox.TextSize = 11
            HexBox.ZIndex = 27
            HexBox.ClearTextOnFocus = false

            HexBox.FocusLost:Connect(function()
                local hex = HexBox.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1,2), 16)
                    local g = tonumber(hex:sub(3,4), 16)
                    local b = tonumber(hex:sub(5,6), 16)
                    if r and g and b then
                        color = Color3.fromRGB(r, g, b)
                        Preview.BackgroundColor3 = color
                        hue, sat, val = Color3.toHSV(color)
                        SVField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                        HueHandle.Position = UDim2.new(hue, 0, 0.5, 0)
                        SVHandle.Position = UDim2.new(sat, 0, 1-val, 0)
                        UpdateColor(hue, sat, val)
                    end
                end
            end)

            Preview.MouseButton1Click:Connect(function()
                open = not open
                Picker.Visible = open
                if open then
                    HexBox.Text = string.format("#%02X%02X%02X", color.R*255, color.G*255, color.B*255)
                end
            end)

            task.spawn(function() callback(color) end)

            local ctrl = {
                Set = function(_, c)
                    color = c
                    Preview.BackgroundColor3 = c
                    callback(c)
                end,
                Get = function(_) return color end,
            }
            return ctrl
        end

        -- ── Keybind ──
        function tab:AddKeybind(kbConfig)
            kbConfig = kbConfig or {}
            local name     = kbConfig.Name    or "Keybind"
            local default  = kbConfig.Default or Enum.KeyCode.Unknown
            local saveKey  = kbConfig.Flag    or name
            local callback = kbConfig.Callback or function() end

            local key = default
            local listening = false

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, 36)
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WS = Instance.new("UIStroke", Wrap)
            WS.Color = Theme.Border
            WS.Thickness = 0.8

            local NameL = Instance.new("TextLabel", Wrap)
            NameL.Size = UDim2.new(1, -100, 1, 0)
            NameL.Position = UDim2.fromOffset(12, 0)
            NameL.BackgroundTransparency = 1
            NameL.Text = name
            NameL.TextColor3 = Theme.Text
            NameL.Font = Enum.Font.GothamSemibold
            NameL.TextSize = 13
            NameL.TextXAlignment = Enum.TextXAlignment.Left
            NameL.ZIndex = 4

            local KeyBtn = Instance.new("TextButton", Wrap)
            KeyBtn.Size = UDim2.fromOffset(80, 24)
            KeyBtn.AnchorPoint = Vector2.new(1, 0.5)
            KeyBtn.Position = UDim2.new(1, -12, 0.5, 0)
            KeyBtn.BackgroundColor3 = Theme.Input
            KeyBtn.Text = key.Name
            KeyBtn.TextColor3 = Theme.Accent
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 11
            KeyBtn.BorderSizePixel = 0
            KeyBtn.ZIndex = 4
            Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 5)
            local KS = Instance.new("UIStroke", KeyBtn)
            KS.Color = Theme.Border
            KS.Thickness = 0.8

            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
                KeyBtn.TextColor3 = Theme.SubText
                Tween(KS, TweenInfo.new(0.15), {Color = Theme.Accent})
            end)

            UserInputService.InputBegan:Connect(function(inp, gp)
                if listening and not gp then
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        key = inp.KeyCode
                        KeyBtn.Text = key.Name
                        KeyBtn.TextColor3 = Theme.Accent
                        Tween(KS, TweenInfo.new(0.15), {Color = Theme.Border})
                        listening = false
                        lib.SaveData[saveKey] = key.Name
                        SaveAll()
                    end
                elseif not listening and inp.KeyCode == key then
                    callback(key)
                end
            end)

            local ctrl = {
                Set = function(_, k)
                    key = k
                    KeyBtn.Text = k.Name
                end,
                Get = function(_) return key end,
            }
            return ctrl
        end

        -- ── Label ──
        function tab:AddLabel(text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 28)
            Lbl.BackgroundColor3 = Theme.Element
            Lbl.Text = text or ""
            Lbl.TextColor3 = Theme.SubText
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 12
            Lbl.BorderSizePixel = 0
            Lbl.LayoutOrder = NextOrder()
            Lbl.ZIndex = 3
            Lbl.Parent = Page
            Instance.new("UICorner", Lbl).CornerRadius = UDim.new(0, 7)
            local Pad = Instance.new("UIPadding", Lbl)
            Pad.PaddingLeft = UDim.new(0, 12)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local ctrl = {
                SetText = function(_, t) Lbl.Text = t end,
                GetText = function(_) return Lbl.Text end,
            }
            return ctrl
        end

        -- ── Paragraph ──
        function tab:AddParagraph(pConfig)
            pConfig = pConfig or {}
            local title = pConfig.Title or ""
            local body  = pConfig.Body  or ""

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, 0)
            Wrap.AutomaticSize = Enum.AutomaticSize.Y
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local WPad = Instance.new("UIPadding", Wrap)
            WPad.PaddingLeft = UDim.new(0, 12)
            WPad.PaddingRight = UDim.new(0, 12)
            WPad.PaddingTop = UDim.new(0, 8)
            WPad.PaddingBottom = UDim.new(0, 8)
            local WL = Instance.new("UIListLayout", Wrap)
            WL.Padding = UDim.new(0, 4)

            if title ~= "" then
                local TL = Instance.new("TextLabel", Wrap)
                TL.Size = UDim2.new(1, 0, 0, 0)
                TL.AutomaticSize = Enum.AutomaticSize.Y
                TL.BackgroundTransparency = 1
                TL.Text = title
                TL.TextColor3 = Theme.Text
                TL.Font = Enum.Font.GothamBold
                TL.TextSize = 13
                TL.TextXAlignment = Enum.TextXAlignment.Left
                TL.TextWrapped = true
                TL.ZIndex = 4
            end

            if body ~= "" then
                local BL = Instance.new("TextLabel", Wrap)
                BL.Size = UDim2.new(1, 0, 0, 0)
                BL.AutomaticSize = Enum.AutomaticSize.Y
                BL.BackgroundTransparency = 1
                BL.Text = body
                BL.TextColor3 = Theme.SubText
                BL.Font = Enum.Font.Gotham
                BL.TextSize = 11
                BL.TextXAlignment = Enum.TextXAlignment.Left
                BL.TextWrapped = true
                BL.ZIndex = 4
            end

            return Wrap
        end

        -- ── Separator ──
        function tab:AddSeparator()
            local Sep = Instance.new("Frame")
            Sep.Size = UDim2.new(1, 0, 0, 1)
            Sep.BackgroundColor3 = Theme.Border
            Sep.BorderSizePixel = 0
            Sep.LayoutOrder = NextOrder()
            Sep.ZIndex = 3
            Sep.Parent = Page
            return Sep
        end

        -- ── Input w/ Confirm Button ──
        function tab:AddInput(inConfig)
            return self:AddTextBox(inConfig)
        end

        -- ── Notification (inline) ──
        function tab:AddNotification(notifConfig)
            notifConfig = notifConfig or {}
            local title = notifConfig.Title or "Info"
            local msg   = notifConfig.Message or ""
            local ntype = notifConfig.Type  or "info" -- info, warn, error, success
            local colors = {
                info    = Color3.fromRGB(60, 130, 255),
                warn    = Color3.fromRGB(255, 180, 40),
                error   = Color3.fromRGB(255, 60, 60),
                success = Color3.fromRGB(50, 200, 100),
            }
            local ac = colors[ntype] or colors.info

            local Wrap = Instance.new("Frame")
            Wrap.Size = UDim2.new(1, 0, 0, 0)
            Wrap.AutomaticSize = Enum.AutomaticSize.Y
            Wrap.BackgroundColor3 = Theme.Element
            Wrap.BorderSizePixel = 0
            Wrap.LayoutOrder = NextOrder()
            Wrap.ZIndex = 3
            Wrap.Parent = Page
            Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 7)
            local NS = Instance.new("UIStroke", Wrap)
            NS.Color = ac
            NS.Thickness = 1

            local AccentBar = Instance.new("Frame", Wrap)
            AccentBar.Size = UDim2.fromOffset(3, 0)
            AccentBar.AutomaticSize = Enum.AutomaticSize.Y
            AccentBar.BackgroundColor3 = ac
            AccentBar.BorderSizePixel = 0
            AccentBar.ZIndex = 4
            Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 7)

            local NPad = Instance.new("UIPadding", Wrap)
            NPad.PaddingLeft = UDim.new(0, 14)
            NPad.PaddingRight = UDim.new(0, 10)
            NPad.PaddingTop = UDim.new(0, 8)
            NPad.PaddingBottom = UDim.new(0, 8)
            local NL = Instance.new("UIListLayout", Wrap)
            NL.Padding = UDim.new(0, 2)

            local TL = Instance.new("TextLabel", Wrap)
            TL.Size = UDim2.new(1, 0, 0, 0)
            TL.AutomaticSize = Enum.AutomaticSize.Y
            TL.BackgroundTransparency = 1
            TL.Text = title
            TL.TextColor3 = ac
            TL.Font = Enum.Font.GothamBold
            TL.TextSize = 12
            TL.TextXAlignment = Enum.TextXAlignment.Left
            TL.ZIndex = 4

            if msg ~= "" then
                local ML = Instance.new("TextLabel", Wrap)
                ML.Size = UDim2.new(1, 0, 0, 0)
                ML.AutomaticSize = Enum.AutomaticSize.Y
                ML.BackgroundTransparency = 1
                ML.Text = msg
                ML.TextColor3 = Theme.SubText
                ML.Font = Enum.Font.Gotham
                ML.TextSize = 11
                ML.TextXAlignment = Enum.TextXAlignment.Left
                ML.TextWrapped = true
                ML.ZIndex = 4
            end

            return Wrap
        end

        return tab
    end

    -- ══════════════════════════════════════════════
    --          ADD CONFIG TAB
    -- ══════════════════════════════════════════════
    function Window:AddConfig()
        local configTab = self:AddTab({Name = "⚙ Config", Icon = ""})

        -- Theme section
        configTab:AddSection("Aparência")

        -- Theme dropdown
        local themeNames = {}
        for k in pairs(Themes) do table.insert(themeNames, k) end
        table.sort(themeNames)

        configTab:AddDropdown({
            Name    = "Tema",
            Description = "Escolha o tema da interface",
            Options = themeNames,
            Default = lib.ThemeName,
            Flag    = "SelectedTheme",
            Callback = function(sel)
                if Themes[sel] then
                    lib.ThemeName = sel
                    lib.Theme = Themes[sel]
                    Theme = lib.Theme
                    -- Note: full re-theme requires a reinit; we update key elements
                    -- (A full dynamic re-theme is very complex; we update what we can)
                    Main.BackgroundColor3 = Theme.Background
                    TopBar.BackgroundColor3 = Theme.TopBar
                    TBFix.BackgroundColor3 = Theme.TopBar
                    MainStroke.Color = Theme.Border
                    TopStroke.Color = Theme.Border
                    TabSide.BackgroundColor3 = Theme.Tab
                end
            end,
        })

        -- Opacity toggle
        configTab:AddToggle({
            Name     = "Fundo Semi-transparente",
            Description = "Deixa o fundo com 60% de opacidade",
            Default  = false,
            Flag     = "BGOpacity",
            Callback = function(val)
                Window._opacity = val
                Tween(Main, TweenInfo.new(0.25), {BackgroundTransparency = val and 0.4 or 0})
            end,
        })

        -- AutoSave toggle
        configTab:AddSection("Sistema")

        configTab:AddToggle({
            Name     = "AutoSave & Load",
            Description = "Salva e carrega automaticamente as configurações",
            Default  = lib.AutoSave,
            Flag     = "AutoSaveToggle",
            Callback = function(val)
                lib.AutoSave = val
                if val then
                    local raw = HttpService:JSONEncode(lib.SaveData)
                    WriteFile(lib.SaveFile, raw)
                end
            end,
        })

        configTab:AddButton({
            Name     = "Limpar Save",
            Description = "Apaga todos os dados salvos",
            Callback = function()
                lib.SaveData = {}
                if writefile then
                    pcall(writefile, lib.SaveFile, "{}")
                end
            end,
        })

        configTab:AddSeparator()

        configTab:AddLabel("NeonLira V2 • Elison999")

        return configTab
    end

    table.insert(lib.Windows, Window)
    return Window
end

-- ══════════════════════════════════════════════
--          TOAST NOTIFICATIONS
-- ══════════════════════════════════════════════
function NeonLira:Notify(config)
    config = config or {}
    local title   = config.Title    or "Notificação"
    local message = config.Message  or ""
    local duration= config.Duration or 3
    local ntype   = config.Type     or "info"
    local Theme   = self.Theme

    local colors = {
        info    = Color3.fromRGB(60, 130, 255),
        warn    = Color3.fromRGB(255, 180, 40),
        error   = Color3.fromRGB(255, 60, 60),
        success = Color3.fromRGB(50, 200, 100),
    }
    local ac = colors[ntype] or colors.info

    -- Find or create container
    local container
    local existing = CoreGui:FindFirstChild("NeonLiraNotifs")
    if not existing then
        existing = Instance.new("ScreenGui")
        existing.Name = "NeonLiraNotifs"
        existing.ResetOnSpawn = false
        existing.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        existing.DisplayOrder = 200
        pcall(function() existing.Parent = CoreGui end)
        if not existing.Parent then existing.Parent = LocalPlayer.PlayerGui end

        container = Instance.new("Frame")
        container.Name = "Container"
        container.Size = UDim2.fromOffset(280, 0)
        container.AnchorPoint = Vector2.new(1, 1)
        container.Position = UDim2.new(1, -12, 1, -12)
        container.BackgroundTransparency = 1
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.ZIndex = 201
        container.Parent = existing
        local CL = Instance.new("UIListLayout", container)
        CL.VerticalAlignment = Enum.VerticalAlignment.Bottom
        CL.Padding = UDim.new(0, 6)
        CL.SortOrder = Enum.SortOrder.LayoutOrder
    else
        container = existing:FindFirstChild("Container")
    end

    if not container then return end

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Theme.Background
    Card.BorderSizePixel = 0
    Card.ZIndex = 202
    Card.Parent = container
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = ac
    CardStroke.Thickness = 1

    local AccBar = Instance.new("Frame", Card)
    AccBar.Size = UDim2.fromOffset(3, 0)
    AccBar.AutomaticSize = Enum.AutomaticSize.Y
    AccBar.Position = UDim2.fromOffset(0, 0)
    AccBar.BackgroundColor3 = ac
    AccBar.BorderSizePixel = 0
    AccBar.ZIndex = 203
    Instance.new("UICorner", AccBar).CornerRadius = UDim.new(0, 8)

    local CPad = Instance.new("UIPadding", Card)
    CPad.PaddingLeft = UDim.new(0, 14)
    CPad.PaddingRight = UDim.new(0, 10)
    CPad.PaddingTop = UDim.new(0, 8)
    CPad.PaddingBottom = UDim.new(0, 8)
    local CLayout = Instance.new("UIListLayout", Card)
    CLayout.Padding = UDim.new(0, 3)

    local TL = Instance.new("TextLabel", Card)
    TL.Size = UDim2.new(1, 0, 0, 0)
    TL.AutomaticSize = Enum.AutomaticSize.Y
    TL.BackgroundTransparency = 1
    TL.Text = title
    TL.TextColor3 = ac
    TL.Font = Enum.Font.GothamBold
    TL.TextSize = 13
    TL.TextXAlignment = Enum.TextXAlignment.Left
    TL.TextWrapped = true
    TL.ZIndex = 203

    if message ~= "" then
        local ML = Instance.new("TextLabel", Card)
        ML.Size = UDim2.new(1, 0, 0, 0)
        ML.AutomaticSize = Enum.AutomaticSize.Y
        ML.BackgroundTransparency = 1
        ML.Text = message
        ML.TextColor3 = Theme.SubText
        ML.Font = Enum.Font.Gotham
        ML.TextSize = 11
        ML.TextXAlignment = Enum.TextXAlignment.Left
        ML.TextWrapped = true
        ML.ZIndex = 203
    end

    -- Progress bar
    local ProgBG = Instance.new("Frame", Card)
    ProgBG.Size = UDim2.new(1, 0, 0, 2)
    ProgBG.BackgroundColor3 = Theme.ToggleOff
    ProgBG.BorderSizePixel = 0
    ProgBG.ZIndex = 203
    Instance.new("UICorner", ProgBG).CornerRadius = UDim.new(1, 0)

    local Prog = Instance.new("Frame", ProgBG)
    Prog.Size = UDim2.fromScale(1, 1)
    Prog.BackgroundColor3 = ac
    Prog.BorderSizePixel = 0
    Prog.ZIndex = 204
    Instance.new("UICorner", Prog).CornerRadius = UDim.new(1, 0)

    -- Animate in
    Card.BackgroundTransparency = 1
    Tween(Card, TweenInfo.new(0.3), {BackgroundTransparency = 0})

    -- Progress countdown
    Tween(Prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.fromScale(0, 1)})

    task.delay(duration, function()
        Tween(Card, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        task.wait(0.3)
        Card:Destroy()
    end)
end

-- ══════════════════════════════════════════════
--          DESTROY
-- ══════════════════════════════════════════════
function NeonLira:Destroy()
    for _, win in ipairs(self.Windows) do
        if win._gui and win._gui.Parent then
            win._gui:Destroy()
        end
    end
    local notifGui = CoreGui:FindFirstChild("NeonLiraNotifs")
    if notifGui then notifGui:Destroy() end
end

return NeonLira
