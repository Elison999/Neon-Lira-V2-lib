--[[
    NexusUI - Super Modern Roblox UI Library
    Version: 2.0.0
    Author: NexusUI Dev Team
    
    Usage:
        loadstring(game:HttpGet("YOUR_RAW_LINK_HERE"))()
        
        local Window = NexusUI:CreateWindow({
            Name = "My Hub",
            LoadingEnabled = true,
            LoadingName = "Hello, Welcome Back!!",
            LoadingIcon = "rbxassetid://0",
            KeySystem = false,
        })
--]]

-- ============================================================
-- SERVICES
-- ============================================================
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local Players            = game:GetService("Players")
local CoreGui            = game:GetService("CoreGui")
local TextService        = game:GetService("TextService")
local HttpService        = game:GetService("HttpService")

local LocalPlayer        = Players.LocalPlayer
local Mouse              = LocalPlayer:GetMouse()

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function Tween(obj, info, props)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function RGBToColor3(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local function Color3ToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255))
end

local function HexToColor3(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1,2), 16) / 255
    local g = tonumber(hex:sub(3,4), 16) / 255
    local b = tonumber(hex:sub(5,6), 16) / 255
    return Color3.new(r, g, b)
end

local function GetTextSize(text, size, font, bounds)
    return TextService:GetTextSize(text, size, font, bounds)
end

local function SafeWriteFile(name, data)
    if writefile then
        local ok, err = pcall(writefile, name, data)
        if not ok then
            warn("[NexusUI] writefile error: " .. tostring(err))
        end
    end
end

local function SafeReadFile(name)
    if readfile and isfile and isfile(name) then
        local ok, data = pcall(readfile, name)
        if ok then return data end
    end
    return nil
end

local function SafeMakeFolder(name)
    if makefolder and not (isfolder and isfolder(name)) then
        pcall(makefolder, name)
    end
end

local function DeepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- ============================================================
-- THEME DEFINITIONS
-- ============================================================
local Themes = {
    ["Dark"] = {
        Background       = RGBToColor3(15, 15, 20),
        TopBar           = RGBToColor3(20, 20, 28),
        TabBar           = RGBToColor3(18, 18, 25),
        Section          = RGBToColor3(22, 22, 32),
        Element          = RGBToColor3(28, 28, 40),
        ElementHover     = RGBToColor3(35, 35, 50),
        Accent           = RGBToColor3(100, 65, 255),
        AccentDark       = RGBToColor3(70, 40, 200),
        AccentLight      = RGBToColor3(140, 100, 255),
        Text             = RGBToColor3(235, 235, 245),
        TextDim          = RGBToColor3(160, 160, 180),
        TextDisabled     = RGBToColor3(90, 90, 110),
        Border           = RGBToColor3(45, 45, 65),
        Toggle_On        = RGBToColor3(100, 65, 255),
        Toggle_Off       = RGBToColor3(55, 55, 75),
        Slider_Fill      = RGBToColor3(100, 65, 255),
        Slider_Track     = RGBToColor3(40, 40, 60),
        Dropdown_BG      = RGBToColor3(18, 18, 28),
        Shadow           = RGBToColor3(5, 5, 10),
        Notification     = RGBToColor3(25, 25, 35),
        Close            = RGBToColor3(255, 70, 70),
        Minimize         = RGBToColor3(255, 190, 50),
        Resize           = RGBToColor3(50, 200, 100),
    },
    ["Light"] = {
        Background       = RGBToColor3(240, 242, 248),
        TopBar           = RGBToColor3(255, 255, 255),
        TabBar           = RGBToColor3(245, 246, 252),
        Section          = RGBToColor3(250, 251, 255),
        Element          = RGBToColor3(255, 255, 255),
        ElementHover     = RGBToColor3(235, 238, 248),
        Accent           = RGBToColor3(100, 65, 255),
        AccentDark       = RGBToColor3(70, 40, 200),
        AccentLight      = RGBToColor3(140, 100, 255),
        Text             = RGBToColor3(20, 20, 35),
        TextDim          = RGBToColor3(90, 90, 120),
        TextDisabled     = RGBToColor3(160, 160, 180),
        Border           = RGBToColor3(210, 210, 230),
        Toggle_On        = RGBToColor3(100, 65, 255),
        Toggle_Off       = RGBToColor3(190, 190, 210),
        Slider_Fill      = RGBToColor3(100, 65, 255),
        Slider_Track     = RGBToColor3(210, 210, 230),
        Dropdown_BG      = RGBToColor3(250, 251, 255),
        Shadow           = RGBToColor3(180, 180, 200),
        Notification     = RGBToColor3(255, 255, 255),
        Close            = RGBToColor3(255, 70, 70),
        Minimize         = RGBToColor3(255, 190, 50),
        Resize           = RGBToColor3(50, 200, 100),
    },
    ["Midnight"] = {
        Background       = RGBToColor3(5, 5, 12),
        TopBar           = RGBToColor3(8, 8, 18),
        TabBar           = RGBToColor3(6, 6, 15),
        Section          = RGBToColor3(10, 10, 22),
        Element          = RGBToColor3(14, 14, 28),
        ElementHover     = RGBToColor3(20, 20, 38),
        Accent           = RGBToColor3(0, 180, 255),
        AccentDark       = RGBToColor3(0, 130, 200),
        AccentLight      = RGBToColor3(80, 210, 255),
        Text             = RGBToColor3(220, 235, 255),
        TextDim          = RGBToColor3(130, 155, 190),
        TextDisabled     = RGBToColor3(70, 85, 110),
        Border           = RGBToColor3(30, 35, 60),
        Toggle_On        = RGBToColor3(0, 180, 255),
        Toggle_Off       = RGBToColor3(40, 40, 65),
        Slider_Fill      = RGBToColor3(0, 180, 255),
        Slider_Track     = RGBToColor3(25, 30, 50),
        Dropdown_BG      = RGBToColor3(8, 8, 18),
        Shadow           = RGBToColor3(0, 0, 5),
        Notification     = RGBToColor3(10, 12, 25),
        Close            = RGBToColor3(255, 70, 70),
        Minimize         = RGBToColor3(255, 190, 50),
        Resize           = RGBToColor3(50, 200, 100),
    },
    ["Neon"] = {
        Background       = RGBToColor3(8, 8, 8),
        TopBar           = RGBToColor3(12, 12, 12),
        TabBar           = RGBToColor3(10, 10, 10),
        Section          = RGBToColor3(14, 14, 14),
        Element          = RGBToColor3(18, 18, 18),
        ElementHover     = RGBToColor3(25, 25, 25),
        Accent           = RGBToColor3(0, 255, 128),
        AccentDark       = RGBToColor3(0, 200, 90),
        AccentLight      = RGBToColor3(100, 255, 180),
        Text             = RGBToColor3(245, 255, 245),
        TextDim          = RGBToColor3(150, 200, 160),
        TextDisabled     = RGBToColor3(80, 110, 85),
        Border           = RGBToColor3(0, 80, 40),
        Toggle_On        = RGBToColor3(0, 255, 128),
        Toggle_Off       = RGBToColor3(40, 55, 45),
        Slider_Fill      = RGBToColor3(0, 255, 128),
        Slider_Track     = RGBToColor3(25, 35, 28),
        Dropdown_BG      = RGBToColor3(10, 14, 11),
        Shadow           = RGBToColor3(0, 20, 8),
        Notification     = RGBToColor3(12, 16, 13),
        Close            = RGBToColor3(255, 70, 70),
        Minimize         = RGBToColor3(255, 190, 50),
        Resize           = RGBToColor3(0, 255, 128),
    },
    ["Rose"] = {
        Background       = RGBToColor3(20, 10, 15),
        TopBar           = RGBToColor3(28, 14, 20),
        TabBar           = RGBToColor3(24, 12, 18),
        Section          = RGBToColor3(32, 16, 24),
        Element          = RGBToColor3(38, 20, 28),
        ElementHover     = RGBToColor3(48, 26, 36),
        Accent           = RGBToColor3(255, 80, 140),
        AccentDark       = RGBToColor3(200, 50, 100),
        AccentLight      = RGBToColor3(255, 140, 180),
        Text             = RGBToColor3(255, 235, 242),
        TextDim          = RGBToColor3(200, 160, 175),
        TextDisabled     = RGBToColor3(110, 80, 95),
        Border           = RGBToColor3(70, 35, 50),
        Toggle_On        = RGBToColor3(255, 80, 140),
        Toggle_Off       = RGBToColor3(60, 35, 45),
        Slider_Fill      = RGBToColor3(255, 80, 140),
        Slider_Track     = RGBToColor3(50, 25, 35),
        Dropdown_BG      = RGBToColor3(22, 12, 17),
        Shadow           = RGBToColor3(8, 3, 6),
        Notification     = RGBToColor3(26, 14, 20),
        Close            = RGBToColor3(255, 70, 70),
        Minimize         = RGBToColor3(255, 190, 50),
        Resize           = RGBToColor3(255, 80, 140),
    },
    ["Ocean"] = {
        Background       = RGBToColor3(5, 15, 30),
        TopBar           = RGBToColor3(8, 20, 40),
        TabBar           = RGBToColor3(6, 17, 35),
        Section          = RGBToColor3(10, 24, 45),
        Element          = RGBToColor3(14, 30, 55),
        ElementHover     = RGBToColor3(20, 40, 70),
        Accent           = RGBToColor3(0, 200, 240),
        AccentDark       = RGBToColor3(0, 150, 190),
        AccentLight      = RGBToColor3(80, 225, 255),
        Text             = RGBToColor3(210, 240, 255),
        TextDim          = RGBToColor3(130, 180, 220),
        TextDisabled     = RGBToColor3(70, 100, 135),
        Border           = RGBToColor3(25, 55, 90),
        Toggle_On        = RGBToColor3(0, 200, 240),
        Toggle_Off       = RGBToColor3(30, 55, 85),
        Slider_Fill      = RGBToColor3(0, 200, 240),
        Slider_Track     = RGBToColor3(20, 45, 70),
        Dropdown_BG      = RGBToColor3(7, 18, 36),
        Shadow           = RGBToColor3(0, 5, 12),
        Notification     = RGBToColor3(9, 22, 42),
        Close            = RGBToColor3(255, 100, 100),
        Minimize         = RGBToColor3(255, 210, 70),
        Resize           = RGBToColor3(0, 200, 240),
    },
    ["Sunset"] = {
        Background       = RGBToColor3(18, 8, 5),
        TopBar           = RGBToColor3(28, 12, 8),
        TabBar           = RGBToColor3(22, 10, 6),
        Section          = RGBToColor3(32, 15, 10),
        Element          = RGBToColor3(40, 18, 12),
        ElementHover     = RGBToColor3(50, 24, 16),
        Accent           = RGBToColor3(255, 130, 50),
        AccentDark       = RGBToColor3(210, 90, 20),
        AccentLight      = RGBToColor3(255, 180, 100),
        Text             = RGBToColor3(255, 240, 225),
        TextDim          = RGBToColor3(210, 175, 145),
        TextDisabled     = RGBToColor3(120, 90, 70),
        Border           = RGBToColor3(80, 40, 20),
        Toggle_On        = RGBToColor3(255, 130, 50),
        Toggle_Off       = RGBToColor3(65, 35, 20),
        Slider_Fill      = RGBToColor3(255, 130, 50),
        Slider_Track     = RGBToColor3(55, 28, 14),
        Dropdown_BG      = RGBToColor3(20, 10, 6),
        Shadow           = RGBToColor3(6, 2, 0),
        Notification     = RGBToColor3(26, 12, 8),
        Close            = RGBToColor3(255, 70, 70),
        Minimize         = RGBToColor3(255, 190, 50),
        Resize           = RGBToColor3(255, 130, 50),
    },
    ["Cyberpunk"] = {
        Background       = RGBToColor3(5, 3, 12),
        TopBar           = RGBToColor3(10, 5, 22),
        TabBar           = RGBToColor3(8, 4, 18),
        Section          = RGBToColor3(12, 6, 25),
        Element          = RGBToColor3(16, 8, 32),
        ElementHover     = RGBToColor3(22, 12, 42),
        Accent           = RGBToColor3(255, 0, 255),
        AccentDark       = RGBToColor3(200, 0, 200),
        AccentLight      = RGBToColor3(255, 100, 255),
        Text             = RGBToColor3(255, 230, 255),
        TextDim          = RGBToColor3(190, 140, 200),
        TextDisabled     = RGBToColor3(100, 60, 115),
        Border           = RGBToColor3(80, 0, 100),
        Toggle_On        = RGBToColor3(255, 0, 255),
        Toggle_Off       = RGBToColor3(55, 20, 65),
        Slider_Fill      = RGBToColor3(255, 0, 255),
        Slider_Track     = RGBToColor3(45, 15, 55),
        Dropdown_BG      = RGBToColor3(8, 4, 18),
        Shadow           = RGBToColor3(2, 0, 5),
        Notification     = RGBToColor3(12, 6, 24),
        Close            = RGBToColor3(255, 50, 50),
        Minimize         = RGBToColor3(255, 255, 0),
        Resize           = RGBToColor3(0, 255, 255),
    },
    ["Forest"] = {
        Background       = RGBToColor3(8, 16, 8),
        TopBar           = RGBToColor3(12, 22, 12),
        TabBar           = RGBToColor3(10, 19, 10),
        Section          = RGBToColor3(14, 25, 14),
        Element          = RGBToColor3(18, 32, 18),
        ElementHover     = RGBToColor3(24, 42, 24),
        Accent           = RGBToColor3(80, 200, 80),
        AccentDark       = RGBToColor3(50, 160, 50),
        AccentLight      = RGBToColor3(130, 230, 130),
        Text             = RGBToColor3(225, 245, 225),
        TextDim          = RGBToColor3(155, 200, 155),
        TextDisabled     = RGBToColor3(80, 115, 80),
        Border           = RGBToColor3(35, 65, 35),
        Toggle_On        = RGBToColor3(80, 200, 80),
        Toggle_Off       = RGBToColor3(35, 60, 35),
        Slider_Fill      = RGBToColor3(80, 200, 80),
        Slider_Track     = RGBToColor3(28, 48, 28),
        Dropdown_BG      = RGBToColor3(10, 20, 10),
        Shadow           = RGBToColor3(2, 5, 2),
        Notification     = RGBToColor3(12, 22, 12),
        Close            = RGBToColor3(255, 80, 80),
        Minimize         = RGBToColor3(240, 220, 60),
        Resize           = RGBToColor3(80, 200, 80),
    },
    ["Arctic"] = {
        Background       = RGBToColor3(220, 235, 248),
        TopBar           = RGBToColor3(235, 248, 255),
        TabBar           = RGBToColor3(225, 240, 252),
        Section          = RGBToColor3(240, 250, 255),
        Element          = RGBToColor3(250, 254, 255),
        ElementHover     = RGBToColor3(210, 232, 248),
        Accent           = RGBToColor3(50, 150, 220),
        AccentDark       = RGBToColor3(30, 110, 175),
        AccentLight      = RGBToColor3(100, 185, 240),
        Text             = RGBToColor3(20, 40, 70),
        TextDim          = RGBToColor3(80, 110, 150),
        TextDisabled     = RGBToColor3(150, 175, 205),
        Border           = RGBToColor3(175, 210, 235),
        Toggle_On        = RGBToColor3(50, 150, 220),
        Toggle_Off       = RGBToColor3(175, 205, 225),
        Slider_Fill      = RGBToColor3(50, 150, 220),
        Slider_Track     = RGBToColor3(185, 215, 235),
        Dropdown_BG      = RGBToColor3(230, 244, 255),
        Shadow           = RGBToColor3(150, 180, 210),
        Notification     = RGBToColor3(240, 250, 255),
        Close            = RGBToColor3(220, 60, 60),
        Minimize         = RGBToColor3(200, 160, 40),
        Resize           = RGBToColor3(50, 150, 220),
    },
    ["Dracula"] = {
        Background       = RGBToColor3(40, 42, 54),
        TopBar           = RGBToColor3(68, 71, 90),
        TabBar           = RGBToColor3(55, 57, 72),
        Section          = RGBToColor3(48, 50, 63),
        Element          = RGBToColor3(57, 59, 75),
        ElementHover     = RGBToColor3(68, 70, 88),
        Accent           = RGBToColor3(189, 147, 249),
        AccentDark       = RGBToColor3(150, 110, 210),
        AccentLight      = RGBToColor3(214, 190, 255),
        Text             = RGBToColor3(248, 248, 242),
        TextDim          = RGBToColor3(190, 192, 200),
        TextDisabled     = RGBToColor3(120, 122, 135),
        Border           = RGBToColor3(98, 100, 125),
        Toggle_On        = RGBToColor3(189, 147, 249),
        Toggle_Off       = RGBToColor3(80, 82, 105),
        Slider_Fill      = RGBToColor3(189, 147, 249),
        Slider_Track     = RGBToColor3(68, 70, 90),
        Dropdown_BG      = RGBToColor3(48, 50, 63),
        Shadow           = RGBToColor3(20, 21, 28),
        Notification     = RGBToColor3(55, 57, 70),
        Close            = RGBToColor3(255, 85, 85),
        Minimize         = RGBToColor3(241, 250, 140),
        Resize           = RGBToColor3(80, 250, 123),
    },
    ["Monokai"] = {
        Background       = RGBToColor3(39, 40, 34),
        TopBar           = RGBToColor3(50, 51, 44),
        TabBar           = RGBToColor3(45, 46, 39),
        Section          = RGBToColor3(52, 53, 46),
        Element          = RGBToColor3(60, 61, 53),
        ElementHover     = RGBToColor3(70, 72, 63),
        Accent           = RGBToColor3(166, 226, 46),
        AccentDark       = RGBToColor3(120, 175, 25),
        AccentLight      = RGBToColor3(200, 245, 100),
        Text             = RGBToColor3(248, 248, 242),
        TextDim          = RGBToColor3(188, 188, 180),
        TextDisabled     = RGBToColor3(115, 115, 105),
        Border           = RGBToColor3(80, 82, 70),
        Toggle_On        = RGBToColor3(166, 226, 46),
        Toggle_Off       = RGBToColor3(75, 77, 66),
        Slider_Fill      = RGBToColor3(166, 226, 46),
        Slider_Track     = RGBToColor3(62, 64, 55),
        Dropdown_BG      = RGBToColor3(44, 45, 38),
        Shadow           = RGBToColor3(15, 15, 12),
        Notification     = RGBToColor3(50, 51, 44),
        Close            = RGBToColor3(249, 38, 114),
        Minimize         = RGBToColor3(230, 219, 116),
        Resize           = RGBToColor3(166, 226, 46),
    },
    ["Vapor"] = {
        Background       = RGBToColor3(16, 8, 24),
        TopBar           = RGBToColor3(24, 12, 36),
        TabBar           = RGBToColor3(20, 10, 30),
        Section          = RGBToColor3(28, 14, 40),
        Element          = RGBToColor3(35, 18, 50),
        ElementHover     = RGBToColor3(45, 24, 64),
        Accent           = RGBToColor3(255, 100, 220),
        AccentDark       = RGBToColor3(200, 60, 175),
        AccentLight      = RGBToColor3(255, 160, 240),
        Text             = RGBToColor3(255, 230, 255),
        TextDim          = RGBToColor3(200, 160, 210),
        TextDisabled     = RGBToColor3(110, 75, 120),
        Border           = RGBToColor3(80, 35, 95),
        Toggle_On        = RGBToColor3(255, 100, 220),
        Toggle_Off       = RGBToColor3(65, 30, 80),
        Slider_Fill      = RGBToColor3(255, 100, 220),
        Slider_Track     = RGBToColor3(52, 24, 65),
        Dropdown_BG      = RGBToColor3(20, 10, 30),
        Shadow           = RGBToColor3(5, 2, 8),
        Notification     = RGBToColor3(25, 12, 35),
        Close            = RGBToColor3(255, 70, 100),
        Minimize         = RGBToColor3(255, 220, 70),
        Resize           = RGBToColor3(70, 220, 255),
    },
    ["Coffee"] = {
        Background       = RGBToColor3(22, 14, 8),
        TopBar           = RGBToColor3(35, 22, 12),
        TabBar           = RGBToColor3(28, 18, 10),
        Section          = RGBToColor3(40, 26, 14),
        Element          = RGBToColor3(50, 33, 18),
        ElementHover     = RGBToColor3(62, 42, 24),
        Accent           = RGBToColor3(200, 145, 80),
        AccentDark       = RGBToColor3(155, 105, 50),
        AccentLight      = RGBToColor3(235, 185, 120),
        Text             = RGBToColor3(248, 236, 218),
        TextDim          = RGBToColor3(196, 172, 140),
        TextDisabled     = RGBToColor3(120, 98, 72),
        Border           = RGBToColor3(80, 54, 30),
        Toggle_On        = RGBToColor3(200, 145, 80),
        Toggle_Off       = RGBToColor3(65, 44, 25),
        Slider_Fill      = RGBToColor3(200, 145, 80),
        Slider_Track     = RGBToColor3(55, 36, 20),
        Dropdown_BG      = RGBToColor3(28, 18, 10),
        Shadow           = RGBToColor3(8, 4, 2),
        Notification     = RGBToColor3(33, 21, 12),
        Close            = RGBToColor3(220, 75, 75),
        Minimize         = RGBToColor3(220, 195, 80),
        Resize           = RGBToColor3(200, 145, 80),
    },
    ["Sakura"] = {
        Background       = RGBToColor3(30, 15, 22),
        TopBar           = RGBToColor3(45, 22, 33),
        TabBar           = RGBToColor3(37, 18, 27),
        Section          = RGBToColor3(52, 25, 38),
        Element          = RGBToColor3(62, 32, 47),
        ElementHover     = RGBToColor3(75, 40, 57),
        Accent           = RGBToColor3(255, 155, 190),
        AccentDark       = RGBToColor3(210, 110, 148),
        AccentLight      = RGBToColor3(255, 195, 218),
        Text             = RGBToColor3(255, 238, 245),
        TextDim          = RGBToColor3(215, 175, 196),
        TextDisabled     = RGBToColor3(130, 95, 115),
        Border           = RGBToColor3(100, 55, 78),
        Toggle_On        = RGBToColor3(255, 155, 190),
        Toggle_Off       = RGBToColor3(80, 45, 62),
        Slider_Fill      = RGBToColor3(255, 155, 190),
        Slider_Track     = RGBToColor3(65, 36, 52),
        Dropdown_BG      = RGBToColor3(36, 18, 27),
        Shadow           = RGBToColor3(10, 4, 7),
        Notification     = RGBToColor3(42, 22, 32),
        Close            = RGBToColor3(255, 75, 95),
        Minimize         = RGBToColor3(255, 215, 100),
        Resize           = RGBToColor3(255, 155, 190),
    },
}

local ThemeNames = {}
for k, _ in pairs(Themes) do
    table.insert(ThemeNames, k)
end
table.sort(ThemeNames)

-- ============================================================
-- TWEEN INFO PRESETS
-- ============================================================
local TI = {
    Fast    = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Normal  = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow    = TweenInfo.new(0.4,  Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Spring  = TweenInfo.new(0.3,  Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.5,  Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Bounce  = TweenInfo.new(0.4,  Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
}

-- ============================================================
-- MAIN LIBRARY
-- ============================================================
local NexusUI = {}
NexusUI.__index = NexusUI
NexusUI._version  = "2.0.0"
NexusUI._windows  = {}
NexusUI._theme    = DeepCopy(Themes["Dark"])
NexusUI._themeName = "Dark"

-- Config system references
NexusUI._configCallbacks = {}

function NexusUI:_ApplyTheme(themeName)
    if not Themes[themeName] then return end
    self._theme = DeepCopy(Themes[themeName])
    self._themeName = themeName
    -- Notify all registered callbacks
    for _, cb in ipairs(self._configCallbacks) do
        pcall(cb, self._theme)
    end
end

function NexusUI:_RegisterThemeCallback(cb)
    table.insert(self._configCallbacks, cb)
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
function NexusUI:_GetScreenGui()
    if self._screenGui and self._screenGui.Parent then
        return self._screenGui
    end
    -- Try to remove old
    pcall(function()
        local old = CoreGui:FindFirstChild("NexusUIv2")
        if old then old:Destroy() end
    end)
    local sg = Create("ScreenGui", {
        Name            = "NexusUIv2",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        DisplayOrder    = 999,
        Parent          = (syn and syn.protect_gui and syn.protect_gui(Instance.new("ScreenGui"))) and gethui() or CoreGui,
    })
    -- Handle executor protect_gui
    if not sg.Parent then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    self._screenGui = sg
    return sg
end

-- ============================================================
-- LOADING SCREEN
-- ============================================================
function NexusUI:_ShowLoading(config)
    local SG = self:_GetScreenGui()
    local T  = self._theme

    local loadFrame = Create("Frame", {
        Name            = "Loading",
        Size            = UDim2.fromScale(1, 1),
        Position        = UDim2.fromScale(0, 0),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ZIndex          = 100,
        Parent          = SG,
    })

    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, T.Background),
            ColorSequenceKeypoint.new(1, Color3.new(
                math.clamp(T.Background.R + 0.05, 0, 1),
                math.clamp(T.Background.G + 0.03, 0, 1),
                math.clamp(T.Background.B + 0.08, 0, 1)
            )),
        }),
        Rotation = 135,
        Parent = loadFrame,
    })

    -- Icon
    local iconFrame = Create("Frame", {
        Size             = UDim2.fromOffset(90, 90),
        Position         = UDim2.new(0.5, -45, 0.4, -70),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        ZIndex           = 101,
        Parent           = loadFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 18), Parent = iconFrame })

    if config.LoadingIcon and config.LoadingIcon ~= "" then
        Create("ImageLabel", {
            Size             = UDim2.fromScale(0.75, 0.75),
            Position         = UDim2.fromScale(0.125, 0.125),
            BackgroundTransparency = 1,
            Image            = config.LoadingIcon,
            ScaleType        = Enum.ScaleType.Fit,
            ZIndex           = 102,
            Parent           = iconFrame,
        })
    else
        Create("TextLabel", {
            Size             = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text             = "N",
            Font             = Enum.Font.GothamBold,
            TextSize         = 44,
            TextColor3       = T.Text,
            ZIndex           = 102,
            Parent           = iconFrame,
        })
    end

    -- Glow behind icon
    local glow = Create("ImageLabel", {
        Size             = UDim2.fromOffset(130, 130),
        Position         = UDim2.new(0.5, -65, 0.4, -110),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://5028857084",
        ImageColor3      = T.Accent,
        ImageTransparency = 0.6,
        ZIndex           = 100,
        Parent           = loadFrame,
    })

    local titleLabel = Create("TextLabel", {
        Size             = UDim2.fromOffset(500, 40),
        Position         = UDim2.new(0.5, -250, 0.4, -15),
        BackgroundTransparency = 1,
        Text             = config.LoadingName or "Loading...",
        Font             = Enum.Font.GothamBold,
        TextSize         = 22,
        TextColor3       = T.Text,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 101,
        Parent           = loadFrame,
    })

    local subtitleLabel = Create("TextLabel", {
        Size             = UDim2.fromOffset(500, 28),
        Position         = UDim2.new(0.5, -250, 0.4, 22),
        BackgroundTransparency = 1,
        Text             = "Please wait...",
        Font             = Enum.Font.Gotham,
        TextSize         = 14,
        TextColor3       = T.TextDim,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 101,
        Parent           = loadFrame,
    })

    -- Progress bar background
    local barBG = Create("Frame", {
        Size             = UDim2.fromOffset(320, 4),
        Position         = UDim2.new(0.5, -160, 0.4, 65),
        BackgroundColor3 = T.Slider_Track,
        BorderSizePixel  = 0,
        ZIndex           = 101,
        Parent           = loadFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barBG })

    local barFill = Create("Frame", {
        Size             = UDim2.fromOffset(0, 4),
        Position         = UDim2.fromOffset(0, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        ZIndex           = 102,
        Parent           = barBG,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barFill })

    -- Animate entrance
    iconFrame.Position = UDim2.new(0.5, -45, 0.4, -80)
    iconFrame.BackgroundTransparency = 1
    Tween(iconFrame, TI.Spring, {
        Position = UDim2.new(0.5, -45, 0.4, -70),
        BackgroundTransparency = 0,
    })

    -- Progress fill animation
    Tween(barFill, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.fromOffset(320, 4),
    })

    -- Glow pulse
    local function pulseGlow()
        while glow and glow.Parent do
            Tween(glow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.3,
                Size = UDim2.fromOffset(150, 150),
                Position = UDim2.new(0.5, -75, 0.4, -120),
            })
            task.wait(0.9)
            Tween(glow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.7,
                Size = UDim2.fromOffset(120, 120),
                Position = UDim2.new(0.5, -60, 0.4, -105),
            })
            task.wait(0.9)
        end
    end
    task.spawn(pulseGlow)

    return function() -- dismiss callback
        Tween(loadFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
        })
        for _, d in ipairs(loadFrame:GetDescendants()) do
            if d:IsA("GuiObject") then
                Tween(d, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    BackgroundTransparency = 1,
                })
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    Tween(d, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        TextTransparency = 1,
                    })
                end
                if d:IsA("ImageLabel") then
                    Tween(d, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        ImageTransparency = 1,
                    })
                end
            end
        end
        task.delay(0.55, function()
            if loadFrame then loadFrame:Destroy() end
        end)
    end
end

-- ============================================================
-- KEY SYSTEM
-- ============================================================
function NexusUI:_ShowKeySystem(config, onSuccess, onFail)
    local SG = self:_GetScreenGui()
    local T  = self._theme
    local FOLDER = "NexusUI"
    local KEYFILE = FOLDER .. "/" .. (config.KeyJsonName or "key.json")

    SafeMakeFolder(FOLDER)

    -- Check saved key
    if config.KeySave then
        local saved = SafeReadFile(KEYFILE)
        if saved then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, saved)
            if ok and data and data.key == config.Key then
                onSuccess()
                return
            end
        end
    end

    -- Build UI
    local overlay = Create("Frame", {
        Name            = "KeyOverlay",
        Size            = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.4,
        ZIndex          = 90,
        Parent          = SG,
    })

    local keyFrame = Create("Frame", {
        Name            = "KeyFrame",
        Size            = UDim2.fromOffset(440, 260),
        Position        = UDim2.new(0.5, -220, 0.5, -140),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ZIndex          = 91,
        Parent          = SG,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = keyFrame })
    Create("UIStroke", {
        Color           = T.Accent,
        Thickness       = 1.5,
        Transparency    = 0.4,
        Parent          = keyFrame,
    })

    -- TopBar
    local kTopBar = Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 92,
        Parent          = keyFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = kTopBar })
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 20),
        Position        = UDim2.fromOffset(0, 25),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 92,
        Parent          = kTopBar,
    })

    Create("TextLabel", {
        Size            = UDim2.new(1, -20, 1, 0),
        Position        = UDim2.fromOffset(15, 0),
        BackgroundTransparency = 1,
        Text            = "🔑  " .. (config.KeyName or "Key System"),
        Font            = Enum.Font.GothamBold,
        TextSize        = 15,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 93,
        Parent          = kTopBar,
    })

    Create("TextLabel", {
        Size            = UDim2.new(1, -30, 0, 28),
        Position        = UDim2.fromOffset(15, 55),
        BackgroundTransparency = 1,
        Text            = "Enter your key to access the script.",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.TextDim,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextWrapped     = true,
        ZIndex          = 92,
        Parent          = keyFrame,
    })

    -- Input
    local inputBG = Create("Frame", {
        Size            = UDim2.new(1, -30, 0, 40),
        Position        = UDim2.fromOffset(15, 96),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        ZIndex          = 92,
        Parent          = keyFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = inputBG })
    Create("UIStroke", {
        Color           = T.Border,
        Thickness       = 1,
        Parent          = inputBG,
    })

    local keyInput = Create("TextBox", {
        Size            = UDim2.new(1, -20, 1, 0),
        Position        = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text            = "",
        PlaceholderText = "Paste your key here...",
        PlaceholderColor3 = T.TextDisabled,
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex          = 93,
        Parent          = inputBG,
    })

    local statusLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -30, 0, 20),
        Position        = UDim2.fromOffset(15, 145),
        BackgroundTransparency = 1,
        Text            = "",
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = T.Close,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 92,
        Parent          = keyFrame,
    })

    -- Buttons row
    local btnRow = Create("Frame", {
        Size            = UDim2.new(1, -30, 0, 38),
        Position        = UDim2.fromOffset(15, 172),
        BackgroundTransparency = 1,
        ZIndex          = 92,
        Parent          = keyFrame,
    })

    -- Confirm
    local confirmBtn = Create("TextButton", {
        Size            = UDim2.new(0.5, -5, 1, 0),
        Position        = UDim2.fromOffset(0, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Text            = "Confirm",
        Font            = Enum.Font.GothamBold,
        TextSize        = 14,
        TextColor3      = Color3.new(1,1,1),
        ZIndex          = 93,
        Parent          = btnRow,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = confirmBtn })

    -- Get key link
    if config.GetKeyFromSite and config.Sitekey then
        local getKeyBtn = Create("TextButton", {
            Size            = UDim2.new(0.5, -5, 1, 0),
            Position        = UDim2.new(0.5, 5, 0, 0),
            BackgroundColor3 = T.Element,
            BorderSizePixel = 0,
            Text            = "Get Key",
            Font            = Enum.Font.GothamBold,
            TextSize        = 14,
            TextColor3      = T.Text,
            ZIndex          = 93,
            Parent          = btnRow,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = getKeyBtn })
        Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = getKeyBtn })

        getKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                pcall(setclipboard, config.Sitekey)
                getKeyBtn.Text = "Copied!"
                task.delay(2, function()
                    getKeyBtn.Text = "Get Key"
                end)
            end
        end)
    end

    -- Animate in
    keyFrame.Position = UDim2.new(0.5, -220, 0.6, -130)
    keyFrame.BackgroundTransparency = 1
    Tween(keyFrame, TI.Spring, {
        Position = UDim2.new(0.5, -220, 0.5, -130),
        BackgroundTransparency = 0,
    })

    confirmBtn.MouseButton1Click:Connect(function()
        local entered = keyInput.Text
        if entered == config.Key then
            if config.KeySave then
                SafeMakeFolder(FOLDER)
                local ok2, encoded = pcall(HttpService.JSONEncode, HttpService, {key = entered})
                if ok2 then
                    SafeWriteFile(KEYFILE, encoded)
                end
            end
            Tween(keyFrame, TI.Fast, { BackgroundTransparency = 1 })
            Tween(overlay, TI.Fast, { BackgroundTransparency = 1 })
            task.delay(0.2, function()
                keyFrame:Destroy()
                overlay:Destroy()
                onSuccess()
            end)
        else
            statusLabel.Text = "❌ Incorrect key. Please try again."
            Tween(inputBG, TI.Fast, { BackgroundColor3 = RGBToColor3(80, 30, 30) })
            task.delay(0.8, function()
                Tween(inputBG, TI.Normal, { BackgroundColor3 = T.Element })
                statusLabel.Text = ""
            end)
        end
    end)

    keyInput.FocusLost:Connect(function(enter)
        if enter then
            confirmBtn.MouseButton1Click:Fire()
        end
    end)
end

-- ============================================================
-- WINDOW CLASS
-- ============================================================
local Window = {}
Window.__index = Window

function Window.new(lib, config)
    local self = setmetatable({}, Window)
    self._lib        = lib
    self._config     = config
    self._tabs       = {}
    self._activeTab  = nil
    self._minimized  = false
    self._closed     = false
    self._elements   = {} -- for save/load
    self._configData = {} -- current saved config data

    local FOLDER     = "NexusUI"
    local SAVEFILE   = FOLDER .. "/" .. (config.SaveFile or (config.Name or "nexus") .. "_cfg.json")
    self._saveFile   = SAVEFILE
    self._folder     = FOLDER
    SafeMakeFolder(FOLDER)

    local T = lib._theme

    local SG = lib:_GetScreenGui()

    -- Main frame
    local mainFrame = Create("Frame", {
        Name            = "Window_" .. (config.Name or "NexusUI"),
        Size            = UDim2.fromOffset(config.Width or 680, config.Height or 440),
        Position        = UDim2.new(0.5, -(config.Width or 680)/2, 0.5, -(config.Height or 440)/2),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent          = SG,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = mainFrame })
    Create("UIStroke", {
        Color           = T.Border,
        Thickness       = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent          = mainFrame,
    })

    -- Shadow
    local shadow = Create("ImageLabel", {
        Name            = "Shadow",
        Size            = UDim2.new(1, 40, 1, 40),
        Position        = UDim2.fromOffset(-20, -20),
        BackgroundTransparency = 1,
        Image           = "rbxassetid://5554236805",
        ImageColor3     = T.Shadow,
        ImageTransparency = 0.5,
        ScaleType       = Enum.ScaleType.Slice,
        SliceCenter     = Rect.new(23, 23, 277, 277),
        ZIndex          = -1,
        Parent          = mainFrame,
    })

    -- Top bar
    local topBar = Create("Frame", {
        Name            = "TopBar",
        Size            = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 3,
        Parent          = mainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = topBar })
    -- Flatten bottom corners of topbar
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 12),
        Position        = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 3,
        Parent          = topBar,
    })

    -- Logo/Title area
    local logoFrame = Create("Frame", {
        Size            = UDim2.fromOffset(36, 36),
        Position        = UDim2.fromOffset(8, 4),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = topBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = logoFrame })
    Create("TextLabel", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text            = "N",
        Font            = Enum.Font.GothamBlack,
        TextSize        = 20,
        TextColor3      = Color3.new(1, 1, 1),
        ZIndex          = 5,
        Parent          = logoFrame,
    })

    local titleLabel = Create("TextLabel", {
        Name            = "Title",
        Size            = UDim2.fromOffset(280, 36),
        Position        = UDim2.fromOffset(52, 4),
        BackgroundTransparency = 1,
        Text            = config.Name or "NexusUI",
        Font            = Enum.Font.GothamBold,
        TextSize        = 16,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 4,
        Parent          = topBar,
    })

    local subtitleLabel = Create("TextLabel", {
        Name            = "Subtitle",
        Size            = UDim2.fromOffset(280, 20),
        Position        = UDim2.new(0, 52, 0, 22),
        BackgroundTransparency = 1,
        Text            = config.Subtitle or "",
        Font            = Enum.Font.Gotham,
        TextSize         = 11,
        TextColor3      = T.TextDim,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 4,
        Parent          = topBar,
    })

    -- Window control buttons (right side)
    local btnSize = UDim2.fromOffset(16, 16)

    -- Close button
    local closeBtn = Create("Frame", {
        Name            = "CloseBtn",
        Size            = btnSize,
        Position        = UDim2.new(1, -26, 0.5, -8),
        BackgroundColor3 = T.Close,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = topBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = closeBtn })
    local closeBtnClick = Create("TextButton", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 5,
        Parent          = closeBtn,
    })

    -- Minimize button
    local minBtn = Create("Frame", {
        Name            = "MinBtn",
        Size            = btnSize,
        Position        = UDim2.new(1, -50, 0.5, -8),
        BackgroundColor3 = T.Minimize,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = topBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = minBtn })
    local minBtnClick = Create("TextButton", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 5,
        Parent          = minBtn,
    })

    -- Resize button
    local resizeBtn = Create("Frame", {
        Name            = "ResizeBtn",
        Size            = btnSize,
        Position        = UDim2.new(1, -74, 0.5, -8),
        BackgroundColor3 = T.Resize,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = topBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = resizeBtn })
    local resizeBtnClick = Create("TextButton", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 5,
        Parent          = resizeBtn,
    })

    -- Tab bar
    local tabBar = Create("Frame", {
        Name            = "TabBar",
        Size            = UDim2.new(0, 150, 1, -44),
        Position        = UDim2.fromOffset(0, 44),
        BackgroundColor3 = T.TabBar,
        BorderSizePixel = 0,
        ZIndex          = 2,
        Parent          = mainFrame,
    })

    local tabList = Create("ScrollingFrame", {
        Name            = "TabList",
        Size            = UDim2.new(1, -8, 1, -10),
        Position        = UDim2.fromOffset(4, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize      = UDim2.fromScale(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex          = 3,
        Parent          = tabBar,
    })
    Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 4),
        Parent          = tabList,
    })
    Create("UIPadding", {
        PaddingTop      = UDim.new(0, 4),
        PaddingBottom   = UDim.new(0, 4),
        PaddingLeft     = UDim.new(0, 2),
        PaddingRight    = UDim.new(0, 2),
        Parent          = tabList,
    })

    -- Content area
    local contentArea = Create("Frame", {
        Name            = "ContentArea",
        Size            = UDim2.new(1, -154, 1, -48),
        Position        = UDim2.fromOffset(154, 48),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ZIndex          = 2,
        Parent          = mainFrame,
    })

    -- Divider
    Create("Frame", {
        Name            = "Divider",
        Size            = UDim2.new(0, 1, 1, -48),
        Position        = UDim2.fromOffset(150, 48),
        BackgroundColor3 = T.Border,
        BorderSizePixel = 0,
        ZIndex          = 3,
        Parent          = mainFrame,
    })

    -- Store references
    self._mainFrame    = mainFrame
    self._topBar       = topBar
    self._tabBar       = tabBar
    self._tabList      = tabList
    self._contentArea  = contentArea
    self._titleLabel   = titleLabel
    self._closeBtn     = closeBtnClick
    self._minBtn       = minBtnClick
    self._resizeBtn    = resizeBtnClick
    self._shadow       = shadow
    self._stroke       = mainFrame:FindFirstChildOfClass("UIStroke")

    -- Register theme callback
    lib:_RegisterThemeCallback(function(theme)
        self:_ApplyThemeToWindow(theme)
    end)

    -- Draggable
    self:_MakeDraggable()
    -- Resize functionality
    self:_MakeResizable()
    -- Window controls
    self:_SetupWindowControls()

    -- Initial animation
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.fromOffset((config.Width or 680) * 0.9, (config.Height or 440) * 0.9)
    Tween(mainFrame, TI.Spring, {
        BackgroundTransparency = 0,
        Size = UDim2.fromOffset(config.Width or 680, config.Height or 440),
    })

    return self
end

function Window:_ApplyThemeToWindow(T)
    if not self._mainFrame or not self._mainFrame.Parent then return end
    local function tw(obj, props)
        Tween(obj, TI.Normal, props)
    end

    tw(self._mainFrame, { BackgroundColor3 = T.Background })
    tw(self._topBar, { BackgroundColor3 = T.TopBar })
    tw(self._tabBar, { BackgroundColor3 = T.TabBar })
    tw(self._contentArea, { BackgroundColor3 = T.Background })
    tw(self._titleLabel, { TextColor3 = T.Text })
    tw(self._shadow, { ImageColor3 = T.Shadow })
    tw(self._stroke, { Color = T.Border })

    if self._topBar:FindFirstChild("Divider") then
        tw(self._topBar:FindFirstChild("Divider"), { BackgroundColor3 = T.Border })
    end

    -- Topbar flatten piece
    for _, f in ipairs(self._topBar:GetChildren()) do
        if f:IsA("Frame") and not f:FindFirstChildOfClass("UICorner") and f.Size == UDim2.new(1, 0, 0, 12) then
            tw(f, { BackgroundColor3 = T.TopBar })
        end
    end

    -- Tab buttons
    for _, tab in ipairs(self._tabs) do
        tab:_ApplyTheme(T)
    end
end

function Window:_MakeDraggable()
    local dragging = false
    local dragStart, startPos

    self._topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos  = self._mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self._mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Window:_MakeResizable()
    local resizing = false
    local resizeStart, startSize
    local minW, minH = 480, 320
    local maxW, maxH = 1000, 700

    self._resizeBtn.MouseButton1Click:Connect(function()
        resizing = not resizing
        if resizing then
            self._resizeBtn.Parent.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
            -- Show resize handle
            if not self._mainFrame:FindFirstChild("ResizeHandle") then
                local handle = Create("Frame", {
                    Name            = "ResizeHandle",
                    Size            = UDim2.fromOffset(18, 18),
                    Position        = UDim2.new(1, -18, 1, -18),
                    BackgroundColor3 = self._lib._theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex          = 10,
                    Parent          = self._mainFrame,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = handle })
                Create("ImageLabel", {
                    Size            = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Image           = "rbxassetid://6031094678",
                    ImageColor3     = Color3.new(1, 1, 1),
                    ZIndex          = 11,
                    Parent          = handle,
                })
            end
        else
            self._resizeBtn.Parent.BackgroundColor3 = self._lib._theme.Resize
            local handle = self._mainFrame:FindFirstChild("ResizeHandle")
            if handle then handle:Destroy() end
        end
    end)

    local isDraggingResize = false
    local resizeDragStart, resizeStartSize

    UserInputService.InputBegan:Connect(function(input)
        if not resizing then return end
        local handle = self._mainFrame:FindFirstChild("ResizeHandle")
        if not handle then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mx, my = input.Position.X, input.Position.Y
            local pos = handle.AbsolutePosition
            local size = handle.AbsoluteSize
            if mx >= pos.X and mx <= pos.X + size.X and
               my >= pos.Y and my <= pos.Y + size.Y then
                isDraggingResize = true
                resizeDragStart = input.Position
                resizeStartSize = self._mainFrame.AbsoluteSize
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not isDraggingResize then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeDragStart
            local newW = math.clamp(resizeStartSize.X + delta.X, minW, maxW)
            local newH = math.clamp(resizeStartSize.Y + delta.Y, minH, maxH)
            self._mainFrame.Size = UDim2.fromOffset(newW, newH)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingResize = false
        end
    end)
end

function Window:_SetupWindowControls()
    local T = self._lib._theme

    -- Minimize
    self._minBtn.MouseButton1Click:Connect(function()
        if self._minimized then
            self._minimized = false
            Tween(self._mainFrame, TI.Spring, {
                Size = UDim2.fromOffset(
                    self._config.Width or 680,
                    self._config.Height or 440
                )
            })
            self._mainFrame.ClipsDescendants = true
            for _, f in ipairs(self._mainFrame:GetChildren()) do
                if f.Name ~= "TopBar" and f:IsA("GuiObject") then
                    Tween(f, TI.Normal, { BackgroundTransparency = f:IsA("Frame") and 0 or nil })
                end
            end
        else
            self._minimized = true
            Tween(self._mainFrame, TI.Spring, { Size = UDim2.fromOffset(self._config.Width or 680, 44) })
        end
    end)

    -- Close (modal)
    self._closeBtn.MouseButton1Click:Connect(function()
        self:_ShowCloseModal()
    end)

    -- Hover effects
    for _, pair in ipairs({
        { self._closeBtn.Parent, T.Close },
        { self._minBtn.Parent, T.Minimize },
        { self._resizeBtn.Parent, T.Resize },
    }) do
        local frame, color = pair[1], pair[2]
        local btn = frame:FindFirstChildOfClass("TextButton")
        if btn then
            btn.MouseEnter:Connect(function()
                Tween(frame, TI.Fast, { Size = UDim2.fromOffset(18, 18), Position = UDim2.new(
                    frame.Position.X.Scale,
                    frame.Position.X.Offset - 1,
                    frame.Position.Y.Scale,
                    frame.Position.Y.Offset - 1
                )})
            end)
            btn.MouseLeave:Connect(function()
                Tween(frame, TI.Fast, { Size = UDim2.fromOffset(16, 16), Position = UDim2.new(
                    frame.Position.X.Scale,
                    frame.Position.X.Offset + 1,
                    frame.Position.Y.Scale,
                    frame.Position.Y.Offset + 1
                )})
            end)
        end
    end
end

function Window:_ShowCloseModal()
    local SG = self._lib:_GetScreenGui()
    local T  = self._lib._theme

    local overlay = Create("Frame", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
        ZIndex          = 80,
        Parent          = SG,
    })

    local modal = Create("Frame", {
        Size            = UDim2.fromOffset(320, 150),
        Position        = UDim2.new(0.5, -160, 0.5, -75),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ZIndex          = 81,
        Parent          = SG,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = modal })
    Create("UIStroke", { Color = T.Border, Thickness = 1.5, Parent = modal })

    local mTopBar = Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 82,
        Parent          = modal,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = mTopBar })
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 12),
        Position        = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 82,
        Parent          = mTopBar,
    })
    Create("TextLabel", {
        Size            = UDim2.new(1, -16, 1, 0),
        Position        = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1,
        Text            = "Close NexusUI?",
        Font            = Enum.Font.GothamBold,
        TextSize        = 15,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 83,
        Parent          = mTopBar,
    })

    Create("TextLabel", {
        Size            = UDim2.new(1, -32, 0, 42),
        Position        = UDim2.fromOffset(16, 46),
        BackgroundTransparency = 1,
        Text            = "Are you sure you want to close the interface?",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.TextDim,
        TextWrapped     = true,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 82,
        Parent          = modal,
    })

    local btnRow2 = Create("Frame", {
        Size            = UDim2.new(1, -32, 0, 36),
        Position        = UDim2.fromOffset(16, 100),
        BackgroundTransparency = 1,
        ZIndex          = 82,
        Parent          = modal,
    })

    local cancelBtn = Create("TextButton", {
        Size            = UDim2.new(0.5, -6, 1, 0),
        Position        = UDim2.fromOffset(0, 0),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        Text            = "Cancel",
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextColor3      = T.Text,
        ZIndex          = 83,
        Parent          = btnRow2,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = cancelBtn })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = cancelBtn })

    local yesBtn = Create("TextButton", {
        Size            = UDim2.new(0.5, -6, 1, 0),
        Position        = UDim2.new(0.5, 6, 0, 0),
        BackgroundColor3 = T.Close,
        BorderSizePixel = 0,
        Text            = "Yes, Close",
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextColor3      = Color3.new(1, 1, 1),
        ZIndex          = 83,
        Parent          = btnRow2,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = yesBtn })

    -- Animate
    modal.Position = UDim2.new(0.5, -160, 0.55, -75)
    modal.BackgroundTransparency = 1
    Tween(modal, TI.Spring, {
        Position = UDim2.new(0.5, -160, 0.5, -75),
        BackgroundTransparency = 0,
    })

    local function closeModal()
        Tween(modal, TI.Fast, { BackgroundTransparency = 1 })
        Tween(overlay, TI.Fast, { BackgroundTransparency = 1 })
        task.delay(0.15, function()
            modal:Destroy()
            overlay:Destroy()
        end)
    end

    cancelBtn.MouseButton1Click:Connect(closeModal)
    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            closeModal()
        end
    end)

    yesBtn.MouseButton1Click:Connect(function()
        closeModal()
        task.delay(0.15, function()
            Tween(self._mainFrame, TI.Normal, { BackgroundTransparency = 1, Size = UDim2.fromOffset(
                (self._config.Width or 680) * 0.85,
                (self._config.Height or 440) * 0.85
            )})
            task.delay(0.25, function()
                if self._mainFrame then self._mainFrame:Destroy() end
            end)
        end)
    end)
end

function Window:AddTab(config)
    local T    = self._lib._theme
    local tab  = {}
    tab._window = self
    tab._lib    = self._lib
    tab._name   = config.Name or ("Tab " .. (#self._tabs + 1))
    tab._icon   = config.Icon or ""
    tab._sections = {}

    -- Tab button
    local tabBtn = Create("TextButton", {
        Name            = "Tab_" .. tab._name,
        Size            = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = T.Element,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text            = "",
        AutoButtonColor = false,
        ZIndex          = 4,
        Parent          = self._tabList,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = tabBtn })

    local tabIndicator = Create("Frame", {
        Name            = "Indicator",
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 0, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex          = 5,
        Parent          = tabBtn,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = tabIndicator })

    local tabIcon = Create("ImageLabel", {
        Name            = "Icon",
        Size            = UDim2.fromOffset(18, 18),
        Position        = UDim2.fromOffset(10, 9),
        BackgroundTransparency = 1,
        Image           = tab._icon ~= "" and tab._icon or "",
        ImageColor3     = T.TextDim,
        Visible         = tab._icon ~= "",
        ZIndex          = 5,
        Parent          = tabBtn,
    })

    local tabText = Create("TextLabel", {
        Name            = "Label",
        Size            = UDim2.new(1, tab._icon ~= "" and -34 or -14, 1, 0),
        Position        = UDim2.fromOffset(tab._icon ~= "" and 32 or 10, 0),
        BackgroundTransparency = 1,
        Text            = tab._name,
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.TextDim,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 5,
        Parent          = tabBtn,
    })

    -- Content frame
    local contentFrame = Create("ScrollingFrame", {
        Name            = "Content_" .. tab._name,
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize      = UDim2.fromScale(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible         = false,
        ZIndex          = 2,
        Parent          = self._contentArea,
    })
    Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 8),
        Parent          = contentFrame,
    })
    Create("UIPadding", {
        PaddingTop      = UDim.new(0, 8),
        PaddingBottom   = UDim.new(0, 12),
        PaddingLeft     = UDim.new(0, 8),
        PaddingRight    = UDim.new(0, 8),
        Parent          = contentFrame,
    })

    tab._tabBtn       = tabBtn
    tab._tabText      = tabText
    tab._tabIcon      = tabIcon
    tab._tabIndicator = tabIndicator
    tab._contentFrame = contentFrame

    -- Select this tab
    tab._Select = function()
        -- Deselect all
        for _, t in ipairs(self._tabs) do
            Tween(t._tabBtn, TI.Fast, { BackgroundTransparency = 1 })
            Tween(t._tabIndicator, TI.Fast, { BackgroundTransparency = 1 })
            Tween(t._tabText, TI.Fast, { TextColor3 = T.TextDim })
            if t._tabIcon then Tween(t._tabIcon, TI.Fast, { ImageColor3 = T.TextDim }) end
            t._tabText.Font = Enum.Font.Gotham
            t._contentFrame.Visible = false
        end
        -- Select
        Tween(tabBtn, TI.Fast, { BackgroundTransparency = 0, BackgroundColor3 = T.Element })
        Tween(tabIndicator, TI.Fast, { BackgroundTransparency = 0 })
        Tween(tabText, TI.Fast, { TextColor3 = T.Text })
        if tabIcon then Tween(tabIcon, TI.Fast, { ImageColor3 = T.Accent }) end
        tabText.Font = Enum.Font.GothamBold
        contentFrame.Visible = true
        self._activeTab = tab
    end

    tabBtn.MouseButton1Click:Connect(function()
        tab._Select()
    end)

    tabBtn.MouseEnter:Connect(function()
        if self._activeTab ~= tab then
            Tween(tabBtn, TI.Fast, { BackgroundTransparency = 0.6 })
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self._activeTab ~= tab then
            Tween(tabBtn, TI.Fast, { BackgroundTransparency = 1 })
        end
    end)

    tab._ApplyTheme = function(_, theme)
        local T2 = theme
        Tween(contentFrame, TI.Normal, {})
        tabText.TextColor3 = (self._activeTab == tab) and T2.Text or T2.TextDim
        tabText.Font = (self._activeTab == tab) and Enum.Font.GothamBold or Enum.Font.Gotham
        if self._activeTab == tab then
            Tween(tabBtn, TI.Normal, { BackgroundColor3 = T2.Element })
            Tween(tabIndicator, TI.Normal, { BackgroundColor3 = T2.Accent })
            if tabIcon then Tween(tabIcon, TI.Normal, { ImageColor3 = T2.Accent }) end
        else
            if tabIcon then Tween(tabIcon, TI.Normal, { ImageColor3 = T2.TextDim }) end
        end
    end

    -- Section builder
    function tab:AddSection(sconfig)
        return self._window:_AddSection(self, sconfig)
    end

    table.insert(self._tabs, tab)
    if #self._tabs == 1 then
        tab._Select()
    end

    return tab
end

function Window:_AddSection(tab, config)
    local T = self._lib._theme
    local section = {}
    section._tab   = tab
    section._lib   = self._lib
    section._win   = self
    section._name  = config.Name or "Section"
    section._elements = {}

    local sectionFrame = Create("Frame", {
        Name            = "Section_" .. section._name,
        Size            = UDim2.new(1, 0, 0, 0),
        AutomaticSize   = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.Section,
        BorderSizePixel = 0,
        ZIndex          = 3,
        Parent          = tab._contentFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sectionFrame })
    Create("UIStroke", {
        Color           = T.Border,
        Thickness       = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent          = sectionFrame,
    })

    local sectionHeader = Create("Frame", {
        Name            = "Header",
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = sectionFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sectionHeader })
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 12),
        Position        = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = T.TopBar,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = sectionHeader,
    })

    local headerAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 16),
        Position        = UDim2.fromOffset(10, 8),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 5,
        Parent          = sectionHeader,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = headerAccent })

    Create("TextLabel", {
        Size            = UDim2.new(1, -28, 1, 0),
        Position        = UDim2.fromOffset(20, 0),
        BackgroundTransparency = 1,
        Text            = section._name,
        Font            = Enum.Font.GothamBold,
        TextSize        = 12,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 5,
        Parent          = sectionHeader,
    })

    -- Elements container
    local elementsFrame = Create("Frame", {
        Name            = "Elements",
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.fromOffset(0, 32),
        AutomaticSize   = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex          = 4,
        Parent          = sectionFrame,
    })
    Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 2),
        Parent          = elementsFrame,
    })
    Create("UIPadding", {
        PaddingTop      = UDim.new(0, 6),
        PaddingBottom   = UDim.new(0, 8),
        PaddingLeft     = UDim.new(0, 8),
        PaddingRight    = UDim.new(0, 8),
        Parent          = elementsFrame,
    })

    section._sectionFrame   = sectionFrame
    section._sectionHeader  = sectionHeader
    section._elementsFrame  = elementsFrame
    section._headerAccent   = headerAccent

    -- Register for theme
    self._lib:_RegisterThemeCallback(function(theme)
        Tween(sectionFrame, TI.Normal, { BackgroundColor3 = theme.Section })
        Tween(sectionHeader, TI.Normal, { BackgroundColor3 = theme.TopBar })
        Tween(headerAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        sectionFrame:FindFirstChildOfClass("UIStroke").Color = theme.Border
    end)

    -- Element builders
    function section:AddLabel(cfg) return self._win:_AddLabel(self, cfg) end
    function section:AddButton(cfg) return self._win:_AddButton(self, cfg) end
    function section:AddToggle(cfg) return self._win:_AddToggle(self, cfg) end
    function section:AddSlider(cfg) return self._win:_AddSlider(self, cfg) end
    function section:AddDropdown(cfg) return self._win:_AddDropdown(self, cfg) end
    function section:AddTextbox(cfg) return self._win:_AddTextbox(self, cfg) end
    function section:AddKeybind(cfg) return self._win:_AddKeybind(self, cfg) end
    function section:AddColorPicker(cfg) return self._win:_AddColorPicker(self, cfg) end

    table.insert(tab._sections, section)
    return section
end

-- ============================================================
-- ELEMENT HELPER: Base element frame
-- ============================================================
function Window:_CreateElementFrame(parent, height)
    local T = self._lib._theme
    local frame = Create("Frame", {
        Size            = UDim2.new(1, 0, 0, height or 40),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        ZIndex          = 5,
        Parent          = parent._elementsFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = frame })

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(frame, TI.Normal, { BackgroundColor3 = theme.Element })
    end)

    return frame
end

-- ============================================================
-- LABEL
-- ============================================================
function Window:_AddLabel(section, config)
    local T = self._lib._theme
    local frame = Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        ZIndex          = 5,
        Parent          = section._elementsFrame,
    })

    local label = Create("TextLabel", {
        Size            = UDim2.fromScale(1, 1),
        Position        = UDim2.fromOffset(4, 0),
        BackgroundTransparency = 1,
        Text            = config.Text or "Label",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.TextDim,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextWrapped     = true,
        ZIndex          = 6,
        Parent          = frame,
    })

    local elem = {
        _label = label,
        _frame = frame,
    }

    function elem:Set(text)
        self._label.Text = text
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(label, TI.Normal, { TextColor3 = theme.TextDim })
    end)

    return elem
end

-- ============================================================
-- BUTTON
-- ============================================================
function Window:_AddButton(section, config)
    local T    = self._lib._theme
    local frame = self:_CreateElementFrame(section, 40)

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local btnLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -100, 1, 0),
        Position        = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text            = config.Name or "Button",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local clickBtn = Create("TextButton", {
        Size            = UDim2.fromOffset(80, 28),
        Position        = UDim2.new(1, -88, 0.5, -14),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Text            = config.ButtonText or "Execute",
        Font            = Enum.Font.GothamBold,
        TextSize        = 12,
        TextColor3      = Color3.new(1, 1, 1),
        AutoButtonColor = false,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = clickBtn })

    local ripple = Create("Frame", {
        Size            = UDim2.fromOffset(0, 0),
        Position        = UDim2.fromScale(0.5, 0.5),
        AnchorPoint     = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex          = 7,
        Parent          = clickBtn,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ripple })

    local elem = { _frame = frame }

    clickBtn.MouseButton1Click:Connect(function()
        -- Ripple
        Tween(ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(100, 100),
            BackgroundTransparency = 1,
        })
        task.delay(0.4, function()
            ripple.Size = UDim2.fromOffset(0, 0)
            ripple.BackgroundTransparency = 0.7
        end)

        Tween(clickBtn, TI.Fast, { BackgroundColor3 = T.AccentDark })
        task.delay(0.12, function()
            Tween(clickBtn, TI.Normal, { BackgroundColor3 = T.Accent })
        end)

        if config.Callback then
            task.spawn(config.Callback)
        end
    end)

    clickBtn.MouseEnter:Connect(function()
        Tween(clickBtn, TI.Fast, { BackgroundColor3 = T.AccentLight })
    end)
    clickBtn.MouseLeave:Connect(function()
        Tween(clickBtn, TI.Fast, { BackgroundColor3 = T.Accent })
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
    end)

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(btnLabel, TI.Normal, { TextColor3 = theme.Text })
        Tween(clickBtn, TI.Normal, { BackgroundColor3 = theme.Accent })
    end)

    function elem:Fire()
        clickBtn.MouseButton1Click:Fire()
    end

    return elem
end

-- ============================================================
-- TOGGLE
-- ============================================================
function Window:_AddToggle(section, config)
    local T    = self._lib._theme
    local frame = self:_CreateElementFrame(section, 40)
    local value = config.Default ~= nil and config.Default or false

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local togLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -70, 1, 0),
        Position        = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text            = config.Name or "Toggle",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local togBG = Create("Frame", {
        Size            = UDim2.fromOffset(44, 24),
        Position        = UDim2.new(1, -52, 0.5, -12),
        BackgroundColor3 = value and T.Toggle_On or T.Toggle_Off,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = togBG })

    local togCircle = Create("Frame", {
        Size            = UDim2.fromOffset(18, 18),
        Position        = value and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex          = 7,
        Parent          = togBG,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = togCircle })

    local clickArea = Create("TextButton", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 8,
        Parent          = frame,
    })

    local elem = { Value = value, _id = config.Flag }

    local function setToggle(v, silent)
        value = v
        elem.Value = v
        Tween(togBG, TI.Fast, { BackgroundColor3 = v and T.Toggle_On or T.Toggle_Off })
        Tween(togCircle, TI.Spring, { Position = v and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3) })
        if not silent and config.Callback then
            task.spawn(config.Callback, v)
        end
        -- Auto save
        if config.Flag then
            self:_SaveElement(config.Flag, v)
        end
    end

    clickArea.MouseButton1Click:Connect(function()
        setToggle(not value)
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
    end)

    function elem:Set(v)
        setToggle(v, true)
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(togLabel, TI.Normal, { TextColor3 = theme.Text })
        Tween(togBG, TI.Normal, { BackgroundColor3 = value and theme.Toggle_On or theme.Toggle_Off })
    end)

    -- Register for save/load
    if config.Flag then
        self._elements[config.Flag] = elem
    end

    -- Load saved
    local saved = self:_LoadElement(config.Flag)
    if saved ~= nil then
        setToggle(saved, true)
    end

    return elem
end

-- ============================================================
-- SLIDER
-- ============================================================
function Window:_AddSlider(section, config)
    local T    = self._lib._theme
    local frame = self:_CreateElementFrame(section, 54)

    local min   = config.Min     or 0
    local max   = config.Max     or 100
    local def   = config.Default or min
    local step  = config.Step    or 1
    local value = def

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local sliderLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -80, 0, 22),
        Position        = UDim2.fromOffset(18, 6),
        BackgroundTransparency = 1,
        Text            = config.Name or "Slider",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local valueLabel = Create("TextLabel", {
        Size            = UDim2.fromOffset(70, 22),
        Position        = UDim2.new(1, -76, 0, 6),
        BackgroundTransparency = 1,
        Text            = tostring(value) .. (config.Suffix or ""),
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextColor3      = T.Accent,
        TextXAlignment  = Enum.TextXAlignment.Right,
        ZIndex          = 6,
        Parent          = frame,
    })

    local trackBG = Create("Frame", {
        Size            = UDim2.new(1, -24, 0, 6),
        Position        = UDim2.new(0, 12, 0, 36),
        BackgroundColor3 = T.Slider_Track,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackBG })

    local fillPct = (value - min) / (max - min)
    local trackFill = Create("Frame", {
        Size            = UDim2.new(fillPct, 0, 1, 0),
        BackgroundColor3 = T.Slider_Fill,
        BorderSizePixel = 0,
        ZIndex          = 7,
        Parent          = trackBG,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackFill })

    local knob = Create("Frame", {
        Size            = UDim2.fromOffset(16, 16),
        Position        = UDim2.new(fillPct, -8, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex          = 8,
        Parent          = trackBG,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    -- Knob shadow
    Create("UIStroke", {
        Color           = T.Accent,
        Thickness       = 2,
        Parent          = knob,
    })

    local elem = { Value = value, _id = config.Flag }
    local dragging = false

    local function updateSlider(pct, silent)
        pct = math.clamp(pct, 0, 1)
        local raw = min + (max - min) * pct
        -- Apply step
        if step > 0 then
            raw = math.round(raw / step) * step
        end
        raw = math.clamp(raw, min, max)
        value = raw
        elem.Value = raw

        local snappedPct = (raw - min) / (max - min)
        Tween(trackFill, TI.Fast, { Size = UDim2.new(snappedPct, 0, 1, 0) })
        Tween(knob, TI.Fast, { Position = UDim2.new(snappedPct, -8, 0.5, -8) })
        valueLabel.Text = tostring(math.floor(raw * 100 + 0.5) / 100) .. (config.Suffix or "")

        if not silent and config.Callback then
            task.spawn(config.Callback, raw)
        end
        if config.Flag then
            self:_SaveElement(config.Flag, raw)
        end
    end

    trackBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local rel = input.Position.X - trackBG.AbsolutePosition.X
            updateSlider(rel / trackBG.AbsoluteSize.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local rel = input.Position.X - trackBG.AbsolutePosition.X
            updateSlider(rel / trackBG.AbsoluteSize.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
        Tween(knob, TI.Fast, { Size = UDim2.fromOffset(18, 18), Position = UDim2.new(
            (value - min)/(max - min), -9, 0.5, -9
        )})
    end)
    frame.MouseLeave:Connect(function()
        if not dragging then
            Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
            Tween(knob, TI.Fast, { Size = UDim2.fromOffset(16, 16), Position = UDim2.new(
                (value - min)/(max - min), -8, 0.5, -8
            )})
        end
    end)

    function elem:Set(v)
        local pct = (v - min) / (max - min)
        updateSlider(pct, true)
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(sliderLabel, TI.Normal, { TextColor3 = theme.Text })
        Tween(valueLabel, TI.Normal, { TextColor3 = theme.Accent })
        Tween(trackBG, TI.Normal, { BackgroundColor3 = theme.Slider_Track })
        Tween(trackFill, TI.Normal, { BackgroundColor3 = theme.Slider_Fill })
        knob:FindFirstChildOfClass("UIStroke").Color = theme.Accent
    end)

    if config.Flag then
        self._elements[config.Flag] = elem
    end
    local saved = self:_LoadElement(config.Flag)
    if saved ~= nil then
        elem:Set(saved)
    end

    return elem
end

-- ============================================================
-- DROPDOWN
-- ============================================================
function Window:_AddDropdown(section, config)
    local T      = self._lib._theme
    local frame  = self:_CreateElementFrame(section, 40)
    local options = config.Options or {}
    local multi   = config.Multi or false
    local selected = multi and {} or (config.Default or (options[1] or ""))
    local isOpen  = false

    if multi and config.Default then
        selected = type(config.Default) == "table" and config.Default or { config.Default }
    end

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local ddLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -100, 1, 0),
        Position        = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text            = config.Name or "Dropdown",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local displayBtn = Create("TextButton", {
        Size            = UDim2.fromOffset(120, 28),
        Position        = UDim2.new(1, -128, 0.5, -14),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        Text            = "",
        AutoButtonColor = false,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = displayBtn })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = displayBtn })

    local displayText = Create("TextLabel", {
        Size            = UDim2.new(1, -26, 1, 0),
        Position        = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        Text            = multi and (next(selected) and table.concat(selected, ", ") or "None") or tostring(selected),
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClipsDescendants = true,
        ZIndex          = 7,
        Parent          = displayBtn,
    })

    local arrowLabel = Create("TextLabel", {
        Size            = UDim2.fromOffset(20, 28),
        Position        = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1,
        Text            = "▾",
        Font            = Enum.Font.GothamBold,
        TextSize        = 14,
        TextColor3      = T.TextDim,
        ZIndex          = 7,
        Parent          = displayBtn,
    })

    -- Dropdown list (outside frame)
    local dropList = Create("Frame", {
        Name            = "DropList",
        Size            = UDim2.fromOffset(140, 0),
        Position        = UDim2.new(1, -148, 1, 4),
        BackgroundColor3 = T.Dropdown_BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex          = 20,
        Visible         = false,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = dropList })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = dropList })

    local dropScroll = Create("ScrollingFrame", {
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize      = UDim2.fromScale(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex          = 21,
        Parent          = dropList,
    })
    Create("UIListLayout", {
        SortOrder       = Enum.SortOrder.LayoutOrder,
        Padding         = UDim.new(0, 2),
        Parent          = dropScroll,
    })
    Create("UIPadding", {
        PaddingTop      = UDim.new(0, 4),
        PaddingBottom   = UDim.new(0, 4),
        PaddingLeft     = UDim.new(0, 4),
        PaddingRight    = UDim.new(0, 4),
        Parent          = dropScroll,
    })

    local elem = {
        Value   = selected,
        _frame  = frame,
        _id     = config.Flag,
        _optionBtns = {},
    }

    local function updateDisplay()
        if multi then
            local selList = {}
            for _, v in ipairs(selected) do
                table.insert(selList, v)
            end
            displayText.Text = #selList > 0 and table.concat(selList, ", ") or "None"
        else
            displayText.Text = tostring(selected)
        end
        elem.Value = selected
    end

    local function isSelected(opt)
        if multi then
            for _, v in ipairs(selected) do
                if v == opt then return true end
            end
            return false
        else
            return selected == opt
        end
    end

    local function buildOptions()
        for _, child in ipairs(dropScroll:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        elem._optionBtns = {}

        for _, opt in ipairs(options) do
            local optBtn = Create("TextButton", {
                Size            = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = isSelected(opt) and T.Accent or T.Element,
                BackgroundTransparency = isSelected(opt) and 0 or 1,
                BorderSizePixel = 0,
                Text            = "",
                AutoButtonColor = false,
                ZIndex          = 22,
                Parent          = dropScroll,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optBtn })

            local checkMark = Create("TextLabel", {
                Size            = UDim2.fromOffset(18, 28),
                Position        = UDim2.fromOffset(4, 0),
                BackgroundTransparency = 1,
                Text            = isSelected(opt) and "✓" or "",
                Font            = Enum.Font.GothamBold,
                TextSize        = 12,
                TextColor3      = Color3.new(1, 1, 1),
                ZIndex          = 23,
                Parent          = optBtn,
            })

            Create("TextLabel", {
                Size            = UDim2.new(1, -26, 1, 0),
                Position        = UDim2.fromOffset(22, 0),
                BackgroundTransparency = 1,
                Text            = tostring(opt),
                Font            = Enum.Font.Gotham,
                TextSize        = 12,
                TextColor3      = isSelected(opt) and Color3.new(1,1,1) or T.Text,
                TextXAlignment  = Enum.TextXAlignment.Left,
                ZIndex          = 23,
                Parent          = optBtn,
            })

            optBtn.MouseButton1Click:Connect(function()
                if multi then
                    if isSelected(opt) then
                        for i, v in ipairs(selected) do
                            if v == opt then
                                table.remove(selected, i)
                                break
                            end
                        end
                    else
                        table.insert(selected, opt)
                    end
                else
                    selected = opt
                    -- Close dropdown
                    isOpen = false
                    Tween(dropList, TI.Fast, { Size = UDim2.fromOffset(140, 0) })
                    task.delay(0.15, function() dropList.Visible = false end)
                    Tween(arrowLabel, TI.Fast, { Rotation = 0 })
                end
                updateDisplay()
                buildOptions()
                if config.Callback then
                    task.spawn(config.Callback, selected)
                end
                if config.Flag then
                    self:_SaveElement(config.Flag, selected)
                end
            end)

            optBtn.MouseEnter:Connect(function()
                if not isSelected(opt) then
                    Tween(optBtn, TI.Fast, { BackgroundTransparency = 0.7, BackgroundColor3 = T.ElementHover })
                end
            end)
            optBtn.MouseLeave:Connect(function()
                if not isSelected(opt) then
                    Tween(optBtn, TI.Fast, { BackgroundTransparency = 1 })
                end
            end)

            table.insert(elem._optionBtns, optBtn)
        end
    end

    buildOptions()

    -- Calculate max height
    local function getDropHeight()
        return math.min(#options * 30 + 8, 200)
    end

    displayBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            dropList.Visible = true
            dropList.Size = UDim2.fromOffset(140, 0)
            Tween(dropList, TI.Spring, { Size = UDim2.fromOffset(140, getDropHeight()) })
            Tween(arrowLabel, TI.Fast, { Rotation = 180 })
        else
            Tween(dropList, TI.Fast, { Size = UDim2.fromOffset(140, 0) })
            task.delay(0.15, function() dropList.Visible = false end)
            Tween(arrowLabel, TI.Fast, { Rotation = 0 })
        end
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
    end)

    function elem:Set(v)
        if multi then
            selected = type(v) == "table" and v or {v}
        else
            selected = v
        end
        updateDisplay()
        buildOptions()
    end

    function elem:AddOption(opt)
        table.insert(options, opt)
        buildOptions()
    end

    function elem:RemoveOption(opt)
        for i, v in ipairs(options) do
            if v == opt then
                table.remove(options, i)
                if not multi and selected == opt then
                    selected = options[1] or ""
                    updateDisplay()
                end
                break
            end
        end
        buildOptions()
    end

    function elem:Refresh(newOptions)
        options = newOptions or {}
        selected = multi and {} or (options[1] or "")
        updateDisplay()
        buildOptions()
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(ddLabel, TI.Normal, { TextColor3 = theme.Text })
        Tween(displayBtn, TI.Normal, { BackgroundColor3 = theme.Element })
        displayBtn:FindFirstChildOfClass("UIStroke").Color = theme.Border
        Tween(displayText, TI.Normal, { TextColor3 = theme.Text })
        Tween(dropList, TI.Normal, { BackgroundColor3 = theme.Dropdown_BG })
        dropList:FindFirstChildOfClass("UIStroke").Color = theme.Border
        buildOptions()
    end)

    if config.Flag then
        self._elements[config.Flag] = elem
    end
    local saved = self:_LoadElement(config.Flag)
    if saved ~= nil then
        elem:Set(saved)
    end

    return elem
end

-- ============================================================
-- TEXTBOX
-- ============================================================
function Window:_AddTextbox(section, config)
    local T    = self._lib._theme
    local frame = self:_CreateElementFrame(section, 40)

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local tbLabel = Create("TextLabel", {
        Size            = UDim2.new(0.4, 0, 1, 0),
        Position        = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text            = config.Name or "Textbox",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local inputBG = Create("Frame", {
        Size            = UDim2.new(0.55, -12, 0, 28),
        Position        = UDim2.new(0.45, 0, 0.5, -14),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = inputBG })
    local inputStroke = Create("UIStroke", {
        Color           = T.Border,
        Thickness       = 1,
        Parent          = inputBG,
    })

    local textBox = Create("TextBox", {
        Size            = UDim2.new(1, -12, 1, 0),
        Position        = UDim2.fromOffset(6, 0),
        BackgroundTransparency = 1,
        Text            = config.Default or "",
        PlaceholderText = config.Placeholder or "Type here...",
        PlaceholderColor3 = T.TextDisabled,
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ClearTextOnFocus = config.ClearOnFocus ~= false and false or false,
        ZIndex          = 7,
        Parent          = inputBG,
    })

    textBox.Focused:Connect(function()
        Tween(inputStroke, TI.Fast, { Color = T.Accent })
    end)
    textBox.FocusLost:Connect(function(enter)
        Tween(inputStroke, TI.Fast, { Color = T.Border })
        if config.Callback then
            task.spawn(config.Callback, textBox.Text, enter)
        end
        if config.Flag then
            self:_SaveElement(config.Flag, textBox.Text)
        end
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
    end)

    local elem = {
        Value = textBox.Text,
        _textBox = textBox,
        _id = config.Flag,
    }

    function elem:Set(v)
        textBox.Text = tostring(v)
        self.Value = textBox.Text
    end

    function elem:Get()
        return textBox.Text
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(tbLabel, TI.Normal, { TextColor3 = theme.Text })
        Tween(inputBG, TI.Normal, { BackgroundColor3 = theme.Background })
        Tween(textBox, TI.Normal, { TextColor3 = theme.Text })
        textBox.PlaceholderColor3 = theme.TextDisabled
    end)

    if config.Flag then
        self._elements[config.Flag] = elem
    end
    local saved = self:_LoadElement(config.Flag)
    if saved ~= nil then
        elem:Set(saved)
    end

    return elem
end

-- ============================================================
-- KEYBIND
-- ============================================================
function Window:_AddKeybind(section, config)
    local T     = self._lib._theme
    local frame = self:_CreateElementFrame(section, 40)
    local key   = config.Default or Enum.KeyCode.Unknown
    local listening = false

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local kbLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -110, 1, 0),
        Position        = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text            = config.Name or "Keybind",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local keyBtn = Create("TextButton", {
        Size            = UDim2.fromOffset(90, 28),
        Position        = UDim2.new(1, -98, 0.5, -14),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        Text            = key ~= Enum.KeyCode.Unknown and key.Name or "None",
        Font            = Enum.Font.GothamBold,
        TextSize        = 12,
        TextColor3      = T.Accent,
        AutoButtonColor = false,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyBtn })
    Create("UIStroke", { Color = T.Accent, Thickness = 1, Parent = keyBtn })

    local elem = {
        Value = key,
        _id = config.Flag,
    }

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = T.TextDim
        Tween(keyBtn, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not listening then
            -- Check if bound key was pressed
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == key then
                    if config.Callback then
                        task.spawn(config.Callback, key)
                    end
                end
            end
            return
        end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                key = Enum.KeyCode.Unknown
            else
                key = input.KeyCode
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            listening = false
            keyBtn.Text = key ~= Enum.KeyCode.Unknown and key.Name or "None"
            keyBtn.TextColor3 = T.Accent
            Tween(keyBtn, TI.Fast, { BackgroundColor3 = T.Element })
            return
        end

        listening = false
        elem.Value = key
        keyBtn.Text = key ~= Enum.KeyCode.Unknown and key.Name or "None"
        keyBtn.TextColor3 = T.Accent
        Tween(keyBtn, TI.Fast, { BackgroundColor3 = T.Element })

        if config.ChangedCallback then
            task.spawn(config.ChangedCallback, key)
        end
        if config.Flag then
            self:_SaveElement(config.Flag, key.Name)
        end
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
    end)

    function elem:Set(keyCode)
        key = keyCode
        self.Value = keyCode
        keyBtn.Text = keyCode ~= Enum.KeyCode.Unknown and keyCode.Name or "None"
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(kbLabel, TI.Normal, { TextColor3 = theme.Text })
        Tween(keyBtn, TI.Normal, { BackgroundColor3 = theme.Element, TextColor3 = theme.Accent })
        keyBtn:FindFirstChildOfClass("UIStroke").Color = theme.Accent
    end)

    if config.Flag then
        self._elements[config.Flag] = elem
    end
    local saved = self:_LoadElement(config.Flag)
    if saved ~= nil then
        local kc = Enum.KeyCode[saved]
        if kc then elem:Set(kc) end
    end

    return elem
end

-- ============================================================
-- COLOR PICKER
-- ============================================================
function Window:_AddColorPicker(section, config)
    local T     = self._lib._theme
    local frame = self:_CreateElementFrame(section, 40)
    local color = config.Default or Color3.fromRGB(255, 255, 255)
    local H, S, V = Color3.toHSV(color)
    local isOpen = false

    local leftAccent = Create("Frame", {
        Size            = UDim2.fromOffset(3, 20),
        Position        = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = leftAccent })

    local cpLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -80, 1, 0),
        Position        = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text            = config.Name or "Color",
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 6,
        Parent          = frame,
    })

    local colorPreview = Create("TextButton", {
        Size            = UDim2.fromOffset(54, 28),
        Position        = UDim2.new(1, -62, 0.5, -14),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text            = "",
        AutoButtonColor = false,
        ZIndex          = 6,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = colorPreview })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = colorPreview })

    -- Picker panel (expanded below)
    local pickerPanel = Create("Frame", {
        Name            = "PickerPanel",
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.fromOffset(0, 40),
        BackgroundColor3 = T.Dropdown_BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex          = 9,
        Visible         = false,
        Parent          = frame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = pickerPanel })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = pickerPanel })

    local PICKER_H = 180

    -- Hue-Saturation gradient canvas
    local svCanvas = Create("ImageLabel", {
        Name            = "SVCanvas",
        Size            = UDim2.new(1, -60, 0, 120),
        Position        = UDim2.fromOffset(8, 8),
        BackgroundColor3 = Color3.fromHSV(H, 1, 1),
        BorderSizePixel = 0,
        Image           = "rbxassetid://4155801252",
        ZIndex          = 10,
        Parent          = pickerPanel,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = svCanvas })

    local svKnob = Create("Frame", {
        Size            = UDim2.fromOffset(12, 12),
        Position        = UDim2.new(S, -6, 1 - V, -6),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex          = 11,
        Parent          = svCanvas,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = svKnob })
    Create("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1.5, Parent = svKnob })

    -- Hue bar
    local hueBar = Create("ImageLabel", {
        Name            = "HueBar",
        Size            = UDim2.new(0, 16, 0, 120),
        Position        = UDim2.new(1, -52, 0, 8),
        BackgroundColor3 = Color3.new(1, 0, 0),
        BorderSizePixel = 0,
        Image           = "rbxassetid://4155805095",
        ZIndex          = 10,
        Parent          = pickerPanel,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = hueBar })

    local hueKnob = Create("Frame", {
        Size            = UDim2.fromOffset(20, 6),
        Position        = UDim2.new(0, -2, H, -3),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex          = 11,
        Parent          = hueBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = hueKnob })
    Create("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1.5, Parent = hueKnob })

    -- Hex input
    local hexBG = Create("Frame", {
        Size            = UDim2.new(1, -16, 0, 28),
        Position        = UDim2.fromOffset(8, 140),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        ZIndex          = 10,
        Parent          = pickerPanel,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hexBG })
    Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = hexBG })

    local hexLabel = Create("TextLabel", {
        Size            = UDim2.fromOffset(30, 28),
        BackgroundTransparency = 1,
        Text            = "HEX",
        Font            = Enum.Font.GothamBold,
        TextSize        = 10,
        TextColor3      = T.TextDim,
        ZIndex          = 11,
        Parent          = hexBG,
    })

    local hexInput = Create("TextBox", {
        Size            = UDim2.new(1, -36, 1, 0),
        Position        = UDim2.fromOffset(30, 0),
        BackgroundTransparency = 1,
        Text            = Color3ToHex(color),
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 11,
        Parent          = hexBG,
    })

    local elem = { Value = color, _id = config.Flag }

    local function updateColor(newH, newS, newV)
        H, S, V = newH, newS, newV
        color = Color3.fromHSV(H, S, V)
        elem.Value = color
        colorPreview.BackgroundColor3 = color
        svCanvas.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        svKnob.Position = UDim2.new(S, -6, 1 - V, -6)
        hueKnob.Position = UDim2.new(0, -2, H, -3)
        hexInput.Text = Color3ToHex(color)
        if config.Callback then
            task.spawn(config.Callback, color)
        end
        if config.Flag then
            self:_SaveElement(config.Flag, Color3ToHex(color))
        end
    end

    -- SV dragging
    local svDragging = false
    svCanvas.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local rel = input.Position - svCanvas.AbsolutePosition
            local ns = math.clamp(rel.X / svCanvas.AbsoluteSize.X, 0, 1)
            local nv = 1 - math.clamp(rel.Y / svCanvas.AbsoluteSize.Y, 0, 1)
            updateColor(H, ns, nv)
        end
    end)

    -- Hue dragging
    local hueDragging = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local rel = input.Position.Y - hueBar.AbsolutePosition.Y
            local nh = math.clamp(rel / hueBar.AbsoluteSize.Y, 0, 1)
            updateColor(nh, S, V)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if svDragging then
                local rel = input.Position - svCanvas.AbsolutePosition
                local ns = math.clamp(rel.X / svCanvas.AbsoluteSize.X, 0, 1)
                local nv = 1 - math.clamp(rel.Y / svCanvas.AbsoluteSize.Y, 0, 1)
                updateColor(H, ns, nv)
            elseif hueDragging then
                local rel = input.Position.Y - hueBar.AbsolutePosition.Y
                local nh = math.clamp(rel / hueBar.AbsoluteSize.Y, 0, 1)
                updateColor(nh, S, V)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
            hueDragging = false
        end
    end)

    hexInput.FocusLost:Connect(function()
        local ok, c = pcall(HexToColor3, hexInput.Text)
        if ok then
            local nh, ns, nv = Color3.toHSV(c)
            updateColor(nh, ns, nv)
        else
            hexInput.Text = Color3ToHex(color)
        end
    end)

    colorPreview.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            pickerPanel.Visible = true
            frame.Size = UDim2.new(1, 0, 0, 40 + PICKER_H)
            Tween(pickerPanel, TI.Spring, { Size = UDim2.new(1, 0, 0, PICKER_H) })
        else
            Tween(pickerPanel, TI.Fast, { Size = UDim2.new(1, 0, 0, 0) })
            task.delay(0.15, function()
                pickerPanel.Visible = false
                frame.Size = UDim2.new(1, 0, 0, 40)
            end)
        end
    end)

    frame.MouseEnter:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.ElementHover })
    end)
    frame.MouseLeave:Connect(function()
        Tween(frame, TI.Fast, { BackgroundColor3 = T.Element })
    end)

    function elem:Set(c)
        if type(c) == "string" then
            local ok, col = pcall(HexToColor3, c)
            if ok then c = col else return end
        end
        local nh, ns, nv = Color3.toHSV(c)
        updateColor(nh, ns, nv)
    end

    self._lib:_RegisterThemeCallback(function(theme)
        Tween(leftAccent, TI.Normal, { BackgroundColor3 = theme.Accent })
        Tween(cpLabel, TI.Normal, { TextColor3 = theme.Text })
        colorPreview:FindFirstChildOfClass("UIStroke").Color = theme.Border
        Tween(pickerPanel, TI.Normal, { BackgroundColor3 = theme.Dropdown_BG })
        pickerPanel:FindFirstChildOfClass("UIStroke").Color = theme.Border
        Tween(hexBG, TI.Normal, { BackgroundColor3 = theme.Element })
        hexBG:FindFirstChildOfClass("UIStroke").Color = theme.Border
        Tween(hexLabel, TI.Normal, { TextColor3 = theme.TextDim })
        Tween(hexInput, TI.Normal, { TextColor3 = theme.Text })
    end)

    if config.Flag then
        self._elements[config.Flag] = elem
    end
    local saved = self:_LoadElement(config.Flag)
    if saved ~= nil then
        elem:Set(saved)
    end

    return elem
end

-- ============================================================
-- SAVE / LOAD SYSTEM
-- ============================================================
function Window:_SaveElement(flag, value)
    if not flag then return end
    self._configData[flag] = value
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, self._configData)
    if ok then
        SafeWriteFile(self._saveFile, encoded)
    end
end

function Window:_LoadElement(flag)
    if not flag then return nil end
    if next(self._configData) == nil then
        -- Try to read from file
        local data = SafeReadFile(self._saveFile)
        if data then
            local ok, decoded = pcall(HttpService.JSONDecode, HttpService, data)
            if ok and decoded then
                self._configData = decoded
            end
        end
    end
    return self._configData[flag]
end

function Window:SaveConfig()
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, self._configData)
    if ok then
        SafeWriteFile(self._saveFile, encoded)
    end
end

function Window:LoadConfig()
    local data = SafeReadFile(self._saveFile)
    if data then
        local ok, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if ok and decoded then
            self._configData = decoded
            -- Apply to all registered elements
            for flag, elem in pairs(self._elements) do
                local v = decoded[flag]
                if v ~= nil and elem.Set then
                    pcall(elem.Set, elem, v)
                end
            end
        end
    end
end

-- ============================================================
-- CONFIG TAB (AddConfig)
-- ============================================================
function Window:AddConfig(config)
    config = config or {}

    local configTab = self:AddTab({
        Name = config.TabName or "⚙ Config",
        Icon = config.Icon or "",
    })

    local themeSection = configTab:AddSection({ Name = "Themes" })

    local themeDropdown = themeSection:AddDropdown({
        Name    = "Theme",
        Options = ThemeNames,
        Default = self._lib._themeName,
        Callback = function(selected)
            self._lib:_ApplyTheme(selected)
        end,
    })

    -- Save/Load section
    local saveSection = configTab:AddSection({ Name = "Configuration" })

    saveSection:AddButton({
        Name        = "Save Config",
        ButtonText  = "Save",
        Callback    = function()
            self:SaveConfig()
            self:_Notify("Config saved!", "✅")
        end,
    })

    saveSection:AddButton({
        Name        = "Load Config",
        ButtonText  = "Load",
        Callback    = function()
            self:LoadConfig()
            self:_Notify("Config loaded!", "📂")
        end,
    })

    saveSection:AddButton({
        Name        = "Reset Config",
        ButtonText  = "Reset",
        Callback    = function()
            self._configData = {}
            self:SaveConfig()
            self:_Notify("Config reset!", "🔄")
        end,
    })

    -- Info section
    local infoSection = configTab:AddSection({ Name = "Info" })
    infoSection:AddLabel({ Text = "NexusUI v" .. NexusUI._version .. "  |  Current Theme: " .. self._lib._themeName })

    return configTab
end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
function Window:_Notify(message, icon, duration)
    duration = duration or 3
    local SG = self._lib:_GetScreenGui()
    local T  = self._lib._theme

    local notifFrame = Create("Frame", {
        Name            = "Notification",
        Size            = UDim2.fromOffset(280, 56),
        Position        = UDim2.new(1, 10, 1, -70),
        BackgroundColor3 = T.Notification,
        BorderSizePixel = 0,
        ZIndex          = 50,
        Parent          = SG,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = notifFrame })
    Create("UIStroke", { Color = T.Accent, Thickness = 1.5, Transparency = 0.3, Parent = notifFrame })

    local accentBar = Create("Frame", {
        Size            = UDim2.fromOffset(4, 36),
        Position        = UDim2.fromOffset(8, 10),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 51,
        Parent          = notifFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accentBar })

    if icon and icon ~= "" then
        Create("TextLabel", {
            Size            = UDim2.fromOffset(26, 56),
            Position        = UDim2.fromOffset(18, 0),
            BackgroundTransparency = 1,
            Text            = icon,
            Font            = Enum.Font.Gotham,
            TextSize        = 18,
            TextColor3      = T.Text,
            ZIndex          = 51,
            Parent          = notifFrame,
        })
    end

    Create("TextLabel", {
        Size            = UDim2.new(1, -56, 0, 18),
        Position        = UDim2.fromOffset(46, 10),
        BackgroundTransparency = 1,
        Text            = "NexusUI",
        Font            = Enum.Font.GothamBold,
        TextSize         = 11,
        TextColor3      = T.Accent,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 51,
        Parent          = notifFrame,
    })

    Create("TextLabel", {
        Size            = UDim2.new(1, -56, 0, 24),
        Position        = UDim2.fromOffset(46, 26),
        BackgroundTransparency = 1,
        Text            = message,
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextWrapped     = true,
        ZIndex          = 51,
        Parent          = notifFrame,
    })

    -- Progress line
    local progressLine = Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 3),
        Position        = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 51,
        Parent          = notifFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progressLine })

    -- Slide in
    notifFrame.BackgroundTransparency = 1
    Tween(notifFrame, TI.Spring, {
        Position = UDim2.new(1, -290, 1, -70),
        BackgroundTransparency = 0,
    })

    Tween(progressLine, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3),
    })

    task.delay(duration, function()
        Tween(notifFrame, TI.Normal, {
            Position = UDim2.new(1, 10, 1, -70),
            BackgroundTransparency = 1,
        })
        task.delay(0.25, function()
            if notifFrame then notifFrame:Destroy() end
        end)
    end)
end

-- ============================================================
-- WINDOW FACTORY
-- ============================================================
function NexusUI:CreateWindow(config)
    config = config or {}

    local function proceed()
        local win = Window.new(self, config)
        table.insert(self._windows, win)

        -- Load config
        task.defer(function()
            win:LoadConfig()
        end)

        return win
    end

    local function startWithLoading()
        if config.LoadingEnabled then
            local dismiss = self:_ShowLoading(config)
            task.delay(config.LoadingTime or 2, function()
                dismiss()
                task.delay(0.6, function()
                    if config.KeySystem then
                        self:_ShowKeySystem(config,
                            function()
                                proceed()
                            end,
                            function()
                                warn("[NexusUI] Key validation failed.")
                            end
                        )
                    else
                        proceed()
                    end
                end)
            end)
            return nil -- Window created asynchronously
        else
            if config.KeySystem then
                self:_ShowKeySystem(config,
                    function()
                        proceed()
                    end,
                    function()
                        warn("[NexusUI] Key validation failed.")
                    end
                )
                return nil
            else
                return proceed()
            end
        end
    end

    return startWithLoading()
end

-- ============================================================
-- GLOBAL NOTIFICATION (static)
-- ============================================================
function NexusUI:Notify(config)
    local SG = self:_GetScreenGui()
    local T  = self._theme

    local notifFrame = Create("Frame", {
        Name            = "GlobalNotification",
        Size            = UDim2.fromOffset(300, 70),
        Position        = UDim2.new(1, 10, 1, -80),
        BackgroundColor3 = T.Notification,
        BorderSizePixel = 0,
        ZIndex          = 50,
        Parent          = SG,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = notifFrame })
    Create("UIStroke", { Color = T.Accent, Thickness = 1.5, Transparency = 0.3, Parent = notifFrame })

    local accentBar = Create("Frame", {
        Size            = UDim2.fromOffset(4, 46),
        Position        = UDim2.fromOffset(8, 12),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 51,
        Parent          = notifFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accentBar })

    local titleText = Create("TextLabel", {
        Size            = UDim2.new(1, -28, 0, 22),
        Position        = UDim2.fromOffset(20, 10),
        BackgroundTransparency = 1,
        Text            = config.Title or "Notification",
        Font            = Enum.Font.GothamBold,
        TextSize        = 14,
        TextColor3      = T.Text,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 51,
        Parent          = notifFrame,
    })

    local contentText = Create("TextLabel", {
        Size            = UDim2.new(1, -28, 0, 30),
        Position        = UDim2.fromOffset(20, 30),
        BackgroundTransparency = 1,
        Text            = config.Content or "",
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = T.TextDim,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextWrapped     = true,
        ZIndex          = 51,
        Parent          = notifFrame,
    })

    local progressLine = Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 3),
        Position        = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        ZIndex          = 51,
        Parent          = notifFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progressLine })

    notifFrame.BackgroundTransparency = 1
    Tween(notifFrame, TI.Spring, {
        Position = UDim2.new(1, -310, 1, -80),
        BackgroundTransparency = 0,
    })

    local duration = config.Duration or 4
    Tween(progressLine, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3),
    })

    task.delay(duration, function()
        Tween(notifFrame, TI.Normal, {
            Position = UDim2.new(1, 10, 1, -80),
            BackgroundTransparency = 1,
        })
        task.delay(0.25, function()
            if notifFrame then notifFrame:Destroy() end
        end)
    end)
end

-- ============================================================
-- DESTROY
-- ============================================================
function NexusUI:Destroy()
    local sg = self._screenGui
    if sg then
        Tween(sg:FindFirstChild("Window_") or sg, TI.Normal, {})
        task.delay(0.3, function()
            sg:Destroy()
        end)
    end
    table.clear(self._windows)
    table.clear(self._configCallbacks)
end

-- ============================================================
-- RETURN
-- ============================================================
return NexusUI
