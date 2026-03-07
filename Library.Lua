--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║              SUPERNOVA UI LIBRARY v3.0                       ║
    ║              Desenvolvedor Sênior Luau                       ║
    ║              Compatível: Mobile + PC                         ║
    ║              Livre de Bugs | OOP | Modular                   ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════════════════════
-- UTILITY MODULE
-- ═══════════════════════════════════════════════════════════════
local Utility = {}

function Utility:Create(className, properties, children)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            pcall(function()
                instance[prop] = value
            end)
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utility:Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:TweenWait(instance, properties, duration, style, direction)
    local tween = self:Tween(instance, properties, duration, style, direction)
    tween.Completed:Wait()
    return tween
end

function Utility:Ripple(button, x, y)
    local ripple = Utility:Create("Frame", {
        Parent = button,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = button.ZIndex + 5,
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    Utility:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

function Utility:DeepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = Utility:DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function Utility:RoundNumber(number, decimalPlaces)
    local mult = 10 ^ (decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
end

function Utility:ColorToTable(color)
    return {R = color.R, G = color.G, B = color.B}
end

function Utility:TableToColor(tbl)
    return Color3.new(tbl.R or 0, tbl.G or 0, tbl.B or 0)
end

function Utility:AddPadding(parent, padding)
    return Utility:Create("UIPadding", {
        Parent = parent,
        PaddingTop = UDim.new(0, padding or 6),
        PaddingBottom = UDim.new(0, padding or 6),
        PaddingLeft = UDim.new(0, padding or 6),
        PaddingRight = UDim.new(0, padding or 6),
    })
end

function Utility:MakeDraggable(topbar, frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            Utility:Tween(frame, {Position = newPos}, 0.08)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- THEME SYSTEM
-- ═══════════════════════════════════════════════════════════════
local ThemeManager = {}
ThemeManager.__index = ThemeManager

ThemeManager.Themes = {
    ["Midnight"] = {
        Background = Color3.fromRGB(15, 15, 25),
        TopBar = Color3.fromRGB(20, 20, 35),
        Section = Color3.fromRGB(22, 22, 38),
        Element = Color3.fromRGB(28, 28, 48),
        ElementHover = Color3.fromRGB(35, 35, 58),
        Accent = Color3.fromRGB(100, 80, 255),
        AccentDark = Color3.fromRGB(75, 55, 200),
        Text = Color3.fromRGB(235, 235, 245),
        TextDark = Color3.fromRGB(160, 160, 180),
        Divider = Color3.fromRGB(40, 40, 65),
        Toggle = Color3.fromRGB(45, 45, 70),
        ToggleEnabled = Color3.fromRGB(100, 80, 255),
        SliderBar = Color3.fromRGB(40, 40, 65),
        SliderFill = Color3.fromRGB(100, 80, 255),
        Input = Color3.fromRGB(25, 25, 42),
        InputFocused = Color3.fromRGB(32, 32, 55),
        DropdownBG = Color3.fromRGB(20, 20, 35),
        DropdownOption = Color3.fromRGB(28, 28, 48),
        DropdownHover = Color3.fromRGB(38, 38, 62),
        Shadow = Color3.fromRGB(5, 5, 10),
        TabActive = Color3.fromRGB(100, 80, 255),
        TabInactive = Color3.fromRGB(28, 28, 48),
        Notification = Color3.fromRGB(22, 22, 38),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 180, 50),
    },
    ["Ocean"] = {
        Background = Color3.fromRGB(12, 20, 30),
        TopBar = Color3.fromRGB(15, 25, 40),
        Section = Color3.fromRGB(18, 28, 42),
        Element = Color3.fromRGB(22, 35, 52),
        ElementHover = Color3.fromRGB(28, 42, 62),
        Accent = Color3.fromRGB(0, 150, 255),
        AccentDark = Color3.fromRGB(0, 120, 210),
        Text = Color3.fromRGB(230, 240, 250),
        TextDark = Color3.fromRGB(140, 170, 200),
        Divider = Color3.fromRGB(30, 50, 72),
        Toggle = Color3.fromRGB(25, 40, 58),
        ToggleEnabled = Color3.fromRGB(0, 150, 255),
        SliderBar = Color3.fromRGB(25, 40, 58),
        SliderFill = Color3.fromRGB(0, 150, 255),
        Input = Color3.fromRGB(18, 30, 45),
        InputFocused = Color3.fromRGB(22, 38, 55),
        DropdownBG = Color3.fromRGB(15, 25, 40),
        DropdownOption = Color3.fromRGB(22, 35, 52),
        DropdownHover = Color3.fromRGB(30, 45, 65),
        Shadow = Color3.fromRGB(5, 10, 18),
        TabActive = Color3.fromRGB(0, 150, 255),
        TabInactive = Color3.fromRGB(22, 35, 52),
        Notification = Color3.fromRGB(18, 28, 42),
        Success = Color3.fromRGB(0, 200, 150),
        Error = Color3.fromRGB(255, 70, 70),
        Warning = Color3.fromRGB(255, 170, 40),
    },
    ["Emerald"] = {
        Background = Color3.fromRGB(12, 22, 18),
        TopBar = Color3.fromRGB(15, 28, 22),
        Section = Color3.fromRGB(18, 32, 26),
        Element = Color3.fromRGB(22, 40, 32),
        ElementHover = Color3.fromRGB(28, 50, 40),
        Accent = Color3.fromRGB(0, 210, 130),
        AccentDark = Color3.fromRGB(0, 175, 105),
        Text = Color3.fromRGB(230, 248, 240),
        TextDark = Color3.fromRGB(140, 190, 170),
        Divider = Color3.fromRGB(30, 55, 42),
        Toggle = Color3.fromRGB(25, 42, 35),
        ToggleEnabled = Color3.fromRGB(0, 210, 130),
        SliderBar = Color3.fromRGB(25, 42, 35),
        SliderFill = Color3.fromRGB(0, 210, 130),
        Input = Color3.fromRGB(15, 28, 22),
        InputFocused = Color3.fromRGB(20, 38, 30),
        DropdownBG = Color3.fromRGB(15, 28, 22),
        DropdownOption = Color3.fromRGB(22, 40, 32),
        DropdownHover = Color3.fromRGB(30, 52, 42),
        Shadow = Color3.fromRGB(5, 12, 8),
        TabActive = Color3.fromRGB(0, 210, 130),
        TabInactive = Color3.fromRGB(22, 40, 32),
        Notification = Color3.fromRGB(18, 32, 26),
        Success = Color3.fromRGB(0, 230, 150),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 200, 50),
    },
    ["Rose"] = {
        Background = Color3.fromRGB(25, 12, 18),
        TopBar = Color3.fromRGB(32, 15, 22),
        Section = Color3.fromRGB(36, 18, 26),
        Element = Color3.fromRGB(45, 22, 32),
        ElementHover = Color3.fromRGB(55, 28, 40),
        Accent = Color3.fromRGB(255, 70, 130),
        AccentDark = Color3.fromRGB(210, 50, 105),
        Text = Color3.fromRGB(250, 230, 240),
        TextDark = Color3.fromRGB(200, 150, 175),
        Divider = Color3.fromRGB(60, 30, 42),
        Toggle = Color3.fromRGB(48, 25, 35),
        ToggleEnabled = Color3.fromRGB(255, 70, 130),
        SliderBar = Color3.fromRGB(48, 25, 35),
        SliderFill = Color3.fromRGB(255, 70, 130),
        Input = Color3.fromRGB(30, 15, 22),
        InputFocused = Color3.fromRGB(40, 20, 28),
        DropdownBG = Color3.fromRGB(32, 15, 22),
        DropdownOption = Color3.fromRGB(45, 22, 32),
        DropdownHover = Color3.fromRGB(58, 30, 42),
        Shadow = Color3.fromRGB(12, 5, 8),
        TabActive = Color3.fromRGB(255, 70, 130),
        TabInactive = Color3.fromRGB(45, 22, 32),
        Notification = Color3.fromRGB(36, 18, 26),
        Success = Color3.fromRGB(100, 220, 130),
        Error = Color3.fromRGB(255, 60, 60),
        Warning = Color3.fromRGB(255, 180, 60),
    },
    ["Sunset"] = {
        Background = Color3.fromRGB(28, 15, 12),
        TopBar = Color3.fromRGB(35, 18, 15),
        Section = Color3.fromRGB(40, 22, 18),
        Element = Color3.fromRGB(50, 28, 22),
        ElementHover = Color3.fromRGB(62, 35, 28),
        Accent = Color3.fromRGB(255, 120, 50),
        AccentDark = Color3.fromRGB(220, 95, 35),
        Text = Color3.fromRGB(255, 240, 230),
        TextDark = Color3.fromRGB(200, 165, 145),
        Divider = Color3.fromRGB(65, 38, 28),
        Toggle = Color3.fromRGB(52, 30, 25),
        ToggleEnabled = Color3.fromRGB(255, 120, 50),
        SliderBar = Color3.fromRGB(52, 30, 25),
        SliderFill = Color3.fromRGB(255, 120, 50),
        Input = Color3.fromRGB(32, 18, 15),
        InputFocused = Color3.fromRGB(42, 25, 20),
        DropdownBG = Color3.fromRGB(35, 18, 15),
        DropdownOption = Color3.fromRGB(50, 28, 22),
        DropdownHover = Color3.fromRGB(65, 38, 30),
        Shadow = Color3.fromRGB(15, 8, 5),
        TabActive = Color3.fromRGB(255, 120, 50),
        TabInactive = Color3.fromRGB(50, 28, 22),
        Notification = Color3.fromRGB(40, 22, 18),
        Success = Color3.fromRGB(80, 220, 120),
        Error = Color3.fromRGB(255, 60, 60),
        Warning = Color3.fromRGB(255, 200, 50),
    },
    ["Lavender"] = {
        Background = Color3.fromRGB(20, 15, 28),
        TopBar = Color3.fromRGB(25, 18, 35),
        Section = Color3.fromRGB(28, 22, 40),
        Element = Color3.fromRGB(35, 28, 50),
        ElementHover = Color3.fromRGB(42, 35, 62),
        Accent = Color3.fromRGB(180, 120, 255),
        AccentDark = Color3.fromRGB(150, 95, 220),
        Text = Color3.fromRGB(240, 235, 250),
        TextDark = Color3.fromRGB(175, 160, 200),
        Divider = Color3.fromRGB(48, 38, 68),
        Toggle = Color3.fromRGB(38, 30, 55),
        ToggleEnabled = Color3.fromRGB(180, 120, 255),
        SliderBar = Color3.fromRGB(38, 30, 55),
        SliderFill = Color3.fromRGB(180, 120, 255),
        Input = Color3.fromRGB(22, 18, 32),
        InputFocused = Color3.fromRGB(30, 25, 42),
        DropdownBG = Color3.fromRGB(25, 18, 35),
        DropdownOption = Color3.fromRGB(35, 28, 50),
        DropdownHover = Color3.fromRGB(45, 38, 65),
        Shadow = Color3.fromRGB(10, 8, 15),
        TabActive = Color3.fromRGB(180, 120, 255),
        TabInactive = Color3.fromRGB(35, 28, 50),
        Notification = Color3.fromRGB(28, 22, 40),
        Success = Color3.fromRGB(100, 220, 140),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 180, 60),
    },
    ["Cyberpunk"] = {
        Background = Color3.fromRGB(10, 10, 15),
        TopBar = Color3.fromRGB(15, 12, 22),
        Section = Color3.fromRGB(18, 15, 28),
        Element = Color3.fromRGB(22, 18, 35),
        ElementHover = Color3.fromRGB(30, 25, 45),
        Accent = Color3.fromRGB(255, 0, 200),
        AccentDark = Color3.fromRGB(200, 0, 160),
        Text = Color3.fromRGB(0, 255, 255),
        TextDark = Color3.fromRGB(0, 180, 180),
        Divider = Color3.fromRGB(35, 28, 52),
        Toggle = Color3.fromRGB(25, 20, 38),
        ToggleEnabled = Color3.fromRGB(255, 0, 200),
        SliderBar = Color3.fromRGB(25, 20, 38),
        SliderFill = Color3.fromRGB(255, 0, 200),
        Input = Color3.fromRGB(12, 10, 20),
        InputFocused = Color3.fromRGB(18, 15, 28),
        DropdownBG = Color3.fromRGB(15, 12, 22),
        DropdownOption = Color3.fromRGB(22, 18, 35),
        DropdownHover = Color3.fromRGB(32, 28, 48),
        Shadow = Color3.fromRGB(5, 5, 8),
        TabActive = Color3.fromRGB(255, 0, 200),
        TabInactive = Color3.fromRGB(22, 18, 35),
        Notification = Color3.fromRGB(18, 15, 28),
        Success = Color3.fromRGB(0, 255, 150),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 0),
    },
    ["Frost"] = {
        Background = Color3.fromRGB(18, 22, 30),
        TopBar = Color3.fromRGB(22, 28, 38),
        Section = Color3.fromRGB(25, 32, 42),
        Element = Color3.fromRGB(30, 40, 55),
        ElementHover = Color3.fromRGB(38, 48, 65),
        Accent = Color3.fromRGB(100, 200, 255),
        AccentDark = Color3.fromRGB(70, 170, 230),
        Text = Color3.fromRGB(230, 242, 255),
        TextDark = Color3.fromRGB(150, 180, 210),
        Divider = Color3.fromRGB(40, 55, 72),
        Toggle = Color3.fromRGB(32, 42, 58),
        ToggleEnabled = Color3.fromRGB(100, 200, 255),
        SliderBar = Color3.fromRGB(32, 42, 58),
        SliderFill = Color3.fromRGB(100, 200, 255),
        Input = Color3.fromRGB(20, 26, 35),
        InputFocused = Color3.fromRGB(28, 35, 48),
        DropdownBG = Color3.fromRGB(22, 28, 38),
        DropdownOption = Color3.fromRGB(30, 40, 55),
        DropdownHover = Color3.fromRGB(40, 52, 70),
        Shadow = Color3.fromRGB(8, 12, 18),
        TabActive = Color3.fromRGB(100, 200, 255),
        TabInactive = Color3.fromRGB(30, 40, 55),
        Notification = Color3.fromRGB(25, 32, 42),
        Success = Color3.fromRGB(80, 230, 160),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 190, 50),
    },
    ["Blood"] = {
        Background = Color3.fromRGB(18, 8, 8),
        TopBar = Color3.fromRGB(25, 10, 10),
        Section = Color3.fromRGB(30, 12, 12),
        Element = Color3.fromRGB(38, 15, 15),
        ElementHover = Color3.fromRGB(48, 20, 20),
        Accent = Color3.fromRGB(220, 20, 20),
        AccentDark = Color3.fromRGB(180, 15, 15),
        Text = Color3.fromRGB(255, 230, 230),
        TextDark = Color3.fromRGB(200, 150, 150),
        Divider = Color3.fromRGB(55, 22, 22),
        Toggle = Color3.fromRGB(42, 18, 18),
        ToggleEnabled = Color3.fromRGB(220, 20, 20),
        SliderBar = Color3.fromRGB(42, 18, 18),
        SliderFill = Color3.fromRGB(220, 20, 20),
        Input = Color3.fromRGB(22, 10, 10),
        InputFocused = Color3.fromRGB(32, 15, 15),
        DropdownBG = Color3.fromRGB(25, 10, 10),
        DropdownOption = Color3.fromRGB(38, 15, 15),
        DropdownHover = Color3.fromRGB(52, 22, 22),
        Shadow = Color3.fromRGB(10, 4, 4),
        TabActive = Color3.fromRGB(220, 20, 20),
        TabInactive = Color3.fromRGB(38, 15, 15),
        Notification = Color3.fromRGB(30, 12, 12),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 180, 50),
    },
    ["Gold"] = {
        Background = Color3.fromRGB(20, 18, 10),
        TopBar = Color3.fromRGB(28, 24, 12),
        Section = Color3.fromRGB(32, 28, 15),
        Element = Color3.fromRGB(40, 35, 18),
        ElementHover = Color3.fromRGB(50, 44, 22),
        Accent = Color3.fromRGB(255, 200, 50),
        AccentDark = Color3.fromRGB(220, 170, 35),
        Text = Color3.fromRGB(255, 248, 230),
        TextDark = Color3.fromRGB(200, 185, 140),
        Divider = Color3.fromRGB(58, 50, 25),
        Toggle = Color3.fromRGB(45, 38, 20),
        ToggleEnabled = Color3.fromRGB(255, 200, 50),
        SliderBar = Color3.fromRGB(45, 38, 20),
        SliderFill = Color3.fromRGB(255, 200, 50),
        Input = Color3.fromRGB(25, 22, 12),
        InputFocused = Color3.fromRGB(35, 30, 18),
        DropdownBG = Color3.fromRGB(28, 24, 12),
        DropdownOption = Color3.fromRGB(40, 35, 18),
        DropdownHover = Color3.fromRGB(52, 45, 25),
        Shadow = Color3.fromRGB(12, 10, 5),
        TabActive = Color3.fromRGB(255, 200, 50),
        TabInactive = Color3.fromRGB(40, 35, 18),
        Notification = Color3.fromRGB(32, 28, 15),
        Success = Color3.fromRGB(80, 220, 120),
        Error = Color3.fromRGB(255, 70, 70),
        Warning = Color3.fromRGB(255, 220, 80),
    },
    ["Aqua"] = {
        Background = Color3.fromRGB(8, 20, 22),
        TopBar = Color3.fromRGB(10, 28, 30),
        Section = Color3.fromRGB(12, 32, 35),
        Element = Color3.fromRGB(15, 40, 45),
        ElementHover = Color3.fromRGB(20, 50, 55),
        Accent = Color3.fromRGB(0, 230, 210),
        AccentDark = Color3.fromRGB(0, 190, 175),
        Text = Color3.fromRGB(220, 255, 250),
        TextDark = Color3.fromRGB(130, 200, 190),
        Divider = Color3.fromRGB(22, 55, 60),
        Toggle = Color3.fromRGB(18, 45, 50),
        ToggleEnabled = Color3.fromRGB(0, 230, 210),
        SliderBar = Color3.fromRGB(18, 45, 50),
        SliderFill = Color3.fromRGB(0, 230, 210),
        Input = Color3.fromRGB(10, 25, 28),
        InputFocused = Color3.fromRGB(15, 35, 38),
        DropdownBG = Color3.fromRGB(10, 28, 30),
        DropdownOption = Color3.fromRGB(15, 40, 45),
        DropdownHover = Color3.fromRGB(22, 52, 58),
        Shadow = Color3.fromRGB(4, 10, 12),
        TabActive = Color3.fromRGB(0, 230, 210),
        TabInactive = Color3.fromRGB(15, 40, 45),
        Notification = Color3.fromRGB(12, 32, 35),
        Success = Color3.fromRGB(0, 255, 180),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 200, 50),
    },
    ["Slate"] = {
        Background = Color3.fromRGB(22, 22, 28),
        TopBar = Color3.fromRGB(28, 28, 36),
        Section = Color3.fromRGB(32, 32, 40),
        Element = Color3.fromRGB(40, 40, 50),
        ElementHover = Color3.fromRGB(50, 50, 62),
        Accent = Color3.fromRGB(150, 160, 180),
        AccentDark = Color3.fromRGB(120, 130, 150),
        Text = Color3.fromRGB(235, 238, 245),
        TextDark = Color3.fromRGB(160, 165, 180),
        Divider = Color3.fromRGB(52, 52, 65),
        Toggle = Color3.fromRGB(42, 42, 55),
        ToggleEnabled = Color3.fromRGB(150, 160, 180),
        SliderBar = Color3.fromRGB(42, 42, 55),
        SliderFill = Color3.fromRGB(150, 160, 180),
        Input = Color3.fromRGB(25, 25, 32),
        InputFocused = Color3.fromRGB(35, 35, 45),
        DropdownBG = Color3.fromRGB(28, 28, 36),
        DropdownOption = Color3.fromRGB(40, 40, 50),
        DropdownHover = Color3.fromRGB(52, 52, 65),
        Shadow = Color3.fromRGB(10, 10, 15),
        TabActive = Color3.fromRGB(150, 160, 180),
        TabInactive = Color3.fromRGB(40, 40, 50),
        Notification = Color3.fromRGB(32, 32, 40),
        Success = Color3.fromRGB(80, 200, 140),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 190, 50),
    },
    ["Neon"] = {
        Background = Color3.fromRGB(5, 5, 12),
        TopBar = Color3.fromRGB(8, 8, 18),
        Section = Color3.fromRGB(10, 10, 22),
        Element = Color3.fromRGB(15, 15, 30),
        ElementHover = Color3.fromRGB(20, 20, 40),
        Accent = Color3.fromRGB(0, 255, 100),
        AccentDark = Color3.fromRGB(0, 200, 80),
        Text = Color3.fromRGB(220, 255, 235),
        TextDark = Color3.fromRGB(100, 200, 150),
        Divider = Color3.fromRGB(20, 20, 42),
        Toggle = Color3.fromRGB(15, 15, 35),
        ToggleEnabled = Color3.fromRGB(0, 255, 100),
        SliderBar = Color3.fromRGB(15, 15, 35),
        SliderFill = Color3.fromRGB(0, 255, 100),
        Input = Color3.fromRGB(8, 8, 18),
        InputFocused = Color3.fromRGB(12, 12, 25),
        DropdownBG = Color3.fromRGB(8, 8, 18),
        DropdownOption = Color3.fromRGB(15, 15, 30),
        DropdownHover = Color3.fromRGB(22, 22, 45),
        Shadow = Color3.fromRGB(2, 2, 5),
        TabActive = Color3.fromRGB(0, 255, 100),
        TabInactive = Color3.fromRGB(15, 15, 30),
        Notification = Color3.fromRGB(10, 10, 22),
        Success = Color3.fromRGB(0, 255, 150),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 255, 0),
    },
    ["Cherry"] = {
        Background = Color3.fromRGB(22, 10, 15),
        TopBar = Color3.fromRGB(30, 12, 20),
        Section = Color3.fromRGB(35, 15, 24),
        Element = Color3.fromRGB(44, 18, 30),
        ElementHover = Color3.fromRGB(55, 25, 38),
        Accent = Color3.fromRGB(255, 50, 80),
        AccentDark = Color3.fromRGB(210, 35, 65),
        Text = Color3.fromRGB(255, 235, 240),
        TextDark = Color3.fromRGB(200, 155, 170),
        Divider = Color3.fromRGB(60, 28, 38),
        Toggle = Color3.fromRGB(48, 22, 32),
        ToggleEnabled = Color3.fromRGB(255, 50, 80),
        SliderBar = Color3.fromRGB(48, 22, 32),
        SliderFill = Color3.fromRGB(255, 50, 80),
        Input = Color3.fromRGB(28, 12, 18),
        InputFocused = Color3.fromRGB(38, 18, 25),
        DropdownBG = Color3.fromRGB(30, 12, 20),
        DropdownOption = Color3.fromRGB(44, 18, 30),
        DropdownHover = Color3.fromRGB(58, 28, 40),
        Shadow = Color3.fromRGB(12, 5, 8),
        TabActive = Color3.fromRGB(255, 50, 80),
        TabInactive = Color3.fromRGB(44, 18, 30),
        Notification = Color3.fromRGB(35, 15, 24),
        Success = Color3.fromRGB(80, 220, 130),
        Error = Color3.fromRGB(255, 60, 60),
        Warning = Color3.fromRGB(255, 180, 60),
    },
    ["Phantom"] = {
        Background = Color3.fromRGB(8, 8, 8),
        TopBar = Color3.fromRGB(12, 12, 12),
        Section = Color3.fromRGB(15, 15, 15),
        Element = Color3.fromRGB(20, 20, 20),
        ElementHover = Color3.fromRGB(28, 28, 28),
        Accent = Color3.fromRGB(200, 200, 200),
        AccentDark = Color3.fromRGB(160, 160, 160),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(140, 140, 140),
        Divider = Color3.fromRGB(35, 35, 35),
        Toggle = Color3.fromRGB(25, 25, 25),
        ToggleEnabled = Color3.fromRGB(200, 200, 200),
        SliderBar = Color3.fromRGB(25, 25, 25),
        SliderFill = Color3.fromRGB(200, 200, 200),
        Input = Color3.fromRGB(12, 12, 12),
        InputFocused = Color3.fromRGB(18, 18, 18),
        DropdownBG = Color3.fromRGB(12, 12, 12),
        DropdownOption = Color3.fromRGB(20, 20, 20),
        DropdownHover = Color3.fromRGB(30, 30, 30),
        Shadow = Color3.fromRGB(2, 2, 2),
        TabActive = Color3.fromRGB(200, 200, 200),
        TabInactive = Color3.fromRGB(20, 20, 20),
        Notification = Color3.fromRGB(15, 15, 15),
        Success = Color3.fromRGB(100, 220, 130),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 200, 60),
    },
}

function ThemeManager:GetTheme(name)
    return self.Themes[name] or self.Themes["Midnight"]
end

function ThemeManager:GetThemeNames()
    local names = {}
    for name, _ in pairs(self.Themes) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

-- ═══════════════════════════════════════════════════════════════
-- FILE SYSTEM HELPER
-- ═══════════════════════════════════════════════════════════════
local FileSystem = {}

function FileSystem:EnsureFolder(path)
    local success, err = pcall(function()
        if not isfolder(path) then
            makefolder(path)
        end
    end)
    return success
end

function FileSystem:WriteFile(path, content)
    local success, err = pcall(function()
        writefile(path, content)
    end)
    return success
end

function FileSystem:ReadFile(path)
    local success, content = pcall(function()
        return readfile(path)
    end)
    if success then
        return content
    end
    return nil
end

function FileSystem:FileExists(path)
    local success, result = pcall(function()
        return isfile(path)
    end)
    return success and result
end

function FileSystem:DeleteFile(path)
    local success = pcall(function()
        delfile(path)
    end)
    return success
end

-- ═══════════════════════════════════════════════════════════════
-- SAVE SYSTEM
-- ═══════════════════════════════════════════════════════════════
local SaveSystem = {}
SaveSystem.__index = SaveSystem

function SaveSystem.new(folderName, fileName)
    local self = setmetatable({}, SaveSystem)
    self.FolderPath = folderName or "SupernovaUI"
    self.FileName = fileName or "config"
    self.FilePath = self.FolderPath .. "/" .. self.FileName .. ".json"
    self.Data = {}
    self.Elements = {}
    self.AutoSaveEnabled = false
    self._autoSaveConnection = nil
    FileSystem:EnsureFolder(self.FolderPath)
    return self
end

function SaveSystem:Register(flag, elementType, defaultValue)
    self.Elements[flag] = {
        Type = elementType,
        Default = defaultValue,
    }
end

function SaveSystem:SetValue(flag, value)
    if elementType == "Color" and typeof(value) == "Color3" then
        self.Data[flag] = Utility:ColorToTable(value)
    else
        self.Data[flag] = value
    end
end

function SaveSystem:GetValue(flag)
    return self.Data[flag]
end

function SaveSystem:Save()
    local saveData = {}
    for flag, info in pairs(self.Elements) do
        local value = self.Data[flag]
        if value ~= nil then
            if info.Type == "Color" and typeof(value) == "Color3" then
                saveData[flag] = {
                    Type = "Color",
                    Value = Utility:ColorToTable(value)
                }
            else
                saveData[flag] = {
                    Type = info.Type,
                    Value = value
                }
            end
        end
    end
    
    local jsonStr = HttpService:JSONEncode(saveData)
    return FileSystem:WriteFile(self.FilePath, jsonStr)
end

function SaveSystem:Load()
    if not FileSystem:FileExists(self.FilePath) then
        return false
    end
    
    local content = FileSystem:ReadFile(self.FilePath)
    if not content then return false end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    
    if not success or type(data) ~= "table" then
        return false
    end
    
    for flag, info in pairs(data) do
        if self.Elements[flag] then
            if info.Type == "Color" and type(info.Value) == "table" then
                self.Data[flag] = info.Value
            else
                self.Data[flag] = info.Value
            end
        end
    end
    
    return true
end

function SaveSystem:StartAutoSave(interval)
    if self._autoSaveConnection then return end
    self.AutoSaveEnabled = true
    
    task.spawn(function()
        while self.AutoSaveEnabled do
            task.wait(interval or 10)
            if self.AutoSaveEnabled then
                self:Save()
            end
        end
    end)
end

function SaveSystem:StopAutoSave()
    self.AutoSaveEnabled = false
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN LIBRARY
-- ═══════════════════════════════════════════════════════════════
local SupernovaUI = {}
SupernovaUI.__index = SupernovaUI
SupernovaUI.Version = "3.0.0"
SupernovaUI.Windows = {}

-- ═══════════════════════════════════════════════════════════════
-- ICONS (Simple Unicode/Text based for compatibility)
-- ═══════════════════════════════════════════════════════════════
local Icons = {
    Close = "✕",
    Minimize = "—",
    Resize = "⤡",
    Dropdown = "▼",
    DropdownUp = "▲",
    Check = "✓",
    Search = "🔍",
    Key = "🔑",
    Settings = "⚙",
    Loading = "◌",
    Arrow = "›",
    Dot = "●",
    Circle = "○",
}

-- ═══════════════════════════════════════════════════════════════
-- LOADING SCREEN CLASS
-- ═══════════════════════════════════════════════════════════════
local LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

function LoadingScreen.new(screenGui, options)
    local self = setmetatable({}, LoadingScreen)
    self.ScreenGui = screenGui
    self.Options = options or {}
    self.LoadingName = options.LoadingName or "Hello, Welcome Back!!"
    self.LoadingIcon = options.LoadingIcon or ""
    self.Duration = options.LoadingDuration or 3
    self.Theme = options.Theme or ThemeManager:GetTheme("Midnight")
    return self
end

function LoadingScreen:Show()
    local theme = self.Theme
    
    -- Main loading frame
    self.Frame = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "LoadingScreen",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ZIndex = 100,
    })
    
    -- Center container
    local centerFrame = Utility:Create("Frame", {
        Parent = self.Frame,
        Name = "Center",
        Size = UDim2.new(0, 320, 0, 280),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Section,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 101,
    })
    
    Utility:Create("UICorner", {
        Parent = centerFrame,
        CornerRadius = UDim.new(0, 16),
    })
    
    -- Loading Icon
    if self.LoadingIcon ~= "" then
        local iconFrame = Utility:Create("ImageLabel", {
            Parent = centerFrame,
            Name = "Icon",
            Size = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, 0, 0, 30),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://" .. tostring(self.LoadingIcon),
            ImageTransparency = 1,
            ZIndex = 102,
        })
        
        Utility:Create("UICorner", {
            Parent = iconFrame,
            CornerRadius = UDim.new(0.5, 0),
        })
        
        Utility:Tween(iconFrame, {ImageTransparency = 0}, 0.5)
    end
    
    -- Loading Text
    local loadingText = Utility:Create("TextLabel", {
        Parent = centerFrame,
        Name = "LoadingText",
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0.5, 0, 0, self.LoadingIcon ~= "" and 125 or 60),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = self.LoadingName,
        TextColor3 = theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        ZIndex = 102,
    })
    
    Utility:Tween(loadingText, {TextTransparency = 0}, 0.5)
    
    -- Loading bar background
    local barBg = Utility:Create("Frame", {
        Parent = centerFrame,
        Name = "BarBg",
        Size = UDim2.new(0.75, 0, 0, 6),
        Position = UDim2.new(0.5, 0, 0, self.LoadingIcon ~= "" and 175 or 110),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = theme.SliderBar,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 102,
    })
    
    Utility:Create("UICorner", {
        Parent = barBg,
        CornerRadius = UDim.new(1, 0),
    })
    
    Utility:Tween(barBg, {BackgroundTransparency = 0}, 0.3)
    
    -- Loading bar fill
    local barFill = Utility:Create("Frame", {
        Parent = barBg,
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 103,
    })
    
    Utility:Create("UICorner", {
        Parent = barFill,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Percentage text
    local percentText = Utility:Create("TextLabel", {
        Parent = centerFrame,
        Name = "Percent",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0, self.LoadingIcon ~= "" and 190 or 125),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "0%",
        TextColor3 = theme.TextDark,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextTransparency = 1,
        ZIndex = 102,
    })
    
    Utility:Tween(percentText, {TextTransparency = 0}, 0.3)
    
    -- Status text
    local statusText = Utility:Create("TextLabel", {
        Parent = centerFrame,
        Name = "Status",
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0.5, 0, 0, self.LoadingIcon ~= "" and 218 or 153),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "Initializing...",
        TextColor3 = theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextTransparency = 1,
        ZIndex = 102,
    })
    
    Utility:Tween(statusText, {TextTransparency = 0}, 0.3)
    
    -- Animate loading
    local loadSteps = {
        {0.15, "Loading modules..."},
        {0.30, "Preparing interface..."},
        {0.50, "Loading elements..."},
        {0.70, "Applying theme..."},
        {0.85, "Finalizing..."},
        {1.00, "Ready!"},
    }
    
    local stepDuration = self.Duration / #loadSteps
    
    task.spawn(function()
        for i, step in ipairs(loadSteps) do
            local targetSize = step[1]
            local status = step[2]
            
            statusText.Text = status
            Utility:Tween(barFill, {Size = UDim2.new(targetSize, 0, 1, 0)}, stepDuration * 0.8)
            
            -- Animate percentage
            local startPercent = i > 1 and math.floor(loadSteps[i-1][1] * 100) or 0
            local endPercent = math.floor(targetSize * 100)
            
            task.spawn(function()
                for p = startPercent, endPercent do
                    percentText.Text = p .. "%"
                    task.wait(stepDuration * 0.8 / (endPercent - startPercent + 1))
                end
            end)
            
            task.wait(stepDuration)
        end
        
        task.wait(0.3)
    end)
end

function LoadingScreen:Hide(callback)
    if self.Frame then
        Utility:TweenWait(self.Frame, {BackgroundTransparency = 1}, 0.5)
        
        for _, child in pairs(self.Frame:GetDescendants()) do
            pcall(function()
                if child:IsA("TextLabel") then
                    Utility:Tween(child, {TextTransparency = 1}, 0.3)
                elseif child:IsA("ImageLabel") then
                    Utility:Tween(child, {ImageTransparency = 1}, 0.3)
                elseif child:IsA("Frame") then
                    Utility:Tween(child, {BackgroundTransparency = 1}, 0.3)
                end
            end)
        end
        
        task.wait(0.5)
        self.Frame:Destroy()
    end
    
    if callback then callback() end
end

-- ═══════════════════════════════════════════════════════════════
-- KEY SYSTEM CLASS
-- ═══════════════════════════════════════════════════════════════
local KeySystem = {}
KeySystem.__index = KeySystem

function KeySystem.new(screenGui, options)
    local self = setmetatable({}, KeySystem)
    self.ScreenGui = screenGui
    self.Options = options or {}
    self.KeyName = options.KeyName or "Key System"
    self.Key = options.Key or "default"
    self.KeySave = options.KeySave or false
    self.KeyJsonName = options.KeyJsonName or "key_data"
    self.GetKeyFromSite = options.GetKeyFromSite or false
    self.Sitekey = options.Sitekey or ""
    self.FolderPath = options.FolderPath or "SupernovaUI"
    self.Theme = options.Theme or ThemeManager:GetTheme("Midnight")
    self.Validated = false
    return self
end

function KeySystem:CheckSavedKey()
    if not self.KeySave then return false end
    
    FileSystem:EnsureFolder(self.FolderPath)
    local filePath = self.FolderPath .. "/" .. self.KeyJsonName .. ".json"
    
    if FileSystem:FileExists(filePath) then
        local content = FileSystem:ReadFile(filePath)
        if content then
            local success, data = pcall(function()
                return HttpService:JSONDecode(content)
            end)
            if success and data and data.key == self.Key then
                self.Validated = true
                return true
            end
        end
    end
    return false
end

function KeySystem:SaveKey(key)
    if not self.KeySave then return end
    FileSystem:EnsureFolder(self.FolderPath)
    local filePath = self.FolderPath .. "/" .. self.KeyJsonName .. ".json"
    local data = HttpService:JSONEncode({key = key, timestamp = os.time()})
    FileSystem:WriteFile(filePath, data)
end

function KeySystem:Show(onValidated, onCancelled)
    -- Check saved key first
    if self:CheckSavedKey() then
        if onValidated then onValidated() end
        return
    end
    
    local theme = self.Theme
    
    -- Overlay
    self.Overlay = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "KeySystemOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 200,
    })
    
    -- Key frame
    self.Frame = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "KeySystem",
        Size = UDim2.new(0, 340, 0, 320),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ZIndex = 201,
        BackgroundTransparency = 1,
    })
    
    Utility:Create("UICorner", {
        Parent = self.Frame,
        CornerRadius = UDim.new(0, 12),
    })
    
    Utility:Create("UIStroke", {
        Parent = self.Frame,
        Color = theme.Divider,
        Thickness = 1,
        Transparency = 1,
    })
    
    -- Animate in
    Utility:Tween(self.Frame, {BackgroundTransparency = 0}, 0.3)
    Utility:Tween(self.Frame:FindFirstChildOfClass("UIStroke"), {Transparency = 0}, 0.3)
    
    -- Key icon
    local keyIcon = Utility:Create("TextLabel", {
        Parent = self.Frame,
        Name = "KeyIcon",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, 0, 0, 25),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = theme.Accent,
        Text = Icons.Key,
        TextSize = 24,
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 202,
    })
    
    Utility:Create("UICorner", {
        Parent = keyIcon,
        CornerRadius = UDim.new(0.5, 0),
    })
    
    -- Title
    local title = Utility:Create("TextLabel", {
        Parent = self.Frame,
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 28),
        Position = UDim2.new(0.5, 0, 0, 85),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = self.KeyName,
        TextColor3 = theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        ZIndex = 202,
    })
    
    -- Description
    local desc = Utility:Create("TextLabel", {
        Parent = self.Frame,
        Name = "Description",
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0.5, 0, 0, 115),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "Enter your key to continue",
        TextColor3 = theme.TextDark,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ZIndex = 202,
    })
    
    -- Input field container
    local inputContainer = Utility:Create("Frame", {
        Parent = self.Frame,
        Name = "InputContainer",
        Size = UDim2.new(1, -40, 0, 42),
        Position = UDim2.new(0.5, 0, 0, 150),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = theme.Input,
        BorderSizePixel = 0,
        ZIndex = 202,
    })
    
    Utility:Create("UICorner", {
        Parent = inputContainer,
        CornerRadius = UDim.new(0, 8),
    })
    
    Utility:Create("UIStroke", {
        Parent = inputContainer,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    -- Input TextBox
    local inputBox = Utility:Create("TextBox", {
        Parent = inputContainer,
        Name = "Input",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Enter key here...",
        PlaceholderColor3 = theme.TextDark,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        ZIndex = 203,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Error message
    local errorMsg = Utility:Create("TextLabel", {
        Parent = self.Frame,
        Name = "ErrorMsg",
        Size = UDim2.new(1, -40, 0, 18),
        Position = UDim2.new(0.5, 0, 0, 196),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = theme.Error,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ZIndex = 202,
    })
    
    -- Submit button
    local submitBtn = Utility:Create("TextButton", {
        Parent = self.Frame,
        Name = "Submit",
        Size = UDim2.new(1, -40, 0, 38),
        Position = UDim2.new(0.5, 0, 0, 220),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = theme.Accent,
        Text = "Validate Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 202,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = submitBtn,
        CornerRadius = UDim.new(0, 8),
    })
    
    -- Focus effects for input
    inputBox.Focused:Connect(function()
        Utility:Tween(inputContainer:FindFirstChildOfClass("UIStroke"), {Color = theme.Accent}, 0.2)
    end)
    
    inputBox.FocusLost:Connect(function()
        Utility:Tween(inputContainer:FindFirstChildOfClass("UIStroke"), {Color = theme.Divider}, 0.2)
    end)
    
    -- Get key from site button (optional)
    if self.GetKeyFromSite and self.Sitekey ~= "" then
        local getKeyBtn = Utility:Create("TextButton", {
            Parent = self.Frame,
            Name = "GetKey",
            Size = UDim2.new(1, -40, 0, 32),
            Position = UDim2.new(0.5, 0, 0, 265),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = theme.Element,
            Text = "📋 Copy Key Link",
            TextColor3 = theme.TextDark,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            BorderSizePixel = 0,
            ZIndex = 202,
            AutoButtonColor = false,
        })
        
        Utility:Create("UICorner", {
            Parent = getKeyBtn,
            CornerRadius = UDim.new(0, 8),
        })
        
        getKeyBtn.MouseButton1Click:Connect(function()
            Utility:Ripple(getKeyBtn, Mouse.X, Mouse.Y)
            pcall(function()
                setclipboard(self.Sitekey)
            end)
            getKeyBtn.Text = "✓ Link Copied!"
            Utility:Tween(getKeyBtn, {BackgroundColor3 = theme.Success}, 0.2)
            task.wait(1.5)
            getKeyBtn.Text = "📋 Copy Key Link"
            Utility:Tween(getKeyBtn, {BackgroundColor3 = theme.Element}, 0.2)
        end)
        
        getKeyBtn.MouseEnter:Connect(function()
            Utility:Tween(getKeyBtn, {BackgroundColor3 = theme.ElementHover}, 0.15)
        end)
        
        getKeyBtn.MouseLeave:Connect(function()
            Utility:Tween(getKeyBtn, {BackgroundColor3 = theme.Element}, 0.15)
        end)
    end
    
    -- Submit logic
    local function validateKey()
        local enteredKey = inputBox.Text
        
        if enteredKey == "" then
            errorMsg.Text = "Please enter a key"
            Utility:Tween(inputContainer:FindFirstChildOfClass("UIStroke"), {Color = theme.Error}, 0.2)
            task.wait(1)
            Utility:Tween(inputContainer:FindFirstChildOfClass("UIStroke"), {Color = theme.Divider}, 0.2)
            errorMsg.Text = ""
            return
        end
        
        if enteredKey == self.Key then
            self.Validated = true
            self:SaveKey(enteredKey)
            errorMsg.TextColor3 = theme.Success
            errorMsg.Text = "✓ Key validated successfully!"
            Utility:Tween(submitBtn, {BackgroundColor3 = theme.Success}, 0.2)
            submitBtn.Text = "✓ Validated"
            
            task.wait(1)
            self:Hide(onValidated)
        else
            errorMsg.TextColor3 = theme.Error
            errorMsg.Text = "✕ Invalid key. Try again."
            Utility:Tween(inputContainer:FindFirstChildOfClass("UIStroke"), {Color = theme.Error}, 0.2)
            
            -- Shake animation
            local originalPos = self.Frame.Position
            for i = 1, 3 do
                Utility:TweenWait(self.Frame, {
                    Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 8, originalPos.Y.Scale, originalPos.Y.Offset)
                }, 0.04)
                Utility:TweenWait(self.Frame, {
                    Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 8, originalPos.Y.Scale, originalPos.Y.Offset)
                }, 0.04)
            end
            Utility:Tween(self.Frame, {Position = originalPos}, 0.04)
            
            task.wait(1.5)
            Utility:Tween(inputContainer:FindFirstChildOfClass("UIStroke"), {Color = theme.Divider}, 0.2)
            errorMsg.Text = ""
        end
    end
    
    submitBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(submitBtn, Mouse.X, Mouse.Y)
        validateKey()
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    -- Submit button hover
    submitBtn.MouseEnter:Connect(function()
        Utility:Tween(submitBtn, {BackgroundColor3 = theme.AccentDark}, 0.15)
    end)
    
    submitBtn.MouseLeave:Connect(function()
        Utility:Tween(submitBtn, {BackgroundColor3 = theme.Accent}, 0.15)
    end)
end

function KeySystem:Hide(callback)
    if self.Frame then
        Utility:Tween(self.Frame, {BackgroundTransparency = 1}, 0.3)
        for _, child in pairs(self.Frame:GetDescendants()) do
            pcall(function()
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    Utility:Tween(child, {TextTransparency = 1}, 0.2)
                end
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
                    Utility:Tween(child, {BackgroundTransparency = 1}, 0.2)
                end
                if child:IsA("UIStroke") then
                    Utility:Tween(child, {Transparency = 1}, 0.2)
                end
            end)
        end
        
        if self.Overlay then
            Utility:Tween(self.Overlay, {BackgroundTransparency = 1}, 0.3)
        end
        
        task.wait(0.35)
        if self.Frame then self.Frame:Destroy() end
        if self.Overlay then self.Overlay:Destroy() end
    end
    
    if callback then callback() end
end

-- ═══════════════════════════════════════════════════════════════
-- WINDOW CLASS
-- ═══════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function SupernovaUI:CreateWindow(options)
    options = options or {}
    
    local window = setmetatable({}, Window)
    window.Title = options.Title or "Supernova UI"
    window.SubTitle = options.SubTitle or "v3.0"
    window.Size = options.Size or UDim2.new(0, 520, 0, 380)
    window.ThemeName = options.Theme or "Midnight"
    window.Theme = ThemeManager:GetTheme(window.ThemeName)
    window.Tabs = {}
    window.ActiveTab = nil
    window.Minimized = false
    window.Elements = {}
    window.Flags = {}
    window.ConfigTab = nil
    
    -- Save system
    window.FolderName = options.FolderName or "SupernovaUI"
    window.FileName = options.FileName or "config"
    window.SaveSystem = SaveSystem.new(window.FolderName, window.FileName)
    
    -- Loading options
    window.LoadingEnabled = options.LoadingEnabled ~= false
    window.LoadingName = options.LoadingName or "Hello, Welcome Back!!"
    window.LoadingIcon = options.LoadingIcon or ""
    window.LoadingDuration = options.LoadingDuration or 3
    
    -- Key system options
    window.KeySystemEnabled = options.KeySystem or false
    window.KeySystemOptions = {
        KeyName = options.KeyName or "Key System",
        Key = options.Key or "default",
        KeySave = options.KeySave or false,
        KeyJsonName = options.KeyJsonName or "key_data",
        GetKeyFromSite = options.GetKeyFromSite or false,
        Sitekey = options.Sitekey or "",
        FolderPath = window.FolderName,
        Theme = window.Theme,
    }
    
    -- Ensure folder exists
    FileSystem:EnsureFolder(window.FolderName)
    
    -- Create ScreenGui
    window.ScreenGui = Utility:Create("ScreenGui", {
        Name = "SupernovaUI_" .. window.Title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    
    -- Parent to CoreGui or PlayerGui
    pcall(function()
        window.ScreenGui.Parent = CoreGui
    end)
    if not window.ScreenGui.Parent then
        window.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Initialize window
    window:_Init()
    
    table.insert(SupernovaUI.Windows, window)
    return window
end

function Window:_Init()
    local self_ref = self
    
    -- Flow: Loading -> Key System -> Main UI
    local function showMainUI()
        self_ref:_BuildUI()
        self_ref:_LoadSavedConfig()
        self_ref.SaveSystem:StartAutoSave(15)
    end
    
    local function afterKeySystem()
        showMainUI()
    end
    
    local function afterLoading()
        if self_ref.KeySystemEnabled then
            local keySys = KeySystem.new(self_ref.ScreenGui, self_ref.KeySystemOptions)
            keySys:Show(afterKeySystem)
        else
            afterKeySystem()
        end
    end
    
    if self.LoadingEnabled then
        local loading = LoadingScreen.new(self.ScreenGui, {
            LoadingName = self.LoadingName,
            LoadingIcon = self.LoadingIcon,
            LoadingDuration = self.LoadingDuration,
            Theme = self.Theme,
        })
        loading:Show()
        task.delay(self.LoadingDuration + 0.5, function()
            loading:Hide(afterLoading)
        end)
    else
        afterLoading()
    end
end

function Window:_BuildUI()
    local theme = self.Theme
    
    -- Main frame
    self.MainFrame = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "MainFrame",
        Size = self.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundTransparency = 1,
    })
    
    Utility:Create("UICorner", {
        Parent = self.MainFrame,
        CornerRadius = UDim.new(0, 10),
    })
    
    -- Shadow
    local shadow = Utility:Create("ImageLabel", {
        Parent = self.MainFrame,
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
    })
    
    -- Animate in
    Utility:Tween(self.MainFrame, {BackgroundTransparency = 0}, 0.4)
    
    -- ═══════════════════════════════════════
    -- TOPBAR
    -- ═════════════════════════════════════���═
    self.TopBar = Utility:Create("Frame", {
        Parent = self.MainFrame,
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.TopBar,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    
    Utility:Create("UICorner", {
        Parent = self.TopBar,
        CornerRadius = UDim.new(0, 10),
    })
    
    -- Fix corner at bottom of topbar
    Utility:Create("Frame", {
        Parent = self.TopBar,
        Name = "BottomFix",
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = theme.TopBar,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    
    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Parent = self.TopBar,
        Name = "Title",
        Size = UDim2.new(0.6, -10, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    })
    
    -- Subtitle
    if self.SubTitle and self.SubTitle ~= "" then
        local subLabel = Utility:Create("TextLabel", {
            Parent = self.TopBar,
            Name = "SubTitle",
            Size = UDim2.new(0, 60, 1, 0),
            Position = UDim2.new(0, 14 + titleLabel.TextBounds.X + 8, 0, 0),
            BackgroundTransparency = 1,
            Text = self.SubTitle,
            TextColor3 = theme.TextDark,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 11,
        })
    end
    
    -- Make draggable
    Utility:MakeDraggable(self.TopBar, self.MainFrame)
    
    -- ═══════════════════════════════════════
    -- TOPBAR BUTTONS
    -- ═══════════════════════════════════════
    local buttonSize = 28
    local buttonPadding = 5
    local buttonsStartX = -8
    
    -- Close button
    local closeBtn = Utility:Create("TextButton", {
        Parent = self.TopBar,
        Name = "CloseBtn",
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, buttonsStartX - buttonSize, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Error,
        BackgroundTransparency = 0.8,
        Text = Icons.Close,
        TextColor3 = theme.Error,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 12,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = closeBtn,
        CornerRadius = UDim.new(0, 6),
    })
    
    -- Minimize button
    local minBtn = Utility:Create("TextButton", {
        Parent = self.TopBar,
        Name = "MinBtn",
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, buttonsStartX - buttonSize * 2 - buttonPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Warning,
        BackgroundTransparency = 0.8,
        Text = Icons.Minimize,
        TextColor3 = theme.Warning,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 12,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = minBtn,
        CornerRadius = UDim.new(0, 6),
    })
    
    -- Resize button
    local resizeBtn = Utility:Create("TextButton", {
        Parent = self.TopBar,
        Name = "ResizeBtn",
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, buttonsStartX - buttonSize * 3 - buttonPadding * 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Success,
        BackgroundTransparency = 0.8,
        Text = Icons.Resize,
        TextColor3 = theme.Success,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 12,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = resizeBtn,
        CornerRadius = UDim.new(0, 6),
    })
    
    -- Button hover effects
    for _, btn in pairs({closeBtn, minBtn, resizeBtn}) do
        btn.MouseEnter:Connect(function()
            Utility:Tween(btn, {BackgroundTransparency = 0.3}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Utility:Tween(btn, {BackgroundTransparency = 0.8}, 0.15)
        end)
    end
    
    -- Close button logic (confirmation modal)
    closeBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(closeBtn, Mouse.X, Mouse.Y)
        self:_ShowCloseConfirmation()
    end)
    
    -- Minimize button logic
    minBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(minBtn, Mouse.X, Mouse.Y)
        self:_ToggleMinimize()
    end)
    
    -- Resize button logic
    local resized = false
    local originalSize = self.Size
    local smallSize = UDim2.new(0, 380, 0, 300)
    
    resizeBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(resizeBtn, Mouse.X, Mouse.Y)
        resized = not resized
        if resized then
            Utility:Tween(self.MainFrame, {Size = smallSize}, 0.3)
        else
            Utility:Tween(self.MainFrame, {Size = originalSize}, 0.3)
        end
    end)
    
    -- ═══════════════════════════════════════
    -- TAB BAR (Side panel)
    -- ═══════════════════════════════════════
    self.TabContainer = Utility:Create("ScrollingFrame", {
        Parent = self.MainFrame,
        Name = "TabContainer",
        Size = UDim2.new(0, 130, 1, -45),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = theme.Section,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 5,
    })
    
    Utility:Create("UIListLayout", {
        Parent = self.TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    })
    
    Utility:AddPadding(self.TabContainer, 4)
    
    -- Divider between tabs and content
    Utility:Create("Frame", {
        Parent = self.MainFrame,
        Name = "Divider",
        Size = UDim2.new(0, 1, 1, -42),
        Position = UDim2.new(0, 130, 0, 42),
        BackgroundColor3 = theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 6,
    })
    
    -- ═══════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════
    self.ContentContainer = Utility:Create("Frame", {
        Parent = self.MainFrame,
        Name = "ContentContainer",
        Size = UDim2.new(1, -132, 1, -44),
        Position = UDim2.new(0, 132, 0, 43),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 5,
    })
    
    -- Notification container
    self.NotificationContainer = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "Notifications",
        Size = UDim2.new(0, 280, 1, 0),
        Position = UDim2.new(1, -290, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 300,
    })
    
    Utility:Create("UIListLayout", {
        Parent = self.NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
end

-- ═══════════════════════════════════════════════════════════════
-- CLOSE CONFIRMATION MODAL
-- ═══════════════════════════════════════════════════════════════
function Window:_ShowCloseConfirmation()
    local theme = self.Theme
    
    -- Overlay
    local overlay = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "CloseOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 500,
    })
    
    local modal = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Name = "CloseModal",
        Size = UDim2.new(0, 280, 0, 170),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ZIndex = 501,
    })
    
    Utility:Create("UICorner", {
        Parent = modal,
        CornerRadius = UDim.new(0, 12),
    })
    
    Utility:Create("UIStroke", {
        Parent = modal,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    -- Warning icon
    local warnIcon = Utility:Create("TextLabel", {
        Parent = modal,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0.5, 0, 0, 18),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = theme.Warning,
        BackgroundTransparency = 0.8,
        Text = "!",
        TextColor3 = theme.Warning,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 502,
    })
    
    Utility:Create("UICorner", {
        Parent = warnIcon,
        CornerRadius = UDim.new(0.5, 0),
    })
    
    -- Title
    Utility:Create("TextLabel", {
        Parent = modal,
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0.5, 0, 0, 65),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "Close UI?",
        TextColor3 = theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 502,
    })
    
    -- Description
    Utility:Create("TextLabel", {
        Parent = modal,
        Size = UDim2.new(1, -30, 0, 18),
        Position = UDim2.new(0.5, 0, 0, 90),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Text = "Are you sure you want to close?",
        TextColor3 = theme.TextDark,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ZIndex = 502,
    })
    
    -- Cancel button
    local cancelBtn = Utility:Create("TextButton", {
        Parent = modal,
        Size = UDim2.new(0.5, -15, 0, 34),
        Position = UDim2.new(0, 10, 1, -46),
        BackgroundColor3 = theme.Element,
        Text = "Cancel",
        TextColor3 = theme.TextDark,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        ZIndex = 502,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = cancelBtn,
        CornerRadius = UDim.new(0, 8),
    })
    
    -- Yes button
    local yesBtn = Utility:Create("TextButton", {
        Parent = modal,
        Size = UDim2.new(0.5, -15, 0, 34),
        Position = UDim2.new(0.5, 5, 1, -46),
        BackgroundColor3 = theme.Error,
        Text = "Yes",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 502,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = yesBtn,
        CornerRadius = UDim.new(0, 8),
    })
    
    -- Hover effects
    cancelBtn.MouseEnter:Connect(function()
        Utility:Tween(cancelBtn, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    cancelBtn.MouseLeave:Connect(function()
        Utility:Tween(cancelBtn, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    yesBtn.MouseEnter:Connect(function()
        Utility:Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.15)
    end)
    yesBtn.MouseLeave:Connect(function()
        Utility:Tween(yesBtn, {BackgroundColor3 = theme.Error}, 0.15)
    end)
    
    -- Actions
    cancelBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(cancelBtn, Mouse.X, Mouse.Y)
        Utility:Tween(overlay, {BackgroundTransparency = 1}, 0.2)
        Utility:TweenWait(modal, {BackgroundTransparency = 1}, 0.2)
        overlay:Destroy()
        modal:Destroy()
    end)
    
    yesBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(yesBtn, Mouse.X, Mouse.Y)
        self.SaveSystem:Save()
        self.SaveSystem:StopAutoSave()
        
        Utility:Tween(overlay, {BackgroundTransparency = 1}, 0.3)
        Utility:TweenWait(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        
        self.ScreenGui:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- MINIMIZE
-- ═══════════════════════════════════════════════════════════════
function Window:_ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        self._originalSize = self.MainFrame.Size
        Utility:Tween(self.MainFrame, {
            Size = UDim2.new(0, self.MainFrame.Size.X.Offset, 0, 40)
        }, 0.3, Enum.EasingStyle.Quart)
    else
        Utility:Tween(self.MainFrame, {
            Size = self._originalSize or self.Size
        }, 0.3, Enum.EasingStyle.Quart)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- TAB CLASS
-- ═══════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Window:AddTab(options)
    options = options or {}
    
    local tab = setmetatable({}, Tab)
    tab.Window = self
    tab.Name = options.Name or "Tab"
    tab.Icon = options.Icon or ""
    tab.Sections = {}
    tab.Elements = {}
    tab.Active = false
    
    local theme = self.Theme
    
    -- Tab button
    tab.Button = Utility:Create("TextButton", {
        Parent = self.TabContainer,
        Name = "Tab_" .. tab.Name,
        Size = UDim2.new(1, -8, 0, 34),
        BackgroundColor3 = theme.TabInactive,
        BackgroundTransparency = 0.5,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 6,
    })
    
    Utility:Create("UICorner", {
        Parent = tab.Button,
        CornerRadius = UDim.new(0, 7),
    })
    
    -- Active indicator
    tab.Indicator = Utility:Create("Frame", {
        Parent = tab.Button,
        Name = "Indicator",
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 7,
    })
    
    Utility:Create("UICorner", {
        Parent = tab.Indicator,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Tab icon text
    if tab.Icon ~= "" then
        Utility:Create("TextLabel", {
            Parent = tab.Button,
            Name = "Icon",
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = tab.Icon,
            TextColor3 = theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            ZIndex = 7,
        })
    end
    
    -- Tab label
    tab.Label = Utility:Create("TextLabel", {
        Parent = tab.Button,
        Name = "Label",
        Size = UDim2.new(1, tab.Icon ~= "" and -38 or -20, 1, 0),
        Position = UDim2.new(0, tab.Icon ~= "" and 32 or 10, 0, 0),
        BackgroundTransparency = 1,
        Text = tab.Name,
        TextColor3 = theme.TextDark,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 7,
    })
    
    -- Content scroll frame
    tab.Content = Utility:Create("ScrollingFrame", {
        Parent = self.ContentContainer,
        Name = "Content_" .. tab.Name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 5,
    })
    
    Utility:Create("UIListLayout", {
        Parent = tab.Content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    })
    
    Utility:AddPadding(tab.Content, 8)
    
    -- Tab click logic
    tab.Button.MouseButton1Click:Connect(function()
        Utility:Ripple(tab.Button, Mouse.X, Mouse.Y)
        self:_SelectTab(tab)
    end)
    
    -- Hover effects
    tab.Button.MouseEnter:Connect(function()
        if not tab.Active then
            Utility:Tween(tab.Button, {BackgroundTransparency = 0.2, BackgroundColor3 = theme.ElementHover}, 0.15)
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if not tab.Active then
            Utility:Tween(tab.Button, {BackgroundTransparency = 0.5, BackgroundColor3 = theme.TabInactive}, 0.15)
        end
    end)
    
    table.insert(self.Tabs, tab)
    
    -- Auto-select first tab
    if #self.Tabs == 1 then
        self:_SelectTab(tab)
    end
    
    return tab
end

function Window:_SelectTab(tab)
    local theme = self.Theme
    
    -- Deactivate all tabs
    for _, t in pairs(self.Tabs) do
        t.Active = false
        t.Content.Visible = false
        Utility:Tween(t.Button, {
            BackgroundColor3 = theme.TabInactive,
            BackgroundTransparency = 0.5,
        }, 0.2)
        Utility:Tween(t.Label, {TextColor3 = theme.TextDark}, 0.2)
        Utility:Tween(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
        
        if t.Button:FindFirstChild("Icon") then
            Utility:Tween(t.Button.Icon, {TextColor3 = theme.TextDark}, 0.2)
        end
    end
    
    -- Activate selected tab
    tab.Active = true
    tab.Content.Visible = true
    Utility:Tween(tab.Button, {
        BackgroundColor3 = theme.TabActive,
        BackgroundTransparency = 0.85,
    }, 0.2)
    Utility:Tween(tab.Label, {TextColor3 = theme.Text}, 0.2)
    Utility:Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 18)}, 0.2)
    
    if tab.Button:FindFirstChild("Icon") then
        Utility:Tween(tab.Button.Icon, {TextColor3 = theme.Accent}, 0.2)
    end
    
    self.ActiveTab = tab
end

-- ═══════════════════════════════════════════════════════════════
-- SECTION CLASS
-- ═══════════════════════════════════════════════════════════════
local Section = {}
Section.__index = Section

function Tab:AddSection(options)
    options = options or {}
    
    local section = setmetatable({}, Section)
    section.Tab = self
    section.Window = self.Window
    section.Name = options.Name or "Section"
    section.Elements = {}
    
    local theme = self.Window.Theme
    
    -- Section frame
    section.Frame = Utility:Create("Frame", {
        Parent = self.Content,
        Name = "Section_" .. section.Name,
        Size = UDim2.new(1, -6, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = theme.Section,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 6,
    })
    
    Utility:Create("UICorner", {
        Parent = section.Frame,
        CornerRadius = UDim.new(0, 8),
    })
    
    -- Section header
    local header = Utility:Create("Frame", {
        Parent = section.Frame,
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        ZIndex = 7,
    })
    
    -- Accent line
    Utility:Create("Frame", {
        Parent = header,
        Name = "AccentLine",
        Size = UDim2.new(0, 3, 0, 14),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 8,
    })
    
    Utility:Create("UICorner", {
        Parent = header.AccentLine,
        CornerRadius = UDim.new(1, 0),
    })
    
    Utility:Create("TextLabel", {
        Parent = header,
        Name = "Title",
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = section.Name,
        TextColor3 = theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    })
    
    -- Elements container
    section.Container = Utility:Create("Frame", {
        Parent = section.Frame,
        Name = "Elements",
        Size = UDim2.new(1, -12, 0, 0),
        Position = UDim2.new(0, 6, 0, 28),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 7,
    })
    
    Utility:Create("UIListLayout", {
        Parent = section.Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
    })
    
    -- Bottom padding
    Utility:Create("Frame", {
        Parent = section.Frame,
        Name = "BottomPad",
        Size = UDim2.new(1, 0, 0, 6),
        LayoutOrder = 999999,
        BackgroundTransparency = 1,
    })
    
    table.insert(self.Sections, section)
    return section
end

-- ���══════════════════════════════════════════════════════════════
-- LABEL ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddLabel(options)
    options = options or {}
    local theme = self.Window.Theme
    local text = options.Text or "Label"
    
    local labelFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Label",
        Size = UDim2.new(1, -4, 0, 28),
        BackgroundTransparency = 1,
        ZIndex = 8,
    })
    
    local label = Utility:Create("TextLabel", {
        Parent = labelFrame,
        Name = "Text",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.TextDark,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9,
    })
    
    local element = {
        Type = "Label",
        Frame = labelFrame,
        Label = label,
    }
    
    function element:SetText(newText)
        label.Text = newText
    end
    
    table.insert(self.Elements, element)
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- BUTTON ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddButton(options)
    options = options or {}
    local theme = self.Window.Theme
    local text = options.Text or "Button"
    local callback = options.Callback or function() end
    
    local buttonFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Button_" .. text,
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
        ClipsDescendants = true,
    })
    
    Utility:Create("UICorner", {
        Parent = buttonFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    local button = Utility:Create("TextButton", {
        Parent = buttonFrame,
        Name = "Btn",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 9,
        AutoButtonColor = false,
    })
    
    local label = Utility:Create("TextLabel", {
        Parent = buttonFrame,
        Name = "Label",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    -- Arrow indicator
    Utility:Create("TextLabel", {
        Parent = buttonFrame,
        Name = "Arrow",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = Icons.Arrow,
        TextColor3 = theme.TextDark,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        ZIndex = 10,
    })
    
    -- Hover & click
    button.MouseEnter:Connect(function()
        Utility:Tween(buttonFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Utility:Tween(buttonFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    button.MouseButton1Click:Connect(function()
        Utility:Ripple(buttonFrame, Mouse.X, Mouse.Y)
        
        -- Click animation
        Utility:Tween(buttonFrame, {BackgroundColor3 = theme.Accent}, 0.1)
        task.wait(0.1)
        Utility:Tween(buttonFrame, {BackgroundColor3 = theme.Element}, 0.2)
        
        pcall(callback)
    end)
    
    local element = {
        Type = "Button",
        Frame = buttonFrame,
        Label = label,
    }
    
    function element:SetText(newText)
        label.Text = newText
    end
    
    table.insert(self.Elements, element)
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- TOGGLE ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddToggle(options)
    options = options or {}
    local theme = self.Window.Theme
    local window = self.Window
    local text = options.Text or "Toggle"
    local default = options.Default or false
    local flag = options.Flag or text
    local callback = options.Callback or function() end
    
    local toggled = default
    
    local toggleFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Toggle_" .. text,
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
        ClipsDescendants = true,
    })
    
    Utility:Create("UICorner", {
        Parent = toggleFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    local button = Utility:Create("TextButton", {
        Parent = toggleFrame,
        Name = "Btn",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 9,
        AutoButtonColor = false,
    })
    
    local label = Utility:Create("TextLabel", {
        Parent = toggleFrame,
        Name = "Label",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    -- Toggle switch background
    local switchBg = Utility:Create("Frame", {
        Parent = toggleFrame,
        Name = "SwitchBg",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = toggled and theme.ToggleEnabled or theme.Toggle,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    
    Utility:Create("UICorner", {
        Parent = switchBg,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Toggle knob
    local knob = Utility:Create("Frame", {
        Parent = switchBg,
        Name = "Knob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 11,
    })
    
    Utility:Create("UICorner", {
        Parent = knob,
        CornerRadius = UDim.new(1, 0),
    })
    
    local function updateVisual()
        if toggled then
            Utility:Tween(switchBg, {BackgroundColor3 = theme.ToggleEnabled}, 0.2)
            Utility:Tween(knob, {Position = UDim2.new(1, -18, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
        else
            Utility:Tween(switchBg, {BackgroundColor3 = theme.Toggle}, 0.2)
            Utility:Tween(knob, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
        end
    end
    
    local function setToggle(value, skipCallback)
        toggled = value
        updateVisual()
        window.Flags[flag] = toggled
        window.SaveSystem.Data[flag] = toggled
        if not skipCallback then
            pcall(callback, toggled)
        end
    end
    
    -- Register save
    window.SaveSystem:Register(flag, "Toggle", default)
    window.Flags[flag] = toggled
    window.SaveSystem.Data[flag] = toggled
    
    -- Hover & click
    button.MouseEnter:Connect(function()
        Utility:Tween(toggleFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Utility:Tween(toggleFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    button.MouseButton1Click:Connect(function()
        Utility:Ripple(toggleFrame, Mouse.X, Mouse.Y)
        setToggle(not toggled)
    end)
    
    local element = {
        Type = "Toggle",
        Frame = toggleFrame,
        Flag = flag,
        Value = toggled,
    }
    
    function element:Set(value, skipCallback)
        setToggle(value, skipCallback)
        self.Value = value
    end
    
    function element:Get()
        return toggled
    end
    
    -- Store element reference
    window.Elements[flag] = element
    table.insert(self.Elements, element)
    
    -- Apply default
    if default then
        pcall(callback, default)
    end
    
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- SLIDER ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddSlider(options)
    options = options or {}
    local theme = self.Window.Theme
    local window = self.Window
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local increment = options.Increment or 1
    local flag = options.Flag or text
    local suffix = options.Suffix or ""
    local callback = options.Callback or function() end
    
    local currentValue = default
    
    local sliderFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Slider_" .. text,
        Size = UDim2.new(1, -4, 0, 50),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
    })
    
    Utility:Create("UICorner", {
        Parent = sliderFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    -- Label
    local label = Utility:Create("TextLabel", {
        Parent = sliderFrame,
        Name = "Label",
        Size = UDim2.new(0.6, -8, 0, 20),
        Position = UDim2.new(0, 8, 0, 4),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    -- Value display
    local valueLabel = Utility:Create("TextLabel", {
        Parent = sliderFrame,
        Name = "Value",
        Size = UDim2.new(0.4, -8, 0, 20),
        Position = UDim2.new(0.6, 0, 0, 4),
        BackgroundTransparency = 1,
        Text = tostring(currentValue) .. suffix,
        TextColor3 = theme.Accent,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 10,
    })
    
    -- Slider bar background
    local barBg = Utility:Create("Frame", {
        Parent = sliderFrame,
        Name = "BarBg",
        Size = UDim2.new(1, -16, 0, 6),
        Position = UDim2.new(0, 8, 0, 32),
        BackgroundColor3 = theme.SliderBar,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    
    Utility:Create("UICorner", {
        Parent = barBg,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Slider fill
    local initialPercent = (default - min) / (max - min)
    
    local barFill = Utility:Create("Frame", {
        Parent = barBg,
        Name = "Fill",
        Size = UDim2.new(initialPercent, 0, 1, 0),
        BackgroundColor3 = theme.SliderFill,
        BorderSizePixel = 0,
        ZIndex = 11,
    })
    
    Utility:Create("UICorner", {
        Parent = barFill,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Slider knob
    local knob = Utility:Create("Frame", {
        Parent = barBg,
        Name = "Knob",
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(initialPercent, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    
    Utility:Create("UICorner", {
        Parent = knob,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Slider interaction
    local dragging = false
    
    local function updateSlider(inputX)
        local barAbsPos = barBg.AbsolutePosition.X
        local barAbsSize = barBg.AbsoluteSize.X
        
        local relativeX = math.clamp((inputX - barAbsPos) / barAbsSize, 0, 1)
        local rawValue = min + (max - min) * relativeX
        
        -- Apply increment
        local snappedValue = math.floor(rawValue / increment + 0.5) * increment
        snappedValue = math.clamp(snappedValue, min, max)
        snappedValue = Utility:RoundNumber(snappedValue, 2)
        
        currentValue = snappedValue
        local percent = (currentValue - min) / (max - min)
        
        barFill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, 0, 0.5, 0)
        valueLabel.Text = tostring(currentValue) .. suffix
        
        window.Flags[flag] = currentValue
        window.SaveSystem.Data[flag] = currentValue
        
        pcall(callback, currentValue)
    end
    
    -- Touch/mouse interaction on the bar area
    local sliderInput = Utility:Create("TextButton", {
        Parent = sliderFrame,
        Name = "Input",
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 13,
        AutoButtonColor = false,
    })
    
    sliderInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    
    sliderInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Hover effect
    sliderFrame.MouseEnter:Connect(function()
        Utility:Tween(sliderFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    sliderFrame.MouseLeave:Connect(function()
        Utility:Tween(sliderFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    -- Register save
    window.SaveSystem:Register(flag, "Slider", default)
    window.Flags[flag] = currentValue
    window.SaveSystem.Data[flag] = currentValue
    
    local element = {
        Type = "Slider",
        Frame = sliderFrame,
        Flag = flag,
        Value = currentValue,
    }
    
    function element:Set(value, skipCallback)
        value = math.clamp(value, min, max)
        currentValue = value
        local percent = (currentValue - min) / (max - min)
        barFill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, 0, 0.5, 0)
        valueLabel.Text = tostring(currentValue) .. suffix
        window.Flags[flag] = currentValue
        window.SaveSystem.Data[flag] = currentValue
        self.Value = currentValue
        if not skipCallback then
            pcall(callback, currentValue)
        end
    end
    
    function element:Get()
        return currentValue
    end
    
    window.Elements[flag] = element
    table.insert(self.Elements, element)
    
    if default ~= min then
        pcall(callback, default)
    end
    
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- DROPDOWN ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddDropdown(options)
    options = options or {}
    local theme = self.Window.Theme
    local window = self.Window
    local text = options.Text or "Dropdown"
    local items = options.Items or {}
    local default = options.Default or (items[1] or "")
    local flag = options.Flag or text
    local multi = options.Multi or false
    local callback = options.Callback or function() end
    
    local currentValue = default
    local opened = false
    
    if multi then
        if type(default) == "table" then
            currentValue = default
        else
            currentValue = {}
        end
    end
    
    local dropdownFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Dropdown_" .. text,
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
        ClipsDescendants = false,
    })
    
    Utility:Create("UICorner", {
        Parent = dropdownFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    local button = Utility:Create("TextButton", {
        Parent = dropdownFrame,
        Name = "Btn",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 9,
        AutoButtonColor = false,
    })
    
    local label = Utility:Create("TextLabel", {
        Parent = dropdownFrame,
        Name = "Label",
        Size = UDim2.new(0.5, -8, 0, 34),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    -- Selected value display
    local function getDisplayText()
        if multi then
            if type(currentValue) == "table" and #currentValue > 0 then
                return table.concat(currentValue, ", ")
            else
                return "None"
            end
        else
            return tostring(currentValue)
        end
    end
    
    local selectedLabel = Utility:Create("TextLabel", {
        Parent = dropdownFrame,
        Name = "Selected",
        Size = UDim2.new(0.45, -30, 0, 34),
        Position = UDim2.new(0.55, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = getDisplayText(),
        TextColor3 = theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 10,
    })
    
    -- Arrow
    local arrow = Utility:Create("TextLabel", {
        Parent = dropdownFrame,
        Name = "Arrow",
        Size = UDim2.new(0, 20, 0, 34),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = Icons.Dropdown,
        TextColor3 = theme.TextDark,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        ZIndex = 10,
    })
    
    -- Options container
    local optionsContainer = Utility:Create("Frame", {
        Parent = dropdownFrame,
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = theme.DropdownBG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 50,
    })
    
    Utility:Create("UICorner", {
        Parent = optionsContainer,
        CornerRadius = UDim.new(0, 7),
    })
    
    Utility:Create("UIStroke", {
        Parent = optionsContainer,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    local optionsList = Utility:Create("ScrollingFrame", {
        Parent = optionsContainer,
        Name = "List",
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 51,
    })
    
    Utility:Create("UIListLayout", {
        Parent = optionsList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    })
    
    local optionButtons = {}
    
    local function createOption(item)
        local isSelected = false
        if multi then
            isSelected = table.find(currentValue, item) ~= nil
        else
            isSelected = currentValue == item
        end
        
        local optionBtn = Utility:Create("TextButton", {
            Parent = optionsList,
            Name = "Option_" .. item,
            Size = UDim2.new(1, -4, 0, 28),
            BackgroundColor3 = isSelected and theme.Accent or theme.DropdownOption,
            BackgroundTransparency = isSelected and 0.7 or 0,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 52,
        })
        
        Utility:Create("UICorner", {
            Parent = optionBtn,
            CornerRadius = UDim.new(0, 5),
        })
        
        local optLabel = Utility:Create("TextLabel", {
            Parent = optionBtn,
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = item,
            TextColor3 = isSelected and theme.Accent or theme.Text,
            TextSize = 12,
            Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 53,
        })
        
        -- Check mark for selected
        local checkMark = Utility:Create("TextLabel", {
            Parent = optionBtn,
            Name = "Check",
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -24, 0, 0),
            BackgroundTransparency = 1,
            Text = isSelected and Icons.Check or "",
            TextColor3 = theme.Accent,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            ZIndex = 53,
        })
        
        optionBtn.MouseEnter:Connect(function()
            Utility:Tween(optionBtn, {BackgroundColor3 = theme.DropdownHover}, 0.1)
        end)
        
        optionBtn.MouseLeave:Connect(function()
            local sel = false
            if multi then
                sel = table.find(currentValue, item) ~= nil
            else
                sel = currentValue == item
            end
            Utility:Tween(optionBtn, {
                BackgroundColor3 = sel and theme.Accent or theme.DropdownOption,
                BackgroundTransparency = sel and 0.7 or 0
            }, 0.1)
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            if multi then
                local idx = table.find(currentValue, item)
                if idx then
                    table.remove(currentValue, idx)
                else
                    table.insert(currentValue, item)
                end
                
                -- Update all option visuals
                for _, ob in pairs(optionButtons) do
                    local s = table.find(currentValue, ob.Item) ~= nil
                    Utility:Tween(ob.Button, {
                        BackgroundColor3 = s and theme.Accent or theme.DropdownOption,
                        BackgroundTransparency = s and 0.7 or 0
                    }, 0.15)
                    ob.Check.Text = s and Icons.Check or ""
                    ob.Label.Font = s and Enum.Font.GothamBold or Enum.Font.Gotham
                    ob.Label.TextColor3 = s and theme.Accent or theme.Text
                end
            else
                currentValue = item
                
                -- Update all option visuals
                for _, ob in pairs(optionButtons) do
                    local s = currentValue == ob.Item
                    Utility:Tween(ob.Button, {
                        BackgroundColor3 = s and theme.Accent or theme.DropdownOption,
                        BackgroundTransparency = s and 0.7 or 0
                    }, 0.15)
                    ob.Check.Text = s and Icons.Check or ""
                    ob.Label.Font = s and Enum.Font.GothamBold or Enum.Font.Gotham
                    ob.Label.TextColor3 = s and theme.Accent or theme.Text
                end
                
                -- Close dropdown after single select
                task.wait(0.1)
                toggleDropdown()
            end
            
            selectedLabel.Text = getDisplayText()
            window.Flags[flag] = currentValue
            window.SaveSystem.Data[flag] = currentValue
            pcall(callback, currentValue)
        end)
        
        table.insert(optionButtons, {
            Item = item,
            Button = optionBtn,
            Label = optLabel,
            Check = checkMark,
        })
    end
    
    for _, item in ipairs(items) do
        createOption(item)
    end
    
    function toggleDropdown()
        opened = not opened
        
        if opened then
            optionsContainer.Visible = true
            local optCount = math.min(#items, 6)
            local targetHeight = optCount * 30 + 6
            Utility:Tween(optionsContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
            Utility:Tween(dropdownFrame, {Size = UDim2.new(1, -4, 0, 34 + targetHeight + 4)}, 0.25)
            arrow.Text = Icons.DropdownUp
        else
            Utility:Tween(optionsContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            Utility:Tween(dropdownFrame, {Size = UDim2.new(1, -4, 0, 34)}, 0.2)
            arrow.Text = Icons.Dropdown
            task.delay(0.2, function()
                if not opened then
                    optionsContainer.Visible = false
                end
            end)
        end
    end
    
    button.MouseButton1Click:Connect(function()
        Utility:Ripple(dropdownFrame, Mouse.X, Mouse.Y)
        toggleDropdown()
    end)
    
    -- Hover
    button.MouseEnter:Connect(function()
        Utility:Tween(dropdownFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Utility:Tween(dropdownFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    -- Register save
    window.SaveSystem:Register(flag, "Dropdown", default)
    window.Flags[flag] = currentValue
    window.SaveSystem.Data[flag] = currentValue
    
    local element = {
        Type = "Dropdown",
        Frame = dropdownFrame,
        Flag = flag,
        Value = currentValue,
    }
    
    function element:Set(value, skipCallback)
        currentValue = value
        selectedLabel.Text = getDisplayText()
        
        -- Update visuals
        for _, ob in pairs(optionButtons) do
            local s
            if multi then
                s = table.find(currentValue, ob.Item) ~= nil
            else
                s = currentValue == ob.Item
            end
            ob.Button.BackgroundColor3 = s and theme.Accent or theme.DropdownOption
            ob.Button.BackgroundTransparency = s and 0.7 or 0
            ob.Check.Text = s and Icons.Check or ""
            ob.Label.Font = s and Enum.Font.GothamBold or Enum.Font.Gotham
            ob.Label.TextColor3 = s and theme.Accent or theme.Text
        end
        
        window.Flags[flag] = currentValue
        window.SaveSystem.Data[flag] = currentValue
        self.Value = currentValue
        if not skipCallback then
            pcall(callback, currentValue)
        end
    end
    
    function element:Get()
        return currentValue
    end
    
    function element:Refresh(newItems, keepValue)
        items = newItems
        
        for _, ob in pairs(optionButtons) do
            ob.Button:Destroy()
        end
        optionButtons = {}
        
        for _, item in ipairs(newItems) do
            createOption(item)
        end
        
        if not keepValue then
            if multi then
                currentValue = {}
            else
                currentValue = newItems[1] or ""
            end
            selectedLabel.Text = getDisplayText()
            window.Flags[flag] = currentValue
            window.SaveSystem.Data[flag] = currentValue
        end
    end
    
    window.Elements[flag] = element
    table.insert(self.Elements, element)
    
    if default and default ~= "" then
        pcall(callback, default)
    end
    
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- TEXTBOX ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddTextbox(options)
    options = options or {}
    local theme = self.Window.Theme
    local window = self.Window
    local text = options.Text or "Textbox"
    local default = options.Default or ""
    local placeholder = options.Placeholder or "Type here..."
    local flag = options.Flag or text
    local callback = options.Callback or function() end
    local onChanged = options.OnChanged or function() end
    
    local currentValue = default
    
    local textboxFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Textbox_" .. text,
        Size = UDim2.new(1, -4, 0, 58),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
    })
    
    Utility:Create("UICorner", {
        Parent = textboxFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    -- Label
    local label = Utility:Create("TextLabel", {
        Parent = textboxFrame,
        Name = "Label",
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 8, 0, 4),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    -- Input container
    local inputBg = Utility:Create("Frame", {
        Parent = textboxFrame,
        Name = "InputBg",
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, 26),
        BackgroundColor3 = theme.Input,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    
    Utility:Create("UICorner", {
        Parent = inputBg,
        CornerRadius = UDim.new(0, 6),
    })
    
    local inputStroke = Utility:Create("UIStroke", {
        Parent = inputBg,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    local inputBox = Utility:Create("TextBox", {
        Parent = inputBg,
        Name = "Input",
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = theme.TextDark,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    })
    
    -- Focus effects
    inputBox.Focused:Connect(function()
        Utility:Tween(inputStroke, {Color = theme.Accent}, 0.2)
        Utility:Tween(inputBg, {BackgroundColor3 = theme.InputFocused}, 0.2)
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        Utility:Tween(inputStroke, {Color = theme.Divider}, 0.2)
        Utility:Tween(inputBg, {BackgroundColor3 = theme.Input}, 0.2)
        
        currentValue = inputBox.Text
        window.Flags[flag] = currentValue
        window.SaveSystem.Data[flag] = currentValue
        
        if enterPressed then
            pcall(callback, currentValue)
        end
    end)
    
    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        currentValue = inputBox.Text
        window.Flags[flag] = currentValue
        window.SaveSystem.Data[flag] = currentValue
        pcall(onChanged, currentValue)
    end)
    
    -- Hover
    textboxFrame.MouseEnter:Connect(function()
        Utility:Tween(textboxFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    textboxFrame.MouseLeave:Connect(function()
        Utility:Tween(textboxFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    -- Register save
    window.SaveSystem:Register(flag, "Textbox", default)
    window.Flags[flag] = currentValue
    window.SaveSystem.Data[flag] = currentValue
    
    local element = {
        Type = "Textbox",
        Frame = textboxFrame,
        Flag = flag,
        Value = currentValue,
    }
    
    function element:Set(value, skipCallback)
        inputBox.Text = value
        currentValue = value
        window.Flags[flag] = value
        window.SaveSystem.Data[flag] = value
        self.Value = value
        if not skipCallback then
            pcall(callback, value)
        end
    end
    
    function element:Get()
        return currentValue
    end
    
    window.Elements[flag] = element
    table.insert(self.Elements, element)
    
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- KEYBIND ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddKeybind(options)
    options = options or {}
    local theme = self.Window.Theme
    local window = self.Window
    local text = options.Text or "Keybind"
    local default = options.Default or Enum.KeyCode.Unknown
    local flag = options.Flag or text
    local callback = options.Callback or function() end
    local onChanged = options.OnChanged or function() end
    
    local currentKey = default
    local listening = false
    
    local keybindFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "Keybind_" .. text,
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
        ClipsDescendants = true,
    })
    
    Utility:Create("UICorner", {
        Parent = keybindFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    local label = Utility:Create("TextLabel", {
        Parent = keybindFrame,
        Name = "Label",
        Size = UDim2.new(0.6, -8, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    local function getKeyName(key)
        if key == Enum.KeyCode.Unknown then
            return "None"
        end
        local name = tostring(key):gsub("Enum.KeyCode.", "")
        return name
    end
    
    local keyBtn = Utility:Create("TextButton", {
        Parent = keybindFrame,
        Name = "KeyBtn",
        Size = UDim2.new(0, 80, 0, 24),
        Position = UDim2.new(1, -90, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Input,
        Text = getKeyName(currentKey),
        TextColor3 = theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 10,
    })
    
    Utility:Create("UICorner", {
        Parent = keyBtn,
        CornerRadius = UDim.new(0, 5),
    })
    
    Utility:Create("UIStroke", {
        Parent = keyBtn,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        Utility:Tween(keyBtn:FindFirstChildOfClass("UIStroke"), {Color = theme.Accent}, 0.2)
        Utility:Tween(keyBtn, {BackgroundColor3 = theme.InputFocused}, 0.2)
    end)
    
    -- Listen for key input
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode
                if key == Enum.KeyCode.Escape then
                    currentKey = Enum.KeyCode.Unknown
                else
                    currentKey = key
                end
                
                listening = false
                keyBtn.Text = getKeyName(currentKey)
                Utility:Tween(keyBtn:FindFirstChildOfClass("UIStroke"), {Color = theme.Divider}, 0.2)
                Utility:Tween(keyBtn, {BackgroundColor3 = theme.Input}, 0.2)
                
                window.Flags[flag] = currentKey.Name
                window.SaveSystem.Data[flag] = currentKey.Name
                pcall(onChanged, currentKey)
            end
        elseif not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
                pcall(callback, currentKey)
            end
        end
    end)
    
    -- Hover
    keybindFrame.MouseEnter:Connect(function()
        Utility:Tween(keybindFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    keybindFrame.MouseLeave:Connect(function()
        Utility:Tween(keybindFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    -- Register save
    local defaultKeyName = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "Unknown"
    window.SaveSystem:Register(flag, "Keybind", defaultKeyName)
    window.Flags[flag] = defaultKeyName
    window.SaveSystem.Data[flag] = defaultKeyName
    
    local element = {
        Type = "Keybind",
        Frame = keybindFrame,
        Flag = flag,
        Value = currentKey,
    }
    
    function element:Set(keyCode, skipCallback)
        if type(keyCode) == "string" then
            local success, key = pcall(function()
                return Enum.KeyCode[keyCode]
            end)
            if success then
                currentKey = key
            else
                currentKey = Enum.KeyCode.Unknown
            end
        else
            currentKey = keyCode
        end
        
        keyBtn.Text = getKeyName(currentKey)
        window.Flags[flag] = currentKey.Name
        window.SaveSystem.Data[flag] = currentKey.Name
        self.Value = currentKey
        if not skipCallback then
            pcall(onChanged, currentKey)
        end
    end
    
    function element:Get()
        return currentKey
    end
    
    window.Elements[flag] = element
    table.insert(self.Elements, element)
    
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- COLOR PICKER ELEMENT
-- ═══════════════════════════════════════════════════════════════
function Section:AddColorPicker(options)
    options = options or {}
    local theme = self.Window.Theme
    local window = self.Window
    local text = options.Text or "Color Picker"
    local default = options.Default or Color3.fromRGB(255, 0, 0)
    local flag = options.Flag or text
    local callback = options.Callback or function() end
    
    local currentColor = default
    local pickerOpen = false
    local hue, sat, val = Color3.toHSV(default)
    
    local colorFrame = Utility:Create("Frame", {
        Parent = self.Container,
        Name = "ColorPicker_" .. text,
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = theme.Element,
        BorderSizePixel = 0,
        ZIndex = 8,
        ClipsDescendants = false,
    })
    
    Utility:Create("UICorner", {
        Parent = colorFrame,
        CornerRadius = UDim.new(0, 7),
    })
    
    local button = Utility:Create("TextButton", {
        Parent = colorFrame,
        Name = "Btn",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 9,
        AutoButtonColor = false,
    })
    
    local label = Utility:Create("TextLabel", {
        Parent = colorFrame,
        Name = "Label",
        Size = UDim2.new(1, -60, 0, 34),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10,
    })
    
    -- Color preview
    local colorPreview = Utility:Create("Frame", {
        Parent = colorFrame,
        Name = "Preview",
        Size = UDim2.new(0, 28, 0, 18),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = currentColor,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    
    Utility:Create("UICorner", {
        Parent = colorPreview,
        CornerRadius = UDim.new(0, 5),
    })
    
    Utility:Create("UIStroke", {
        Parent = colorPreview,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    -- Picker panel
    local pickerPanel = Utility:Create("Frame", {
        Parent = colorFrame,
        Name = "PickerPanel",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = theme.DropdownBG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 50,
    })
    
    Utility:Create("UICorner", {
        Parent = pickerPanel,
        CornerRadius = UDim.new(0, 7),
    })
    
    Utility:Create("UIStroke", {
        Parent = pickerPanel,
        Color = theme.Divider,
        Thickness = 1,
    })
    
    -- Saturation/Value field
    local svField = Utility:Create("ImageLabel", {
        Parent = pickerPanel,
        Name = "SVField",
        Size = UDim2.new(1, -50, 0, 120),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        BorderSizePixel = 0,
        Image = "rbxassetid://4155801252",
        ZIndex = 51,
    })
    
    Utility:Create("UICorner", {
        Parent = svField,
        CornerRadius = UDim.new(0, 6),
    })
    
    -- SV Cursor
    local svCursor = Utility:Create("Frame", {
        Parent = svField,
        Name = "Cursor",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(sat, 0, 1 - val, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 52,
    })
    
    Utility:Create("UICorner", {
        Parent = svCursor,
        CornerRadius = UDim.new(1, 0),
    })
    
    Utility:Create("UIStroke", {
        Parent = svCursor,
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
    })
    
    -- Hue slider
    local hueBar = Utility:Create("ImageLabel", {
        Parent = pickerPanel,
        Name = "HueBar",
        Size = UDim2.new(0, 22, 0, 120),
        Position = UDim2.new(1, -36, 0, 8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Image = "rbxassetid://4155801252",
        ZIndex = 51,
    })
    
    Utility:Create("UICorner", {
        Parent = hueBar,
        CornerRadius = UDim.new(0, 6),
    })
    
    -- Create hue gradient
    local hueGradient = Utility:Create("UIGradient", {
        Parent = hueBar,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
    })
    
    -- Hue cursor
    local hueCursor = Utility:Create("Frame", {
        Parent = hueBar,
        Name = "Cursor",
        Size = UDim2.new(1, 4, 0, 4),
        Position = UDim2.new(0.5, 0, hue, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 52,
    })
    
    Utility:Create("UICorner", {
        Parent = hueCursor,
        CornerRadius = UDim.new(1, 0),
    })
    
    Utility:Create("UIStroke", {
        Parent = hueCursor,
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
    })
    
    -- Hex input
    local hexInput = Utility:Create("TextBox", {
        Parent = pickerPanel,
        Name = "HexInput",
        Size = UDim2.new(1, -16, 0, 26),
        Position = UDim2.new(0, 8, 0, 136),
        BackgroundColor3 = theme.Input,
        Text = "#" .. currentColor:ToHex(),
        PlaceholderText = "#FFFFFF",
        PlaceholderColor3 = theme.TextDark,
        TextColor3 = theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        ZIndex = 51,
    })
    
    Utility:Create("UICorner", {
        Parent = hexInput,
        CornerRadius = UDim.new(0, 5),
    })
    
    local function updateColor()
        currentColor = Color3.fromHSV(hue, sat, val)
        colorPreview.BackgroundColor3 = currentColor
        svField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        svCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
        hueCursor.Position = UDim2.new(0.5, 0, hue, 0)
        hexInput.Text = "#" .. currentColor:ToHex()
        
        window.Flags[flag] = Utility:ColorToTable(currentColor)
        window.SaveSystem.Data[flag] = Utility:ColorToTable(currentColor)
        
        pcall(callback, currentColor)
    end
    
    -- SV Field interaction
    local svDragging = false
    
    local svInput = Utility:Create("TextButton", {
        Parent = svField,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 53,
        AutoButtonColor = false,
    })
    
    svInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            svDragging = true
            local relX = math.clamp((input.Position.X - svField.AbsolutePosition.X) / svField.AbsoluteSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - svField.AbsolutePosition.Y) / svField.AbsoluteSize.Y, 0, 1)
            sat = relX
            val = 1 - relY
            updateColor()
        end
    end)
    
    svInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            svDragging = false
        end
    end)
    
    -- Hue bar interaction
    local hueDragging = false
    
    local hueInput = Utility:Create("TextButton", {
        Parent = hueBar,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 53,
        AutoButtonColor = false,
    })
    
    hueInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = true
            local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
            hue = relY
            updateColor()
        end
    end)
    
    hueInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = false
        end
    end)
    
    -- Global input tracking for dragging
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            if svDragging then
                local relX = math.clamp((input.Position.X - svField.AbsolutePosition.X) / svField.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - svField.AbsolutePosition.Y) / svField.AbsoluteSize.Y, 0, 1)
                sat = relX
                val = 1 - relY
                updateColor()
            elseif hueDragging then
                local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                hue = relY
                updateColor()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            svDragging = false
            hueDragging = false
        end
    end)
    
    -- Hex input
    hexInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local hex = hexInput.Text:gsub("#", "")
            local success, color = pcall(function()
                return Color3.fromHex("#" .. hex)
            end)
            if success then
                hue, sat, val = Color3.toHSV(color)
                updateColor()
            else
                hexInput.Text = "#" .. currentColor:ToHex()
            end
        end
    end)
    
    -- Toggle picker
    local function togglePicker()
        pickerOpen = not pickerOpen
        
        if pickerOpen then
            pickerPanel.Visible = true
            Utility:Tween(pickerPanel, {Size = UDim2.new(1, 0, 0, 172)}, 0.25)
            Utility:Tween(colorFrame, {Size = UDim2.new(1, -4, 0, 34 + 176)}, 0.25)
        else
            Utility:Tween(pickerPanel, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            Utility:Tween(colorFrame, {Size = UDim2.new(1, -4, 0, 34)}, 0.2)
            task.delay(0.2, function()
                if not pickerOpen then
                    pickerPanel.Visible = false
                end
            end)
        end
    end
    
    button.MouseButton1Click:Connect(function()
        Utility:Ripple(colorFrame, Mouse.X, Mouse.Y)
        togglePicker()
    end)
    
    -- Hover
    button.MouseEnter:Connect(function()
        Utility:Tween(colorFrame, {BackgroundColor3 = theme.ElementHover}, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Utility:Tween(colorFrame, {BackgroundColor3 = theme.Element}, 0.15)
    end)
    
    -- Register save
    window.SaveSystem:Register(flag, "Color", Utility:ColorToTable(default))
    window.Flags[flag] = Utility:ColorToTable(currentColor)
    window.SaveSystem.Data[flag] = Utility:ColorToTable(currentColor)
    
    local element = {
        Type = "ColorPicker",
        Frame = colorFrame,
        Flag = flag,
        Value = currentColor,
    }
    
    function element:Set(color, skipCallback)
        if type(color) == "table" then
            color = Color3.new(color.R or 0, color.G or 0, color.B or 0)
        end
        hue, sat, val = Color3.toHSV(color)
        currentColor = color
        colorPreview.BackgroundColor3 = color
        svField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        svCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
        hueCursor.Position = UDim2.new(0.5, 0, hue, 0)
        hexInput.Text = "#" .. color:ToHex()
        
        window.Flags[flag] = Utility:ColorToTable(color)
        window.SaveSystem.Data[flag] = Utility:ColorToTable(color)
        self.Value = color
        if not skipCallback then
            pcall(callback, color)
        end
    end
    
    function element:Get()
        return currentColor
    end
    
    window.Elements[flag] = element
    table.insert(self.Elements, element)
    
    pcall(callback, default)
    
    return element
end

-- ═══════════════════════════════════════════════════════════════
-- LOAD SAVED CONFIG
-- ═══════════════════════════════════════════════════════════════
function Window:_LoadSavedConfig()
    local loaded = self.SaveSystem:Load()
    if not loaded then return end
    
    for flag, element in pairs(self.Elements) do
        local savedValue = self.SaveSystem.Data[flag]
        if savedValue ~= nil then
            pcall(function()
                if element.Type == "Toggle" then
                    if type(savedValue) == "boolean" then
                        element:Set(savedValue)
                    end
                elseif element.Type == "Slider" then
                    if type(savedValue) == "number" then
                        element:Set(savedValue)
                    end
                elseif element.Type == "Dropdown" then
                    element:Set(savedValue)
                elseif element.Type == "Textbox" then
                    if type(savedValue) == "string" then
                        element:Set(savedValue)
                    end
                elseif element.Type == "Keybind" then
                    if type(savedValue) == "string" then
                        element:Set(savedValue)
                    end
                elseif element.Type == "ColorPicker" then
                    if type(savedValue) == "table" then
                        local color = Color3.new(savedValue.R or 0, savedValue.G or 0, savedValue.B or 0)
                        element:Set(color)
                    end
                end
            end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════
function Window:Notify(options)
    options = options or {}
    local theme = self.Theme
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info" -- Info, Success, Error, Warning
    
    local typeColors = {
        Info = theme.Accent,
        Success = theme.Success,
        Error = theme.Error,
        Warning = theme.Warning,
    }
    
    local accentColor = typeColors[notifType] or theme.Accent
    
    local notifFrame = Utility:Create("Frame", {
        Parent = self.NotificationContainer,
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = theme.Notification,
        BorderSizePixel = 0,
        ZIndex = 301,
        BackgroundTransparency = 1,
    })
    
    Utility:Create("UICorner", {
        Parent = notifFrame,
        CornerRadius = UDim.new(0, 8),
    })
    
    Utility:Create("UIStroke", {
        Parent = notifFrame,
        Color = theme.Divider,
        Thickness = 1,
        Transparency = 1,
    })
    
    -- Accent line
    local accentLine = Utility:Create("Frame", {
        Parent = notifFrame,
        Size = UDim2.new(0, 3, 0.7, 0),
        Position = UDim2.new(0, 6, 0.15, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = 302,
        BackgroundTransparency = 1,
    })
    
    Utility:Create("UICorner", {
        Parent = accentLine,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Parent = notifFrame,
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 16, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 302,
        TextTransparency = 1,
    })
    
    -- Message
    local msgLabel = Utility:Create("TextLabel", {
        Parent = notifFrame,
        Size = UDim2.new(1, -24, 0, 30),
        Position = UDim2.new(0, 16, 0, 28),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 302,
        TextTransparency = 1,
    })
    
    -- Progress bar
    local progressBg = Utility:Create("Frame", {
        Parent = notifFrame,
        Size = UDim2.new(1, -16, 0, 3),
        Position = UDim2.new(0, 8, 1, -8),
        BackgroundColor3 = theme.SliderBar,
        BorderSizePixel = 0,
        ZIndex = 302,
        BackgroundTransparency = 1,
    })
    
    Utility:Create("UICorner", {
        Parent = progressBg,
        CornerRadius = UDim.new(1, 0),
    })
    
    local progressFill = Utility:Create("Frame", {
        Parent = progressBg,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = 303,
        BackgroundTransparency = 1,
    })
    
    Utility:Create("UICorner", {
        Parent = progressFill,
        CornerRadius = UDim.new(1, 0),
    })
    
    -- Animate in
    Utility:Tween(notifFrame, {BackgroundTransparency = 0}, 0.3)
    Utility:Tween(notifFrame:FindFirstChildOfClass("UIStroke"), {Transparency = 0}, 0.3)
    Utility:Tween(accentLine, {BackgroundTransparency = 0}, 0.3)
    Utility:Tween(titleLabel, {TextTransparency = 0}, 0.3)
    Utility:Tween(msgLabel, {TextTransparency = 0}, 0.3)
    Utility:Tween(progressBg, {BackgroundTransparency = 0}, 0.3)
    Utility:Tween(progressFill, {BackgroundTransparency = 0}, 0.3)
    
    -- Progress animation
    Utility:Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto dismiss
    task.delay(duration, function()
        Utility:Tween(notifFrame, {BackgroundTransparency = 1}, 0.3)
        pcall(function()
            Utility:Tween(notifFrame:FindFirstChildOfClass("UIStroke"), {Transparency = 1}, 0.3)
        end)
        Utility:Tween(accentLine, {BackgroundTransparency = 1}, 0.3)
        Utility:Tween(titleLabel, {TextTransparency = 1}, 0.3)
        Utility:Tween(msgLabel, {TextTransparency = 1}, 0.3)
        Utility:Tween(progressBg, {BackgroundTransparency = 1}, 0.3)
        Utility:Tween(progressFill, {BackgroundTransparency = 1}, 0.3)
        
        task.wait(0.35)
        Utility:TweenWait(notifFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        notifFrame:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- CONFIG SYSTEM (Window:AddConfig)
-- ═══════════════════════════════════════════════════════════════
function Window:AddConfig()
    local theme = self.Theme
    local window = self
    
    -- Create Config tab
    local configTab = self:AddTab({
        Name = "⚙ Settings",
        Icon = Icons.Settings,
    })
    
    self.ConfigTab = configTab
    
    -- Theme section
    local themeSection = configTab:AddSection({Name = "Theme"})
    
    local themeNames = ThemeManager:GetThemeNames()
    
    themeSection:AddDropdown({
        Text = "Select Theme",
        Items = themeNames,
        Default = self.ThemeName,
        Flag = "_ConfigTheme",
        Callback = function(selected)
            window:_ApplyTheme(selected)
        end,
    })
    
    -- UI Settings section
    local uiSection = configTab:AddSection({Name = "UI Settings"})
    
    uiSection:AddButton({
        Text = "Save Config",
        Callback = function()
            window.SaveSystem:Save()
            window:Notify({
                Title = "Config Saved",
                Message = "Your configuration has been saved successfully!",
                Duration = 3,
                Type = "Success",
            })
        end,
    })
    
    uiSection:AddButton({
        Text = "Load Config",
        Callback = function()
            window:_LoadSavedConfig()
            window:Notify({
                Title = "Config Loaded",
                Message = "Your configuration has been loaded!",
                Duration = 3,
                Type = "Info",
            })
        end,
    })
    
    uiSection:AddButton({
        Text = "Reset Config",
        Callback = function()
            local filePath = window.SaveSystem.FilePath
            FileSystem:DeleteFile(filePath)
            window:Notify({
                Title = "Config Reset",
                Message = "Configuration file has been deleted. Restart to apply defaults.",
                Duration = 4,
                Type = "Warning",
            })
        end,
    })
    
    -- Info section
    local infoSection = configTab:AddSection({Name = "Information"})
    
    infoSection:AddLabel({Text = "Supernova UI Library v" .. SupernovaUI.Version})
    infoSection:AddLabel({Text = "Developed by Senior Luau Dev"})
    infoSection:AddLabel({Text = "Player: " .. Player.Name})
    
    return configTab
end

-- ═══════════════════════════════════════════════════════════════
-- APPLY THEME
-- ═══════════════════════════════════════════════════════════════
function Window:_ApplyTheme(themeName)
    local newTheme = ThemeManager:GetTheme(themeName)
    if not newTheme then return end
    
    self.ThemeName = themeName
    self.Theme = newTheme
    
    local function applyToDescendants(parent)
        for _, child in pairs(parent:GetDescendants()) do
            pcall(function()
                -- Main backgrounds
                if child.Name == "MainFrame" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.Background}, 0.3)
                end
                
                if child.Name == "TopBar" or child.Name == "BottomFix" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.TopBar}, 0.3)
                end
                
                if child.Name == "TabContainer" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.Section}, 0.3)
                end
                
                if child.Name == "Divider" or child.Name == "AccentLine" then
                    if child.Name == "AccentLine" then
                        Utility:Tween(child, {BackgroundColor3 = newTheme.Accent}, 0.3)
                    else
                        Utility:Tween(child, {BackgroundColor3 = newTheme.Divider}, 0.3)
                    end
                end
                
                -- Sections
                if child.Name:find("Section_") then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.Section}, 0.3)
                end
                
                -- Elements
                if child.Name:find("Toggle_") or child.Name:find("Slider_") or 
                   child.Name:find("Button_") or child.Name:find("Dropdown_") or 
                   child.Name:find("Textbox_") or child.Name:find("Keybind_") or 
                   child.Name:find("ColorPicker_") then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.Element}, 0.3)
                end
                
                -- Text colors
                if child:IsA("TextLabel") then
                    if child.Name == "Title" or child.Name == "Label" then
                        Utility:Tween(child, {TextColor3 = newTheme.Text}, 0.3)
                    end
                    if child.Name == "SubTitle" or child.Name == "Value" or 
                       child.Name == "Selected" or child.Name == "Arrow" then
                        Utility:Tween(child, {TextColor3 = newTheme.TextDark}, 0.3)
                    end
                end
                
                -- UIStroke
                if child:IsA("UIStroke") then
                    Utility:Tween(child, {Color = newTheme.Divider}, 0.3)
                end
                
                -- Input backgrounds
                if child.Name == "InputBg" or child.Name == "Input" then
                    if child:IsA("Frame") then
                        Utility:Tween(child, {BackgroundColor3 = newTheme.Input}, 0.3)
                    end
                end
                
                -- Slider bars
                if child.Name == "BarBg" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.SliderBar}, 0.3)
                end
                if child.Name == "Fill" and child.Parent.Name == "BarBg" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.SliderFill}, 0.3)
                end
                
                -- Toggle switch
                if child.Name == "SwitchBg" then
                    -- Check if toggle is enabled by checking knob position
                    local knob = child:FindFirstChild("Knob")
                    if knob then
                        local isOn = knob.Position.X.Scale > 0.5
                        Utility:Tween(child, {
                            BackgroundColor3 = isOn and newTheme.ToggleEnabled or newTheme.Toggle
                        }, 0.3)
                    end
                end
                
                -- Indicator
                if child.Name == "Indicator" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.Accent}, 0.3)
                end
                
                -- Shadow
                if child.Name == "Shadow" then
                    child.ImageColor3 = newTheme.Shadow
                end
                
                -- Dropdown backgrounds
                if child.Name == "Options" or child.Name == "PickerPanel" then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.DropdownBG}, 0.3)
                end
                
                -- Dropdown options
                if child.Name:find("Option_") then
                    Utility:Tween(child, {BackgroundColor3 = newTheme.DropdownOption}, 0.3)
                end
                
                -- ScrollBar colors
                if child:IsA("ScrollingFrame") then
                    child.ScrollBarImageColor3 = newTheme.Accent
                end
            end)
        end
    end
    
    -- Update tab button colors
    for _, tab in pairs(self.Tabs) do
        if tab.Active then
            Utility:Tween(tab.Button, {BackgroundColor3 = newTheme.TabActive}, 0.3)
            Utility:Tween(tab.Label, {TextColor3 = newTheme.Text}, 0.3)
        else
            Utility:Tween(tab.Button, {BackgroundColor3 = newTheme.TabInactive}, 0.3)
            Utility:Tween(tab.Label, {TextColor3 = newTheme.TextDark}, 0.3)
        end
        Utility:Tween(tab.Indicator, {BackgroundColor3 = newTheme.Accent}, 0.3)
    end
    
    applyToDescendants(self.ScreenGui)
    
    -- Save theme preference
    self.SaveSystem.Data["_ConfigTheme"] = themeName
end

-- ═══════════════════════════════════════════════════════════════
-- DESTROY / TOGGLE VISIBILITY
-- ═══════════════════════════════════════════════════════════════
function Window:Destroy()
    self.SaveSystem:Save()
    self.SaveSystem:StopAutoSave()
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

function Window:Toggle(visible)
    if self.MainFrame then
        if visible == nil then
            visible = not self.MainFrame.Visible
        end
        
        if visible then
            self.MainFrame.Visible = true
            Utility:Tween(self.MainFrame, {BackgroundTransparency = 0}, 0.3)
        else
            Utility:TweenWait(self.MainFrame, {BackgroundTransparency = 1}, 0.3)
            self.MainFrame.Visible = false
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- TOGGLE KEYBIND (Show/Hide UI)
-- ═══════════════════════════════════════════════════════════════
function Window:SetToggleKey(keyCode)
    keyCode = keyCode or Enum.KeyCode.RightControl
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keyCode then
            self:Toggle()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- MOBILE TOGGLE BUTTON
-- ═══════════════════════════════════════════════════════════════
function Window:AddMobileToggle()
    local theme = self.Theme
    
    local toggleBtn = Utility:Create("TextButton", {
        Parent = self.ScreenGui,
        Name = "MobileToggle",
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0, 15, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.2,
        Text = "S",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 999,
        AutoButtonColor = false,
    })
    
    Utility:Create("UICorner", {
        Parent = toggleBtn,
        CornerRadius = UDim.new(0.5, 0),
    })
    
    -- Make draggable
    Utility:MakeDraggable(toggleBtn, toggleBtn)
    
    toggleBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    return toggleBtn
end

-- ═══════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════
return SupernovaUI
