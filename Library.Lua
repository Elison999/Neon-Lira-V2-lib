--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗     ██╗██████╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║     ██║██╔══██╗
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║     ██║██████╔╝
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║     ██║██╔══██╗
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ███████╗██║██████╔╝
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚══════╝╚═╝╚═════╝
    
    NexusLib v1.0 — UI Library for Roblox
    Mobile-first · Modern · Feature-complete
    
    USAGE:
    
    local Nexus = loadstring(...)()
    
    local Window = Nexus:CreateWindow({
        Name        = "My Hub",
        ImageId     = "rbxassetid://12345678",
        LoadingName = "Loading My Hub",
        LoadingImage= "rbxassetid://12345678",
        KeyEnable   = false,
        Key         = "1234",
        KeyName     = "Key System",
        KeySave     = false,
        KeyFileName = "MyHub.json",
        GetKeyFromSite = false,
        KeySite     = "https://pastebin.com/raw/...",
        AutoLoadKey = true,
        AutoSaveLoad= true,
    })
    
    local Tab = Window:AddTab({ Name = "Main", ImageId = "rbxassetid://..." })
    
    Tab:AddToggle({ Name="God Mode", Default=false, Callback=function(v) end })
    Tab:AddButton({ Name="Teleport", Callback=function() end })
    Tab:AddSlider({ Name="Speed", Min=0, Max=100, Default=16, Callback=function(v) end })
    Tab:AddTextbox({ Name="Name", Default="Player", Callback=function(v) end })
    Tab:AddLabel("Hello World")
    Tab:AddDropdown({ Name="Team", Options={"Red","Blue"}, Default="Red", Callback=function(v) end })
    Tab:AddColorPicker({ Name="Color", Default=Color3.new(1,1,1), Callback=function(v) end })
    Tab:AddKeybind({ Name="Toggle UI", Default=Enum.KeyCode.RightShift, Callback=function() end })
    Tab:AddParagraph({ Title="Info", Content="Some text here" })
    Tab:AddInput({ Name="Value", Default="", Callback=function(v) end })
    Tab:AddSection("Combat")
    Tab:AddProgressBar({ Name="XP", Value=0.75 })
    
    Window:AddConfig()  -- adds Config tab automatically
]]

-- ════════════════════════════════════════════════════════════════════════════
--  SERVICES & UTILS
-- ════════════════════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local function Tween(obj, t, props, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
end

local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color        = color or Color3.fromRGB(60,60,60),
        Thickness    = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function AddPadding(parent, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft   = UDim.new(0, left   or 8),
        PaddingRight  = UDim.new(0, right  or 8),
    }, parent)
end

local function AddListLayout(parent, dir, padding, align)
    return Create("UIListLayout", {
        FillDirection       = dir    or Enum.FillDirection.Vertical,
        Padding             = UDim.new(0, padding or 6),
        HorizontalAlignment = align  or Enum.HorizontalAlignment.Left,
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }, parent)
end

-- ════════════════════════════════════════════════════════════════════════════
--  THEMES
-- ════════════════════════════════════════════════════════════════════════════
local Themes = {
    ["Noir"] = {
        Background  = Color3.fromRGB(10,  10,  10),
        TopBar      = Color3.fromRGB(18,  18,  18),
        Card        = Color3.fromRGB(22,  22,  22),
        Accent      = Color3.fromRGB(255, 255, 255),
        AccentDim   = Color3.fromRGB(180, 180, 180),
        Text        = Color3.fromRGB(230, 230, 230),
        SubText     = Color3.fromRGB(110, 110, 110),
        Toggle      = Color3.fromRGB(255, 255, 255),
        ToggleKnob  = Color3.fromRGB(10,  10,  10),
        Stroke      = Color3.fromRGB(50,  50,  50),
        TabActive   = Color3.fromRGB(255, 255, 255),
        TabInactive = Color3.fromRGB(50,  50,  50),
    },
    ["Obsidian"] = {
        Background  = Color3.fromRGB(13,  13,  20),
        TopBar      = Color3.fromRGB(20,  20,  32),
        Card        = Color3.fromRGB(26,  26,  40),
        Accent      = Color3.fromRGB(120, 100, 255),
        AccentDim   = Color3.fromRGB(80,  60,  200),
        Text        = Color3.fromRGB(220, 220, 240),
        SubText     = Color3.fromRGB(100, 100, 140),
        Toggle      = Color3.fromRGB(120, 100, 255),
        ToggleKnob  = Color3.fromRGB(255, 255, 255),
        Stroke      = Color3.fromRGB(50,  50,  80),
        TabActive   = Color3.fromRGB(120, 100, 255),
        TabInactive = Color3.fromRGB(40,  40,  60),
    },
    ["Crimson"] = {
        Background  = Color3.fromRGB(14,  8,   8),
        TopBar      = Color3.fromRGB(22,  12,  12),
        Card        = Color3.fromRGB(28,  16,  16),
        Accent      = Color3.fromRGB(220, 50,  50),
        AccentDim   = Color3.fromRGB(160, 30,  30),
        Text        = Color3.fromRGB(240, 220, 220),
        SubText     = Color3.fromRGB(130, 90,  90),
        Toggle      = Color3.fromRGB(220, 50,  50),
        ToggleKnob  = Color3.fromRGB(255, 255, 255),
        Stroke      = Color3.fromRGB(60,  30,  30),
        TabActive   = Color3.fromRGB(220, 50,  50),
        TabInactive = Color3.fromRGB(50,  25,  25),
    },
    ["Aqua"] = {
        Background  = Color3.fromRGB(6,   18,  22),
        TopBar      = Color3.fromRGB(10,  26,  32),
        Card        = Color3.fromRGB(14,  32,  40),
        Accent      = Color3.fromRGB(0,   210, 210),
        AccentDim   = Color3.fromRGB(0,   150, 150),
        Text        = Color3.fromRGB(200, 240, 240),
        SubText     = Color3.fromRGB(80,  150, 160),
        Toggle      = Color3.fromRGB(0,   210, 210),
        ToggleKnob  = Color3.fromRGB(6,   18,  22),
        Stroke      = Color3.fromRGB(20,  70,  80),
        TabActive   = Color3.fromRGB(0,   210, 210),
        TabInactive = Color3.fromRGB(20,  55,  65),
    },
    ["Forest"] = {
        Background  = Color3.fromRGB(8,   16,  10),
        TopBar      = Color3.fromRGB(12,  24,  14),
        Card        = Color3.fromRGB(16,  30,  18),
        Accent      = Color3.fromRGB(60,  200, 80),
        AccentDim   = Color3.fromRGB(40,  140, 60),
        Text        = Color3.fromRGB(210, 240, 215),
        SubText     = Color3.fromRGB(90,  140, 100),
        Toggle      = Color3.fromRGB(60,  200, 80),
        ToggleKnob  = Color3.fromRGB(8,   16,  10),
        Stroke      = Color3.fromRGB(30,  70,  35),
        TabActive   = Color3.fromRGB(60,  200, 80),
        TabInactive = Color3.fromRGB(25,  55,  28),
    },
    ["Amber"] = {
        Background  = Color3.fromRGB(18,  14,  6),
        TopBar      = Color3.fromRGB(26,  20,  8),
        Card        = Color3.fromRGB(32,  25,  10),
        Accent      = Color3.fromRGB(255, 180, 30),
        AccentDim   = Color3.fromRGB(200, 130, 20),
        Text        = Color3.fromRGB(245, 235, 200),
        SubText     = Color3.fromRGB(160, 130, 70),
        Toggle      = Color3.fromRGB(255, 180, 30),
        ToggleKnob  = Color3.fromRGB(18,  14,  6),
        Stroke      = Color3.fromRGB(80,  60,  20),
        TabActive   = Color3.fromRGB(255, 180, 30),
        TabInactive = Color3.fromRGB(55,  44,  15),
    },
    ["Rose"] = {
        Background  = Color3.fromRGB(18,  10,  14),
        TopBar      = Color3.fromRGB(26,  14,  20),
        Card        = Color3.fromRGB(32,  18,  26),
        Accent      = Color3.fromRGB(255, 100, 160),
        AccentDim   = Color3.fromRGB(200, 60,  120),
        Text        = Color3.fromRGB(245, 215, 230),
        SubText     = Color3.fromRGB(160, 100, 130),
        Toggle      = Color3.fromRGB(255, 100, 160),
        ToggleKnob  = Color3.fromRGB(18,  10,  14),
        Stroke      = Color3.fromRGB(80,  40,  60),
        TabActive   = Color3.fromRGB(255, 100, 160),
        TabInactive = Color3.fromRGB(55,  28,  42),
    },
    ["Arctic"] = {
        Background  = Color3.fromRGB(235, 240, 248),
        TopBar      = Color3.fromRGB(220, 228, 240),
        Card        = Color3.fromRGB(245, 248, 255),
        Accent      = Color3.fromRGB(50,  120, 220),
        AccentDim   = Color3.fromRGB(30,  80,  170),
        Text        = Color3.fromRGB(20,  30,  55),
        SubText     = Color3.fromRGB(100, 120, 160),
        Toggle      = Color3.fromRGB(50,  120, 220),
        ToggleKnob  = Color3.fromRGB(255, 255, 255),
        Stroke      = Color3.fromRGB(190, 200, 220),
        TabActive   = Color3.fromRGB(50,  120, 220),
        TabInactive = Color3.fromRGB(200, 210, 230),
    },
    ["Midnight"] = {
        Background  = Color3.fromRGB(5,   5,   18),
        TopBar      = Color3.fromRGB(8,   8,   28),
        Card        = Color3.fromRGB(12,  12,  36),
        Accent      = Color3.fromRGB(100, 130, 255),
        AccentDim   = Color3.fromRGB(60,  90,  200),
        Text        = Color3.fromRGB(210, 215, 255),
        SubText     = Color3.fromRGB(80,  90,  150),
        Toggle      = Color3.fromRGB(100, 130, 255),
        ToggleKnob  = Color3.fromRGB(5,   5,   18),
        Stroke      = Color3.fromRGB(30,  35,  80),
        TabActive   = Color3.fromRGB(100, 130, 255),
        TabInactive = Color3.fromRGB(22,  24,  60),
    },
    ["Vapor"] = {
        Background  = Color3.fromRGB(12,  6,   20),
        TopBar      = Color3.fromRGB(20,  10,  32),
        Card        = Color3.fromRGB(26,  14,  42),
        Accent      = Color3.fromRGB(255, 80,  200),
        AccentDim   = Color3.fromRGB(180, 40,  140),
        Text        = Color3.fromRGB(240, 210, 255),
        SubText     = Color3.fromRGB(150, 90,  180),
        Toggle      = Color3.fromRGB(255, 80,  200),
        ToggleKnob  = Color3.fromRGB(12,  6,   20),
        Stroke      = Color3.fromRGB(80,  30,  100),
        TabActive   = Color3.fromRGB(255, 80,  200),
        TabInactive = Color3.fromRGB(50,  20,  70),
    },
}

local ThemeOrder = { "Noir","Obsidian","Crimson","Aqua","Forest","Amber","Rose","Arctic","Midnight","Vapor" }

-- ════════════════════════════════════════════════════════════════════════════
--  FILE SYSTEM (writefile / readfile / isfile)
-- ════════════════════════════════════════════════════════════════════════════
local function safeWrite(filename, content)
    if writefile then pcall(writefile, filename, content) end
end
local function safeRead(filename)
    if readfile and isfile then
        local ok, data = pcall(readfile, filename)
        if ok then return data end
    end
    return nil
end
local function safeIsFile(filename)
    if isfile then
        local ok, v = pcall(isfile, filename)
        return ok and v
    end
    return false
end

-- ════════════════════════════════════════════════════════════════════════════
--  NEXUS LIBRARY CORE
-- ════════════════════════════════════════════════════════════════════════════
local NexusLib = {}
NexusLib.__index = NexusLib

function NexusLib:CreateWindow(config)
    config = config or {}

    -- defaults
    local cfg = {
        Name           = config.Name        or "Nexus Hub",
        ImageId        = config.ImageId     or "",
        LoadingName    = config.LoadingName or "Loading...",
        LoadingImage   = config.LoadingImage or config.ImageId or "",
        KeyEnable      = config.KeyEnable   ~= nil and config.KeyEnable   or false,
        Key            = config.Key         or "nexus",
        KeyName        = config.KeyName     or "Key System",
        KeySave        = config.KeySave     ~= nil and config.KeySave     or false,
        KeyFileName    = config.KeyFileName or "NexusKey.json",
        GetKeyFromSite = config.GetKeyFromSite ~= nil and config.GetKeyFromSite or false,
        KeySite        = config.KeySite     or "",
        AutoLoadKey    = config.AutoLoadKey ~= nil and config.AutoLoadKey or true,
        AutoSaveLoad   = config.AutoSaveLoad ~= nil and config.AutoSaveLoad or false,
        Theme          = config.Theme       or "Noir",
    }

    -- destroy old instance
    if CoreGui:FindFirstChild("NexusLib_GUI") then
        CoreGui.NexusLib_GUI:Destroy()
    end
    if PlayerGui:FindFirstChild("NexusLib_GUI") then
        PlayerGui.NexusLib_GUI:Destroy()
    end

    -- ── State ──────────────────────────────────────────────────────────────
    local W = setmetatable({}, { __index = {} })
    local currentTheme = Themes[cfg.Theme] or Themes["Noir"]
    local currentThemeName = cfg.Theme
    local isMinimized = false
    local isTransparent = false
    local saveData = {}
    local saveFileName = "NexusLib_" .. cfg.Name:gsub("%s","_") .. ".json"
    local allElements = {} -- { id, type, setFunc }
    local tabButtons = {}
    local tabFrames  = {}
    local activeTab  = nil
    local keyUnlocked = not cfg.KeyEnable

    -- ── load save data ─────────────────────────────────────────────────────
    if cfg.AutoSaveLoad then
        local raw = safeRead(saveFileName)
        if raw then
            local ok, d = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and type(d) == "table" then saveData = d end
        end
    end

    local function persistSave()
        if cfg.AutoSaveLoad then
            local ok, encoded = pcall(HttpService.JSONEncode, HttpService, saveData)
            if ok then safeWrite(saveFileName, encoded) end
        end
    end

    -- ── ScreenGui ─────────────────────────────────────────────────────────
    local ScreenGui = Create("ScreenGui", {
        Name            = "NexusLib_GUI",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset  = true,
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

    -- ════════════════════════════════════════════════════════════════════
    --  LOADING SCREEN
    -- ════════════════════════════════════════════════════════════════════
    local LoadFrame = Create("Frame", {
        Name              = "LoadScreen",
        Size              = UDim2.new(1, 0, 1, 0),
        Position          = UDim2.new(0, 0, 0, 0),
        BackgroundColor3  = Color3.fromRGB(5, 5, 5),
        BorderSizePixel   = 0,
        ZIndex            = 100,
    }, ScreenGui)

    -- animated bg gradient
    local LoadGrad = Create("UIGradient", {
        Color    = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10,10,10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(2,2,2)),
        }),
        Rotation = 135,
    }, LoadFrame)

    local LoadImg = Create("ImageLabel", {
        Size                  = UDim2.new(0, 80, 0, 80),
        Position              = UDim2.new(0.5, -40, 0.38, 0),
        BackgroundTransparency= 1,
        Image                 = cfg.LoadingImage ~= "" and ("rbxassetid://" .. cfg.LoadingImage:match("%d+")) or "",
        ImageTransparency     = 1,
        ZIndex                = 101,
    }, LoadFrame)
    AddCorner(LoadImg, 16)

    local LoadTitle = Create("TextLabel", {
        Size             = UDim2.new(0, 300, 0, 32),
        Position         = UDim2.new(0.5, -150, 0.5, 10),
        BackgroundTransparency = 1,
        Text             = cfg.LoadingName,
        TextColor3       = Color3.fromRGB(230, 230, 230),
        Font             = Enum.Font.GothamBold,
        TextSize         = 18,
        TextXAlignment   = Enum.TextXAlignment.Center,
        TextTransparency = 1,
        ZIndex           = 101,
    }, LoadFrame)

    local LoadBarBg = Create("Frame", {
        Size            = UDim2.new(0, 220, 0, 4),
        Position        = UDim2.new(0.5, -110, 0.5, 56),
        BackgroundColor3= Color3.fromRGB(35,35,35),
        BorderSizePixel = 0,
        ZIndex          = 101,
    }, LoadFrame)
    AddCorner(LoadBarBg, 2)

    local LoadBarFill = Create("Frame", {
        Size            = UDim2.new(0, 0, 1, 0),
        BackgroundColor3= Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        ZIndex          = 102,
    }, LoadBarBg)
    AddCorner(LoadBarFill, 2)

    local LoadSub = Create("TextLabel", {
        Size             = UDim2.new(0, 300, 0, 20),
        Position         = UDim2.new(0.5, -150, 0.5, 70),
        BackgroundTransparency = 1,
        Text             = "Initializing...",
        TextColor3       = Color3.fromRGB(90,90,90),
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Center,
        TextTransparency = 1,
        ZIndex           = 101,
    }, LoadFrame)

    -- animate loading
    local function runLoadingAnim(callback)
        -- fade in image + title
        Tween(LoadImg,   0.4, { ImageTransparency = 0 }):Play()
        Tween(LoadTitle, 0.4, { TextTransparency = 0 }):Play()
        task.wait(0.3)
        Tween(LoadSub, 0.3, { TextTransparency = 0 }):Play()

        local steps = {
            { t = 0.3, pct = 0.3, msg = "Loading assets..." },
            { t = 0.4, pct = 0.6, msg = "Building interface..." },
            { t = 0.3, pct = 0.85, msg = "Almost ready..." },
            { t = 0.2, pct = 1.0, msg = "Done!" },
        }
        for _, s in ipairs(steps) do
            task.wait(s.t)
            LoadSub.Text = s.msg
            Tween(LoadBarFill, 0.25, { Size = UDim2.new(s.pct, 0, 1, 0) }):Play()
        end
        task.wait(0.4)
        Tween(LoadFrame, 0.5, { BackgroundTransparency = 1 }):Play()
        Tween(LoadImg,   0.4, { ImageTransparency = 1 }):Play()
        Tween(LoadTitle, 0.4, { TextTransparency = 1 }):Play()
        Tween(LoadSub,   0.4, { TextTransparency = 1 }):Play()
        Tween(LoadBarBg, 0.4, { BackgroundTransparency = 1 }):Play()
        Tween(LoadBarFill,0.4,{ BackgroundTransparency = 1 }):Play()
        task.wait(0.5)
        LoadFrame:Destroy()
        if callback then callback() end
    end

    -- ════════════════════════════════════════════════════════════════════
    --  MAIN WINDOW FRAME (hidden initially)
    -- ════════════════════════════════════════════════════════════════════
    local MainFrame = Create("Frame", {
        Name             = "MainFrame",
        Size             = UDim2.new(0, 360, 0, 480),
        Position         = UDim2.new(0.5, -180, 0.5, -240),
        BackgroundColor3 = currentTheme.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        Visible          = false,
    }, ScreenGui)
    AddCorner(MainFrame, 14)

    local MainStroke = AddStroke(MainFrame, currentTheme.Stroke, 1.2, 0.2)

    -- shadow
    local Shadow = Create("ImageLabel", {
        Name                  = "Shadow",
        Size                  = UDim2.new(1, 40, 1, 40),
        Position              = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency= 1,
        Image                 = "rbxassetid://5554236805",
        ImageColor3           = Color3.fromRGB(0,0,0),
        ImageTransparency     = 0.6,
        ScaleType             = Enum.ScaleType.Slice,
        SliceCenter           = Rect.new(23,23,277,277),
        ZIndex                = 0,
    }, MainFrame)

    -- ── TopBar ──────────────────────────────────────────────────────────
    local TopBar = Create("Frame", {
        Name             = "TopBar",
        Size             = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = currentTheme.TopBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
    }, MainFrame)
    AddCorner(TopBar, 14)

    -- bottom-only rounded for topbar (cover bottom corners)
    local TopBarFix = Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = currentTheme.TopBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
    }, TopBar)

    local TopDivider = Create("Frame", {
        Size             = UDim2.new(1, -20, 0, 1),
        Position         = UDim2.new(0, 10, 1, -1),
        BackgroundColor3 = currentTheme.Stroke,
        BorderSizePixel  = 0,
        ZIndex           = 4,
    }, TopBar)

    -- logo image
    local LogoImg = Create("ImageLabel", {
        Size                  = UDim2.new(0, 28, 0, 28),
        Position              = UDim2.new(0, 12, 0.5, -14),
        BackgroundTransparency= 1,
        Image                 = cfg.ImageId ~= "" and ("rbxassetid://" .. cfg.ImageId:match("%d+")) or "",
        ZIndex                = 4,
    }, TopBar)
    AddCorner(LogoImg, 6)

    local titleOffset = cfg.ImageId ~= "" and 50 or 14
    local TitleLbl = Create("TextLabel", {
        Size             = UDim2.new(1, -(titleOffset + 90), 1, 0),
        Position         = UDim2.new(0, titleOffset, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name,
        TextColor3       = currentTheme.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 4,
    }, TopBar)

    -- ── TopBar Buttons ────────────────────────────────────────────────
    local BtnContainer = Create("Frame", {
        Size             = UDim2.new(0, 86, 0, 28),
        Position         = UDim2.new(1, -96, 0.5, -14),
        BackgroundTransparency = 1,
        ZIndex           = 4,
    }, TopBar)
    AddListLayout(BtnContainer, Enum.FillDirection.Horizontal, 4)

    local function makeTopBtn(icon, size)
        local btn = Create("TextButton", {
            Size             = UDim2.new(0, size or 26, 0, 26),
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.88,
            Text             = icon,
            TextColor3       = Color3.fromRGB(180,180,180),
            Font             = Enum.Font.GothamBold,
            TextSize         = 12,
            BorderSizePixel  = 0,
            ZIndex           = 5,
        }, BtnContainer)
        AddCorner(btn, 6)
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.12, { BackgroundTransparency = 0.65 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.12, { BackgroundTransparency = 0.88 }):Play()
        end)
        return btn
    end

    local ResizeBtn  = makeTopBtn("⤢", 26)
    local MinBtn     = makeTopBtn("─", 26)
    local CloseBtn   = makeTopBtn("✕", 26)

    -- ── CLOSE CONFIRM DIALOG ──────────────────────────────────────────
    local ConfirmDialog = Create("Frame", {
        Name             = "ConfirmDialog",
        Size             = UDim2.new(0, 240, 0, 110),
        Position         = UDim2.new(0.5, -120, 0.5, -55),
        BackgroundColor3 = currentTheme.Card,
        BorderSizePixel  = 0,
        Visible          = false,
        ZIndex           = 20,
    }, MainFrame)
    AddCorner(ConfirmDialog, 12)
    AddStroke(ConfirmDialog, currentTheme.Stroke, 1, 0.2)

    Create("TextLabel", {
        Size             = UDim2.new(1, -20, 0, 40),
        Position         = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text             = "Close " .. cfg.Name .. "?",
        TextColor3       = currentTheme.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 21,
    }, ConfirmDialog)

    local CancelBtn2 = Create("TextButton", {
        Size             = UDim2.new(0, 100, 0, 34),
        Position         = UDim2.new(0, 12, 1, -46),
        BackgroundColor3 = currentTheme.Card,
        Text             = "Cancel",
        TextColor3       = currentTheme.SubText,
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        BorderSizePixel  = 0,
        ZIndex           = 21,
    }, ConfirmDialog)
    AddCorner(CancelBtn2, 8)
    AddStroke(CancelBtn2, currentTheme.Stroke, 1, 0.3)

    local YesBtn = Create("TextButton", {
        Size             = UDim2.new(0, 100, 0, 34),
        Position         = UDim2.new(1, -112, 1, -46),
        BackgroundColor3 = Color3.fromRGB(180, 40, 40),
        Text             = "Close",
        TextColor3       = Color3.fromRGB(255,255,255),
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        BorderSizePixel  = 0,
        ZIndex           = 21,
    }, ConfirmDialog)
    AddCorner(YesBtn, 8)

    CloseBtn.MouseButton1Click:Connect(function()
        ConfirmDialog.Visible = true
        Tween(ConfirmDialog, 0.2, { BackgroundTransparency = 0 }, Enum.EasingStyle.Back):Play()
    end)
    CancelBtn2.MouseButton1Click:Connect(function()
        ConfirmDialog.Visible = false
    end)
    YesBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, 0.3, { BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- ── RESIZE ────────────────────────────────────────────────────────
    local sizeStates = {
        UDim2.new(0, 360, 0, 480),
        UDim2.new(0, 420, 0, 540),
        UDim2.new(0, 300, 0, 400),
    }
    local sizeIdx = 1
    ResizeBtn.MouseButton1Click:Connect(function()
        sizeIdx = sizeIdx % #sizeStates + 1
        local ns = sizeStates[sizeIdx]
        Tween(MainFrame, 0.3, {
            Size     = ns,
            Position = UDim2.new(0.5, -ns.X.Offset/2, 0.5, -ns.Y.Offset/2),
        }, Enum.EasingStyle.Back):Play()
    end)

    -- ── MINIMIZE ──────────────────────────────────────────────────────
    local ContentFrame -- declared below, referenced here
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, 0.3, { Size = UDim2.new(0, 360, 0, 46) }, Enum.EasingStyle.Quad):Play()
        else
            local ns = sizeStates[sizeIdx]
            Tween(MainFrame, 0.3, { Size = ns }, Enum.EasingStyle.Back):Play()
        end
    end)

    -- ── DRAG ──────────────────────────────────────────────────────────
    do
        local dragging, dragInput, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if ConfirmDialog.Visible then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging  = true
                dragStart = input.Position
                startPos  = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- ── TAB BAR ──────────────────────────────────────────────────────
    local TabBar = Create("ScrollingFrame", {
        Name             = "TabBar",
        Size             = UDim2.new(1, 0, 0, 38),
        Position         = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = currentTheme.TopBar,
        BorderSizePixel  = 0,
        ScrollBarThickness = 0,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ClipsDescendants = true,
        ZIndex           = 2,
    }, MainFrame)
    AddPadding(TabBar, 0, 0, 8, 8)
    AddListLayout(TabBar, Enum.FillDirection.Horizontal, 4, Enum.HorizontalAlignment.Left)

    local TabDivider2 = Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 0, 84),
        BackgroundColor3 = currentTheme.Stroke,
        BorderSizePixel  = 0,
        ZIndex           = 2,
    }, MainFrame)

    -- ── CONTENT AREA ─────────────────────────────────────────────────
    ContentFrame = Create("ScrollingFrame", {
        Name              = "Content",
        Size              = UDim2.new(1, 0, 1, -86),
        Position          = UDim2.new(0, 0, 0, 86),
        BackgroundTransparency = 1,
        BorderSizePixel   = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = currentTheme.Accent,
        CanvasSize        = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants  = true,
    }, MainFrame)

    -- ═══════════════════════════════════════════════════════════════════
    --  THEME UPDATER
    -- ═══════════════════════════════════════════════════════════════════
    local themeUpdateCallbacks = {}
    local function updateTheme(name)
        local t = Themes[name]
        if not t then return end
        currentTheme = t
        currentThemeName = name
        -- update key frames
        Tween(MainFrame,  0.3, { BackgroundColor3 = t.Background }):Play()
        Tween(TopBar,     0.3, { BackgroundColor3 = t.TopBar }):Play()
        Tween(TopBarFix,  0.3, { BackgroundColor3 = t.TopBar }):Play()
        Tween(TabBar,     0.3, { BackgroundColor3 = t.TopBar }):Play()
        Tween(TitleLbl,   0.3, { TextColor3 = t.Text }):Play()
        Tween(MainStroke, 0.3, { Color = t.Stroke }):Play()
        ContentFrame.ScrollBarImageColor3 = t.Accent
        for _, cb in ipairs(themeUpdateCallbacks) do
            pcall(cb, t)
        end
    end

    -- ═══════════════════════════════════════════════════════════════════
    --  TAB SYSTEM
    -- ═══════════════════════════════════════════════════════════════════
    local function switchTab(tabName)
        for name, frame in pairs(tabFrames) do
            local isActive = (name == tabName)
            frame.Visible = isActive
        end
        for name, btn in pairs(tabButtons) do
            local t = currentTheme
            if name == tabName then
                Tween(btn, 0.15, {
                    BackgroundColor3 = t.TabActive,
                    TextColor3 = (name == tabName) and Color3.fromRGB(5,5,5) or t.Text,
                }):Play()
            else
                Tween(btn, 0.15, {
                    BackgroundColor3 = t.TabInactive,
                    TextColor3 = t.SubText,
                }):Play()
            end
        end
        activeTab = tabName
    end

    table.insert(themeUpdateCallbacks, function(t)
        for name, btn in pairs(tabButtons) do
            if name == activeTab then
                btn.BackgroundColor3 = t.TabActive
                btn.TextColor3 = Color3.fromRGB(5,5,5)
            else
                btn.BackgroundColor3 = t.TabInactive
                btn.TextColor3 = t.SubText
            end
        end
        TabDivider2.BackgroundColor3 = t.Stroke
        TopDivider.BackgroundColor3 = t.Stroke
    end)

    -- ═══════════════════════════════════════════════════════════════════
    --  ELEMENT BUILDER HELPERS
    -- ═══════════════════════════════════════════════════════════════════
    local function makeCard(parent, height)
        local card = Create("Frame", {
            Size             = UDim2.new(1, -16, 0, height or 44),
            BackgroundColor3 = currentTheme.Card,
            BorderSizePixel  = 0,
            ZIndex           = 2,
        }, parent)
        AddCorner(card, 10)
        AddStroke(card, currentTheme.Stroke, 1, 0.5)
        table.insert(themeUpdateCallbacks, function(t)
            Tween(card, 0.2, { BackgroundColor3 = t.Card }):Play()
            card:FindFirstChildOfClass("UIStroke").Color = t.Stroke
        end)
        return card
    end

    local function makeToggleSwitch(parent, state, onToggle)
        local bg = Create("Frame", {
            Size             = UDim2.new(0, 46, 0, 24),
            BackgroundColor3 = state and currentTheme.Toggle or currentTheme.Card,
            BorderSizePixel  = 0,
            ZIndex           = 4,
        }, parent)
        AddCorner(bg, 12)
        AddStroke(bg, state and currentTheme.Accent or currentTheme.Stroke, 1, 0.2)

        local knob = Create("Frame", {
            Size             = UDim2.new(0, 18, 0, 18),
            Position         = state and UDim2.new(0, 25, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = state and currentTheme.ToggleKnob or currentTheme.SubText,
            BorderSizePixel  = 0,
            ZIndex           = 5,
        }, bg)
        AddCorner(knob, 9)

        local hitbox = Create("TextButton", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text             = "",
            ZIndex           = 6,
        }, bg)

        local currentState = state
        local function setToggleState(s, silent)
            currentState = s
            local t = currentTheme
            if s then
                Tween(bg,   0.2, { BackgroundColor3 = t.Toggle }):Play()
                Tween(knob, 0.2, { Position = UDim2.new(0, 25, 0.5, -9), BackgroundColor3 = t.ToggleKnob }):Play()
                bg:FindFirstChildOfClass("UIStroke").Color = t.Accent
            else
                Tween(bg,   0.2, { BackgroundColor3 = t.Card }):Play()
                Tween(knob, 0.2, { Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = t.SubText }):Play()
                bg:FindFirstChildOfClass("UIStroke").Color = t.Stroke
            end
            if not silent and onToggle then onToggle(s) end
        end

        hitbox.MouseButton1Click:Connect(function()
            setToggleState(not currentState)
        end)

        table.insert(themeUpdateCallbacks, function(t)
            if currentState then
                bg.BackgroundColor3 = t.Toggle
                knob.BackgroundColor3 = t.ToggleKnob
                bg:FindFirstChildOfClass("UIStroke").Color = t.Accent
            else
                bg.BackgroundColor3 = t.Card
                knob.BackgroundColor3 = t.SubText
                bg:FindFirstChildOfClass("UIStroke").Color = t.Stroke
            end
        end)

        return bg, setToggleState, function() return currentState end
    end

    -- ═══════════════════════════════════════════════════════════════════
    --  AddTab
    -- ═══════════════════════════════════════════════════════════════════
    local function addTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#tabButtons + 1))
        local imageId = tabConfig.ImageId or ""

        -- Tab button
        local tbtn = Create("TextButton", {
            Size             = UDim2.new(0, 0, 0, 26),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundColor3 = currentTheme.TabInactive,
            Text             = "",
            BorderSizePixel  = 0,
            ZIndex           = 3,
        }, TabBar)
        AddCorner(tbtn, 7)
        AddPadding(tbtn, 0, 0, 10, 10)

        local tabInner = Create("Frame", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex           = 3,
        }, tbtn)
        AddListLayout(tabInner, Enum.FillDirection.Horizontal, 4, Enum.HorizontalAlignment.Center)
        tabInner.VerticalAlignment = Enum.VerticalAlignment.Center

        if imageId ~= "" then
            Create("ImageLabel", {
                Size             = UDim2.new(0, 16, 0, 16),
                BackgroundTransparency = 1,
                Image            = "rbxassetid://" .. imageId:match("%d+"),
                ZIndex           = 4,
                LayoutOrder      = 1,
            }, tabInner)
        end

        local tabLbl = Create("TextLabel", {
            Size             = UDim2.new(0, 0, 1, 0),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text             = tabName,
            TextColor3       = currentTheme.SubText,
            Font             = Enum.Font.GothamBold,
            TextSize          = 12,
            ZIndex           = 4,
            LayoutOrder      = 2,
        }, tabInner)

        -- Tab content frame
        local tabFrame = Create("Frame", {
            Name             = tabName,
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible          = false,
            ZIndex           = 2,
        }, ContentFrame)
        AddPadding(tabFrame, 8, 8, 8, 8)
        local tabLayout = AddListLayout(tabFrame, Enum.FillDirection.Vertical, 6)

        tabButtons[tabName] = tabLbl
        tabFrames[tabName]  = tabFrame

        tbtn.MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)

        -- activate first tab
        if not activeTab then
            switchTab(tabName)
        end

        -- ─────────────────────────────────────────────────────────────
        --  ELEMENT METHODS
        -- ─────────────────────────────────────────────────────────────
        local Tab = {}

        -- ── Toggle ───────────────────────────────────────────────────
        function Tab:AddToggle(opts)
            opts = opts or {}
            local name     = opts.Name     or "Toggle"
            local default  = opts.Default  ~= nil and opts.Default or false
            local callback = opts.Callback or function() end
            local id       = opts.Name or name

            -- auto load
            if cfg.AutoSaveLoad and saveData[id] ~= nil then
                default = saveData[id]
            end

            local card = makeCard(tabFrame, 44)
            card.LayoutOrder = #tabFrame:GetChildren()

            local lbl = Create("TextLabel", {
                Size             = UDim2.new(1, -60, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(lbl, 0.2, { TextColor3 = t.Text }):Play() end)

            local toggleContainer = Create("Frame", {
                Size     = UDim2.new(0, 46, 0, 24),
                Position = UDim2.new(1, -58, 0.5, -12),
                BackgroundTransparency = 1,
                ZIndex   = 3,
            }, card)

            local _, setToggle, getToggle = makeToggleSwitch(toggleContainer, default, function(v)
                saveData[id] = v
                persistSave()
                pcall(callback, v)
            end)

            local element = { Type = "Toggle", Id = id, Set = setToggle, Get = getToggle }
            table.insert(allElements, element)
            return element
        end

        -- ── Button ───────────────────────────────────────────────────
        function Tab:AddButton(opts)
            opts = opts or {}
            local name     = opts.Name     or "Button"
            local callback = opts.Callback or function() end

            local card = makeCard(tabFrame, 44)
            card.LayoutOrder = #tabFrame:GetChildren()

            -- gradient accent line on left
            local accent = Create("Frame", {
                Size             = UDim2.new(0, 3, 0, 22),
                Position         = UDim2.new(0, 0, 0.5, -11),
                BackgroundColor3 = currentTheme.Accent,
                BorderSizePixel  = 0,
                ZIndex           = 3,
            }, card)
            AddCorner(accent, 2)
            table.insert(themeUpdateCallbacks, function(t) Tween(accent,0.2,{BackgroundColor3=t.Accent}):Play() end)

            local lbl = Create("TextLabel", {
                Size             = UDim2.new(1, -30, 1, 0),
                Position         = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.GothamBold,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(lbl,0.2,{TextColor3=t.Text}):Play() end)

            local arrow = Create("TextLabel", {
                Size             = UDim2.new(0, 20, 1, 0),
                Position         = UDim2.new(1, -28, 0, 0),
                BackgroundTransparency = 1,
                Text             = "›",
                TextColor3       = currentTheme.SubText,
                Font             = Enum.Font.GothamBold,
                TextSize         = 18,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(arrow,0.2,{TextColor3=t.SubText}):Play() end)

            local hitbox = Create("TextButton", {
                Size             = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = "",
                ZIndex           = 4,
            }, card)

            hitbox.MouseButton1Click:Connect(function()
                Tween(card, 0.08, { BackgroundColor3 = currentTheme.Accent }):Play()
                task.wait(0.1)
                Tween(card, 0.15, { BackgroundColor3 = currentTheme.Card }):Play()
                pcall(callback)
            end)

            return { Type = "Button" }
        end

        -- ── Slider ───────────────────────────────────────────────────
        function Tab:AddSlider(opts)
            opts = opts or {}
            local name     = opts.Name     or "Slider"
            local min      = opts.Min      or 0
            local max      = opts.Max      or 100
            local default  = opts.Default  or min
            local suffix   = opts.Suffix   or ""
            local callback = opts.Callback or function() end
            local id       = opts.Name or name

            if cfg.AutoSaveLoad and saveData[id] ~= nil then
                default = saveData[id]
            end
            default = math.clamp(default, min, max)

            local card = makeCard(tabFrame, 60)
            card.LayoutOrder = #tabFrame:GetChildren()

            local topRow = Create("Frame", {
                Size             = UDim2.new(1, -20, 0, 22),
                Position         = UDim2.new(0, 10, 0, 10),
                BackgroundTransparency = 1,
                ZIndex           = 3,
            }, card)

            local nameLbl = Create("TextLabel", {
                Size             = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, topRow)
            table.insert(themeUpdateCallbacks, function(t) Tween(nameLbl,0.2,{TextColor3=t.Text}):Play() end)

            local valLbl = Create("TextLabel", {
                Size             = UDim2.new(0.3, 0, 1, 0),
                Position         = UDim2.new(0.7, 0, 0, 0),
                BackgroundTransparency = 1,
                Text             = tostring(default) .. suffix,
                TextColor3       = currentTheme.Accent,
                Font             = Enum.Font.GothamBold,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Right,
                ZIndex           = 3,
            }, topRow)
            table.insert(themeUpdateCallbacks, function(t) Tween(valLbl,0.2,{TextColor3=t.Accent}):Play() end)

            local trackBg = Create("Frame", {
                Size             = UDim2.new(1, -20, 0, 6),
                Position         = UDim2.new(0, 10, 0, 42),
                BackgroundColor3 = Color3.fromRGB(35,35,35),
                BorderSizePixel  = 0,
                ZIndex           = 3,
            }, card)
            AddCorner(trackBg, 3)

            local trackFill = Create("Frame", {
                Size             = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = currentTheme.Accent,
                BorderSizePixel  = 0,
                ZIndex           = 4,
            }, trackBg)
            AddCorner(trackFill, 3)
            table.insert(themeUpdateCallbacks, function(t)
                Tween(trackFill,0.2,{BackgroundColor3=t.Accent}):Play()
            end)

            local knobDot = Create("Frame", {
                Size             = UDim2.new(0, 14, 0, 14),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new((default-min)/(max-min), 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel  = 0,
                ZIndex           = 5,
            }, trackBg)
            AddCorner(knobDot, 7)

            local currentVal = default
            local draggingSlider = false

            local function updateSlider(x)
                local absPos  = trackBg.AbsolutePosition.X
                local absSize = trackBg.AbsoluteSize.X
                local pct     = math.clamp((x - absPos) / absSize, 0, 1)
                local val     = math.floor(min + pct * (max - min) + 0.5)
                currentVal    = val
                trackFill.Size = UDim2.new(pct, 0, 1, 0)
                knobDot.Position = UDim2.new(pct, 0, 0.5, 0)
                valLbl.Text    = tostring(val) .. suffix
                saveData[id]   = val
                persistSave()
                pcall(callback, val)
            end

            local sliderHitbox = Create("TextButton", {
                Size             = UDim2.new(1, 0, 2, 8),
                Position         = UDim2.new(0, 0, -0.5, -4),
                BackgroundTransparency = 1,
                Text             = "",
                ZIndex           = 6,
            }, trackBg)

            sliderHitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    updateSlider(input.Position.X)
                end
            end)
            sliderHitbox.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider then
                    if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                        updateSlider(input.Position.X)
                    end
                end
            end)

            local element = {
                Type = "Slider",
                Id   = id,
                Set  = function(v)
                    v = math.clamp(v, min, max)
                    currentVal = v
                    local pct = (v - min) / (max - min)
                    trackFill.Size = UDim2.new(pct, 0, 1, 0)
                    knobDot.Position = UDim2.new(pct, 0, 0.5, 0)
                    valLbl.Text = tostring(v) .. suffix
                end,
                Get  = function() return currentVal end,
            }
            table.insert(allElements, element)
            return element
        end

        -- ── Textbox ──────────────────────────────────────────────────
        function Tab:AddTextbox(opts)
            opts = opts or {}
            local name     = opts.Name     or "Input"
            local default  = opts.Default  or ""
            local placeholder = opts.Placeholder or "Enter text..."
            local callback = opts.Callback or function() end
            local id       = opts.Name or name

            if cfg.AutoSaveLoad and saveData[id] ~= nil then
                default = saveData[id]
            end

            local card = makeCard(tabFrame, 60)
            card.LayoutOrder = #tabFrame:GetChildren()

            Create("TextLabel", {
                Size             = UDim2.new(1, -20, 0, 20),
                Position         = UDim2.new(0, 10, 0, 8),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.SubText,
                Font             = Enum.Font.Gotham,
                TextSize         = 11,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)

            local inputBg = Create("Frame", {
                Size             = UDim2.new(1, -20, 0, 28),
                Position         = UDim2.new(0, 10, 0, 26),
                BackgroundColor3 = currentTheme.Background,
                BorderSizePixel  = 0,
                ZIndex           = 3,
            }, card)
            AddCorner(inputBg, 7)
            AddStroke(inputBg, currentTheme.Stroke, 1, 0.3)
            table.insert(themeUpdateCallbacks, function(t)
                Tween(inputBg,0.2,{BackgroundColor3=t.Background}):Play()
                inputBg:FindFirstChildOfClass("UIStroke").Color = t.Stroke
            end)

            local tb = Create("TextBox", {
                Size             = UDim2.new(1, -16, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text             = default,
                PlaceholderText  = placeholder,
                TextColor3       = currentTheme.Text,
                PlaceholderColor3= currentTheme.SubText,
                Font             = Enum.Font.Gotham,
                TextSize         = 12,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ZIndex           = 4,
            }, inputBg)
            table.insert(themeUpdateCallbacks, function(t)
                Tween(tb,0.2,{TextColor3=t.Text, PlaceholderColor3=t.SubText}):Play()
            end)

            tb.FocusLost:Connect(function(enter)
                if enter then
                    saveData[id] = tb.Text
                    persistSave()
                    pcall(callback, tb.Text)
                end
            end)

            return { Type = "Textbox", Id = id, Set = function(v) tb.Text = v end, Get = function() return tb.Text end }
        end

        -- ── Label ────────────────────────────────────────────────────
        function Tab:AddLabel(text)
            local card = makeCard(tabFrame, 36)
            card.LayoutOrder = #tabFrame:GetChildren()
            local lbl = Create("TextLabel", {
                Size             = UDim2.new(1, -20, 1, 0),
                Position         = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text             = text or "",
                TextColor3       = currentTheme.SubText,
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(lbl,0.2,{TextColor3=t.SubText}):Play() end)
            return {
                Type = "Label",
                Set  = function(v) lbl.Text = v end,
            }
        end

        -- ── Dropdown ─────────────────────────────────────────────────
        function Tab:AddDropdown(opts)
            opts = opts or {}
            local name     = opts.Name     or "Dropdown"
            local options  = opts.Options  or {}
            local default  = opts.Default  or (options[1] or "")
            local callback = opts.Callback or function() end
            local id       = opts.Name or name
            local multiSelect = opts.Multi or false

            if cfg.AutoSaveLoad and saveData[id] ~= nil then
                default = saveData[id]
            end

            local card = makeCard(tabFrame, 44)
            card.LayoutOrder = #tabFrame:GetChildren()
            card.ClipsDescendants = false

            local nameLbl = Create("TextLabel", {
                Size             = UDim2.new(0.5, 0, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(nameLbl,0.2,{TextColor3=t.Text}):Play() end)

            local selectedLbl = Create("TextLabel", {
                Size             = UDim2.new(0.45, -10, 1, 0),
                Position         = UDim2.new(0.5, 0, 0, 0),
                BackgroundTransparency = 1,
                Text             = default,
                TextColor3       = currentTheme.Accent,
                Font             = Enum.Font.GothamBold,
                TextSize         = 12,
                TextXAlignment   = Enum.TextXAlignment.Right,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(selectedLbl,0.2,{TextColor3=t.Accent}):Play() end)

            Create("TextLabel", {
                Size             = UDim2.new(0, 16, 1, 0),
                Position         = UDim2.new(1, -22, 0, 0),
                BackgroundTransparency = 1,
                Text             = "▾",
                TextColor3       = currentTheme.SubText,
                Font             = Enum.Font.GothamBold,
                TextSize         = 14,
                ZIndex           = 3,
            }, card)

            local dropList = Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = currentTheme.Card,
                BorderSizePixel  = 0,
                Visible          = false,
                ZIndex           = 10,
                ClipsDescendants = true,
            }, card)
            AddCorner(dropList, 8)
            AddStroke(dropList, currentTheme.Stroke, 1, 0.2)
            AddPadding(dropList, 4, 4, 0, 0)
            AddListLayout(dropList, Enum.FillDirection.Vertical, 2)
            table.insert(themeUpdateCallbacks, function(t)
                Tween(dropList,0.2,{BackgroundColor3=t.Card}):Play()
                dropList:FindFirstChildOfClass("UIStroke").Color = t.Stroke
            end)

            local selectedValue = default
            local isOpen = false

            for _, opt in ipairs(options) do
                local optBtn = Create("TextButton", {
                    Size             = UDim2.new(1, -8, 0, 30),
                    BackgroundColor3 = currentTheme.Background,
                    Text             = opt,
                    TextColor3       = opt == selectedValue and currentTheme.Accent or currentTheme.Text,
                    Font             = Enum.Font.Gotham,
                    TextSize         = 12,
                    BorderSizePixel  = 0,
                    ZIndex           = 11,
                }, dropList)
                AddCorner(optBtn, 6)
                table.insert(themeUpdateCallbacks, function(t)
                    Tween(optBtn,0.2,{BackgroundColor3=t.Background}):Play()
                    optBtn.TextColor3 = opt == selectedValue and t.Accent or t.Text
                end)
                optBtn.MouseButton1Click:Connect(function()
                    selectedValue = opt
                    selectedLbl.Text = opt
                    for _, c in ipairs(dropList:GetChildren()) do
                        if c:IsA("TextButton") then
                            c.TextColor3 = (c.Text == opt) and currentTheme.Accent or currentTheme.Text
                        end
                    end
                    isOpen = false
                    Tween(dropList, 0.2, { Size = UDim2.new(1, 0, 0, 0) }):Play()
                    task.wait(0.2)
                    dropList.Visible = false
                    saveData[id] = opt
                    persistSave()
                    pcall(callback, opt)
                end)
            end

            local hitbox = Create("TextButton", {
                Size             = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = "",
                ZIndex           = 4,
            }, card)

            hitbox.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropList.Visible = true
                    local targetH = math.min(#options, 5) * 34 + 8
                    Tween(dropList, 0.2, { Size = UDim2.new(1, 0, 0, targetH) }):Play()
                else
                    Tween(dropList, 0.15, { Size = UDim2.new(1, 0, 0, 0) }):Play()
                    task.delay(0.15, function() dropList.Visible = false end)
                end
            end)

            return {
                Type = "Dropdown",
                Id   = id,
                Set  = function(v)
                    selectedValue = v
                    selectedLbl.Text = v
                end,
                Get  = function() return selectedValue end,
                Refresh = function(newOpts)
                    for _, c in ipairs(dropList:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    options = newOpts
                end,
            }
        end

        -- ── ColorPicker ──────────────────────────────────────────────
        function Tab:AddColorPicker(opts)
            opts = opts or {}
            local name     = opts.Name     or "Color"
            local default  = opts.Default  or Color3.new(1, 1, 1)
            local callback = opts.Callback or function() end
            local id       = opts.Name or name

            local card = makeCard(tabFrame, 44)
            card.LayoutOrder = #tabFrame:GetChildren()

            local nameLbl = Create("TextLabel", {
                Size             = UDim2.new(1, -70, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(nameLbl,0.2,{TextColor3=t.Text}):Play() end)

            local preview = Create("Frame", {
                Size             = UDim2.new(0, 28, 0, 28),
                Position         = UDim2.new(1, -42, 0.5, -14),
                BackgroundColor3 = default,
                BorderSizePixel  = 0,
                ZIndex           = 3,
            }, card)
            AddCorner(preview, 7)
            AddStroke(preview, currentTheme.Stroke, 1, 0.3)

            -- simple hue slider picker popup
            local pickerOpen = false
            local pickerFrame = Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = currentTheme.Card,
                BorderSizePixel  = 0,
                Visible          = false,
                ZIndex           = 10,
                ClipsDescendants = true,
            }, card)
            AddCorner(pickerFrame, 8)
            AddStroke(pickerFrame, currentTheme.Stroke, 1, 0.2)
            table.insert(themeUpdateCallbacks, function(t)
                Tween(pickerFrame,0.2,{BackgroundColor3=t.Card}):Play()
            end)

            -- hue bar
            local hueBar = Create("Frame", {
                Size     = UDim2.new(1, -20, 0, 16),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0,
                ZIndex = 11,
            }, pickerFrame)
            AddCorner(hueBar, 4)
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1,    Color3.fromHSV(1, 1, 1)),
                }),
            }, hueBar)

            local hueKnob = Create("Frame", {
                Size             = UDim2.new(0, 10, 1, 4),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel  = 0,
                ZIndex           = 12,
            }, hueBar)
            AddCorner(hueKnob, 3)
            AddStroke(hueKnob, Color3.fromRGB(0,0,0), 1, 0)

            local currentColor = default
            local currentHue = 0

            local function updateColor(hue)
                currentHue = hue
                local c = Color3.fromHSV(hue, 1, 1)
                currentColor = c
                preview.BackgroundColor3 = c
                hueKnob.Position = UDim2.new(hue, 0, 0.5, 0)
                saveData[id] = { R = c.R, G = c.G, B = c.B }
                persistSave()
                pcall(callback, c)
            end

            local draggingHue = false
            local hueHitbox = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 13,
            }, hueBar)
            hueHitbox.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                    local pct = math.clamp((inp.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    updateColor(pct)
                end
            end)
            hueHitbox.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = false
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if draggingHue then
                    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                        local pct = math.clamp((inp.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        updateColor(pct)
                    end
                end
            end)

            local hitbox = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 4,
            }, card)
            hitbox.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                if pickerOpen then
                    pickerFrame.Visible = true
                    Tween(pickerFrame, 0.2, { Size = UDim2.new(1, 0, 0, 40) }):Play()
                else
                    Tween(pickerFrame, 0.15, { Size = UDim2.new(1, 0, 0, 0) }):Play()
                    task.delay(0.15, function() pickerFrame.Visible = false end)
                end
            end)

            return {
                Type = "ColorPicker",
                Id   = id,
                Set  = function(c) preview.BackgroundColor3 = c; currentColor = c end,
                Get  = function() return currentColor end,
            }
        end

        -- ── Keybind ──────────────────────────────────────────────────
        function Tab:AddKeybind(opts)
            opts = opts or {}
            local name     = opts.Name     or "Keybind"
            local default  = opts.Default  or Enum.KeyCode.Unknown
            local callback = opts.Callback or function() end
            local id       = opts.Name or name

            local card = makeCard(tabFrame, 44)
            card.LayoutOrder = #tabFrame:GetChildren()

            local nameLbl = Create("TextLabel", {
                Size             = UDim2.new(1, -100, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = name,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.Gotham,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(nameLbl,0.2,{TextColor3=t.Text}):Play() end)

            local keyBadge = Create("TextButton", {
                Size             = UDim2.new(0, 72, 0, 28),
                Position         = UDim2.new(1, -80, 0.5, -14),
                BackgroundColor3 = currentTheme.Background,
                Text             = default ~= Enum.KeyCode.Unknown and default.Name or "None",
                TextColor3       = currentTheme.Accent,
                Font             = Enum.Font.GothamBold,
                TextSize         = 11,
                BorderSizePixel  = 0,
                ZIndex           = 3,
            }, card)
            AddCorner(keyBadge, 7)
            AddStroke(keyBadge, currentTheme.Stroke, 1, 0.3)
            table.insert(themeUpdateCallbacks, function(t)
                Tween(keyBadge,0.2,{BackgroundColor3=t.Background, TextColor3=t.Accent}):Play()
            end)

            local currentKey = default
            local listening  = false

            keyBadge.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keyBadge.Text = "..."
                keyBadge.TextColor3 = currentTheme.SubText
                local conn
                conn = UserInputService.InputBegan:Connect(function(inp, gp)
                    if gp then return end
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = inp.KeyCode
                        keyBadge.Text = inp.KeyCode.Name
                        keyBadge.TextColor3 = currentTheme.Accent
                        listening = false
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(inp, gp)
                if gp then return end
                if not listening and inp.KeyCode == currentKey then
                    pcall(callback)
                end
            end)

            return { Type = "Keybind", Id = id, Get = function() return currentKey end }
        end

        -- ── Paragraph ────────────────────────────────────────────────
        function Tab:AddParagraph(opts)
            opts = opts or {}
            local title   = opts.Title   or ""
            local content = opts.Content or ""

            local card = makeCard(tabFrame, 0)
            card.AutomaticSize = Enum.AutomaticSize.Y
            card.LayoutOrder = #tabFrame:GetChildren()
            AddPadding(card, 10, 10, 14, 14)

            local titleLbl = Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text             = title,
                TextColor3       = currentTheme.Text,
                Font             = Enum.Font.GothamBold,
                TextSize         = 13,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextWrapped      = true,
                ZIndex           = 3,
            }, card)
            table.insert(themeUpdateCallbacks, function(t) Tween(titleLbl,0.2,{TextColor3=t.Text}):Play() end)

            local bodyLbl = Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text             = content,
                TextColor3       = currentTheme.SubText,
                Font             = Enum.Font.Gotham,
                TextSize         = 12,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextWrapped      = true,
                ZIndex           = 3,
            }, card)
            AddListLayout(card, Enum.FillDirection.Vertical, 4)
            table.insert(themeUpdateCallbacks, function(t) Tween(bodyLbl,0.2,{TextColor3=t.SubText}):Play() end)

            return {
                Type = "Paragraph",
                SetTitle   = function(v) titleLbl.Text = v end,
                SetContent = function(v) bodyLbl.Text  = v end,
            }
        end

        -- ── Input (alias for Textbox with enter-to-confirm) ──────────
        function Tab:AddInput(opts)
            return self:AddTextbox(opts)
        end

        -- ── Section ──────────────────────────────────────────────────
        function Tab:AddSection(title)
            local sect = Create("Frame", {
                Size             = UDim2.new(1, -16, 0, 28),
                BackgroundTransparency = 1,
                LayoutOrder      = #tabFrame:GetChildren(),
            }, tabFrame)

            local line1 = Create("Frame", {
                Size             = UDim2.new(0.35, 0, 0, 1),
                Position         = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = currentTheme.Stroke,
                BorderSizePixel  = 0,
            }, sect)
            local sLbl = Create("TextLabel", {
                Size             = UDim2.new(0.3, 0, 1, 0),
                Position         = UDim2.new(0.35, 0, 0, 0),
                BackgroundTransparency = 1,
                Text             = title or "",
                TextColor3       = currentTheme.SubText,
                Font             = Enum.Font.GothamBold,
                TextSize         = 11,
                TextXAlignment   = Enum.TextXAlignment.Center,
            }, sect)
            local line2 = Create("Frame", {
                Size             = UDim2.new(0.35, 0, 0, 1),
                Position         = UDim2.new(0.65, 0, 0.5, 0),
                BackgroundColor3 = currentTheme.Stroke,
                BorderSizePixel  = 0,
            }, sect)
            table.insert(themeUpdateCallbacks, function(t)
                line1.BackgroundColor3 = t.Stroke
                line2.BackgroundColor3 = t.Stroke
                Tween(sLbl,0.2,{TextColor3=t.SubText}):Play()
            end)
            return { Type = "Section" }
        end

        -- ── ProgressBar ──────────────────────────────────────────────
        function Tab:AddProgressBar(opts)
            opts = opts or {}
            local name    = opts.Name  or "Progress"
            local value   = opts.Value or 0  -- 0 to 1
            local suffix  = opts.Suffix or "%"

            value = math.clamp(value, 0, 1)

            local card = makeCard(tabFrame, 54)
            card.LayoutOrder = #tabFrame:GetChildren()

            local topRow = Create("Frame", {
                Size             = UDim2.new(1, -20, 0, 20),
                Position         = UDim2.new(0, 10, 0, 8),
                BackgroundTransparency = 1,
                ZIndex           = 3,
            }, card)

            local nLbl = Create("TextLabel", {
                Size = UDim2.new(0.7,0,1,0),
                BackgroundTransparency=1,
                Text=name,TextColor3=currentTheme.Text,
                Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3
            }, topRow)
            table.insert(themeUpdateCallbacks, function(t) Tween(nLbl,0.2,{TextColor3=t.Text}):Play() end)

            local pLbl = Create("TextLabel", {
                Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0.7,0,0,0),
                BackgroundTransparency=1,
                Text=math.floor(value*100)..suffix,
                TextColor3=currentTheme.Accent,Font=Enum.Font.GothamBold,
                TextSize=13,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=3
            }, topRow)
            table.insert(themeUpdateCallbacks, function(t) Tween(pLbl,0.2,{TextColor3=t.Accent}):Play() end)

            local trackBg = Create("Frame", {
                Size=UDim2.new(1,-20,0,8),Position=UDim2.new(0,10,0,36),
                BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0,ZIndex=3
            }, card)
            AddCorner(trackBg, 4)

            local fill = Create("Frame", {
                Size=UDim2.new(value,0,1,0),
                BackgroundColor3=currentTheme.Accent,BorderSizePixel=0,ZIndex=4
            }, trackBg)
            AddCorner(fill, 4)

            -- gradient shine
            Create("UIGradient", {
                Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
                    ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8)),
                }),
                Transparency=NumberSequence.new({
                    NumberSequenceKeypoint.new(0,0.3),
                    NumberSequenceKeypoint.new(1,0.6),
                }),
            }, fill)
            table.insert(themeUpdateCallbacks, function(t) Tween(fill,0.2,{BackgroundColor3=t.Accent}):Play() end)

            return {
                Type = "ProgressBar",
                Set  = function(v)
                    v = math.clamp(v, 0, 1)
                    Tween(fill, 0.3, { Size = UDim2.new(v, 0, 1, 0) }):Play()
                    pLbl.Text = math.floor(v*100) .. suffix
                end,
                Get = function() return value end,
            }
        end

        return Tab
    end

    -- ═══════════════════════════════════════════════════════════════════
    --  CONFIG TAB
    -- ═══════════════════════════════════════════════════════════════════
    local function buildConfigTab()
        local cfgTab = addTab({ Name = "⚙ Config" })

        -- Theme dropdown
        cfgTab:AddSection("Appearance")
        local themeDropdown = cfgTab:AddDropdown({
            Name    = "Theme",
            Options = ThemeOrder,
            Default = currentThemeName,
            Callback = function(v)
                updateTheme(v)
                saveData["__theme"] = v
                persistSave()
            end,
        })

        -- Transparency toggle
        cfgTab:AddToggle({
            Name    = "Background Opacity (60%)",
            Default = false,
            Callback = function(v)
                isTransparent = v
                Tween(MainFrame, 0.3, { BackgroundTransparency = v and 0.4 or 0 }):Play()
            end,
        })

        -- AutoSave toggle
        cfgTab:AddSection("Data")
        cfgTab:AddToggle({
            Name    = "Auto Save & Load",
            Default = cfg.AutoSaveLoad,
            Callback = function(v)
                cfg.AutoSaveLoad = v
                if v then persistSave() end
            end,
        })

        cfgTab:AddButton({
            Name = "Clear Saved Data",
            Callback = function()
                saveData = {}
                safeWrite(saveFileName, "{}")
            end,
        })

        return cfgTab
    end

    -- ═══════════════════════════════════════════════════════════════════
    --  KEY SYSTEM
    -- ═══════════════════════════════════════════════════════════════════
    local function showKeySystem(onSuccess)
        local keyFrame = Create("Frame", {
            Size             = UDim2.new(0, 300, 0, 200),
            Position         = UDim2.new(0.5, -150, 0.5, -100),
            BackgroundColor3 = Color3.fromRGB(12,12,12),
            BorderSizePixel  = 0,
            ZIndex           = 50,
        }, ScreenGui)
        AddCorner(keyFrame, 14)
        AddStroke(keyFrame, Color3.fromRGB(50,50,50), 1, 0.2)

        Create("TextLabel", {
            Size=UDim2.new(1,-20,0,30),Position=UDim2.new(0,10,0,14),
            BackgroundTransparency=1,Text=cfg.KeyName,
            TextColor3=Color3.fromRGB(230,230,230),Font=Enum.Font.GothamBold,
            TextSize=15,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=51
        }, keyFrame)

        Create("TextLabel", {
            Size=UDim2.new(1,-20,0,20),Position=UDim2.new(0,10,0,46),
            BackgroundTransparency=1,Text="Enter your key to continue",
            TextColor3=Color3.fromRGB(100,100,100),Font=Enum.Font.Gotham,
            TextSize=12,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=51
        }, keyFrame)

        local inputBg = Create("Frame", {
            Size=UDim2.new(1,-30,0,36),Position=UDim2.new(0,15,0,76),
            BackgroundColor3=Color3.fromRGB(22,22,22),BorderSizePixel=0,ZIndex=51
        }, keyFrame)
        AddCorner(inputBg, 8)
        AddStroke(inputBg, Color3.fromRGB(50,50,50), 1, 0.3)

        local keyInput = Create("TextBox", {
            Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,PlaceholderText="Enter key...",
            Text="",TextColor3=Color3.fromRGB(200,200,200),
            PlaceholderColor3=Color3.fromRGB(70,70,70),
            Font=Enum.Font.GothamBold,TextSize=13,ZIndex=52
        }, inputBg)

        local statusLbl = Create("TextLabel", {
            Size=UDim2.new(1,-20,0,20),Position=UDim2.new(0,10,0,120),
            BackgroundTransparency=1,Text="",
            TextColor3=Color3.fromRGB(200,60,60),Font=Enum.Font.Gotham,
            TextSize=11,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=51
        }, keyFrame)

        local confirmKeyBtn = Create("TextButton", {
            Size=UDim2.new(1,-30,0,36),Position=UDim2.new(0,15,0,148),
            BackgroundColor3=Color3.fromRGB(255,255,255),
            Text="Confirm",TextColor3=Color3.fromRGB(10,10,10),
            Font=Enum.Font.GothamBold,TextSize=13,BorderSizePixel=0,ZIndex=51
        }, keyFrame)
        AddCorner(confirmKeyBtn, 8)

        -- auto load key from file
        if cfg.AutoLoadKey and cfg.KeySave then
            local raw = safeRead(cfg.KeyFileName)
            if raw then
                local ok, d = pcall(HttpService.JSONDecode, HttpService, raw)
                if ok and d and d.key then
                    if d.key == cfg.Key then
                        keyFrame:Destroy()
                        onSuccess()
                        return
                    end
                end
            end
        end

        -- fetch from site
        if cfg.GetKeyFromSite and cfg.KeySite ~= "" then
            statusLbl.Text = "Fetching key from site..."
            statusLbl.TextColor3 = Color3.fromRGB(150,150,255)
            task.spawn(function()
                local ok, result = pcall(function()
                    return game:GetService("HttpService"):GetAsync(cfg.KeySite)
                end)
                if ok and result then
                    statusLbl.Text = "Key fetched! Check site for key."
                    statusLbl.TextColor3 = Color3.fromRGB(100,200,100)
                else
                    statusLbl.Text = "Could not fetch key."
                    statusLbl.TextColor3 = Color3.fromRGB(200,60,60)
                end
            end)
        end

        confirmKeyBtn.MouseButton1Click:Connect(function()
            local entered = keyInput.Text
            if entered == cfg.Key then
                if cfg.KeySave then
                    local encoded = HttpService:JSONEncode({ key = entered })
                    safeWrite(cfg.KeyFileName, encoded)
                end
                Tween(keyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
                task.wait(0.3)
                keyFrame:Destroy()
                onSuccess()
            else
                statusLbl.Text = "❌ Invalid key. Try again."
                statusLbl.TextColor3 = Color3.fromRGB(220, 60, 60)
                Tween(keyFrame, 0.05, { Position = UDim2.new(0.5,-148,0.5,-100) }):Play()
                task.wait(0.05)
                Tween(keyFrame, 0.05, { Position = UDim2.new(0.5,-152,0.5,-100) }):Play()
                task.wait(0.05)
                Tween(keyFrame, 0.05, { Position = UDim2.new(0.5,-150,0.5,-100) }):Play()
            end
        end)
    end

    -- ═══════════════════════════════════════════════════════════════════
    --  WINDOW PUBLIC API
    -- ═══════════════════════════════════════════════════════════════════
    local WindowAPI = {}

    function WindowAPI:AddTab(tabConfig)
        return addTab(tabConfig)
    end

    function WindowAPI:AddConfig()
        return buildConfigTab()
    end

    function WindowAPI:SetTheme(name)
        updateTheme(name)
    end

    function WindowAPI:Destroy()
        ScreenGui:Destroy()
    end

    function WindowAPI:Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end

    -- ═══════════════════════════════════════════════════════════════════
    --  INIT SEQUENCE
    -- ═══════════════════════════════════════════════════════════════════
    -- restore theme from save
    if saveData["__theme"] and Themes[saveData["__theme"]] then
        currentTheme = Themes[saveData["__theme"]]
        currentThemeName = saveData["__theme"]
        MainFrame.BackgroundColor3 = currentTheme.Background
        TopBar.BackgroundColor3    = currentTheme.TopBar
        TopBarFix.BackgroundColor3 = currentTheme.TopBar
        TabBar.BackgroundColor3    = currentTheme.TopBar
        TitleLbl.TextColor3        = currentTheme.Text
    end

    task.spawn(function()
        runLoadingAnim(function()
            if cfg.KeyEnable then
                showKeySystem(function()
                    keyUnlocked = true
                    MainFrame.Visible = true
                    Tween(MainFrame, 0.4, { }, Enum.EasingStyle.Back):Play()
                end)
            else
                MainFrame.Visible = true
                MainFrame.Position = UDim2.new(0.5, -180, 0.5, -260)
                Tween(MainFrame, 0.4, {
                    Position = UDim2.new(0.5, -180, 0.5, -240),
                }, Enum.EasingStyle.Back):Play()
            end
        end)
    end)

    return WindowAPI
end

return NexusLib
