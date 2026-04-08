--[[
    ███╗   ██╗███████╗ ██████╗ ███╗   ██╗    ██╗     ██╗██████╗  █████╗ 
    ████╗  ██║██╔════╝██╔═══██╗████╗  ██║    ██║     ██║██╔══██╗██╔══██╗
    ██╔██╗ ██║█████╗  ██║   ██║██╔██╗ ██║    ██║     ██║██████╔╝███████║
    ██║╚██╗██║██╔══╝  ██║   ██║██║╚██╗██║    ██║     ██║██╔══██╗██╔══██║
    ██║ ╚████║███████╗╚██████╔╝██║ ╚████║    ███████╗██║██║  ██║██║  ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚══════╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝

    NeonLira UI Library v2.0
    Author: NeonLira Team
    License: MIT
    
    Features:
      - Draggable, resizable windows
      - Key system with save/load
      - Loading screen with progress
      - Auto-save / auto-load config
      - 12+ UI elements
      - Tab system
      - 10 themes
      - Mobile support
      - TweenService animations
]]

-- ============================================================
-- SERVICES
-- ============================================================
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- ============================================================
-- LIBRARY TABLE
-- ============================================================
local NeonLira = {}
NeonLira.__index = NeonLira

-- ============================================================
-- UTILITY
-- ============================================================
local Utility = {}

--- Smoothly tween a UI property
function Utility.Tween(instance, properties, duration, easingStyle, easingDirection)
    easingStyle      = easingStyle      or Enum.EasingStyle.Quart
    easingDirection  = easingDirection  or Enum.EasingDirection.Out
    duration         = duration         or 0.3
    local info = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

--- Create a UICorner quickly
function Utility.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

--- Create a UIPadding quickly
function Utility.Padding(parent, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.Parent = parent
    return p
end

--- Create a UIStroke
function Utility.Stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color        or Color3.fromRGB(255,255,255)
    s.Thickness    = thickness    or 1
    s.Transparency = transparency or 0.7
    s.Parent = parent
    return s
end

--- Create a UIListLayout
function Utility.ListLayout(parent, padding, fillDir, sortOrder)
    local l = Instance.new("UIListLayout")
    l.Padding           = UDim.new(0, padding or 6)
    l.FillDirection     = fillDir  or Enum.FillDirection.Vertical
    l.SortOrder         = sortOrder or Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Parent = parent
    return l
end

--- Create a gradient
function Utility.Gradient(parent, colorSeq, rotation)
    local g = Instance.new("UIGradient")
    g.Color    = colorSeq or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,28)),
    })
    g.Rotation = rotation or 90
    g.Parent   = parent
    return g
end

--- Write to file (writefile / saveFile support)
function Utility.WriteFile(path, data)
    local ok, err = pcall(function()
        if writefile then
            writefile(path, data)
        elseif saveFile then
            saveFile(path, data)
        end
    end)
    return ok, err
end

--- Read from file
function Utility.ReadFile(path)
    local ok, data = pcall(function()
        if readfile then
            return readfile(path)
        elseif loadFile then
            return loadFile(path)
        end
        return nil
    end)
    if ok and data then return data end
    return nil
end

--- Check if file exists
function Utility.FileExists(path)
    if isfile then return isfile(path) end
    local data = Utility.ReadFile(path)
    return data ~= nil
end

-- ============================================================
-- THEMES
-- ============================================================
local Themes = {
    ["Dark"] = {
        Background      = Color3.fromRGB(15,  15,  20),
        Topbar          = Color3.fromRGB(20,  20,  28),
        Element         = Color3.fromRGB(25,  25,  35),
        ElementHover    = Color3.fromRGB(35,  35,  48),
        Accent          = Color3.fromRGB(100, 60,  255),
        AccentDark      = Color3.fromRGB(70,  40,  190),
        Text            = Color3.fromRGB(230, 230, 240),
        TextMuted       = Color3.fromRGB(140, 140, 160),
        Success         = Color3.fromRGB(50,  200, 120),
        Error           = Color3.fromRGB(220, 70,  70),
        Border          = Color3.fromRGB(50,  50,  70),
        Tab             = Color3.fromRGB(18,  18,  25),
        TabActive       = Color3.fromRGB(100, 60,  255),
        Scrollbar       = Color3.fromRGB(60,  60,  80),
        Toggle          = Color3.fromRGB(40,  200, 120),
        ToggleOff       = Color3.fromRGB(60,  60,  80),
        Slider          = Color3.fromRGB(100, 60,  255),
    },
    ["Light"] = {
        Background      = Color3.fromRGB(245, 245, 250),
        Topbar          = Color3.fromRGB(235, 235, 242),
        Element         = Color3.fromRGB(255, 255, 255),
        ElementHover    = Color3.fromRGB(240, 240, 248),
        Accent          = Color3.fromRGB(90,  50,  240),
        AccentDark      = Color3.fromRGB(65,  35,  180),
        Text            = Color3.fromRGB(20,  20,  30),
        TextMuted       = Color3.fromRGB(100, 100, 120),
        Success         = Color3.fromRGB(40,  180, 100),
        Error           = Color3.fromRGB(200, 50,  50),
        Border          = Color3.fromRGB(200, 200, 215),
        Tab             = Color3.fromRGB(240, 240, 248),
        TabActive       = Color3.fromRGB(90,  50,  240),
        Scrollbar       = Color3.fromRGB(180, 180, 200),
        Toggle          = Color3.fromRGB(40,  180, 100),
        ToggleOff       = Color3.fromRGB(180, 180, 200),
        Slider          = Color3.fromRGB(90,  50,  240),
    },
    ["Midnight"] = {
        Background      = Color3.fromRGB(5,   5,   15),
        Topbar          = Color3.fromRGB(10,  10,  22),
        Element         = Color3.fromRGB(12,  12,  28),
        ElementHover    = Color3.fromRGB(20,  20,  40),
        Accent          = Color3.fromRGB(0,   180, 255),
        AccentDark      = Color3.fromRGB(0,   120, 200),
        Text            = Color3.fromRGB(200, 220, 255),
        TextMuted       = Color3.fromRGB(100, 130, 180),
        Success         = Color3.fromRGB(40,  220, 140),
        Error           = Color3.fromRGB(220, 80,  80),
        Border          = Color3.fromRGB(30,  40,  70),
        Tab             = Color3.fromRGB(8,   8,   20),
        TabActive       = Color3.fromRGB(0,   180, 255),
        Scrollbar       = Color3.fromRGB(40,  60,  100),
        Toggle          = Color3.fromRGB(40,  220, 140),
        ToggleOff       = Color3.fromRGB(30,  40,  70),
        Slider          = Color3.fromRGB(0,   180, 255),
    },
    ["Sunset"] = {
        Background      = Color3.fromRGB(20,  10,  25),
        Topbar          = Color3.fromRGB(30,  15,  35),
        Element         = Color3.fromRGB(35,  18,  40),
        ElementHover    = Color3.fromRGB(50,  25,  55),
        Accent          = Color3.fromRGB(255, 80,  150),
        AccentDark      = Color3.fromRGB(200, 50,  110),
        Text            = Color3.fromRGB(255, 220, 230),
        TextMuted       = Color3.fromRGB(180, 130, 150),
        Success         = Color3.fromRGB(80,  220, 150),
        Error           = Color3.fromRGB(255, 80,  80),
        Border          = Color3.fromRGB(80,  40,  70),
        Tab             = Color3.fromRGB(25,  12,  30),
        TabActive       = Color3.fromRGB(255, 80,  150),
        Scrollbar       = Color3.fromRGB(100, 50,  80),
        Toggle          = Color3.fromRGB(80,  220, 150),
        ToggleOff       = Color3.fromRGB(80,  40,  70),
        Slider          = Color3.fromRGB(255, 80,  150),
    },
    ["Ocean"] = {
        Background      = Color3.fromRGB(8,   20,  35),
        Topbar          = Color3.fromRGB(10,  28,  48),
        Element         = Color3.fromRGB(12,  32,  55),
        ElementHover    = Color3.fromRGB(18,  45,  75),
        Accent          = Color3.fromRGB(0,   220, 200),
        AccentDark      = Color3.fromRGB(0,   160, 145),
        Text            = Color3.fromRGB(200, 240, 255),
        TextMuted       = Color3.fromRGB(100, 170, 200),
        Success         = Color3.fromRGB(60,  220, 130),
        Error           = Color3.fromRGB(220, 70,  90),
        Border          = Color3.fromRGB(20,  60,  90),
        Tab             = Color3.fromRGB(8,   22,  40),
        TabActive       = Color3.fromRGB(0,   220, 200),
        Scrollbar       = Color3.fromRGB(30,  80,  110),
        Toggle          = Color3.fromRGB(60,  220, 130),
        ToggleOff       = Color3.fromRGB(20,  60,  90),
        Slider          = Color3.fromRGB(0,   220, 200),
    },
    ["Cyber"] = {
        Background      = Color3.fromRGB(0,   5,   10),
        Topbar          = Color3.fromRGB(0,   8,   16),
        Element         = Color3.fromRGB(0,   10,  20),
        ElementHover    = Color3.fromRGB(0,   20,  35),
        Accent          = Color3.fromRGB(0,   255, 128),
        AccentDark      = Color3.fromRGB(0,   180, 90),
        Text            = Color3.fromRGB(180, 255, 220),
        TextMuted       = Color3.fromRGB(80,  160, 120),
        Success         = Color3.fromRGB(0,   255, 128),
        Error           = Color3.fromRGB(255, 60,  60),
        Border          = Color3.fromRGB(0,   60,  40),
        Tab             = Color3.fromRGB(0,   6,   12),
        TabActive       = Color3.fromRGB(0,   255, 128),
        Scrollbar       = Color3.fromRGB(0,   80,  50),
        Toggle          = Color3.fromRGB(0,   255, 128),
        ToggleOff       = Color3.fromRGB(0,   60,  40),
        Slider          = Color3.fromRGB(0,   255, 128),
    },
    ["Rose"] = {
        Background      = Color3.fromRGB(25,  10,  15),
        Topbar          = Color3.fromRGB(35,  15,  22),
        Element         = Color3.fromRGB(40,  18,  26),
        ElementHover    = Color3.fromRGB(55,  25,  36),
        Accent          = Color3.fromRGB(255, 120, 140),
        AccentDark      = Color3.fromRGB(200, 80,  100),
        Text            = Color3.fromRGB(255, 230, 235),
        TextMuted       = Color3.fromRGB(180, 130, 140),
        Success         = Color3.fromRGB(100, 220, 150),
        Error           = Color3.fromRGB(255, 80,  80),
        Border          = Color3.fromRGB(90,  40,  55),
        Tab             = Color3.fromRGB(28,  12,  18),
        TabActive       = Color3.fromRGB(255, 120, 140),
        Scrollbar       = Color3.fromRGB(110, 50,  70),
        Toggle          = Color3.fromRGB(100, 220, 150),
        ToggleOff       = Color3.fromRGB(90,  40,  55),
        Slider          = Color3.fromRGB(255, 120, 140),
    },
    ["Arctic"] = {
        Background      = Color3.fromRGB(230, 240, 255),
        Topbar          = Color3.fromRGB(215, 228, 248),
        Element         = Color3.fromRGB(255, 255, 255),
        ElementHover    = Color3.fromRGB(240, 246, 255),
        Accent          = Color3.fromRGB(50,  120, 240),
        AccentDark      = Color3.fromRGB(30,  90,  190),
        Text            = Color3.fromRGB(20,  30,  60),
        TextMuted       = Color3.fromRGB(90,  110, 160),
        Success         = Color3.fromRGB(40,  190, 110),
        Error           = Color3.fromRGB(200, 50,  60),
        Border          = Color3.fromRGB(190, 210, 240),
        Tab             = Color3.fromRGB(220, 232, 252),
        TabActive       = Color3.fromRGB(50,  120, 240),
        Scrollbar       = Color3.fromRGB(160, 185, 230),
        Toggle          = Color3.fromRGB(40,  190, 110),
        ToggleOff       = Color3.fromRGB(190, 210, 240),
        Slider          = Color3.fromRGB(50,  120, 240),
    },
    ["Neon"] = {
        Background      = Color3.fromRGB(5,   0,   15),
        Topbar          = Color3.fromRGB(10,  0,   25),
        Element         = Color3.fromRGB(12,  0,   30),
        ElementHover    = Color3.fromRGB(22,  0,   50),
        Accent          = Color3.fromRGB(200, 0,   255),
        AccentDark      = Color3.fromRGB(150, 0,   200),
        Text            = Color3.fromRGB(240, 200, 255),
        TextMuted       = Color3.fromRGB(150, 100, 180),
        Success         = Color3.fromRGB(60,  255, 150),
        Error           = Color3.fromRGB(255, 50,  80),
        Border          = Color3.fromRGB(80,  0,   120),
        Tab             = Color3.fromRGB(8,   0,   20),
        TabActive       = Color3.fromRGB(200, 0,   255),
        Scrollbar       = Color3.fromRGB(100, 0,   150),
        Toggle          = Color3.fromRGB(60,  255, 150),
        ToggleOff       = Color3.fromRGB(80,  0,   120),
        Slider          = Color3.fromRGB(200, 0,   255),
    },
    ["Slate"] = {
        Background      = Color3.fromRGB(30,  35,  42),
        Topbar          = Color3.fromRGB(38,  44,  52),
        Element         = Color3.fromRGB(44,  50,  60),
        ElementHover    = Color3.fromRGB(55,  62,  74),
        Accent          = Color3.fromRGB(98,  160, 234),
        AccentDark      = Color3.fromRGB(65,  125, 200),
        Text            = Color3.fromRGB(220, 225, 235),
        TextMuted       = Color3.fromRGB(130, 145, 165),
        Success         = Color3.fromRGB(72,  199, 142),
        Error           = Color3.fromRGB(210, 80,  80),
        Border          = Color3.fromRGB(60,  68,  80),
        Tab             = Color3.fromRGB(34,  40,  48),
        TabActive       = Color3.fromRGB(98,  160, 234),
        Scrollbar       = Color3.fromRGB(80,  90,  105),
        Toggle          = Color3.fromRGB(72,  199, 142),
        ToggleOff       = Color3.fromRGB(60,  68,  80),
        Slider          = Color3.fromRGB(98,  160, 234),
    },
}

-- ============================================================
-- LIBRARY STATE
-- ============================================================
local LibState = {
    Theme           = Themes["Dark"],
    ThemeName       = "Dark",
    TransparentBg   = false,
    AutoSaveLoad    = true,
    SaveData        = {},
    Notifications   = {},
    Windows         = {},
    ScreenGui       = nil,
}

-- ============================================================
-- SCREEN GUI SETUP
-- ============================================================
local function GetOrCreateScreenGui()
    if LibState.ScreenGui and LibState.ScreenGui.Parent then
        return LibState.ScreenGui
    end
    
    local gui
    -- Try to parent to CoreGui for executor support
    pcall(function()
        gui = Instance.new("ScreenGui")
        gui.Name            = "NeonLiraLib"
        gui.ResetOnSpawn    = false
        gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder    = 999
        gui.IgnoreGuiInset  = true
        game:GetService("CoreGui"):WaitForChild("RobloxGui", 5)
        gui.Parent = game:GetService("CoreGui")
    end)
    
    if not gui or not gui.Parent then
        gui = Instance.new("ScreenGui")
        gui.Name            = "NeonLiraLib"
        gui.ResetOnSpawn    = false
        gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder    = 999
        gui.IgnoreGuiInset  = true
        gui.Parent          = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    LibState.ScreenGui = gui
    return gui
end

-- ============================================================
-- DRAGGING SYSTEM (Mouse + Touch)
-- ============================================================
local function MakeDraggable(dragHandle, dragObject)
    local dragging     = false
    local dragStart    = nil
    local startPos     = nil

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        dragObject.Position = newPos
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = dragObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            updateDrag(input)
        end
    end)
end

-- ============================================================
-- RESIZE SYSTEM
-- ============================================================
local function MakeResizable(resizeBtn, window, minW, minH, maxW, maxH)
    minW = minW or 300
    minH = minH or 200
    maxW = maxW or 800
    maxH = maxH or 700

    local resizing  = false
    local startSize = nil
    local startPos  = nil

    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            resizing  = true
            startSize = window.Size
            startPos  = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - startPos
            local newW  = math.clamp(startSize.X.Offset + delta.X, minW, maxW)
            local newH  = math.clamp(startSize.Y.Offset + delta.Y, minH, maxH)
            window.Size = UDim2.new(0, newW, 0, newH)
        end
    end)
end

-- ============================================================
-- NOTIFICATION SYSTEM
-- ============================================================
local function ShowNotification(title, message, notifType, duration)
    local T = LibState.Theme
    notifType = notifType or "info"
    duration  = duration  or 4

    local gui = GetOrCreateScreenGui()

    -- Container for stacking
    local container = gui:FindFirstChild("__NotifContainer")
    if not container then
        container = Instance.new("Frame")
        container.Name              = "__NotifContainer"
        container.Size              = UDim2.new(0, 280, 1, 0)
        container.Position          = UDim2.new(1, -296, 0, 0)
        container.BackgroundTransparency = 1
        container.Parent            = gui

        local list = Instance.new("UIListLayout")
        list.VerticalAlignment  = Enum.VerticalAlignment.Bottom
        list.HorizontalAlignment = Enum.HorizontalAlignment.Right
        list.Padding            = UDim.new(0, 8)
        list.SortOrder          = Enum.SortOrder.LayoutOrder
        list.Parent             = container

        local pad = Instance.new("UIPadding")
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingRight  = UDim.new(0, 0)
        pad.Parent = container
    end

    local accentColor = T.Accent
    if notifType == "success" then accentColor = T.Success
    elseif notifType == "error" then accentColor = T.Error end

    local notif = Instance.new("Frame")
    notif.Name              = "Notification"
    notif.Size              = UDim2.new(1, 0, 0, 72)
    notif.BackgroundColor3  = T.Element
    notif.BorderSizePixel   = 0
    notif.BackgroundTransparency = 1
    Utility.Corner(notif, 10)

    local stroke = Utility.Stroke(notif, accentColor, 1.2, 0.5)

    local accent = Instance.new("Frame")
    accent.Size             = UDim2.new(0, 3, 1, -16)
    accent.Position         = UDim2.new(0, 8, 0, 8)
    accent.BackgroundColor3 = accentColor
    accent.BorderSizePixel  = 0
    Utility.Corner(accent, 3)
    accent.Parent = notif

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size               = UDim2.new(1, -28, 0, 20)
    titleLbl.Position           = UDim2.new(0, 20, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = title
    titleLbl.TextColor3         = T.Text
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextSize           = 13
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.Parent             = notif

    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size                 = UDim2.new(1, -28, 0, 32)
    msgLbl.Position             = UDim2.new(0, 20, 0, 32)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text                 = message
    msgLbl.TextColor3           = T.TextMuted
    msgLbl.Font                 = Enum.Font.Gotham
    msgLbl.TextSize             = 11
    msgLbl.TextXAlignment       = Enum.TextXAlignment.Left
    msgLbl.TextWrapped          = true
    msgLbl.Parent               = notif

    -- Progress bar
    local progBg = Instance.new("Frame")
    progBg.Size             = UDim2.new(1, -16, 0, 2)
    progBg.Position         = UDim2.new(0, 8, 1, -6)
    progBg.BackgroundColor3 = T.Border
    progBg.BorderSizePixel  = 0
    Utility.Corner(progBg, 1)
    progBg.Parent = notif

    local progFill = Instance.new("Frame")
    progFill.Size           = UDim2.new(1, 0, 1, 0)
    progFill.BackgroundColor3 = accentColor
    progFill.BorderSizePixel = 0
    Utility.Corner(progFill, 1)
    progFill.Parent = progBg

    notif.Parent = container

    -- Animate in
    Utility.Tween(notif, {BackgroundTransparency = 0}, 0.3)

    -- Progress animation
    Utility.Tween(progFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    -- Animate out
    task.delay(duration, function()
        Utility.Tween(notif, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        notif:Destroy()
    end)

    return notif
end

-- ============================================================
-- KEY SYSTEM
-- ============================================================
local function CreateKeySystem(config, onSuccess)
    local T     = LibState.Theme
    local gui   = GetOrCreateScreenGui()

    -- Blur overlay
    local overlay = Instance.new("Frame")
    overlay.Size             = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel  = 0
    overlay.ZIndex           = 50
    overlay.Parent           = gui

    -- Card
    local card = Instance.new("Frame")
    card.Size               = UDim2.new(0, 340, 0, 260)
    card.Position           = UDim2.new(0.5, -170, 0.5, -130)
    card.BackgroundColor3   = T.Background
    card.BorderSizePixel    = 0
    card.ZIndex             = 51
    Utility.Corner(card, 14)
    Utility.Stroke(card, T.Accent, 1.5, 0.3)
    card.Parent = gui

    -- Accent top bar
    local topAccent = Instance.new("Frame")
    topAccent.Size          = UDim2.new(1, 0, 0, 3)
    topAccent.BackgroundColor3 = T.Accent
    topAccent.BorderSizePixel = 0
    Utility.Corner(topAccent, 3)
    topAccent.ZIndex = 52
    topAccent.Parent = card

    -- Logo/Icon
    if config.ImageId and config.ImageId ~= "" then
        local logo = Instance.new("ImageLabel")
        logo.Size               = UDim2.new(0, 44, 0, 44)
        logo.Position           = UDim2.new(0.5, -22, 0, 24)
        logo.BackgroundTransparency = 1
        logo.Image              = "rbxassetid://" .. tostring(config.ImageId)
        logo.ZIndex             = 52
        Utility.Corner(logo, 8)
        logo.Parent = card
    end

    local titleY = (config.ImageId and config.ImageId ~= "") and 78 or 28

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size               = UDim2.new(1, -20, 0, 24)
    titleLbl.Position           = UDim2.new(0, 10, 0, titleY)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = config.KeyName or "Key System"
    titleLbl.TextColor3         = T.Text
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextSize           = 17
    titleLbl.ZIndex             = 52
    titleLbl.Parent             = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size                 = UDim2.new(1, -20, 0, 16)
    subLbl.Position             = UDim2.new(0, 10, 0, titleY + 28)
    subLbl.BackgroundTransparency = 1
    subLbl.Text                 = "Enter your key to continue"
    subLbl.TextColor3           = T.TextMuted
    subLbl.Font                 = Enum.Font.Gotham
    subLbl.TextSize             = 12
    subLbl.ZIndex               = 52
    subLbl.Parent               = card

    -- Input
    local inputBg = Instance.new("Frame")
    inputBg.Size            = UDim2.new(1, -32, 0, 40)
    inputBg.Position        = UDim2.new(0, 16, 0, titleY + 58)
    inputBg.BackgroundColor3 = T.Element
    inputBg.BorderSizePixel = 0
    inputBg.ZIndex          = 52
    Utility.Corner(inputBg, 8)
    Utility.Stroke(inputBg, T.Border, 1, 0.4)
    inputBg.Parent = card

    local inputBox = Instance.new("TextBox")
    inputBox.Size               = UDim2.new(1, -20, 1, 0)
    inputBox.Position           = UDim2.new(0, 10, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.PlaceholderText    = "Enter key here..."
    inputBox.PlaceholderColor3  = T.TextMuted
    inputBox.Text               = ""
    inputBox.TextColor3         = T.Text
    inputBox.Font               = Enum.Font.Gotham
    inputBox.TextSize           = 13
    inputBox.ClearTextOnFocus   = false
    inputBox.ZIndex             = 53
    inputBox.Parent             = inputBg

    -- Status label
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size              = UDim2.new(1, -32, 0, 16)
    statusLbl.Position          = UDim2.new(0, 16, 0, titleY + 103)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text              = ""
    statusLbl.TextColor3        = T.TextMuted
    statusLbl.Font              = Enum.Font.Gotham
    statusLbl.TextSize          = 11
    statusLbl.ZIndex            = 52
    statusLbl.Parent            = card

    -- Submit button
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size              = UDim2.new(1, -32, 0, 38)
    submitBtn.Position          = UDim2.new(0, 16, 0, titleY + 126)
    submitBtn.BackgroundColor3  = T.Accent
    submitBtn.BorderSizePixel   = 0
    submitBtn.Text              = "Verify Key"
    submitBtn.TextColor3        = Color3.fromRGB(255,255,255)
    submitBtn.Font              = Enum.Font.GothamBold
    submitBtn.TextSize          = 13
    submitBtn.ZIndex            = 52
    Utility.Corner(submitBtn, 8)
    submitBtn.Parent = card

    -- Hover effect
    submitBtn.MouseEnter:Connect(function()
        Utility.Tween(submitBtn, {BackgroundColor3 = T.AccentDark}, 0.15)
    end)
    submitBtn.MouseLeave:Connect(function()
        Utility.Tween(submitBtn, {BackgroundColor3 = T.Accent}, 0.15)
    end)

    -- GetKey link
    if config.GetKeyFromSite and config.KeySite and config.KeySite ~= "" then
        local getKeyBtn = Instance.new("TextButton")
        getKeyBtn.Size              = UDim2.new(1, -32, 0, 18)
        getKeyBtn.Position          = UDim2.new(0, 16, 0, titleY + 170)
        getKeyBtn.BackgroundTransparency = 1
        getKeyBtn.Text              = "🔗 Get Key from Site"
        getKeyBtn.TextColor3        = T.Accent
        getKeyBtn.Font              = Enum.Font.Gotham
        getKeyBtn.TextSize          = 11
        getKeyBtn.ZIndex            = 52
        getKeyBtn.Parent            = card

        getKeyBtn.MouseButton1Click:Connect(function()
            -- Copy site URL to clipboard if possible
            pcall(function()
                setclipboard(config.KeySite)
                statusLbl.Text       = "✓ Site URL copied to clipboard!"
                statusLbl.TextColor3 = T.Success
            end)
        end)
    end

    -- Validation logic
    local function validateKey(key)
        key = key:gsub("^%s+", ""):gsub("%s+$", "")

        -- Check locally saved key first
        if config.KeySave and config.KeyFileName then
            local savedData = Utility.ReadFile(config.KeyFileName)
            if savedData then
                local ok, decoded = pcall(HttpService.JSONDecode, HttpService, savedData)
                if ok and decoded and decoded.key == key then
                    return true, "key_saved"
                end
            end
        end

        -- Validate against config key
        if config.Key and key == config.Key then
            return true, "key_match"
        end

        -- Validate via site if enabled
        if config.GetKeyFromSite and config.KeySite and config.KeySite ~= "" then
            local ok, response = pcall(function()
                return HttpService:GetAsync(config.KeySite)
            end)
            if ok and response then
                local siteKey = response:gsub("^%s+", ""):gsub("%s+$", "")
                if key == siteKey then
                    return true, "key_site"
                end
            end
        end

        return false, "invalid"
    end

    local function onSubmit()
        local key = inputBox.Text
        if key == "" then
            statusLbl.Text       = "⚠ Please enter a key."
            statusLbl.TextColor3 = T.Error
            Utility.Tween(inputBg, {BackgroundColor3 = Color3.fromRGB(60,20,20)}, 0.15)
            task.wait(0.3)
            Utility.Tween(inputBg, {BackgroundColor3 = T.Element}, 0.3)
            return
        end

        statusLbl.Text       = "⏳ Validating..."
        statusLbl.TextColor3 = T.TextMuted

        task.spawn(function()
            local valid, reason = validateKey(key)

            if valid then
                -- Save key
                if config.KeySave and config.KeyFileName then
                    local data = HttpService:JSONEncode({key = key, savedAt = os.time()})
                    Utility.WriteFile(config.KeyFileName, data)
                end

                statusLbl.Text       = "✓ Access granted!"
                statusLbl.TextColor3 = T.Success
                Utility.Tween(submitBtn, {BackgroundColor3 = T.Success}, 0.3)

                task.wait(0.8)

                -- Animate card out
                Utility.Tween(card, {BackgroundTransparency = 1}, 0.3)
                Utility.Tween(overlay, {BackgroundTransparency = 1}, 0.3)

                task.wait(0.35)
                card:Destroy()
                overlay:Destroy()

                if onSuccess then onSuccess() end
            else
                statusLbl.Text       = "✗ Invalid key. Try again."
                statusLbl.TextColor3 = T.Error
                Utility.Tween(inputBg, {BackgroundColor3 = Color3.fromRGB(60,20,20)}, 0.15)
                task.wait(0.4)
                Utility.Tween(inputBg, {BackgroundColor3 = T.Element}, 0.4)
                Utility.Tween(submitBtn, {BackgroundColor3 = T.Accent}, 0.3)
            end
        end)
    end

    submitBtn.MouseButton1Click:Connect(onSubmit)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then onSubmit() end
    end)

    -- Animate in
    card.BackgroundTransparency = 1
    Utility.Tween(card, {BackgroundTransparency = 0}, 0.4)

    return card
end

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local function CreateLoadingScreen(config, onComplete)
    local T   = LibState.Theme
    local gui = GetOrCreateScreenGui()

    local overlay = Instance.new("Frame")
    overlay.Size             = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(5,5,10)
    overlay.BorderSizePixel  = 0
    overlay.ZIndex           = 100
    overlay.Parent           = gui

    -- Logo
    if config.ImageId and config.ImageId ~= "" then
        local logo = Instance.new("ImageLabel")
        logo.Size               = UDim2.new(0, 72, 0, 72)
        logo.Position           = UDim2.new(0.5, -36, 0.5, -80)
        logo.BackgroundTransparency = 1
        logo.Image              = "rbxassetid://" .. tostring(config.ImageId)
        logo.ZIndex             = 101
        logo.ImageTransparency  = 1
        Utility.Corner(logo, 14)
        logo.Parent             = overlay
        Utility.Tween(logo, {ImageTransparency = 0}, 0.6)
    end

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size               = UDim2.new(0, 320, 0, 32)
    titleLbl.Position           = UDim2.new(0.5, -160, 0.5, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = config.LoadingName or "Loading..."
    titleLbl.TextColor3         = Color3.fromRGB(230,230,240)
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextSize           = 20
    titleLbl.ZIndex             = 101
    titleLbl.TextTransparency   = 1
    titleLbl.Parent             = overlay
    Utility.Tween(titleLbl, {TextTransparency = 0}, 0.6)

    local subLbl = Instance.new("TextLabel")
    subLbl.Size                 = UDim2.new(0, 320, 0, 18)
    subLbl.Position             = UDim2.new(0.5, -160, 0.5, 40)
    subLbl.BackgroundTransparency = 1
    subLbl.Text                 = "Please wait..."
    subLbl.TextColor3           = Color3.fromRGB(120,120,140)
    subLbl.Font                 = Enum.Font.Gotham
    subLbl.TextSize             = 12
    subLbl.ZIndex               = 101
    subLbl.TextTransparency     = 1
    subLbl.Parent               = overlay
    Utility.Tween(subLbl, {TextTransparency = 0}, 0.6)

    -- Progress track
    local progTrack = Instance.new("Frame")
    progTrack.Size          = UDim2.new(0, 280, 0, 4)
    progTrack.Position      = UDim2.new(0.5, -140, 0.5, 72)
    progTrack.BackgroundColor3 = Color3.fromRGB(30,30,45)
    progTrack.BorderSizePixel = 0
    progTrack.ZIndex        = 101
    Utility.Corner(progTrack, 2)
    progTrack.Parent = overlay

    local progFill = Instance.new("Frame")
    progFill.Size           = UDim2.new(0, 0, 1, 0)
    progFill.BackgroundColor3 = T.Accent
    progFill.BorderSizePixel = 0
    progFill.ZIndex         = 102
    Utility.Corner(progFill, 2)
    progFill.Parent = progTrack

    local pctLbl = Instance.new("TextLabel")
    pctLbl.Size                 = UDim2.new(0, 280, 0, 16)
    pctLbl.Position             = UDim2.new(0.5, -140, 0.5, 82)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text                 = "0%"
    pctLbl.TextColor3           = Color3.fromRGB(120,120,140)
    pctLbl.Font                 = Enum.Font.Gotham
    pctLbl.TextSize             = 10
    pctLbl.ZIndex               = 101
    pctLbl.TextXAlignment       = Enum.TextXAlignment.Right
    pctLbl.Parent               = overlay

    -- Simulate loading progress
    local steps = {
        {pct=0.15, label="Initializing..."},
        {pct=0.35, label="Loading modules..."},
        {pct=0.55, label="Preparing UI..."},
        {pct=0.75, label="Applying theme..."},
        {pct=0.90, label="Almost done..."},
        {pct=1.00, label="Complete!"},
    }

    task.spawn(function()
        task.wait(0.3)
        for _, step in ipairs(steps) do
            subLbl.Text = step.label
            Utility.Tween(progFill, {Size = UDim2.new(step.pct, 0, 1, 0)}, 0.4, Enum.EasingStyle.Quint)
            pctLbl.Text = math.floor(step.pct * 100) .. "%"
            task.wait(0.35)
        end

        task.wait(0.3)

        -- Animate out
        Utility.Tween(overlay, {BackgroundTransparency = 1}, 0.5)
        Utility.Tween(titleLbl, {TextTransparency = 1}, 0.4)
        Utility.Tween(subLbl, {TextTransparency = 1}, 0.4)
        Utility.Tween(pctLbl, {TextTransparency = 1}, 0.4)

        task.wait(0.55)
        overlay:Destroy()

        if onComplete then onComplete() end
    end)

    return overlay
end

-- ============================================================
-- SAVE / LOAD SYSTEM
-- ============================================================
local function SaveConfig(fileName)
    if not LibState.AutoSaveLoad then return end
    local ok, data = pcall(HttpService.JSONEncode, HttpService, LibState.SaveData)
    if ok then
        Utility.WriteFile(fileName or "NeonLira_Config.json", data)
    end
end

local function LoadConfig(fileName)
    if not LibState.AutoSaveLoad then return end
    local raw = Utility.ReadFile(fileName or "NeonLira_Config.json")
    if raw then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
        if ok and type(data) == "table" then
            LibState.SaveData = data
        end
    end
end

-- ============================================================
-- WINDOW CREATION
-- ============================================================
function NeonLira:CreateWindow(config)
    config = config or {}

    local windowData = {
        Name        = config.Name        or "NeonLira",
        ImageId     = config.ImageId     or "",
        Size        = config.Size        or {Width=520, Height=400},
        Position    = config.Position    or {X=0.5, Y=0.5},
        Theme       = config.Theme       or "Dark",
        KeyEnable       = config.KeyEnable   or false,
        Key             = config.Key         or "",
        KeyName         = config.KeyName     or "Key System",
        KeySave         = config.KeySave     or false,
        KeyFileName     = config.KeyFileName or "NeonLira_Key.json",
        GetKeyFromSite  = config.GetKeyFromSite or false,
        KeySite         = config.KeySite     or "",
        LoadingName     = config.LoadingName or ("Loading " .. (config.Name or "NeonLira")),
        AutoSaveLoad    = config.AutoSaveLoad ~= nil and config.AutoSaveLoad or true,
        SaveFileName    = config.SaveFileName or "NeonLira_Config.json",
        Tabs            = {},
        ActiveTab       = nil,
        Elements        = {},
        Minimized       = false,
        Closed          = false,
    }

    -- Apply config settings to lib state
    if Themes[config.Theme] then
        LibState.Theme     = Themes[config.Theme]
        LibState.ThemeName = config.Theme
    end
    LibState.AutoSaveLoad = windowData.AutoSaveLoad

    -- Load saved config
    LoadConfig(windowData.SaveFileName)

    local T   = LibState.Theme
    local gui = GetOrCreateScreenGui()

    -- ---- Build actual window ----
    local function BuildWindow()
        -- Main window frame
        local window = Instance.new("Frame")
        window.Name             = "NeonLiraWindow"
        window.Size             = UDim2.new(0, windowData.Size.Width, 0, windowData.Size.Height)
        window.Position         = UDim2.new(
            windowData.Position.X, -windowData.Size.Width/2,
            windowData.Position.Y, -windowData.Size.Height/2
        )
        window.BackgroundColor3 = T.Background
        window.BorderSizePixel  = 0
        window.ClipsDescendants = true
        window.ZIndex           = 10
        Utility.Corner(window, 12)
        Utility.Stroke(window, T.Border, 1, 0.4)
        window.Parent = gui

        if LibState.TransparentBg then
            window.BackgroundTransparency = 0.4
        end

        -- Gradient background
        Utility.Gradient(window, ColorSequence.new({
            ColorSequenceKeypoint.new(0, T.Background),
            ColorSequenceKeypoint.new(1, Color3.new(
                T.Background.R * 0.9,
                T.Background.G * 0.9,
                T.Background.B * 0.9
            )),
        }), 135)

        -- ---- TOPBAR ----
        local topbar = Instance.new("Frame")
        topbar.Name             = "Topbar"
        topbar.Size             = UDim2.new(1, 0, 0, 44)
        topbar.BackgroundColor3 = T.Topbar
        topbar.BorderSizePixel  = 0
        topbar.ZIndex           = 11
        Utility.Gradient(topbar, ColorSequence.new({
            ColorSequenceKeypoint.new(0, T.Topbar),
            ColorSequenceKeypoint.new(1, Color3.new(
                T.Topbar.R * 0.85,
                T.Topbar.G * 0.85,
                T.Topbar.B * 0.85
            )),
        }), 90)
        topbar.Parent = window

        -- Accent line under topbar
        local topLine = Instance.new("Frame")
        topLine.Size            = UDim2.new(1, 0, 0, 2)
        topLine.Position        = UDim2.new(0, 0, 1, 0)
        topLine.BackgroundColor3 = T.Accent
        topLine.BorderSizePixel = 0
        topLine.ZIndex          = 12
        topLine.Parent          = topbar

        -- Icon
        local iconX = 12
        if windowData.ImageId ~= "" then
            local icon = Instance.new("ImageLabel")
            icon.Size               = UDim2.new(0, 26, 0, 26)
            icon.Position           = UDim2.new(0, 10, 0.5, -13)
            icon.BackgroundTransparency = 1
            icon.Image              = "rbxassetid://" .. windowData.ImageId
            icon.ZIndex             = 12
            Utility.Corner(icon, 5)
            icon.Parent = topbar
            iconX = 44
        end

        -- Window name
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size               = UDim2.new(1, -150, 1, 0)
        titleLbl.Position           = UDim2.new(0, iconX, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text               = windowData.Name
        titleLbl.TextColor3         = T.Text
        titleLbl.Font               = Enum.Font.GothamBold
        titleLbl.TextSize           = 14
        titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
        titleLbl.ZIndex             = 12
        titleLbl.Parent             = topbar

        -- ---- BUTTONS (Close / Minimize / Resize) ----
        local btnContainer = Instance.new("Frame")
        btnContainer.Size           = UDim2.new(0, 86, 0, 26)
        btnContainer.Position       = UDim2.new(1, -96, 0.5, -13)
        btnContainer.BackgroundTransparency = 1
        btnContainer.ZIndex         = 12
        btnContainer.Parent         = topbar

        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection     = Enum.FillDirection.Horizontal
        btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        btnLayout.Padding           = UDim.new(0, 6)
        btnLayout.SortOrder         = Enum.SortOrder.LayoutOrder
        btnLayout.Parent            = btnContainer

        local function MakeTopBtn(icon, color, layoutOrder)
            local btn = Instance.new("TextButton")
            btn.Size            = UDim2.new(0, 22, 0, 22)
            btn.BackgroundColor3 = color
            btn.BorderSizePixel = 0
            btn.Text            = icon
            btn.TextColor3      = Color3.fromRGB(255,255,255)
            btn.Font            = Enum.Font.GothamBold
            btn.TextSize        = 10
            btn.ZIndex          = 13
            btn.LayoutOrder     = layoutOrder
            Utility.Corner(btn, 5)
            btn.Parent = btnContainer

            btn.MouseEnter:Connect(function()
                Utility.Tween(btn, {BackgroundTransparency = 0.2}, 0.12)
            end)
            btn.MouseLeave:Connect(function()
                Utility.Tween(btn, {BackgroundTransparency = 0}, 0.12)
            end)

            return btn
        end

        local resizeBtn   = MakeTopBtn("⤢", Color3.fromRGB(80,160,255), 1)
        local minimizeBtn = MakeTopBtn("—", Color3.fromRGB(255,190,50), 2)
        local closeBtn    = MakeTopBtn("✕", Color3.fromRGB(230,60,60), 3)

        -- ---- BODY (Sidebar tabs + Content) ----
        local body = Instance.new("Frame")
        body.Name               = "Body"
        body.Size               = UDim2.new(1, 0, 1, -46)
        body.Position           = UDim2.new(0, 0, 0, 46)
        body.BackgroundTransparency = 1
        body.ZIndex             = 11
        body.Parent             = window

        -- Sidebar
        local sidebar = Instance.new("ScrollingFrame")
        sidebar.Name                = "Sidebar"
        sidebar.Size                = UDim2.new(0, 130, 1, 0)
        sidebar.BackgroundColor3    = T.Tab
        sidebar.BorderSizePixel     = 0
        sidebar.ScrollBarThickness  = 0
        sidebar.ScrollingDirection  = Enum.ScrollingDirection.Y
        sidebar.CanvasSize          = UDim2.new(0, 0, 0, 0)
        sidebar.ZIndex              = 12
        sidebar.ClipsDescendants    = true
        sidebar.Parent              = body

        Utility.Padding(sidebar, 8, 0, 8, 0)
        Utility.ListLayout(sidebar, 4)

        -- Right-side border line
        local sideLineR = Instance.new("Frame")
        sideLineR.Size          = UDim2.new(0, 1, 1, 0)
        sideLineR.Position      = UDim2.new(1, -1, 0, 0)
        sideLineR.BackgroundColor3 = T.Border
        sideLineR.BorderSizePixel = 0
        sideLineR.ZIndex        = 13
        sideLineR.Parent        = sidebar

        -- Content area
        local content = Instance.new("Frame")
        content.Name            = "Content"
        content.Size            = UDim2.new(1, -132, 1, 0)
        content.Position        = UDim2.new(0, 132, 0, 0)
        content.BackgroundTransparency = 1
        content.ZIndex          = 12
        content.ClipsDescendants = true
        content.Parent          = body

        -- ---- CLOSE CONFIRM ----
        local function ShowConfirm(onYes)
            local confirmBg = Instance.new("Frame")
            confirmBg.Size               = UDim2.new(1, 0, 1, 0)
            confirmBg.BackgroundColor3   = Color3.fromRGB(0,0,0)
            confirmBg.BackgroundTransparency = 0.6
            confirmBg.ZIndex             = 20
            confirmBg.Parent             = window

            local confirmCard = Instance.new("Frame")
            confirmCard.Size             = UDim2.new(0, 240, 0, 120)
            confirmCard.Position         = UDim2.new(0.5, -120, 0.5, -60)
            confirmCard.BackgroundColor3 = T.Element
            confirmCard.BorderSizePixel  = 0
            confirmCard.ZIndex           = 21
            Utility.Corner(confirmCard, 12)
            Utility.Stroke(confirmCard, T.Border, 1, 0.3)
            confirmCard.Parent = confirmBg

            local msg = Instance.new("TextLabel")
            msg.Size                = UDim2.new(1, -20, 0, 30)
            msg.Position            = UDim2.new(0, 10, 0, 16)
            msg.BackgroundTransparency = 1
            msg.Text                = "Close " .. windowData.Name .. "?"
            msg.TextColor3          = T.Text
            msg.Font                = Enum.Font.GothamBold
            msg.TextSize            = 14
            msg.ZIndex              = 22
            msg.Parent              = confirmCard

            local subMsg = Instance.new("TextLabel")
            subMsg.Size             = UDim2.new(1, -20, 0, 18)
            subMsg.Position         = UDim2.new(0, 10, 0, 44)
            subMsg.BackgroundTransparency = 1
            subMsg.Text             = "This will destroy the UI."
            subMsg.TextColor3       = T.TextMuted
            subMsg.Font             = Enum.Font.Gotham
            subMsg.TextSize         = 11
            subMsg.ZIndex           = 22
            subMsg.Parent           = confirmCard

            local yesBtn = Instance.new("TextButton")
            yesBtn.Size             = UDim2.new(0, 96, 0, 30)
            yesBtn.Position         = UDim2.new(0, 16, 0, 74)
            yesBtn.BackgroundColor3 = T.Error
            yesBtn.BorderSizePixel  = 0
            yesBtn.Text             = "Yes, Close"
            yesBtn.TextColor3       = Color3.fromRGB(255,255,255)
            yesBtn.Font             = Enum.Font.GothamBold
            yesBtn.TextSize         = 12
            yesBtn.ZIndex           = 22
            Utility.Corner(yesBtn, 7)
            yesBtn.Parent = confirmCard

            local cancelBtn = Instance.new("TextButton")
            cancelBtn.Size          = UDim2.new(0, 96, 0, 30)
            cancelBtn.Position      = UDim2.new(1, -112, 0, 74)
            cancelBtn.BackgroundColor3 = T.Element
            cancelBtn.BorderSizePixel = 0
            cancelBtn.Text          = "Cancel"
            cancelBtn.TextColor3    = T.Text
            cancelBtn.Font          = Enum.Font.Gotham
            cancelBtn.TextSize      = 12
            cancelBtn.ZIndex        = 22
            Utility.Corner(cancelBtn, 7)
            Utility.Stroke(cancelBtn, T.Border, 1, 0.3)
            cancelBtn.Parent = confirmCard

            yesBtn.MouseButton1Click:Connect(function()
                confirmBg:Destroy()
                if onYes then onYes() end
            end)
            cancelBtn.MouseButton1Click:Connect(function()
                confirmBg:Destroy()
            end)
        end

        -- Close button logic
        closeBtn.MouseButton1Click:Connect(function()
            ShowConfirm(function()
                SaveConfig(windowData.SaveFileName)
                Utility.Tween(window, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.35)
                window:Destroy()
            end)
        end)

        -- Minimize button logic
        local origSize = UDim2.new(0, windowData.Size.Width, 0, windowData.Size.Height)
        local miniSize = UDim2.new(0, windowData.Size.Width, 0, 44)

        minimizeBtn.MouseButton1Click:Connect(function()
            windowData.Minimized = not windowData.Minimized
            if windowData.Minimized then
                Utility.Tween(window, {Size = miniSize}, 0.3, Enum.EasingStyle.Quint)
                body.Visible = false
            else
                body.Visible = true
                Utility.Tween(window, {Size = origSize}, 0.3, Enum.EasingStyle.Quint)
            end
        end)

        -- Resize button
        MakeResizable(resizeBtn, window)

        -- Drag
        MakeDraggable(topbar, window)

        -- ---- Window Object API ----
        local WindowObj = {}
        WindowObj._window   = window
        WindowObj._sidebar  = sidebar
        WindowObj._content  = content
        WindowObj._tabs     = {}
        WindowObj._data     = windowData
        WindowObj._saveFile = windowData.SaveFileName

        -- ===========================
        -- ADD TAB
        -- ===========================
        function WindowObj:AddTab(tabConfig)
            tabConfig = tabConfig or {}
            local tabName  = tabConfig.Name  or ("Tab " .. (#self._tabs + 1))
            local tabIcon  = tabConfig.Icon  or ""

            -- Sidebar button
            local tabBtn = Instance.new("TextButton")
            tabBtn.Size             = UDim2.new(1, -12, 0, 34)
            tabBtn.BackgroundColor3 = T.Tab
            tabBtn.BorderSizePixel  = 0
            tabBtn.Text             = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName
            tabBtn.TextColor3       = T.TextMuted
            tabBtn.Font             = Enum.Font.Gotham
            tabBtn.TextSize         = 12
            tabBtn.TextXAlignment   = Enum.TextXAlignment.Left
            tabBtn.ZIndex           = 13
            Utility.Corner(tabBtn, 7)
            Utility.Padding(tabBtn, 0, 0, 0, 10)
            tabBtn.Parent = sidebar

            -- Accent indicator
            local indicator = Instance.new("Frame")
            indicator.Size          = UDim2.new(0, 3, 0.5, 0)
            indicator.Position      = UDim2.new(0, 0, 0.25, 0)
            indicator.BackgroundColor3 = T.Accent
            indicator.BorderSizePixel = 0
            indicator.BackgroundTransparency = 1
            Utility.Corner(indicator, 2)
            indicator.Parent = tabBtn

            -- Content scroll frame
            local tabFrame = Instance.new("ScrollingFrame")
            tabFrame.Name               = "Tab_" .. tabName
            tabFrame.Size               = UDim2.new(1, 0, 1, 0)
            tabFrame.BackgroundTransparency = 1
            tabFrame.BorderSizePixel    = 0
            tabFrame.ScrollBarThickness = 4
            tabFrame.ScrollBarImageColor3 = T.Scrollbar
            tabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
            tabFrame.CanvasSize         = UDim2.new(0, 0, 0, 0)
            tabFrame.Visible            = false
            tabFrame.ZIndex             = 13
            tabFrame.Parent             = content

            Utility.ListLayout(tabFrame, 6)
            Utility.Padding(tabFrame, 10, 10, 10, 10)

            local tabObj = {
                _btn        = tabBtn,
                _frame      = tabFrame,
                _indicator  = indicator,
                _name       = tabName,
                _window     = self,
                _elements   = {},
            }

            local function Activate()
                -- Deactivate all tabs
                for _, t in ipairs(self._tabs) do
                    t._frame.Visible = false
                    Utility.Tween(t._btn, {BackgroundColor3 = T.Tab, TextColor3 = T.TextMuted}, 0.2)
                    Utility.Tween(t._indicator, {BackgroundTransparency = 1}, 0.2)
                end
                -- Activate this tab
                tabFrame.Visible = true
                windowData.ActiveTab = tabObj
                Utility.Tween(tabBtn, {BackgroundColor3 = T.ElementHover, TextColor3 = T.Text}, 0.2)
                Utility.Tween(indicator, {BackgroundTransparency = 0}, 0.2)
            end

            tabBtn.MouseButton1Click:Connect(Activate)
            tabBtn.MouseEnter:Connect(function()
                if windowData.ActiveTab ~= tabObj then
                    Utility.Tween(tabBtn, {BackgroundColor3 = T.ElementHover}, 0.15)
                end
            end)
            tabBtn.MouseLeave:Connect(function()
                if windowData.ActiveTab ~= tabObj then
                    Utility.Tween(tabBtn, {BackgroundColor3 = T.Tab}, 0.15)
                end
            end)

            table.insert(self._tabs, tabObj)

            -- Auto-activate first tab
            if #self._tabs == 1 then
                Activate()
            end

            -- Update sidebar canvas
            local function UpdateSidebarCanvas()
                local list = sidebar:FindFirstChildOfClass("UIListLayout")
                if list then
                    sidebar.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 16)
                end
            end
            tabBtn:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSidebarCanvas)
            UpdateSidebarCanvas()

            -- ========================
            -- ELEMENT HELPERS
            -- ========================
            local function UpdateCanvas()
                local list = tabFrame:FindFirstChildOfClass("UIListLayout")
                if list then
                    tabFrame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
                end
            end

            local function BaseElement(height)
                local el = Instance.new("Frame")
                el.Size             = UDim2.new(1, -4, 0, height or 40)
                el.BackgroundColor3 = T.Element
                el.BorderSizePixel  = 0
                el.ZIndex           = 14
                Utility.Corner(el, 8)
                el.Parent = tabFrame
                UpdateCanvas()
                return el
            end

            -- ========================
            -- SECTION
            -- ========================
            function tabObj:AddSection(sectionConfig)
                sectionConfig = sectionConfig or {}
                local name = sectionConfig.Name or "Section"

                local el = Instance.new("Frame")
                el.Size             = UDim2.new(1, -4, 0, 26)
                el.BackgroundTransparency = 1
                el.ZIndex           = 14
                el.Parent           = tabFrame

                local line = Instance.new("Frame")
                line.Size           = UDim2.new(0.5, 0, 0, 1)
                line.Position       = UDim2.new(0, 0, 0.5, 0)
                line.BackgroundColor3 = T.Border
                line.BorderSizePixel = 0
                line.ZIndex         = 15
                line.Parent         = el

                local lineR = Instance.new("Frame")
                lineR.Size          = UDim2.new(0.5, 0, 0, 1)
                lineR.Position      = UDim2.new(0.5, 0, 0.5, 0)
                lineR.BackgroundColor3 = T.Border
                lineR.BorderSizePixel = 0
                lineR.ZIndex        = 15
                lineR.Parent        = el

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text            = name
                lbl.TextColor3      = T.TextMuted
                lbl.Font            = Enum.Font.GothamBold
                lbl.TextSize        = 10
                lbl.ZIndex          = 15
                lbl.Parent          = el

                UpdateCanvas()
                return el
            end

            -- ========================
            -- LABEL
            -- ========================
            function tabObj:AddLabel(labelConfig)
                labelConfig = labelConfig or {}
                local el = BaseElement(32)

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.new(1, -12, 1, 0)
                lbl.Position        = UDim2.new(0, 6, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text            = labelConfig.Text or "Label"
                lbl.TextColor3      = T.TextMuted
                lbl.Font            = Enum.Font.Gotham
                lbl.TextSize        = 12
                lbl.TextXAlignment  = Enum.TextXAlignment.Left
                lbl.ZIndex          = 15
                lbl.Parent          = el

                local labelObj = {}
                function labelObj:SetText(t)
                    lbl.Text = t
                end
                return labelObj
            end

            -- ========================
            -- PARAGRAPH
            -- ========================
            function tabObj:AddParagraph(paragConfig)
                paragConfig = paragConfig or {}
                local el = BaseElement(60)
                el.ClipsDescendants = true

                local titleLb = Instance.new("TextLabel")
                titleLb.Size        = UDim2.new(1, -12, 0, 18)
                titleLb.Position    = UDim2.new(0, 6, 0, 6)
                titleLb.BackgroundTransparency = 1
                titleLb.Text        = paragConfig.Title or "Title"
                titleLb.TextColor3  = T.Text
                titleLb.Font        = Enum.Font.GothamBold
                titleLb.TextSize    = 12
                titleLb.TextXAlignment = Enum.TextXAlignment.Left
                titleLb.ZIndex      = 15
                titleLb.Parent      = el

                local bodyLb = Instance.new("TextLabel")
                bodyLb.Size         = UDim2.new(1, -12, 0, 0)
                bodyLb.Position     = UDim2.new(0, 6, 0, 26)
                bodyLb.BackgroundTransparency = 1
                bodyLb.Text         = paragConfig.Content or ""
                bodyLb.TextColor3   = T.TextMuted
                bodyLb.Font         = Enum.Font.Gotham
                bodyLb.TextSize     = 11
                bodyLb.TextXAlignment = Enum.TextXAlignment.Left
                bodyLb.TextWrapped  = true
                bodyLb.ZIndex       = 15
                bodyLb.Parent       = el

                -- Auto-resize
                bodyLb:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    local h = bodyLb.TextBounds.Y
                    bodyLb.Size = UDim2.new(1, -12, 0, h)
                    el.Size = UDim2.new(1, -4, 0, h + 36)
                    UpdateCanvas()
                end)

                return el
            end

            -- ========================
            -- BUTTON
            -- ========================
            function tabObj:AddButton(btnConfig)
                btnConfig = btnConfig or {}
                local el = BaseElement(38)
                Utility.Stroke(el, T.Accent, 1, 0.7)

                local btn = Instance.new("TextButton")
                btn.Size            = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text            = btnConfig.Name or "Button"
                btn.TextColor3      = T.Text
                btn.Font            = Enum.Font.GothamBold
                btn.TextSize        = 13
                btn.ZIndex          = 15
                btn.Parent          = el

                btn.MouseEnter:Connect(function()
                    Utility.Tween(el, {BackgroundColor3 = T.ElementHover}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    Utility.Tween(el, {BackgroundColor3 = T.Element}, 0.15)
                end)
                btn.MouseButton1Down:Connect(function()
                    Utility.Tween(el, {BackgroundColor3 = T.AccentDark}, 0.1)
                end)
                btn.MouseButton1Up:Connect(function()
                    Utility.Tween(el, {BackgroundColor3 = T.ElementHover}, 0.15)
                end)
                btn.MouseButton1Click:Connect(function()
                    if btnConfig.Callback then
                        pcall(btnConfig.Callback)
                    end
                end)

                local btnObj = {}
                function btnObj:SetText(t) btn.Text = t end
                return btnObj
            end

            -- ========================
            -- TOGGLE
            -- ========================
            function tabObj:AddToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local name    = toggleConfig.Name    or "Toggle"
                local default = toggleConfig.Default or false
                local saveId  = toggleConfig.Flag    or name

                -- Load saved value
                if LibState.SaveData[saveId] ~= nil then
                    default = LibState.SaveData[saveId]
                end

                local state = default
                local el = BaseElement(38)
                Utility.Padding(el, 0, 0, 0, 0)

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.new(1, -58, 1, 0)
                lbl.Position        = UDim2.new(0, 10, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text            = name
                lbl.TextColor3      = T.Text
                lbl.Font            = Enum.Font.Gotham
                lbl.TextSize        = 13
                lbl.TextXAlignment  = Enum.TextXAlignment.Left
                lbl.ZIndex          = 15
                lbl.Parent          = el

                -- Toggle track
                local track = Instance.new("Frame")
                track.Size          = UDim2.new(0, 38, 0, 20)
                track.Position      = UDim2.new(1, -48, 0.5, -10)
                track.BorderSizePixel = 0
                track.BackgroundColor3 = state and T.Toggle or T.ToggleOff
                Utility.Corner(track, 10)
                track.ZIndex        = 15
                track.Parent        = el

                local knob = Instance.new("Frame")
                knob.Size           = UDim2.new(0, 16, 0, 16)
                knob.Position       = UDim2.new(state and 1 or 0, state and -18 or 2, 0.5, -8)
                knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                knob.BorderSizePixel = 0
                Utility.Corner(knob, 8)
                knob.ZIndex         = 16
                knob.Parent         = track

                local clickArea = Instance.new("TextButton")
                clickArea.Size      = UDim2.new(1, 0, 1, 0)
                clickArea.BackgroundTransparency = 1
                clickArea.Text      = ""
                clickArea.ZIndex    = 16
                clickArea.Parent    = el

                local function SetState(v)
                    state = v
                    LibState.SaveData[saveId] = state
                    SaveConfig(self._window._saveFile)

                    Utility.Tween(track, {
                        BackgroundColor3 = state and T.Toggle or T.ToggleOff
                    }, 0.2)
                    Utility.Tween(knob, {
                        Position = state
                            and UDim2.new(1, -18, 0.5, -8)
                            or  UDim2.new(0,   2, 0.5, -8)
                    }, 0.2)

                    if toggleConfig.Callback then
                        pcall(toggleConfig.Callback, state)
                    end
                end

                clickArea.MouseButton1Click:Connect(function()
                    SetState(not state)
                end)

                -- Initial callback
                if toggleConfig.Callback and state then
                    pcall(toggleConfig.Callback, state)
                end

                local toggleObj = {}
                function toggleObj:Set(v) SetState(v) end
                function toggleObj:Get() return state end
                return toggleObj
            end

            -- ========================
            -- SLIDER
            -- ========================
            function tabObj:AddSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                local name    = sliderConfig.Name    or "Slider"
                local min     = sliderConfig.Min     or 0
                local max     = sliderConfig.Max     or 100
                local default = sliderConfig.Default or min
                local saveId  = sliderConfig.Flag    or name
                local suffix  = sliderConfig.Suffix  or ""

                if LibState.SaveData[saveId] ~= nil then
                    default = LibState.SaveData[saveId]
                end
                default = math.clamp(default, min, max)

                local value = default
                local el = BaseElement(54)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size        = UDim2.new(1, -70, 0, 20)
                nameLbl.Position    = UDim2.new(0, 10, 0, 8)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text        = name
                nameLbl.TextColor3  = T.Text
                nameLbl.Font        = Enum.Font.Gotham
                nameLbl.TextSize    = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex      = 15
                nameLbl.Parent      = el

                local valLbl = Instance.new("TextLabel")
                valLbl.Size         = UDim2.new(0, 55, 0, 20)
                valLbl.Position     = UDim2.new(1, -65, 0, 8)
                valLbl.BackgroundTransparency = 1
                valLbl.Text         = tostring(value) .. suffix
                valLbl.TextColor3   = T.Accent
                valLbl.Font         = Enum.Font.GothamBold
                valLbl.TextSize     = 12
                valLbl.TextXAlignment = Enum.TextXAlignment.Right
                valLbl.ZIndex       = 15
                valLbl.Parent       = el

                -- Track
                local track = Instance.new("Frame")
                track.Size          = UDim2.new(1, -20, 0, 6)
                track.Position      = UDim2.new(0, 10, 0, 36)
                track.BackgroundColor3 = T.Border
                track.BorderSizePixel = 0
                Utility.Corner(track, 3)
                track.ZIndex        = 15
                track.Parent        = el

                local fill = Instance.new("Frame")
                fill.Size           = UDim2.new((value - min)/(max - min), 0, 1, 0)
                fill.BackgroundColor3 = T.Slider
                fill.BorderSizePixel = 0
                Utility.Corner(fill, 3)
                fill.ZIndex         = 16
                fill.Parent         = track

                local knob = Instance.new("Frame")
                knob.Size           = UDim2.new(0, 14, 0, 14)
                knob.Position       = UDim2.new((value-min)/(max-min), -7, 0.5, -7)
                knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                knob.BorderSizePixel = 0
                Utility.Corner(knob, 7)
                Utility.Stroke(knob, T.Slider, 2, 0)
                knob.ZIndex         = 17
                knob.Parent         = track

                local function SetValue(v)
                    value = math.clamp(math.round(v), min, max)
                    local pct = (value - min) / (max - min)
                    Utility.Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                    Utility.Tween(knob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.1)
                    valLbl.Text = tostring(value) .. suffix

                    LibState.SaveData[saveId] = value
                    SaveConfig(self._window._saveFile)

                    if sliderConfig.Callback then
                        pcall(sliderConfig.Callback, value)
                    end
                end

                -- Input
                local sliding = false
                local clickArea = Instance.new("TextButton")
                clickArea.Size      = UDim2.new(1, 0, 1, 0)
                clickArea.BackgroundTransparency = 1
                clickArea.Text      = ""
                clickArea.ZIndex    = 18
                clickArea.Parent    = track

                clickArea.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                    end
                end)

                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(inp)
                    if sliding and (
                        inp.UserInputType == Enum.UserInputType.MouseMovement
                        or inp.UserInputType == Enum.UserInputType.Touch
                    ) then
                        local absPos  = track.AbsolutePosition
                        local absSize = track.AbsoluteSize
                        local pct     = math.clamp((inp.Position.X - absPos.X) / absSize.X, 0, 1)
                        SetValue(min + pct * (max - min))
                    end
                end)

                -- Initial
                if sliderConfig.Callback and value ~= min then
                    pcall(sliderConfig.Callback, value)
                end

                local sliderObj = {}
                function sliderObj:Set(v) SetValue(v) end
                function sliderObj:Get() return value end
                return sliderObj
            end

            -- ========================
            -- DROPDOWN
            -- ========================
            function tabObj:AddDropdown(dropConfig)
                dropConfig = dropConfig or {}
                local name     = dropConfig.Name    or "Dropdown"
                local options  = dropConfig.Options or {}
                local default  = dropConfig.Default or (options[1] or "")
                local saveId   = dropConfig.Flag    or name
                local multi    = dropConfig.Multi   or false

                if LibState.SaveData[saveId] ~= nil then
                    default = LibState.SaveData[saveId]
                end

                local selected = default
                local open = false
                local el = BaseElement(38)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size        = UDim2.new(0.5, -10, 1, 0)
                nameLbl.Position    = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text        = name
                nameLbl.TextColor3  = T.Text
                nameLbl.Font        = Enum.Font.Gotham
                nameLbl.TextSize    = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex      = 15
                nameLbl.Parent      = el

                local valDisplay = Instance.new("TextButton")
                valDisplay.Size     = UDim2.new(0.5, -10, 0, 28)
                valDisplay.Position = UDim2.new(0.5, 0, 0.5, -14)
                valDisplay.BackgroundColor3 = T.Tab
                valDisplay.BorderSizePixel = 0
                valDisplay.Text     = tostring(selected) .. " ▾"
                valDisplay.TextColor3 = T.Text
                valDisplay.Font     = Enum.Font.Gotham
                valDisplay.TextSize = 11
                valDisplay.ZIndex   = 15
                Utility.Corner(valDisplay, 6)
                Utility.Stroke(valDisplay, T.Border, 1, 0.4)
                valDisplay.Parent   = el

                -- Dropdown list
                local dropList = Instance.new("Frame")
                dropList.Size       = UDim2.new(0.5, -10, 0, 0)
                dropList.Position   = UDim2.new(0.5, 0, 1, 4)
                dropList.BackgroundColor3 = T.Tab
                dropList.BorderSizePixel = 0
                dropList.ZIndex     = 20
                dropList.ClipsDescendants = true
                Utility.Corner(dropList, 6)
                Utility.Stroke(dropList, T.Border, 1, 0.3)
                dropList.Parent     = el

                local dropLayout = Instance.new("UIListLayout")
                dropLayout.Padding  = UDim.new(0, 2)
                dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropLayout.Parent   = dropList

                local function RefreshOptions()
                    for _, c in ipairs(dropList:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size         = UDim2.new(1, 0, 0, 26)
                        optBtn.BackgroundColor3 = (opt == selected) and T.ElementHover or T.Tab
                        optBtn.BorderSizePixel = 0
                        optBtn.Text         = tostring(opt)
                        optBtn.TextColor3   = (opt == selected) and T.Text or T.TextMuted
                        optBtn.Font         = Enum.Font.Gotham
                        optBtn.TextSize     = 11
                        optBtn.ZIndex       = 21
                        Utility.Corner(optBtn, 5)
                        optBtn.Parent       = dropList

                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            valDisplay.Text = tostring(selected) .. " ▾"
                            LibState.SaveData[saveId] = selected
                            SaveConfig(self._window._saveFile)
                            if dropConfig.Callback then
                                pcall(dropConfig.Callback, selected)
                            end
                            -- Close
                            open = false
                            Utility.Tween(dropList, {Size = UDim2.new(0.5, -10, 0, 0)}, 0.2)
                            RefreshOptions()
                        end)
                    end
                end
                RefreshOptions()

                valDisplay.MouseButton1Click:Connect(function()
                    open = not open
                    local targetH = open and math.min(#options * 28 + (#options-1)*2, 150) or 0
                    Utility.Tween(dropList, {Size = UDim2.new(0.5, -10, 0, targetH)}, 0.2)
                end)

                local dropObj = {}
                function dropObj:Set(v)
                    selected = v
                    valDisplay.Text = tostring(selected) .. " ▾"
                end
                function dropObj:Get() return selected end
                function dropObj:Refresh(newOptions)
                    options = newOptions
                    RefreshOptions()
                end
                return dropObj
            end

            -- ========================
            -- TEXTBOX
            -- ========================
            function tabObj:AddTextbox(tbConfig)
                tbConfig = tbConfig or {}
                local name    = tbConfig.Name    or "Textbox"
                local placeholder = tbConfig.Placeholder or "Enter text..."
                local default = tbConfig.Default or ""
                local saveId  = tbConfig.Flag    or name

                if LibState.SaveData[saveId] ~= nil then
                    default = LibState.SaveData[saveId]
                end

                local el = BaseElement(54)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size        = UDim2.new(1, -10, 0, 18)
                nameLbl.Position    = UDim2.new(0, 10, 0, 6)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text        = name
                nameLbl.TextColor3  = T.Text
                nameLbl.Font        = Enum.Font.Gotham
                nameLbl.TextSize    = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex      = 15
                nameLbl.Parent      = el

                local inputBg = Instance.new("Frame")
                inputBg.Size        = UDim2.new(1, -20, 0, 26)
                inputBg.Position    = UDim2.new(0, 10, 0, 24)
                inputBg.BackgroundColor3 = T.Tab
                inputBg.BorderSizePixel = 0
                Utility.Corner(inputBg, 6)
                Utility.Stroke(inputBg, T.Border, 1, 0.4)
                inputBg.ZIndex      = 15
                inputBg.Parent      = el

                local inputBox = Instance.new("TextBox")
                inputBox.Size       = UDim2.new(1, -12, 1, 0)
                inputBox.Position   = UDim2.new(0, 6, 0, 0)
                inputBox.BackgroundTransparency = 1
                inputBox.PlaceholderText = placeholder
                inputBox.PlaceholderColor3 = T.TextMuted
                inputBox.Text       = default
                inputBox.TextColor3 = T.Text
                inputBox.Font       = Enum.Font.Gotham
                inputBox.TextSize   = 12
                inputBox.ClearTextOnFocus = false
                inputBox.ZIndex     = 16
                inputBox.Parent     = inputBg

                inputBox.FocusLost:Connect(function()
                    LibState.SaveData[saveId] = inputBox.Text
                    SaveConfig(self._window._saveFile)
                    if tbConfig.Callback then
                        pcall(tbConfig.Callback, inputBox.Text)
                    end
                end)
                inputBox.Focused:Connect(function()
                    Utility.Tween(inputBg, {}, 0.1)
                    Utility.Stroke(inputBg, T.Accent, 1, 0.2)
                end)

                local tbObj = {}
                function tbObj:Set(v) inputBox.Text = v end
                function tbObj:Get() return inputBox.Text end
                return tbObj
            end

            -- ========================
            -- KEYBIND
            -- ========================
            function tabObj:AddKeybind(kbConfig)
                kbConfig = kbConfig or {}
                local name    = kbConfig.Name    or "Keybind"
                local default = kbConfig.Default or Enum.KeyCode.Unknown
                local saveId  = kbConfig.Flag    or name

                if LibState.SaveData[saveId] then
                    pcall(function()
                        default = Enum.KeyCode[LibState.SaveData[saveId]] or default
                    end)
                end

                local key = default
                local listening = false
                local el = BaseElement(38)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size        = UDim2.new(0.6, -10, 1, 0)
                nameLbl.Position    = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text        = name
                nameLbl.TextColor3  = T.Text
                nameLbl.Font        = Enum.Font.Gotham
                nameLbl.TextSize    = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex      = 15
                nameLbl.Parent      = el

                local keyBtn = Instance.new("TextButton")
                keyBtn.Size         = UDim2.new(0, 80, 0, 26)
                keyBtn.Position     = UDim2.new(1, -90, 0.5, -13)
                keyBtn.BackgroundColor3 = T.Tab
                keyBtn.BorderSizePixel = 0
                keyBtn.Text         = key.Name
                keyBtn.TextColor3   = T.Accent
                keyBtn.Font         = Enum.Font.GothamBold
                keyBtn.TextSize     = 11
                keyBtn.ZIndex       = 15
                Utility.Corner(keyBtn, 6)
                Utility.Stroke(keyBtn, T.Border, 1, 0.3)
                keyBtn.Parent       = el

                keyBtn.MouseButton1Click:Connect(function()
                    listening       = true
                    keyBtn.Text     = "..."
                    keyBtn.TextColor3 = T.TextMuted
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if listening and not gp then
                        if inp.UserInputType == Enum.UserInputType.Keyboard then
                            key         = inp.KeyCode
                            listening   = false
                            keyBtn.Text = key.Name
                            keyBtn.TextColor3 = T.Accent
                            LibState.SaveData[saveId] = key.Name
                            SaveConfig(self._window._saveFile)
                            if kbConfig.Callback then
                                pcall(kbConfig.Callback, key)
                            end
                        end
                    elseif not listening and not gp then
                        if inp.UserInputType == Enum.UserInputType.Keyboard
                        and inp.KeyCode == key then
                            if kbConfig.OnPress then
                                pcall(kbConfig.OnPress)
                            end
                        end
                    end
                end)

                local kbObj = {}
                function kbObj:Set(k) key = k; keyBtn.Text = k.Name end
                function kbObj:Get() return key end
                return kbObj
            end

            -- ========================
            -- COLOR PICKER
            -- ========================
            function tabObj:AddColorPicker(cpConfig)
                cpConfig = cpConfig or {}
                local name    = cpConfig.Name    or "Color Picker"
                local default = cpConfig.Default or Color3.fromRGB(255,80,150)
                local saveId  = cpConfig.Flag    or name

                if LibState.SaveData[saveId] then
                    pcall(function()
                        local d = LibState.SaveData[saveId]
                        default = Color3.fromRGB(d[1], d[2], d[3])
                    end)
                end

                local color = default
                local open  = false
                local el = BaseElement(38)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size        = UDim2.new(1, -58, 1, 0)
                nameLbl.Position    = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text        = name
                nameLbl.TextColor3  = T.Text
                nameLbl.Font        = Enum.Font.Gotham
                nameLbl.TextSize    = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex      = 15
                nameLbl.Parent      = el

                local preview = Instance.new("TextButton")
                preview.Size        = UDim2.new(0, 38, 0, 26)
                preview.Position    = UDim2.new(1, -46, 0.5, -13)
                preview.BackgroundColor3 = color
                preview.BorderSizePixel = 0
                preview.Text        = ""
                preview.ZIndex      = 15
                Utility.Corner(preview, 7)
                Utility.Stroke(preview, T.Border, 1, 0.3)
                preview.Parent = el

                -- Simple RGB picker panel
                local panel = Instance.new("Frame")
                panel.Size          = UDim2.new(1, -20, 0, 0)
                panel.Position      = UDim2.new(0, 10, 1, 4)
                panel.BackgroundColor3 = T.Tab
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.ZIndex        = 20
                Utility.Corner(panel, 8)
                Utility.Stroke(panel, T.Border, 1, 0.4)
                panel.Parent        = el

                local r,g,b = math.round(color.R*255), math.round(color.G*255), math.round(color.B*255)

                local function MakeChannelSlider(label, initVal, yPos, callback)
                    local lbl = Instance.new("TextLabel")
                    lbl.Size        = UDim2.new(0, 14, 0, 16)
                    lbl.Position    = UDim2.new(0, 8, 0, yPos)
                    lbl.BackgroundTransparency = 1
                    lbl.Text        = label
                    lbl.TextColor3  = T.TextMuted
                    lbl.Font        = Enum.Font.GothamBold
                    lbl.TextSize    = 10
                    lbl.ZIndex      = 21
                    lbl.Parent      = panel

                    local track = Instance.new("Frame")
                    track.Size      = UDim2.new(1, -60, 0, 6)
                    track.Position  = UDim2.new(0, 24, 0, yPos + 5)
                    track.BackgroundColor3 = T.Border
                    track.BorderSizePixel = 0
                    Utility.Corner(track, 3)
                    track.ZIndex    = 21
                    track.Parent    = panel

                    local fill = Instance.new("Frame")
                    fill.Size       = UDim2.new(initVal/255, 0, 1, 0)
                    fill.BackgroundColor3 = T.Accent
                    fill.BorderSizePixel = 0
                    Utility.Corner(fill, 3)
                    fill.ZIndex     = 22
                    fill.Parent     = track

                    local valLbl = Instance.new("TextLabel")
                    valLbl.Size     = UDim2.new(0, 28, 0, 16)
                    valLbl.Position = UDim2.new(1, -32, 0, yPos)
                    valLbl.BackgroundTransparency = 1
                    valLbl.Text     = tostring(initVal)
                    valLbl.TextColor3 = T.Text
                    valLbl.Font     = Enum.Font.Gotham
                    valLbl.TextSize = 10
                    valLbl.ZIndex   = 21
                    valLbl.Parent   = panel

                    local sliding = false
                    local clk = Instance.new("TextButton")
                    clk.Size        = UDim2.new(1, 0, 1, 0)
                    clk.BackgroundTransparency = 1
                    clk.Text        = ""
                    clk.ZIndex      = 23
                    clk.Parent      = track

                    clk.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1
                        or inp.UserInputType == Enum.UserInputType.Touch then
                            sliding = true
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(inp)
                        if sliding and (
                            inp.UserInputType == Enum.UserInputType.MouseMovement
                            or inp.UserInputType == Enum.UserInputType.Touch
                        ) then
                            local pct = math.clamp((inp.Position.X - track.AbsolutePosition.X)/track.AbsoluteSize.X, 0, 1)
                            local v = math.round(pct * 255)
                            fill.Size = UDim2.new(pct, 0, 1, 0)
                            valLbl.Text = tostring(v)
                            callback(v)
                        end
                    end)
                end

                MakeChannelSlider("R", r, 8, function(v)
                    r = v; color = Color3.fromRGB(r,g,b)
                    preview.BackgroundColor3 = color
                    LibState.SaveData[saveId] = {r,g,b}
                    SaveConfig(self._window._saveFile)
                    if cpConfig.Callback then pcall(cpConfig.Callback, color) end
                end)
                MakeChannelSlider("G", g, 30, function(v)
                    g = v; color = Color3.fromRGB(r,g,b)
                    preview.BackgroundColor3 = color
                    LibState.SaveData[saveId] = {r,g,b}
                    SaveConfig(self._window._saveFile)
                    if cpConfig.Callback then pcall(cpConfig.Callback, color) end
                end)
                MakeChannelSlider("B", b, 52, function(v)
                    b = v; color = Color3.fromRGB(r,g,b)
                    preview.BackgroundColor3 = color
                    LibState.SaveData[saveId] = {r,g,b}
                    SaveConfig(self._window._saveFile)
                    if cpConfig.Callback then pcall(cpConfig.Callback, color) end
                end)

                preview.MouseButton1Click:Connect(function()
                    open = not open
                    local targetH = open and 84 or 0
                    el.Size = UDim2.new(1, -4, 0, open and 130 or 38)
                    Utility.Tween(panel, {Size = UDim2.new(1, -20, 0, targetH)}, 0.2)
                    UpdateCanvas()
                end)

                local cpObj = {}
                function cpObj:Set(c)
                    color = c
                    r,g,b = math.round(c.R*255), math.round(c.G*255), math.round(c.B*255)
                    preview.BackgroundColor3 = color
                end
                function cpObj:Get() return color end
                return cpObj
            end

            -- ========================
            -- NOTIFICATION (tab-level helper)
            -- ========================
            function tabObj:Notify(title, message, notifType, duration)
                ShowNotification(title, message, notifType, duration)
            end

            return tabObj
        end -- AddTab

        -- ========================
        -- ADD CONFIG TAB
        -- ========================
        function WindowObj:AddConfig()
            local configTab = self:AddTab({Name = "⚙ Config", Icon = ""})

            configTab:AddSection({Name = "Theme"})

            -- Theme dropdown
            local themeNames = {}
            for k in pairs(Themes) do table.insert(themeNames, k) end
            table.sort(themeNames)

            configTab:AddDropdown({
                Name    = "Theme",
                Options = themeNames,
                Default = LibState.ThemeName,
                Callback = function(selected)
                    if Themes[selected] then
                        LibState.Theme     = Themes[selected]
                        LibState.ThemeName = selected
                        ShowNotification("Theme", "Theme changed to " .. selected .. ". Reload to apply fully.", "info", 3)
                    end
                end,
            })

            configTab:AddSection({Name = "Transparency"})

            configTab:AddToggle({
                Name    = "Transparent Background",
                Default = LibState.TransparentBg,
                Callback = function(v)
                    LibState.TransparentBg = v
                    Utility.Tween(window, {
                        BackgroundTransparency = v and 0.4 or 0
                    }, 0.3)
                end,
            })

            configTab:AddSection({Name = "Auto Save"})

            configTab:AddToggle({
                Name    = "Auto Save & Load",
                Default = LibState.AutoSaveLoad,
                Callback = function(v)
                    LibState.AutoSaveLoad = v
                    ShowNotification(
                        "Auto Save",
                        v and "Auto Save enabled." or "Auto Save disabled.",
                        v and "success" or "info",
                        3
                    )
                end,
            })

            configTab:AddButton({
                Name = "Save Config Now",
                Callback = function()
                    SaveConfig(windowData.SaveFileName)
                    ShowNotification("Saved", "Configuration saved successfully.", "success", 3)
                end,
            })

            configTab:AddButton({
                Name = "Reset Config",
                Callback = function()
                    LibState.SaveData = {}
                    SaveConfig(windowData.SaveFileName)
                    ShowNotification("Reset", "Configuration reset. Reload to apply.", "info", 3)
                end,
            })

            return configTab
        end

        -- ========================
        -- NOTIFICATION (window-level)
        -- ========================
        function WindowObj:Notify(title, message, notifType, duration)
            ShowNotification(title, message, notifType, duration)
        end

        table.insert(LibState.Windows, WindowObj)
        return WindowObj
    end -- BuildWindow

    -- ---- Flow Control ----
    -- Show key system if enabled, then loading, then UI
    local function ShowUI()
        -- Loading screen
        CreateLoadingScreen({
            LoadingName = windowData.LoadingName,
            ImageId     = windowData.ImageId,
        }, function()
            BuildWindow()
        end)
    end

    if windowData.KeyEnable then
        -- Check if key already saved
        local keyAlreadyValid = false
        if windowData.KeySave and windowData.KeyFileName then
            local savedRaw = Utility.ReadFile(windowData.KeyFileName)
            if savedRaw then
                local ok, savedData = pcall(HttpService.JSONDecode, HttpService, savedRaw)
                if ok and savedData and savedData.key == windowData.Key then
                    keyAlreadyValid = true
                end
            end
        end

        if keyAlreadyValid then
            ShowUI()
        else
            CreateKeySystem({
                Key             = windowData.Key,
                KeyName         = windowData.KeyName,
                KeySave         = windowData.KeySave,
                KeyFileName     = windowData.KeyFileName,
                GetKeyFromSite  = windowData.GetKeyFromSite,
                KeySite         = windowData.KeySite,
                ImageId         = windowData.ImageId,
            }, ShowUI)
        end
    else
        ShowUI()
    end

    -- Return a proxy object that resolves when window is built
    -- For immediate-use scripts, we return a temporary object
    -- that queues element additions
    local proxy = {}
    local queue = {}
    local realWindow = nil

    setmetatable(proxy, {
        __index = function(_, k)
            return function(self, ...)
                if realWindow and realWindow[k] then
                    return realWindow[k](realWindow, ...)
                else
                    table.insert(queue, {k, {...}})
                end
            end
        end
    })

    -- Patch BuildWindow to set realWindow and flush queue
    local _origBuild = BuildWindow
    BuildWindow = function()
        local w = _origBuild()
        realWindow = w
        for _, item in ipairs(queue) do
            local method = item[1]
            local args   = item[2]
            if w[method] then
                w[method](w, table.unpack(args))
            end
        end
        return w
    end

    -- Re-run the flow with patched BuildWindow
    -- (Reset and re-trigger)
    BuildWindow = _origBuild

    -- Simply return the window object directly from BuildWindow via the flow
    -- Since the flow is async (loading screen), return a deferred-resolution API:
    local deferredWindow = setmetatable({}, {
        __index = function(t, k)
            -- After loading completes, the real window will be accessible
            -- For synchronous-looking API, we store methods and proxy them
            return function(self, ...)
                -- Queue or call directly
                if rawget(t, "_real") then
                    local real = rawget(t, "_real")
                    if real[k] then
                        return real[k](real, ...)
                    end
                else
                    local calls = rawget(t, "_queue") or {}
                    table.insert(calls, {method=k, args={...}})
                    rawset(t, "_queue", calls)
                end
            end
        end
    })

    -- Override BuildWindow to resolve deferred
    local _flow = function()
        CreateLoadingScreen({
            LoadingName = windowData.LoadingName,
            ImageId     = windowData.ImageId,
        }, function()
            local w = BuildWindow()
            rawset(deferredWindow, "_real", w)
            -- Flush queued calls
            local q = rawget(deferredWindow, "_queue") or {}
            for _, call in ipairs(q) do
                if w[call.method] then
                    w[call.method](w, table.unpack(call.args))
                end
            end
        end)
    end

    if windowData.KeyEnable then
        local keyAlreadyValid2 = false
        if windowData.KeySave and windowData.KeyFileName then
            local savedRaw = Utility.ReadFile(windowData.KeyFileName)
            if savedRaw then
                local ok, savedData = pcall(HttpService.JSONDecode, HttpService, savedRaw)
                if ok and savedData and savedData.key == windowData.Key then
                    keyAlreadyValid2 = true
                end
            end
        end

        if keyAlreadyValid2 then
            _flow()
        else
            CreateKeySystem({
                Key             = windowData.Key,
                KeyName         = windowData.KeyName,
                KeySave         = windowData.KeySave,
                KeyFileName     = windowData.KeyFileName,
                GetKeyFromSite  = windowData.GetKeyFromSite,
                KeySite         = windowData.KeySite,
                ImageId         = windowData.ImageId,
            }, _flow)
        end
    else
        _flow()
    end

    return deferredWindow
end

-- ============================================================
-- STANDALONE NOTIFY
-- ============================================================
function NeonLira:Notify(title, message, notifType, duration)
    ShowNotification(title, message, notifType, duration)
end

-- ============================================================
-- INIT
-- ============================================================
GetOrCreateScreenGui()

-- ============================================================
-- RETURN LIBRARY
-- ============================================================
return NeonLira

--[[
===============================================================================
  USAGE EXAMPLE
===============================================================================

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Elison999/Neon-Lira-V2-lib/refs/heads/main/Library.Lua"))()

local Window = lib:CreateWindow({
    Name         = "Lol Hub",
    ImageId      = "1234567891",
    LoadingName  = "Loading Lol Hub",
    Theme        = "Dark",           -- "Dark","Light","Midnight","Sunset","Ocean","Cyber","Rose","Arctic","Neon","Slate"
    KeyEnable    = false,
    Key          = "1234",
    KeyName      = "LolHub Key",
    KeySave      = false,
    KeyFileName  = "LolHub.json",
    GetKeyFromSite = false,
    KeySite      = "https://pastebin.com/...",
    AutoSaveLoad = true,
    SaveFileName = "LolHub_Config.json",
    Size         = {Width=520, Height=420},
})

-- Must wait for window to fully load if using deferred API
task.wait(3) -- adjust based on loading duration

local MainTab = Window:AddTab({Name = "Main", Icon = "🏠"})

MainTab:AddSection({Name = "Player"})

MainTab:AddButton({
    Name = "Say Hello",
    Callback = function()
        print("Hello from NeonLira!")
    end,
})

local speedToggle = MainTab:AddToggle({
    Name    = "Speed Hack",
    Default = false,
    Flag    = "SpeedHack",
    Callback = function(v)
        print("Speed:", v)
    end,
})

local speedSlider = MainTab:AddSlider({
    Name    = "Walk Speed",
    Min     = 16,
    Max     = 200,
    Default = 16,
    Suffix  = " speed",
    Flag    = "WalkSpeed",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

MainTab:AddDropdown({
    Name    = "Team",
    Options = {"Red","Blue","Green","Yellow"},
    Default = "Red",
    Flag    = "TeamSelect",
    Callback = function(v)
        print("Team:", v)
    end,
})

MainTab:AddKeybind({
    Name    = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Flag    = "ToggleUI",
    OnPress = function()
        print("UI toggled!")
    end,
})

MainTab:AddColorPicker({
    Name    = "Trail Color",
    Default = Color3.fromRGB(100, 60, 255),
    Flag    = "TrailColor",
    Callback = function(c)
        print("Color:", c)
    end,
})

MainTab:AddTextbox({
    Name        = "Custom Message",
    Placeholder = "Type here...",
    Default     = "",
    Flag        = "CustomMsg",
    Callback    = function(v)
        print("Text:", v)
    end,
})

MainTab:AddParagraph({
    Title   = "About",
    Content = "NeonLira UI Library v2.0 — Fast, modern, mobile-friendly.",
})

-- Config tab (auto-generates settings)
Window:AddConfig()

-- Notification example
Window:Notify("Welcome!", "NeonLira loaded successfully.", "success", 4)

===============================================================================
]]
