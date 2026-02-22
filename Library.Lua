--[[
    NexusUI Library v1.0
    Super Modern OOP Roblox UI Library
    Features: Window, Tab, Section, Label, Button, Toggle, Slider, Dropdown, Textbox, Keybind, ColorPicker
    Auto-Save, Key System, Themes, Loading Screen
    
    Usage:
    local NexusUI = loadstring(game:HttpGet("YOUR_RAW_LINK"))()
    local Window = NexusUI:CreateWindow({...})
]]

-- ══════════════════════════════════════════════════════════
--                     SERVICES & VARS
-- ══════════════════════════════════════════════════════════
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

local NexusUI = {}
NexusUI.__index = NexusUI
NexusUI.Version = "1.0.0"
NexusUI.Windows = {}

-- ══════════════════════════════════════════════════════════
--                      THEME SYSTEM
-- ══════════════════════════════════════════════════════════
local Themes = {
    ["Dark"] = {
        Background    = Color3.fromRGB(18, 18, 24),
        Secondary     = Color3.fromRGB(26, 26, 35),
        Tertiary      = Color3.fromRGB(34, 34, 46),
        Accent        = Color3.fromRGB(99, 102, 241),
        AccentDark    = Color3.fromRGB(79, 82, 211),
        AccentLight   = Color3.fromRGB(129, 132, 255),
        Text          = Color3.fromRGB(240, 240, 250),
        SubText       = Color3.fromRGB(150, 150, 175),
        Border        = Color3.fromRGB(50, 50, 70),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 0, 0),
        TopBar        = Color3.fromRGB(22, 22, 30),
        Toggle_OFF    = Color3.fromRGB(60, 60, 80),
        Toggle_ON     = Color3.fromRGB(99, 102, 241),
    },
    ["Light"] = {
        Background    = Color3.fromRGB(248, 248, 255),
        Secondary     = Color3.fromRGB(235, 235, 245),
        Tertiary      = Color3.fromRGB(220, 220, 235),
        Accent        = Color3.fromRGB(79, 82, 211),
        AccentDark    = Color3.fromRGB(59, 62, 191),
        AccentLight   = Color3.fromRGB(109, 112, 241),
        Text          = Color3.fromRGB(20, 20, 35),
        SubText       = Color3.fromRGB(90, 90, 120),
        Border        = Color3.fromRGB(190, 190, 215),
        Success       = Color3.fromRGB(22, 163, 74),
        Error         = Color3.fromRGB(220, 38, 38),
        Warning       = Color3.fromRGB(202, 138, 4),
        Shadow        = Color3.fromRGB(150, 150, 180),
        TopBar        = Color3.fromRGB(230, 230, 245),
        Toggle_OFF    = Color3.fromRGB(180, 180, 210),
        Toggle_ON     = Color3.fromRGB(79, 82, 211),
    },
    ["Midnight"] = {
        Background    = Color3.fromRGB(5, 5, 15),
        Secondary     = Color3.fromRGB(10, 10, 25),
        Tertiary      = Color3.fromRGB(15, 15, 35),
        Accent        = Color3.fromRGB(139, 92, 246),
        AccentDark    = Color3.fromRGB(109, 62, 216),
        AccentLight   = Color3.fromRGB(167, 139, 250),
        Text          = Color3.fromRGB(230, 220, 255),
        SubText       = Color3.fromRGB(130, 115, 170),
        Border        = Color3.fromRGB(40, 30, 70),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 0, 0),
        TopBar        = Color3.fromRGB(8, 8, 20),
        Toggle_OFF    = Color3.fromRGB(45, 35, 80),
        Toggle_ON     = Color3.fromRGB(139, 92, 246),
    },
    ["Ocean"] = {
        Background    = Color3.fromRGB(10, 20, 40),
        Secondary     = Color3.fromRGB(15, 30, 55),
        Tertiary      = Color3.fromRGB(20, 40, 70),
        Accent        = Color3.fromRGB(6, 182, 212),
        AccentDark    = Color3.fromRGB(8, 145, 178),
        AccentLight   = Color3.fromRGB(103, 232, 249),
        Text          = Color3.fromRGB(220, 240, 255),
        SubText       = Color3.fromRGB(100, 150, 190),
        Border        = Color3.fromRGB(30, 70, 110),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 5, 15),
        TopBar        = Color3.fromRGB(8, 16, 32),
        Toggle_OFF    = Color3.fromRGB(20, 60, 95),
        Toggle_ON     = Color3.fromRGB(6, 182, 212),
    },
    ["Forest"] = {
        Background    = Color3.fromRGB(10, 22, 14),
        Secondary     = Color3.fromRGB(15, 32, 20),
        Tertiary      = Color3.fromRGB(20, 44, 28),
        Accent        = Color3.fromRGB(34, 197, 94),
        AccentDark    = Color3.fromRGB(22, 163, 74),
        AccentLight   = Color3.fromRGB(74, 222, 128),
        Text          = Color3.fromRGB(220, 245, 225),
        SubText       = Color3.fromRGB(100, 160, 115),
        Border        = Color3.fromRGB(30, 80, 45),
        Success       = Color3.fromRGB(74, 222, 128),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 5, 2),
        TopBar        = Color3.fromRGB(8, 18, 11),
        Toggle_OFF    = Color3.fromRGB(22, 70, 38),
        Toggle_ON     = Color3.fromRGB(34, 197, 94),
    },
    ["Sunset"] = {
        Background    = Color3.fromRGB(30, 10, 20),
        Secondary     = Color3.fromRGB(45, 15, 30),
        Tertiary      = Color3.fromRGB(60, 20, 38),
        Accent        = Color3.fromRGB(251, 113, 133),
        AccentDark    = Color3.fromRGB(225, 75, 100),
        AccentLight   = Color3.fromRGB(255, 160, 175),
        Text          = Color3.fromRGB(255, 235, 240),
        SubText       = Color3.fromRGB(185, 130, 145),
        Border        = Color3.fromRGB(100, 40, 60),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(251, 191, 36),
        Shadow        = Color3.fromRGB(10, 0, 5),
        TopBar        = Color3.fromRGB(22, 8, 15),
        Toggle_OFF    = Color3.fromRGB(90, 35, 55),
        Toggle_ON     = Color3.fromRGB(251, 113, 133),
    },
    ["Cyberpunk"] = {
        Background    = Color3.fromRGB(8, 5, 18),
        Secondary     = Color3.fromRGB(14, 8, 28),
        Tertiary      = Color3.fromRGB(20, 12, 40),
        Accent        = Color3.fromRGB(255, 215, 0),
        AccentDark    = Color3.fromRGB(200, 168, 0),
        AccentLight   = Color3.fromRGB(255, 240, 80),
        Text          = Color3.fromRGB(255, 245, 210),
        SubText       = Color3.fromRGB(160, 140, 90),
        Border        = Color3.fromRGB(60, 40, 100),
        Success       = Color3.fromRGB(0, 255, 128),
        Error         = Color3.fromRGB(255, 50, 80),
        Warning       = Color3.fromRGB(255, 215, 0),
        Shadow        = Color3.fromRGB(0, 0, 5),
        TopBar        = Color3.fromRGB(5, 3, 12),
        Toggle_OFF    = Color3.fromRGB(45, 28, 75),
        Toggle_ON     = Color3.fromRGB(255, 215, 0),
    },
    ["Ruby"] = {
        Background    = Color3.fromRGB(25, 8, 8),
        Secondary     = Color3.fromRGB(38, 12, 12),
        Tertiary      = Color3.fromRGB(52, 18, 18),
        Accent        = Color3.fromRGB(239, 68, 68),
        AccentDark    = Color3.fromRGB(200, 40, 40),
        AccentLight   = Color3.fromRGB(252, 120, 120),
        Text          = Color3.fromRGB(255, 235, 235),
        SubText       = Color3.fromRGB(175, 125, 125),
        Border        = Color3.fromRGB(100, 35, 35),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(8, 0, 0),
        TopBar        = Color3.fromRGB(18, 5, 5),
        Toggle_OFF    = Color3.fromRGB(85, 28, 28),
        Toggle_ON     = Color3.fromRGB(239, 68, 68),
    },
    ["Neon"] = {
        Background    = Color3.fromRGB(5, 5, 8),
        Secondary     = Color3.fromRGB(8, 8, 14),
        Tertiary      = Color3.fromRGB(12, 12, 20),
        Accent        = Color3.fromRGB(0, 255, 200),
        AccentDark    = Color3.fromRGB(0, 200, 155),
        AccentLight   = Color3.fromRGB(80, 255, 220),
        Text          = Color3.fromRGB(220, 255, 248),
        SubText       = Color3.fromRGB(100, 175, 158),
        Border        = Color3.fromRGB(0, 80, 62),
        Success       = Color3.fromRGB(0, 255, 200),
        Error         = Color3.fromRGB(255, 60, 100),
        Warning       = Color3.fromRGB(255, 220, 0),
        Shadow        = Color3.fromRGB(0, 0, 0),
        TopBar        = Color3.fromRGB(3, 3, 5),
        Toggle_OFF    = Color3.fromRGB(15, 60, 52),
        Toggle_ON     = Color3.fromRGB(0, 255, 200),
    },
    ["Sakura"] = {
        Background    = Color3.fromRGB(30, 18, 28),
        Secondary     = Color3.fromRGB(44, 26, 40),
        Tertiary      = Color3.fromRGB(58, 35, 54),
        Accent        = Color3.fromRGB(244, 114, 182),
        AccentDark    = Color3.fromRGB(219, 74, 152),
        AccentLight   = Color3.fromRGB(255, 162, 210),
        Text          = Color3.fromRGB(255, 235, 252),
        SubText       = Color3.fromRGB(185, 140, 178),
        Border        = Color3.fromRGB(110, 60, 100),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(10, 0, 8),
        TopBar        = Color3.fromRGB(22, 12, 20),
        Toggle_OFF    = Color3.fromRGB(95, 52, 88),
        Toggle_ON     = Color3.fromRGB(244, 114, 182),
    },
    ["Arctic"] = {
        Background    = Color3.fromRGB(12, 18, 30),
        Secondary     = Color3.fromRGB(18, 28, 48),
        Tertiary      = Color3.fromRGB(25, 38, 65),
        Accent        = Color3.fromRGB(147, 197, 253),
        AccentDark    = Color3.fromRGB(96, 165, 250),
        AccentLight   = Color3.fromRGB(186, 230, 253),
        Text          = Color3.fromRGB(225, 240, 255),
        SubText       = Color3.fromRGB(120, 155, 200),
        Border        = Color3.fromRGB(40, 70, 120),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 2, 8),
        TopBar        = Color3.fromRGB(8, 14, 24),
        Toggle_OFF    = Color3.fromRGB(35, 60, 105),
        Toggle_ON     = Color3.fromRGB(147, 197, 253),
    },
    ["Lava"] = {
        Background    = Color3.fromRGB(20, 8, 5),
        Secondary     = Color3.fromRGB(32, 12, 7),
        Tertiary      = Color3.fromRGB(46, 18, 10),
        Accent        = Color3.fromRGB(249, 115, 22),
        AccentDark    = Color3.fromRGB(220, 80, 8),
        AccentLight   = Color3.fromRGB(253, 170, 80),
        Text          = Color3.fromRGB(255, 240, 230),
        SubText       = Color3.fromRGB(180, 130, 100),
        Border        = Color3.fromRGB(110, 45, 18),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(249, 115, 22),
        Shadow        = Color3.fromRGB(5, 0, 0),
        TopBar        = Color3.fromRGB(14, 5, 3),
        Toggle_OFF    = Color3.fromRGB(90, 38, 15),
        Toggle_ON     = Color3.fromRGB(249, 115, 22),
    },
    ["Emerald"] = {
        Background    = Color3.fromRGB(8, 22, 18),
        Secondary     = Color3.fromRGB(12, 34, 28),
        Tertiary      = Color3.fromRGB(16, 46, 38),
        Accent        = Color3.fromRGB(52, 211, 153),
        AccentDark    = Color3.fromRGB(16, 185, 129),
        AccentLight   = Color3.fromRGB(110, 231, 183),
        Text          = Color3.fromRGB(210, 255, 242),
        SubText       = Color3.fromRGB(90, 170, 140),
        Border        = Color3.fromRGB(22, 90, 68),
        Success       = Color3.fromRGB(52, 211, 153),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 5, 3),
        TopBar        = Color3.fromRGB(5, 15, 12),
        Toggle_OFF    = Color3.fromRGB(18, 75, 58),
        Toggle_ON     = Color3.fromRGB(52, 211, 153),
    },
    ["Storm"] = {
        Background    = Color3.fromRGB(15, 15, 20),
        Secondary     = Color3.fromRGB(22, 22, 32),
        Tertiary      = Color3.fromRGB(30, 30, 44),
        Accent        = Color3.fromRGB(148, 163, 184),
        AccentDark    = Color3.fromRGB(100, 116, 139),
        AccentLight   = Color3.fromRGB(203, 213, 225),
        Text          = Color3.fromRGB(240, 242, 246),
        SubText       = Color3.fromRGB(140, 148, 165),
        Border        = Color3.fromRGB(60, 65, 88),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(0, 0, 2),
        TopBar        = Color3.fromRGB(10, 10, 14),
        Toggle_OFF    = Color3.fromRGB(50, 55, 74),
        Toggle_ON     = Color3.fromRGB(148, 163, 184),
    },
    ["Gold"] = {
        Background    = Color3.fromRGB(20, 16, 5),
        Secondary     = Color3.fromRGB(32, 25, 8),
        Tertiary      = Color3.fromRGB(44, 35, 12),
        Accent        = Color3.fromRGB(234, 179, 8),
        AccentDark    = Color3.fromRGB(190, 140, 5),
        AccentLight   = Color3.fromRGB(253, 224, 71),
        Text          = Color3.fromRGB(255, 248, 220),
        SubText       = Color3.fromRGB(175, 148, 80),
        Border        = Color3.fromRGB(110, 85, 18),
        Success       = Color3.fromRGB(34, 197, 94),
        Error         = Color3.fromRGB(239, 68, 68),
        Warning       = Color3.fromRGB(234, 179, 8),
        Shadow        = Color3.fromRGB(5, 3, 0),
        TopBar        = Color3.fromRGB(14, 11, 3),
        Toggle_OFF    = Color3.fromRGB(90, 70, 15),
        Toggle_ON     = Color3.fromRGB(234, 179, 8),
    },
}

-- ══════════════════════════════════════════════════════════
--                    UTILITY FUNCTIONS
-- ══════════════════════════════════════════════════════════
local Utility = {}

function Utility.Tween(instance, properties, duration, easingStyle, easingDirection)
    easingStyle     = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration        = duration or 0.3
    local info      = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween     = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Utility.Create(class, properties, children)
    local instance = Instance.new(class)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

function Utility.RoundedFrame(parent, size, position, color, cornerRadius, name)
    local frame = Utility.Create("Frame", {
        Name            = name or "Frame",
        Size            = size,
        Position        = position,
        BackgroundColor3= color,
        BorderSizePixel = 0,
        ClipsDescendants= true,
        Parent          = parent,
    })
    Utility.Create("UICorner", { CornerRadius = UDim.new(0, cornerRadius or 8) }, {}),
    Utility.Create("UICorner", { CornerRadius = UDim.new(0, cornerRadius or 8), Parent = frame })
    return frame
end

function Utility.AddShadow(parent)
    local shadow = Utility.Create("ImageLabel", {
        Name               = "Shadow",
        AnchorPoint        = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position           = UDim2.new(0.5, 0, 0.5, 4),
        Size               = UDim2.new(1, 30, 1, 30),
        ZIndex             = parent.ZIndex - 1,
        Image              = "rbxassetid://6015897843",
        ImageColor3        = Color3.fromRGB(0, 0, 0),
        ImageTransparency  = 0.5,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(49, 49, 450, 450),
        Parent             = parent,
    })
    return shadow
end

function Utility.MakeDraggable(topbarFrame, mainFrame)
    local dragging    = false
    local dragInput   = nil
    local dragStart   = nil
    local startPos    = nil

    topbarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = mainFrame.Position
        end
    end)

    topbarFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Utility.ReadFile(path)
    if readfile then
        local ok, data = pcall(readfile, path)
        if ok then return data end
    end
    return nil
end

function Utility.WriteFile(path, data)
    if writefile then
        local ok = pcall(writefile, path, data)
        return ok
    end
    return false
end

function Utility.FolderExists(path)
    if isfolder then
        return isfolder(path)
    end
    return false
end

function Utility.MakeFolder(path)
    if makefolder then
        local ok = pcall(makefolder, path)
        return ok
    end
    return false
end

function Utility.CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    end
    return false
end

-- ══════════════════════════════════════════════════════════
--                    NEXUS UI CORE
-- ══════════════════════════════════════════════════════════

function NexusUI:CreateWindow(config)
    config = config or {}

    -- Window configuration
    local windowConfig = {
        Name            = config.Name or "NexusUI",
        SubTitle        = config.SubTitle or "v1.0",
        Size            = config.Size or UDim2.new(0, 620, 0, 480),
        Position        = config.Position or UDim2.new(0.5, -310, 0.5, -240),
        Theme           = config.Theme or "Dark",
        LoadingEnabled  = config.LoadingEnabled ~= false,
        LoadingName     = config.LoadingName or "Welcome Back!!",
        LoadingIcon     = config.LoadingIcon or "rbxassetid://4483345998",
        KeySystem       = config.KeySystem or false,
        KeyName         = config.KeyName or "Key System",
        Key             = config.Key or "nexus2024",
        GetKeyFromSite  = config.GetKeyFromSite or false,
        SiteKey         = config.SiteKey or "https://example.com/getkey",
        KeySave         = config.KeySave ~= false,
        KeyJsonName     = config.KeyJsonName or "NexusKey.json",
        AutoSave        = config.AutoSave ~= false,
        SaveFile        = config.SaveFile or "NexusConfig.json",
        ConfigFolder    = config.ConfigFolder or "NexusUI",
    }

    -- Current theme
    local CurrentTheme = Themes[windowConfig.Theme] or Themes["Dark"]

    -- Window object
    local Window = setmetatable({}, { __index = NexusUI })
    Window._config       = windowConfig
    Window._theme        = CurrentTheme
    Window._tabs         = {}
    Window._activeTab    = nil
    Window._elements     = {}
    Window._saveData     = {}
    Window._minimized    = false
    Window._closed       = false
    Window._themeObjects = {}

    -- Ensure config folder exists
    if not Utility.FolderExists(windowConfig.ConfigFolder) then
        Utility.MakeFolder(windowConfig.ConfigFolder)
    end

    -- ══════════════════════════════════════════════════════
    --                      SCREEN GUI
    -- ══════════════════════════════════════════════════════
    local ScreenGui = Utility.Create("ScreenGui", {
        Name                  = "NexusUI_" .. windowConfig.Name,
        ResetOnSpawn          = false,
        ZIndexBehavior        = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset        = true,
    })

    -- Try to parent to CoreGui, fallback to PlayerGui
    local ok = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ok then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    Window.ScreenGui = ScreenGui

    -- ══════════════════════════════════════════════════════
    --                   LOADING SCREEN
    -- ══════════════════════════════════════════════════════
    local function CreateLoadingScreen()
        local LoadingFrame = Utility.Create("Frame", {
            Name                = "LoadingScreen",
            Size                = UDim2.new(1, 0, 1, 0),
            Position            = UDim2.new(0, 0, 0, 0),
            BackgroundColor3    = CurrentTheme.Background,
            BorderSizePixel     = 0,
            ZIndex              = 100,
            Parent              = ScreenGui,
        })

        local LoadingContainer = Utility.Create("Frame", {
            Name                = "Container",
            AnchorPoint         = Vector2.new(0.5, 0.5),
            Size                = UDim2.new(0, 300, 0, 220),
            Position            = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3    = CurrentTheme.Secondary,
            BorderSizePixel     = 0,
            Parent              = LoadingFrame,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = LoadingContainer })
        Utility.AddShadow(LoadingContainer)

        -- Icon
        local IconLabel = Utility.Create("ImageLabel", {
            Name               = "Icon",
            AnchorPoint        = Vector2.new(0.5, 0),
            Size               = UDim2.new(0, 70, 0, 70),
            Position           = UDim2.new(0.5, 0, 0, 22),
            BackgroundTransparency = 1,
            Image              = windowConfig.LoadingIcon,
            Parent             = LoadingContainer,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = IconLabel })

        -- Title
        Utility.Create("TextLabel", {
            Name               = "Title",
            AnchorPoint        = Vector2.new(0.5, 0),
            Size               = UDim2.new(1, -20, 0, 28),
            Position           = UDim2.new(0.5, 0, 0, 102),
            BackgroundTransparency = 1,
            Text               = windowConfig.LoadingName,
            TextColor3         = CurrentTheme.Text,
            TextSize           = 15,
            Font               = Enum.Font.GothamBold,
            TextXAlignment     = Enum.TextXAlignment.Center,
            Parent             = LoadingContainer,
        })

        -- Subtitle
        Utility.Create("TextLabel", {
            Name               = "Sub",
            AnchorPoint        = Vector2.new(0.5, 0),
            Size               = UDim2.new(1, -20, 0, 20),
            Position           = UDim2.new(0.5, 0, 0, 132),
            BackgroundTransparency = 1,
            Text               = windowConfig.Name .. " " .. windowConfig.SubTitle,
            TextColor3         = CurrentTheme.SubText,
            TextSize           = 12,
            Font               = Enum.Font.Gotham,
            TextXAlignment     = Enum.TextXAlignment.Center,
            Parent             = LoadingContainer,
        })

        -- Progress bar background
        local ProgressBG = Utility.Create("Frame", {
            Name                = "ProgressBG",
            AnchorPoint         = Vector2.new(0.5, 0),
            Size                = UDim2.new(1, -40, 0, 6),
            Position            = UDim2.new(0.5, 0, 0, 168),
            BackgroundColor3    = CurrentTheme.Tertiary,
            BorderSizePixel     = 0,
            Parent              = LoadingContainer,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBG })

        local ProgressBar = Utility.Create("Frame", {
            Name                = "Bar",
            Size                = UDim2.new(0, 0, 1, 0),
            BackgroundColor3    = CurrentTheme.Accent,
            BorderSizePixel     = 0,
            Parent              = ProgressBG,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ProgressBar })

        -- Loading text
        local LoadText = Utility.Create("TextLabel", {
            Name                = "LoadText",
            AnchorPoint         = Vector2.new(0.5, 0),
            Size                = UDim2.new(1, -20, 0, 18),
            Position            = UDim2.new(0.5, 0, 0, 183),
            BackgroundTransparency = 1,
            Text                = "Initializing...",
            TextColor3          = CurrentTheme.SubText,
            TextSize            = 11,
            Font                = Enum.Font.Gotham,
            TextXAlignment      = Enum.TextXAlignment.Center,
            Parent              = LoadingContainer,
        })

        -- Animate loading
        local steps = {
            {text = "Loading modules...",  pct = 0.2},
            {text = "Checking configs...", pct = 0.45},
            {text = "Building UI...",      pct = 0.70},
            {text = "Almost ready...",     pct = 0.90},
            {text = "Done!",               pct = 1.0},
        }

        for _, step in ipairs(steps) do
            LoadText.Text = step.text
            Utility.Tween(ProgressBar, {Size = UDim2.new(step.pct, 0, 1, 0)}, 0.4)
            task.wait(0.35)
        end

        task.wait(0.2)
        Utility.Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
        Utility.Tween(LoadingContainer, {BackgroundTransparency = 1}, 0.5)
        task.wait(0.5)
        LoadingFrame:Destroy()
    end

    -- ══════════════════════════════════════════════════════
    --                    KEY SYSTEM
    -- ══════════════════════════════════════════════════════
    local keyValidated = not windowConfig.KeySystem

    local function CreateKeySystem()
        if not windowConfig.KeySystem then
            keyValidated = true
            return true
        end

        -- Check if key is already saved
        local keyPath = windowConfig.ConfigFolder .. "/" .. windowConfig.KeyJsonName
        if windowConfig.KeySave then
            local savedData = Utility.ReadFile(keyPath)
            if savedData then
                local ok, decoded = pcall(HttpService.JSONDecode, HttpService, savedData)
                if ok and decoded and decoded.key == windowConfig.Key then
                    keyValidated = true
                    return true
                end
            end
        end

        -- Create key system frame
        local KeyFrame = Utility.Create("Frame", {
            Name                = "KeySystem",
            Size                = UDim2.new(1, 0, 1, 0),
            BackgroundColor3    = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.4,
            BorderSizePixel     = 0,
            ZIndex              = 90,
            Parent              = ScreenGui,
        })

        local KeyContainer = Utility.Create("Frame", {
            Name                = "Container",
            AnchorPoint         = Vector2.new(0.5, 0.5),
            Size                = UDim2.new(0, 380, 0, 290),
            Position            = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3    = CurrentTheme.Secondary,
            BorderSizePixel     = 0,
            ZIndex              = 91,
            Parent              = KeyFrame,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = KeyContainer })
        Utility.AddShadow(KeyContainer)

        -- Top bar
        local KeyTopbar = Utility.Create("Frame", {
            Name                = "Topbar",
            Size                = UDim2.new(1, 0, 0, 44),
            BackgroundColor3    = CurrentTheme.TopBar,
            BorderSizePixel     = 0,
            ZIndex              = 92,
            Parent              = KeyContainer,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = KeyTopbar })

        -- Fix bottom corners of topbar
        Utility.Create("Frame", {
            Size                = UDim2.new(1, 0, 0, 14),
            Position            = UDim2.new(0, 0, 1, -14),
            BackgroundColor3    = CurrentTheme.TopBar,
            BorderSizePixel     = 0,
            ZIndex              = 92,
            Parent              = KeyTopbar,
        })

        Utility.Create("TextLabel", {
            Name                = "Title",
            Size                = UDim2.new(1, -20, 1, 0),
            Position            = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text                = "🔑 " .. windowConfig.KeyName,
            TextColor3          = CurrentTheme.Text,
            TextSize            = 14,
            Font                = Enum.Font.GothamBold,
            TextXAlignment      = Enum.TextXAlignment.Left,
            ZIndex              = 93,
            Parent              = KeyTopbar,
        })

        Utility.Create("TextLabel", {
            AnchorPoint         = Vector2.new(0.5, 0),
            Size                = UDim2.new(1, -30, 0, 30),
            Position            = UDim2.new(0.5, 0, 0, 55),
            BackgroundTransparency = 1,
            Text                = "Enter the key to continue.",
            TextColor3          = CurrentTheme.SubText,
            TextSize            = 12,
            Font                = Enum.Font.Gotham,
            TextXAlignment      = Enum.TextXAlignment.Center,
            ZIndex              = 92,
            Parent              = KeyContainer,
        })

        -- Input box
        local InputBG = Utility.Create("Frame", {
            AnchorPoint         = Vector2.new(0.5, 0),
            Size                = UDim2.new(1, -40, 0, 44),
            Position            = UDim2.new(0.5, 0, 0, 95),
            BackgroundColor3    = CurrentTheme.Tertiary,
            BorderSizePixel     = 0,
            ZIndex              = 92,
            Parent              = KeyContainer,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = InputBG })

        local KeyInput = Utility.Create("TextBox", {
            Size                = UDim2.new(1, -16, 1, 0),
            Position            = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            PlaceholderText     = "Enter key here...",
            Text                = "",
            TextColor3          = CurrentTheme.Text,
            PlaceholderColor3   = CurrentTheme.SubText,
            TextSize            = 13,
            Font                = Enum.Font.Gotham,
            ZIndex              = 93,
            ClearTextOnFocus    = false,
            Parent              = InputBG,
        })

        -- Status label
        local StatusLabel = Utility.Create("TextLabel", {
            AnchorPoint         = Vector2.new(0.5, 0),
            Size                = UDim2.new(1, -30, 0, 24),
            Position            = UDim2.new(0.5, 0, 0, 148),
            BackgroundTransparency = 1,
            Text                = "",
            TextColor3          = CurrentTheme.Error,
            TextSize            = 12,
            Font                = Enum.Font.Gotham,
            TextXAlignment      = Enum.TextXAlignment.Center,
            ZIndex              = 92,
            Parent              = KeyContainer,
        })

        -- Buttons area
        local BtnContainer = Utility.Create("Frame", {
            AnchorPoint         = Vector2.new(0.5, 0),
            Size                = UDim2.new(1, -40, 0, 40),
            Position            = UDim2.new(0.5, 0, 0, 178),
            BackgroundTransparency = 1,
            ZIndex              = 92,
            Parent              = KeyContainer,
        })
        Utility.Create("UIListLayout", {
            FillDirection       = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment   = Enum.VerticalAlignment.Center,
            Padding             = UDim.new(0, 10),
            Parent              = BtnContainer,
        })

        -- Submit button
        local SubmitBtn = Utility.Create("TextButton", {
            Size                = UDim2.new(0, 130, 0, 38),
            BackgroundColor3    = CurrentTheme.Accent,
            BorderSizePixel     = 0,
            Text                = "Submit",
            TextColor3          = Color3.fromRGB(255, 255, 255),
            TextSize            = 13,
            Font                = Enum.Font.GothamBold,
            ZIndex              = 93,
            Parent              = BtnContainer,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = SubmitBtn })

        -- GetKey button (if enabled)
        if windowConfig.GetKeyFromSite then
            local GetKeyBtn = Utility.Create("TextButton", {
                Size                = UDim2.new(0, 130, 0, 38),
                BackgroundColor3    = CurrentTheme.Tertiary,
                BorderSizePixel     = 0,
                Text                = "Get Key",
                TextColor3          = CurrentTheme.Text,
                TextSize            = 13,
                Font                = Enum.Font.GothamBold,
                ZIndex              = 93,
                Parent              = BtnContainer,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = GetKeyBtn })

            GetKeyBtn.MouseButton1Click:Connect(function()
                Utility.CopyToClipboard(windowConfig.SiteKey)
                GetKeyBtn.Text = "Copied!"
                task.delay(2, function()
                    GetKeyBtn.Text = "Get Key"
                end)
            end)
        end

        -- Validate function
        local validated = false
        local function ValidateKey()
            local inputKey = KeyInput.Text
            if inputKey == windowConfig.Key then
                StatusLabel.TextColor3 = CurrentTheme.Success
                StatusLabel.Text = "✓ Key accepted!"

                if windowConfig.KeySave then
                    local data = HttpService:JSONEncode({ key = inputKey })
                    Utility.WriteFile(keyPath, data)
                end

                task.wait(0.8)
                Utility.Tween(KeyFrame, {BackgroundTransparency = 1}, 0.4)
                Utility.Tween(KeyContainer, {BackgroundTransparency = 1}, 0.4)
                task.wait(0.45)
                KeyFrame:Destroy()
                validated = true
                keyValidated = true
            else
                StatusLabel.TextColor3 = CurrentTheme.Error
                StatusLabel.Text = "✗ Invalid key. Try again."
                Utility.Tween(KeyInput, {TextColor3 = CurrentTheme.Error}, 0.1)
                task.wait(0.8)
                Utility.Tween(KeyInput, {TextColor3 = CurrentTheme.Text}, 0.3)
            end
        end

        SubmitBtn.MouseButton1Click:Connect(ValidateKey)
        KeyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then ValidateKey() end
        end)

        -- Wait for validation
        repeat task.wait(0.1) until keyValidated
        return true
    end

    -- ══════════════════════════════════════════════════════
    --                   MAIN WINDOW UI
    -- ══════════════════════════════════════════════════════
    local function BuildWindow()
        -- Main frame
        local MainFrame = Utility.Create("Frame", {
            Name                = "MainFrame",
            Size                = windowConfig.Size,
            Position            = windowConfig.Position,
            BackgroundColor3    = CurrentTheme.Background,
            BorderSizePixel     = 0,
            Parent              = ScreenGui,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = MainFrame })
        Utility.AddShadow(MainFrame)

        Window.MainFrame = MainFrame

        -- Topbar
        local TopBar = Utility.Create("Frame", {
            Name                = "TopBar",
            Size                = UDim2.new(1, 0, 0, 46),
            BackgroundColor3    = CurrentTheme.TopBar,
            BorderSizePixel     = 0,
            Parent              = MainFrame,
        })
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = TopBar })
        Utility.Create("Frame", {
            Size                = UDim2.new(1, 0, 0, 12),
            Position            = UDim2.new(0, 0, 1, -12),
            BackgroundColor3    = CurrentTheme.TopBar,
            BorderSizePixel     = 0,
            Parent              = TopBar,
        })

        Window.TopBar = TopBar
        table.insert(Window._themeObjects, {obj = TopBar, prop = "BackgroundColor3", key = "TopBar"})

        -- Title
        local TitleLabel = Utility.Create("TextLabel", {
            Name                = "Title",
            Size                = UDim2.new(0, 200, 1, 0),
            Position            = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text                = windowConfig.Name,
            TextColor3          = CurrentTheme.Text,
            TextSize            = 14,
            Font                = Enum.Font.GothamBold,
            TextXAlignment      = Enum.TextXAlignment.Left,
            Parent              = TopBar,
        })
        table.insert(Window._themeObjects, {obj = TitleLabel, prop = "TextColor3", key = "Text"})

        local SubTitleLabel = Utility.Create("TextLabel", {
            Name                = "SubTitle",
            Size                = UDim2.new(0, 200, 1, 0),
            Position            = UDim2.new(0, 14 + TitleLabel.TextBounds.X + 8, 0, 0),
            BackgroundTransparency = 1,
            Text                = windowConfig.SubTitle,
            TextColor3          = CurrentTheme.SubText,
            TextSize            = 12,
            Font                = Enum.Font.Gotham,
            TextXAlignment      = Enum.TextXAlignment.Left,
            Parent              = TopBar,
        })
        table.insert(Window._themeObjects, {obj = SubTitleLabel, prop = "TextColor3", key = "SubText"})

        -- Topbar Buttons (right side)
        local BtnHolder = Utility.Create("Frame", {
            Name                = "BtnHolder",
            AnchorPoint         = Vector2.new(1, 0.5),
            Size                = UDim2.new(0, 105, 0, 28),
            Position            = UDim2.new(1, -12, 0.5, 0),
            BackgroundTransparency = 1,
            Parent              = TopBar,
        })
        Utility.Create("UIListLayout", {
            FillDirection       = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment   = Enum.VerticalAlignment.Center,
            Padding             = UDim.new(0, 6),
            Parent              = BtnHolder,
        })

        local function CreateTopBtn(icon, color)
            local btn = Utility.Create("TextButton", {
                Size                = UDim2.new(0, 28, 0, 28),
                BackgroundColor3    = CurrentTheme.Tertiary,
                BorderSizePixel     = 0,
                Text                = icon,
                TextColor3          = color or CurrentTheme.SubText,
                TextSize            = 14,
                Font                = Enum.Font.GothamBold,
                Parent              = BtnHolder,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
            btn.MouseEnter:Connect(function()
                Utility.Tween(btn, {BackgroundColor3 = CurrentTheme.Border}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Utility.Tween(btn, {BackgroundColor3 = CurrentTheme.Tertiary}, 0.15)
            end)
            return btn
        end

        local ResizeBtn   = CreateTopBtn("⤡", CurrentTheme.SubText)
        local MinimizeBtn = CreateTopBtn("−", CurrentTheme.Warning)
        local CloseBtn    = CreateTopBtn("×", CurrentTheme.Error)

        -- Resize functionality
        local resizing    = false
        local resizeStart = nil
        local origSize    = nil

        ResizeBtn.MouseButton1Down:Connect(function()
            resizing    = true
            resizeStart = UserInputService:GetMouseLocation()
            origSize    = MainFrame.Size
        end)

        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if resizing then
                local mousePos = UserInputService:GetMouseLocation()
                local delta    = mousePos - resizeStart
                local newW     = math.max(480, origSize.X.Offset + delta.X)
                local newH     = math.max(360, origSize.Y.Offset + delta.Y)
                MainFrame.Size = UDim2.new(0, newW, 0, newH)
            end
        end)

        -- Minimize functionality
        local originalHeight = windowConfig.Size.Y.Offset
        MinimizeBtn.MouseButton1Click:Connect(function()
            Window._minimized = not Window._minimized
            if Window._minimized then
                Utility.Tween(MainFrame, {Size = UDim2.new(0, windowConfig.Size.X.Offset, 0, 46)}, 0.35)
                MinimizeBtn.Text = "+"
            else
                Utility.Tween(MainFrame, {Size = windowConfig.Size}, 0.35)
                MinimizeBtn.Text = "−"
            end
        end)

        -- Close modal
        CloseBtn.MouseButton1Click:Connect(function()
            local ModalBG = Utility.Create("Frame", {
                Name                = "ModalBG",
                Size                = UDim2.new(1, 0, 1, 0),
                BackgroundColor3    = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.5,
                ZIndex              = 150,
                Parent              = ScreenGui,
            })
            local Modal = Utility.Create("Frame", {
                Name                = "Modal",
                AnchorPoint         = Vector2.new(0.5, 0.5),
                Size                = UDim2.new(0, 280, 0, 160),
                Position            = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundColor3    = CurrentTheme.Secondary,
                BorderSizePixel     = 0,
                ZIndex              = 151,
                Parent              = ModalBG,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Modal })
            Utility.AddShadow(Modal)

            Utility.Create("TextLabel", {
                AnchorPoint         = Vector2.new(0.5, 0),
                Size                = UDim2.new(1, -20, 0, 30),
                Position            = UDim2.new(0.5, 0, 0, 22),
                BackgroundTransparency = 1,
                Text                = "Close " .. windowConfig.Name .. "?",
                TextColor3          = CurrentTheme.Text,
                TextSize            = 14,
                Font                = Enum.Font.GothamBold,
                TextXAlignment      = Enum.TextXAlignment.Center,
                ZIndex              = 152,
                Parent              = Modal,
            })

            Utility.Create("TextLabel", {
                AnchorPoint         = Vector2.new(0.5, 0),
                Size                = UDim2.new(1, -20, 0, 24),
                Position            = UDim2.new(0.5, 0, 0, 55),
                BackgroundTransparency = 1,
                Text                = "Are you sure you want to close the UI?",
                TextColor3          = CurrentTheme.SubText,
                TextSize            = 12,
                Font                = Enum.Font.Gotham,
                TextXAlignment      = Enum.TextXAlignment.Center,
                ZIndex              = 152,
                Parent              = Modal,
            })

            local ModalBtnHolder = Utility.Create("Frame", {
                AnchorPoint         = Vector2.new(0.5, 1),
                Size                = UDim2.new(1, -30, 0, 40),
                Position            = UDim2.new(0.5, 0, 1, -16),
                BackgroundTransparency = 1,
                ZIndex              = 152,
                Parent              = Modal,
            })
            Utility.Create("UIListLayout", {
                FillDirection       = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment   = Enum.VerticalAlignment.Center,
                Padding             = UDim.new(0, 12),
                Parent              = ModalBtnHolder,
            })

            local CancelBtn = Utility.Create("TextButton", {
                Size                = UDim2.new(0, 100, 0, 36),
                BackgroundColor3    = CurrentTheme.Tertiary,
                BorderSizePixel     = 0,
                Text                = "Cancel",
                TextColor3          = CurrentTheme.Text,
                TextSize            = 13,
                Font                = Enum.Font.GothamBold,
                ZIndex              = 153,
                Parent              = ModalBtnHolder,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = CancelBtn })

            local YesBtn = Utility.Create("TextButton", {
                Size                = UDim2.new(0, 100, 0, 36),
                BackgroundColor3    = CurrentTheme.Error,
                BorderSizePixel     = 0,
                Text                = "Yes",
                TextColor3          = Color3.fromRGB(255, 255, 255),
                TextSize            = 13,
                Font                = Enum.Font.GothamBold,
                ZIndex              = 153,
                Parent              = ModalBtnHolder,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = YesBtn })

            CancelBtn.MouseButton1Click:Connect(function()
                Utility.Tween(ModalBG, {BackgroundTransparency = 1}, 0.25)
                task.wait(0.25)
                ModalBG:Destroy()
            end)

            YesBtn.MouseButton1Click:Connect(function()
                Window:SaveConfig()
                Utility.Tween(MainFrame, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                ScreenGui:Destroy()
            end)
        end)

        -- Make draggable
        Utility.MakeDraggable(TopBar, MainFrame)

        -- Content area
        local ContentFrame = Utility.Create("Frame", {
            Name                = "Content",
            Size                = UDim2.new(1, 0, 1, -46),
            Position            = UDim2.new(0, 0, 0, 46),
            BackgroundTransparency = 1,
            Parent              = MainFrame,
        })

        -- Tab bar (left side)
        local TabBar = Utility.Create("Frame", {
            Name                = "TabBar",
            Size                = UDim2.new(0, 155, 1, 0),
            BackgroundColor3    = CurrentTheme.Secondary,
            BorderSizePixel     = 0,
            Parent              = ContentFrame,
        })
        Utility.Create("Frame", {
            Size                = UDim2.new(0, 12, 1, 0),
            BackgroundColor3    = CurrentTheme.Secondary,
            BorderSizePixel     = 0,
            Parent              = TabBar,
        })
        table.insert(Window._themeObjects, {obj = TabBar, prop = "BackgroundColor3", key = "Secondary"})

        local TabList = Utility.Create("Frame", {
            Name                = "TabList",
            Size                = UDim2.new(1, -12, 1, -12),
            Position            = UDim2.new(0, 6, 0, 6),
            BackgroundTransparency = 1,
            Parent              = TabBar,
        })
        Utility.Create("UIListLayout", {
            FillDirection       = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder           = Enum.SortOrder.LayoutOrder,
            Padding             = UDim.new(0, 4),
            Parent              = TabList,
        })

        -- Tab content area
        local TabContentArea = Utility.Create("Frame", {
            Name                = "TabContentArea",
            Size                = UDim2.new(1, -155, 1, 0),
            Position            = UDim2.new(0, 155, 0, 0),
            BackgroundColor3    = CurrentTheme.Background,
            BorderSizePixel     = 0,
            ClipsDescendants    = true,
            Parent              = ContentFrame,
        })
        -- rounded right side
        local TabRight = Utility.Create("Frame", {
            Size                = UDim2.new(0, 12, 1, 0),
            Position            = UDim2.new(0, 0, 0, 0),
            BackgroundColor3    = CurrentTheme.Background,
            BorderSizePixel     = 0,
            Parent              = TabContentArea,
        })
        table.insert(Window._themeObjects, {obj = TabContentArea, prop = "BackgroundColor3", key = "Background"})
        table.insert(Window._themeObjects, {obj = TabRight,       prop = "BackgroundColor3", key = "Background"})
        table.insert(Window._themeObjects, {obj = MainFrame,      prop = "BackgroundColor3", key = "Background"})

        Window.TabList         = TabList
        Window.TabContentArea  = TabContentArea

        -- ══════════════════════════════════════════════════
        --                  AUTO SAVE/LOAD
        -- ══════════════════════════════════════════════════
        local savePath = windowConfig.ConfigFolder .. "/" .. windowConfig.SaveFile

        function Window:SaveConfig()
            if not windowConfig.AutoSave then return end
            local data = {}
            for id, elem in pairs(self._elements) do
                if elem.type == "Toggle" then
                    data[id] = { type = "Toggle", value = elem.value }
                elseif elem.type == "Slider" then
                    data[id] = { type = "Slider", value = elem.value }
                elseif elem.type == "Textbox" then
                    data[id] = { type = "Textbox", value = elem.value }
                elseif elem.type == "Dropdown" then
                    data[id] = { type = "Dropdown", value = elem.value }
                elseif elem.type == "Keybind" then
                    data[id] = { type = "Keybind", value = elem.value and elem.value.Name or nil }
                elseif elem.type == "ColorPicker" then
                    data[id] = { type = "ColorPicker", r = elem.value.R, g = elem.value.G, b = elem.value.B }
                end
            end
            local encoded = HttpService:JSONEncode(data)
            Utility.WriteFile(savePath, encoded)
        end

        function Window:LoadConfig()
            if not windowConfig.AutoSave then return end
            if not keyValidated then return end
            local raw = Utility.ReadFile(savePath)
            if not raw then return end
            local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
            if not ok or type(data) ~= "table" then return end
            for id, saved in pairs(data) do
                local elem = self._elements[id]
                if elem then
                    if saved.type == "Toggle" and elem.SetValue then
                        elem:SetValue(saved.value)
                    elseif saved.type == "Slider" and elem.SetValue then
                        elem:SetValue(saved.value)
                    elseif saved.type == "Textbox" and elem.SetValue then
                        elem:SetValue(saved.value)
                    elseif saved.type == "Dropdown" and elem.SetValue then
                        elem:SetValue(saved.value)
                    elseif saved.type == "Keybind" and elem.SetValue and saved.value then
                        local kb = Enum.KeyCode[saved.value]
                        if kb then elem:SetValue(kb) end
                    elseif saved.type == "ColorPicker" and elem.SetValue then
                        elem:SetValue(Color3.new(saved.r, saved.g, saved.b))
                    end
                end
            end
        end

        -- Auto-save loop
        if windowConfig.AutoSave then
            task.spawn(function()
                while ScreenGui.Parent do
                    task.wait(10)
                    Window:SaveConfig()
                end
            end)
        end

        -- ══════════════════════════════════════════════════
        --                 THEME APPLIER
        -- ══════════════════════════════════════════════════
        function Window:ApplyTheme(themeName)
            local theme = Themes[themeName]
            if not theme then return end
            CurrentTheme     = theme
            Window._theme    = theme

            for _, entry in ipairs(self._themeObjects) do
                if entry.obj and entry.obj.Parent then
                    Utility.Tween(entry.obj, { [entry.prop] = theme[entry.key] }, 0.25)
                end
            end
        end

        -- ══════════════════════════════════════════════════
        --                   ADD TAB
        -- ══════════════════════════════════════════════════
        function Window:AddTab(tabConfig)
            tabConfig = tabConfig or {}
            local tabName = tabConfig.Name or ("Tab " .. (#self._tabs + 1))
            local tabIcon = tabConfig.Icon or "☰"

            local Tab = {}
            Tab.Name      = tabName
            Tab._sections = {}
            Tab._window   = self

            -- Tab button
            local TabBtn = Utility.Create("TextButton", {
                Name                = tabName .. "Btn",
                Size                = UDim2.new(1, -8, 0, 36),
                BackgroundColor3    = CurrentTheme.Tertiary,
                BackgroundTransparency = 1,
                BorderSizePixel     = 0,
                Text                = "",
                LayoutOrder         = #self._tabs + 1,
                Parent              = TabList,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabBtn })

            local TabBtnLayout = Utility.Create("Frame", {
                Size                = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent              = TabBtn,
            })
            Utility.Create("UIListLayout", {
                FillDirection       = Enum.FillDirection.Horizontal,
                VerticalAlignment   = Enum.VerticalAlignment.Center,
                Padding             = UDim.new(0, 8),
                Parent              = TabBtnLayout,
            })
            Utility.Create("UIPadding", {
                PaddingLeft         = UDim.new(0, 10),
                Parent              = TabBtnLayout,
            })

            local TabIcon = Utility.Create("TextLabel", {
                Size                = UDim2.new(0, 20, 1, 0),
                BackgroundTransparency = 1,
                Text                = tabIcon,
                TextColor3          = CurrentTheme.SubText,
                TextSize            = 14,
                Font                = Enum.Font.GothamBold,
                Parent              = TabBtnLayout,
            })
            local TabLabel = Utility.Create("TextLabel", {
                Size                = UDim2.new(1, -38, 1, 0),
                BackgroundTransparency = 1,
                Text                = tabName,
                TextColor3          = CurrentTheme.SubText,
                TextSize            = 13,
                Font                = Enum.Font.Gotham,
                TextXAlignment      = Enum.TextXAlignment.Left,
                Parent              = TabBtnLayout,
            })

            -- Active indicator
            local ActiveBar = Utility.Create("Frame", {
                Name                = "ActiveBar",
                AnchorPoint         = Vector2.new(0, 0.5),
                Size                = UDim2.new(0, 3, 0, 20),
                Position            = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3    = CurrentTheme.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel     = 0,
                Parent              = TabBtn,
            })
            Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ActiveBar })

            -- Tab content frame (scrolling)
            local TabContent = Utility.Create("ScrollingFrame", {
                Name                    = tabName .. "Content",
                Size                    = UDim2.new(1, -10, 1, -10),
                Position                = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency  = 1,
                BorderSizePixel         = 0,
                ScrollBarThickness      = 4,
                ScrollBarImageColor3    = CurrentTheme.Border,
                CanvasSize              = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize     = Enum.AutomaticSize.Y,
                Visible                 = false,
                Parent                  = TabContentArea,
            })
            Utility.Create("UIListLayout", {
                FillDirection           = Enum.FillDirection.Vertical,
                HorizontalAlignment     = Enum.HorizontalAlignment.Center,
                SortOrder               = Enum.SortOrder.LayoutOrder,
                Padding                 = UDim.new(0, 8),
                Parent                  = TabContent,
            })
            Utility.Create("UIPadding", {
                PaddingTop              = UDim.new(0, 6),
                PaddingBottom           = UDim.new(0, 6),
                Parent                  = TabContent,
            })

            Tab.Content = TabContent
            Tab.Button  = TabBtn

            local function SelectTab()
                -- Deselect all
                for _, t in ipairs(Window._tabs) do
                    t.Content.Visible = false
                    Utility.Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                    t.Button:FindFirstChild("ActiveBar", true).BackgroundTransparency = 1
                    local tbl = t.Button:FindFirstChild("TabBtnLayout")
                    if tbl then
                        for _, lbl in ipairs(tbl:GetChildren()) do
                            if lbl:IsA("TextLabel") then
                                Utility.Tween(lbl, {TextColor3 = CurrentTheme.SubText}, 0.2)
                            end
                        end
                    end
                end

                -- Select this
                TabContent.Visible = true
                Utility.Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = CurrentTheme.Tertiary}, 0.2)
                ActiveBar.BackgroundTransparency = 0
                Utility.Tween(TabIcon,  {TextColor3 = CurrentTheme.Accent}, 0.2)
                Utility.Tween(TabLabel, {TextColor3 = CurrentTheme.Text,   Font = Enum.Font.GothamBold}, 0.2)
                Window._activeTab = Tab
            end

            TabBtn.MouseButton1Click:Connect(SelectTab)

            -- Select first tab automatically
            if #self._tabs == 0 then
                task.defer(SelectTab)
            end

            table.insert(self._tabs, Tab)

            -- ══════════════════════════════════════════════
            --               ADD SECTION
            -- ══════════════════════════════════════════════
            function Tab:AddSection(sectionConfig)
                sectionConfig = sectionConfig or {}
                local sectionName = sectionConfig.Name or "Section"

                local Section = {}
                Section._tab     = self
                Section._window  = self._window
                Section._items   = {}

                local SectionFrame = Utility.Create("Frame", {
                    Name                = sectionName .. "Section",
                    Size                = UDim2.new(1, -16, 0, 0),
                    AutomaticSize       = Enum.AutomaticSize.Y,
                    BackgroundColor3    = CurrentTheme.Secondary,
                    BorderSizePixel     = 0,
                    LayoutOrder         = #Tab._sections + 1,
                    Parent              = TabContent,
                })
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = SectionFrame })
                table.insert(Window._themeObjects, {obj = SectionFrame, prop = "BackgroundColor3", key = "Secondary"})

                -- Section header
                local SectionHeader = Utility.Create("Frame", {
                    Name                = "Header",
                    Size                = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    Parent              = SectionFrame,
                })
                Utility.Create("TextLabel", {
                    Size                = UDim2.new(1, -16, 1, 0),
                    Position            = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text                = sectionName,
                    TextColor3          = CurrentTheme.SubText,
                    TextSize            = 11,
                    Font                = Enum.Font.GothamBold,
                    TextXAlignment      = Enum.TextXAlignment.Left,
                    Parent              = SectionHeader,
                })

                -- Divider
                Utility.Create("Frame", {
                    Size                = UDim2.new(1, -24, 0, 1),
                    Position            = UDim2.new(0, 12, 0, 33),
                    BackgroundColor3    = CurrentTheme.Border,
                    BorderSizePixel     = 0,
                    Parent              = SectionFrame,
                })

                -- Items list
                local ItemList = Utility.Create("Frame", {
                    Name                = "Items",
                    Size                = UDim2.new(1, 0, 0, 0),
                    Position            = UDim2.new(0, 0, 0, 36),
                    AutomaticSize       = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Parent              = SectionFrame,
                })
                Utility.Create("UIListLayout", {
                    FillDirection       = Enum.FillDirection.Vertical,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder           = Enum.SortOrder.LayoutOrder,
                    Padding             = UDim.new(0, 0),
                    Parent              = ItemList,
                })
                Utility.Create("UIPadding", {
                    PaddingBottom       = UDim.new(0, 8),
                    Parent              = ItemList,
                })

                Section.ItemList    = ItemList
                Section.SectionFrame = SectionFrame

                -- ══════════════════════════════════════════
                --                 LABEL
                -- ══════════════════════════════════════════
                function Section:AddLabel(labelConfig)
                    labelConfig = labelConfig or {}
                    local text  = labelConfig.Text or "Label"

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 34),
                        BackgroundTransparency = 1,
                        LayoutOrder         = #self._items + 1,
                        Parent              = self.ItemList,
                    })

                    local LabelEl = Utility.Create("TextLabel", {
                        Size                = UDim2.new(1, -16, 1, 0),
                        Position            = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.SubText,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        TextWrapped         = true,
                        Parent              = Item,
                    })
                    table.insert(Window._themeObjects, {obj = LabelEl, prop = "TextColor3", key = "SubText"})

                    local LabelObj = {}
                    function LabelObj:SetText(newText) LabelEl.Text = newText end
                    table.insert(self._items, LabelObj)
                    return LabelObj
                end

                -- ══════════════════════════════════════════
                --                 BUTTON
                -- ══════════════════════════════════════════
                function Section:AddButton(btnConfig)
                    btnConfig = btnConfig or {}
                    local text     = btnConfig.Name or "Button"
                    local callback = btnConfig.Callback or function() end

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 36),
                        BackgroundTransparency = 1,
                        LayoutOrder         = #self._items + 1,
                        Parent              = self.ItemList,
                    })

                    local Btn = Utility.Create("TextButton", {
                        AnchorPoint         = Vector2.new(0.5, 0.5),
                        Size                = UDim2.new(1, 0, 0, 30),
                        Position            = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundColor3    = CurrentTheme.Accent,
                        BorderSizePixel     = 0,
                        Text                = text,
                        TextColor3          = Color3.fromRGB(255, 255, 255),
                        TextSize            = 13,
                        Font                = Enum.Font.GothamBold,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
                    table.insert(Window._themeObjects, {obj = Btn, prop = "BackgroundColor3", key = "Accent"})

                    Btn.MouseEnter:Connect(function()
                        Utility.Tween(Btn, {BackgroundColor3 = CurrentTheme.AccentLight}, 0.15)
                    end)
                    Btn.MouseLeave:Connect(function()
                        Utility.Tween(Btn, {BackgroundColor3 = CurrentTheme.Accent}, 0.15)
                    end)
                    Btn.MouseButton1Click:Connect(function()
                        Utility.Tween(Btn, {BackgroundColor3 = CurrentTheme.AccentDark}, 0.1)
                        task.delay(0.1, function()
                            Utility.Tween(Btn, {BackgroundColor3 = CurrentTheme.Accent}, 0.1)
                        end)
                        callback()
                    end)

                    local BtnObj = { type = "Button" }
                    function BtnObj:SetText(t) Btn.Text = t end
                    table.insert(self._items, BtnObj)
                    return BtnObj
                end

                -- ══════════════════════════════════════════
                --                 TOGGLE
                -- ══════════════════════════════════════════
                function Section:AddToggle(toggleConfig)
                    toggleConfig = toggleConfig or {}
                    local id       = toggleConfig.Name or ("Toggle_" .. #Window._elements)
                    local text     = toggleConfig.Name or "Toggle"
                    local default  = toggleConfig.Default or false
                    local callback = toggleConfig.Callback or function() end

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 40),
                        BackgroundTransparency = 1,
                        LayoutOrder         = #self._items + 1,
                        Parent              = self.ItemList,
                    })

                    Utility.Create("TextLabel", {
                        Size                = UDim2.new(1, -62, 1, 0),
                        Position            = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        Parent              = Item,
                    })

                    local ToggleBG = Utility.Create("Frame", {
                        AnchorPoint         = Vector2.new(1, 0.5),
                        Size                = UDim2.new(0, 44, 0, 22),
                        Position            = UDim2.new(1, -8, 0.5, 0),
                        BackgroundColor3    = default and CurrentTheme.Toggle_ON or CurrentTheme.Toggle_OFF,
                        BorderSizePixel     = 0,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleBG })

                    local ToggleCircle = Utility.Create("Frame", {
                        AnchorPoint         = Vector2.new(0, 0.5),
                        Size                = UDim2.new(0, 16, 0, 16),
                        Position            = default and UDim2.new(0, 25, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                        BackgroundColor3    = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel     = 0,
                        Parent              = ToggleBG,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleCircle })

                    local ToggleObj = { type = "Toggle", value = default }

                    local function SetToggle(val)
                        ToggleObj.value = val
                        if val then
                            Utility.Tween(ToggleBG,     {BackgroundColor3 = CurrentTheme.Toggle_ON}, 0.2)
                            Utility.Tween(ToggleCircle, {Position = UDim2.new(0, 25, 0.5, 0)},       0.2)
                        else
                            Utility.Tween(ToggleBG,     {BackgroundColor3 = CurrentTheme.Toggle_OFF}, 0.2)
                            Utility.Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, 0)},        0.2)
                        end
                        callback(val)
                        Window:SaveConfig()
                    end

                    function ToggleObj:SetValue(val) SetToggle(val) end

                    local ClickArea = Utility.Create("TextButton", {
                        Size                = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text                = "",
                        Parent              = Item,
                    })
                    ClickArea.MouseButton1Click:Connect(function()
                        SetToggle(not ToggleObj.value)
                    end)

                    Window._elements[id] = ToggleObj
                    table.insert(self._items, ToggleObj)
                    return ToggleObj
                end

                -- ══════════════════════════════════════════
                --                 SLIDER
                -- ══════════════════════════════════════════
                function Section:AddSlider(sliderConfig)
                    sliderConfig = sliderConfig or {}
                    local id       = sliderConfig.Name or ("Slider_" .. #Window._elements)
                    local text     = sliderConfig.Name or "Slider"
                    local min      = sliderConfig.Min or 0
                    local max      = sliderConfig.Max or 100
                    local default  = sliderConfig.Default or min
                    local suffix   = sliderConfig.Suffix or ""
                    local callback = sliderConfig.Callback or function() end

                    default = math.clamp(default, min, max)

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 52),
                        BackgroundTransparency = 1,
                        LayoutOrder         = #self._items + 1,
                        Parent              = self.ItemList,
                    })

                    local TopRow = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 24),
                        Position            = UDim2.new(0, 8, 0, 4),
                        BackgroundTransparency = 1,
                        Parent              = Item,
                    })

                    Utility.Create("TextLabel", {
                        Size                = UDim2.new(0.7, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        Parent              = TopRow,
                    })

                    local ValLabel = Utility.Create("TextLabel", {
                        AnchorPoint         = Vector2.new(1, 0),
                        Size                = UDim2.new(0.3, 0, 1, 0),
                        Position            = UDim2.new(1, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = tostring(default) .. suffix,
                        TextColor3          = CurrentTheme.Accent,
                        TextSize            = 13,
                        Font                = Enum.Font.GothamBold,
                        TextXAlignment      = Enum.TextXAlignment.Right,
                        Parent              = TopRow,
                    })

                    local SliderBG = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 8),
                        Position            = UDim2.new(0, 8, 0, 34),
                        BackgroundColor3    = CurrentTheme.Tertiary,
                        BorderSizePixel     = 0,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderBG })

                    local pct = (default - min) / (max - min)
                    local SliderFill = Utility.Create("Frame", {
                        Size                = UDim2.new(pct, 0, 1, 0),
                        BackgroundColor3    = CurrentTheme.Accent,
                        BorderSizePixel     = 0,
                        Parent              = SliderBG,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })

                    local SliderKnob = Utility.Create("Frame", {
                        AnchorPoint         = Vector2.new(0.5, 0.5),
                        Size                = UDim2.new(0, 16, 0, 16),
                        Position            = UDim2.new(pct, 0, 0.5, 0),
                        BackgroundColor3    = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel     = 0,
                        ZIndex              = 2,
                        Parent              = SliderBG,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderKnob })

                    local SliderObj = { type = "Slider", value = default }
                    local dragging  = false

                    local function UpdateSlider(inputX)
                        local absPos = SliderBG.AbsolutePosition.X
                        local absSize = SliderBG.AbsoluteSize.X
                        local ratio   = math.clamp((inputX - absPos) / absSize, 0, 1)
                        local value   = math.floor(min + (max - min) * ratio)
                        SliderObj.value = value
                        ValLabel.Text   = tostring(value) .. suffix
                        Utility.Tween(SliderFill, {Size = UDim2.new(ratio, 0, 1, 0)}, 0.07)
                        Utility.Tween(SliderKnob, {Position = UDim2.new(ratio, 0, 0.5, 0)}, 0.07)
                        callback(value)
                        Window:SaveConfig()
                    end

                    function SliderObj:SetValue(val)
                        val           = math.clamp(val, min, max)
                        local ratio   = (val - min) / (max - min)
                        SliderObj.value = val
                        ValLabel.Text  = tostring(val) .. suffix
                        Utility.Tween(SliderFill, {Size = UDim2.new(ratio, 0, 1, 0)}, 0.15)
                        Utility.Tween(SliderKnob, {Position = UDim2.new(ratio, 0, 0.5, 0)}, 0.15)
                    end

                    SliderBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            UpdateSlider(input.Position.X)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(input.Position.X)
                        end
                    end)

                    Window._elements[id] = SliderObj
                    table.insert(self._items, SliderObj)
                    return SliderObj
                end

                -- ══════════════════════════════════════════
                --               DROPDOWN
                -- ══════════════════════════════════════════
                function Section:AddDropdown(ddConfig)
                    ddConfig   = ddConfig or {}
                    local id   = ddConfig.Name or ("DD_" .. #Window._elements)
                    local text = ddConfig.Name or "Dropdown"
                    local opts = ddConfig.Options or {}
                    local def  = ddConfig.Default or (opts[1] or "")
                    local callback = ddConfig.Callback or function() end

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 52),
                        BackgroundTransparency = 1,
                        ClipsDescendants    = false,
                        LayoutOrder         = #self._items + 1,
                        ZIndex              = 5,
                        Parent              = self.ItemList,
                    })

                    Utility.Create("TextLabel", {
                        Size                = UDim2.new(1, -16, 0, 20),
                        Position            = UDim2.new(0, 8, 0, 2),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        ZIndex              = 5,
                        Parent              = Item,
                    })

                    local DropBG = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 30),
                        Position            = UDim2.new(0, 8, 0, 22),
                        BackgroundColor3    = CurrentTheme.Tertiary,
                        BorderSizePixel     = 0,
                        ZIndex              = 5,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = DropBG })

                    local SelectedLabel = Utility.Create("TextLabel", {
                        Size                = UDim2.new(1, -30, 1, 0),
                        Position            = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = def,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 12,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        ZIndex              = 6,
                        Parent              = DropBG,
                    })

                    local Arrow = Utility.Create("TextLabel", {
                        AnchorPoint         = Vector2.new(1, 0.5),
                        Size                = UDim2.new(0, 20, 1, 0),
                        Position            = UDim2.new(1, -8, 0.5, 0),
                        BackgroundTransparency = 1,
                        Text                = "▾",
                        TextColor3          = CurrentTheme.SubText,
                        TextSize            = 14,
                        Font                = Enum.Font.GothamBold,
                        ZIndex              = 6,
                        Parent              = DropBG,
                    })

                    -- Dropdown list
                    local ListFrame = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 0),
                        Position            = UDim2.new(0, 8, 0, 54),
                        BackgroundColor3    = CurrentTheme.Tertiary,
                        BorderSizePixel     = 0,
                        ClipsDescendants    = true,
                        ZIndex              = 10,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ListFrame })

                    local ListInner = Utility.Create("Frame", {
                        Size                = UDim2.new(1, 0, 0, 0),
                        AutomaticSize       = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        ZIndex              = 10,
                        Parent              = ListFrame,
                    })
                    Utility.Create("UIListLayout", {
                        FillDirection       = Enum.FillDirection.Vertical,
                        SortOrder           = Enum.SortOrder.LayoutOrder,
                        Padding             = UDim.new(0, 0),
                        Parent              = ListInner,
                    })

                    local isOpen = false
                    local DDObj  = { type = "Dropdown", value = def }

                    local function SetSelected(opt)
                        DDObj.value         = opt
                        SelectedLabel.Text  = opt
                        callback(opt)
                        Window:SaveConfig()
                    end

                    local function PopulateList()
                        for _, child in ipairs(ListInner:GetChildren()) do
                            if child:IsA("Frame") or child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        for i, opt in ipairs(opts) do
                            local OptBtn = Utility.Create("TextButton", {
                                Size                = UDim2.new(1, 0, 0, 28),
                                BackgroundColor3    = CurrentTheme.Tertiary,
                                BackgroundTransparency = opt == DDObj.value and 0 or 1,
                                BorderSizePixel     = 0,
                                Text                = opt,
                                TextColor3          = opt == DDObj.value and CurrentTheme.Accent or CurrentTheme.Text,
                                TextSize            = 12,
                                Font                = opt == DDObj.value and Enum.Font.GothamBold or Enum.Font.Gotham,
                                LayoutOrder         = i,
                                ZIndex              = 11,
                                Parent              = ListInner,
                            })
                            OptBtn.MouseButton1Click:Connect(function()
                                SetSelected(opt)
                                isOpen = false
                                Utility.Tween(ListFrame, {Size = UDim2.new(1, -16, 0, 0)}, 0.2)
                                Utility.Tween(Arrow, {Rotation = 0}, 0.2)
                                Item.Size = UDim2.new(1, -16, 0, 52)
                            end)
                        end
                    end

                    PopulateList()

                    local ClickBtn = Utility.Create("TextButton", {
                        Size                = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text                = "",
                        ZIndex              = 7,
                        Parent              = DropBG,
                    })
                    ClickBtn.MouseButton1Click:Connect(function()
                        isOpen = not isOpen
                        local listHeight = math.min(#opts * 28, 140)
                        if isOpen then
                            PopulateList()
                            Utility.Tween(ListFrame, {Size = UDim2.new(1, -16, 0, listHeight)}, 0.25)
                            Utility.Tween(Arrow, {Rotation = 180}, 0.2)
                            Item.Size = UDim2.new(1, -16, 0, 52 + listHeight + 4)
                        else
                            Utility.Tween(ListFrame, {Size = UDim2.new(1, -16, 0, 0)}, 0.2)
                            Utility.Tween(Arrow, {Rotation = 0}, 0.2)
                            Item.Size = UDim2.new(1, -16, 0, 52)
                        end
                    end)

                    function DDObj:SetValue(val)
                        if table.find(opts, val) then SetSelected(val) end
                    end
                    function DDObj:SetOptions(newOpts)
                        opts = newOpts
                        PopulateList()
                    end

                    Window._elements[id] = DDObj
                    table.insert(self._items, DDObj)
                    return DDObj
                end

                -- ══════════════════════════════════════════
                --               TEXTBOX
                -- ══════════════════════════════════════════
                function Section:AddTextbox(tbConfig)
                    tbConfig = tbConfig or {}
                    local id         = tbConfig.Name or ("TB_" .. #Window._elements)
                    local text       = tbConfig.Name or "Textbox"
                    local placeholder= tbConfig.Placeholder or "Enter text..."
                    local default    = tbConfig.Default or ""
                    local callback   = tbConfig.Callback or function() end
                    local clearOnFocus = tbConfig.ClearOnFocus ~= false

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 52),
                        BackgroundTransparency = 1,
                        LayoutOrder         = #self._items + 1,
                        Parent              = self.ItemList,
                    })

                    Utility.Create("TextLabel", {
                        Size                = UDim2.new(1, -16, 0, 20),
                        Position            = UDim2.new(0, 8, 0, 2),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        Parent              = Item,
                    })

                    local InputBG = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 30),
                        Position            = UDim2.new(0, 8, 0, 22),
                        BackgroundColor3    = CurrentTheme.Tertiary,
                        BorderSizePixel     = 0,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = InputBG })

                    local InputBox = Utility.Create("TextBox", {
                        Size                = UDim2.new(1, -16, 1, 0),
                        Position            = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = default,
                        PlaceholderText     = placeholder,
                        TextColor3          = CurrentTheme.Text,
                        PlaceholderColor3   = CurrentTheme.SubText,
                        TextSize            = 12,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        ClearTextOnFocus    = clearOnFocus,
                        Parent              = InputBG,
                    })

                    InputBox.Focused:Connect(function()
                        Utility.Tween(InputBG, {BackgroundColor3 = CurrentTheme.Border}, 0.15)
                    end)
                    InputBox.FocusLost:Connect(function(enter)
                        Utility.Tween(InputBG, {BackgroundColor3 = CurrentTheme.Tertiary}, 0.15)
                        if enter then
                            callback(InputBox.Text)
                            Window:SaveConfig()
                        end
                    end)

                    local TBObj = { type = "Textbox", value = default }
                    function TBObj:SetValue(val)
                        InputBox.Text = val
                        TBObj.value   = val
                    end
                    function TBObj:GetValue() return InputBox.Text end

                    Window._elements[id] = TBObj
                    table.insert(self._items, TBObj)
                    return TBObj
                end

                -- ══════════════════════════════════════════
                --               KEYBIND
                -- ══════════════════════════════════════════
                function Section:AddKeybind(kbConfig)
                    kbConfig = kbConfig or {}
                    local id         = kbConfig.Name or ("KB_" .. #Window._elements)
                    local text       = kbConfig.Name or "Keybind"
                    local default    = kbConfig.Default or Enum.KeyCode.Unknown
                    local callback   = kbConfig.Callback or function() end

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 40),
                        BackgroundTransparency = 1,
                        LayoutOrder         = #self._items + 1,
                        Parent              = self.ItemList,
                    })

                    Utility.Create("TextLabel", {
                        Size                = UDim2.new(0.6, 0, 1, 0),
                        Position            = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        Parent              = Item,
                    })

                    local KeyBtn = Utility.Create("TextButton", {
                        AnchorPoint         = Vector2.new(1, 0.5),
                        Size                = UDim2.new(0, 90, 0, 26),
                        Position            = UDim2.new(1, -8, 0.5, 0),
                        BackgroundColor3    = CurrentTheme.Tertiary,
                        BorderSizePixel     = 0,
                        Text                = default == Enum.KeyCode.Unknown and "None" or default.Name,
                        TextColor3          = CurrentTheme.Accent,
                        TextSize            = 12,
                        Font                = Enum.Font.GothamBold,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyBtn })

                    local KBObj    = { type = "Keybind", value = default }
                    local listening = false

                    KeyBtn.MouseButton1Click:Connect(function()
                        listening      = true
                        KeyBtn.Text    = "..."
                        KeyBtn.TextColor3 = CurrentTheme.Warning
                    end)

                    UserInputService.InputBegan:Connect(function(input, gpe)
                        if listening and not gpe then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                KBObj.value    = input.KeyCode
                                KeyBtn.Text    = input.KeyCode.Name
                                KeyBtn.TextColor3 = CurrentTheme.Accent
                                listening      = false
                                callback(input.KeyCode)
                                Window:SaveConfig()
                            end
                        elseif not listening and input.UserInputType == Enum.UserInputType.Keyboard then
                            if KBObj.value and input.KeyCode == KBObj.value then
                                callback(input.KeyCode)
                            end
                        end
                    end)

                    function KBObj:SetValue(kc)
                        KBObj.value  = kc
                        KeyBtn.Text  = kc.Name
                    end

                    Window._elements[id] = KBObj
                    table.insert(self._items, KBObj)
                    return KBObj
                end

                -- ══════════════════════════════════════════
                --             COLOR PICKER
                -- ══════════════════════════════════════════
                function Section:AddColorPicker(cpConfig)
                    cpConfig = cpConfig or {}
                    local id       = cpConfig.Name or ("CP_" .. #Window._elements)
                    local text     = cpConfig.Name or "Color Picker"
                    local default  = cpConfig.Default or Color3.fromRGB(99, 102, 241)
                    local callback = cpConfig.Callback or function() end

                    local H, S, V  = Color3.toHSV(default)

                    local Item = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 40),
                        BackgroundTransparency = 1,
                        ClipsDescendants    = false,
                        LayoutOrder         = #self._items + 1,
                        ZIndex              = 5,
                        Parent              = self.ItemList,
                    })

                    Utility.Create("TextLabel", {
                        Size                = UDim2.new(0.6, 0, 0, 40),
                        Position            = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = text,
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 13,
                        Font                = Enum.Font.Gotham,
                        TextXAlignment      = Enum.TextXAlignment.Left,
                        ZIndex              = 5,
                        Parent              = Item,
                    })

                    -- Color preview swatch
                    local Swatch = Utility.Create("TextButton", {
                        AnchorPoint         = Vector2.new(1, 0.5),
                        Size                = UDim2.new(0, 56, 0, 26),
                        Position            = UDim2.new(1, -8, 0.5, 0),
                        BackgroundColor3    = default,
                        BorderSizePixel     = 0,
                        Text                = "",
                        ZIndex              = 6,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Swatch })

                    -- Picker panel
                    local Panel = Utility.Create("Frame", {
                        Size                = UDim2.new(0, 220, 0, 0),
                        Position            = UDim2.new(1, -228, 0, 44),
                        BackgroundColor3    = CurrentTheme.Secondary,
                        BorderSizePixel     = 0,
                        ClipsDescendants    = true,
                        ZIndex              = 20,
                        Parent              = Item,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Panel })

                    -- SV Square
                    local SVFrame = Utility.Create("ImageLabel", {
                        Size                = UDim2.new(1, -16, 0, 120),
                        Position            = UDim2.new(0, 8, 0, 8),
                        BackgroundColor3    = Color3.fromHSV(H, 1, 1),
                        BorderSizePixel     = 0,
                        Image               = "rbxassetid://4155801252",
                        ZIndex              = 21,
                        Parent              = Panel,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SVFrame })

                    local SVCursor = Utility.Create("Frame", {
                        AnchorPoint         = Vector2.new(0.5, 0.5),
                        Size                = UDim2.new(0, 10, 0, 10),
                        Position            = UDim2.new(S, 0, 1 - V, 0),
                        BackgroundColor3    = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel     = 1,
                        ZIndex              = 22,
                        Parent              = SVFrame,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SVCursor })

                    -- Hue bar
                    local HueBar = Utility.Create("ImageLabel", {
                        Size                = UDim2.new(1, -16, 0, 14),
                        Position            = UDim2.new(0, 8, 0, 136),
                        Image               = "rbxassetid://4155799004",
                        BorderSizePixel     = 0,
                        ZIndex              = 21,
                        Parent              = Panel,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = HueBar })

                    local HueCursor = Utility.Create("Frame", {
                        AnchorPoint         = Vector2.new(0.5, 0.5),
                        Size                = UDim2.new(0, 8, 1, 4),
                        Position            = UDim2.new(H, 0, 0.5, 0),
                        BackgroundColor3    = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel     = 1,
                        ZIndex              = 22,
                        Parent              = HueBar,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = HueCursor })

                    -- Hex input
                    local HexBG = Utility.Create("Frame", {
                        Size                = UDim2.new(1, -16, 0, 28),
                        Position            = UDim2.new(0, 8, 0, 158),
                        BackgroundColor3    = CurrentTheme.Tertiary,
                        BorderSizePixel     = 0,
                        ZIndex              = 21,
                        Parent              = Panel,
                    })
                    Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = HexBG })
                    local HexInput = Utility.Create("TextBox", {
                        Size                = UDim2.new(1, -16, 1, 0),
                        Position            = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text                = string.format("%02X%02X%02X", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
                        PlaceholderText     = "FFFFFF",
                        TextColor3          = CurrentTheme.Text,
                        TextSize            = 12,
                        Font                = Enum.Font.Code,
                        ZIndex              = 22,
                        Parent              = HexBG,
                    })

                    local CPObj = { type = "ColorPicker", value = default }
                    local panelOpen = false

                    local function UpdateColor()
                        local color = Color3.fromHSV(H, S, V)
                        CPObj.value  = color
                        Swatch.BackgroundColor3 = color
                        SVFrame.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                        HexInput.Text = string.format("%02X%02X%02X",
                            math.floor(color.R * 255),
                            math.floor(color.G * 255),
                            math.floor(color.B * 255))
                        callback(color)
                        Window:SaveConfig()
                    end

                    -- SV interaction
                    local svDragging = false
                    SVFrame.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            svDragging = true
                            local rel = inp.Position - SVFrame.AbsolutePosition
                            S = math.clamp(rel.X / SVFrame.AbsoluteSize.X, 0, 1)
                            V = 1 - math.clamp(rel.Y / SVFrame.AbsoluteSize.Y, 0, 1)
                            SVCursor.Position = UDim2.new(S, 0, 1 - V, 0)
                            UpdateColor()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end
                    end)
                    UserInputService.InputChanged:Connect(function(inp)
                        if svDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = inp.Position - SVFrame.AbsolutePosition
                            S = math.clamp(rel.X / SVFrame.AbsoluteSize.X, 0, 1)
                            V = 1 - math.clamp(rel.Y / SVFrame.AbsoluteSize.Y, 0, 1)
                            SVCursor.Position = UDim2.new(S, 0, 1 - V, 0)
                            UpdateColor()
                        end
                    end)

                    -- Hue interaction
                    local hueDragging = false
                    HueBar.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            hueDragging = true
                            H = math.clamp((inp.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                            HueCursor.Position = UDim2.new(H, 0, 0.5, 0)
                            UpdateColor()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end
                    end)
                    UserInputService.InputChanged:Connect(function(inp)
                        if hueDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            H = math.clamp((inp.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                            HueCursor.Position = UDim2.new(H, 0, 0.5, 0)
                            UpdateColor()
                        end
                    end)

                    -- Hex input
                    HexInput.FocusLost:Connect(function()
                        local hex = HexInput.Text:gsub("#", "")
                        if #hex == 6 then
                            local r = tonumber(hex:sub(1,2), 16) or 0
                            local g = tonumber(hex:sub(3,4), 16) or 0
                            local b = tonumber(hex:sub(5,6), 16) or 0
                            local c = Color3.fromRGB(r, g, b)
                            H, S, V = Color3.toHSV(c)
                            SVCursor.Position = UDim2.new(S, 0, 1-V, 0)
                            HueCursor.Position = UDim2.new(H, 0, 0.5, 0)
                            UpdateColor()
                        end
                    end)

                    -- Toggle panel
                    Swatch.MouseButton1Click:Connect(function()
                        panelOpen = not panelOpen
                        if panelOpen then
                            Utility.Tween(Panel, {Size = UDim2.new(0, 220, 0, 196)}, 0.25)
                        else
                            Utility.Tween(Panel, {Size = UDim2.new(0, 220, 0, 0)}, 0.2)
                        end
                    end)

                    function CPObj:SetValue(color)
                        H, S, V = Color3.toHSV(color)
                        SVCursor.Position  = UDim2.new(S, 0, 1 - V, 0)
                        HueCursor.Position = UDim2.new(H, 0, 0.5, 0)
                        UpdateColor()
                    end

                    Window._elements[id] = CPObj
                    table.insert(self._items, CPObj)
                    return CPObj
                end

                table.insert(Tab._sections, Section)
                return Section
            end

            return Tab
        end

        -- ══════════════════════════════════════════════════
        --               ADD CONFIG TAB
        -- ══════════════════════════════════════════════════
        function Window:AddConfig()
            local ConfigTab = self:AddTab({ Name = "⚙ Config", Icon = "⚙" })
            local ConfigSection = ConfigTab:AddSection({ Name = "Themes" })

            local themeNames = {}
            for name, _ in pairs(Themes) do
                table.insert(themeNames, name)
            end
            table.sort(themeNames)

            ConfigSection:AddDropdown({
                Name     = "Theme",
                Options  = themeNames,
                Default  = windowConfig.Theme,
                Callback = function(selected)
                    Window:ApplyTheme(selected)
                end,
            })

            local SaveSection = ConfigTab:AddSection({ Name = "Config Management" })

            SaveSection:AddButton({
                Name     = "Save Config",
                Callback = function()
                    Window:SaveConfig()
                end,
            })

            SaveSection:AddButton({
                Name     = "Load Config",
                Callback = function()
                    Window:LoadConfig()
                end,
            })

            return ConfigTab
        end

        return Window
    end -- end BuildWindow

    -- ══════════════════════════════════════════════════════
    --                   INITIALIZATION
    -- ══════════════════════════════════════════════════════
    task.spawn(function()
        if windowConfig.LoadingEnabled then
            CreateLoadingScreen()
        end

        if windowConfig.KeySystem then
            CreateKeySystem()
        else
            keyValidated = true
        end

        if keyValidated then
            BuildWindow()
            if windowConfig.AutoSave then
                task.defer(function()
                    Window:LoadConfig()
                end)
            end
        end
    end)

    table.insert(NexusUI.Windows, Window)
    return Window
end

-- ══════════════════════════════════════════════════════════
--                      RETURN LIBRARY
-- ══════════════════════════════════════════════════════════
return NexusUI
