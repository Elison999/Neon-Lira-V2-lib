--[[
    ╔══════════════════════════════════════════════════════╗
    ║           ModernUI Library - Roblox  v3.1            ║
    ║   Draggable | Resizable | Minimizable | 14 Elements  ║
    ╠══════════════════════════════════════════════════════╣
    ║  NOVIDADES v3.1:                                     ║
    ║  • sec:AddFloatingButton(label, size, callback)      ║
    ║    → toggle na section; ativado = botão arrastável   ║
    ║  • sec:AddFloatingToggleSwitch(label, size, cb)      ║
    ║    → toggle na section; ativado = toggle arrastável  ║
    ║  • Dropdown/MultiDropdown empurram elementos         ║
    ║  • Scroll automático nos dropdowns                   ║
    ║  • 20 temas completos na tab Config                  ║
    ╚══════════════════════════════════════════════════════╝
    
    ELEMENTOS: Button, Toggle, Slider, Dropdown, TextBox,
               ColorPicker, Keybind, Label, Paragraph,
               Separator, ProgressBar, MultiDropdown,
               FloatingButton, FloatingToggleSwitch
]]

local Library = {}
Library.__index = Library

-- ══ Services ══
local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local CoreGui        = game:GetService("CoreGui")
local LocalPlayer    = Players.LocalPlayer

-- ══ Theme ══
local T = {
    Bg          = Color3.fromRGB(12, 12, 18),
    Secondary   = Color3.fromRGB(18, 18, 26),
    Tertiary    = Color3.fromRGB(24, 24, 34),
    Accent      = Color3.fromRGB(90, 140, 255),
    AccentDark  = Color3.fromRGB(55, 95, 200),
    AccentGlow  = Color3.fromRGB(110, 160, 255),
    Text        = Color3.fromRGB(235, 235, 250),
    TextMuted   = Color3.fromRGB(130, 130, 155),
    Border      = Color3.fromRGB(35, 35, 50),
    BorderLight = Color3.fromRGB(50, 50, 70),
    Section     = Color3.fromRGB(20, 20, 30),
    Element     = Color3.fromRGB(28, 28, 40),
    ElementHov  = Color3.fromRGB(36, 36, 52),
    Input       = Color3.fromRGB(22, 22, 32),
    SliderBar   = Color3.fromRGB(30, 30, 44),
    ToggleOn    = Color3.fromRGB(90, 140, 255),
    ToggleOff   = Color3.fromRGB(44, 44, 60),
    Green       = Color3.fromRGB(80, 200, 120),
    Red         = Color3.fromRGB(220, 80, 80),
}

-- ══ Themes (20 temas completos) ══
local Themes = {
    ["Neon Blue"] = {
        Bg=Color3.fromRGB(12,12,18), Secondary=Color3.fromRGB(18,18,26), Tertiary=Color3.fromRGB(24,24,34),
        Accent=Color3.fromRGB(90,140,255), AccentDark=Color3.fromRGB(55,95,200), AccentGlow=Color3.fromRGB(110,160,255),
        Text=Color3.fromRGB(235,235,250), TextMuted=Color3.fromRGB(130,130,155), Border=Color3.fromRGB(35,35,50),
        BorderLight=Color3.fromRGB(50,50,70), Section=Color3.fromRGB(20,20,30), Element=Color3.fromRGB(28,28,40),
        ElementHov=Color3.fromRGB(36,36,52), Input=Color3.fromRGB(22,22,32), SliderBar=Color3.fromRGB(30,30,44),
        ToggleOn=Color3.fromRGB(90,140,255), ToggleOff=Color3.fromRGB(44,44,60),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Crimson"] = {
        Bg=Color3.fromRGB(14,8,8), Secondary=Color3.fromRGB(22,12,12), Tertiary=Color3.fromRGB(30,16,16),
        Accent=Color3.fromRGB(220,55,75), AccentDark=Color3.fromRGB(165,30,50), AccentGlow=Color3.fromRGB(255,85,105),
        Text=Color3.fromRGB(250,235,235), TextMuted=Color3.fromRGB(160,120,125), Border=Color3.fromRGB(50,25,28),
        BorderLight=Color3.fromRGB(70,35,38), Section=Color3.fromRGB(20,10,12), Element=Color3.fromRGB(30,15,17),
        ElementHov=Color3.fromRGB(42,20,22), Input=Color3.fromRGB(24,12,14), SliderBar=Color3.fromRGB(40,20,22),
        ToggleOn=Color3.fromRGB(220,55,75), ToggleOff=Color3.fromRGB(60,30,32),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(255,80,80),
    },
    ["Emerald"] = {
        Bg=Color3.fromRGB(8,14,10), Secondary=Color3.fromRGB(10,22,14), Tertiary=Color3.fromRGB(14,30,18),
        Accent=Color3.fromRGB(45,200,120), AccentDark=Color3.fromRGB(25,145,80), AccentGlow=Color3.fromRGB(70,230,145),
        Text=Color3.fromRGB(230,250,235), TextMuted=Color3.fromRGB(110,155,125), Border=Color3.fromRGB(20,45,28),
        BorderLight=Color3.fromRGB(28,62,38), Section=Color3.fromRGB(10,20,13), Element=Color3.fromRGB(14,28,18),
        ElementHov=Color3.fromRGB(18,40,25), Input=Color3.fromRGB(10,22,14), SliderBar=Color3.fromRGB(18,38,24),
        ToggleOn=Color3.fromRGB(45,200,120), ToggleOff=Color3.fromRGB(22,55,32),
        Green=Color3.fromRGB(45,220,130), Red=Color3.fromRGB(220,80,80),
    },
    ["Purple Haze"] = {
        Bg=Color3.fromRGB(12,8,18), Secondary=Color3.fromRGB(18,12,28), Tertiary=Color3.fromRGB(24,16,38),
        Accent=Color3.fromRGB(160,80,255), AccentDark=Color3.fromRGB(110,45,200), AccentGlow=Color3.fromRGB(190,110,255),
        Text=Color3.fromRGB(240,235,255), TextMuted=Color3.fromRGB(140,120,170), Border=Color3.fromRGB(40,25,60),
        BorderLight=Color3.fromRGB(58,38,85), Section=Color3.fromRGB(16,10,26), Element=Color3.fromRGB(24,15,38),
        ElementHov=Color3.fromRGB(34,22,54), Input=Color3.fromRGB(18,12,30), SliderBar=Color3.fromRGB(30,18,48),
        ToggleOn=Color3.fromRGB(160,80,255), ToggleOff=Color3.fromRGB(48,28,75),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Sunset"] = {
        Bg=Color3.fromRGB(16,10,8), Secondary=Color3.fromRGB(26,15,10), Tertiary=Color3.fromRGB(36,20,12),
        Accent=Color3.fromRGB(255,130,50), AccentDark=Color3.fromRGB(200,90,25), AccentGlow=Color3.fromRGB(255,165,85),
        Text=Color3.fromRGB(255,245,235), TextMuted=Color3.fromRGB(170,140,120), Border=Color3.fromRGB(55,30,15),
        BorderLight=Color3.fromRGB(75,42,20), Section=Color3.fromRGB(22,13,8), Element=Color3.fromRGB(32,18,11),
        ElementHov=Color3.fromRGB(44,25,15), Input=Color3.fromRGB(24,14,9), SliderBar=Color3.fromRGB(40,22,12),
        ToggleOn=Color3.fromRGB(255,130,50), ToggleOff=Color3.fromRGB(65,35,18),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Arctic"] = {
        Bg=Color3.fromRGB(8,12,18), Secondary=Color3.fromRGB(12,18,26), Tertiary=Color3.fromRGB(16,24,36),
        Accent=Color3.fromRGB(80,200,240), AccentDark=Color3.fromRGB(45,155,195), AccentGlow=Color3.fromRGB(110,220,255),
        Text=Color3.fromRGB(230,245,255), TextMuted=Color3.fromRGB(110,145,170), Border=Color3.fromRGB(20,35,52),
        BorderLight=Color3.fromRGB(28,48,70), Section=Color3.fromRGB(10,16,24), Element=Color3.fromRGB(14,22,34),
        ElementHov=Color3.fromRGB(20,30,48), Input=Color3.fromRGB(10,18,26), SliderBar=Color3.fromRGB(18,28,44),
        ToggleOn=Color3.fromRGB(80,200,240), ToggleOff=Color3.fromRGB(22,42,60),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Rose Gold"] = {
        Bg=Color3.fromRGB(18,10,12), Secondary=Color3.fromRGB(28,16,18), Tertiary=Color3.fromRGB(38,22,24),
        Accent=Color3.fromRGB(225,145,145), AccentDark=Color3.fromRGB(185,100,105), AccentGlow=Color3.fromRGB(245,170,170),
        Text=Color3.fromRGB(255,240,240), TextMuted=Color3.fromRGB(175,135,138), Border=Color3.fromRGB(55,28,30),
        BorderLight=Color3.fromRGB(78,40,43), Section=Color3.fromRGB(22,12,14), Element=Color3.fromRGB(34,18,20),
        ElementHov=Color3.fromRGB(48,25,28), Input=Color3.fromRGB(26,14,16), SliderBar=Color3.fromRGB(42,22,24),
        ToggleOn=Color3.fromRGB(225,145,145), ToggleOff=Color3.fromRGB(65,32,35),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Cyber Yellow"] = {
        Bg=Color3.fromRGB(10,10,6), Secondary=Color3.fromRGB(16,16,8), Tertiary=Color3.fromRGB(22,22,10),
        Accent=Color3.fromRGB(240,220,30), AccentDark=Color3.fromRGB(185,165,15), AccentGlow=Color3.fromRGB(255,240,70),
        Text=Color3.fromRGB(255,255,230), TextMuted=Color3.fromRGB(165,160,110), Border=Color3.fromRGB(45,42,12),
        BorderLight=Color3.fromRGB(62,58,18), Section=Color3.fromRGB(14,14,7), Element=Color3.fromRGB(22,22,10),
        ElementHov=Color3.fromRGB(32,30,14), Input=Color3.fromRGB(16,16,8), SliderBar=Color3.fromRGB(28,27,12),
        ToggleOn=Color3.fromRGB(240,220,30), ToggleOff=Color3.fromRGB(55,52,15),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Midnight"] = {
        Bg=Color3.fromRGB(6,6,10), Secondary=Color3.fromRGB(10,10,16), Tertiary=Color3.fromRGB(14,14,22),
        Accent=Color3.fromRGB(100,100,200), AccentDark=Color3.fromRGB(65,65,155), AccentGlow=Color3.fromRGB(130,130,230),
        Text=Color3.fromRGB(220,220,240), TextMuted=Color3.fromRGB(110,110,140), Border=Color3.fromRGB(22,22,38),
        BorderLight=Color3.fromRGB(32,32,55), Section=Color3.fromRGB(9,9,14), Element=Color3.fromRGB(14,14,22),
        ElementHov=Color3.fromRGB(20,20,32), Input=Color3.fromRGB(10,10,18), SliderBar=Color3.fromRGB(18,18,30),
        ToggleOn=Color3.fromRGB(100,100,200), ToggleOff=Color3.fromRGB(28,28,50),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Forest"] = {
        Bg=Color3.fromRGB(8,12,8), Secondary=Color3.fromRGB(12,18,12), Tertiary=Color3.fromRGB(16,24,16),
        Accent=Color3.fromRGB(95,175,75), AccentDark=Color3.fromRGB(60,130,45), AccentGlow=Color3.fromRGB(120,205,100),
        Text=Color3.fromRGB(230,245,225), TextMuted=Color3.fromRGB(115,148,110), Border=Color3.fromRGB(22,40,20),
        BorderLight=Color3.fromRGB(30,55,28), Section=Color3.fromRGB(10,16,10), Element=Color3.fromRGB(14,22,14),
        ElementHov=Color3.fromRGB(20,32,18), Input=Color3.fromRGB(10,18,10), SliderBar=Color3.fromRGB(18,30,16),
        ToggleOn=Color3.fromRGB(95,175,75), ToggleOff=Color3.fromRGB(24,45,22),
        Green=Color3.fromRGB(95,220,80), Red=Color3.fromRGB(220,80,80),
    },
    ["Ocean"] = {
        Bg=Color3.fromRGB(5,12,20), Secondary=Color3.fromRGB(8,18,30), Tertiary=Color3.fromRGB(10,24,40),
        Accent=Color3.fromRGB(30,160,220), AccentDark=Color3.fromRGB(15,115,175), AccentGlow=Color3.fromRGB(55,190,245),
        Text=Color3.fromRGB(220,240,255), TextMuted=Color3.fromRGB(95,140,175), Border=Color3.fromRGB(12,35,58),
        BorderLight=Color3.fromRGB(18,48,78), Section=Color3.fromRGB(6,15,25), Element=Color3.fromRGB(9,22,36),
        ElementHov=Color3.fromRGB(13,30,50), Input=Color3.fromRGB(7,16,28), SliderBar=Color3.fromRGB(10,24,40),
        ToggleOn=Color3.fromRGB(30,160,220), ToggleOff=Color3.fromRGB(12,38,60),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Lava"] = {
        Bg=Color3.fromRGB(16,6,4), Secondary=Color3.fromRGB(26,8,5), Tertiary=Color3.fromRGB(36,10,6),
        Accent=Color3.fromRGB(255,80,30), AccentDark=Color3.fromRGB(200,50,15), AccentGlow=Color3.fromRGB(255,115,65),
        Text=Color3.fromRGB(255,238,230), TextMuted=Color3.fromRGB(175,125,112), Border=Color3.fromRGB(60,18,10),
        BorderLight=Color3.fromRGB(85,25,14), Section=Color3.fromRGB(20,7,5), Element=Color3.fromRGB(32,9,6),
        ElementHov=Color3.fromRGB(46,12,8), Input=Color3.fromRGB(24,7,5), SliderBar=Color3.fromRGB(40,10,7),
        ToggleOn=Color3.fromRGB(255,80,30), ToggleOff=Color3.fromRGB(70,18,10),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(255,60,60),
    },
    ["Sakura"] = {
        Bg=Color3.fromRGB(18,10,14), Secondary=Color3.fromRGB(28,15,20), Tertiary=Color3.fromRGB(38,20,28),
        Accent=Color3.fromRGB(240,130,175), AccentDark=Color3.fromRGB(200,90,138), AccentGlow=Color3.fromRGB(255,160,200),
        Text=Color3.fromRGB(255,240,248), TextMuted=Color3.fromRGB(178,138,158), Border=Color3.fromRGB(58,25,38),
        BorderLight=Color3.fromRGB(80,35,52), Section=Color3.fromRGB(22,12,17), Element=Color3.fromRGB(34,17,25),
        ElementHov=Color3.fromRGB(48,23,35), Input=Color3.fromRGB(26,13,19), SliderBar=Color3.fromRGB(44,20,30),
        ToggleOn=Color3.fromRGB(240,130,175), ToggleOff=Color3.fromRGB(68,28,45),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Monochrome"] = {
        Bg=Color3.fromRGB(8,8,8), Secondary=Color3.fromRGB(14,14,14), Tertiary=Color3.fromRGB(20,20,20),
        Accent=Color3.fromRGB(200,200,200), AccentDark=Color3.fromRGB(145,145,145), AccentGlow=Color3.fromRGB(230,230,230),
        Text=Color3.fromRGB(245,245,245), TextMuted=Color3.fromRGB(140,140,140), Border=Color3.fromRGB(35,35,35),
        BorderLight=Color3.fromRGB(50,50,50), Section=Color3.fromRGB(12,12,12), Element=Color3.fromRGB(20,20,20),
        ElementHov=Color3.fromRGB(30,30,30), Input=Color3.fromRGB(16,16,16), SliderBar=Color3.fromRGB(28,28,28),
        ToggleOn=Color3.fromRGB(200,200,200), ToggleOff=Color3.fromRGB(45,45,45),
        Green=Color3.fromRGB(180,180,180), Red=Color3.fromRGB(120,120,120),
    },
    ["Toxic"] = {
        Bg=Color3.fromRGB(6,14,6), Secondary=Color3.fromRGB(8,22,8), Tertiary=Color3.fromRGB(10,30,10),
        Accent=Color3.fromRGB(130,255,50), AccentDark=Color3.fromRGB(90,195,25), AccentGlow=Color3.fromRGB(165,255,85),
        Text=Color3.fromRGB(230,255,225), TextMuted=Color3.fromRGB(120,170,108), Border=Color3.fromRGB(18,48,14),
        BorderLight=Color3.fromRGB(25,68,18), Section=Color3.fromRGB(7,18,7), Element=Color3.fromRGB(10,27,9),
        ElementHov=Color3.fromRGB(14,38,12), Input=Color3.fromRGB(8,20,8), SliderBar=Color3.fromRGB(12,34,10),
        ToggleOn=Color3.fromRGB(130,255,50), ToggleOff=Color3.fromRGB(20,52,14),
        Green=Color3.fromRGB(130,255,50), Red=Color3.fromRGB(220,80,80),
    },
    ["Candy"] = {
        Bg=Color3.fromRGB(16,8,16), Secondary=Color3.fromRGB(25,12,26), Tertiary=Color3.fromRGB(34,16,36),
        Accent=Color3.fromRGB(255,100,220), AccentDark=Color3.fromRGB(200,60,175), AccentGlow=Color3.fromRGB(255,140,240),
        Text=Color3.fromRGB(255,235,255), TextMuted=Color3.fromRGB(178,130,180), Border=Color3.fromRGB(55,20,58),
        BorderLight=Color3.fromRGB(78,28,82), Section=Color3.fromRGB(20,10,21), Element=Color3.fromRGB(30,14,32),
        ElementHov=Color3.fromRGB(44,20,46), Input=Color3.fromRGB(22,10,24), SliderBar=Color3.fromRGB(38,16,40),
        ToggleOn=Color3.fromRGB(255,100,220), ToggleOff=Color3.fromRGB(65,22,68),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Deep Space"] = {
        Bg=Color3.fromRGB(4,4,12), Secondary=Color3.fromRGB(6,6,20), Tertiary=Color3.fromRGB(8,8,28),
        Accent=Color3.fromRGB(70,110,255), AccentDark=Color3.fromRGB(40,70,210), AccentGlow=Color3.fromRGB(95,140,255),
        Text=Color3.fromRGB(215,220,255), TextMuted=Color3.fromRGB(100,108,158), Border=Color3.fromRGB(16,16,45),
        BorderLight=Color3.fromRGB(22,22,62), Section=Color3.fromRGB(5,5,16), Element=Color3.fromRGB(8,8,26),
        ElementHov=Color3.fromRGB(12,12,38), Input=Color3.fromRGB(6,6,20), SliderBar=Color3.fromRGB(10,10,32),
        ToggleOn=Color3.fromRGB(70,110,255), ToggleOff=Color3.fromRGB(18,18,55),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Bronze"] = {
        Bg=Color3.fromRGB(14,10,6), Secondary=Color3.fromRGB(22,15,8), Tertiary=Color3.fromRGB(30,20,10),
        Accent=Color3.fromRGB(200,148,70), AccentDark=Color3.fromRGB(155,110,42), AccentGlow=Color3.fromRGB(230,178,100),
        Text=Color3.fromRGB(255,248,230), TextMuted=Color3.fromRGB(170,145,108), Border=Color3.fromRGB(50,34,15),
        BorderLight=Color3.fromRGB(70,48,20), Section=Color3.fromRGB(18,13,7), Element=Color3.fromRGB(28,19,10),
        ElementHov=Color3.fromRGB(40,27,14), Input=Color3.fromRGB(20,14,7), SliderBar=Color3.fromRGB(36,24,12),
        ToggleOn=Color3.fromRGB(200,148,70), ToggleOff=Color3.fromRGB(58,40,18),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Ice Cream"] = {
        Bg=Color3.fromRGB(10,8,16), Secondary=Color3.fromRGB(16,12,26), Tertiary=Color3.fromRGB(22,16,36),
        Accent=Color3.fromRGB(155,210,255), AccentDark=Color3.fromRGB(105,165,220), AccentGlow=Color3.fromRGB(185,230,255),
        Text=Color3.fromRGB(235,245,255), TextMuted=Color3.fromRGB(130,155,185), Border=Color3.fromRGB(30,25,50),
        BorderLight=Color3.fromRGB(44,35,70), Section=Color3.fromRGB(13,10,21), Element=Color3.fromRGB(20,15,33),
        ElementHov=Color3.fromRGB(28,22,46), Input=Color3.fromRGB(14,11,24), SliderBar=Color3.fromRGB(24,18,40),
        ToggleOn=Color3.fromRGB(155,210,255), ToggleOff=Color3.fromRGB(38,28,62),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
    ["Void"] = {
        Bg=Color3.fromRGB(2,2,4), Secondary=Color3.fromRGB(4,4,8), Tertiary=Color3.fromRGB(6,6,12),
        Accent=Color3.fromRGB(180,50,255), AccentDark=Color3.fromRGB(130,20,205), AccentGlow=Color3.fromRGB(210,85,255),
        Text=Color3.fromRGB(230,215,255), TextMuted=Color3.fromRGB(120,98,158), Border=Color3.fromRGB(20,8,35),
        BorderLight=Color3.fromRGB(30,12,50), Section=Color3.fromRGB(3,3,6), Element=Color3.fromRGB(6,5,12),
        ElementHov=Color3.fromRGB(10,8,20), Input=Color3.fromRGB(4,4,8), SliderBar=Color3.fromRGB(8,6,16),
        ToggleOn=Color3.fromRGB(180,50,255), ToggleOff=Color3.fromRGB(24,8,42),
        Green=Color3.fromRGB(80,200,120), Red=Color3.fromRGB(220,80,80),
    },
}
local ThemeNames = {}
for k in pairs(Themes) do table.insert(ThemeNames, k) end
table.sort(ThemeNames)

-- apply a theme to T and all existing UI (called from Config tab)
local function ApplyTheme(themeName)
    local th = Themes[themeName]
    if not th then return end
    for k, v in pairs(th) do T[k] = v end
end

-- ══ Mobile Detection ══
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Helper: connect both Mouse and Touch input to a frame
local function ConnectInputBegan(frame, callback)
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            callback(inp)
        end
    end)
end

local function ConnectInputEnded(frame, callback)
    frame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            callback(inp)
        end
    end)
end

-- ══ Utilities ══
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out
        ), props):Play()
end

local function Corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color     = color or T.Border
    s.Thickness = thick or 1
    s.Parent    = parent
    return s
end

local function Gradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 0
    g.Parent   = parent
    return g
end

local function Shadow(frame, size, alpha)
    local s = Instance.new("ImageLabel")
    s.Name               = "Shadow"
    s.AnchorPoint        = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position           = UDim2.new(0.5, 0, 0.5, 6)
    s.Size               = UDim2.new(1, size or 30, 1, size or 30)
    s.ZIndex             = frame.ZIndex - 1
    s.Image              = "rbxassetid://6015897843"
    s.ImageColor3        = Color3.new(0, 0, 0)
    s.ImageTransparency  = alpha or 0.45
    s.ScaleType          = Enum.ScaleType.Slice
    s.SliceCenter        = Rect.new(49, 49, 450, 450)
    s.Parent             = frame
    return s
end

-- ══ Theme Registry ══
-- Toda vez que um objeto recebe uma cor de tema, registramos aqui.
-- O recolor varre esta lista e atualiza direto — sem adivinhação de cor.
local _themed = {}   -- { {obj, prop, key}, ... }

-- Seta cor de tema em obj.BackgroundColor3 e registra para recolor futuro
local function TC(obj, key)
    obj.BackgroundColor3 = T[key]
    table.insert(_themed, {obj=obj, prop="BackgroundColor3", key=key})
    return obj
end

-- Seta cor de tema em TextColor3
local function TT(obj, key)
    obj.TextColor3 = T[key]
    table.insert(_themed, {obj=obj, prop="TextColor3", key=key})
    return obj
end

-- Seta cor de tema em UIStroke.Color
local function TS(obj, key)
    obj.Color = T[key]
    table.insert(_themed, {obj=obj, prop="Color", key=key})
    return obj
end

-- Seta ColorSequence de UIGradient com duas chaves de tema
local function TG(obj, key0, key1)
    obj.Color = ColorSequence.new(T[key0], T[key1])
    table.insert(_themed, {obj=obj, prop="Gradient", key0=key0, key1=key1})
    return obj
end

-- Aplica o tema em T e re-pinta todos os objetos registrados
local function ApplyThemeAndRecolor(themeName)
    local th = Themes[themeName]
    if not th then return end
    for k, v in pairs(th) do T[k] = v end
    -- Limpa entradas de objetos destruídos e repinta os vivos
    local alive = {}
    for _, e in ipairs(_themed) do
        local ok = pcall(function()
            if not e.obj.Parent then return end  -- destruído
            if e.prop == "BackgroundColor3" then
                e.obj.BackgroundColor3 = T[e.key]
            elseif e.prop == "TextColor3" then
                e.obj.TextColor3 = T[e.key]
            elseif e.prop == "Color" then
                e.obj.Color = T[e.key]
            elseif e.prop == "Gradient" then
                e.obj.Color = ColorSequence.new(T[e.key0], T[e.key1])
            end
            table.insert(alive, e)
        end)
        if not ok then end -- objeto destruído, descarta
    end
    _themed = alive
end

-- ══ Create Window ══
function Library.new(title, subtitle)
    local self = setmetatable({}, Library)
    self.Tabs       = {}
    self.ActiveTab  = nil
    self.Minimized  = false
    self._Elements  = {}  -- { id = string, type = string, api = table }

    -- ── ScreenGui ──
    local gui = Instance.new("ScreenGui")
    gui.Name           = "ModernUILibrary_" .. math.random(1000, 9999)
    gui.ResetOnSpawn   = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder   = 999
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = gui

    -- ── Main Window Frame ──
    local win = Instance.new("Frame")
    win.Name              = "Window"
    -- Responsive: on mobile use near-fullscreen, on PC use fixed 580×420
    if isMobile then
        win.Size     = UDim2.new(0.95, 0, 0.85, 0)
        win.Position = UDim2.new(0.025, 0, 0.075, 0)
    else
        win.Size     = UDim2.new(0, 580, 0, 420)
        win.Position = UDim2.new(0.5, -290, 0.5, -210)
    end
    win.BackgroundColor3  = T.Bg; table.insert(_themed,{obj=win,prop="BackgroundColor3",key="Bg"})
    win.BorderSizePixel   = 0
    win.ClipsDescendants  = true
    win.Parent            = gui
    Corner(win, 10)
    do local _s=Stroke(win,T.Border, 1); table.insert(_themed,{obj=_s,prop="Color",key="Border"}) end
    Shadow(win, 40, 0.35)
    self.Window = win

    -- ── Title Bar ──
    local titleBar = Instance.new("Frame")
    titleBar.Name             = "TitleBar"
    titleBar.Size             = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=titleBar,prop="BackgroundColor3",key="Secondary"})
    titleBar.BorderSizePixel  = 0
    titleBar.ZIndex           = 2
    titleBar.Parent           = win
    Corner(titleBar, 10)
    -- patch bottom-left and bottom-right corners square (only top corners rounded)
    local tbBL = Instance.new("Frame")
    tbBL.Size = UDim2.new(0,10,0,10); tbBL.Position = UDim2.new(0,0,1,-10)
    tbBL.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=tbBL,prop="BackgroundColor3",key="Secondary"}); tbBL.BorderSizePixel = 0; tbBL.ZIndex = 2; tbBL.Parent = titleBar
    local tbBR = Instance.new("Frame")
    tbBR.Size = UDim2.new(0,10,0,10); tbBR.Position = UDim2.new(1,-10,1,-10)
    tbBR.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=tbBR,prop="BackgroundColor3",key="Secondary"}); tbBR.BorderSizePixel = 0; tbBR.ZIndex = 2; tbBR.Parent = titleBar

    -- accent underline
    local accentBar = Instance.new("Frame")
    accentBar.Size            = UDim2.new(1, 0, 0, 2)
    accentBar.Position        = UDim2.new(0, 0, 1, -1)
    accentBar.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=accentBar,prop="BackgroundColor3",key="Accent"})
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex          = 3
    accentBar.Parent          = titleBar
    do local g = Gradient(accentBar, T.Accent, T.AccentDark, 0); table.insert(_themed,{obj=g,prop="Gradient",key0="Accent",key1="AccentDark"}) end

    -- icon dot
    local dot = Instance.new("Frame")
    dot.Size             = UDim2.new(0, 8, 0, 8)
    dot.Position         = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=dot,prop="BackgroundColor3",key="Accent"})
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 3
    dot.Parent           = titleBar
    Corner(dot, 4)

    -- title text
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text             = title or "Window"
    titleLbl.Size             = UDim2.new(0, 200, 1, 0)
    titleLbl.Position         = UDim2.new(0, 28, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3       = T.Text; table.insert(_themed,{obj=titleLbl,prop="TextColor3",key="Text"})
    titleLbl.Font             = Enum.Font.GothamBold
    titleLbl.TextSize         = 14
    titleLbl.TextXAlignment   = Enum.TextXAlignment.Left
    titleLbl.ZIndex           = 3
    titleLbl.Parent           = titleBar

    -- subtitle
    if subtitle then
        local subLbl = Instance.new("TextLabel")
        subLbl.Text           = subtitle
        subLbl.Size           = UDim2.new(0, 200, 1, 0)
        subLbl.Position       = UDim2.new(0, 28 + 90, 0, 0) -- placeholder, adjusted below
        subLbl.BackgroundTransparency = 1
        subLbl.TextColor3     = T.TextMuted; table.insert(_themed,{obj=subLbl,prop="TextColor3",key="TextMuted"})
        subLbl.Font           = Enum.Font.Gotham
        subLbl.TextSize       = 11
        subLbl.TextXAlignment = Enum.TextXAlignment.Left
        subLbl.ZIndex         = 3
        subLbl.Parent         = titleBar
        -- Fix: TextBounds is 0 at creation time; wait for it to be calculated
        titleLbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
            subLbl.Position = UDim2.new(0, 28 + titleLbl.TextBounds.X + 8, 0, 0)
        end)
    end

    -- minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Name              = "Minimize"
    minBtn.Size              = isMobile and UDim2.new(0, 36, 0, 36) or UDim2.new(0, 26, 0, 26)
    minBtn.Position          = isMobile and UDim2.new(1, -44, 0.5, -18) or UDim2.new(1, -34, 0.5, -13)
    minBtn.BackgroundColor3  = T.Element; table.insert(_themed,{obj=minBtn,prop="BackgroundColor3",key="Element"})
    minBtn.Text              = "—"
    minBtn.TextColor3        = T.TextMuted; table.insert(_themed,{obj=minBtn,prop="TextColor3",key="TextMuted"})
    minBtn.Font              = Enum.Font.GothamBold
    minBtn.TextSize          = isMobile and 14 or 11
    minBtn.BorderSizePixel   = 0
    minBtn.ZIndex            = 3
    minBtn.Parent            = titleBar
    Corner(minBtn, 6)
    do local _s=Stroke(minBtn,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundColor3 = T.Accent, TextColor3 = T.Text}, 0.15)
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundColor3 = T.Element, TextColor3 = T.TextMuted}, 0.15)
    end)

    -- mobile sidebar toggle button (☰) — only on mobile
    local menuBtn
    if isMobile then
        menuBtn = Instance.new("TextButton")
        menuBtn.Name              = "MenuToggle"
        menuBtn.Size              = UDim2.new(0, 36, 0, 36)
        menuBtn.Position          = UDim2.new(1, -88, 0.5, -18)
        menuBtn.BackgroundColor3  = T.Element; table.insert(_themed,{obj=menuBtn,prop="BackgroundColor3",key="Element"})
        menuBtn.Text              = "☰"
        menuBtn.TextColor3        = T.TextMuted; table.insert(_themed,{obj=menuBtn,prop="TextColor3",key="TextMuted"})
        menuBtn.Font              = Enum.Font.GothamBold
        menuBtn.TextSize          = 16
        menuBtn.BorderSizePixel   = 0
        menuBtn.ZIndex            = 3
        menuBtn.Parent            = titleBar
        Corner(menuBtn, 6)
        do local _s=Stroke(menuBtn,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end
    end
    self._MenuBtn = menuBtn

    -- ── Content (TabBar + Main) ──
    local content = Instance.new("Frame")
    content.Name             = "Content"
    content.Size             = UDim2.new(1, 0, 1, -40)
    content.Position         = UDim2.new(0, 0, 0, 40)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    content.Parent           = win
    self.Content = content

    -- ── Tab Sidebar ──
    local SIDEBAR_W = isMobile and 110 or 140
    local sidebar = Instance.new("Frame")
    sidebar.Name             = "Sidebar"
    sidebar.Size             = UDim2.new(0, SIDEBAR_W, 1, 0)
    sidebar.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=sidebar,prop="BackgroundColor3",key="Secondary"})
    sidebar.BorderSizePixel  = 0
    sidebar.Parent           = content
    self._Sidebar = sidebar
    self._SidebarOpen = true
    -- patch only right corners square (left corners are rounded to match window)
    Corner(sidebar, 10)
    local sbTR = Instance.new("Frame")
    sbTR.Size = UDim2.new(0,10,0,10); sbTR.Position = UDim2.new(1,-10,0,0)
    sbTR.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=sbTR,prop="BackgroundColor3",key="Secondary"}); sbTR.BorderSizePixel = 0; sbTR.Parent = sidebar
    local sbBR = Instance.new("Frame")
    sbBR.Size = UDim2.new(0,10,0,10); sbBR.Position = UDim2.new(1,-10,1,-10)
    sbBR.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=sbBR,prop="BackgroundColor3",key="Secondary"}); sbBR.BorderSizePixel = 0; sbBR.Parent = sidebar

    -- sidebar header
    local sideHeader = Instance.new("TextLabel")
    sideHeader.Text           = "NAVEGAÇÃO"
    sideHeader.Size           = UDim2.new(1, -16, 0, 28)
    sideHeader.Position       = UDim2.new(0, 10, 0, 6)
    sideHeader.BackgroundTransparency = 1
    sideHeader.TextColor3     = T.TextMuted; table.insert(_themed,{obj=sideHeader,prop="TextColor3",key="TextMuted"})
    sideHeader.Font           = Enum.Font.GothamBold
    sideHeader.TextSize       = 9
    sideHeader.TextXAlignment = Enum.TextXAlignment.Left
    sideHeader.Parent         = sidebar

    -- separator under header
    local sideDiv = Instance.new("Frame")
    sideDiv.Size             = UDim2.new(1, -16, 0, 1)
    sideDiv.Position         = UDim2.new(0, 8, 0, 34)
    sideDiv.BackgroundColor3 = T.Border; table.insert(_themed,{obj=sideDiv,prop="BackgroundColor3",key="Border"})
    sideDiv.BorderSizePixel  = 0
    sideDiv.Parent           = sidebar

    -- tab list scroll
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name                  = "TabList"
    tabScroll.Size                  = UDim2.new(1, -8, 1, -42)
    tabScroll.Position              = UDim2.new(0, 4, 0, 38)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel       = 0
    tabScroll.ScrollBarThickness    = 2
    tabScroll.ScrollBarImageColor3  = T.Accent
    tabScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    tabScroll.Parent                = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding   = UDim.new(0, 3)
    tabListLayout.Parent    = tabScroll

    local tabListPad = Instance.new("UIPadding")
    tabListPad.PaddingTop = UDim.new(0, 2)
    tabListPad.Parent     = tabScroll

    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 4)
    end)

    self.TabScroll     = tabScroll
    self.TabListLayout = tabListLayout

    -- ── Main Content Area ──
    local mainArea = Instance.new("Frame")
    mainArea.Name             = "MainArea"
    mainArea.Size             = UDim2.new(1, -SIDEBAR_W, 1, 0)
    mainArea.Position         = UDim2.new(0, SIDEBAR_W, 0, 0)
    mainArea.BackgroundColor3 = T.Bg; table.insert(_themed,{obj=mainArea,prop="BackgroundColor3",key="Bg"})
    mainArea.BorderSizePixel  = 0
    mainArea.ClipsDescendants = true
    mainArea.Parent           = content
    self.MainArea = mainArea

    -- ── Resize Handle ──
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name             = "ResizeHandle"
    resizeHandle.Size             = UDim2.new(0, 18, 0, 18)
    resizeHandle.Position         = UDim2.new(1, -18, 1, -18)
    resizeHandle.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=resizeHandle,prop="BackgroundColor3",key="Accent"})
    resizeHandle.Text             = ""
    resizeHandle.BorderSizePixel  = 0
    resizeHandle.ZIndex           = 10
    resizeHandle.Parent           = win
    Corner(resizeHandle, 4)

    -- resize icon lines
    local function makeLine(x, y, w, h)
        local l = Instance.new("Frame")
        l.Size             = UDim2.new(0, w, 0, h)
        l.Position         = UDim2.new(0, x, 0, y)
        l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        l.BorderSizePixel  = 0
        l.ZIndex           = 11
        l.Parent           = resizeHandle
        Corner(l, 1)
    end
    makeLine(4, 12, 10, 2)
    makeLine(4,  8,  6, 2)
    makeLine(4,  4,  2, 2)

    -- ══ DRAGGING (Mouse + Touch) ══
    local dragging, dragStart, winStart = false, nil, nil
    ConnectInputBegan(titleBar, function(inp)
        dragging  = true
        dragStart = inp.Position
        winStart  = win.Position
    end)
    ConnectInputEnded(titleBar, function()
        dragging = false
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            local d = inp.Position - dragStart
            win.Position = UDim2.new(
                winStart.X.Scale, winStart.X.Offset + d.X,
                winStart.Y.Scale, winStart.Y.Offset + d.Y
            )
        end
    end)

    -- ══ RESIZE (Mouse + Touch) ══
    local resizing, resizeStart, startSize = false, nil, nil
    local MIN_W, MIN_H = isMobile and 280 or 420, isMobile and 220 or 300

    ConnectInputBegan(resizeHandle, function(inp)
        if self.Minimized then return end
        resizing    = true
        resizeStart = inp.Position
        startSize   = Vector2.new(win.AbsoluteSize.X, win.AbsoluteSize.Y)
    end)
    ConnectInputEnded(resizeHandle, function()
        resizing = false
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not resizing then return end
        if self.Minimized then resizing = false; return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            local d  = inp.Position - resizeStart
            local nw = math.max(MIN_W, startSize.X + d.X)
            local nh = math.max(MIN_H, startSize.Y + d.Y)
            win.Size = UDim2.new(0, nw, 0, nh)
        end
    end)

    -- ══ MINIMIZE ══
    local storedH = 420
    minBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            storedH = win.AbsoluteSize.Y
            Tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, 40)}, 0.28, Enum.EasingStyle.Quart)
            task.delay(0.1, function() content.Visible = false end)
            minBtn.Text = "+"
        else
            content.Visible = true
            Tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, storedH)}, 0.28, Enum.EasingStyle.Quart)
            minBtn.Text = "—"
        end
    end)

    -- ══ MOBILE SIDEBAR TOGGLE ══
    if isMobile and menuBtn then
        menuBtn.MouseButton1Click:Connect(function()
            self._SidebarOpen = not self._SidebarOpen
            if self._SidebarOpen then
                Tween(sidebar,   {Size = UDim2.new(0, SIDEBAR_W, 1, 0)}, 0.22, Enum.EasingStyle.Quart)
                Tween(mainArea,  {Size = UDim2.new(1, -SIDEBAR_W, 1, 0), Position = UDim2.new(0, SIDEBAR_W, 0, 0)}, 0.22, Enum.EasingStyle.Quart)
            else
                Tween(sidebar,   {Size = UDim2.new(0, 0, 1, 0)}, 0.22, Enum.EasingStyle.Quart)
                Tween(mainArea,  {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}, 0.22, Enum.EasingStyle.Quart)
            end
        end)
    end

    return self
end

-- ══ Add Tab ══
function Library:AddTab(name, icon)
    local idx = #self.Tabs + 1

    -- tab button
    local btn = Instance.new("TextButton")
    btn.Name             = "Tab_" .. name
    btn.Size             = isMobile and UDim2.new(1, 0, 0, 42) or UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = T.Element; table.insert(_themed,{obj=btn,prop="BackgroundColor3",key="Element"})
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = idx
    btn.Parent           = self.TabScroll
    Corner(btn, 7)

    -- active indicator bar
    local bar = Instance.new("Frame")
    bar.Size             = UDim2.new(0, 3, 0.55, 0)
    bar.Position         = UDim2.new(0, 1, 0.225, 0)
    bar.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=bar,prop="BackgroundColor3",key="Accent"})
    bar.BorderSizePixel  = 0
    bar.BackgroundTransparency = 1
    bar.Parent           = btn
    Corner(bar, 2)

    -- icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Text             = icon or "◈"
    iconLbl.Size             = UDim2.new(0, 22, 1, 0)
    iconLbl.Position         = UDim2.new(0, 10, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextColor3       = T.TextMuted; table.insert(_themed,{obj=iconLbl,prop="TextColor3",key="TextMuted"})
    iconLbl.Font             = Enum.Font.GothamBold
    iconLbl.TextSize         = 14
    iconLbl.Parent           = btn

    -- name
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Text             = name
    nameLbl.Size             = UDim2.new(1, -36, 1, 0)
    nameLbl.Position         = UDim2.new(0, 34, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3       = T.TextMuted; table.insert(_themed,{obj=nameLbl,prop="TextColor3",key="TextMuted"})
    nameLbl.Font             = Enum.Font.Gotham
    nameLbl.TextSize         = 13
    nameLbl.TextXAlignment   = Enum.TextXAlignment.Left
    nameLbl.Parent           = btn

    -- tab page (scrolling)
    local page = Instance.new("ScrollingFrame")
    page.Name                   = "Page_" .. name
    page.Size                   = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel        = 0
    page.ScrollBarThickness     = 3
    page.ScrollBarImageColor3   = T.Accent
    page.CanvasSize             = UDim2.new(0, 0, 0, 0)
    page.Visible                = false
    page.Parent                 = self.MainArea

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding   = UDim.new(0, 6)
    pageLayout.Parent    = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingLeft   = UDim.new(0, 8)
    pagePad.PaddingRight  = UDim.new(0, 8)
    pagePad.PaddingTop    = UDim.new(0, 8)
    pagePad.PaddingBottom = UDim.new(0, 8)
    pagePad.Parent        = page

    -- Auto-scroll: recalculate canvas whenever content changes size
    local function updateCanvas()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local tabData = {
        Name     = name,
        Button   = btn,
        Bar      = bar,
        Icon     = iconLbl,
        Label    = nameLbl,
        Page     = page,
    }

    -- hover
    btn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabData then
            Tween(btn, {BackgroundColor3 = T.ElementHov}, 0.12)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabData then
            Tween(btn, {BackgroundColor3 = T.Element}, 0.12)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        self:_SelectTab(tabData)
    end)

    table.insert(self.Tabs, tabData)
    if idx == 1 then self:_SelectTab(tabData) end

    -- return tab API
    local tabAPI = { _data = tabData, _lib = self }
    function tabAPI:AddSection(sname)
        return Library._MakeSection(page, sname, self._lib)
    end
    return tabAPI
end

function Library:_SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
        Tween(t.Button, {BackgroundColor3 = T.Element}, 0.15)
        Tween(t.Label,  {TextColor3 = T.TextMuted}, 0.15)
        Tween(t.Icon,   {TextColor3 = T.TextMuted}, 0.15)
        Tween(t.Bar,    {BackgroundTransparency = 1}, 0.15)
    end
    tab.Page.Visible = true
    Tween(tab.Button, {BackgroundColor3 = T.AccentDark}, 0.18)
    Tween(tab.Label,  {TextColor3 = T.Accent}, 0.18)
    Tween(tab.Icon,   {TextColor3 = T.AccentGlow}, 0.18)
    Tween(tab.Bar,    {BackgroundTransparency = 0}, 0.18)
    self.ActiveTab = tab
end

-- ══ Section ══
function Library._MakeSection(parent, name, lib)
    local section = Instance.new("Frame")
    section.Name             = "Section_" .. name
    section.Size             = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize    = Enum.AutomaticSize.Y
    section.BackgroundColor3 = T.Section; table.insert(_themed,{obj=section,prop="BackgroundColor3",key="Section"})
    section.BorderSizePixel  = 0
    section.Parent           = parent
    Corner(section, 8)
    do local _s=Stroke(section,T.Border, 1); table.insert(_themed,{obj=_s,prop="Color",key="Border"}) end

    -- header
    local header = Instance.new("Frame")
    header.Size             = UDim2.new(1, 0, 0, 32)
    header.BackgroundTransparency = 1
    header.Parent           = section

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Text          = name
    headerLbl.Size          = UDim2.new(1, -16, 1, 0)
    headerLbl.Position      = UDim2.new(0, 12, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.TextColor3    = T.Text; table.insert(_themed,{obj=headerLbl,prop="TextColor3",key="Text"})
    headerLbl.Font          = Enum.Font.GothamBold
    headerLbl.TextSize      = 12
    headerLbl.TextXAlignment = Enum.TextXAlignment.Left
    headerLbl.Parent        = header

    -- divider
    local div = Instance.new("Frame")
    div.Size             = UDim2.new(1, -16, 0, 1)
    div.Position         = UDim2.new(0, 8, 0, 31)
    div.BackgroundColor3 = T.Border; table.insert(_themed,{obj=div,prop="BackgroundColor3",key="Border"})
    div.BorderSizePixel  = 0
    div.Parent           = section

    -- elements holder
    local holder = Instance.new("Frame")
    holder.Name           = "Holder"
    holder.Size           = UDim2.new(1, 0, 0, 0)
    holder.Position       = UDim2.new(0, 0, 0, 32)
    holder.AutomaticSize  = Enum.AutomaticSize.Y
    holder.BackgroundTransparency = 1
    holder.Parent         = section

    local hLayout = Instance.new("UIListLayout")
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.Padding   = UDim.new(0, 1)
    hLayout.Parent    = holder

    local hPad = Instance.new("UIPadding")
    hPad.PaddingLeft   = UDim.new(0, 6)
    hPad.PaddingRight  = UDim.new(0, 6)
    hPad.PaddingBottom = UDim.new(0, 6)
    hPad.Parent        = holder

    -- ── Element Builder ──
    local S = {}   -- section object

    -- Register an element for config save/load
    local function Reg(id, elemType, api)
        if lib then
            table.insert(lib._Elements, {id = id, elemType = elemType, api = api})
        end
        return api
    end

    local function BaseElem(h)
        local f = Instance.new("Frame")
        f.Size             = UDim2.new(1, 0, 0, isMobile and math.max((h or 32) + 6, 38) or (h or 32))
        f.BackgroundColor3 = T.Element; table.insert(_themed,{obj=f,prop="BackgroundColor3",key="Element"})
        f.BorderSizePixel  = 0
        f.Parent           = holder
        Corner(f, 6)
        return f
    end

    local function LeftLabel(parent, text, size)
        local l = Instance.new("TextLabel")
        l.Text             = text
        l.Size             = UDim2.new(0.55, 0, 1, 0)
        l.Position         = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3       = T.Text; table.insert(_themed,{obj=l,prop="TextColor3",key="Text"})
        l.Font             = Enum.Font.Gotham
        l.TextSize         = size or 13
        l.TextXAlignment   = Enum.TextXAlignment.Left
        l.Parent           = parent
        return l
    end

    -- ══════════════════════════════════════
    --  1. BUTTON
    -- ══════════════════════════════════════
    function S:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = T.Element; table.insert(_themed,{obj=btn,prop="BackgroundColor3",key="Element"})
        btn.Text             = ""
        btn.BorderSizePixel  = 0
        btn.Parent           = holder
        Corner(btn, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Text             = text or "Button"
        lbl.Size             = UDim2.new(1, -16, 1, 0)
        lbl.Position         = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3       = T.Text; table.insert(_themed,{obj=lbl,prop="TextColor3",key="Text"})
        lbl.Font             = Enum.Font.Gotham
        lbl.TextSize         = 13
        lbl.TextXAlignment   = Enum.TextXAlignment.Center
        lbl.Parent           = btn

        -- gradient on button
        local bg = Instance.new("Frame")
        bg.Size             = UDim2.new(1, 0, 1, 0)
        bg.BackgroundTransparency = 1
        bg.BorderSizePixel  = 0
        bg.Parent           = btn
        Corner(bg, 6)

        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = T.Accent}, 0.15)
            Tween(lbl, {TextColor3 = Color3.new(1,1,1)}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = T.Element}, 0.15)
            Tween(lbl, {TextColor3 = T.Text}, 0.15)
        end)
        btn.MouseButton1Down:Connect(function()
            Tween(btn, {BackgroundColor3 = T.AccentDark}, 0.06)
        end)
        btn.MouseButton1Up:Connect(function()
            Tween(btn, {BackgroundColor3 = T.Accent}, 0.12)
            if callback then task.spawn(callback) end
        end)

        local api = {}
        function api:SetText(t) lbl.Text = t end
        return api
    end

    -- ══════════════════════════════════════
    --  2. TOGGLE
    -- ══════════════════════════════════════
    function S:AddToggle(text, default, callback)
        local val = default or false
        local elem = BaseElem(30)
        LeftLabel(elem, text)

        local trackBg = Instance.new("Frame")
        trackBg.Size             = UDim2.new(0, 38, 0, 20)
        trackBg.Position         = UDim2.new(1, -46, 0.5, -10)
        trackBg.BackgroundColor3 = val and T.ToggleOn or T.ToggleOff
        trackBg.BorderSizePixel  = 0
        trackBg.Parent           = elem
        Corner(trackBg, 10)

        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, 14, 0, 14)
        dot.Position         = UDim2.new(0, val and 21 or 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.new(1,1,1)
        dot.BorderSizePixel  = 0
        dot.Parent           = trackBg
        Corner(dot, 7)

        local clickArea = Instance.new("TextButton")
        clickArea.Size             = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text             = ""
        clickArea.Parent           = elem

        local function update(v)
            val = v
            Tween(trackBg, {BackgroundColor3 = val and T.ToggleOn or T.ToggleOff}, 0.18)
            Tween(dot, {Position = UDim2.new(0, val and 21 or 3, 0.5, -7)}, 0.18)
        end

        clickArea.MouseButton1Click:Connect(function()
            update(not val)
            if callback then task.spawn(callback, val) end
        end)

        local api = {}
        function api:Set(v) update(v) end
        function api:Get() return val end
        return Reg(text, "Toggle", api)
    end
    -- ══════════════════════════════════════
    function S:AddSlider(text, min, max, default, callback)
        min = min or 0; max = max or 100
        local val = math.clamp(default or min, min, max)
        local elem = BaseElem(46)
        LeftLabel(elem, text, 12)

        local valLbl = Instance.new("TextLabel")
        valLbl.Text           = tostring(math.floor(val))
        valLbl.Size           = UDim2.new(0, 44, 0, 18)
        valLbl.Position       = UDim2.new(1, -50, 0, 4)
        valLbl.BackgroundTransparency = 1
        valLbl.TextColor3     = T.Accent; table.insert(_themed,{obj=valLbl,prop="TextColor3",key="Accent"})
        valLbl.Font           = Enum.Font.GothamBold
        valLbl.TextSize       = 11
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent         = elem

        local track = Instance.new("Frame")
        track.Size             = UDim2.new(1, -20, 0, 6)
        track.Position         = UDim2.new(0, 10, 0, 32)
        track.BackgroundColor3 = T.SliderBar; table.insert(_themed,{obj=track,prop="BackgroundColor3",key="SliderBar"})
        track.BorderSizePixel  = 0
        track.Parent           = elem
        Corner(track, 3)

        local fill = Instance.new("Frame")
        fill.Size             = UDim2.new((val-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=fill,prop="BackgroundColor3",key="Accent"})
        fill.BorderSizePixel  = 0
        fill.Parent           = track
        Corner(fill, 3)
        do local g = Gradient(fill, T.Accent, T.AccentDark, 0); table.insert(_themed,{obj=g,prop="Gradient",key0="Accent",key1="AccentDark"}) end

        local handle = Instance.new("Frame")
        handle.Size             = UDim2.new(0, 14, 0, 14)
        handle.AnchorPoint      = Vector2.new(0.5, 0.5)
        handle.Position         = UDim2.new((val-min)/(max-min), 0, 0.5, 0)
        handle.BackgroundColor3 = Color3.new(1,1,1)
        handle.BorderSizePixel  = 0
        handle.ZIndex           = 2
        handle.Parent           = track
        Corner(handle, 7)

        local sliding = false

        local function applyPos(input)
            local rel = math.clamp(
                (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1
            )
            val = math.floor(min + rel * (max - min))
            fill.Size    = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text  = tostring(val)
            if callback then task.spawn(callback, val) end
        end

        ConnectInputBegan(track, function(inp)
            sliding = true; applyPos(inp)
        end)
        ConnectInputEnded(track, function()
            sliding = false
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if not sliding then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch then
                applyPos(inp)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)

        local api = {}
        function api:Set(v)
            val = math.clamp(v, min, max)
            local rel = (val-min)/(max-min)
            fill.Size       = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text     = tostring(val)
        end
        function api:Get() return val end
        return Reg(text, "Slider", api)
    end
    -- ══════════════════════════════════════
    function S:AddDropdown(text, options, default, callback)
        local val  = default or (options and options[1]) or ""
        local open = false
        options    = options or {}

        -- Wrapper that can grow vertically (pushes siblings down)
        local wrapper = Instance.new("Frame")
        wrapper.Name             = "DropWrapper_" .. text
        wrapper.Size             = UDim2.new(1, 0, 0, isMobile and 38 or 30)
        wrapper.BackgroundTransparency = 1
        wrapper.BorderSizePixel  = 0
        wrapper.ClipsDescendants = false
        wrapper.ZIndex           = 6
        wrapper.Parent           = holder

        local elem = Instance.new("Frame")
        elem.Size             = UDim2.new(1, 0, 0, isMobile and 38 or 30)
        elem.BackgroundColor3 = T.Element; table.insert(_themed,{obj=elem,prop="BackgroundColor3",key="Element"})
        elem.BorderSizePixel  = 0
        elem.ZIndex           = 6
        elem.Parent           = wrapper
        Corner(elem, 6)
        LeftLabel(elem, text)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size             = UDim2.new(0, 108, 0, 22)
        dropBtn.Position         = UDim2.new(1, -114, 0.5, -11)
        dropBtn.BackgroundColor3 = T.Input; table.insert(_themed,{obj=dropBtn,prop="BackgroundColor3",key="Input"})
        dropBtn.Text             = val
        dropBtn.TextColor3       = T.Text; table.insert(_themed,{obj=dropBtn,prop="TextColor3",key="Text"})
        dropBtn.Font             = Enum.Font.Gotham
        dropBtn.TextSize         = 12
        dropBtn.BorderSizePixel  = 0
        dropBtn.ZIndex           = 6
        dropBtn.Parent           = elem
        Corner(dropBtn, 5)
        do local _s=Stroke(dropBtn,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local arrow = Instance.new("TextLabel")
        arrow.Text           = "▾"
        arrow.Size           = UDim2.new(0, 18, 1, 0)
        arrow.Position       = UDim2.new(1, -18, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.TextColor3     = T.Accent; table.insert(_themed,{obj=arrow,prop="TextColor3",key="Accent"})
        arrow.Font           = Enum.Font.GothamBold
        arrow.TextSize       = 11
        arrow.ZIndex         = 7
        arrow.Parent         = dropBtn

        -- ScrollingFrame list (auto-scroll)
        local ITEM_H  = 24
        local MAX_VIS = 5  -- max items visible before scroll kicks in
        local listH   = math.min(#options, MAX_VIS) * ITEM_H
        local MARGIN  = 4

        local list = Instance.new("ScrollingFrame")
        list.Size                  = UDim2.new(0, 108, 0, 0)
        list.Position              = UDim2.new(1, -114, 0, (isMobile and 38 or 30) + 3)
        list.BackgroundColor3      = T.Secondary; table.insert(_themed,{obj=list,prop="BackgroundColor3",key="Secondary"})
        list.BorderSizePixel       = 0
        list.ScrollBarThickness    = 3
        list.ScrollBarImageColor3  = T.Accent
        list.CanvasSize            = UDim2.new(0, 0, 0, #options * ITEM_H)
        list.ClipsDescendants      = true
        list.ZIndex                = 30
        list.Visible               = false
        list.Parent                = wrapper  -- parent to wrapper so it escapes elem clip
        Corner(list, 5)
        do local _s=Stroke(list,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent    = list

        for _, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.Size             = UDim2.new(1, 0, 0, ITEM_H)
            ob.BackgroundTransparency = 1
            ob.Text             = opt
            ob.TextColor3       = T.TextMuted; table.insert(_themed,{obj=ob,prop="TextColor3",key="TextMuted"})
            ob.Font             = Enum.Font.Gotham
            ob.TextSize         = 12
            ob.BorderSizePixel  = 0
            ob.ZIndex           = 31
            ob.Parent           = list
            ob.MouseEnter:Connect(function()
                Tween(ob, {TextColor3 = T.Text, BackgroundTransparency = 0.88}, 0.1)
                ob.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=ob,prop="BackgroundColor3",key="Accent"})
            end)
            ob.MouseLeave:Connect(function()
                Tween(ob, {TextColor3 = T.TextMuted, BackgroundTransparency = 1}, 0.1)
            end)
            ob.MouseButton1Click:Connect(function()
                val = opt
                dropBtn.Text = opt
                open = false
                Tween(list, {Size = UDim2.new(0, 108, 0, 0)}, 0.18)
                task.delay(0.18, function() list.Visible = false end)
                Tween(arrow, {Rotation = 0}, 0.18)
                -- shrink wrapper back
                Tween(wrapper, {Size = UDim2.new(1, 0, 0, isMobile and 38 or 30)}, 0.18)
                if callback then task.spawn(callback, val) end
            end)
        end

        dropBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                list.Visible = true
                local targetListH = listH + MARGIN
                Tween(list, {Size = UDim2.new(0, 108, 0, targetListH)}, 0.18)
                Tween(arrow, {Rotation = 180}, 0.18)
                -- expand wrapper to push siblings down
                Tween(wrapper, {Size = UDim2.new(1, 0, 0, (isMobile and 38 or 30) + targetListH + 3)}, 0.18)
            else
                Tween(list, {Size = UDim2.new(0, 108, 0, 0)}, 0.18)
                task.delay(0.18, function() list.Visible = false end)
                Tween(arrow, {Rotation = 0}, 0.18)
                Tween(wrapper, {Size = UDim2.new(1, 0, 0, isMobile and 38 or 30)}, 0.18)
            end
        end)

        local api = {}
        function api:Get() return val end
        function api:Set(v) val = v; dropBtn.Text = v end
        function api:GetOptions() return options end
        return Reg(text, "Dropdown", api)
    end

    -- ══════════════════════════════════════
    --  5. TEXTBOX
    -- ══════════════════════════════════════
    function S:AddTextBox(text, placeholder, callback)
        local elem = BaseElem(30)
        LeftLabel(elem, text)

        local inputWrap = Instance.new("Frame")
        inputWrap.Size             = UDim2.new(0, 118, 0, 22)
        inputWrap.Position         = UDim2.new(1, -124, 0.5, -11)
        inputWrap.BackgroundColor3 = T.Input; table.insert(_themed,{obj=inputWrap,prop="BackgroundColor3",key="Input"})
        inputWrap.BorderSizePixel  = 0
        inputWrap.Parent           = elem
        Corner(inputWrap, 5)
        do local _s=Stroke(inputWrap,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local tb = Instance.new("TextBox")
        tb.Size              = UDim2.new(1, -8, 1, 0)
        tb.Position          = UDim2.new(0, 4, 0, 0)
        tb.BackgroundTransparency = 1
        tb.Text              = ""
        tb.PlaceholderText   = placeholder or "Type here..."
        tb.PlaceholderColor3 = T.TextMuted
        tb.TextColor3        = T.Text; table.insert(_themed,{obj=tb,prop="TextColor3",key="Text"})
        tb.Font              = Enum.Font.Gotham
        tb.TextSize          = 12
        tb.TextXAlignment    = Enum.TextXAlignment.Left
        tb.ClearTextOnFocus  = false
        tb.Parent            = inputWrap

        tb.Focused:Connect(function()
            Tween(inputWrap, {BackgroundColor3 = T.ElementHov}, 0.12)
        end)
        tb.FocusLost:Connect(function(enter)
            Tween(inputWrap, {BackgroundColor3 = T.Input}, 0.12)
            if callback then task.spawn(callback, tb.Text, enter) end
        end)

        local api = {}
        function api:Get() return tb.Text end
        function api:Set(v) tb.Text = v end
        return Reg(text, "TextBox", api)
    end

    -- ══════════════════════════════════════
    --  6. COLORPICKER
    -- ══════════════════════════════════════
    function S:AddColorPicker(text, default, callback)
        local color = default or Color3.fromRGB(100, 140, 255)
        local open  = false
        local r, g, b = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)

        local elem = BaseElem(30)
        elem.ClipsDescendants = false
        elem.ZIndex = 5
        LeftLabel(elem, text)

        local preview = Instance.new("TextButton")
        preview.Size             = UDim2.new(0, 32, 0, 22)
        preview.Position         = UDim2.new(1, -40, 0.5, -11)
        preview.BackgroundColor3 = color
        preview.Text             = ""
        preview.BorderSizePixel  = 0
        preview.ZIndex           = 5
        preview.Parent           = elem
        Corner(preview, 5)
        do local _s=Stroke(preview,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local picker = Instance.new("Frame")
        picker.Size             = UDim2.new(0, 190, 0, 0)
        picker.Position         = UDim2.new(1, -198, 1, 4)
        picker.BackgroundColor3 = T.Secondary; table.insert(_themed,{obj=picker,prop="BackgroundColor3",key="Secondary"})
        picker.BorderSizePixel  = 0
        picker.ClipsDescendants = true
        picker.ZIndex           = 30
        picker.Visible          = false
        picker.Parent           = elem
        Corner(picker, 8)
        do local _s=Stroke(picker,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local pLayout = Instance.new("UIListLayout")
        pLayout.Padding   = UDim.new(0, 5)
        pLayout.Parent    = picker

        local pPad = Instance.new("UIPadding")
        pPad.PaddingLeft   = UDim.new(0, 8)
        pPad.PaddingRight  = UDim.new(0, 8)
        pPad.PaddingTop    = UDim.new(0, 8)
        pPad.PaddingBottom = UDim.new(0, 8)
        pPad.Parent        = picker

        local function recalc()
            color = Color3.fromRGB(r, g, b)
            preview.BackgroundColor3 = color
            if callback then task.spawn(callback, color) end
        end

        local chColors = {
            R = Color3.fromRGB(220, 70, 70),
            G = Color3.fromRGB(60, 200, 80),
            B = Color3.fromRGB(80, 130, 230)
        }

        for _, ch in ipairs({"R","G","B"}) do
            local row = Instance.new("Frame")
            row.Size             = UDim2.new(1, 0, 0, 22)
            row.BackgroundTransparency = 1
            row.ZIndex           = 31
            row.Parent           = picker

            local chLbl = Instance.new("TextLabel")
            chLbl.Text           = ch
            chLbl.Size           = UDim2.new(0, 12, 1, 0)
            chLbl.BackgroundTransparency = 1
            chLbl.TextColor3     = chColors[ch]
            chLbl.Font           = Enum.Font.GothamBold
            chLbl.TextSize       = 11
            chLbl.ZIndex         = 31
            chLbl.Parent         = row

            local trackBg = Instance.new("Frame")
            trackBg.Size         = UDim2.new(1, -50, 0, 6)
            trackBg.Position     = UDim2.new(0, 16, 0.5, -3)
            trackBg.BackgroundColor3 = T.SliderBar; table.insert(_themed,{obj=trackBg,prop="BackgroundColor3",key="SliderBar"})
            trackBg.BorderSizePixel  = 0
            trackBg.ZIndex       = 31
            trackBg.Parent       = row
            Corner(trackBg, 3)

            local cval = ch == "R" and r or ch == "G" and g or b

            local tFill = Instance.new("Frame")
            tFill.Size           = UDim2.new(cval/255, 0, 1, 0)
            tFill.BackgroundColor3 = chColors[ch]
            tFill.BorderSizePixel  = 0
            tFill.ZIndex         = 32
            tFill.Parent         = trackBg
            Corner(tFill, 3)

            local numBox = Instance.new("TextBox")
            numBox.Size          = UDim2.new(0, 30, 1, 0)
            numBox.Position      = UDim2.new(1, -30, 0, 0)
            numBox.BackgroundColor3 = T.Input; table.insert(_themed,{obj=numBox,prop="BackgroundColor3",key="Input"})
            numBox.Text          = tostring(cval)
            numBox.TextColor3    = T.Text; table.insert(_themed,{obj=numBox,prop="TextColor3",key="Text"})
            numBox.Font          = Enum.Font.Gotham
            numBox.TextSize      = 10
            numBox.BorderSizePixel = 0
            numBox.ZIndex        = 31
            numBox.Parent        = row
            Corner(numBox, 3)

            local sliding = false
            ConnectInputBegan(trackBg, function(inp)
                sliding = true
                local rel = math.clamp((inp.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
                local v   = math.floor(rel*255)
                tFill.Size = UDim2.new(rel,0,1,0)
                numBox.Text = tostring(v)
                if ch=="R" then r=v elseif ch=="G" then g=v else b=v end
                recalc()
            end)
            ConnectInputEnded(trackBg, function()
                sliding = false
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if not sliding then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch then
                    local rel = math.clamp((inp.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
                    local v   = math.floor(rel*255)
                    tFill.Size = UDim2.new(rel,0,1,0)
                    numBox.Text = tostring(v)
                    if ch=="R" then r=v elseif ch=="G" then g=v else b=v end
                    recalc()
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            numBox.FocusLost:Connect(function()
                local v = math.clamp(tonumber(numBox.Text) or 0, 0, 255)
                numBox.Text = tostring(v)
                tFill.Size  = UDim2.new(v/255, 0, 1, 0)
                if ch=="R" then r=v elseif ch=="G" then g=v else b=v end
                recalc()
            end)
        end

        preview.MouseButton1Click:Connect(function()
            open = not open
            if open then
                picker.Visible = true
                Tween(picker, {Size = UDim2.new(0, 190, 0, 104)}, 0.2)
            else
                Tween(picker, {Size = UDim2.new(0, 190, 0, 0)}, 0.18)
                task.delay(0.18, function() picker.Visible = false end)
            end
        end)

        local api = {}
        function api:Get() return color end
        function api:Set(c)
            color = c
            r,g,b = math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)
            preview.BackgroundColor3 = c
        end
        return Reg(text, "ColorPicker", api)
    end

    -- ══════════════════════════════════════
    --  7. KEYBIND
    -- ══════════════════════════════════════
    function S:AddKeybind(text, default, callback)
        local key       = default or Enum.KeyCode.Unknown
        local listening = false
        local conn

        local elem = BaseElem(30)
        LeftLabel(elem, text)

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size             = UDim2.new(0, 68, 0, 22)
        keyBtn.Position         = UDim2.new(1, -74, 0.5, -11)
        keyBtn.BackgroundColor3 = T.Input; table.insert(_themed,{obj=keyBtn,prop="BackgroundColor3",key="Input"})
        keyBtn.Text             = key == Enum.KeyCode.Unknown and "NONE" or key.Name
        keyBtn.TextColor3       = T.Text; table.insert(_themed,{obj=keyBtn,prop="TextColor3",key="Text"})
        keyBtn.Font             = Enum.Font.GothamBold
        keyBtn.TextSize         = 11
        keyBtn.BorderSizePixel  = 0
        keyBtn.Parent           = elem
        Corner(keyBtn, 5)
        do local _s=Stroke(keyBtn,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        keyBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening       = true
            keyBtn.Text     = "..."
            Tween(keyBtn, {BackgroundColor3 = T.Accent}, 0.15)
            conn = UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Keyboard then
                    key             = inp.KeyCode
                    keyBtn.Text     = key.Name
                    listening       = false
                    Tween(keyBtn, {BackgroundColor3 = T.Input}, 0.15)
                    conn:Disconnect()
                    if callback then task.spawn(callback, key) end
                end
            end)
        end)

        local api = {}
        function api:Get() return key end
        function api:Set(k)
            key = k
            keyBtn.Text = k == Enum.KeyCode.Unknown and "NONE" or k.Name
        end
        return Reg(text, "Keybind", api)
    end

    -- ══════════════════════════════════════
    --  8. LABEL
    -- ══════════════════════════════════════
    function S:AddLabel(text)
        local elem = Instance.new("Frame")
        elem.Size             = UDim2.new(1, 0, 0, 26)
        elem.BackgroundTransparency = 1
        elem.BorderSizePixel  = 0
        elem.Parent           = holder

        local lbl = Instance.new("TextLabel")
        lbl.Text             = text or ""
        lbl.Size             = UDim2.new(1, -16, 1, 0)
        lbl.Position         = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3       = T.TextMuted; table.insert(_themed,{obj=lbl,prop="TextColor3",key="TextMuted"})
        lbl.Font             = Enum.Font.Gotham
        lbl.TextSize         = 12
        lbl.TextXAlignment   = Enum.TextXAlignment.Left
        lbl.TextWrapped      = true
        lbl.Parent           = elem

        local api = {}
        function api:Set(t) lbl.Text = t end
        function api:Get() return lbl.Text end
        return api
    end

    -- ══════════════════════════════════════
    --  9. PARAGRAPH
    -- ══════════════════════════════════════
    function S:AddParagraph(title, body)
        local elem = Instance.new("Frame")
        elem.Size             = UDim2.new(1, 0, 0, 0)
        elem.AutomaticSize    = Enum.AutomaticSize.Y
        elem.BackgroundColor3 = T.Input; table.insert(_themed,{obj=elem,prop="BackgroundColor3",key="Input"})
        elem.BorderSizePixel  = 0
        elem.Parent           = holder
        Corner(elem, 6)

        local inner = Instance.new("UIListLayout")
        inner.Padding   = UDim.new(0, 2)
        inner.Parent    = elem
        local ipad = Instance.new("UIPadding")
        ipad.PaddingLeft   = UDim.new(0, 8)
        ipad.PaddingRight  = UDim.new(0, 8)
        ipad.PaddingTop    = UDim.new(0, 8)
        ipad.PaddingBottom = UDim.new(0, 8)
        ipad.Parent        = elem

        local tLbl = Instance.new("TextLabel")
        tLbl.Text           = title or "Title"
        tLbl.Size           = UDim2.new(1, 0, 0, 16)
        tLbl.BackgroundTransparency = 1
        tLbl.TextColor3     = T.Text; table.insert(_themed,{obj=tLbl,prop="TextColor3",key="Text"})
        tLbl.Font           = Enum.Font.GothamBold
        tLbl.TextSize       = 12
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        tLbl.Parent         = elem

        local bLbl = Instance.new("TextLabel")
        bLbl.Text           = body or ""
        bLbl.Size           = UDim2.new(1, 0, 0, 0)
        bLbl.AutomaticSize  = Enum.AutomaticSize.Y
        bLbl.BackgroundTransparency = 1
        bLbl.TextColor3     = T.TextMuted; table.insert(_themed,{obj=bLbl,prop="TextColor3",key="TextMuted"})
        bLbl.Font           = Enum.Font.Gotham
        bLbl.TextSize       = 11
        bLbl.TextXAlignment = Enum.TextXAlignment.Left
        bLbl.TextWrapped    = true
        bLbl.Parent         = elem

        local api = {}
        function api:Set(t, bd)
            if t  then tLbl.Text = t  end
            if bd then bLbl.Text = bd end
        end
        return api
    end

    -- ══════════════════════════════════════
    --  10. SEPARATOR
    -- ══════════════════════════════════════
    function S:AddSeparator(label)
        local elem = Instance.new("Frame")
        elem.Size             = UDim2.new(1, 0, 0, 18)
        elem.BackgroundTransparency = 1
        elem.BorderSizePixel  = 0
        elem.Parent           = holder

        if label and label ~= "" then
            local l1 = Instance.new("Frame")
            l1.Size             = UDim2.new(0.3, 0, 0, 1)
            l1.Position         = UDim2.new(0, 0, 0.5, 0)
            l1.BackgroundColor3 = T.Border; table.insert(_themed,{obj=l1,prop="BackgroundColor3",key="Border"})
            l1.BorderSizePixel  = 0
            l1.Parent           = elem

            local txt = Instance.new("TextLabel")
            txt.Text            = label
            txt.Size            = UDim2.new(0.4, 0, 1, 0)
            txt.Position        = UDim2.new(0.3, 0, 0, 0)
            txt.BackgroundTransparency = 1
            txt.TextColor3      = T.TextMuted; table.insert(_themed,{obj=txt,prop="TextColor3",key="TextMuted"})
            txt.Font            = Enum.Font.Gotham
            txt.TextSize        = 10
            txt.Parent          = elem

            local l2 = Instance.new("Frame")
            l2.Size             = UDim2.new(0.3, 0, 0, 1)
            l2.Position         = UDim2.new(0.7, 0, 0.5, 0)
            l2.BackgroundColor3 = T.Border; table.insert(_themed,{obj=l2,prop="BackgroundColor3",key="Border"})
            l2.BorderSizePixel  = 0
            l2.Parent           = elem
        else
            local line = Instance.new("Frame")
            line.Size           = UDim2.new(1, 0, 0, 1)
            line.Position       = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = T.Border; table.insert(_themed,{obj=line,prop="BackgroundColor3",key="Border"})
            line.BorderSizePixel  = 0
            line.Parent         = elem
        end
    end

    -- ══════════════════════════════════════
    --  11. PROGRESS BAR
    -- ══════════════════════════════════════
    function S:AddProgressBar(text, default)
        local val = math.clamp(default or 0, 0, 100)
        local elem = BaseElem(46)

        LeftLabel(elem, text, 12)

        local pctLbl = Instance.new("TextLabel")
        pctLbl.Text           = math.floor(val) .. "%"
        pctLbl.Size           = UDim2.new(0, 44, 0, 18)
        pctLbl.Position       = UDim2.new(1, -50, 0, 4)
        pctLbl.BackgroundTransparency = 1
        pctLbl.TextColor3     = T.Accent; table.insert(_themed,{obj=pctLbl,prop="TextColor3",key="Accent"})
        pctLbl.Font           = Enum.Font.GothamBold
        pctLbl.TextSize       = 11
        pctLbl.TextXAlignment = Enum.TextXAlignment.Right
        pctLbl.Parent         = elem

        local barBg = Instance.new("Frame")
        barBg.Size            = UDim2.new(1, -20, 0, 8)
        barBg.Position        = UDim2.new(0, 10, 0, 30)
        barBg.BackgroundColor3 = T.SliderBar; table.insert(_themed,{obj=barBg,prop="BackgroundColor3",key="SliderBar"})
        barBg.BorderSizePixel  = 0
        barBg.Parent          = elem
        Corner(barBg, 4)

        local barFill = Instance.new("Frame")
        barFill.Size          = UDim2.new(val/100, 0, 1, 0)
        barFill.BackgroundColor3 = T.Accent; table.insert(_themed,{obj=barFill,prop="BackgroundColor3",key="Accent"})
        barFill.BorderSizePixel  = 0
        barFill.Parent        = barBg
        Corner(barFill, 4)
        do local g = Gradient(barFill, T.Accent, T.AccentDark, 0); table.insert(_themed,{obj=g,prop="Gradient",key0="Accent",key1="AccentDark"}) end

        -- shine
        local shine = Instance.new("Frame")
        shine.Size            = UDim2.new(0.4, 0, 0.5, 0)
        shine.BackgroundColor3 = Color3.new(1,1,1)
        shine.BackgroundTransparency = 0.75
        shine.BorderSizePixel  = 0
        shine.Parent          = barFill
        Corner(shine, 4)

        local api = {}
        function api:Set(v)
            val = math.clamp(v, 0, 100)
            Tween(barFill, {Size = UDim2.new(val/100, 0, 1, 0)}, 0.3)
            pctLbl.Text = math.floor(val) .. "%"
        end
        function api:Get() return val end
        return api
    end

    -- ══════════════════════════════════════
    --  12. MULTI-DROPDOWN
    -- ══════════════════════════════════════
    function S:AddMultiDropdown(text, options, callback)
        local selected = {}
        local open     = false
        options        = options or {}

        -- Wrapper that can grow vertically (pushes siblings down)
        local wrapper = Instance.new("Frame")
        wrapper.Name             = "MultiDropWrapper_" .. text
        wrapper.Size             = UDim2.new(1, 0, 0, isMobile and 38 or 30)
        wrapper.BackgroundTransparency = 1
        wrapper.BorderSizePixel  = 0
        wrapper.ClipsDescendants = false
        wrapper.ZIndex           = 4
        wrapper.Parent           = holder

        local elem = Instance.new("Frame")
        elem.Size             = UDim2.new(1, 0, 0, isMobile and 38 or 30)
        elem.BackgroundColor3 = T.Element; table.insert(_themed,{obj=elem,prop="BackgroundColor3",key="Element"})
        elem.BorderSizePixel  = 0
        elem.ZIndex           = 4
        elem.Parent           = wrapper
        Corner(elem, 6)
        LeftLabel(elem, text)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size             = UDim2.new(0, 108, 0, 22)
        dropBtn.Position         = UDim2.new(1, -114, 0.5, -11)
        dropBtn.BackgroundColor3 = T.Input; table.insert(_themed,{obj=dropBtn,prop="BackgroundColor3",key="Input"})
        dropBtn.Text             = "Select..."
        dropBtn.TextColor3       = T.TextMuted; table.insert(_themed,{obj=dropBtn,prop="TextColor3",key="TextMuted"})
        dropBtn.Font             = Enum.Font.Gotham
        dropBtn.TextSize         = 11
        dropBtn.BorderSizePixel  = 0
        dropBtn.ZIndex           = 4
        dropBtn.Parent           = elem
        Corner(dropBtn, 5)
        do local _s=Stroke(dropBtn,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local arrow2 = Instance.new("TextLabel")
        arrow2.Text           = "▾"
        arrow2.Size           = UDim2.new(0, 18, 1, 0)
        arrow2.Position       = UDim2.new(1, -18, 0, 0)
        arrow2.BackgroundTransparency = 1
        arrow2.TextColor3     = T.Accent; table.insert(_themed,{obj=arrow2,prop="TextColor3",key="Accent"})
        arrow2.Font           = Enum.Font.GothamBold
        arrow2.TextSize       = 11
        arrow2.ZIndex         = 5
        arrow2.Parent         = dropBtn

        -- ScrollingFrame list (auto-scroll)
        local ITEM_H  = 26
        local MAX_VIS = 5
        local listH   = math.min(#options, MAX_VIS) * ITEM_H
        local MARGIN  = 4

        local list2 = Instance.new("ScrollingFrame")
        list2.Size                  = UDim2.new(0, 125, 0, 0)
        list2.Position              = UDim2.new(1, -131, 0, (isMobile and 38 or 30) + 3)
        list2.BackgroundColor3      = T.Secondary; table.insert(_themed,{obj=list2,prop="BackgroundColor3",key="Secondary"})
        list2.BorderSizePixel       = 0
        list2.ScrollBarThickness    = 3
        list2.ScrollBarImageColor3  = T.Accent
        list2.CanvasSize            = UDim2.new(0, 0, 0, #options * ITEM_H)
        list2.ClipsDescendants      = true
        list2.ZIndex                = 28
        list2.Visible               = false
        list2.Parent                = wrapper
        Corner(list2, 5)
        do local _s=Stroke(list2,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

        local l2Layout = Instance.new("UIListLayout")
        l2Layout.SortOrder = Enum.SortOrder.LayoutOrder
        l2Layout.Parent    = list2

        local function refreshLabel()
            local cnt = 0
            for _ in pairs(selected) do cnt = cnt + 1 end
            dropBtn.Text      = cnt == 0 and "Select..." or cnt .. " selected"
            dropBtn.TextColor3 = cnt == 0 and T.TextMuted or T.Text
        end

        for _, opt in ipairs(options) do
            local row = Instance.new("Frame")
            row.Size             = UDim2.new(1, 0, 0, ITEM_H)
            row.BackgroundTransparency = 1
            row.ZIndex           = 29
            row.Parent           = list2

            local box = Instance.new("Frame")
            box.Size             = UDim2.new(0, 14, 0, 14)
            box.Position         = UDim2.new(0, 6, 0.5, -7)
            box.BackgroundColor3 = T.SliderBar; table.insert(_themed,{obj=box,prop="BackgroundColor3",key="SliderBar"})
            box.BorderSizePixel  = 0
            box.ZIndex           = 30
            box.Parent           = row
            Corner(box, 3)
            do local _s=Stroke(box,T.BorderLight, 1); table.insert(_themed,{obj=_s,prop="Color",key="BorderLight"}) end

            local check = Instance.new("TextLabel")
            check.Text           = "✓"
            check.Size           = UDim2.new(1, 0, 1, 0)
            check.BackgroundTransparency = 1
            check.TextColor3     = T.Accent; table.insert(_themed,{obj=check,prop="TextColor3",key="Accent"})
            check.Font           = Enum.Font.GothamBold
            check.TextSize       = 10
            check.Visible        = false
            check.ZIndex         = 31
            check.Parent         = box

            local optLbl = Instance.new("TextLabel")
            optLbl.Text          = opt
            optLbl.Size          = UDim2.new(1, -28, 1, 0)
            optLbl.Position      = UDim2.new(0, 26, 0, 0)
            optLbl.BackgroundTransparency = 1
            optLbl.TextColor3    = T.TextMuted; table.insert(_themed,{obj=optLbl,prop="TextColor3",key="TextMuted"})
            optLbl.Font          = Enum.Font.Gotham
            optLbl.TextSize      = 12
            optLbl.TextXAlignment = Enum.TextXAlignment.Left
            optLbl.ZIndex        = 30
            optLbl.Parent        = row

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size        = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text        = ""
            clickBtn.ZIndex      = 31
            clickBtn.Parent      = row

            clickBtn.MouseButton1Click:Connect(function()
                if selected[opt] then
                    selected[opt]    = nil
                    check.Visible    = false
                    box.BackgroundColor3 = T.SliderBar; table.insert(_themed,{obj=box,prop="BackgroundColor3",key="SliderBar"})
                    optLbl.TextColor3 = T.TextMuted; table.insert(_themed,{obj=optLbl,prop="TextColor3",key="TextMuted"})
                else
                    selected[opt]    = true
                    check.Visible    = true
                    box.BackgroundColor3 = Color3.fromRGB(25, 45, 90)
                    optLbl.TextColor3 = T.Text; table.insert(_themed,{obj=optLbl,prop="TextColor3",key="Text"})
                end
                refreshLabel()
                if callback then task.spawn(callback, selected) end
            end)
        end

        dropBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                list2.Visible = true
                local targetListH = listH + MARGIN
                Tween(list2, {Size = UDim2.new(0, 125, 0, targetListH)}, 0.18)
                Tween(arrow2, {Rotation = 180}, 0.18)
                Tween(wrapper, {Size = UDim2.new(1, 0, 0, (isMobile and 38 or 30) + targetListH + 3)}, 0.18)
            else
                Tween(list2, {Size = UDim2.new(0, 125, 0, 0)}, 0.18)
                task.delay(0.18, function() list2.Visible = false end)
                Tween(arrow2, {Rotation = 0}, 0.18)
                Tween(wrapper, {Size = UDim2.new(1, 0, 0, isMobile and 38 or 30)}, 0.18)
            end
        end)

        local api = {}
        function api:Get() return selected end
        function api:Set(tbl)
            selected = tbl
            refreshLabel()
        end
        return Reg(text, "MultiDropdown", api)
    end

    -- ══════════════════════════════════════
    --  14. FLOATING BUTTON (via section toggle)
    --  sec:AddFloatingButton(text, label, size, callback)
    --  Mostra um toggle switch na section. Quando ativado,
    --  aparece um botão arrastável com o tema atual da UI.
    -- ══════════════════════════════════════
    function S:AddFloatingButton(text, label, size, callback)
        label    = label or "▶"
        size     = size  or 52
        local enabled = false
        local fab     = nil

        -- ── toggle row na section ──
        local elem = BaseElem(30)
        LeftLabel(elem, text or "Floating Button")

        local trackBg = Instance.new("Frame")
        trackBg.Size             = UDim2.new(0, 38, 0, 20)
        trackBg.Position         = UDim2.new(1, -46, 0.5, -10)
        trackBg.BackgroundColor3 = T.ToggleOff; table.insert(_themed,{obj=trackBg,prop="BackgroundColor3",key="ToggleOff"})
        trackBg.BorderSizePixel  = 0
        trackBg.Parent           = elem
        Corner(trackBg, 10)

        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, 14, 0, 14)
        dot.Position         = UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.new(1,1,1)
        dot.BorderSizePixel  = 0
        dot.Parent           = trackBg
        Corner(dot, 7)

        local clickArea = Instance.new("TextButton")
        clickArea.Size             = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text             = ""
        clickArea.Parent           = elem

        -- ── função que cria o floating button arrastável ──
        local function createFab()
            local startPos = UDim2.new(1, -(size + 16), 0.5, 0)
            fab = Instance.new("Frame")
            fab.Name              = "FloatingButton"
            fab.Size              = UDim2.new(0, size, 0, size)
            fab.Position          = startPos
            fab.BackgroundColor3  = T.Accent
            fab.BorderSizePixel   = 0
            fab.ZIndex            = 100
            fab.Parent            = lib.ScreenGui
            Corner(fab, size / 2)

            local glow = Instance.new("UIStroke")
            glow.Color     = T.AccentGlow; table.insert(_themed,{obj=glow,prop="Color",key="AccentGlow"})
            glow.Thickness = 2
            glow.Parent    = fab

            local innerGrad = Instance.new("Frame")
            innerGrad.Size             = UDim2.new(1, 0, 1, 0)
            innerGrad.BackgroundTransparency = 0.35
            innerGrad.BackgroundColor3 = Color3.new(1, 1, 1)
            innerGrad.BorderSizePixel  = 0
            innerGrad.ZIndex           = 101
            innerGrad.Parent           = fab
            Corner(innerGrad, size / 2)
            Gradient(innerGrad, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), 90)

            Shadow(fab, 20, 0.5)

            local iconBtn = Instance.new("TextButton")
            iconBtn.Size             = UDim2.new(1, 0, 1, 0)
            iconBtn.BackgroundTransparency = 1
            iconBtn.Text             = label
            iconBtn.TextColor3       = Color3.new(1, 1, 1)
            iconBtn.Font             = Enum.Font.GothamBold
            iconBtn.TextSize         = math.floor(size * 0.4)
            iconBtn.BorderSizePixel  = 0
            iconBtn.ZIndex           = 102
            iconBtn.Parent           = fab

            -- drag
            local dragging3, dragStart3, fabStart3 = false, nil, nil
            ConnectInputBegan(fab, function(inp)
                dragging3  = true
                dragStart3 = inp.Position
                fabStart3  = fab.Position
                Tween(fab, {BackgroundColor3 = T.AccentDark}, 0.08)
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if not dragging3 then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch then
                    local d = inp.Position - dragStart3
                    fab.Position = UDim2.new(
                        fabStart3.X.Scale, fabStart3.X.Offset + d.X,
                        fabStart3.Y.Scale, fabStart3.Y.Offset + d.Y
                    )
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging3 = false
                    Tween(fab, {BackgroundColor3 = T.Accent}, 0.12)
                end
            end)

            -- click + bounce
            iconBtn.MouseButton1Click:Connect(function()
                if callback then task.spawn(callback) end
                TweenService:Create(fab, TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                    {Size = UDim2.new(0, size - 6, 0, size - 6)}):Play()
                task.delay(0.08, function()
                    TweenService:Create(fab, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, size, 0, size)}):Play()
                end)
            end)
            iconBtn.MouseEnter:Connect(function()
                if not dragging3 then Tween(fab, {BackgroundColor3 = T.AccentGlow}, 0.12) end
            end)
            iconBtn.MouseLeave:Connect(function()
                if not dragging3 then Tween(fab, {BackgroundColor3 = T.Accent}, 0.12) end
            end)

            -- aparece com tween de escala
            fab.Size = UDim2.new(0, 0, 0, 0)
            Tween(fab, {Size = UDim2.new(0, size, 0, size)}, 0.22, Enum.EasingStyle.Back)
        end

        -- ── toggle click ──
        clickArea.MouseButton1Click:Connect(function()
            enabled = not enabled
            Tween(trackBg, {BackgroundColor3 = enabled and T.ToggleOn or T.ToggleOff}, 0.18)
            Tween(dot, {Position = UDim2.new(0, enabled and 21 or 3, 0.5, -7)}, 0.18)
            if enabled then
                createFab()
            else
                if fab then
                    Tween(fab, {Size = UDim2.new(0, 0, 0, 0)}, 0.18, Enum.EasingStyle.Back)
                    task.delay(0.2, function() fab:Destroy(); fab = nil end)
                end
            end
        end)

        local api = {}
        function api:Get() return enabled end
        function api:Set(v)
            if v == enabled then return end
            clickArea.MouseButton1Click:Fire()
        end
        return api
    end

    -- ══════════════════════════════════════
    --  15. FLOATING TOGGLE SWITCH (via section toggle)
    --  sec:AddFloatingToggleSwitch(text, label, size, callback)
    --  Mostra um toggle switch na section. Quando ativado,
    --  aparece um toggle switch arrastável com o tema atual da UI.
    -- ══════════════════════════════════════
    function S:AddFloatingToggleSwitch(text, label, size, callback)
        label    = label or "⚡"
        size     = size  or 52
        local enabled  = false
        local fab      = nil
        local togState = false

        -- ── toggle row na section ──
        local elem = BaseElem(30)
        LeftLabel(elem, text or "Floating Toggle")

        local trackBg = Instance.new("Frame")
        trackBg.Size             = UDim2.new(0, 38, 0, 20)
        trackBg.Position         = UDim2.new(1, -46, 0.5, -10)
        trackBg.BackgroundColor3 = T.ToggleOff; table.insert(_themed,{obj=trackBg,prop="BackgroundColor3",key="ToggleOff"})
        trackBg.BorderSizePixel  = 0
        trackBg.Parent           = elem
        Corner(trackBg, 10)

        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, 14, 0, 14)
        dot.Position         = UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.new(1,1,1)
        dot.BorderSizePixel  = 0
        dot.Parent           = trackBg
        Corner(dot, 7)

        local clickArea = Instance.new("TextButton")
        clickArea.Size             = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text             = ""
        clickArea.Parent           = elem

        -- ── função que cria o floating toggle switch arrastável ──
        local function createFab()
            local startPos = UDim2.new(0, 16, 0.5, 0)
            fab = Instance.new("Frame")
            fab.Name              = "FloatingToggleSwitch"
            fab.Size              = UDim2.new(0, size, 0, size)
            fab.Position          = startPos
            fab.BackgroundColor3  = T.Accent
            fab.BorderSizePixel   = 0
            fab.ZIndex            = 100
            fab.Parent            = lib.ScreenGui
            Corner(fab, size / 2)

            local glow = Instance.new("UIStroke")
            glow.Color     = T.AccentGlow; table.insert(_themed,{obj=glow,prop="Color",key="AccentGlow"})
            glow.Thickness = 2
            glow.Parent    = fab

            local innerGrad = Instance.new("Frame")
            innerGrad.Size             = UDim2.new(1, 0, 1, 0)
            innerGrad.BackgroundTransparency = 0.35
            innerGrad.BackgroundColor3 = Color3.new(1, 1, 1)
            innerGrad.BorderSizePixel  = 0
            innerGrad.ZIndex           = 101
            innerGrad.Parent           = fab
            Corner(innerGrad, size / 2)
            Gradient(innerGrad, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), 90)

            Shadow(fab, 20, 0.5)

            -- toggle indicator dot
            local toggleDot = Instance.new("Frame")
            toggleDot.Size             = UDim2.new(0, 10, 0, 10)
            toggleDot.Position         = UDim2.new(1, -12, 0, 2)
            toggleDot.BackgroundColor3 = T.ToggleOff
            toggleDot.BorderSizePixel  = 0
            toggleDot.ZIndex           = 103
            toggleDot.Parent           = fab
            Corner(toggleDot, 5)
            Stroke(toggleDot, Color3.new(0,0,0), 1)

            local iconBtn = Instance.new("TextButton")
            iconBtn.Size             = UDim2.new(1, 0, 1, 0)
            iconBtn.BackgroundTransparency = 1
            iconBtn.Text             = label
            iconBtn.TextColor3       = Color3.new(1, 1, 1)
            iconBtn.Font             = Enum.Font.GothamBold
            iconBtn.TextSize         = math.floor(size * 0.4)
            iconBtn.BorderSizePixel  = 0
            iconBtn.ZIndex           = 102
            iconBtn.Parent           = fab

            -- drag
            local dragging4, dragStart4, fabStart4 = false, nil, nil
            ConnectInputBegan(fab, function(inp)
                dragging4  = true
                dragStart4 = inp.Position
                fabStart4  = fab.Position
                Tween(fab, {BackgroundColor3 = togState and T.AccentDark or T.AccentDark}, 0.08)
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if not dragging4 then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch then
                    local d = inp.Position - dragStart4
                    fab.Position = UDim2.new(
                        fabStart4.X.Scale, fabStart4.X.Offset + d.X,
                        fabStart4.Y.Scale, fabStart4.Y.Offset + d.Y
                    )
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging4 = false
                    Tween(fab, {BackgroundColor3 = togState and T.AccentDark or T.Accent}, 0.12)
                end
            end)

            -- click: alterna estado interno do toggle flutuante
            iconBtn.MouseButton1Click:Connect(function()
                togState = not togState
                if togState then
                    Tween(fab, {BackgroundColor3 = T.AccentDark}, 0.15)
                    Tween(toggleDot, {BackgroundColor3 = T.Green}, 0.15)
                else
                    Tween(fab, {BackgroundColor3 = T.Accent}, 0.15)
                    Tween(toggleDot, {BackgroundColor3 = T.ToggleOff}, 0.15)
                end
                if callback then task.spawn(callback, togState) end
                TweenService:Create(fab, TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                    {Size = UDim2.new(0, size - 6, 0, size - 6)}):Play()
                task.delay(0.08, function()
                    TweenService:Create(fab, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, size, 0, size)}):Play()
                end)
            end)
            iconBtn.MouseEnter:Connect(function()
                if not dragging4 then Tween(fab, {BackgroundColor3 = T.AccentGlow}, 0.12) end
            end)
            iconBtn.MouseLeave:Connect(function()
                if not dragging4 then Tween(fab, {BackgroundColor3 = togState and T.AccentDark or T.Accent}, 0.12) end
            end)

            -- aparece com tween
            fab.Size = UDim2.new(0, 0, 0, 0)
            Tween(fab, {Size = UDim2.new(0, size, 0, size)}, 0.22, Enum.EasingStyle.Back)
        end

        -- ── toggle click (seção) ──
        clickArea.MouseButton1Click:Connect(function()
            enabled = not enabled
            Tween(trackBg, {BackgroundColor3 = enabled and T.ToggleOn or T.ToggleOff}, 0.18)
            Tween(dot, {Position = UDim2.new(0, enabled and 21 or 3, 0.5, -7)}, 0.18)
            if enabled then
                togState = false
                createFab()
            else
                if fab then
                    Tween(fab, {Size = UDim2.new(0, 0, 0, 0)}, 0.18, Enum.EasingStyle.Back)
                    task.delay(0.2, function() fab:Destroy(); fab = nil end)
                end
            end
        end)

        local api = {}
        function api:Get() return togState end
        function api:GetEnabled() return enabled end
        return api
    end

    return S
end

-- ══ Notify ══
-- lib:Notify(message, type, duration)
-- type: "info" | "warning" | "error"   (padrão: "info")
-- duration: segundos até sumir        (padrão: 5)
do
    local _notifyGui     = nil   -- ScreenGui dedicada
    local _notifyFrame   = nil   -- frame atual
    local _notifyThread  = nil   -- thread do timer atual

    local COLORS = {
        info    = { bg = Color3.fromRGB(28, 40, 70),  border = Color3.fromRGB(90,140,255),  icon = "ℹ",  iconColor = Color3.fromRGB(90,140,255)  },
        warning = { bg = Color3.fromRGB(50, 38, 10),  border = Color3.fromRGB(240,180, 40), icon = "⚠",  iconColor = Color3.fromRGB(240,180, 40) },
        error   = { bg = Color3.fromRGB(55, 12, 12),  border = Color3.fromRGB(220, 60, 60), icon = "✕",  iconColor = Color3.fromRGB(220, 60, 60)  },
    }

    local function getGui()
        if _notifyGui and _notifyGui.Parent then return _notifyGui end
        local sg = Instance.new("ScreenGui")
        sg.Name           = "ModernUI_Notify"
        sg.ResetOnSpawn   = false
        sg.DisplayOrder   = 1000
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not sg.Parent then sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
        _notifyGui = sg
        return sg
    end

    local function killCurrent()
        if _notifyThread then
            task.cancel(_notifyThread)
            _notifyThread = nil
        end
        if _notifyFrame and _notifyFrame.Parent then
            -- fade out imediato ao ser substituído
            local old = _notifyFrame
            TweenService:Create(old, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, old.Position.Y.Offset),
            }):Play()
            for _, d in ipairs(old:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    TweenService:Create(d, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                elseif d:IsA("UIStroke") then
                    TweenService:Create(d, TweenInfo.new(0.2), {Transparency = 1}):Play()
                elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then
                    TweenService:Create(d, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
            end
            task.delay(0.22, function() if old and old.Parent then old:Destroy() end end)
            _notifyFrame = nil
        end
    end

    function Library:Notify(message, notifType, duration)
        notifType = notifType or "info"
        duration  = duration  or 5
        local cfg = COLORS[notifType] or COLORS.info

        killCurrent()

        local sg = getGui()
        local W  = isMobile and 240 or 290
        local H  = 56

        -- Frame principal
        local frame = Instance.new("Frame")
        frame.Name               = "Notification"
        frame.Size               = UDim2.new(0, W, 0, H)
        frame.Position           = UDim2.new(1, 20, 1, -(H + 16))  -- começa fora da tela (direita)
        frame.BackgroundColor3   = cfg.bg
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel    = 0
        frame.ZIndex             = 50
        frame.ClipsDescendants   = false
        frame.Parent             = sg
        Corner(frame, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color     = cfg.border
        stroke.Thickness = 1.5
        stroke.Parent    = frame

        -- Barra colorida na esquerda
        local bar = Instance.new("Frame")
        bar.Size             = UDim2.new(0, 3, 1, -16)
        bar.Position         = UDim2.new(0, 8, 0, 8)
        bar.BackgroundColor3 = cfg.border
        bar.BorderSizePixel  = 0
        bar.ZIndex           = 51
        bar.Parent           = frame
        Corner(bar, 2)

        -- Ícone
        local iconLbl = Instance.new("TextLabel")
        iconLbl.Text                = cfg.icon
        iconLbl.Size                = UDim2.new(0, 20, 0, 20)
        iconLbl.Position            = UDim2.new(0, 18, 0.5, -10)
        iconLbl.BackgroundTransparency = 1
        iconLbl.TextColor3          = cfg.iconColor
        iconLbl.Font                = Enum.Font.GothamBold
        iconLbl.TextSize            = 14
        iconLbl.ZIndex              = 51
        iconLbl.Parent              = frame

        -- Mensagem
        local msgLbl = Instance.new("TextLabel")
        msgLbl.Text                 = message or ""
        msgLbl.Size                 = UDim2.new(1, -50, 1, 0)
        msgLbl.Position             = UDim2.new(0, 44, 0, 0)
        msgLbl.BackgroundTransparency = 1
        msgLbl.TextColor3           = Color3.fromRGB(235, 235, 250)
        msgLbl.Font                 = Enum.Font.Gotham
        msgLbl.TextSize             = isMobile and 11 or 12
        msgLbl.TextXAlignment       = Enum.TextXAlignment.Left
        msgLbl.TextWrapped          = true
        msgLbl.ZIndex               = 51
        msgLbl.Parent               = frame

        -- Barra de progresso (fundo)
        local progBg = Instance.new("Frame")
        progBg.Size             = UDim2.new(1, 0, 0, 2)
        progBg.Position         = UDim2.new(0, 0, 1, -2)
        progBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        progBg.BackgroundTransparency = 0
        progBg.BorderSizePixel  = 0
        progBg.ZIndex           = 52
        progBg.Parent           = frame
        Corner(progBg, 1)

        local progFill = Instance.new("Frame")
        progFill.Size             = UDim2.new(1, 0, 1, 0)
        progFill.BackgroundColor3 = cfg.border
        progFill.BackgroundTransparency = 0
        progFill.BorderSizePixel  = 0
        progFill.ZIndex           = 53
        progFill.Parent           = progBg
        Corner(progFill, 1)

        _notifyFrame = frame

        -- Slide in da direita
        local targetX = -(W + 16)
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, targetX, 1, -(H + 16))
        }):Play()

        -- Barra de progresso encolhe ao longo do duration
        TweenService:Create(progFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 1, 0)
        }):Play()

        -- Timer: fade out suave após duration
        _notifyThread = task.spawn(function()
            task.wait(duration)
            if _notifyFrame ~= frame then return end
            -- Fade out (transparência suave)
            TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, targetX + 10, 1, -(H + 16)),
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
            TweenService:Create(bar,    TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(iconLbl,TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(msgLbl, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(progBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(progFill,TweenInfo.new(0.5),{BackgroundTransparency = 1}):Play()
            task.wait(0.52)
            if frame and frame.Parent then frame:Destroy() end
            if _notifyFrame == frame then _notifyFrame = nil end
            _notifyThread = nil
        end)
    end
end

-- ══ AddConfig ══
function Library:AddConfig()
    local configTab = self:AddTab("⚙ Config", "⚙")
    local sec = configTab:AddSection("Interface")
    local win = self.Window

    -- ── Tema ──
    local secTheme = configTab:AddSection("Tema da UI")
    secTheme:AddDropdown("Tema", ThemeNames, "Neon Blue", function(themeName)
        ApplyThemeAndRecolor(themeName)
    end)

    -- ── Transparência ──
    sec:AddToggle("Transparência 60%", false, function(v)
        local goal = v and 0.6 or 0
        for _, d in ipairs(win:GetDescendants()) do
            if (d:IsA("Frame") or d:IsA("ScrollingFrame")) and d.BackgroundTransparency < 1 then
                Tween(d, {BackgroundTransparency = goal}, 0.35, Enum.EasingStyle.Quart)
            end
        end
        if win.BackgroundTransparency < 1 or goal == 0 then
            Tween(win, {BackgroundTransparency = goal}, 0.35, Enum.EasingStyle.Quart)
        end
    end)

    -- ── Efeitos Visuais ──
    local effectsActive = false
    local particles = {}

    local function spawnParticle()
        local p = Instance.new("Frame")
        p.Size             = UDim2.new(0, math.random(3,8), 0, math.random(3,8))
        p.Position         = UDim2.new(math.random()*0.9, 0, math.random()*0.85 + 0.1, 0)
        local h, s, v = Color3.toHSV(T.Accent)
        p.BackgroundColor3 = Color3.fromHSV(h, s, math.clamp(v + math.random()*0.2 - 0.1, 0, 1))
        p.BackgroundTransparency = 0.15
        p.BorderSizePixel  = 0
        p.ZIndex           = 50
        p.Parent           = win
        Corner(p, 4)
        table.insert(particles, p)
        TweenService:Create(p, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Position = UDim2.new(p.Position.X.Scale, 0, p.Position.Y.Scale - 0.35, 0),
            BackgroundTransparency = 1
        }):Play()
        task.delay(2.1, function()
            if p and p.Parent then p:Destroy() end
            for i,v in ipairs(particles) do if v == p then table.remove(particles,i); break end end
        end)
    end

    sec:AddToggle("Efeitos Visuais", false, function(v)
        effectsActive = v
        if v then
            task.spawn(function()
                while effectsActive do
                    spawnParticle()
                    task.wait(0.35)
                end
            end)
        else
            for _, p in ipairs(particles) do
                if p and p.Parent then p:Destroy() end
            end
            particles = {}
        end
    end)

    -- ── Save/Load ──
    local secSave = configTab:AddSection("Salvar / Carregar")
    local FOLDER  = "Neon-Saves"

    local function ensureFolder()
        pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end)
    end

    local function listSaves()
        ensureFolder()
        local names = {}
        local ok, lst = pcall(listfiles, FOLDER)
        if ok and lst then
            for _, path in ipairs(lst) do
                local n = (path:match("([^/\\]+)$") or path):gsub("%.json$","")
                if n ~= "" then table.insert(names, n) end
            end
        end
        table.sort(names)
        return names
    end

    -- ── JSON encoder robusto ──
    local function jsonEncode(v)
        local t = type(v)
        if t == "string" then
            return '"' .. v:gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\n','\\n'):gsub('\r','\\r') .. '"' 
        elseif t == "number" then
            return tostring(v)
        elseif t == "boolean" then
            return v and "true" or "false"
        elseif t == "table" then
            local isArr = true
            local maxN  = 0
            for k in pairs(v) do
                if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
                    isArr = false; break
                end
                if k > maxN then maxN = k end
            end
            if isArr and maxN == #v then
                local parts = {}
                for _, item in ipairs(v) do table.insert(parts, jsonEncode(item)) end
                return "[" .. table.concat(parts, ",") .. "]"
            else
                local parts = {}
                for k, item in pairs(v) do
                    table.insert(parts, '"' .. tostring(k) .. '":'  .. jsonEncode(item))
                end
                return "{" .. table.concat(parts, ",") .. "}"
            end
        end
        return "null"
    end

    -- ── JSON decoder (parser manual) ──
    local function jsonDecode(s)
        local pos = 1
        local function skipWS()
            while pos <= #s and s:sub(pos,pos):match("%s") do pos = pos + 1 end
        end
        local parseValue
        local function parseString()
            pos = pos + 1
            local res = {}
            while pos <= #s do
                local c = s:sub(pos,pos)
                if c == '"' then pos = pos + 1; break
                elseif c == '\\\\' then
                    pos = pos + 1
                    local esc = s:sub(pos,pos)
                    local map = {['"']='"', ['\\\\']='\\\\', ['n']='\n', ['r']='\r', ['t']='\t'}
                    table.insert(res, map[esc] or esc)
                    pos = pos + 1
                else
                    table.insert(res, c); pos = pos + 1
                end
            end
            return table.concat(res)
        end
        local function parseNumber()
            local numStr = s:match("^-?%d+%.?%d*[eE]?[+-]?%d*", pos)
            pos = pos + #numStr
            return tonumber(numStr)
        end
        local function parseArray()
            pos = pos + 1
            local arr = {}
            skipWS()
            if s:sub(pos,pos) == ']' then pos = pos + 1; return arr end
            while true do
                skipWS(); table.insert(arr, parseValue()); skipWS()
                local c = s:sub(pos,pos)
                if c == ']' then pos = pos + 1; break
                elseif c == ',' then pos = pos + 1
                else break end
            end
            return arr
        end
        local function parseObject()
            pos = pos + 1
            local obj = {}
            skipWS()
            if s:sub(pos,pos) == '}' then pos = pos + 1; return obj end
            while true do
                skipWS()
                if s:sub(pos,pos) ~= '"' then break end
                local key = parseString(); skipWS()
                if s:sub(pos,pos) == ':' then pos = pos + 1 end
                skipWS()
                obj[key] = parseValue(); skipWS()
                local c = s:sub(pos,pos)
                if c == '}' then pos = pos + 1; break
                elseif c == ',' then pos = pos + 1
                else break end
            end
            return obj
        end
        parseValue = function()
            skipWS()
            local c = s:sub(pos,pos)
            if c == '"' then return parseString()
            elseif c == '{' then return parseObject()
            elseif c == '[' then return parseArray()
            elseif c == 't' then pos = pos + 4; return true
            elseif c == 'f' then pos = pos + 5; return false
            elseif c == 'n' then pos = pos + 4; return nil
            else return parseNumber() end
        end
        local ok, result = pcall(parseValue)
        return ok and result or nil
    end

    local saveNameApi  = secSave:AddTextBox("Nome da Save", "minha-config")
    local savesDropApi = secSave:AddDropdown("Saves", listSaves(), nil, nil)

    -- Atualiza lista de saves na dropdown
    local function refreshSavesDrop(selectName)
        local names = listSaves()
        local opts = savesDropApi:GetOptions()
        for i = #opts, 1, -1 do table.remove(opts, i) end
        for _, n in ipairs(names) do table.insert(opts, n) end
        if selectName then savesDropApi:Set(selectName) end
    end

    secSave:AddButton("💾 Salvar", function()
        local name = saveNameApi:Get()
        if not name or name == "" then name = "config" end
        name = name:gsub('[/\\\\:*?"<>|]', "_")
        ensureFolder()
        local data = {}
        for _, entry in ipairs(self._Elements) do
            local ok, val = pcall(function() return entry.api:Get() end)
            if ok and val ~= nil then
                local et = entry.elemType
                if et == "Toggle" then
                    data[entry.id] = {t=et, v=(val == true)}
                elseif et == "Slider" then
                    data[entry.id] = {t=et, v=tonumber(val) or 0}
                elseif et == "Dropdown" then
                    data[entry.id] = {t=et, v=tostring(val)}
                elseif et == "TextBox" then
                    data[entry.id] = {t=et, v=tostring(val)}
                elseif et == "ColorPicker" then
                    data[entry.id] = {t=et,
                        r=math.floor(val.R*255),
                        g=math.floor(val.G*255),
                        b=math.floor(val.B*255)}
                elseif et == "Keybind" then
                    data[entry.id] = {t=et, v=tostring(val)}
                elseif et == "MultiDropdown" then
                    local arr = {}
                    for k in pairs(val) do table.insert(arr, k) end
                    data[entry.id] = {t=et, v=arr}
                end
            end
        end
        local writeOk = pcall(writefile, FOLDER.."/"..name..".json", jsonEncode(data))
        if writeOk then refreshSavesDrop(name) end
    end)

    secSave:AddButton("📂 Carregar", function()
        local name = savesDropApi:Get()
        if not name or name == "" then return end
        local ok, content = pcall(readfile, FOLDER.."/"..name..".json")
        if not ok or not content or content == "" then return end
        local data = jsonDecode(content)
        if type(data) ~= "table" then return end
        for _, entry in ipairs(self._Elements) do
            local saved = data[entry.id]
            if saved and type(saved) == "table" then
                pcall(function()
                    local et = saved.t
                    if et == "Toggle" then
                        entry.api:Set(saved.v == true)
                    elseif et == "Slider" then
                        entry.api:Set(tonumber(saved.v) or 0)
                    elseif et == "Dropdown" then
                        entry.api:Set(tostring(saved.v or ""))
                    elseif et == "TextBox" then
                        entry.api:Set(tostring(saved.v or ""))
                    elseif et == "ColorPicker" then
                        entry.api:Set(Color3.fromRGB(
                            tonumber(saved.r) or 0,
                            tonumber(saved.g) or 0,
                            tonumber(saved.b) or 0))
                    elseif et == "Keybind" then
                        local kc = Enum.KeyCode[tostring(saved.v)]
                        if kc then entry.api:Set(kc) end
                    elseif et == "MultiDropdown" then
                        local tbl = {}
                        if type(saved.v) == "table" then
                            for _, k in ipairs(saved.v) do tbl[k] = true end
                        end
                        entry.api:Set(tbl)
                    end
                end)
            end
        end
    end)
end
return Library

--[[
══════════════════════════════════════════════════
  EXEMPLO DE USO — cole em um LocalScript
══════════════════════════════════════════════════

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Elison999/Neon-Lira-V2-lib/refs/heads/main/Library.Lua"))()
-- OU se for módulo local: local Lib = require(script.ModernUILibrary)

local Win = Lib.new("ModernScript", "v3.1")

-- Cria tabs com ícone (emoji ou texto)
local tabMain   = Win:AddTab("Principal", "⚙")
local tabVisual = Win:AddTab("Visual",    "👁")
local tabPlayer = Win:AddTab("Player",    "👤")

-- Tab de configuração automática (transparência, efeitos, save/load, TEMAS)
Win:AddConfig()

-- ── Seção na tab Principal ──
local sec = tabMain:AddSection("Configurações Gerais")

-- Floating Button: toggle switch na section.
-- Ao ativar → aparece um botão arrastável combinando com o tema atual.
sec:AddFloatingButton("Botão Flutuante", "🎮", 52, function()
    print("Floating button clicado!")
end)

-- Floating Toggle Switch: toggle switch na section.
-- Ao ativar → aparece um toggle switch arrastável combinando com o tema atual.
sec:AddFloatingToggleSwitch("Toggle Flutuante", "⚡", 48, function(state)
    print("Floating toggle:", state)
end)

sec:AddButton("Executar Script", function()
    print("Executando!")
end)

local tog = sec:AddToggle("God Mode", false, function(v)
    print("God Mode:", v)
end)

local spd = sec:AddSlider("WalkSpeed", 16, 250, 16, function(v)
    local char = game.Players.LocalPlayer.Character
    if char then char.Humanoid.WalkSpeed = v end
end)

-- Dropdown empurra elementos pra baixo + scroll automático
local drop = sec:AddDropdown("Time", {"Vermelho","Azul","Verde","Amarelo","Roxo","Laranja"}, "Vermelho", function(v)
    print("Time:", v)
end)

-- MultiDropdown também empurra pra baixo + scroll
local multi = sec:AddMultiDropdown("Itens", {"Espada","Escudo","Poção","Armadura","Arco","Cajado","Amuleto"}, function(sel)
    print("Selecionados:", sel)
end)

sec:AddSeparator("Extras")
sec:AddLabel("ModernUI Library  •  v3.1  •  Roblox")

-- ── Tab Visual ──
local secVis = tabVisual:AddSection("ESP & Aimbot")
secVis:AddToggle("ESP Players", false)
secVis:AddToggle("Wallhack",    false)
secVis:AddSlider("FOV Circle",  10, 500, 120)
secVis:AddColorPicker("Cor Box", Color3.fromRGB(255, 80, 80))

-- ── Tab Player ──
local secPly = tabPlayer:AddSection("Stats do Personagem")
secPly:AddSlider("WalkSpeed",  16, 250, 16)
secPly:AddSlider("JumpPower",  50, 350, 50)
secPly:AddToggle("Fly",        false)
secPly:AddToggle("Noclip",     false)

]] 
