--[[
    NexusLib - Super Modern Roblox UI Library
    Version: 2.0.0
    Developed by: Senior Luau Developer
    
    Usage:
        local NexusLib = loadstring(game:HttpGet("YOUR_LINK_HERE"))()
        local Window = NexusLib:CreateWindow({...})
    
    Features:
        - 11 UI Elements: Window, Tab, Section, Label, Button, Toggle, Slider, Dropdown, Textbox, Keybind, ColorPicker
        - Smooth TweenService animations
        - Draggable & Resizable Topbar
        - Minimize & Close (with modal confirmation)
        - Loading Screen System
        - Key System with optional save
        - Auto Save & Load (JSON)
        - 15 Themes via Window:AddConfig()
        - Full OOP architecture
]]

-- ============================================================
-- SERVICES
-- ============================================================
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local HttpService        = game:GetService("HttpService")
local Players            = game:GetService("Players")
local LocalPlayer        = Players.LocalPlayer

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function Tween(obj, props, duration, easingStyle, easingDirection, delay_time)
    local info = TweenInfo.new(
        duration or 0.25,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    if delay_time and delay_time > 0 then
        task.delay(delay_time, function() t:Play() end)
    else
        t:Play()
    end
    return t
end

local function Color3FromHex(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1,2), 16),
        tonumber(hex:sub(3,4), 16),
        tonumber(hex:sub(5,6), 16)
    )
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function LerpColor(c1, c2, t)
    return Color3.new(
        Lerp(c1.R, c2.R, t),
        Lerp(c1.G, c2.G, t),
        Lerp(c1.B, c2.B, t)
    )
end

local function RGBToHSV(color)
    local r, g, b = color.R, color.G, color.B
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min
    local h, s, v = 0, 0, max

    if max ~= 0 then s = delta / max end

    if delta ~= 0 then
        if max == r then
            h = (g - b) / delta
            if g < b then h = h + 6 end
        elseif max == g then
            h = (b - r) / delta + 2
        else
            h = (r - g) / delta + 4
        end
        h = h / 6
    end

    return h, s, v
end

local function HSVToColor3(h, s, v)
    local r, g, b = 0, 0, 0
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return Color3.new(r, g, b)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 70)
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function SafeReadFile(path)
    local ok, result = pcall(readfile, path)
    if ok then return result end
    return nil
end

local function SafeWriteFile(path, content)
    local ok, err = pcall(writefile, path, content)
    return ok
end

local function SafeJsonDecode(str)
    local ok, result = pcall(HttpService.JSONDecode, HttpService, str)
    if ok then return result end
    return nil
end

local function SafeJsonEncode(tbl)
    local ok, result = pcall(HttpService.JSONEncode, HttpService, tbl)
    if ok then return result end
    return "{}"
end

local function MakeFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

-- ============================================================
-- THEMES SYSTEM
-- ============================================================
local Themes = {
    ["Dark"] = {
        Background       = Color3FromHex("#0F0F14"),
        Topbar           = Color3FromHex("#17171F"),
        Section          = Color3FromHex("#1C1C26"),
        Element          = Color3FromHex("#22222E"),
        ElementHover     = Color3FromHex("#2A2A38"),
        Accent           = Color3FromHex("#7C5CFC"),
        AccentDark       = Color3FromHex("#5B3FD4"),
        Text             = Color3FromHex("#EAEAF5"),
        TextSecondary    = Color3FromHex("#8888AA"),
        TextDisabled     = Color3FromHex("#555566"),
        Stroke           = Color3FromHex("#2E2E3E"),
        Toggle           = Color3FromHex("#3A3A50"),
        ToggleEnabled    = Color3FromHex("#7C5CFC"),
        SliderFill       = Color3FromHex("#7C5CFC"),
        SliderTrack      = Color3FromHex("#2E2E3E"),
        Scrollbar        = Color3FromHex("#3A3A50"),
    },
    ["Light"] = {
        Background       = Color3FromHex("#F4F4FC"),
        Topbar           = Color3FromHex("#EAEAF5"),
        Section          = Color3FromHex("#DCDCEC"),
        Element          = Color3FromHex("#FFFFFF"),
        ElementHover     = Color3FromHex("#E8E8F5"),
        Accent           = Color3FromHex("#6B48FF"),
        AccentDark       = Color3FromHex("#4D2FCC"),
        Text             = Color3FromHex("#1A1A2E"),
        TextSecondary    = Color3FromHex("#6666AA"),
        TextDisabled     = Color3FromHex("#AAAACC"),
        Stroke           = Color3FromHex("#D0D0E0"),
        Toggle           = Color3FromHex("#CCCCDD"),
        ToggleEnabled    = Color3FromHex("#6B48FF"),
        SliderFill       = Color3FromHex("#6B48FF"),
        SliderTrack      = Color3FromHex("#CCCCDD"),
        Scrollbar        = Color3FromHex("#AAAACC"),
    },
    ["Midnight"] = {
        Background       = Color3FromHex("#050510"),
        Topbar           = Color3FromHex("#0A0A18"),
        Section          = Color3FromHex("#0F0F20"),
        Element          = Color3FromHex("#131328"),
        ElementHover     = Color3FromHex("#1A1A35"),
        Accent           = Color3FromHex("#00D4FF"),
        AccentDark       = Color3FromHex("#0099CC"),
        Text             = Color3FromHex("#D0E8FF"),
        TextSecondary    = Color3FromHex("#5577AA"),
        TextDisabled     = Color3FromHex("#334466"),
        Stroke           = Color3FromHex("#1A1A35"),
        Toggle           = Color3FromHex("#1A2244"),
        ToggleEnabled    = Color3FromHex("#00D4FF"),
        SliderFill       = Color3FromHex("#00D4FF"),
        SliderTrack      = Color3FromHex("#1A2244"),
        Scrollbar        = Color3FromHex("#1A2244"),
    },
    ["Neon"] = {
        Background       = Color3FromHex("#050505"),
        Topbar           = Color3FromHex("#0A0A0A"),
        Section          = Color3FromHex("#0F0F0F"),
        Element          = Color3FromHex("#141414"),
        ElementHover     = Color3FromHex("#1F1F1F"),
        Accent           = Color3FromHex("#FF00FF"),
        AccentDark       = Color3FromHex("#CC00CC"),
        Text             = Color3FromHex("#FFFFFF"),
        TextSecondary    = Color3FromHex("#AA66AA"),
        TextDisabled     = Color3FromHex("#553355"),
        Stroke           = Color3FromHex("#2A002A"),
        Toggle           = Color3FromHex("#1F001F"),
        ToggleEnabled    = Color3FromHex("#FF00FF"),
        SliderFill       = Color3FromHex("#FF00FF"),
        SliderTrack      = Color3FromHex("#1F001F"),
        Scrollbar        = Color3FromHex("#2A002A"),
    },
    ["Crimson"] = {
        Background       = Color3FromHex("#100A0A"),
        Topbar           = Color3FromHex("#180D0D"),
        Section          = Color3FromHex("#201212"),
        Element          = Color3FromHex("#271515"),
        ElementHover     = Color3FromHex("#311B1B"),
        Accent           = Color3FromHex("#FF3355"),
        AccentDark       = Color3FromHex("#CC1A33"),
        Text             = Color3FromHex("#FFE0E5"),
        TextSecondary    = Color3FromHex("#AA5566"),
        TextDisabled     = Color3FromHex("#663344"),
        Stroke           = Color3FromHex("#3A1A1A"),
        Toggle           = Color3FromHex("#2A1010"),
        ToggleEnabled    = Color3FromHex("#FF3355"),
        SliderFill       = Color3FromHex("#FF3355"),
        SliderTrack      = Color3FromHex("#2A1010"),
        Scrollbar        = Color3FromHex("#3A1A1A"),
    },
    ["Forest"] = {
        Background       = Color3FromHex("#060E08"),
        Topbar           = Color3FromHex("#0C160E"),
        Section          = Color3FromHex("#121E14"),
        Element          = Color3FromHex("#162018"),
        ElementHover     = Color3FromHex("#1E2C20"),
        Accent           = Color3FromHex("#4ADE80"),
        AccentDark       = Color3FromHex("#22C55E"),
        Text             = Color3FromHex("#DCFCE7"),
        TextSecondary    = Color3FromHex("#4D7A5A"),
        TextDisabled     = Color3FromHex("#2D4A35"),
        Stroke           = Color3FromHex("#1E3322"),
        Toggle           = Color3FromHex("#122018"),
        ToggleEnabled    = Color3FromHex("#4ADE80"),
        SliderFill       = Color3FromHex("#4ADE80"),
        SliderTrack      = Color3FromHex("#122018"),
        Scrollbar        = Color3FromHex("#1E3322"),
    },
    ["Ocean"] = {
        Background       = Color3FromHex("#060A10"),
        Topbar           = Color3FromHex("#0A1018"),
        Section          = Color3FromHex("#0E1820"),
        Element          = Color3FromHex("#121E28"),
        ElementHover     = Color3FromHex("#1A2A38"),
        Accent           = Color3FromHex("#38BDF8"),
        AccentDark       = Color3FromHex("#0EA5E9"),
        Text             = Color3FromHex("#E0F2FE"),
        TextSecondary    = Color3FromHex("#4477AA"),
        TextDisabled     = Color3FromHex("#224466"),
        Stroke           = Color3FromHex("#1A2A3A"),
        Toggle           = Color3FromHex("#0E1E30"),
        ToggleEnabled    = Color3FromHex("#38BDF8"),
        SliderFill       = Color3FromHex("#38BDF8"),
        SliderTrack      = Color3FromHex("#0E1E30"),
        Scrollbar        = Color3FromHex("#1A2A3A"),
    },
    ["Sakura"] = {
        Background       = Color3FromHex("#120810"),
        Topbar           = Color3FromHex("#1A1018"),
        Section          = Color3FromHex("#221420"),
        Element          = Color3FromHex("#2A1828"),
        ElementHover     = Color3FromHex("#342030"),
        Accent           = Color3FromHex("#F472B6"),
        AccentDark       = Color3FromHex("#EC4899"),
        Text             = Color3FromHex("#FCE7F3"),
        TextSecondary    = Color3FromHex("#AA5588"),
        TextDisabled     = Color3FromHex("#663355"),
        Stroke           = Color3FromHex("#3A1830"),
        Toggle           = Color3FromHex("#261020"),
        ToggleEnabled    = Color3FromHex("#F472B6"),
        SliderFill       = Color3FromHex("#F472B6"),
        SliderTrack      = Color3FromHex("#261020"),
        Scrollbar        = Color3FromHex("#3A1830"),
    },
    ["Amber"] = {
        Background       = Color3FromHex("#100C00"),
        Topbar           = Color3FromHex("#181200"),
        Section          = Color3FromHex("#201600"),
        Element          = Color3FromHex("#281A00"),
        ElementHover     = Color3FromHex("#342200"),
        Accent           = Color3FromHex("#F59E0B"),
        AccentDark       = Color3FromHex("#D97706"),
        Text             = Color3FromHex("#FEF3C7"),
        TextSecondary    = Color3FromHex("#AA8833"),
        TextDisabled     = Color3FromHex("#665522"),
        Stroke           = Color3FromHex("#3A2800"),
        Toggle           = Color3FromHex("#261A00"),
        ToggleEnabled    = Color3FromHex("#F59E0B"),
        SliderFill       = Color3FromHex("#F59E0B"),
        SliderTrack      = Color3FromHex("#261A00"),
        Scrollbar        = Color3FromHex("#3A2800"),
    },
    ["Slate"] = {
        Background       = Color3FromHex("#0A0C10"),
        Topbar           = Color3FromHex("#111318"),
        Section          = Color3FromHex("#181A20"),
        Element          = Color3FromHex("#1E2028"),
        ElementHover     = Color3FromHex("#262830"),
        Accent           = Color3FromHex("#94A3B8"),
        AccentDark       = Color3FromHex("#64748B"),
        Text             = Color3FromHex("#E2E8F0"),
        TextSecondary    = Color3FromHex("#64748B"),
        TextDisabled     = Color3FromHex("#334155"),
        Stroke           = Color3FromHex("#2A2C34"),
        Toggle           = Color3FromHex("#1A1C24"),
        ToggleEnabled    = Color3FromHex("#94A3B8"),
        SliderFill       = Color3FromHex("#94A3B8"),
        SliderTrack      = Color3FromHex("#1A1C24"),
        Scrollbar        = Color3FromHex("#2A2C34"),
    },
    ["Copper"] = {
        Background       = Color3FromHex("#0E0804"),
        Topbar           = Color3FromHex("#160E08"),
        Section          = Color3FromHex("#1E140A"),
        Element          = Color3FromHex("#261A0E"),
        ElementHover     = Color3FromHex("#302014"),
        Accent           = Color3FromHex("#D97706"),
        AccentDark       = Color3FromHex("#B45309"),
        Text             = Color3FromHex("#FDE68A"),
        TextSecondary    = Color3FromHex("#926633"),
        TextDisabled     = Color3FromHex("#5A3D1A"),
        Stroke           = Color3FromHex("#3A2010"),
        Toggle           = Color3FromHex("#261408"),
        ToggleEnabled    = Color3FromHex("#D97706"),
        SliderFill       = Color3FromHex("#D97706"),
        SliderTrack      = Color3FromHex("#261408"),
        Scrollbar        = Color3FromHex("#3A2010"),
    },
    ["Ice"] = {
        Background       = Color3FromHex("#080E14"),
        Topbar           = Color3FromHex("#0E141C"),
        Section          = Color3FromHex("#121820"),
        Element          = Color3FromHex("#161E28"),
        ElementHover     = Color3FromHex("#1E2A36"),
        Accent           = Color3FromHex("#BAE6FD"),
        AccentDark       = Color3FromHex("#7DD3FC"),
        Text             = Color3FromHex("#F0F9FF"),
        TextSecondary    = Color3FromHex("#5588AA"),
        TextDisabled     = Color3FromHex("#2A4A60"),
        Stroke           = Color3FromHex("#1A2E40"),
        Toggle           = Color3FromHex("#101E2C"),
        ToggleEnabled    = Color3FromHex("#BAE6FD"),
        SliderFill       = Color3FromHex("#BAE6FD"),
        SliderTrack      = Color3FromHex("#101E2C"),
        Scrollbar        = Color3FromHex("#1A2E40"),
    },
    ["Obsidian"] = {
        Background       = Color3FromHex("#030303"),
        Topbar           = Color3FromHex("#080808"),
        Section          = Color3FromHex("#0D0D0D"),
        Element          = Color3FromHex("#121212"),
        ElementHover     = Color3FromHex("#1A1A1A"),
        Accent           = Color3FromHex("#A855F7"),
        AccentDark       = Color3FromHex("#7C3AED"),
        Text             = Color3FromHex("#EDE9FE"),
        TextSecondary    = Color3FromHex("#7755AA"),
        TextDisabled     = Color3FromHex("#443366"),
        Stroke           = Color3FromHex("#1E1E2A"),
        Toggle           = Color3FromHex("#0E0E18"),
        ToggleEnabled    = Color3FromHex("#A855F7"),
        SliderFill       = Color3FromHex("#A855F7"),
        SliderTrack      = Color3FromHex("#0E0E18"),
        Scrollbar        = Color3FromHex("#1E1E2A"),
    },
    ["Sunset"] = {
        Background       = Color3FromHex("#100808"),
        Topbar           = Color3FromHex("#180E0A"),
        Section          = Color3FromHex("#20120C"),
        Element          = Color3FromHex("#28160E"),
        ElementHover     = Color3FromHex("#341C14"),
        Accent           = Color3FromHex("#FB923C"),
        AccentDark       = Color3FromHex("#EA580C"),
        Text             = Color3FromHex("#FFEDD5"),
        TextSecondary    = Color3FromHex("#AA6644"),
        TextDisabled     = Color3FromHex("#663D26"),
        Stroke           = Color3FromHex("#3A1E10"),
        Toggle           = Color3FromHex("#261208"),
        ToggleEnabled    = Color3FromHex("#FB923C"),
        SliderFill       = Color3FromHex("#FB923C"),
        SliderTrack      = Color3FromHex("#261208"),
        Scrollbar        = Color3FromHex("#3A1E10"),
    },
    ["Cyber"] = {
        Background       = Color3FromHex("#020612"),
        Topbar           = Color3FromHex("#040A1A"),
        Section          = Color3FromHex("#060E22"),
        Element          = Color3FromHex("#08122A"),
        ElementHover     = Color3FromHex("#0E1A36"),
        Accent           = Color3FromHex("#00FFB3"),
        AccentDark       = Color3FromHex("#00CC8A"),
        Text             = Color3FromHex("#CCFFE8"),
        TextSecondary    = Color3FromHex("#33AA77"),
        TextDisabled     = Color3FromHex("#1A5A3A"),
        Stroke           = Color3FromHex("#0A1E2A"),
        Toggle           = Color3FromHex("#041220"),
        ToggleEnabled    = Color3FromHex("#00FFB3"),
        SliderFill       = Color3FromHex("#00FFB3"),
        SliderTrack      = Color3FromHex("#041220"),
        Scrollbar        = Color3FromHex("#0A1E2A"),
    },
}

-- ============================================================
-- LIBRARY CORE
-- ============================================================
local NexusLib = {}
NexusLib.__index = NexusLib
NexusLib._registry = {}  -- Save/Load registry
NexusLib._themeCallbacks = {}  -- Theme change callbacks

function NexusLib:_getCurrentTheme()
    return Themes[self._currentTheme] or Themes["Dark"]
end

function NexusLib:_applyTheme(themeName)
    if not Themes[themeName] then return end
    self._currentTheme = themeName
    local theme = Themes[themeName]
    for _, callback in ipairs(self._themeCallbacks) do
        pcall(callback, theme)
    end
end

function NexusLib:_registerThemeCallback(callback)
    table.insert(self._themeCallbacks, callback)
end

function NexusLib:_saveConfig()
    if not self._configPath then return end
    MakeFolder("NexusLib")
    local data = {}
    for id, info in pairs(self._registry) do
        if info.getValue then
            data[id] = info.getValue()
        end
    end
    SafeWriteFile(self._configPath, SafeJsonEncode(data))
end

function NexusLib:_loadConfig()
    if not self._configPath then return end
    local raw = SafeReadFile(self._configPath)
    if not raw then return end
    local data = SafeJsonDecode(raw)
    if not data then return end
    for id, value in pairs(data) do
        if self._registry[id] and self._registry[id].setValue then
            pcall(self._registry[id].setValue, value)
        end
    end
end

function NexusLib:_registerElement(id, getValue, setValue)
    self._registry[id] = {
        getValue = getValue,
        setValue = setValue,
    }
end

-- ============================================================
-- MAIN CreateWindow FUNCTION
-- ============================================================
function NexusLib:CreateWindow(config)
    config = config or {}

    local windowConfig = {
        Name              = config.Name or "NexusLib",
        SubTitle          = config.SubTitle or "v2.0.0",
        Theme             = config.Theme or "Dark",
        LoadingEnabled    = config.LoadingEnabled ~= false,
        LoadingName       = config.LoadingName or "Welcome Back!",
        LoadingIcon       = config.LoadingIcon or "",
        KeySystem         = config.KeySystem or false,
        KeyName           = config.KeyName or "Key System",
        Key               = config.Key or "nexus2024",
        GetKeyFromSite    = config.GetKeyFromSite or false,
        SiteKey           = config.SiteKey or "",
        KeySave           = config.KeySave ~= false,
        KeyJsonName       = config.KeyJsonName or "nexus_key",
        ConfigFolder      = config.ConfigFolder or "NexusLib",
        AutoSave          = config.AutoSave ~= false,
    }

    -- Initialize library state
    local lib = setmetatable({}, NexusLib)
    lib._currentTheme = windowConfig.Theme
    lib._themeCallbacks = {}
    lib._registry = {}
    lib._tabs = {}
    lib._activeTab = nil
    lib._minimized = false
    lib._configPath = windowConfig.ConfigFolder .. "/" .. "config.json"
    lib._keyPath = windowConfig.ConfigFolder .. "/" .. windowConfig.KeyJsonName .. ".json"

    -- Ensure folder
    MakeFolder(windowConfig.ConfigFolder)

    local theme = Themes[lib._currentTheme] or Themes["Dark"]

    -- ============================================================
    -- SCREEN GUI ROOT
    -- ============================================================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusLib_" .. windowConfig.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999

    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ============================================================
    -- LOADING SCREEN
    -- ============================================================
    local function ShowLoadingScreen(onComplete)
        if not windowConfig.LoadingEnabled then
            onComplete()
            return
        end

        local LoadFrame = Instance.new("Frame")
        LoadFrame.Name = "LoadingScreen"
        LoadFrame.Size = UDim2.new(1, 0, 1, 0)
        LoadFrame.BackgroundColor3 = theme.Background
        LoadFrame.BorderSizePixel = 0
        LoadFrame.ZIndex = 100
        LoadFrame.Parent = ScreenGui

        local LoadContainer = Instance.new("Frame")
        LoadContainer.Name = "Container"
        LoadContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        LoadContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        LoadContainer.Size = UDim2.new(0, 320, 0, 200)
        LoadContainer.BackgroundColor3 = theme.Section
        LoadContainer.BorderSizePixel = 0
        LoadContainer.ZIndex = 101
        LoadContainer.Parent = LoadFrame
        CreateCorner(LoadContainer, 16)
        CreateStroke(LoadContainer, theme.Stroke, 1)
        CreateShadow(LoadContainer)

        if windowConfig.LoadingIcon ~= "" then
            local IconLabel = Instance.new("ImageLabel")
            IconLabel.Name = "Icon"
            IconLabel.AnchorPoint = Vector2.new(0.5, 0)
            IconLabel.Position = UDim2.new(0.5, 0, 0, 24)
            IconLabel.Size = UDim2.new(0, 64, 0, 64)
            IconLabel.BackgroundTransparency = 1
            IconLabel.Image = "rbxassetid://" .. windowConfig.LoadingIcon
            IconLabel.ZIndex = 102
            IconLabel.Parent = LoadContainer

            -- Icon spin animation
            local spinConn
            local angle = 0
            spinConn = RunService.RenderStepped:Connect(function(dt)
                angle = angle + dt * 180
                IconLabel.Rotation = angle
            end)
            task.delay(2.5, function()
                if spinConn then spinConn:Disconnect() end
            end)
        end

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.AnchorPoint = Vector2.new(0.5, 0)
        TitleLabel.Position = UDim2.new(0.5, 0, 0, windowConfig.LoadingIcon ~= "" and 100 or 40)
        TitleLabel.Size = UDim2.new(1, -32, 0, 28)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextColor3 = theme.Text
        TitleLabel.TextSize = 18
        TitleLabel.Text = windowConfig.LoadingName
        TitleLabel.ZIndex = 102
        TitleLabel.Parent = LoadContainer

        local SubLabel = Instance.new("TextLabel")
        SubLabel.Name = "Sub"
        SubLabel.AnchorPoint = Vector2.new(0.5, 0)
        SubLabel.Position = UDim2.new(0.5, 0, 0, windowConfig.LoadingIcon ~= "" and 132 or 72)
        SubLabel.Size = UDim2.new(1, -32, 0, 20)
        SubLabel.BackgroundTransparency = 1
        SubLabel.Font = Enum.Font.Gotham
        SubLabel.TextColor3 = theme.TextSecondary
        SubLabel.TextSize = 13
        SubLabel.Text = "Loading " .. windowConfig.Name .. "..."
        SubLabel.ZIndex = 102
        SubLabel.Parent = LoadContainer

        -- Progress bar background
        local BarBG = Instance.new("Frame")
        BarBG.Name = "BarBG"
        BarBG.AnchorPoint = Vector2.new(0.5, 0)
        BarBG.Position = UDim2.new(0.5, 0, 0, windowConfig.LoadingIcon ~= "" and 165 or 110)
        BarBG.Size = UDim2.new(1, -48, 0, 6)
        BarBG.BackgroundColor3 = theme.SliderTrack
        BarBG.BorderSizePixel = 0
        BarBG.ZIndex = 102
        BarBG.Parent = LoadContainer
        CreateCorner(BarBG, 3)

        local BarFill = Instance.new("Frame")
        BarFill.Name = "BarFill"
        BarFill.Size = UDim2.new(0, 0, 1, 0)
        BarFill.BackgroundColor3 = theme.Accent
        BarFill.BorderSizePixel = 0
        BarFill.ZIndex = 103
        BarFill.Parent = BarBG
        CreateCorner(BarFill, 3)

        -- Loading steps
        local loadSteps = {
            {text = "Initializing systems...", progress = 0.2, delay = 0},
            {text = "Loading configurations...", progress = 0.5, delay = 0.4},
            {text = "Applying themes...", progress = 0.75, delay = 0.9},
            {text = "Almost ready!", progress = 1.0, delay = 1.4},
        }

        for _, step in ipairs(loadSteps) do
            task.delay(step.delay, function()
                if SubLabel and SubLabel.Parent then
                    SubLabel.Text = step.text
                end
                Tween(BarFill, {Size = UDim2.new(step.progress, 0, 1, 0)}, 0.35)
            end)
        end

        task.delay(2.2, function()
            Tween(LoadFrame, {BackgroundTransparency = 1}, 0.5)
            Tween(LoadContainer, {BackgroundTransparency = 1}, 0.5)
            task.wait(0.5)
            LoadFrame:Destroy()
            onComplete()
        end)
    end

    -- ============================================================
    -- KEY SYSTEM
    -- ============================================================
    local function ShowKeySystem(onValid, onClose)
        if not windowConfig.KeySystem then
            onValid()
            return
        end

        -- Check saved key
        if windowConfig.KeySave then
            local savedData = SafeReadFile(lib._keyPath)
            if savedData then
                local decoded = SafeJsonDecode(savedData)
                if decoded and decoded.key == windowConfig.Key then
                    onValid()
                    return
                end
            end
        end

        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeySystem"
        KeyFrame.Size = UDim2.new(1, 0, 1, 0)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        KeyFrame.BackgroundTransparency = 0.4
        KeyFrame.BorderSizePixel = 0
        KeyFrame.ZIndex = 200
        KeyFrame.Parent = ScreenGui

        local KeyContainer = Instance.new("Frame")
        KeyContainer.Name = "Container"
        KeyContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        KeyContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        KeyContainer.Size = UDim2.new(0, 360, 0, 260)
        KeyContainer.BackgroundColor3 = theme.Section
        KeyContainer.BorderSizePixel = 0
        KeyContainer.ZIndex = 201
        KeyContainer.Parent = KeyFrame
        CreateCorner(KeyContainer, 14)
        CreateStroke(KeyContainer, theme.Stroke, 1)
        CreateShadow(KeyContainer)

        KeyContainer.BackgroundTransparency = 1
        KeyContainer.Size = UDim2.new(0, 360, 0, 0)
        Tween(KeyContainer, {BackgroundTransparency = 0, Size = UDim2.new(0, 360, 0, 260)}, 0.4, Enum.EasingStyle.Back)

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Name = "Title"
        KeyTitle.AnchorPoint = Vector2.new(0.5, 0)
        KeyTitle.Position = UDim2.new(0.5, 0, 0, 20)
        KeyTitle.Size = UDim2.new(1, -32, 0, 28)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.TextColor3 = theme.Text
        KeyTitle.TextSize = 18
        KeyTitle.Text = windowConfig.KeyName
        KeyTitle.ZIndex = 202
        KeyTitle.Parent = KeyContainer

        local KeySub = Instance.new("TextLabel")
        KeySub.Name = "Sub"
        KeySub.AnchorPoint = Vector2.new(0.5, 0)
        KeySub.Position = UDim2.new(0.5, 0, 0, 52)
        KeySub.Size = UDim2.new(1, -32, 0, 18)
        KeySub.BackgroundTransparency = 1
        KeySub.Font = Enum.Font.Gotham
        KeySub.TextColor3 = theme.TextSecondary
        KeySub.TextSize = 13
        KeySub.Text = "Enter your access key to continue"
        KeySub.ZIndex = 202
        KeySub.Parent = KeyContainer

        local KeyInputBG = Instance.new("Frame")
        KeyInputBG.Name = "InputBG"
        KeyInputBG.AnchorPoint = Vector2.new(0.5, 0)
        KeyInputBG.Position = UDim2.new(0.5, 0, 0, 90)
        KeyInputBG.Size = UDim2.new(1, -48, 0, 44)
        KeyInputBG.BackgroundColor3 = theme.Element
        KeyInputBG.BorderSizePixel = 0
        KeyInputBG.ZIndex = 202
        KeyInputBG.Parent = KeyContainer
        CreateCorner(KeyInputBG, 8)
        CreateStroke(KeyInputBG, theme.Stroke, 1)

        local KeyInput = Instance.new("TextBox")
        KeyInput.Name = "Input"
        KeyInput.Size = UDim2.new(1, -16, 1, 0)
        KeyInput.Position = UDim2.new(0, 8, 0, 0)
        KeyInput.BackgroundTransparency = 1
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextColor3 = theme.Text
        KeyInput.PlaceholderColor3 = theme.TextDisabled
        KeyInput.TextSize = 14
        KeyInput.PlaceholderText = "Enter key here..."
        KeyInput.Text = ""
        KeyInput.ClearTextOnFocus = false
        KeyInput.ZIndex = 203
        KeyInput.Parent = KeyInputBG

        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Name = "Status"
        StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
        StatusLabel.Position = UDim2.new(0.5, 0, 0, 144)
        StatusLabel.Size = UDim2.new(1, -48, 0, 18)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.TextColor3 = theme.TextSecondary
        StatusLabel.TextSize = 12
        StatusLabel.Text = ""
        StatusLabel.ZIndex = 202
        StatusLabel.Parent = KeyContainer

        -- Get Key button
        if windowConfig.GetKeyFromSite and windowConfig.SiteKey ~= "" then
            local GetKeyBtn = Instance.new("TextButton")
            GetKeyBtn.Name = "GetKey"
            GetKeyBtn.AnchorPoint = Vector2.new(0.5, 0)
            GetKeyBtn.Position = UDim2.new(0.5, 0, 0, 168)
            GetKeyBtn.Size = UDim2.new(1, -48, 0, 36)
            GetKeyBtn.BackgroundColor3 = theme.Element
            GetKeyBtn.BorderSizePixel = 0
            GetKeyBtn.Font = Enum.Font.GothamBold
            GetKeyBtn.TextColor3 = theme.TextSecondary
            GetKeyBtn.TextSize = 13
            GetKeyBtn.Text = "📋  Copy Key Link"
            GetKeyBtn.ZIndex = 202
            GetKeyBtn.Parent = KeyContainer
            CreateCorner(GetKeyBtn, 8)
            CreateStroke(GetKeyBtn, theme.Stroke, 1)

            GetKeyBtn.MouseButton1Click:Connect(function()
                setclipboard(windowConfig.SiteKey)
                GetKeyBtn.Text = "✓  Link Copied!"
                Tween(GetKeyBtn, {TextColor3 = theme.Accent}, 0.2)
                task.delay(2, function()
                    GetKeyBtn.Text = "📋  Copy Key Link"
                    Tween(GetKeyBtn, {TextColor3 = theme.TextSecondary}, 0.2)
                end)
            end)
        end

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Name = "Submit"
        SubmitBtn.AnchorPoint = Vector2.new(0.5, 0)
        SubmitBtn.Position = UDim2.new(0.5, 0, 0, windowConfig.GetKeyFromSite and 212 or 175)
        SubmitBtn.Size = UDim2.new(1, -48, 0, 40)
        SubmitBtn.BackgroundColor3 = theme.Accent
        SubmitBtn.BorderSizePixel = 0
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitBtn.TextSize = 14
        SubmitBtn.Text = "Submit Key"
        SubmitBtn.ZIndex = 202
        SubmitBtn.Parent = KeyContainer
        CreateCorner(SubmitBtn, 8)

        local function TrySubmit()
            local input = KeyInput.Text
            if input == windowConfig.Key then
                StatusLabel.Text = "✓ Key accepted!"
                StatusLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
                Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.2)

                if windowConfig.KeySave then
                    MakeFolder(windowConfig.ConfigFolder)
                    SafeWriteFile(lib._keyPath, SafeJsonEncode({key = input}))
                end

                task.delay(0.8, function()
                    Tween(KeyContainer, {BackgroundTransparency = 1, Size = UDim2.new(0, 360, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    task.wait(0.4)
                    KeyFrame:Destroy()
                    onValid()
                end)
            else
                StatusLabel.Text = "✗ Invalid key. Please try again."
                StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
                Tween(KeyInputBG, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
                task.delay(0.5, function()
                    Tween(KeyInputBG, {BackgroundColor3 = theme.Element}, 0.15)
                end)
            end
        end

        SubmitBtn.MouseButton1Click:Connect(TrySubmit)
        KeyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then TrySubmit() end
        end)

        SubmitBtn.MouseEnter:Connect(function()
            Tween(SubmitBtn, {BackgroundColor3 = theme.AccentDark}, 0.15)
        end)
        SubmitBtn.MouseLeave:Connect(function()
            Tween(SubmitBtn, {BackgroundColor3 = theme.Accent}, 0.15)
        end)
    end

    -- ============================================================
    -- MAIN WINDOW UI
    -- ============================================================
    local function BuildMainUI()
        -- Window container
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.Size = UDim2.new(0, 514, 0, 343)
        MainFrame.BackgroundColor3 = theme.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.ClipsDescendants = false
        MainFrame.ZIndex = 10
        MainFrame.Parent = ScreenGui
        CreateCorner(MainFrame, 12)
        CreateStroke(MainFrame, theme.Stroke, 1)
        CreateShadow(MainFrame)

        -- Animate in
        MainFrame.BackgroundTransparency = 1
        MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
        Tween(MainFrame, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Back)

        -- ============================================================
        -- TOPBAR
        -- ============================================================
        local Topbar = Instance.new("Frame")
        Topbar.Name = "Topbar"
        Topbar.Size = UDim2.new(1, 0, 0, 34)
        Topbar.BackgroundColor3 = theme.Topbar
        Topbar.BorderSizePixel = 0
        Topbar.ZIndex = 12
        Topbar.Parent = MainFrame
        CreateCorner(Topbar, 12)

        -- Fix topbar bottom corners
        local TopbarFix = Instance.new("Frame")
        TopbarFix.Name = "Fix"
        TopbarFix.Size = UDim2.new(1, 0, 0.5, 0)
        TopbarFix.Position = UDim2.new(0, 0, 0.5, 0)
        TopbarFix.BackgroundColor3 = theme.Topbar
        TopbarFix.BorderSizePixel = 0
        TopbarFix.ZIndex = 12
        TopbarFix.Parent = Topbar

        -- Window Title
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Position = UDim2.new(0, 16, 0, 0)
        TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextColor3 = theme.Text
        TitleLabel.TextSize = 15
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Text = windowConfig.Name
        TitleLabel.ZIndex = 13
        TitleLabel.Parent = Topbar

        local SubTitleLabel = Instance.new("TextLabel")
        SubTitleLabel.Name = "SubTitle"
        SubTitleLabel.Position = UDim2.new(0, 16, 0, 0)
        SubTitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
        SubTitleLabel.BackgroundTransparency = 1
        SubTitleLabel.Font = Enum.Font.Gotham
        SubTitleLabel.TextColor3 = theme.TextSecondary
        SubTitleLabel.TextSize = 11
        SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        SubTitleLabel.Text = "    " .. string.rep(" ", #windowConfig.Name + 2) .. windowConfig.SubTitle
        SubTitleLabel.ZIndex = 13
        SubTitleLabel.Parent = Topbar

        -- Topbar Buttons
        local ButtonsFrame = Instance.new("Frame")
        ButtonsFrame.Name = "Buttons"
        ButtonsFrame.AnchorPoint = Vector2.new(1, 0.5)
        ButtonsFrame.Position = UDim2.new(1, -12, 0.5, 0)
        ButtonsFrame.Size = UDim2.new(0, 77, 0, 20)
        ButtonsFrame.BackgroundTransparency = 1
        ButtonsFrame.ZIndex = 13
        ButtonsFrame.Parent = Topbar

        local ButtonsLayout = Instance.new("UIListLayout")
        ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
        ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ButtonsLayout.Padding = UDim.new(0, 6)
        ButtonsLayout.Parent = ButtonsFrame

        local function MakeTopbarBtn(text, color)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 20, 0, 20)
            Btn.BackgroundColor3 = theme.Element
            Btn.BorderSizePixel = 0
            Btn.Font = Enum.Font.GothamBold
            Btn.TextColor3 = color or theme.TextSecondary
            Btn.TextSize = 14
            Btn.Text = text
            Btn.ZIndex = 14
            Btn.Parent = ButtonsFrame
            CreateCorner(Btn, 6)

            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = theme.ElementHover}, 0.15)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = theme.Element}, 0.15)
            end)

            return Btn
        end

        local ResizeBtn   = MakeTopbarBtn("⤡", theme.TextSecondary)
        local MinimizeBtn = MakeTopbarBtn("—", theme.TextSecondary)
        local CloseBtn    = MakeTopbarBtn("✕", Color3.fromRGB(239, 68, 68))

        -- ============================================================
        -- CLOSE MODAL
        -- ============================================================
        CloseBtn.MouseButton1Click:Connect(function()
            local ModalBG = Instance.new("Frame")
            ModalBG.Name = "ModalBG"
            ModalBG.Size = UDim2.new(1, 0, 1, 0)
            ModalBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            ModalBG.BackgroundTransparency = 1
            ModalBG.ZIndex = 50
            ModalBG.Parent = ScreenGui
            Tween(ModalBG, {BackgroundTransparency = 0.5}, 0.2)

            local Modal = Instance.new("Frame")
            Modal.Name = "Modal"
            Modal.AnchorPoint = Vector2.new(0.5, 0.5)
            Modal.Position = UDim2.new(0.5, 0, 0.5, 0)
            Modal.Size = UDim2.new(0, 214, 0, 0)
            Modal.BackgroundColor3 = theme.Section
            Modal.BorderSizePixel = 0
            Modal.ZIndex = 51
            Modal.Parent = ScreenGui
            CreateCorner(Modal, 12)
            CreateStroke(Modal, theme.Stroke, 1)
            CreateShadow(Modal)
            Tween(Modal, {Size = UDim2.new(0, 214, 0, 114)}, 0.35, Enum.EasingStyle.Back)

            local ModalTitle = Instance.new("TextLabel")
            ModalTitle.Name = "Title"
            ModalTitle.AnchorPoint = Vector2.new(0.5, 0)
            ModalTitle.Position = UDim2.new(0.5, 0, 0, 20)
            ModalTitle.Size = UDim2.new(1, -32, 0, 24)
            ModalTitle.BackgroundTransparency = 1
            ModalTitle.Font = Enum.Font.GothamBold
            ModalTitle.TextColor3 = theme.Text
            ModalTitle.TextSize = 16
            ModalTitle.Text = "Close " .. windowConfig.Name .. "?"
            ModalTitle.ZIndex = 52
            ModalTitle.Parent = Modal

            local ModalSub = Instance.new("TextLabel")
            ModalSub.Name = "Sub"
            ModalSub.AnchorPoint = Vector2.new(0.5, 0)
            ModalSub.Position = UDim2.new(0.5, 0, 0, 48)
            ModalSub.Size = UDim2.new(1, -32, 0, 18)
            ModalSub.BackgroundTransparency = 1
            ModalSub.Font = Enum.Font.Gotham
            ModalSub.TextColor3 = theme.TextSecondary
            ModalSub.TextSize = 13
            ModalSub.Text = "Are you sure you want to close?"
            ModalSub.ZIndex = 52
            ModalSub.Parent = Modal

            local ModalBtnsFrame = Instance.new("Frame")
            ModalBtnsFrame.Name = "Buttons"
            ModalBtnsFrame.AnchorPoint = Vector2.new(0.5, 0)
            ModalBtnsFrame.Position = UDim2.new(0.5, 0, 0, 88)
            ModalBtnsFrame.Size = UDim2.new(1, -48, 0, 40)
            ModalBtnsFrame.BackgroundTransparency = 1
            ModalBtnsFrame.ZIndex = 52
            ModalBtnsFrame.Parent = Modal

            local MBtnLayout = Instance.new("UIListLayout")
            MBtnLayout.FillDirection = Enum.FillDirection.Horizontal
            MBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            MBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            MBtnLayout.Padding = UDim.new(0, 12)
            MBtnLayout.Parent = ModalBtnsFrame

            local CancelBtn = Instance.new("TextButton")
            CancelBtn.Size = UDim2.new(0, 79, 0, 27)
            CancelBtn.BackgroundColor3 = theme.Element
            CancelBtn.BorderSizePixel = 0
            CancelBtn.Font = Enum.Font.GothamBold
            CancelBtn.TextColor3 = theme.TextSecondary
            CancelBtn.TextSize = 13
            CancelBtn.Text = "Cancel"
            CancelBtn.ZIndex = 53
            CancelBtn.Parent = ModalBtnsFrame
            CreateCorner(CancelBtn, 8)

            local YesBtn = Instance.new("TextButton")
            YesBtn.Size = UDim2.new(0, 79, 0, 27)
            YesBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
            YesBtn.BorderSizePixel = 0
            YesBtn.Font = Enum.Font.GothamBold
            YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            YesBtn.TextSize = 13
            YesBtn.Text = "Yes, Close"
            YesBtn.ZIndex = 53
            YesBtn.Parent = ModalBtnsFrame
            CreateCorner(YesBtn, 8)

            CancelBtn.MouseEnter:Connect(function()
                Tween(CancelBtn, {BackgroundColor3 = theme.ElementHover}, 0.15)
            end)
            CancelBtn.MouseLeave:Connect(function()
                Tween(CancelBtn, {BackgroundColor3 = theme.Element}, 0.15)
            end)
            YesBtn.MouseEnter:Connect(function()
                Tween(YesBtn, {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}, 0.15)
            end)
            YesBtn.MouseLeave:Connect(function()
                Tween(YesBtn, {BackgroundColor3 = Color3.fromRGB(239, 68, 68)}, 0.15)
            end)

            CancelBtn.MouseButton1Click:Connect(function()
                Tween(Modal, {Size = UDim2.new(0, 214, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                Tween(ModalBG, {BackgroundTransparency = 1}, 0.3)
                task.delay(0.3, function()
                    Modal:Destroy()
                    ModalBG:Destroy()
                end)
            end)

            YesBtn.MouseButton1Click:Connect(function()
                Tween(MainFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 514, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                Modal:Destroy()
                ModalBG:Destroy()
                task.delay(0.4, function()
                    ScreenGui:Destroy()
                end)
            end)
        end)

        -- ============================================================
        -- MINIMIZE
        -- ============================================================
        local _contentSize = MainFrame.Size

        MinimizeBtn.MouseButton1Click:Connect(function()
            lib._minimized = not lib._minimized
            if lib._minimized then
                _contentSize = MainFrame.Size
                Tween(MainFrame, {Size = UDim2.new(0, 514, 0, 34)}, 0.4, Enum.EasingStyle.Back)
                MinimizeBtn.Text = "▲"
            else
                Tween(MainFrame, {Size = _contentSize}, 0.4, Enum.EasingStyle.Back)
                MinimizeBtn.Text = "—"
            end
        end)

        -- ============================================================
        -- RESIZE
        -- ============================================================
        local resizing = false
        local resizeStart = nil
        local resizeFrameStart = nil
        local MIN_W, MAX_W = 357, 714
        local MIN_H, MAX_H = 250, 500

        ResizeBtn.MouseButton1Down:Connect(function()
            resizing = true
            resizeStart = UserInputService:GetMouseLocation()
            resizeFrameStart = MainFrame.Size
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if resizing then
                local mouse = UserInputService:GetMouseLocation()
                local dx = mouse.X - resizeStart.X
                local dy = mouse.Y - resizeStart.Y
                local newW = math.clamp(resizeFrameStart.X.Offset + dx, MIN_W, MAX_W)
                local newH = math.clamp(resizeFrameStart.Y.Offset + dy, MIN_H, MAX_H)
                MainFrame.Size = UDim2.new(0, newW, 0, newH)
            end
        end)

        -- ============================================================
        -- DRAG
        -- ============================================================
        local dragging = false
        local dragStart, startPos

        Topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        -- ============================================================
        -- CONTENT AREA
        -- ============================================================
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "Content"
        ContentFrame.Position = UDim2.new(0, 0, 0, 34)
        ContentFrame.Size = UDim2.new(1, 0, 1, -34)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.ZIndex = 11
        ContentFrame.ClipsDescendants = true
        ContentFrame.Parent = MainFrame

        -- Sidebar for tabs
        local Sidebar = Instance.new("Frame")
        Sidebar.Name = "Sidebar"
        Sidebar.Size = UDim2.new(0, 100, 1, 0)
        Sidebar.BackgroundColor3 = theme.Topbar
        Sidebar.BorderSizePixel = 0
        Sidebar.ZIndex = 12
        Sidebar.Parent = ContentFrame

        -- Fix sidebar top corner
        local SidebarFix = Instance.new("Frame")
        SidebarFix.Size = UDim2.new(1, 0, 0, 12)
        SidebarFix.BackgroundColor3 = theme.Topbar
        SidebarFix.BorderSizePixel = 0
        SidebarFix.ZIndex = 12
        SidebarFix.Parent = Sidebar

        local TabList = Instance.new("ScrollingFrame")
        TabList.Name = "TabList"
        TabList.Position = UDim2.new(0, 0, 0, 8)
        TabList.Size = UDim2.new(1, 0, 1, -8)
        TabList.BackgroundTransparency = 1
        TabList.ScrollBarThickness = 3
        TabList.ScrollBarImageColor3 = theme.Scrollbar
        TabList.BorderSizePixel = 0
        TabList.ZIndex = 13
        TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabList.Parent = Sidebar

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Padding = UDim.new(0, 4)
        TabListLayout.Parent = TabList

        local TabListPadding = Instance.new("UIPadding")
        TabListPadding.PaddingLeft = UDim.new(0, 10)
        TabListPadding.PaddingRight = UDim.new(0, 10)
        TabListPadding.PaddingTop = UDim.new(0, 4)
        TabListPadding.Parent = TabList

        TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
        end)

        -- Main tab content area
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent"
        TabContent.Position = UDim2.new(0, 100, 0, 0)
        TabContent.Size = UDim2.new(1, -100, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = theme.Scrollbar
        TabContent.BorderSizePixel = 0
        TabContent.ZIndex = 11
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentFrame

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 0)
        TabContentLayout.Parent = TabContent

        -- Register theme callbacks for main elements
        lib:_registerThemeCallback(function(t)
            theme = t
            Tween(MainFrame, {BackgroundColor3 = t.Background}, 0.3)
            Tween(Topbar, {BackgroundColor3 = t.Topbar}, 0.3)
            Tween(TopbarFix, {BackgroundColor3 = t.Topbar}, 0.3)
            Tween(TitleLabel, {TextColor3 = t.Text}, 0.3)
            Tween(SubTitleLabel, {TextColor3 = t.TextSecondary}, 0.3)
            Tween(Sidebar, {BackgroundColor3 = t.Topbar}, 0.3)
            Tween(SidebarFix, {BackgroundColor3 = t.Topbar}, 0.3)
            TabList.ScrollBarImageColor3 = t.Scrollbar
            TabContent.ScrollBarImageColor3 = t.Scrollbar
        end)

        -- ============================================================
        -- WINDOW OBJECT (returned)
        -- ============================================================
        local Window = {}
        Window._lib = lib
        Window._tabContent = TabContent
        Window._tabContentLayout = TabContentLayout
        Window._tabList = TabList
        Window._tabs = {}
        Window._activeTab = nil

        -- ============================================================
        -- AddTab
        -- ============================================================
        function Window:AddTab(config)
            config = config or {}
            local tabConfig = {
                Name = config.Name or "Tab",
                Icon = config.Icon or "",
            }

            local TabPage = Instance.new("Frame")
            TabPage.Name = "TabPage_" .. tabConfig.Name
            TabPage.Size = UDim2.new(1, 0, 1, 0)
            TabPage.BackgroundTransparency = 1
            TabPage.ZIndex = 11
            TabPage.Visible = false
            TabPage.Parent = TabContent

            local TabPageLayout = Instance.new("UIListLayout")
            TabPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            TabPageLayout.Padding = UDim.new(0, 12)
            TabPageLayout.Parent = TabPage

            local TabPagePadding = Instance.new("UIPadding")
            TabPagePadding.PaddingLeft = UDim.new(0, 12)
            TabPagePadding.PaddingRight = UDim.new(0, 12)
            TabPagePadding.PaddingTop = UDim.new(0, 12)
            TabPagePadding.PaddingBottom = UDim.new(0, 12)
            TabPagePadding.Parent = TabPage

            TabPageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabPageLayout.AbsoluteContentSize.Y + 24)
            end)

            -- Sidebar Tab Button
            local TabBtn = Instance.new("TextButton")
            TabBtn.Name = "TabBtn_" .. tabConfig.Name
            TabBtn.Size = UDim2.new(1, 0, 0, 27)
            TabBtn.BackgroundColor3 = theme.Background
            TabBtn.BackgroundTransparency = 1
            TabBtn.BorderSizePixel = 0
            TabBtn.Font = Enum.Font.GothamMedium
            TabBtn.TextColor3 = theme.TextSecondary
            TabBtn.TextSize = 13
            TabBtn.Text = (tabConfig.Icon ~= "" and tabConfig.Icon .. "  " or "") .. tabConfig.Name
            TabBtn.TextXAlignment = Enum.TextXAlignment.Left
            TabBtn.ZIndex = 14
            TabBtn.Parent = TabList
            CreateCorner(TabBtn, 8)

            local TabBtnIndicator = Instance.new("Frame")
            TabBtnIndicator.Name = "Indicator"
            TabBtnIndicator.Position = UDim2.new(0, 0, 0.5, -7)
            TabBtnIndicator.Size = UDim2.new(0, 3, 0, 14)
            TabBtnIndicator.BackgroundColor3 = theme.Accent
            TabBtnIndicator.BackgroundTransparency = 1
            TabBtnIndicator.BorderSizePixel = 0
            TabBtnIndicator.ZIndex = 15
            TabBtnIndicator.Parent = TabBtn
            CreateCorner(TabBtnIndicator, 2)

            local BtnPad = Instance.new("UIPadding")
            BtnPad.PaddingLeft = UDim.new(0, 10)
            BtnPad.Parent = TabBtn

            local function SelectTab()
                -- Deselect all
                for _, t in ipairs(Window._tabs) do
                    Tween(t.button, {BackgroundTransparency = 1, TextColor3 = theme.TextSecondary}, 0.2)
                    Tween(t.indicator, {BackgroundTransparency = 1}, 0.2)
                    t.page.Visible = false
                end
                -- Select this
                Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.Element, TextColor3 = theme.Text}, 0.2)
                Tween(TabBtnIndicator, {BackgroundTransparency = 0}, 0.2)
                TabPage.Visible = true
                Window._activeTab = tabConfig.Name
                TabContent.CanvasPosition = Vector2.new(0, 0)
            end

            TabBtn.MouseButton1Click:Connect(SelectTab)

            TabBtn.MouseEnter:Connect(function()
                if Window._activeTab ~= tabConfig.Name then
                    Tween(TabBtn, {BackgroundTransparency = 0.5, BackgroundColor3 = theme.Element}, 0.15)
                end
            end)
            TabBtn.MouseLeave:Connect(function()
                if Window._activeTab ~= tabConfig.Name then
                    Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
                end
            end)

            local tabEntry = {
                name = tabConfig.Name,
                page = TabPage,
                button = TabBtn,
                indicator = TabBtnIndicator,
                layout = TabPageLayout,
            }
            table.insert(Window._tabs, tabEntry)

            -- Auto select first tab
            if #Window._tabs == 1 then
                SelectTab()
            end

            -- Theme callbacks
            lib:_registerThemeCallback(function(t)
                if Window._activeTab == tabConfig.Name then
                    Tween(TabBtn, {BackgroundColor3 = t.Element, TextColor3 = t.Text}, 0.3)
                    Tween(TabBtnIndicator, {BackgroundColor3 = t.Accent}, 0.3)
                else
                    Tween(TabBtn, {TextColor3 = t.TextSecondary}, 0.3)
                end
            end)

            -- ============================================================
            -- TAB OBJECT
            -- ============================================================
            local Tab = {}

            -- ============================================================
            -- AddSection
            -- ============================================================
            function Tab:AddSection(config)
                config = config or {}
                local sectionConfig = {
                    Name = config.Name or "Section",
                }

                local SectionFrame = Instance.new("Frame")
                SectionFrame.Name = "Section_" .. sectionConfig.Name
                SectionFrame.Size = UDim2.new(1, 0, 0, 0)
                SectionFrame.BackgroundColor3 = theme.Section
                SectionFrame.BorderSizePixel = 0
                SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                SectionFrame.ZIndex = 12
                SectionFrame.Parent = TabPage
                CreateCorner(SectionFrame, 10)
                CreateStroke(SectionFrame, theme.Stroke, 1)

                local SectionTitle = Instance.new("TextLabel")
                SectionTitle.Name = "Title"
                SectionTitle.Position = UDim2.new(0, 10, 0, 7)
                SectionTitle.Size = UDim2.new(1, -28, 0, 13)
                SectionTitle.BackgroundTransparency = 1
                SectionTitle.Font = Enum.Font.GothamBold
                SectionTitle.TextColor3 = theme.Accent
                SectionTitle.TextSize = 12
                SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
                SectionTitle.Text = sectionConfig.Name:upper()
                SectionTitle.ZIndex = 13
                SectionTitle.Parent = SectionFrame

                local SectionDivider = Instance.new("Frame")
                SectionDivider.Name = "Divider"
                SectionDivider.Position = UDim2.new(0, 10, 0, 23)
                SectionDivider.Size = UDim2.new(1, -28, 0, 1)
                SectionDivider.BackgroundColor3 = theme.Stroke
                SectionDivider.BorderSizePixel = 0
                SectionDivider.ZIndex = 13
                SectionDivider.Parent = SectionFrame

                local SectionContent = Instance.new("Frame")
                SectionContent.Name = "Content"
                SectionContent.Position = UDim2.new(0, 0, 0, 26)
                SectionContent.Size = UDim2.new(1, 0, 0, 0)
                SectionContent.BackgroundTransparency = 1
                SectionContent.AutomaticSize = Enum.AutomaticSize.Y
                SectionContent.ZIndex = 13
                SectionContent.Parent = SectionFrame

                local SectionLayout = Instance.new("UIListLayout")
                SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                SectionLayout.Padding = UDim.new(0, 0)
                SectionLayout.Parent = SectionContent

                local SectionPadding = Instance.new("UIPadding")
                SectionPadding.PaddingBottom = UDim.new(0, 8)
                SectionPadding.Parent = SectionContent

                lib:_registerThemeCallback(function(t)
                    Tween(SectionFrame, {BackgroundColor3 = t.Section}, 0.3)
                    Tween(SectionTitle, {TextColor3 = t.Accent}, 0.3)
                    Tween(SectionDivider, {BackgroundColor3 = t.Stroke}, 0.3)
                end)

                -- ============================================================
                -- SECTION OBJECT
                -- ============================================================
                local Section = {}

                -- Helper: create element row frame
                local function MakeElementFrame(height)
                    local f = Instance.new("Frame")
                    f.Size = UDim2.new(1, 0, 0, height or 31)
                    f.BackgroundColor3 = theme.Section
                    f.BorderSizePixel = 0
                    f.ZIndex = 14
                    f.Parent = SectionContent

                    lib:_registerThemeCallback(function(t)
                        Tween(f, {BackgroundColor3 = t.Section}, 0.3)
                    end)
                    return f
                end

                -- ============================================================
                -- AddLabel
                -- ============================================================
                function Section:AddLabel(config)
                    config = config or {}
                    local labelConfig = {
                        Text = config.Text or "Label",
                    }

                    local LabelFrame = MakeElementFrame(27)

                    local Label = Instance.new("TextLabel")
                    Label.Name = "Label"
                    Label.Position = UDim2.new(0, 14, 0, 0)
                    Label.Size = UDim2.new(1, -28, 1, 0)
                    Label.BackgroundTransparency = 1
                    Label.Font = Enum.Font.Gotham
                    Label.TextColor3 = theme.TextSecondary
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.Text = labelConfig.Text
                    Label.ZIndex = 15
                    Label.Parent = LabelFrame

                    lib:_registerThemeCallback(function(t)
                        Tween(Label, {TextColor3 = t.TextSecondary}, 0.3)
                    end)

                    local LabelObj = {}

                    function LabelObj:SetText(text)
                        Label.Text = text
                    end

                    return LabelObj
                end

                -- ============================================================
                -- AddButton
                -- ============================================================
                function Section:AddButton(config)
                    config = config or {}
                    local btnConfig = {
                        Name        = config.Name or "Button",
                        Description = config.Description or "",
                        Callback    = config.Callback or function() end,
                    }

                    local BtnFrame = MakeElementFrame(btnConfig.Description ~= "" and 41 or 31)

                    local Btn = Instance.new("TextButton")
                    Btn.Name = "Button"
                    Btn.Position = UDim2.new(0, 10, 0, 5)
                    Btn.Size = UDim2.new(1, -28, 0, btnConfig.Description ~= "" and 31 or 21)
                    Btn.BackgroundColor3 = theme.Element
                    Btn.BorderSizePixel = 0
                    Btn.Font = Enum.Font.GothamBold
                    Btn.TextColor3 = theme.Text
                    Btn.TextSize = 13
                    Btn.Text = btnConfig.Name
                    Btn.ZIndex = 15
                    Btn.Parent = BtnFrame
                    CreateCorner(Btn, 8)
                    CreateStroke(Btn, theme.Stroke, 1)

                    if btnConfig.Description ~= "" then
                        local DescLabel = Instance.new("TextLabel")
                        DescLabel.Name = "Desc"
                        DescLabel.Position = UDim2.new(0, 0, 0, 30)
                        DescLabel.Size = UDim2.new(1, 0, 0, 14)
                        DescLabel.BackgroundTransparency = 1
                        DescLabel.Font = Enum.Font.Gotham
                        DescLabel.TextColor3 = theme.TextSecondary
                        DescLabel.TextSize = 11
                        DescLabel.Text = btnConfig.Description
                        DescLabel.ZIndex = 16
                        DescLabel.Parent = Btn

                        lib:_registerThemeCallback(function(t)
                            Tween(DescLabel, {TextColor3 = t.TextSecondary}, 0.3)
                        end)
                    end

                    Btn.MouseEnter:Connect(function()
                        Tween(Btn, {BackgroundColor3 = theme.ElementHover}, 0.15)
                    end)
                    Btn.MouseLeave:Connect(function()
                        Tween(Btn, {BackgroundColor3 = theme.Element}, 0.15)
                    end)
                    Btn.MouseButton1Down:Connect(function()
                        Tween(Btn, {BackgroundColor3 = theme.Stroke}, 0.1)
                    end)
                    Btn.MouseButton1Up:Connect(function()
                        Tween(Btn, {BackgroundColor3 = theme.ElementHover}, 0.1)
                    end)
                    Btn.MouseButton1Click:Connect(function()
                        -- Ripple effect
                        local Ripple = Instance.new("Frame")
                        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                        Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                        Ripple.Size = UDim2.new(0, 0, 0, 0)
                        Ripple.BackgroundColor3 = theme.Accent
                        Ripple.BackgroundTransparency = 0.7
                        Ripple.BorderSizePixel = 0
                        Ripple.ZIndex = 16
                        Ripple.Parent = Btn
                        CreateCorner(Ripple, 4)
                        Tween(Ripple, {Size = UDim2.new(1.5, 0, 3, 0), BackgroundTransparency = 1}, 0.4)
                        task.delay(0.4, function() Ripple:Destroy() end)

                        pcall(btnConfig.Callback)
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(Btn, {BackgroundColor3 = t.Element, TextColor3 = t.Text}, 0.3)
                    end)

                    local BtnObj = {}
                    function BtnObj:SetText(text) Btn.Text = text end
                    function BtnObj:SetCallback(fn) btnConfig.Callback = fn end
                    return BtnObj
                end

                -- ============================================================
                -- AddToggle
                -- ============================================================
                function Section:AddToggle(config)
                    config = config or {}
                    local togConfig = {
                        Name        = config.Name or "Toggle",
                        Description = config.Description or "",
                        Default     = config.Default or false,
                        Callback    = config.Callback or function() end,
                        Id          = config.Id or config.Name,
                    }

                    local TogFrame = MakeElementFrame(togConfig.Description ~= "" and 40 or 31)

                    local TogLabel = Instance.new("TextLabel")
                    TogLabel.Name = "Label"
                    TogLabel.Position = UDim2.new(0, 14, 0, 0)
                    TogLabel.Size = UDim2.new(1, -70, togConfig.Description ~= "" and 0.5 or 1, 0)
                    TogLabel.BackgroundTransparency = 1
                    TogLabel.Font = Enum.Font.GothamMedium
                    TogLabel.TextColor3 = theme.Text
                    TogLabel.TextSize = 13
                    TogLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TogLabel.Text = togConfig.Name
                    TogLabel.ZIndex = 15
                    TogLabel.Parent = TogFrame

                    if togConfig.Description ~= "" then
                        local DescLabel = Instance.new("TextLabel")
                        DescLabel.Name = "Desc"
                        DescLabel.Position = UDim2.new(0, 14, 0.5, 0)
                        DescLabel.Size = UDim2.new(1, -70, 0.5, 0)
                        DescLabel.BackgroundTransparency = 1
                        DescLabel.Font = Enum.Font.Gotham
                        DescLabel.TextColor3 = theme.TextSecondary
                        DescLabel.TextSize = 11
                        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                        DescLabel.Text = togConfig.Description
                        DescLabel.ZIndex = 15
                        DescLabel.Parent = TogFrame
                        lib:_registerThemeCallback(function(t)
                            Tween(DescLabel, {TextColor3 = t.TextSecondary}, 0.3)
                        end)
                    end

                    -- Toggle switch
                    local TogBG = Instance.new("Frame")
                    TogBG.Name = "TogBG"
                    TogBG.AnchorPoint = Vector2.new(1, 0.5)
                    TogBG.Position = UDim2.new(1, -14, 0.5, 0)
                    TogBG.Size = UDim2.new(0, 31, 0, 17)
                    TogBG.BackgroundColor3 = theme.Toggle
                    TogBG.BorderSizePixel = 0
                    TogBG.ZIndex = 15
                    TogBG.Parent = TogFrame
                    CreateCorner(TogBG, 9)

                    local TogCircle = Instance.new("Frame")
                    TogCircle.Name = "Circle"
                    TogCircle.Position = UDim2.new(0, 2, 0.5, -6)
                    TogCircle.Size = UDim2.new(0, 13, 0, 13)
                    TogCircle.BackgroundColor3 = theme.Text
                    TogCircle.BorderSizePixel = 0
                    TogCircle.ZIndex = 16
                    TogCircle.Parent = TogBG
                    CreateCorner(TogCircle, 6)

                    local _value = togConfig.Default

                    local function SetToggle(val, skipCallback)
                        _value = val
                        if val then
                            Tween(TogBG, {BackgroundColor3 = theme.ToggleEnabled}, 0.25)
                            Tween(TogCircle, {Position = UDim2.new(0, 16, 0.5, -6)}, 0.25, Enum.EasingStyle.Back)
                        else
                            Tween(TogBG, {BackgroundColor3 = theme.Toggle}, 0.25)
                            Tween(TogCircle, {Position = UDim2.new(0, 2, 0.5, -6)}, 0.25, Enum.EasingStyle.Back)
                        end
                        if not skipCallback then
                            pcall(togConfig.Callback, val)
                            if windowConfig.AutoSave then
                                task.delay(0.5, function() lib:_saveConfig() end)
                            end
                        end
                    end

                    SetToggle(_value, true)

                    TogBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            SetToggle(not _value)
                        end
                    end)
                    TogFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            SetToggle(not _value)
                        end
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(TogLabel, {TextColor3 = t.Text}, 0.3)
                        if _value then
                            Tween(TogBG, {BackgroundColor3 = t.ToggleEnabled}, 0.3)
                        else
                            Tween(TogBG, {BackgroundColor3 = t.Toggle}, 0.3)
                        end
                        Tween(TogCircle, {BackgroundColor3 = t.Text}, 0.3)
                    end)

                    lib:_registerElement(togConfig.Id,
                        function() return _value end,
                        function(v) SetToggle(v == true, true) end
                    )

                    local TogObj = {}
                    function TogObj:SetValue(val) SetToggle(val) end
                    function TogObj:GetValue() return _value end
                    function TogObj:SetCallback(fn) togConfig.Callback = fn end
                    return TogObj
                end

                -- ============================================================
                -- AddSlider
                -- ============================================================
                function Section:AddSlider(config)
                    config = config or {}
                    local sliderConfig = {
                        Name        = config.Name or "Slider",
                        Description = config.Description or "",
                        Min         = config.Min or 0,
                        Max         = config.Max or 100,
                        Default     = config.Default or 50,
                        Increment   = config.Increment or 1,
                        Suffix      = config.Suffix or "",
                        Callback    = config.Callback or function() end,
                        Id          = config.Id or config.Name,
                    }

                    local SliderFrame = MakeElementFrame(sliderConfig.Description ~= "" and 50 or 41)

                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.Name = "Label"
                    SliderLabel.Position = UDim2.new(0, 14, 0, 8)
                    SliderLabel.Size = UDim2.new(1, -100, 0, 18)
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.Font = Enum.Font.GothamMedium
                    SliderLabel.TextColor3 = theme.Text
                    SliderLabel.TextSize = 13
                    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SliderLabel.Text = sliderConfig.Name
                    SliderLabel.ZIndex = 15
                    SliderLabel.Parent = SliderFrame

                    local ValueLabel = Instance.new("TextLabel")
                    ValueLabel.Name = "Value"
                    ValueLabel.AnchorPoint = Vector2.new(1, 0)
                    ValueLabel.Position = UDim2.new(1, -14, 0, 8)
                    ValueLabel.Size = UDim2.new(0, 80, 0, 18)
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.Font = Enum.Font.GothamBold
                    ValueLabel.TextColor3 = theme.Accent
                    ValueLabel.TextSize = 13
                    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                    ValueLabel.ZIndex = 15
                    ValueLabel.Parent = SliderFrame

                    if sliderConfig.Description ~= "" then
                        local DescLabel = Instance.new("TextLabel")
                        DescLabel.Name = "Desc"
                        DescLabel.Position = UDim2.new(0, 14, 0, 26)
                        DescLabel.Size = UDim2.new(1, -28, 0, 14)
                        DescLabel.BackgroundTransparency = 1
                        DescLabel.Font = Enum.Font.Gotham
                        DescLabel.TextColor3 = theme.TextSecondary
                        DescLabel.TextSize = 11
                        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                        DescLabel.Text = sliderConfig.Description
                        DescLabel.ZIndex = 15
                        DescLabel.Parent = SliderFrame
                        lib:_registerThemeCallback(function(t)
                            Tween(DescLabel, {TextColor3 = t.TextSecondary}, 0.3)
                        end)
                    end

                    local trackY = sliderConfig.Description ~= "" and 48 or 36

                    local TrackBG = Instance.new("Frame")
                    TrackBG.Name = "TrackBG"
                    TrackBG.Position = UDim2.new(0, 14, 0, trackY)
                    TrackBG.Size = UDim2.new(1, -28, 0, 6)
                    TrackBG.BackgroundColor3 = theme.SliderTrack
                    TrackBG.BorderSizePixel = 0
                    TrackBG.ZIndex = 15
                    TrackBG.Parent = SliderFrame
                    CreateCorner(TrackBG, 3)

                    local TrackFill = Instance.new("Frame")
                    TrackFill.Name = "Fill"
                    TrackFill.Size = UDim2.new(0, 0, 1, 0)
                    TrackFill.BackgroundColor3 = theme.SliderFill
                    TrackFill.BorderSizePixel = 0
                    TrackFill.ZIndex = 16
                    TrackFill.Parent = TrackBG
                    CreateCorner(TrackFill, 3)

                    local Knob = Instance.new("Frame")
                    Knob.Name = "Knob"
                    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
                    Knob.Position = UDim2.new(0, 0, 0.5, 0)
                    Knob.Size = UDim2.new(0, 11, 0, 11)
                    Knob.BackgroundColor3 = theme.Accent
                    Knob.BorderSizePixel = 0
                    Knob.ZIndex = 17
                    Knob.Parent = TrackBG
                    CreateCorner(Knob, 6)

                    local _value = sliderConfig.Default
                    local draggingSlider = false

                    local function UpdateSlider(val, skipCallback)
                        val = math.clamp(val, sliderConfig.Min, sliderConfig.Max)
                        local inc = sliderConfig.Increment
                        val = math.round(val / inc) * inc
                        _value = val

                        local alpha = (val - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                        Tween(TrackFill, {Size = UDim2.new(alpha, 0, 1, 0)}, 0.1)
                        Tween(Knob, {Position = UDim2.new(alpha, 0, 0.5, 0)}, 0.1)

                        ValueLabel.Text = tostring(val) .. sliderConfig.Suffix

                        if not skipCallback then
                            pcall(sliderConfig.Callback, val)
                            if windowConfig.AutoSave then
                                task.delay(0.5, function() lib:_saveConfig() end)
                            end
                        end
                    end

                    UpdateSlider(_value, true)

                    local function GetSliderValue(inputX)
                        local trackAbsPos = TrackBG.AbsolutePosition.X
                        local trackAbsSize = TrackBG.AbsoluteSize.X
                        local alpha = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
                        return sliderConfig.Min + alpha * (sliderConfig.Max - sliderConfig.Min)
                    end

                    TrackBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSlider = true
                            UpdateSlider(GetSliderValue(input.Position.X))
                        end
                    end)
                    Knob.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSlider = true
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(GetSliderValue(input.Position.X))
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSlider = false
                        end
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(SliderLabel, {TextColor3 = t.Text}, 0.3)
                        Tween(ValueLabel, {TextColor3 = t.Accent}, 0.3)
                        Tween(TrackBG, {BackgroundColor3 = t.SliderTrack}, 0.3)
                        Tween(TrackFill, {BackgroundColor3 = t.SliderFill}, 0.3)
                        Tween(Knob, {BackgroundColor3 = t.Accent}, 0.3)
                    end)

                    lib:_registerElement(sliderConfig.Id,
                        function() return _value end,
                        function(v)
                            local n = tonumber(v)
                            if n then UpdateSlider(n, true) end
                        end
                    )

                    local SliderObj = {}
                    function SliderObj:SetValue(val) UpdateSlider(val) end
                    function SliderObj:GetValue() return _value end
                    function SliderObj:SetCallback(fn) sliderConfig.Callback = fn end
                    return SliderObj
                end

                -- ============================================================
                -- AddDropdown
                -- ============================================================
                function Section:AddDropdown(config)
                    config = config or {}
                    local ddConfig = {
                        Name        = config.Name or "Dropdown",
                        Description = config.Description or "",
                        Options     = config.Options or {},
                        Default     = config.Default or (config.Options and config.Options[1] or ""),
                        Callback    = config.Callback or function() end,
                        Id          = config.Id or config.Name,
                    }

                    local DDFrame = MakeElementFrame(44)

                    local DDLabel = Instance.new("TextLabel")
                    DDLabel.Name = "Label"
                    DDLabel.Position = UDim2.new(0, 14, 0, 0)
                    DDLabel.Size = UDim2.new(0.5, 0, 1, 0)
                    DDLabel.BackgroundTransparency = 1
                    DDLabel.Font = Enum.Font.GothamMedium
                    DDLabel.TextColor3 = theme.Text
                    DDLabel.TextSize = 13
                    DDLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DDLabel.Text = ddConfig.Name
                    DDLabel.ZIndex = 15
                    DDLabel.Parent = DDFrame

                    local DDBtn = Instance.new("TextButton")
                    DDBtn.Name = "Button"
                    DDBtn.AnchorPoint = Vector2.new(1, 0.5)
                    DDBtn.Position = UDim2.new(1, -14, 0.5, 0)
                    DDBtn.Size = UDim2.new(0, 160, 0, 30)
                    DDBtn.BackgroundColor3 = theme.Element
                    DDBtn.BorderSizePixel = 0
                    DDBtn.Font = Enum.Font.Gotham
                    DDBtn.TextColor3 = theme.Text
                    DDBtn.TextSize = 12
                    DDBtn.Text = (ddConfig.Default or "Select...") .. "  ▾"
                    DDBtn.ZIndex = 15
                    DDBtn.Parent = DDFrame
                    CreateCorner(DDBtn, 8)
                    CreateStroke(DDBtn, theme.Stroke, 1)

                    local _value = ddConfig.Default
                    local _open = false
                    local _dropdownFrame = nil

                    local function SetValue(val, skipCallback)
                        _value = val
                        DDBtn.Text = val .. "  ▾"
                        if not skipCallback then
                            pcall(ddConfig.Callback, val)
                            if windowConfig.AutoSave then
                                task.delay(0.5, function() lib:_saveConfig() end)
                            end
                        end
                    end

                    SetValue(_value, true)

                    local function CloseDropdown()
                        if _dropdownFrame then
                            Tween(_dropdownFrame, {Size = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1}, 0.2)
                            task.delay(0.2, function()
                                if _dropdownFrame then
                                    _dropdownFrame:Destroy()
                                    _dropdownFrame = nil
                                end
                            end)
                        end
                        _open = false
                        DDBtn.Text = _value .. "  ▾"
                    end

                    DDBtn.MouseButton1Click:Connect(function()
                        if _open then
                            CloseDropdown()
                            return
                        end
                        _open = true
                        DDBtn.Text = _value .. "  ▲"

                        local optionHeight = 32
                        local totalH = #ddConfig.Options * optionHeight

                        _dropdownFrame = Instance.new("Frame")
                        _dropdownFrame.Name = "Dropdown"
                        _dropdownFrame.Position = UDim2.new(0, 14, 1, 4)
                        _dropdownFrame.Size = UDim2.new(1, -28, 0, 0)
                        _dropdownFrame.BackgroundColor3 = theme.Element
                        _dropdownFrame.BorderSizePixel = 0
                        _dropdownFrame.ZIndex = 30
                        _dropdownFrame.ClipsDescendants = true
                        _dropdownFrame.Parent = DDFrame
                        CreateCorner(_dropdownFrame, 8)
                        CreateStroke(_dropdownFrame, theme.Stroke, 1)
                        CreateShadow(_dropdownFrame)

                        local DDScroll = Instance.new("ScrollingFrame")
                        DDScroll.Size = UDim2.new(1, 0, 1, 0)
                        DDScroll.BackgroundTransparency = 1
                        DDScroll.ScrollBarThickness = 3
                        DDScroll.ScrollBarImageColor3 = theme.Scrollbar
                        DDScroll.BorderSizePixel = 0
                        DDScroll.ZIndex = 31
                        DDScroll.CanvasSize = UDim2.new(0, 0, 0, totalH)
                        DDScroll.Parent = _dropdownFrame

                        local DDLayout = Instance.new("UIListLayout")
                        DDLayout.SortOrder = Enum.SortOrder.LayoutOrder
                        DDLayout.Parent = DDScroll

                        for _, opt in ipairs(ddConfig.Options) do
                            local OptBtn = Instance.new("TextButton")
                            OptBtn.Size = UDim2.new(1, 0, 0, optionHeight)
                            OptBtn.BackgroundTransparency = 1
                            OptBtn.Font = opt == _value and Enum.Font.GothamBold or Enum.Font.Gotham
                            OptBtn.TextColor3 = opt == _value and theme.Accent or theme.Text
                            OptBtn.TextSize = 13
                            OptBtn.Text = opt
                            OptBtn.ZIndex = 32
                            OptBtn.Parent = DDScroll

                            OptBtn.MouseEnter:Connect(function()
                                Tween(OptBtn, {BackgroundTransparency = 0.7, BackgroundColor3 = theme.ElementHover}, 0.1)
                            end)
                            OptBtn.MouseLeave:Connect(function()
                                Tween(OptBtn, {BackgroundTransparency = 1}, 0.1)
                            end)
                            OptBtn.MouseButton1Click:Connect(function()
                                SetValue(opt)
                                CloseDropdown()
                            end)
                        end

                        local clampedH = math.min(totalH, 114)
                        Tween(_dropdownFrame, {Size = UDim2.new(1, -28, 0, clampedH)}, 0.25, Enum.EasingStyle.Back)

                        DDFrame.Size = UDim2.new(1, 0, 0, 31 + clampedH + 6)
                    end)

                    DDBtn.MouseEnter:Connect(function()
                        Tween(DDBtn, {BackgroundColor3 = theme.ElementHover}, 0.15)
                    end)
                    DDBtn.MouseLeave:Connect(function()
                        Tween(DDBtn, {BackgroundColor3 = theme.Element}, 0.15)
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(DDLabel, {TextColor3 = t.Text}, 0.3)
                        Tween(DDBtn, {BackgroundColor3 = t.Element, TextColor3 = t.Text}, 0.3)
                    end)

                    lib:_registerElement(ddConfig.Id,
                        function() return _value end,
                        function(v)
                            for _, opt in ipairs(ddConfig.Options) do
                                if opt == v then
                                    SetValue(v, true)
                                    break
                                end
                            end
                        end
                    )

                    local DDObj = {}
                    function DDObj:SetValue(val) SetValue(val) end
                    function DDObj:GetValue() return _value end
                    function DDObj:SetOptions(opts)
                        ddConfig.Options = opts
                        DDBtn.Text = _value .. "  ▾"
                    end
                    function DDObj:SetCallback(fn) ddConfig.Callback = fn end
                    return DDObj
                end

                -- ============================================================
                -- AddTextbox
                -- ============================================================
                function Section:AddTextbox(config)
                    config = config or {}
                    local tbConfig = {
                        Name        = config.Name or "Textbox",
                        Description = config.Description or "",
                        Default     = config.Default or "",
                        Placeholder = config.Placeholder or "Enter text...",
                        Callback    = config.Callback or function() end,
                        Id          = config.Id or config.Name,
                        NumberOnly  = config.NumberOnly or false,
                    }

                    local TBFrame = MakeElementFrame(58)

                    local TBLabel = Instance.new("TextLabel")
                    TBLabel.Name = "Label"
                    TBLabel.Position = UDim2.new(0, 14, 0, 6)
                    TBLabel.Size = UDim2.new(1, -28, 0, 18)
                    TBLabel.BackgroundTransparency = 1
                    TBLabel.Font = Enum.Font.GothamMedium
                    TBLabel.TextColor3 = theme.Text
                    TBLabel.TextSize = 13
                    TBLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TBLabel.Text = tbConfig.Name
                    TBLabel.ZIndex = 15
                    TBLabel.Parent = TBFrame

                    local TBInputBG = Instance.new("Frame")
                    TBInputBG.Name = "InputBG"
                    TBInputBG.Position = UDim2.new(0, 10, 0, 20)
                    TBInputBG.Size = UDim2.new(1, -28, 0, 17)
                    TBInputBG.BackgroundColor3 = theme.Element
                    TBInputBG.BorderSizePixel = 0
                    TBInputBG.ZIndex = 15
                    TBInputBG.Parent = TBFrame
                    CreateCorner(TBInputBG, 6)
                    CreateStroke(TBInputBG, theme.Stroke, 1)

                    local TBInput = Instance.new("TextBox")
                    TBInput.Name = "Input"
                    TBInput.Size = UDim2.new(1, -12, 1, 0)
                    TBInput.Position = UDim2.new(0, 6, 0, 0)
                    TBInput.BackgroundTransparency = 1
                    TBInput.Font = Enum.Font.Gotham
                    TBInput.TextColor3 = theme.Text
                    TBInput.PlaceholderColor3 = theme.TextDisabled
                    TBInput.TextSize = 12
                    TBInput.PlaceholderText = tbConfig.Placeholder
                    TBInput.Text = tbConfig.Default
                    TBInput.ClearTextOnFocus = false
                    TBInput.ZIndex = 16
                    TBInput.Parent = TBInputBG

                    local _value = tbConfig.Default

                    TBInput.Focused:Connect(function()
                        Tween(TBInputBG, {BackgroundColor3 = theme.ElementHover}, 0.2)
                    end)
                    TBInput.FocusLost:Connect(function(enterPressed)
                        Tween(TBInputBG, {BackgroundColor3 = theme.Element}, 0.2)
                        local text = TBInput.Text
                        if tbConfig.NumberOnly then
                            local n = tonumber(text)
                            if not n then
                                TBInput.Text = _value
                                return
                            end
                            text = tostring(n)
                        end
                        _value = text
                        pcall(tbConfig.Callback, text)
                        if windowConfig.AutoSave then
                            task.delay(0.5, function() lib:_saveConfig() end)
                        end
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(TBLabel, {TextColor3 = t.Text}, 0.3)
                        Tween(TBInputBG, {BackgroundColor3 = t.Element}, 0.3)
                        Tween(TBInput, {TextColor3 = t.Text, PlaceholderColor3 = t.TextDisabled}, 0.3)
                    end)

                    lib:_registerElement(tbConfig.Id,
                        function() return _value end,
                        function(v)
                            _value = tostring(v)
                            TBInput.Text = _value
                        end
                    )

                    local TBObj = {}
                    function TBObj:SetValue(val)
                        _value = tostring(val)
                        TBInput.Text = _value
                    end
                    function TBObj:GetValue() return _value end
                    function TBObj:SetCallback(fn) tbConfig.Callback = fn end
                    return TBObj
                end

                -- ============================================================
                -- AddKeybind
                -- ============================================================
                function Section:AddKeybind(config)
                    config = config or {}
                    local kbConfig = {
                        Name     = config.Name or "Keybind",
                        Default  = config.Default or Enum.KeyCode.RightShift,
                        Callback = config.Callback or function() end,
                        Id       = config.Id or config.Name,
                    }

                    local KBFrame = MakeElementFrame(44)

                    local KBLabel = Instance.new("TextLabel")
                    KBLabel.Name = "Label"
                    KBLabel.Position = UDim2.new(0, 14, 0, 0)
                    KBLabel.Size = UDim2.new(0.6, 0, 1, 0)
                    KBLabel.BackgroundTransparency = 1
                    KBLabel.Font = Enum.Font.GothamMedium
                    KBLabel.TextColor3 = theme.Text
                    KBLabel.TextSize = 13
                    KBLabel.TextXAlignment = Enum.TextXAlignment.Left
                    KBLabel.Text = kbConfig.Name
                    KBLabel.ZIndex = 15
                    KBLabel.Parent = KBFrame

                    local KBBtn = Instance.new("TextButton")
                    KBBtn.Name = "KeyBtn"
                    KBBtn.AnchorPoint = Vector2.new(1, 0.5)
                    KBBtn.Position = UDim2.new(1, -14, 0.5, 0)
                    KBBtn.Size = UDim2.new(0, 57, 0, 20)
                    KBBtn.BackgroundColor3 = theme.Element
                    KBBtn.BorderSizePixel = 0
                    KBBtn.Font = Enum.Font.GothamBold
                    KBBtn.TextColor3 = theme.Accent
                    KBBtn.TextSize = 12
                    KBBtn.ZIndex = 15
                    KBBtn.Parent = KBFrame
                    CreateCorner(KBBtn, 6)
                    CreateStroke(KBBtn, theme.Stroke, 1)

                    local _value = kbConfig.Default
                    local _listening = false

                    local function FormatKey(key)
                        local name = key.Name
                        -- Shorten common names
                        local shorts = {
                            LeftControl = "LCtrl", RightControl = "RCtrl",
                            LeftShift = "LShift", RightShift = "RShift",
                            LeftAlt = "LAlt", RightAlt = "RAlt",
                            Return = "Enter", BackSpace = "Bksp",
                        }
                        return shorts[name] or name
                    end

                    KBBtn.Text = "[" .. FormatKey(_value) .. "]"

                    KBBtn.MouseButton1Click:Connect(function()
                        if _listening then return end
                        _listening = true
                        KBBtn.Text = "..."
                        Tween(KBBtn, {BackgroundColor3 = theme.ElementHover}, 0.15)

                        local conn
                        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                _value = input.KeyCode
                                KBBtn.Text = "[" .. FormatKey(_value) .. "]"
                                _listening = false
                                Tween(KBBtn, {BackgroundColor3 = theme.Element}, 0.15)
                                conn:Disconnect()
                                if windowConfig.AutoSave then
                                    task.delay(0.5, function() lib:_saveConfig() end)
                                end
                            end
                        end)
                    end)

                    UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if not gameProcessed and input.KeyCode == _value and not _listening then
                            pcall(kbConfig.Callback, _value)
                        end
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(KBLabel, {TextColor3 = t.Text}, 0.3)
                        Tween(KBBtn, {BackgroundColor3 = t.Element, TextColor3 = t.Accent}, 0.3)
                    end)

                    lib:_registerElement(kbConfig.Id,
                        function() return _value.Name end,
                        function(v)
                            local ok, key = pcall(function() return Enum.KeyCode[v] end)
                            if ok and key then
                                _value = key
                                KBBtn.Text = "[" .. FormatKey(_value) .. "]"
                            end
                        end
                    )

                    local KBObj = {}
                    function KBObj:GetValue() return _value end
                    function KBObj:SetValue(key)
                        _value = key
                        KBBtn.Text = "[" .. FormatKey(_value) .. "]"
                    end
                    function KBObj:SetCallback(fn) kbConfig.Callback = fn end
                    return KBObj
                end

                -- ============================================================
                -- AddColorPicker
                -- ============================================================
                function Section:AddColorPicker(config)
                    config = config or {}
                    local cpConfig = {
                        Name     = config.Name or "Color Picker",
                        Default  = config.Default or Color3.fromRGB(255, 100, 100),
                        Callback = config.Callback or function() end,
                        Id       = config.Id or config.Name,
                    }

                    local CPFrame = MakeElementFrame(44)
                    local _open = false
                    local _pickerFrame = nil

                    local CPLabel = Instance.new("TextLabel")
                    CPLabel.Name = "Label"
                    CPLabel.Position = UDim2.new(0, 14, 0, 0)
                    CPLabel.Size = UDim2.new(0.6, 0, 1, 0)
                    CPLabel.BackgroundTransparency = 1
                    CPLabel.Font = Enum.Font.GothamMedium
                    CPLabel.TextColor3 = theme.Text
                    CPLabel.TextSize = 13
                    CPLabel.TextXAlignment = Enum.TextXAlignment.Left
                    CPLabel.Text = cpConfig.Name
                    CPLabel.ZIndex = 15
                    CPLabel.Parent = CPFrame

                    local CPPreview = Instance.new("TextButton")
                    CPPreview.Name = "Preview"
                    CPPreview.AnchorPoint = Vector2.new(1, 0.5)
                    CPPreview.Position = UDim2.new(1, -14, 0.5, 0)
                    CPPreview.Size = UDim2.new(0, 31, 0, 20)
                    CPPreview.BackgroundColor3 = cpConfig.Default
                    CPPreview.BorderSizePixel = 0
                    CPPreview.Text = ""
                    CPPreview.ZIndex = 15
                    CPPreview.Parent = CPFrame
                    CreateCorner(CPPreview, 6)
                    CreateStroke(CPPreview, theme.Stroke, 1)

                    local _color = cpConfig.Default
                    local _h, _s, _v = RGBToHSV(_color)

                    local function CloseColorPicker()
                        if _pickerFrame then
                            Tween(_pickerFrame, {Size = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1}, 0.2)
                            task.delay(0.2, function()
                                if _pickerFrame then
                                    _pickerFrame:Destroy()
                                    _pickerFrame = nil
                                end
                            end)
                        end
                        _open = false
                        CPFrame.Size = UDim2.new(1, 0, 0, 44)
                    end

                    local function UpdateColor(h, s, v, skipCallback)
                        _h, _s, _v = h, s, v
                        _color = HSVToColor3(h, s, v)
                        CPPreview.BackgroundColor3 = _color
                        if not skipCallback then
                            pcall(cpConfig.Callback, _color)
                            if windowConfig.AutoSave then
                                task.delay(0.5, function() lib:_saveConfig() end)
                            end
                        end
                    end

                    CPPreview.MouseButton1Click:Connect(function()
                        if _open then
                            CloseColorPicker()
                            return
                        end
                        _open = true

                        local pickerH = 129

                        _pickerFrame = Instance.new("Frame")
                        _pickerFrame.Name = "ColorPicker"
                        _pickerFrame.Position = UDim2.new(0, 14, 1, 4)
                        _pickerFrame.Size = UDim2.new(1, -28, 0, 0)
                        _pickerFrame.BackgroundColor3 = theme.Element
                        _pickerFrame.BorderSizePixel = 0
                        _pickerFrame.ClipsDescendants = true
                        _pickerFrame.ZIndex = 30
                        _pickerFrame.Parent = CPFrame
                        CreateCorner(_pickerFrame, 8)
                        CreateStroke(_pickerFrame, theme.Stroke, 1)

                        -- SV picker square
                        local SVPicker = Instance.new("ImageLabel")
                        SVPicker.Name = "SVPicker"
                        SVPicker.Position = UDim2.new(0, 8, 0, 8)
                        SVPicker.Size = UDim2.new(1, -72, 0, 120)
                        SVPicker.BackgroundColor3 = HSVToColor3(_h, 1, 1)
                        SVPicker.BorderSizePixel = 0
                        SVPicker.ZIndex = 31
                        SVPicker.Image = "rbxassetid://4155801252" -- white to transparent gradient
                        SVPicker.Parent = _pickerFrame
                        CreateCorner(SVPicker, 4)

                        local SVOverlay = Instance.new("ImageLabel")
                        SVOverlay.Size = UDim2.new(1, 0, 1, 0)
                        SVOverlay.BackgroundTransparency = 1
                        SVOverlay.BorderSizePixel = 0
                        SVOverlay.ZIndex = 32
                        SVOverlay.Image = "rbxassetid://4155801252"
                        SVOverlay.ImageColor3 = Color3.fromRGB(0, 0, 0)
                        SVOverlay.Rotation = 90
                        SVOverlay.Parent = SVPicker

                        local SVKnob = Instance.new("Frame")
                        SVKnob.Name = "Knob"
                        SVKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                        SVKnob.Position = UDim2.new(_s, 0, 1 - _v, 0)
                        SVKnob.Size = UDim2.new(0, 10, 0, 10)
                        SVKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        SVKnob.BorderSizePixel = 0
                        SVKnob.ZIndex = 33
                        SVKnob.Parent = SVPicker
                        CreateCorner(SVKnob, 5)
                        CreateStroke(SVKnob, Color3.fromRGB(0, 0, 0), 1)

                        -- Hue slider (vertical)
                        local HuePicker = Instance.new("ImageLabel")
                        HuePicker.Name = "HuePicker"
                        HuePicker.AnchorPoint = Vector2.new(1, 0)
                        HuePicker.Position = UDim2.new(1, -8, 0, 8)
                        HuePicker.Size = UDim2.new(0, 20, 0, 120)
                        HuePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        HuePicker.BorderSizePixel = 0
                        HuePicker.ZIndex = 31
                        HuePicker.Image = "rbxassetid://4155820455" -- hue gradient
                        HuePicker.Parent = _pickerFrame
                        CreateCorner(HuePicker, 4)

                        local HueKnob = Instance.new("Frame")
                        HueKnob.Name = "Knob"
                        HueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                        HueKnob.Position = UDim2.new(0.5, 0, _h, 0)
                        HueKnob.Size = UDim2.new(1, 4, 0, 4)
                        HueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        HueKnob.BorderSizePixel = 0
                        HueKnob.ZIndex = 32
                        HueKnob.Parent = HuePicker
                        CreateCorner(HueKnob, 2)
                        CreateStroke(HueKnob, Color3.fromRGB(0, 0, 0), 1)

                        -- Color hex display
                        local HexLabel = Instance.new("TextLabel")
                        HexLabel.Position = UDim2.new(0, 8, 0, 136)
                        HexLabel.Size = UDim2.new(1, -16, 0, 20)
                        HexLabel.BackgroundTransparency = 1
                        HexLabel.Font = Enum.Font.GothamBold
                        HexLabel.TextColor3 = theme.TextSecondary
                        HexLabel.TextSize = 11
                        HexLabel.TextXAlignment = Enum.TextXAlignment.Left
                        HexLabel.ZIndex = 31
                        HexLabel.Parent = _pickerFrame

                        local function UpdateHexLabel()
                            local r = math.floor(_color.R * 255)
                            local g = math.floor(_color.G * 255)
                            local b = math.floor(_color.B * 255)
                            HexLabel.Text = string.format("RGB: %d, %d, %d", r, g, b)
                        end
                        UpdateHexLabel()

                        -- SV interaction
                        local dragSV = false
                        SVPicker.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragSV = true
                            end
                        end)
                        UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragSV = false
                            end
                        end)

                        local function UpdateSVFromMouse(inputX, inputY)
                            local absPos = SVPicker.AbsolutePosition
                            local absSize = SVPicker.AbsoluteSize
                            local s = math.clamp((inputX - absPos.X) / absSize.X, 0, 1)
                            local v = 1 - math.clamp((inputY - absPos.Y) / absSize.Y, 0, 1)
                            SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                            SVPicker.BackgroundColor3 = HSVToColor3(_h, 1, 1)
                            UpdateColor(_h, s, v)
                            UpdateHexLabel()
                        end

                        SVPicker.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                UpdateSVFromMouse(input.Position.X, input.Position.Y)
                            end
                        end)

                        -- Hue interaction
                        local dragHue = false
                        HuePicker.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragHue = true
                            end
                        end)
                        UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragHue = false
                            end
                        end)

                        local function UpdateHueFromMouse(inputY)
                            local absPos = HuePicker.AbsolutePosition
                            local absSize = HuePicker.AbsoluteSize
                            local h = math.clamp((inputY - absPos.Y) / absSize.Y, 0, 1)
                            HueKnob.Position = UDim2.new(0.5, 0, h, 0)
                            SVPicker.BackgroundColor3 = HSVToColor3(h, 1, 1)
                            UpdateColor(h, _s, _v)
                            UpdateHexLabel()
                        end

                        HuePicker.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                UpdateHueFromMouse(input.Position.Y)
                            end
                        end)

                        UserInputService.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                if dragSV then
                                    UpdateSVFromMouse(input.Position.X, input.Position.Y)
                                end
                                if dragHue then
                                    UpdateHueFromMouse(input.Position.Y)
                                end
                            end
                        end)

                        Tween(_pickerFrame, {Size = UDim2.new(1, -28, 0, pickerH)}, 0.25, Enum.EasingStyle.Back)
                        CPFrame.Size = UDim2.new(1, 0, 0, 31 + pickerH + 6)
                    end)

                    lib:_registerThemeCallback(function(t)
                        Tween(CPLabel, {TextColor3 = t.Text}, 0.3)
                    end)

                    lib:_registerElement(cpConfig.Id,
                        function()
                            return {
                                R = math.floor(_color.R * 255),
                                G = math.floor(_color.G * 255),
                                B = math.floor(_color.B * 255),
                            }
                        end,
                        function(v)
                            if type(v) == "table" and v.R and v.G and v.B then
                                local col = Color3.fromRGB(v.R, v.G, v.B)
                                local h, s, vv = RGBToHSV(col)
                                UpdateColor(h, s, vv, true)
                            end
                        end
                    )

                    local CPObj = {}
                    function CPObj:SetValue(color)
                        local h, s, v = RGBToHSV(color)
                        UpdateColor(h, s, v)
                    end
                    function CPObj:GetValue() return _color end
                    function CPObj:SetCallback(fn) cpConfig.Callback = fn end
                    return CPObj
                end

                return Section
            end

            return Tab
        end

        -- ============================================================
        -- AddConfig (Theme Selector Tab)
        -- ============================================================
        function Window:AddConfig()
            local ConfigTab = self:AddTab({Name = "⚙ Config", Icon = ""})
            local ConfigSection = ConfigTab:AddSection({Name = "Interface Themes"})

            local themeNames = {}
            for name, _ in pairs(Themes) do
                table.insert(themeNames, name)
            end
            table.sort(themeNames)

            local ThemeDropdown = ConfigSection:AddDropdown({
                Name = "Active Theme",
                Options = themeNames,
                Default = lib._currentTheme,
                Callback = function(val)
                    lib:_applyTheme(val)
                end,
            })

            local SaveSection = ConfigTab:AddSection({Name = "Save & Load"})

            SaveSection:AddButton({
                Name = "Save Configuration",
                Description = "Manually save all current settings",
                Callback = function()
                    lib:_saveConfig()
                end,
            })

            SaveSection:AddButton({
                Name = "Load Configuration",
                Description = "Reload settings from file",
                Callback = function()
                    lib:_loadConfig()
                end,
            })

            SaveSection:AddButton({
                Name = "Reset Configuration",
                Description = "Delete saved config file",
                Callback = function()
                    pcall(delfile, lib._configPath)
                end,
            })

            return ConfigTab
        end

        -- Load config after build
        if windowConfig.AutoSave then
            task.delay(0.5, function()
                lib:_loadConfig()
            end)
        end

        -- Auto-save loop
        if windowConfig.AutoSave then
            task.spawn(function()
                while task.wait(30) do
                    lib:_saveConfig()
                end
            end)
        end

        return Window
    end

    -- ============================================================
    -- BOOT SEQUENCE: Loading → Key → Main UI
    -- ============================================================
    local function Boot()
        ShowLoadingScreen(function()
            ShowKeySystem(function()
                BuildMainUI()
            end, function()
                ScreenGui:Destroy()
            end)
        end)
    end

    Boot()

    -- Return a proxy until window builds (needed for immediate calls)
    local proxy = setmetatable({}, {
        __index = function(t, k)
            -- Wait for window to be built
            if rawget(t, "_built") then
                return rawget(t, "_built")[k]
            end
            return function() warn("NexusLib: Window not ready yet, call deferred") end
        end
    })

    -- Rebuild the window and attach
    local _realWindow = nil
    local _originalBuild = BuildMainUI

    -- Patch BuildMainUI to capture return
    local _pendingCalls = {}

    -- We need to re-route. Let's use a simpler approach:
    -- Return a WindowProxy that captures the real window when ready.
    local WindowProxy = {}
    WindowProxy._ready = false
    WindowProxy._realWindow = nil
    WindowProxy._pending = {}

    local function PatchedBuild()
        local w = _originalBuild()
        WindowProxy._ready = true
        WindowProxy._realWindow = w
        for _, fn in ipairs(WindowProxy._pending) do
            pcall(fn, w)
        end
        WindowProxy._pending = {}
    end

    -- Replace BuildMainUI in boot
    BuildMainUI = PatchedBuild

    -- Boot again with patched version
    -- Actually, let's simplify: just rebuild and expose properly.
    -- The cleanest approach: RunBoot returns the window directly via callback chain.

    -- Re-architect: single clean boot
    ScreenGui:Destroy()

    -- Fresh start
    local FreshGui = Instance.new("ScreenGui")
    FreshGui.Name = "NexusLib_" .. windowConfig.Name
    FreshGui.ResetOnSpawn = false
    FreshGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FreshGui.IgnoreGuiInset = true
    FreshGui.DisplayOrder = 999

    pcall(function() FreshGui.Parent = CoreGui end)
    if not FreshGui.Parent then
        FreshGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local FinalWindow = nil
    local _windowReady = false
    local _readyCallbacks = {}

    -- Rebuild everything cleanly with the fresh GUI
    local function RunFullBoot()
        -- LOADING
        local function DoLoading(cb)
            if not windowConfig.LoadingEnabled then cb() return end
            local LF = Instance.new("Frame")
            LF.Name = "Loading"
            LF.Size = UDim2.new(1,0,1,0)
            LF.BackgroundColor3 = theme.Background
            LF.BorderSizePixel = 0
            LF.ZIndex = 100
            LF.Parent = FreshGui

            local LC = Instance.new("Frame")
            LC.Name = "Container"
            LC.AnchorPoint = Vector2.new(0.5, 0.5)
            LC.Position = UDim2.new(0.5, 0, 0.5, 0)
            LC.Size = UDim2.new(0, 320, 0, 200)
            LC.BackgroundColor3 = theme.Section
            LC.BorderSizePixel = 0
            LC.ZIndex = 101
            LC.Parent = LF
            CreateCorner(LC, 16)
            CreateStroke(LC, theme.Stroke, 1)
            CreateShadow(LC)

            if windowConfig.LoadingIcon ~= "" then
                local icon = Instance.new("ImageLabel")
                icon.AnchorPoint = Vector2.new(0.5, 0)
                icon.Position = UDim2.new(0.5, 0, 0, 20)
                icon.Size = UDim2.new(0, 60, 0, 60)
                icon.BackgroundTransparency = 1
                icon.Image = "rbxassetid://" .. tostring(windowConfig.LoadingIcon)
                icon.ZIndex = 102
                icon.Parent = LC
                local ang = 0
                local spinC
                spinC = RunService.RenderStepped:Connect(function(dt)
                    ang = ang + dt * 180
                    icon.Rotation = ang
                end)
                task.delay(2.4, function() if spinC then spinC:Disconnect() end end)
            end

            local t1 = Instance.new("TextLabel")
            t1.AnchorPoint = Vector2.new(0.5, 0)
            t1.Position = UDim2.new(0.5, 0, 0, windowConfig.LoadingIcon ~= "" and 96 or 36)
            t1.Size = UDim2.new(1, -32, 0, 28)
            t1.BackgroundTransparency = 1
            t1.Font = Enum.Font.GothamBold
            t1.TextColor3 = theme.Text
            t1.TextSize = 17
            t1.Text = windowConfig.LoadingName
            t1.ZIndex = 102
            t1.Parent = LC

            local t2 = Instance.new("TextLabel")
            t2.AnchorPoint = Vector2.new(0.5, 0)
            t2.Position = UDim2.new(0.5, 0, 0, windowConfig.LoadingIcon ~= "" and 128 or 68)
            t2.Size = UDim2.new(1, -32, 0, 18)
            t2.BackgroundTransparency = 1
            t2.Font = Enum.Font.Gotham
            t2.TextColor3 = theme.TextSecondary
            t2.TextSize = 13
            t2.Text = "Loading " .. windowConfig.Name .. "..."
            t2.ZIndex = 102
            t2.Parent = LC

            local barBG = Instance.new("Frame")
            barBG.AnchorPoint = Vector2.new(0.5, 0)
            barBG.Position = UDim2.new(0.5, 0, 0, windowConfig.LoadingIcon ~= "" and 160 or 104)
            barBG.Size = UDim2.new(1, -48, 0, 6)
            barBG.BackgroundColor3 = theme.SliderTrack
            barBG.BorderSizePixel = 0
            barBG.ZIndex = 102
            barBG.Parent = LC
            CreateCorner(barBG, 3)

            local barFill = Instance.new("Frame")
            barFill.Size = UDim2.new(0, 0, 1, 0)
            barFill.BackgroundColor3 = theme.Accent
            barFill.BorderSizePixel = 0
            barFill.ZIndex = 103
            barFill.Parent = barBG
            CreateCorner(barFill, 3)

            local steps = {0.15, 0.45, 0.75, 1.0}
            local msgs = {"Initializing...", "Loading modules...", "Applying theme...", "Ready!"}
            for i, p in ipairs(steps) do
                task.delay((i - 1) * 0.4, function()
                    if t2 and t2.Parent then t2.Text = msgs[i] end
                    Tween(barFill, {Size = UDim2.new(p, 0, 1, 0)}, 0.3)
                end)
            end

            task.delay(2.0, function()
                Tween(LF, {BackgroundTransparency = 1}, 0.45)
                task.wait(0.45)
                if LF and LF.Parent then LF:Destroy() end
                cb()
            end)
        end

        -- KEY SYSTEM
        local function DoKey(cb)
            if not windowConfig.KeySystem then cb() return end
            if windowConfig.KeySave then
                local raw = SafeReadFile(lib._keyPath)
                if raw then
                    local decoded = SafeJsonDecode(raw)
                    if decoded and decoded.key == windowConfig.Key then
                        cb()
                        return
                    end
                end
            end

            local KF = Instance.new("Frame")
            KF.Size = UDim2.new(1,0,1,0)
            KF.BackgroundColor3 = Color3.fromRGB(0,0,0)
            KF.BackgroundTransparency = 0.45
            KF.BorderSizePixel = 0
            KF.ZIndex = 200
            KF.Parent = FreshGui

            local KC = Instance.new("Frame")
            KC.AnchorPoint = Vector2.new(0.5, 0.5)
            KC.Position = UDim2.new(0.5, 0, 0.5, 0)
            KC.Size = UDim2.new(0, 360, 0, 0)
            KC.BackgroundColor3 = theme.Section
            KC.BorderSizePixel = 0
            KC.ZIndex = 201
            KC.Parent = KF
            CreateCorner(KC, 14)
            CreateStroke(KC, theme.Stroke, 1)
            CreateShadow(KC)
            Tween(KC, {Size = UDim2.new(0, 360, 0, windowConfig.GetKeyFromSite and 280 or 240)}, 0.4, Enum.EasingStyle.Back)

            local kt = Instance.new("TextLabel")
            kt.AnchorPoint = Vector2.new(0.5, 0)
            kt.Position = UDim2.new(0.5, 0, 0, 20)
            kt.Size = UDim2.new(1, -32, 0, 28)
            kt.BackgroundTransparency = 1
            kt.Font = Enum.Font.GothamBold
            kt.TextColor3 = theme.Text
            kt.TextSize = 18
            kt.Text = windowConfig.KeyName
            kt.ZIndex = 202
            kt.Parent = KC

            local ks = Instance.new("TextLabel")
            ks.AnchorPoint = Vector2.new(0.5, 0)
            ks.Position = UDim2.new(0.5, 0, 0, 52)
            ks.Size = UDim2.new(1, -32, 0, 18)
            ks.BackgroundTransparency = 1
            ks.Font = Enum.Font.Gotham
            ks.TextColor3 = theme.TextSecondary
            ks.TextSize = 13
            ks.Text = "Enter your key to access " .. windowConfig.Name
            ks.ZIndex = 202
            ks.Parent = KC

            local kiBG = Instance.new("Frame")
            kiBG.AnchorPoint = Vector2.new(0.5, 0)
            kiBG.Position = UDim2.new(0.5, 0, 0, 84)
            kiBG.Size = UDim2.new(1, -48, 0, 44)
            kiBG.BackgroundColor3 = theme.Element
            kiBG.BorderSizePixel = 0
            kiBG.ZIndex = 202
            kiBG.Parent = KC
            CreateCorner(kiBG, 8)
            CreateStroke(kiBG, theme.Stroke, 1)

            local ki = Instance.new("TextBox")
            ki.Size = UDim2.new(1, -16, 1, 0)
            ki.Position = UDim2.new(0, 8, 0, 0)
            ki.BackgroundTransparency = 1
            ki.Font = Enum.Font.Gotham
            ki.TextColor3 = theme.Text
            ki.PlaceholderColor3 = theme.TextDisabled
            ki.TextSize = 14
            ki.PlaceholderText = "Enter key..."
            ki.Text = ""
            ki.ClearTextOnFocus = false
            ki.ZIndex = 203
            ki.Parent = kiBG

            local kStatus = Instance.new("TextLabel")
            kStatus.AnchorPoint = Vector2.new(0.5, 0)
            kStatus.Position = UDim2.new(0.5, 0, 0, 136)
            kStatus.Size = UDim2.new(1, -48, 0, 18)
            kStatus.BackgroundTransparency = 1
            kStatus.Font = Enum.Font.Gotham
            kStatus.TextColor3 = theme.TextSecondary
            kStatus.TextSize = 12
            kStatus.Text = ""
            kStatus.ZIndex = 202
            kStatus.Parent = KC

            local btnY = 162

            if windowConfig.GetKeyFromSite and windowConfig.SiteKey ~= "" then
                local gkBtn = Instance.new("TextButton")
                gkBtn.AnchorPoint = Vector2.new(0.5, 0)
                gkBtn.Position = UDim2.new(0.5, 0, 0, 160)
                gkBtn.Size = UDim2.new(1, -48, 0, 34)
                gkBtn.BackgroundColor3 = theme.Element
                gkBtn.BorderSizePixel = 0
                gkBtn.Font = Enum.Font.GothamBold
                gkBtn.TextColor3 = theme.TextSecondary
                gkBtn.TextSize = 13
                gkBtn.Text = "📋  Copy Key Link"
                gkBtn.ZIndex = 202
                gkBtn.Parent = KC
                CreateCorner(gkBtn, 8)
                CreateStroke(gkBtn, theme.Stroke, 1)

                gkBtn.MouseButton1Click:Connect(function()
                    pcall(setclipboard, windowConfig.SiteKey)
                    gkBtn.Text = "✓  Copied!"
                    Tween(gkBtn, {TextColor3 = theme.Accent}, 0.2)
                    task.delay(2, function()
                        gkBtn.Text = "📋  Copy Key Link"
                        Tween(gkBtn, {TextColor3 = theme.TextSecondary}, 0.2)
                    end)
                end)

                btnY = 204
            end

            local subBtn = Instance.new("TextButton")
            subBtn.AnchorPoint = Vector2.new(0.5, 0)
            subBtn.Position = UDim2.new(0.5, 0, 0, btnY)
            subBtn.Size = UDim2.new(1, -48, 0, 40)
            subBtn.BackgroundColor3 = theme.Accent
            subBtn.BorderSizePixel = 0
            subBtn.Font = Enum.Font.GothamBold
            subBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            subBtn.TextSize = 14
            subBtn.Text = "Authenticate"
            subBtn.ZIndex = 202
            subBtn.Parent = KC
            CreateCorner(subBtn, 8)

            subBtn.MouseEnter:Connect(function() Tween(subBtn, {BackgroundColor3 = theme.AccentDark}, 0.15) end)
            subBtn.MouseLeave:Connect(function() Tween(subBtn, {BackgroundColor3 = theme.Accent}, 0.15) end)

            local function TrySub()
                if ki.Text == windowConfig.Key then
                    kStatus.Text = "✓ Access granted!"
                    kStatus.TextColor3 = Color3.fromRGB(74, 222, 128)
                    if windowConfig.KeySave then
                        MakeFolder(windowConfig.ConfigFolder)
                        SafeWriteFile(lib._keyPath, SafeJsonEncode({key = ki.Text}))
                    end
                    task.delay(0.8, function()
                        Tween(KC, {Size = UDim2.new(0, 360, 0, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                        task.wait(0.35)
                        KF:Destroy()
                        cb()
                    end)
                else
                    kStatus.Text = "✗ Incorrect key. Try again."
                    kStatus.TextColor3 = Color3.fromRGB(239, 68, 68)
                    Tween(kiBG, {BackgroundColor3 = Color3.fromRGB(50, 15, 15)}, 0.15)
                    task.delay(0.5, function()
                        Tween(kiBG, {BackgroundColor3 = theme.Element}, 0.15)
                    end)
                end
            end

            subBtn.MouseButton1Click:Connect(TrySub)
            ki.FocusLost:Connect(function(ep) if ep then TrySub() end end)
        end

        -- MAIN UI BUILD
        local function DoMainUI()
            -- Main frame
            local MF = Instance.new("Frame")
            MF.Name = "MainWindow"
            MF.AnchorPoint = Vector2.new(0.5, 0.5)
            MF.Position = UDim2.new(0.5, 0, 0.4, 0)
            MF.Size = UDim2.new(0, 514, 0, 343)
            MF.BackgroundColor3 = theme.Background
            MF.BackgroundTransparency = 1
            MF.BorderSizePixel = 0
            MF.ClipsDescendants = false
            MF.ZIndex = 10
            MF.Parent = FreshGui
            CreateCorner(MF, 12)
            CreateStroke(MF, theme.Stroke, 1)
            CreateShadow(MF)
            Tween(MF, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Back)

            -- Topbar
            local TB = Instance.new("Frame")
            TB.Name = "Topbar"
            TB.Size = UDim2.new(1, 0, 0, 34)
            TB.BackgroundColor3 = theme.Topbar
            TB.BorderSizePixel = 0
            TB.ZIndex = 12
            TB.Parent = MF
            CreateCorner(TB, 12)

            local TBFix = Instance.new("Frame")
            TBFix.Size = UDim2.new(1, 0, 0.5, 0)
            TBFix.Position = UDim2.new(0, 0, 0.5, 0)
            TBFix.BackgroundColor3 = theme.Topbar
            TBFix.BorderSizePixel = 0
            TBFix.ZIndex = 12
            TBFix.Parent = TB

            local WinTitle = Instance.new("TextLabel")
            WinTitle.Position = UDim2.new(0, 11, 0, 4)
            WinTitle.Size = UDim2.new(0.5, 0, 0, 14)
            WinTitle.BackgroundTransparency = 1
            WinTitle.Font = Enum.Font.GothamBold
            WinTitle.TextColor3 = theme.Text
            WinTitle.TextSize = 15
            WinTitle.TextXAlignment = Enum.TextXAlignment.Left
            WinTitle.Text = windowConfig.Name
            WinTitle.ZIndex = 13
            WinTitle.Parent = TB

            local WinSub = Instance.new("TextLabel")
            WinSub.Position = UDim2.new(0, 11, 0, 19)
            WinSub.Size = UDim2.new(0.5, 0, 0, 10)
            WinSub.BackgroundTransparency = 1
            WinSub.Font = Enum.Font.Gotham
            WinSub.TextColor3 = theme.TextSecondary
            WinSub.TextSize = 11
            WinSub.TextXAlignment = Enum.TextXAlignment.Left
            WinSub.Text = windowConfig.SubTitle
            WinSub.ZIndex = 13
            WinSub.Parent = TB

            -- Window control buttons
            local BtnHolder = Instance.new("Frame")
            BtnHolder.AnchorPoint = Vector2.new(1, 0.5)
            BtnHolder.Position = UDim2.new(1, -12, 0.5, 0)
            BtnHolder.Size = UDim2.new(0, 79, 0, 20)
            BtnHolder.BackgroundTransparency = 1
            BtnHolder.ZIndex = 13
            BtnHolder.Parent = TB

            local BHL = Instance.new("UIListLayout")
            BHL.FillDirection = Enum.FillDirection.Horizontal
            BHL.HorizontalAlignment = Enum.HorizontalAlignment.Right
            BHL.VerticalAlignment = Enum.VerticalAlignment.Center
            BHL.Padding = UDim.new(0, 6)
            BHL.Parent = BtnHolder

            local function MkBtn(text, col)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0, 20, 0, 20)
                b.BackgroundColor3 = theme.Element
                b.BorderSizePixel = 0
                b.Font = Enum.Font.GothamBold
                b.TextColor3 = col or theme.TextSecondary
                b.TextSize = 14
                b.Text = text
                b.ZIndex = 14
                b.Parent = BtnHolder
                CreateCorner(b, 6)
                b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = theme.ElementHover}, 0.12) end)
                b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = theme.Element}, 0.12) end)
                return b
            end

            local RzBtn = MkBtn("⤡")
            local MnBtn = MkBtn("—")
            local ClBtn = MkBtn("✕", Color3.fromRGB(239, 68, 68))

            -- Close modal
            ClBtn.MouseButton1Click:Connect(function()
                local OvBG = Instance.new("Frame")
                OvBG.Size = UDim2.new(1, 0, 1, 0)
                OvBG.BackgroundColor3 = Color3.new(0, 0, 0)
                OvBG.BackgroundTransparency = 1
                OvBG.ZIndex = 50
                OvBG.Parent = FreshGui
                Tween(OvBG, {BackgroundTransparency = 0.5}, 0.2)

                local Mdl = Instance.new("Frame")
                Mdl.AnchorPoint = Vector2.new(0.5, 0.5)
                Mdl.Position = UDim2.new(0.5, 0, 0.5, 0)
                Mdl.Size = UDim2.new(0, 214, 0, 0)
                Mdl.BackgroundColor3 = theme.Section
                Mdl.BorderSizePixel = 0
                Mdl.ZIndex = 51
                Mdl.Parent = FreshGui
                CreateCorner(Mdl, 12)
                CreateStroke(Mdl, theme.Stroke, 1)
                CreateShadow(Mdl)
                Tween(Mdl, {Size = UDim2.new(0, 214, 0, 114)}, 0.3, Enum.EasingStyle.Back)

                local MdlT = Instance.new("TextLabel")
                MdlT.AnchorPoint = Vector2.new(0.5, 0)
                MdlT.Position = UDim2.new(0.5, 0, 0, 20)
                MdlT.Size = UDim2.new(1, -32, 0, 24)
                MdlT.BackgroundTransparency = 1
                MdlT.Font = Enum.Font.GothamBold
                MdlT.TextColor3 = theme.Text
                MdlT.TextSize = 16
                MdlT.Text = "Close " .. windowConfig.Name .. "?"
                MdlT.ZIndex = 52
                MdlT.Parent = Mdl

                local MdlS = Instance.new("TextLabel")
                MdlS.AnchorPoint = Vector2.new(0.5, 0)
                MdlS.Position = UDim2.new(0.5, 0, 0, 48)
                MdlS.Size = UDim2.new(1, -32, 0, 18)
                MdlS.BackgroundTransparency = 1
                MdlS.Font = Enum.Font.Gotham
                MdlS.TextColor3 = theme.TextSecondary
                MdlS.TextSize = 13
                MdlS.Text = "Are you sure you want to exit?"
                MdlS.ZIndex = 52
                MdlS.Parent = Mdl

                local MdlBF = Instance.new("Frame")
                MdlBF.AnchorPoint = Vector2.new(0.5, 0)
                MdlBF.Position = UDim2.new(0.5, 0, 0, 90)
                MdlBF.Size = UDim2.new(1, -48, 0, 40)
                MdlBF.BackgroundTransparency = 1
                MdlBF.ZIndex = 52
                MdlBF.Parent = Mdl

                local MBL = Instance.new("UIListLayout")
                MBL.FillDirection = Enum.FillDirection.Horizontal
                MBL.HorizontalAlignment = Enum.HorizontalAlignment.Center
                MBL.VerticalAlignment = Enum.VerticalAlignment.Center
                MBL.Padding = UDim.new(0, 12)
                MBL.Parent = MdlBF

                local function MkMdlBtn(text, bg, tc)
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(0, 79, 0, 26)
                    b.BackgroundColor3 = bg
                    b.BorderSizePixel = 0
                    b.Font = Enum.Font.GothamBold
                    b.TextColor3 = tc
                    b.TextSize = 13
                    b.Text = text
                    b.ZIndex = 53
                    b.Parent = MdlBF
                    CreateCorner(b, 8)
                    return b
                end

                local CnBtn = MkMdlBtn("Cancel", theme.Element, theme.TextSecondary)
                local YsBtn = MkMdlBtn("Yes, Close", Color3.fromRGB(239, 68, 68), Color3.fromRGB(255, 255, 255))

                CnBtn.MouseButton1Click:Connect(function()
                    Tween(Mdl, {Size = UDim2.new(0, 214, 0, 0), BackgroundTransparency = 1}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    Tween(OvBG, {BackgroundTransparency = 1}, 0.25)
                    task.delay(0.25, function() Mdl:Destroy() OvBG:Destroy() end)
                end)

                YsBtn.MouseButton1Click:Connect(function()
                    Tween(MF, {BackgroundTransparency = 1, Size = UDim2.new(0, 514, 0, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    Mdl:Destroy() OvBG:Destroy()
                    task.delay(0.35, function() FreshGui:Destroy() end)
                end)

                CnBtn.MouseEnter:Connect(function() Tween(CnBtn, {BackgroundColor3 = theme.ElementHover}, 0.12) end)
                CnBtn.MouseLeave:Connect(function() Tween(CnBtn, {BackgroundColor3 = theme.Element}, 0.12) end)
                YsBtn.MouseEnter:Connect(function() Tween(YsBtn, {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}, 0.12) end)
                YsBtn.MouseLeave:Connect(function() Tween(YsBtn, {BackgroundColor3 = Color3.fromRGB(239, 68, 68)}, 0.12) end)
            end)

            -- Minimize
            local minimized = false
            local savedSize = MF.Size
            MnBtn.MouseButton1Click:Connect(function()
                minimized = not minimized
                if minimized then
                    savedSize = MF.Size
                    Tween(MF, {Size = UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, 34)}, 0.35, Enum.EasingStyle.Back)
                    MnBtn.Text = "▲"
                else
                    Tween(MF, {Size = savedSize}, 0.35, Enum.EasingStyle.Back)
                    MnBtn.Text = "—"
                end
            end)

            -- Resize
            local rzStart, rzPos, rzDrag = nil, nil, false
            RzBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    rzDrag = true
                    rzStart = i.Position
                    rzPos = MF.Size
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if rzDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local dx = i.Position.X - rzStart.X
                    local dy = i.Position.Y - rzStart.Y
                    MF.Size = UDim2.new(0, math.clamp(rzPos.X.Offset + dx, 343, 714), 0, math.clamp(rzPos.Y.Offset + dy, 229, 500))
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then rzDrag = false end
            end)

            -- Drag
            local drgStart, drgPos, drgActive = nil, nil, false
            TB.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    drgActive = true
                    drgStart = i.Position
                    drgPos = MF.Position
                    i.Changed:Connect(function()
                        if i.UserInputState == Enum.UserInputState.End then drgActive = false end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drgActive and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local d = i.Position - drgStart
                    MF.Position = UDim2.new(drgPos.X.Scale, drgPos.X.Offset + d.X, drgPos.Y.Scale, drgPos.Y.Offset + d.Y)
                end
            end)

            -- Content
            local CF = Instance.new("Frame")
            CF.Name = "Content"
            CF.Position = UDim2.new(0, 0, 0, 34)
            CF.Size = UDim2.new(1, 0, 1, -34)
            CF.BackgroundTransparency = 1
            CF.ClipsDescendants = true
            CF.ZIndex = 11
            CF.Parent = MF

            -- Sidebar
            local SB = Instance.new("Frame")
            SB.Name = "Sidebar"
            SB.Size = UDim2.new(0, 100, 1, 0)
            SB.BackgroundColor3 = theme.Topbar
            SB.BorderSizePixel = 0
            SB.ZIndex = 12
            SB.Parent = CF

            local SBFix = Instance.new("Frame")
            SBFix.Size = UDim2.new(1, 0, 0, 12)
            SBFix.BackgroundColor3 = theme.Topbar
            SBFix.BorderSizePixel = 0
            SBFix.ZIndex = 12
            SBFix.Parent = SB

            local TL = Instance.new("ScrollingFrame")
            TL.Name = "TabList"
            TL.Position = UDim2.new(0, 0, 0, 8)
            TL.Size = UDim2.new(1, 0, 1, -8)
            TL.BackgroundTransparency = 1
            TL.ScrollBarThickness = 3
            TL.ScrollBarImageColor3 = theme.Scrollbar
            TL.BorderSizePixel = 0
            TL.ZIndex = 13
            TL.CanvasSize = UDim2.new(0, 0, 0, 0)
            TL.Parent = SB

            local TLL = Instance.new("UIListLayout")
            TLL.SortOrder = Enum.SortOrder.LayoutOrder
            TLL.Padding = UDim.new(0, 4)
            TLL.Parent = TL

            local TLPad = Instance.new("UIPadding")
            TLPad.PaddingLeft = UDim.new(0, 8)
            TLPad.PaddingRight = UDim.new(0, 8)
            TLPad.PaddingTop = UDim.new(0, 6)
            TLPad.Parent = TL

            TLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TL.CanvasSize = UDim2.new(0, 0, 0, TLL.AbsoluteContentSize.Y + 16)
            end)

            -- Tab content area
            local TC = Instance.new("Frame")
            TC.Name = "TabContent"
            TC.Position = UDim2.new(0, 100, 0, 0)
            TC.Size = UDim2.new(1, -100, 1, 0)
            TC.BackgroundTransparency = 1
            TC.ClipsDescendants = true
            TC.ZIndex = 11
            TC.Parent = CF

            -- Theme callbacks for core elements
            lib:_registerThemeCallback(function(t)
                theme = t
                Tween(MF, {BackgroundColor3 = t.Background}, 0.3)
                Tween(TB, {BackgroundColor3 = t.Topbar}, 0.3)
                Tween(TBFix, {BackgroundColor3 = t.Topbar}, 0.3)
                Tween(WinTitle, {TextColor3 = t.Text}, 0.3)
                Tween(WinSub, {TextColor3 = t.TextSecondary}, 0.3)
                Tween(SB, {BackgroundColor3 = t.Topbar}, 0.3)
                Tween(SBFix, {BackgroundColor3 = t.Topbar}, 0.3)
                TL.ScrollBarImageColor3 = t.Scrollbar
            end)

            -- Window object
            local W = {}
            W._lib = lib
            W._tabs = {}
            W._activeTab = nil
            W._tc = TC
            W._tl = TL
            W._tll = TLL

            -- AddTab
            function W:AddTab(cfg)
                cfg = cfg or {}
                local tName = cfg.Name or "Tab"
                local tIcon = cfg.Icon or ""

                local Page = Instance.new("ScrollingFrame")
                Page.Name = "Page_" .. tName
                Page.Size = UDim2.new(1, 0, 1, 0)
                Page.BackgroundTransparency = 1
                Page.ScrollBarThickness = 3
                Page.ScrollBarImageColor3 = theme.Scrollbar
                Page.BorderSizePixel = 0
                Page.ZIndex = 11
                Page.Visible = false
                Page.CanvasSize = UDim2.new(0, 0, 0, 0)
                Page.Parent = TC

                local PageLayout = Instance.new("UIListLayout")
                PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
                PageLayout.Padding = UDim.new(0, 12)
                PageLayout.Parent = Page

                local PagePad = Instance.new("UIPadding")
                PagePad.PaddingLeft = UDim.new(0, 12)
                PagePad.PaddingRight = UDim.new(0, 12)
                PagePad.PaddingTop = UDim.new(0, 12)
                PagePad.PaddingBottom = UDim.new(0, 12)
                PagePad.Parent = Page

                PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 24)
                end)

                lib:_registerThemeCallback(function(t)
                    Page.ScrollBarImageColor3 = t.Scrollbar
                end)

                -- Tab button
                local TBtn = Instance.new("TextButton")
                TBtn.Size = UDim2.new(1, 0, 0, 26)
                TBtn.BackgroundColor3 = theme.Element
                TBtn.BackgroundTransparency = 1
                TBtn.BorderSizePixel = 0
                TBtn.Font = Enum.Font.GothamMedium
                TBtn.TextColor3 = theme.TextSecondary
                TBtn.TextSize = 13
                TBtn.Text = (tIcon ~= "" and tIcon .. "  " or "") .. tName
                TBtn.TextXAlignment = Enum.TextXAlignment.Left
                TBtn.ZIndex = 14
                TBtn.Parent = TL
                CreateCorner(TBtn, 8)

                local TBtnPad = Instance.new("UIPadding")
                TBtnPad.PaddingLeft = UDim.new(0, 10)
                TBtnPad.Parent = TBtn

                local TInd = Instance.new("Frame")
                TInd.Name = "Indicator"
                TInd.Position = UDim2.new(0, 0, 0.5, -6)
                TInd.Size = UDim2.new(0, 3, 0, 11)
                TInd.BackgroundColor3 = theme.Accent
                TInd.BackgroundTransparency = 1
                TInd.BorderSizePixel = 0
                TInd.ZIndex = 15
                TInd.Parent = TBtn
                CreateCorner(TInd, 2)

                local entry = {name = tName, page = Page, btn = TBtn, ind = TInd, layout = PageLayout}
                table.insert(W._tabs, entry)

                local function SelectThis()
                    for _, e in ipairs(W._tabs) do
                        Tween(e.btn, {BackgroundTransparency = 1, TextColor3 = theme.TextSecondary}, 0.2)
                        Tween(e.ind, {BackgroundTransparency = 1}, 0.2)
                        e.page.Visible = false
                    end
                    Tween(TBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.Element, TextColor3 = theme.Text}, 0.2)
                    Tween(TInd, {BackgroundTransparency = 0}, 0.2)
                    Page.Visible = true
                    W._activeTab = tName
                    Page.CanvasPosition = Vector2.new(0, 0)
                end

                TBtn.MouseButton1Click:Connect(SelectThis)
                TBtn.MouseEnter:Connect(function()
                    if W._activeTab ~= tName then
                        Tween(TBtn, {BackgroundTransparency = 0.6, BackgroundColor3 = theme.Element}, 0.12)
                    end
                end)
                TBtn.MouseLeave:Connect(function()
                    if W._activeTab ~= tName then
                        Tween(TBtn, {BackgroundTransparency = 1}, 0.12)
                    end
                end)

                if #W._tabs == 1 then SelectThis() end

                lib:_registerThemeCallback(function(t)
                    if W._activeTab == tName then
                        Tween(TBtn, {BackgroundColor3 = t.Element, TextColor3 = t.Text}, 0.3)
                        Tween(TInd, {BackgroundColor3 = t.Accent}, 0.3)
                    else
                        Tween(TBtn, {TextColor3 = t.TextSecondary}, 0.3)
                    end
                end)

                -- Tab object
                local T = {}

                -- AddSection
                function T:AddSection(scfg)
                    scfg = scfg or {}
                    local sName = scfg.Name or "Section"

                    local SF = Instance.new("Frame")
                    SF.Name = "Sec_" .. sName
                    SF.Size = UDim2.new(1, 0, 0, 0)
                    SF.BackgroundColor3 = theme.Section
                    SF.BorderSizePixel = 0
                    SF.AutomaticSize = Enum.AutomaticSize.Y
                    SF.ZIndex = 12
                    SF.Parent = Page
                    CreateCorner(SF, 10)
                    CreateStroke(SF, theme.Stroke, 1)

                    local ST = Instance.new("TextLabel")
                    ST.Position = UDim2.new(0, 10, 0, 7)
                    ST.Size = UDim2.new(1, -28, 0, 11)
                    ST.BackgroundTransparency = 1
                    ST.Font = Enum.Font.GothamBold
                    ST.TextColor3 = theme.Accent
                    ST.TextSize = 11
                    ST.TextXAlignment = Enum.TextXAlignment.Left
                    ST.Text = sName:upper()
                    ST.ZIndex = 13
                    ST.Parent = SF

                    local SD = Instance.new("Frame")
                    SD.Position = UDim2.new(0, 10, 0, 21)
                    SD.Size = UDim2.new(1, -28, 0, 1)
                    SD.BackgroundColor3 = theme.Stroke
                    SD.BorderSizePixel = 0
                    SD.ZIndex = 13
                    SD.Parent = SF

                    local SC = Instance.new("Frame")
                    SC.Name = "Content"
                    SC.Position = UDim2.new(0, 0, 0, 24)
                    SC.Size = UDim2.new(1, 0, 0, 0)
                    SC.BackgroundTransparency = 1
                    SC.AutomaticSize = Enum.AutomaticSize.Y
                    SC.ZIndex = 13
                    SC.Parent = SF

                    local SCL = Instance.new("UIListLayout")
                    SCL.SortOrder = Enum.SortOrder.LayoutOrder
                    SCL.Padding = UDim.new(0, 0)
                    SCL.Parent = SC

                    local SCP = Instance.new("UIPadding")
                    SCP.PaddingBottom = UDim.new(0, 8)
                    SCP.Parent = SC

                    lib:_registerThemeCallback(function(t)
                        Tween(SF, {BackgroundColor3 = t.Section}, 0.3)
                        Tween(ST, {TextColor3 = t.Accent}, 0.3)
                        Tween(SD, {BackgroundColor3 = t.Stroke}, 0.3)
                    end)

                    local Sec = {}

                    local function MkRow(h)
                        local f = Instance.new("Frame")
                        f.Size = UDim2.new(1, 0, 0, h or 31)
                        f.BackgroundColor3 = theme.Section
                        f.BorderSizePixel = 0
                        f.ZIndex = 14
                        f.Parent = SC
                        lib:_registerThemeCallback(function(t) Tween(f, {BackgroundColor3 = t.Section}, 0.3) end)
                        return f
                    end

                    -- Label
                    function Sec:AddLabel(c)
                        c = c or {}
                        local row = MkRow(26)
                        local lbl = Instance.new("TextLabel")
                        lbl.Position = UDim2.new(0, 14, 0, 0)
                        lbl.Size = UDim2.new(1, -28, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Font = Enum.Font.Gotham
                        lbl.TextColor3 = theme.TextSecondary
                        lbl.TextSize = 13
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                        lbl.Text = c.Text or "Label"
                        lbl.ZIndex = 15
                        lbl.Parent = row
                        lib:_registerThemeCallback(function(t) Tween(lbl, {TextColor3 = t.TextSecondary}, 0.3) end)
                        local obj = {}
                        function obj:SetText(t) lbl.Text = t end
                        return obj
                    end

                    -- Button
                    function Sec:AddButton(c)
                        c = c or {}
                        local bName = c.Name or "Button"
                        local bDesc = c.Description or ""
                        local bCb   = c.Callback or function() end
                        local row = MkRow(bDesc ~= "" and 41 or 31)
                        local btn = Instance.new("TextButton")
                        btn.Position = UDim2.new(0, 10, 0, 5)
                        btn.Size = UDim2.new(1, -28, 0, bDesc ~= "" and 31 or 21)
                        btn.BackgroundColor3 = theme.Element
                        btn.BorderSizePixel = 0
                        btn.Font = Enum.Font.GothamBold
                        btn.TextColor3 = theme.Text
                        btn.TextSize = 13
                        btn.Text = bName
                        btn.ZIndex = 15
                        btn.Parent = row
                        CreateCorner(btn, 8)
                        CreateStroke(btn, theme.Stroke, 1)
                        if bDesc ~= "" then
                            local dl = Instance.new("TextLabel")
                            dl.Position = UDim2.new(0, 0, 0, 21)
                            dl.Size = UDim2.new(1, 0, 0, 10)
                            dl.BackgroundTransparency = 1
                            dl.Font = Enum.Font.Gotham
                            dl.TextColor3 = theme.TextSecondary
                            dl.TextSize = 11
                            dl.Text = bDesc
                            dl.ZIndex = 16
                            dl.Parent = btn
                            lib:_registerThemeCallback(function(t) Tween(dl, {TextColor3 = t.TextSecondary}, 0.3) end)
                        end
                        btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = theme.ElementHover}, 0.12) end)
                        btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = theme.Element}, 0.12) end)
                        btn.MouseButton1Down:Connect(function() Tween(btn, {BackgroundColor3 = theme.Stroke}, 0.08) end)
                        btn.MouseButton1Up:Connect(function() Tween(btn, {BackgroundColor3 = theme.ElementHover}, 0.08) end)
                        btn.MouseButton1Click:Connect(function()
                            local rp = Instance.new("Frame")
                            rp.AnchorPoint = Vector2.new(0.5, 0.5)
                            rp.Position = UDim2.new(0.5, 0, 0.5, 0)
                            rp.Size = UDim2.new(0, 0, 0, 0)
                            rp.BackgroundColor3 = theme.Accent
                            rp.BackgroundTransparency = 0.7
                            rp.BorderSizePixel = 0
                            rp.ZIndex = 16
                            rp.Parent = btn
                            CreateCorner(rp, 4)
                            Tween(rp, {Size = UDim2.new(1.5, 0, 3, 0), BackgroundTransparency = 1}, 0.4)
                            task.delay(0.4, function() rp:Destroy() end)
                            pcall(bCb)
                        end)
                        lib:_registerThemeCallback(function(t)
                            Tween(btn, {BackgroundColor3 = t.Element, TextColor3 = t.Text}, 0.3)
                        end)
                        local obj = {}
                        function obj:SetText(t) btn.Text = t end
                        function obj:SetCallback(fn) bCb = fn end
                        return obj
                    end

                    -- Toggle
                    function Sec:AddToggle(c)
                        c = c or {}
                        local tgName = c.Name or "Toggle"
                        local tgDesc = c.Description or ""
                        local tgDef  = c.Default or false
                        local tgCb   = c.Callback or function() end
                        local tgId   = c.Id or tgName
                        local row = MkRow(tgDesc ~= "" and 40 or 31)

                        local tgL = Instance.new("TextLabel")
                        tgL.Position = UDim2.new(0, 14, 0, 0)
                        tgL.Size = UDim2.new(1, -70, tgDesc ~= "" and 0.5 or 1, 0)
                        tgL.BackgroundTransparency = 1
                        tgL.Font = Enum.Font.GothamMedium
                        tgL.TextColor3 = theme.Text
                        tgL.TextSize = 13
                        tgL.TextXAlignment = Enum.TextXAlignment.Left
                        tgL.Text = tgName
                        tgL.ZIndex = 15
                        tgL.Parent = row

                        if tgDesc ~= "" then
                            local dl = Instance.new("TextLabel")
                            dl.Position = UDim2.new(0, 14, 0.5, 0)
                            dl.Size = UDim2.new(1, -70, 0.5, 0)
                            dl.BackgroundTransparency = 1
                            dl.Font = Enum.Font.Gotham
                            dl.TextColor3 = theme.TextSecondary
                            dl.TextSize = 11
                            dl.TextXAlignment = Enum.TextXAlignment.Left
                            dl.Text = tgDesc
                            dl.ZIndex = 15
                            dl.Parent = row
                            lib:_registerThemeCallback(function(t) Tween(dl, {TextColor3 = t.TextSecondary}, 0.3) end)
                        end

                        local tgBG = Instance.new("Frame")
                        tgBG.AnchorPoint = Vector2.new(1, 0.5)
                        tgBG.Position = UDim2.new(1, -14, 0.5, 0)
                        tgBG.Size = UDim2.new(0, 31, 0, 17)
                        tgBG.BackgroundColor3 = theme.Toggle
                        tgBG.BorderSizePixel = 0
                        tgBG.ZIndex = 15
                        tgBG.Parent = row
                        CreateCorner(tgBG, 9)

                        local tgC = Instance.new("Frame")
                        tgC.Position = UDim2.new(0, 2, 0.5, -6)
                        tgC.Size = UDim2.new(0, 13, 0, 13)
                        tgC.BackgroundColor3 = theme.Text
                        tgC.BorderSizePixel = 0
                        tgC.ZIndex = 16
                        tgC.Parent = tgBG
                        CreateCorner(tgC, 6)

                        local _val = tgDef

                        local function SetTg(v, skip)
                            _val = v
                            if v then
                                Tween(tgBG, {BackgroundColor3 = theme.ToggleEnabled}, 0.22)
                                Tween(tgC, {Position = UDim2.new(0, 16, 0.5, -6)}, 0.22, Enum.EasingStyle.Back)
                            else
                                Tween(tgBG, {BackgroundColor3 = theme.Toggle}, 0.22)
                                Tween(tgC, {Position = UDim2.new(0, 2, 0.5, -6)}, 0.22, Enum.EasingStyle.Back)
                            end
                            if not skip then
                                pcall(tgCb, v)
                                if windowConfig.AutoSave then task.delay(0.5, function() lib:_saveConfig() end) end
                            end
                        end

                        SetTg(_val, true)
                        tgBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SetTg(not _val) end end)
                        row.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SetTg(not _val) end end)

                        lib:_registerThemeCallback(function(t)
                            Tween(tgL, {TextColor3 = t.Text}, 0.3)
                            if _val then Tween(tgBG, {BackgroundColor3 = t.ToggleEnabled}, 0.3)
                            else Tween(tgBG, {BackgroundColor3 = t.Toggle}, 0.3) end
                            Tween(tgC, {BackgroundColor3 = t.Text}, 0.3)
                        end)

                        lib:_registerElement(tgId, function() return _val end, function(v) SetTg(v == true, true) end)

                        local obj = {}
                        function obj:SetValue(v) SetTg(v) end
                        function obj:GetValue() return _val end
                        function obj:SetCallback(fn) tgCb = fn end
                        return obj
                    end

                    -- Slider
                    function Sec:AddSlider(c)
                        c = c or {}
                        local sName = c.Name or "Slider"
                        local sMin  = c.Min or 0
                        local sMax  = c.Max or 100
                        local sDef  = c.Default or 50
                        local sInc  = c.Increment or 1
                        local sSuf  = c.Suffix or ""
                        local sCb   = c.Callback or function() end
                        local sId   = c.Id or sName
                        local sDesc = c.Description or ""
                        local row = MkRow(sDesc ~= "" and 50 or 41)

                        local sLabel = Instance.new("TextLabel")
                        sLabel.Position = UDim2.new(0, 14, 0, 8)
                        sLabel.Size = UDim2.new(1, -100, 0, 18)
                        sLabel.BackgroundTransparency = 1
                        sLabel.Font = Enum.Font.GothamMedium
                        sLabel.TextColor3 = theme.Text
                        sLabel.TextSize = 13
                        sLabel.TextXAlignment = Enum.TextXAlignment.Left
                        sLabel.Text = sName
                        sLabel.ZIndex = 15
                        sLabel.Parent = row

                        local sVal = Instance.new("TextLabel")
                        sVal.AnchorPoint = Vector2.new(1, 0)
                        sVal.Position = UDim2.new(1, -14, 0, 8)
                        sVal.Size = UDim2.new(0, 80, 0, 18)
                        sVal.BackgroundTransparency = 1
                        sVal.Font = Enum.Font.GothamBold
                        sVal.TextColor3 = theme.Accent
                        sVal.TextSize = 13
                        sVal.TextXAlignment = Enum.TextXAlignment.Right
                        sVal.ZIndex = 15
                        sVal.Parent = row

                        if sDesc ~= "" then
                            local dl = Instance.new("TextLabel")
                            dl.Position = UDim2.new(0, 14, 0, 26)
                            dl.Size = UDim2.new(1, -28, 0, 14)
                            dl.BackgroundTransparency = 1
                            dl.Font = Enum.Font.Gotham
                            dl.TextColor3 = theme.TextSecondary
                            dl.TextSize = 11
                            dl.TextXAlignment = Enum.TextXAlignment.Left
                            dl.Text = sDesc
                            dl.ZIndex = 15
                            dl.Parent = row
                            lib:_registerThemeCallback(function(t) Tween(dl, {TextColor3 = t.TextSecondary}, 0.3) end)
                        end

                        local trackY = sDesc ~= "" and 48 or 36

                        local sTrk = Instance.new("Frame")
                        sTrk.Position = UDim2.new(0, 14, 0, trackY)
                        sTrk.Size = UDim2.new(1, -28, 0, 6)
                        sTrk.BackgroundColor3 = theme.SliderTrack
                        sTrk.BorderSizePixel = 0
                        sTrk.ZIndex = 15
                        sTrk.Parent = row
                        CreateCorner(sTrk, 3)

                        local sFill = Instance.new("Frame")
                        sFill.Size = UDim2.new(0, 0, 1, 0)
                        sFill.BackgroundColor3 = theme.SliderFill
                        sFill.BorderSizePixel = 0
                        sFill.ZIndex = 16
                        sFill.Parent = sTrk
                        CreateCorner(sFill, 3)

                        local sKnob = Instance.new("Frame")
                        sKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                        sKnob.Position = UDim2.new(0, 0, 0.5, 0)
                        sKnob.Size = UDim2.new(0, 11, 0, 11)
                        sKnob.BackgroundColor3 = theme.Accent
                        sKnob.BorderSizePixel = 0
                        sKnob.ZIndex = 17
                        sKnob.Parent = sTrk
                        CreateCorner(sKnob, 6)

                        local _svalue = sDef
                        local sdragging = false

                        local function UpdSlider(v, skip)
                            v = math.clamp(v, sMin, sMax)
                            v = math.round(v / sInc) * sInc
                            _svalue = v
                            local a = (v - sMin) / (sMax - sMin)
                            Tween(sFill, {Size = UDim2.new(a, 0, 1, 0)}, 0.1)
                            Tween(sKnob, {Position = UDim2.new(a, 0, 0.5, 0)}, 0.1)
                            sVal.Text = tostring(v) .. sSuf
                            if not skip then
                                pcall(sCb, v)
                                if windowConfig.AutoSave then task.delay(0.5, function() lib:_saveConfig() end) end
                            end
                        end

                        UpdSlider(_svalue, true)

                        local function GetSV(x)
                            local ap = sTrk.AbsolutePosition.X
                            local as_ = sTrk.AbsoluteSize.X
                            local a = math.clamp((x - ap) / as_, 0, 1)
                            return sMin + a * (sMax - sMin)
                        end

                        sTrk.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                sdragging = true
                                UpdSlider(GetSV(i.Position.X))
                            end
                        end)
                        sKnob.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then sdragging = true end
                        end)
                        UserInputService.InputChanged:Connect(function(i)
                            if sdragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                                UpdSlider(GetSV(i.Position.X))
                            end
                        end)
                        UserInputService.InputEnded:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then sdragging = false end
                        end)

                        lib:_registerThemeCallback(function(t)
                            Tween(sLabel, {TextColor3 = t.Text}, 0.3)
                            Tween(sVal, {TextColor3 = t.Accent}, 0.3)
                            Tween(sTrk, {BackgroundColor3 = t.SliderTrack}, 0.3)
                            Tween(sFill, {BackgroundColor3 = t.SliderFill}, 0.3)
                            Tween(sKnob, {BackgroundColor3 = t.Accent}, 0.3)
                        end)

                        lib:_registerElement(sId,
                            function() return _svalue end,
                            function(v) local n = tonumber(v); if n then UpdSlider(n, true) end end
                        )

                        local obj = {}
                        function obj:SetValue(v) UpdSlider(v) end
                        function obj:GetValue() return _svalue end
                        function obj:SetCallback(fn) sCb = fn end
                        return obj
                    end

                    -- Dropdown
                    function Sec:AddDropdown(c)
                        c = c or {}
                        local dName = c.Name or "Dropdown"
                        local dOpts = c.Options or {}
                        local dDef  = c.Default or (dOpts[1] or "")
                        local dCb   = c.Callback or function() end
                        local dId   = c.Id or dName
                        local row = MkRow(44)

                        local dLabel = Instance.new("TextLabel")
                        dLabel.Position = UDim2.new(0, 14, 0, 0)
                        dLabel.Size = UDim2.new(0.45, 0, 1, 0)
                        dLabel.BackgroundTransparency = 1
                        dLabel.Font = Enum.Font.GothamMedium
                        dLabel.TextColor3 = theme.Text
                        dLabel.TextSize = 13
                        dLabel.TextXAlignment = Enum.TextXAlignment.Left
                        dLabel.Text = dName
                        dLabel.ZIndex = 15
                        dLabel.Parent = row

                        local dBtn = Instance.new("TextButton")
                        dBtn.AnchorPoint = Vector2.new(1, 0.5)
                        dBtn.Position = UDim2.new(1, -14, 0.5, 0)
                        dBtn.Size = UDim2.new(0, 114, 0, 21)
                        dBtn.BackgroundColor3 = theme.Element
                        dBtn.BorderSizePixel = 0
                        dBtn.Font = Enum.Font.Gotham
                        dBtn.TextColor3 = theme.Text
                        dBtn.TextSize = 12
                        dBtn.ZIndex = 15
                        dBtn.Parent = row
                        CreateCorner(dBtn, 8)
                        CreateStroke(dBtn, theme.Stroke, 1)

                        local _dval = dDef
                        local _dopen = false
                        local _dframe = nil

                        local function SetDV(v, skip)
                            _dval = v
                            dBtn.Text = v .. "  ▾"
                            if not skip then
                                pcall(dCb, v)
                                if windowConfig.AutoSave then task.delay(0.5, function() lib:_saveConfig() end) end
                            end
                        end

                        SetDV(_dval, true)

                        local function CloseDrop()
                            if _dframe then
                                Tween(_dframe, {Size = UDim2.new(1, -28, 0, 0)}, 0.2)
                                task.delay(0.2, function()
                                    if _dframe then _dframe:Destroy(); _dframe = nil end
                                end)
                            end
                            _dopen = false
                            dBtn.Text = _dval .. "  ▾"
                            row.Size = UDim2.new(1, 0, 0, 31)
                        end

                        dBtn.MouseButton1Click:Connect(function()
                            if _dopen then CloseDrop() return end
                            _dopen = true
                            dBtn.Text = _dval .. "  ▲"

                            local oh = 23
                            local tot = #dOpts * oh

                            _dframe = Instance.new("Frame")
                            _dframe.Name = "DDrop"
                            _dframe.Position = UDim2.new(0, 14, 1, 4)
                            _dframe.Size = UDim2.new(1, -28, 0, 0)
                            _dframe.BackgroundColor3 = theme.Element
                            _dframe.BorderSizePixel = 0
                            _dframe.ClipsDescendants = true
                            _dframe.ZIndex = 30
                            _dframe.Parent = row
                            CreateCorner(_dframe, 8)
                            CreateStroke(_dframe, theme.Stroke, 1)

                            local dScroll = Instance.new("ScrollingFrame")
                            dScroll.Size = UDim2.new(1, 0, 1, 0)
                            dScroll.BackgroundTransparency = 1
                            dScroll.ScrollBarThickness = 3
                            dScroll.ScrollBarImageColor3 = theme.Scrollbar
                            dScroll.BorderSizePixel = 0
                            dScroll.ZIndex = 31
                            dScroll.CanvasSize = UDim2.new(0, 0, 0, tot)
                            dScroll.Parent = _dframe

                            local dLL = Instance.new("UIListLayout")
                            dLL.SortOrder = Enum.SortOrder.LayoutOrder
                            dLL.Parent = dScroll

                            for _, opt in ipairs(dOpts) do
                                local ob = Instance.new("TextButton")
                                ob.Size = UDim2.new(1, 0, 0, oh)
                                ob.BackgroundTransparency = 1
                                ob.Font = opt == _dval and Enum.Font.GothamBold or Enum.Font.Gotham
                                ob.TextColor3 = opt == _dval and theme.Accent or theme.Text
                                ob.TextSize = 13
                                ob.Text = opt
                                ob.ZIndex = 32
                                ob.Parent = dScroll
                                ob.MouseEnter:Connect(function() Tween(ob, {BackgroundTransparency = 0.7, BackgroundColor3 = theme.ElementHover}, 0.1) end)
                                ob.MouseLeave:Connect(function() Tween(ob, {BackgroundTransparency = 1}, 0.1) end)
                                ob.MouseButton1Click:Connect(function() SetDV(opt); CloseDrop() end)
                            end

                            local ch = math.min(tot, 114)
                            Tween(_dframe, {Size = UDim2.new(1, -28, 0, ch)}, 0.22, Enum.EasingStyle.Back)
                            row.Size = UDim2.new(1, 0, 0, 31 + ch + 6)
                        end)

                        dBtn.MouseEnter:Connect(function() Tween(dBtn, {BackgroundColor3 = theme.ElementHover}, 0.12) end)
                        dBtn.MouseLeave:Connect(function() Tween(dBtn, {BackgroundColor3 = theme.Element}, 0.12) end)

                        lib:_registerThemeCallback(function(t)
                            Tween(dLabel, {TextColor3 = t.Text}, 0.3)
                            Tween(dBtn, {BackgroundColor3 = t.Element, TextColor3 = t.Text}, 0.3)
                        end)

                        lib:_registerElement(dId,
                            function() return _dval end,
                            function(v)
                                for _, op in ipairs(dOpts) do
                                    if op == v then SetDV(v, true) break end
                                end
                            end
                        )

                        local obj = {}
                        function obj:SetValue(v) SetDV(v) end
                        function obj:GetValue() return _dval end
                        function obj:SetOptions(opts) dOpts = opts end
                        function obj:SetCallback(fn) dCb = fn end
                        return obj
                    end

                    -- Textbox
                    function Sec:AddTextbox(c)
                        c = c or {}
                        local tName  = c.Name or "Textbox"
                        local tDef   = c.Default or ""
                        local tPh    = c.Placeholder or "Type here..."
                        local tCb    = c.Callback or function() end
                        local tId    = c.Id or tName
                        local tNum   = c.NumberOnly or false
                        local row = MkRow(41)

                        local tLabel = Instance.new("TextLabel")
                        tLabel.Position = UDim2.new(0, 14, 0, 6)
                        tLabel.Size = UDim2.new(1, -28, 0, 18)
                        tLabel.BackgroundTransparency = 1
                        tLabel.Font = Enum.Font.GothamMedium
                        tLabel.TextColor3 = theme.Text
                        tLabel.TextSize = 13
                        tLabel.TextXAlignment = Enum.TextXAlignment.Left
                        tLabel.Text = tName
                        tLabel.ZIndex = 15
                        tLabel.Parent = row

                        local tBG = Instance.new("Frame")
                        tBG.Position = UDim2.new(0, 10, 0, 20)
                        tBG.Size = UDim2.new(1, -28, 0, 17)
                        tBG.BackgroundColor3 = theme.Element
                        tBG.BorderSizePixel = 0
                        tBG.ZIndex = 15
                        tBG.Parent = row
                        CreateCorner(tBG, 6)
                        CreateStroke(tBG, theme.Stroke, 1)

                        local tBox = Instance.new("TextBox")
                        tBox.Size = UDim2.new(1, -12, 1, 0)
                        tBox.Position = UDim2.new(0, 6, 0, 0)
                        tBox.BackgroundTransparency = 1
                        tBox.Font = Enum.Font.Gotham
                        tBox.TextColor3 = theme.Text
                        tBox.PlaceholderColor3 = theme.TextDisabled
                        tBox.TextSize = 12
                        tBox.PlaceholderText = tPh
                        tBox.Text = tDef
                        tBox.ClearTextOnFocus = false
                        tBox.ZIndex = 16
                        tBox.Parent = tBG

                        local _tval = tDef
                        tBox.Focused:Connect(function() Tween(tBG, {BackgroundColor3 = theme.ElementHover}, 0.2) end)
                        tBox.FocusLost:Connect(function()
                            Tween(tBG, {BackgroundColor3 = theme.Element}, 0.2)
                            local txt = tBox.Text
                            if tNum then
                                local n = tonumber(txt)
                                if not n then tBox.Text = _tval return end
                                txt = tostring(n)
                            end
                            _tval = txt
                            pcall(tCb, txt)
                            if windowConfig.AutoSave then task.delay(0.5, function() lib:_saveConfig() end) end
                        end)

                        lib:_registerThemeCallback(function(t)
                            Tween(tLabel, {TextColor3 = t.Text}, 0.3)
                            Tween(tBG, {BackgroundColor3 = t.Element}, 0.3)
                            Tween(tBox, {TextColor3 = t.Text}, 0.3)
                        end)

                        lib:_registerElement(tId,
                            function() return _tval end,
                            function(v) _tval = tostring(v); tBox.Text = _tval end
                        )

                        local obj = {}
                        function obj:SetValue(v) _tval = tostring(v); tBox.Text = _tval end
                        function obj:GetValue() return _tval end
                        function obj:SetCallback(fn) tCb = fn end
                        return obj
                    end

                    -- Keybind
                    function Sec:AddKeybind(c)
                        c = c or {}
                        local kName = c.Name or "Keybind"
                        local kDef  = c.Default or Enum.KeyCode.RightShift
                        local kCb   = c.Callback or function() end
                        local kId   = c.Id or kName
                        local row = MkRow(44)

                        local kLabel = Instance.new("TextLabel")
                        kLabel.Position = UDim2.new(0, 14, 0, 0)
                        kLabel.Size = UDim2.new(0.6, 0, 1, 0)
                        kLabel.BackgroundTransparency = 1
                        kLabel.Font = Enum.Font.GothamMedium
                        kLabel.TextColor3 = theme.Text
                        kLabel.TextSize = 13
                        kLabel.TextXAlignment = Enum.TextXAlignment.Left
                        kLabel.Text = kName
                        kLabel.ZIndex = 15
                        kLabel.Parent = row

                        local kBtn = Instance.new("TextButton")
                        kBtn.AnchorPoint = Vector2.new(1, 0.5)
                        kBtn.Position = UDim2.new(1, -14, 0.5, 0)
                        kBtn.Size = UDim2.new(0, 57, 0, 20)
                        kBtn.BackgroundColor3 = theme.Element
                        kBtn.BorderSizePixel = 0
                        kBtn.Font = Enum.Font.GothamBold
                        kBtn.TextColor3 = theme.Accent
                        kBtn.TextSize = 12
                        kBtn.ZIndex = 15
                        kBtn.Parent = row
                        CreateCorner(kBtn, 6)
                        CreateStroke(kBtn, theme.Stroke, 1)

                        local _kval = kDef
                        local _kl = false

                        local shorts = {
                            LeftControl="LCtrl", RightControl="RCtrl",
                            LeftShift="LShift", RightShift="RShift",
                            LeftAlt="LAlt", RightAlt="RAlt",
                            Return="Enter", BackSpace="Bksp"
                        }
                        local function FmtKey(k)
                            return shorts[k.Name] or k.Name
                        end

                        kBtn.Text = "[" .. FmtKey(_kval) .. "]"

                        kBtn.MouseButton1Click:Connect(function()
                            if _kl then return end
                            _kl = true
                            kBtn.Text = "..."
                            Tween(kBtn, {BackgroundColor3 = theme.ElementHover}, 0.12)
                            local conn
                            conn = UserInputService.InputBegan:Connect(function(i)
                                if i.UserInputType == Enum.UserInputType.Keyboard then
                                    _kval = i.KeyCode
                                    kBtn.Text = "[" .. FmtKey(_kval) .. "]"
                                    _kl = false
                                    Tween(kBtn, {BackgroundColor3 = theme.Element}, 0.12)
                                    conn:Disconnect()
                                    if windowConfig.AutoSave then task.delay(0.5, function() lib:_saveConfig() end) end
                                end
                            end)
                        end)

                        UserInputService.InputBegan:Connect(function(i, gp)
                            if not gp and i.KeyCode == _kval and not _kl then
                                pcall(kCb, _kval)
                            end
                        end)

                        lib:_registerThemeCallback(function(t)
                            Tween(kLabel, {TextColor3 = t.Text}, 0.3)
                            Tween(kBtn, {BackgroundColor3 = t.Element, TextColor3 = t.Accent}, 0.3)
                        end)

                        lib:_registerElement(kId,
                            function() return _kval.Name end,
                            function(v)
                                local ok, k = pcall(function() return Enum.KeyCode[v] end)
                                if ok and k then _kval = k; kBtn.Text = "[" .. FmtKey(_kval) .. "]" end
                            end
                        )

                        local obj = {}
                        function obj:GetValue() return _kval end
                        function obj:SetValue(k) _kval = k; kBtn.Text = "[" .. FmtKey(k) .. "]" end
                        function obj:SetCallback(fn) kCb = fn end
                        return obj
                    end

                    -- ColorPicker
                    function Sec:AddColorPicker(c)
                        c = c or {}
                        local cpName = c.Name or "Color"
                        local cpDef  = c.Default or Color3.fromRGB(200, 100, 100)
                        local cpCb   = c.Callback or function() end
                        local cpId   = c.Id or cpName
                        local row = MkRow(44)
                        local _cpopen = false
                        local _cpframe = nil

                        local cpLabel = Instance.new("TextLabel")
                        cpLabel.Position = UDim2.new(0, 14, 0, 0)
                        cpLabel.Size = UDim2.new(0.6, 0, 1, 0)
                        cpLabel.BackgroundTransparency = 1
                        cpLabel.Font = Enum.Font.GothamMedium
                        cpLabel.TextColor3 = theme.Text
                        cpLabel.TextSize = 13
                        cpLabel.TextXAlignment = Enum.TextXAlignment.Left
                        cpLabel.Text = cpName
                        cpLabel.ZIndex = 15
                        cpLabel.Parent = row

                        local cpPrev = Instance.new("TextButton")
                        cpPrev.AnchorPoint = Vector2.new(1, 0.5)
                        cpPrev.Position = UDim2.new(1, -14, 0.5, 0)
                        cpPrev.Size = UDim2.new(0, 31, 0, 20)
                        cpPrev.BackgroundColor3 = cpDef
                        cpPrev.BorderSizePixel = 0
                        cpPrev.Text = ""
                        cpPrev.ZIndex = 15
                        cpPrev.Parent = row
                        CreateCorner(cpPrev, 6)
                        CreateStroke(cpPrev, theme.Stroke, 1)

                        local _cpcolor = cpDef
                        local _cph, _cps, _cpv = RGBToHSV(_cpcolor)

                        local function ClosePicker()
                            if _cpframe then
                                Tween(_cpframe, {Size = UDim2.new(1, -28, 0, 0)}, 0.2)
                                task.delay(0.2, function()
                                    if _cpframe then _cpframe:Destroy(); _cpframe = nil end
                                end)
                            end
                            _cpopen = false
                            row.Size = UDim2.new(1, 0, 0, 31)
                        end

                        local function UpdColor(h, s, v, skip)
                            _cph, _cps, _cpv = h, s, v
                            _cpcolor = HSVToColor3(h, s, v)
                            cpPrev.BackgroundColor3 = _cpcolor
                            if not skip then
                                pcall(cpCb, _cpcolor)
                                if windowConfig.AutoSave then task.delay(0.5, function() lib:_saveConfig() end) end
                            end
                        end

                        cpPrev.MouseButton1Click:Connect(function()
                            if _cpopen then ClosePicker() return end
                            _cpopen = true

                            _cpframe = Instance.new("Frame")
                            _cpframe.Position = UDim2.new(0, 14, 1, 4)
                            _cpframe.Size = UDim2.new(1, -28, 0, 0)
                            _cpframe.BackgroundColor3 = theme.Element
                            _cpframe.BorderSizePixel = 0
                            _cpframe.ClipsDescendants = true
                            _cpframe.ZIndex = 30
                            _cpframe.Parent = row
                            CreateCorner(_cpframe, 8)
                            CreateStroke(_cpframe, theme.Stroke, 1)

                            -- SV area
                            local svArea = Instance.new("ImageLabel")
                            svArea.Position = UDim2.new(0, 8, 0, 8)
                            svArea.Size = UDim2.new(1, -51, 0, 79)
                            svArea.BackgroundColor3 = HSVToColor3(_cph, 1, 1)
                            svArea.BorderSizePixel = 0
                            svArea.ZIndex = 31
                            svArea.Image = "rbxassetid://4155801252"
                            svArea.Parent = _cpframe
                            CreateCorner(svArea, 4)

                            local svOv = Instance.new("ImageLabel")
                            svOv.Size = UDim2.new(1, 0, 1, 0)
                            svOv.BackgroundTransparency = 1
                            svOv.BorderSizePixel = 0
                            svOv.ZIndex = 32
                            svOv.Image = "rbxassetid://4155801252"
                            svOv.ImageColor3 = Color3.new(0, 0, 0)
                            svOv.Rotation = 90
                            svOv.Parent = svArea

                            local svKnob = Instance.new("Frame")
                            svKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                            svKnob.Position = UDim2.new(_cps, 0, 1 - _cpv, 0)
                            svKnob.Size = UDim2.new(0, 10, 0, 10)
                            svKnob.BackgroundColor3 = Color3.new(1, 1, 1)
                            svKnob.BorderSizePixel = 0
                            svKnob.ZIndex = 33
                            svKnob.Parent = svArea
                            CreateCorner(svKnob, 5)
                            CreateStroke(svKnob, Color3.new(0, 0, 0), 1)

                            -- Hue bar
                            local hBar = Instance.new("ImageLabel")
                            hBar.AnchorPoint = Vector2.new(1, 0)
                            hBar.Position = UDim2.new(1, -8, 0, 8)
                            hBar.Size = UDim2.new(0, 14, 0, 79)
                            hBar.BackgroundColor3 = Color3.new(1, 1, 1)
                            hBar.BorderSizePixel = 0
                            hBar.ZIndex = 31
                            hBar.Image = "rbxassetid://4155820455"
                            hBar.Parent = _cpframe
                            CreateCorner(hBar, 4)

                            local hKnob = Instance.new("Frame")
                            hKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                            hKnob.Position = UDim2.new(0.5, 0, _cph, 0)
                            hKnob.Size = UDim2.new(1, 4, 0, 4)
                            hKnob.BackgroundColor3 = Color3.new(1, 1, 1)
                            hKnob.BorderSizePixel = 0
                            hKnob.ZIndex = 32
                            hKnob.Parent = hBar
                            CreateCorner(hKnob, 2)
                            CreateStroke(hKnob, Color3.new(0, 0, 0), 1)

                            local hexL = Instance.new("TextLabel")
                            hexL.Position = UDim2.new(0, 6, 0, 90)
                            hexL.Size = UDim2.new(1, -16, 0, 13)
                            hexL.BackgroundTransparency = 1
                            hexL.Font = Enum.Font.Gotham
                            hexL.TextColor3 = theme.TextSecondary
                            hexL.TextSize = 11
                            hexL.TextXAlignment = Enum.TextXAlignment.Left
                            hexL.ZIndex = 31
                            hexL.Parent = _cpframe

                            local function UpdHex()
                                hexL.Text = string.format("RGB: %d, %d, %d",
                                    math.floor(_cpcolor.R*255),
                                    math.floor(_cpcolor.G*255),
                                    math.floor(_cpcolor.B*255))
                            end
                            UpdHex()

                            local svDrag, hDrag = false, false

                            svArea.InputBegan:Connect(function(i)
                                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                    svDrag = true
                                    local ap = svArea.AbsolutePosition
                                    local as_ = svArea.AbsoluteSize
                                    local s = math.clamp((i.Position.X - ap.X) / as_.X, 0, 1)
                                    local v = 1 - math.clamp((i.Position.Y - ap.Y) / as_.Y, 0, 1)
                                    svKnob.Position = UDim2.new(s, 0, 1-v, 0)
                                    svArea.BackgroundColor3 = HSVToColor3(_cph, 1, 1)
                                    UpdColor(_cph, s, v); UpdHex()
                                end
                            end)

                            hBar.InputBegan:Connect(function(i)
                                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                    hDrag = true
                                    local ap = hBar.AbsolutePosition
                                    local as_ = hBar.AbsoluteSize
                                    local h = math.clamp((i.Position.Y - ap.Y) / as_.Y, 0, 1)
                                    hKnob.Position = UDim2.new(0.5, 0, h, 0)
                                    svArea.BackgroundColor3 = HSVToColor3(h, 1, 1)
                                    UpdColor(h, _cps, _cpv); UpdHex()
                                end
                            end)

                            UserInputService.InputChanged:Connect(function(i)
                                if i.UserInputType == Enum.UserInputType.MouseMovement then
                                    if svDrag then
                                        local ap = svArea.AbsolutePosition
                                        local as_ = svArea.AbsoluteSize
                                        local s = math.clamp((i.Position.X - ap.X) / as_.X, 0, 1)
                                        local v = 1 - math.clamp((i.Position.Y - ap.Y) / as_.Y, 0, 1)
                                        svKnob.Position = UDim2.new(s, 0, 1-v, 0)
                                        svArea.BackgroundColor3 = HSVToColor3(_cph, 1, 1)
                                        UpdColor(_cph, s, v); UpdHex()
                                    end
                                    if hDrag then
                                        local ap = hBar.AbsolutePosition
                                        local as_ = hBar.AbsoluteSize
                                        local h = math.clamp((i.Position.Y - ap.Y) / as_.Y, 0, 1)
                                        hKnob.Position = UDim2.new(0.5, 0, h, 0)
                                        svArea.BackgroundColor3 = HSVToColor3(h, 1, 1)
                                        UpdColor(h, _cps, _cpv); UpdHex()
                                    end
                                end
                            end)

                            UserInputService.InputEnded:Connect(function(i)
                                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                    svDrag = false; hDrag = false
                                end
                            end)

                            local ph = 107
                            Tween(_cpframe, {Size = UDim2.new(1, -28, 0, ph)}, 0.22, Enum.EasingStyle.Back)
                            row.Size = UDim2.new(1, 0, 0, 31 + ph + 6)
                        end)

                        lib:_registerThemeCallback(function(t)
                            Tween(cpLabel, {TextColor3 = t.Text}, 0.3)
                        end)

                        lib:_registerElement(cpId,
                            function()
                                return {R=math.floor(_cpcolor.R*255), G=math.floor(_cpcolor.G*255), B=math.floor(_cpcolor.B*255)}
                            end,
                            function(v)
                                if type(v) == "table" and v.R and v.G and v.B then
                                    local col = Color3.fromRGB(v.R, v.G, v.B)
                                    local h, s, vv = RGBToHSV(col)
                                    UpdColor(h, s, vv, true)
                                end
                            end
                        )

                        local obj = {}
                        function obj:SetValue(col)
                            local h, s, v = RGBToHSV(col)
                            UpdColor(h, s, v)
                        end
                        function obj:GetValue() return _cpcolor end
                        function obj:SetCallback(fn) cpCb = fn end
                        return obj
                    end

                    return Sec
                end

                return T
            end

            -- AddConfig
            function W:AddConfig()
                local ctab = self:AddTab({Name = "⚙ Config"})
                local csec = ctab:AddSection({Name = "Interface Theme"})

                local tNames = {}
                for n, _ in pairs(Themes) do table.insert(tNames, n) end
                table.sort(tNames)

                csec:AddDropdown({
                    Name = "Theme",
                    Options = tNames,
                    Default = lib._currentTheme,
                    Callback = function(v) lib:_applyTheme(v) end,
                })

                local ssec = ctab:AddSection({Name = "Configuration"})

                ssec:AddButton({
                    Name = "💾  Save Config",
                    Description = "Save all current settings to file",
                    Callback = function() lib:_saveConfig() end,
                })
                ssec:AddButton({
                    Name = "📂  Load Config",
                    Description = "Load settings from saved file",
                    Callback = function() lib:_loadConfig() end,
                })
                ssec:AddButton({
                    Name = "🗑  Reset Config",
                    Description = "Delete saved configuration",
                    Callback = function() pcall(delfile, lib._configPath) end,
                })

                return ctab
            end

            FinalWindow = W
            _windowReady = true
            for _, fn in ipairs(_readyCallbacks) do pcall(fn, W) end
            _readyCallbacks = {}

            -- Load config
            if windowConfig.AutoSave then
                task.delay(0.8, function() lib:_loadConfig() end)
                task.spawn(function()
                    while FreshGui and FreshGui.Parent do
                        task.wait(30)
                        lib:_saveConfig()
                    end
                end)
            end

            return W
        end

        DoLoading(function()
            DoKey(function()
                DoMainUI()
            end)
        end)
    end

    RunFullBoot()

    -- Return a proxy that waits for the window to be ready
    local ProxyWindow = {}
    setmetatable(ProxyWindow, {
        __index = function(_, k)
            if _windowReady and FinalWindow then
                return FinalWindow[k]
            end
            -- Queue or warn
            return function(...)
                if _windowReady and FinalWindow then
                    local fn = FinalWindow[k]
                    if fn then return fn(FinalWindow, ...) end
                end
                warn("NexusLib: Window not ready. Use :OnReady() or wait briefly.")
            end
        end
    })

    function ProxyWindow:OnReady(fn)
        if _windowReady and FinalWindow then
            fn(FinalWindow)
        else
            table.insert(_readyCallbacks, fn)
        end
    end

    return ProxyWindow
end

-- ============================================================
-- LIBRARY METADATA
-- ============================================================
NexusLib.Version = "2.0.0"
NexusLib.Author = "NexusLib"
NexusLib.Themes = Themes

return NexusLib
