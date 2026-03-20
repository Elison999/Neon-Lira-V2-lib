--[[
    ██╗      ██████╗ ██╗         ██╗  ██╗██╗   ██╗██████╗ 
    ██║     ██╔═══██╗██║         ██║  ██║██║   ██║██╔══██╗
    ██║     ██║   ██║██║         ███████║██║   ██║██████╔╝
    ██║     ██║   ██║██║         ██╔══██║██║   ██║██╔══██╗
    ███████╗╚██████╔╝███████╗    ██║  ██║╚██████╔╝██████╔╝
    ╚══════╝ ╚═════╝ ╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    LolHub UI Library - Ultra Pro Max Edition v2.0
    By: LolHub Dev Team
    Features: 12 Elements | Key System | Auto Save | Themes | Loading Screen
]]

local LolHub = {}
LolHub.__index = LolHub

-- ═══════════════════════════════════════════════════
--              SERVICES & VARIABLES
-- ═══════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════
--              THEME DEFINITIONS
-- ═══════════════════════════════════════════════════
local Themes = {
    ["Dark Neon"] = {
        Background = Color3.fromRGB(12, 12, 20),
        TopBar = Color3.fromRGB(18, 18, 30),
        Accent = Color3.fromRGB(100, 60, 255),
        AccentGlow = Color3.fromRGB(130, 90, 255),
        Text = Color3.fromRGB(240, 240, 255),
        SubText = Color3.fromRGB(160, 160, 190),
        Element = Color3.fromRGB(22, 22, 38),
        ElementHover = Color3.fromRGB(30, 30, 50),
        Border = Color3.fromRGB(60, 40, 120),
        Toggle_ON = Color3.fromRGB(100, 60, 255),
        Toggle_OFF = Color3.fromRGB(50, 50, 70),
        Slider = Color3.fromRGB(100, 60, 255),
        Dropdown = Color3.fromRGB(22, 22, 38),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(20, 20, 35),
    },
    ["Midnight Blue"] = {
        Background = Color3.fromRGB(8, 10, 22),
        TopBar = Color3.fromRGB(12, 16, 35),
        Accent = Color3.fromRGB(30, 100, 255),
        AccentGlow = Color3.fromRGB(60, 130, 255),
        Text = Color3.fromRGB(230, 235, 255),
        SubText = Color3.fromRGB(140, 155, 200),
        Element = Color3.fromRGB(14, 18, 40),
        ElementHover = Color3.fromRGB(20, 25, 55),
        Border = Color3.fromRGB(30, 60, 130),
        Toggle_ON = Color3.fromRGB(30, 100, 255),
        Toggle_OFF = Color3.fromRGB(30, 35, 70),
        Slider = Color3.fromRGB(30, 100, 255),
        Dropdown = Color3.fromRGB(14, 18, 40),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(12, 16, 35),
    },
    ["Crimson Red"] = {
        Background = Color3.fromRGB(18, 8, 8),
        TopBar = Color3.fromRGB(28, 10, 10),
        Accent = Color3.fromRGB(220, 30, 60),
        AccentGlow = Color3.fromRGB(255, 60, 90),
        Text = Color3.fromRGB(255, 235, 235),
        SubText = Color3.fromRGB(200, 160, 160),
        Element = Color3.fromRGB(30, 12, 12),
        ElementHover = Color3.fromRGB(40, 18, 18),
        Border = Color3.fromRGB(130, 30, 40),
        Toggle_ON = Color3.fromRGB(220, 30, 60),
        Toggle_OFF = Color3.fromRGB(70, 30, 35),
        Slider = Color3.fromRGB(220, 30, 60),
        Dropdown = Color3.fromRGB(30, 12, 12),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(25, 10, 10),
    },
    ["Forest Green"] = {
        Background = Color3.fromRGB(8, 16, 10),
        TopBar = Color3.fromRGB(10, 22, 14),
        Accent = Color3.fromRGB(30, 180, 80),
        AccentGlow = Color3.fromRGB(60, 210, 110),
        Text = Color3.fromRGB(230, 255, 235),
        SubText = Color3.fromRGB(150, 200, 160),
        Element = Color3.fromRGB(12, 22, 14),
        ElementHover = Color3.fromRGB(18, 32, 20),
        Border = Color3.fromRGB(30, 100, 50),
        Toggle_ON = Color3.fromRGB(30, 180, 80),
        Toggle_OFF = Color3.fromRGB(25, 55, 35),
        Slider = Color3.fromRGB(30, 180, 80),
        Dropdown = Color3.fromRGB(12, 22, 14),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(10, 18, 12),
    },
    ["Cyberpunk Gold"] = {
        Background = Color3.fromRGB(14, 12, 5),
        TopBar = Color3.fromRGB(20, 18, 6),
        Accent = Color3.fromRGB(255, 200, 0),
        AccentGlow = Color3.fromRGB(255, 220, 50),
        Text = Color3.fromRGB(255, 250, 220),
        SubText = Color3.fromRGB(200, 190, 140),
        Element = Color3.fromRGB(20, 18, 6),
        ElementHover = Color3.fromRGB(30, 26, 10),
        Border = Color3.fromRGB(130, 100, 0),
        Toggle_ON = Color3.fromRGB(255, 200, 0),
        Toggle_OFF = Color3.fromRGB(70, 60, 20),
        Slider = Color3.fromRGB(255, 200, 0),
        Dropdown = Color3.fromRGB(20, 18, 6),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(16, 14, 5),
    },
    ["Ocean Teal"] = {
        Background = Color3.fromRGB(5, 16, 20),
        TopBar = Color3.fromRGB(6, 22, 28),
        Accent = Color3.fromRGB(0, 190, 200),
        AccentGlow = Color3.fromRGB(30, 220, 230),
        Text = Color3.fromRGB(220, 250, 255),
        SubText = Color3.fromRGB(140, 200, 210),
        Element = Color3.fromRGB(7, 20, 26),
        ElementHover = Color3.fromRGB(10, 28, 36),
        Border = Color3.fromRGB(0, 100, 120),
        Toggle_ON = Color3.fromRGB(0, 190, 200),
        Toggle_OFF = Color3.fromRGB(15, 55, 65),
        Slider = Color3.fromRGB(0, 190, 200),
        Dropdown = Color3.fromRGB(7, 20, 26),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(6, 16, 20),
    },
    ["Rose Pink"] = {
        Background = Color3.fromRGB(20, 10, 15),
        TopBar = Color3.fromRGB(28, 14, 20),
        Accent = Color3.fromRGB(255, 80, 150),
        AccentGlow = Color3.fromRGB(255, 110, 175),
        Text = Color3.fromRGB(255, 235, 245),
        SubText = Color3.fromRGB(210, 165, 190),
        Element = Color3.fromRGB(28, 14, 20),
        ElementHover = Color3.fromRGB(38, 20, 28),
        Border = Color3.fromRGB(140, 40, 90),
        Toggle_ON = Color3.fromRGB(255, 80, 150),
        Toggle_OFF = Color3.fromRGB(80, 35, 60),
        Slider = Color3.fromRGB(255, 80, 150),
        Dropdown = Color3.fromRGB(28, 14, 20),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(22, 11, 16),
    },
    ["White Minimal"] = {
        Background = Color3.fromRGB(245, 245, 250),
        TopBar = Color3.fromRGB(230, 230, 240),
        Accent = Color3.fromRGB(80, 80, 200),
        AccentGlow = Color3.fromRGB(110, 110, 230),
        Text = Color3.fromRGB(20, 20, 40),
        SubText = Color3.fromRGB(100, 100, 130),
        Element = Color3.fromRGB(235, 235, 245),
        ElementHover = Color3.fromRGB(220, 220, 235),
        Border = Color3.fromRGB(200, 200, 220),
        Toggle_ON = Color3.fromRGB(80, 80, 200),
        Toggle_OFF = Color3.fromRGB(180, 180, 200),
        Slider = Color3.fromRGB(80, 80, 200),
        Dropdown = Color3.fromRGB(235, 235, 245),
        Shadow = Color3.fromRGB(150, 150, 180),
        Notification = Color3.fromRGB(230, 230, 240),
    },
    ["Orange Blaze"] = {
        Background = Color3.fromRGB(16, 9, 3),
        TopBar = Color3.fromRGB(22, 12, 4),
        Accent = Color3.fromRGB(255, 120, 20),
        AccentGlow = Color3.fromRGB(255, 150, 50),
        Text = Color3.fromRGB(255, 245, 230),
        SubText = Color3.fromRGB(210, 180, 140),
        Element = Color3.fromRGB(22, 12, 4),
        ElementHover = Color3.fromRGB(32, 18, 6),
        Border = Color3.fromRGB(140, 65, 10),
        Toggle_ON = Color3.fromRGB(255, 120, 20),
        Toggle_OFF = Color3.fromRGB(80, 45, 15),
        Slider = Color3.fromRGB(255, 120, 20),
        Dropdown = Color3.fromRGB(22, 12, 4),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(18, 10, 3),
    },
    ["Ice Purple"] = {
        Background = Color3.fromRGB(10, 8, 18),
        TopBar = Color3.fromRGB(16, 12, 28),
        Accent = Color3.fromRGB(160, 80, 255),
        AccentGlow = Color3.fromRGB(185, 110, 255),
        Text = Color3.fromRGB(240, 230, 255),
        SubText = Color3.fromRGB(170, 150, 210),
        Element = Color3.fromRGB(18, 14, 32),
        ElementHover = Color3.fromRGB(26, 20, 45),
        Border = Color3.fromRGB(90, 50, 150),
        Toggle_ON = Color3.fromRGB(160, 80, 255),
        Toggle_OFF = Color3.fromRGB(55, 40, 90),
        Slider = Color3.fromRGB(160, 80, 255),
        Dropdown = Color3.fromRGB(18, 14, 32),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(13, 10, 22),
    },
}

-- ═══════════════════════════════════════════════════
--              UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════
local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.25,
        Enum.EasingStyle[style or "Quart"],
        Enum.EasingDirection[direction or "Out"]
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 40, 120)
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function AddGlow(parent, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 19, 1, 19)
    glow.Position = UDim2.new(0, -9, 0, -9)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857472"
    glow.ImageColor3 = color or Color3.fromRGB(100, 60, 255)
    glow.ImageTransparency = 0.7
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    return glow
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, mousePos, framePos

    local function beginDrag(pos)
        dragging = true
        mousePos = pos
        framePos = frame.Position
    end

    local function endDrag()
        dragging = false
    end

    local function moveDrag(pos)
        if dragging and mousePos then
            local delta = pos - mousePos
            -- Clamp so window stays on screen
            local screen = GetScreenSize()
            local absSize = frame.AbsoluteSize
            local newX = math.clamp(framePos.X.Offset + delta.X, 0, screen.X - absSize.X)
            local newY = math.clamp(framePos.Y.Offset + delta.Y, 0, screen.Y - absSize.Y)
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end

    -- Mouse support
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            beginDrag(input.Position)
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            moveDrag(input.Position)
        end
    end)

    -- Touch support (mobile)
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(input.Position)
            dragInput = input
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            moveDrag(input.Position)
        end
    end)
end

local function SaveFile(filename, data)
    if writefile then
        local success = pcall(function()
            writefile(filename, HttpService:JSONEncode(data))
        end)
        return success
    end
    return false
end

local function LoadFile(filename)
    if readfile and isfile then
        if isfile(filename) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(filename))
            end)
            if success then return data end
        end
    end
    return nil
end

local function FetchFromSite(url)
    if request then
        local success, result = pcall(function()
            return request({ Url = url, Method = "GET" })
        end)
        if success and result and result.StatusCode == 200 then
            return result.Body
        end
    elseif syn and syn.request then
        local success, result = pcall(function()
            return syn.request({ Url = url, Method = "GET" })
        end)
        if success and result and result.StatusCode == 200 then
            return result.Body
        end
    end

-- ═══════════════════════════════════════════════════
--              MOBILE / SCREEN DETECTION
-- ═══════════════════════════════════════════════════
local ScreenGui_Ref  -- set after ScreenGui is created
local Camera = workspace.CurrentCamera

local function GetScreenSize()
    return Camera.ViewportSize
end

local function IsMobile()
    local screen = GetScreenSize()
    return screen.X <= 500 or screen.Y <= 600
end

local function ScaleForScreen(pixelVal)
    -- Scales a pixel value relative to a 390px reference width
    local screen = GetScreenSize()
    local refWidth = 390
    local scale = math.clamp(screen.X / refWidth, 0.6, 1.2)
    return math.round(pixelVal * scale)
end

local function MobileUDim2(xScale, xOff, yScale, yOff)
    local screen = GetScreenSize()
    local refW, refH = 390, 700
    local scaleX = math.clamp(screen.X / refW, 0.55, 1.3)
    local scaleY = math.clamp(screen.Y / refH, 0.55, 1.3)
    return UDim2.new(xScale, math.round(xOff * scaleX), yScale, math.round(yOff * scaleY))
end

    return nil
end

-- ═══════════════════════════════════════════════════
--              MAIN LIBRARY INIT
-- ═══════════════════════════════════════════════════
function LolHub:Init(config)
    config = config or {}
    
    -- Config defaults
    self.Config = {
        -- Key System
        KeyEnable = config.KeyEnable or false,
        Key = config.Key or "1234",
        KeyName = config.KeyName or "KeySystem",
        KeySave = config.KeySave or false,
        KeyFileName = config.KeyFileName or "LolHub.json",
        GetKeyFromSite = config.GetKeyFromSite or false,
        KeySite = config.KeySite or "",
        
        -- Loading Screen
        LoadingName = config.LoadingName or "Loading LolHub",
        ImageId = config.ImageId or "rbxassetid://0",
        
        -- AutoSave
        AutoSaveLoad = config.AutoSaveLoad or false,
        AutoSaveFile = config.AutoSaveFile or "LolHub_Save.json",
        
        -- Theme
        Theme = config.Theme or "Dark Neon",
        BlurBackground = config.BlurBackground or false,
        
        -- Window
        Title = config.Title or "LolHub",
        WindowIcon = config.WindowIcon or "rbxassetid://0",
    }
    
    self.Flags = {}
    self.Connections = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.Windows = {}
    self.Notifications = {}
    self.KeyVerified = not self.Config.KeyEnable
    self.SaveData = {}
    
    -- Load theme
    self.Theme = Themes[self.Config.Theme] or Themes["Dark Neon"]
    
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "LolHub_UI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    
    pcall(function()
        gui.Parent = CoreGui
    end)
    if not gui.Parent then
        gui.Parent = LocalPlayer.PlayerGui
    end
    
    self.ScreenGui = gui
    
    -- Load auto save data
    if self.Config.AutoSaveLoad then
        local saved = LoadFile(self.Config.AutoSaveFile)
        if saved then self.SaveData = saved end
    end
    
    -- Show loading screen
    self:ShowLoadingScreen()
    
    return self
end

-- ═══════════════════════════════════════════════════
--              LOADING SCREEN
-- ═══════════════════════════════════════════════════
function LolHub:ShowLoadingScreen()
    local theme = self.Theme
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingScreen"
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = theme.Background
    loadingFrame.BorderSizePixel = 0
    loadingFrame.ZIndex = 200
    loadingFrame.Parent = self.ScreenGui
    
    -- Animated background pattern
    local bgPattern = Instance.new("Frame")
    bgPattern.Size = UDim2.new(1, 0, 1, 0)
    bgPattern.BackgroundTransparency = 1
    bgPattern.ZIndex = 201
    bgPattern.Parent = loadingFrame
    
    -- Center container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0.78, 0, 0.44, 0)
    container.Position = UDim2.new(0.5, -106, 0.5, -106)
    container.BackgroundColor3 = theme.TopBar
    container.BorderSizePixel = 0
    container.ZIndex = 202
    container.Parent = loadingFrame
    AddCorner(container, 12)
    AddStroke(container, theme.Accent, 2)
    AddGlow(container, theme.Accent)
    
    -- Spinning ring
    local ringOuter = Instance.new("ImageLabel")
    ringOuter.Size = UDim2.new(0, 100, 0, 100)
    ringOuter.Position = UDim2.new(0.5, -50, 0, 19)
    ringOuter.BackgroundTransparency = 1
    ringOuter.Image = "rbxassetid://4965945816"
    ringOuter.ImageColor3 = theme.Accent
    ringOuter.ImageTransparency = 0.3
    ringOuter.ZIndex = 203
    ringOuter.Parent = container
    
    -- Logo/Image
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(0, 69, 0, 69)
    logoFrame.Position = UDim2.new(0.5, -34, 0, 34)
    logoFrame.BackgroundColor3 = theme.Element
    logoFrame.ZIndex = 204
    logoFrame.Parent = container
    AddCorner(logoFrame, 34)
    
    local logoImage = Instance.new("ImageLabel")
    logoImage.Size = UDim2.new(0, 50, 0, 50)
    logoImage.Position = UDim2.new(0.5, -25, 0.5, -25)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = self.Config.ImageId ~= "" and ("rbxassetid://" .. self.Config.ImageId) or "rbxasset://textures/loading/robloxTilt.png"
    logoImage.ZIndex = 205
    logoImage.Parent = logoFrame
    
    -- Loading text
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Size = UDim2.new(1, -12, 0, 19)
    loadingTitle.Position = UDim2.new(0, 6, 0, 125)
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Text = self.Config.LoadingName
    loadingTitle.TextColor3 = theme.Text
    loadingTitle.TextSize = 14
    loadingTitle.Font = Enum.Font.GothamBold
    loadingTitle.TextXAlignment = Enum.TextXAlignment.Center
    loadingTitle.ZIndex = 203
    loadingTitle.Parent = container
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -12, 0, 14)
    statusLabel.Position = UDim2.new(0, 6, 0, 146)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Initializing..."
    statusLabel.TextColor3 = theme.SubText
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.ZIndex = 203
    statusLabel.Parent = container
    
    -- Progress bar bg
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 175, 0, 4)
    progressBg.Position = UDim2.new(0.5, -88, 0, 168)
    progressBg.BackgroundColor3 = theme.Element
    progressBg.BorderSizePixel = 0
    progressBg.ZIndex = 203
    progressBg.Parent = container
    AddCorner(progressBg, 4)
    
    -- Progress bar fill
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = theme.Accent
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 204
    progressFill.Parent = progressBg
    AddCorner(progressFill, 4)
    
    -- Version label
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, -12, 0, 12)
    versionLabel.Position = UDim2.new(0, 6, 0, 178)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v2.0 Ultra Pro Max"
    versionLabel.TextColor3 = theme.SubText
    versionLabel.TextSize = 10
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Center
    versionLabel.ZIndex = 203
    versionLabel.Parent = container
    
    -- Spin animation
    local spinConn
    local angle = 0
    spinConn = RunService.Heartbeat:Connect(function(dt)
        angle = angle + dt * 120
        ringOuter.Rotation = angle
    end)
    
    -- Loading steps
    local steps = {
        {text = "Loading modules...", progress = 0.2},
        {text = "Connecting to services...", progress = 0.45},
        {text = "Applying theme...", progress = 0.65},
        {text = "Loading configuration...", progress = 0.82},
        {text = "Ready!", progress = 1.0},
    }
    
    local stepIndex = 0
    local function nextStep()
        stepIndex = stepIndex + 1
        if stepIndex > #steps then return end
        local step = steps[stepIndex]
        statusLabel.Text = step.text
        Tween(progressFill, {Size = UDim2.new(step.progress, 0, 1, 0)}, 0.4)
    end
    
    nextStep()
    
    task.spawn(function()
        for i = 1, #steps do
            task.wait(0.55)
            nextStep()
        end
        task.wait(0.4)
        spinConn:Disconnect()
        
        -- Fade out
        Tween(loadingFrame, {BackgroundTransparency = 1}, 0.6)
        Tween(container, {BackgroundTransparency = 1}, 0.6)
        task.wait(0.7)
        loadingFrame:Destroy()
        
        -- Show key system or main UI
        if self.Config.KeyEnable and not self.KeyVerified then
            self:ShowKeySystem()
        else
            self:_OnReady()
        end
    end)
end

-- ═══════════════════════════════════════════════════
--              KEY SYSTEM
-- ═══════════════════════════════════════════════════
function LolHub:ShowKeySystem()
    local theme = self.Theme
    
    -- Check saved key
    if self.Config.KeySave then
        local saved = LoadFile(self.Config.KeyFileName)
        if saved and saved.key then
            local validKey = self.Config.Key
            if self.Config.GetKeyFromSite and self.Config.KeySite ~= "" then
                local siteKey = FetchFromSite(self.Config.KeySite)
                if siteKey then validKey = siteKey:gsub("%s+", "") end
            end
            if saved.key == validKey then
                self.KeyVerified = true
                self:_OnReady()
                return
            end
        end
    end
    
    -- Fetch key from site if needed
    local validKey = self.Config.Key
    if self.Config.GetKeyFromSite and self.Config.KeySite ~= "" then
        local siteKey = FetchFromSite(self.Config.KeySite)
        if siteKey then validKey = siteKey:gsub("%s+", "") end
    end
    
    -- Key UI
    local keyScreen = Instance.new("Frame")
    keyScreen.Name = "KeyScreen"
    keyScreen.Size = UDim2.new(1, 0, 1, 0)
    keyScreen.BackgroundColor3 = Color3.fromRGB(0,0,0)
    keyScreen.BackgroundTransparency = 0.4
    keyScreen.BorderSizePixel = 0
    keyScreen.ZIndex = 150
    keyScreen.Parent = self.ScreenGui
    
    local keyContainer = Instance.new("Frame")
    keyContainer.Size = UDim2.new(0.85, 0, 0.52, 0)
    keyContainer.Position = UDim2.new(0.5, -125, 0.5, -100)
    keyContainer.BackgroundColor3 = theme.TopBar
    keyContainer.BorderSizePixel = 0
    keyContainer.ZIndex = 151
    keyContainer.Parent = keyScreen
    AddCorner(keyContainer, 10)
    AddStroke(keyContainer, theme.Accent, 2)
    AddGlow(keyContainer, theme.Accent)
    
    -- Header
    local keyHeader = Instance.new("Frame")
    keyHeader.Size = UDim2.new(1, 0, 0, 38)
    keyHeader.BackgroundColor3 = theme.Accent
    keyHeader.BorderSizePixel = 0
    keyHeader.ZIndex = 152
    keyHeader.Parent = keyContainer
    AddCorner(keyHeader, 10)
    
    -- Fix rounded corners only top
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 12)
    headerFix.Position = UDim2.new(0, 0, 1, -12)
    headerFix.BackgroundColor3 = theme.Accent
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 152
    headerFix.Parent = keyHeader
    
    local keyNameLabel = Instance.new("TextLabel")
    keyNameLabel.Size = UDim2.new(1, 0, 1, 0)
    keyNameLabel.BackgroundTransparency = 1
    keyNameLabel.Text = "🔑  " .. self.Config.KeyName
    keyNameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    keyNameLabel.TextSize = 13
    keyNameLabel.Font = Enum.Font.GothamBold
    keyNameLabel.ZIndex = 153
    keyNameLabel.Parent = keyHeader
    
    -- Description
    local keyDesc = Instance.new("TextLabel")
    keyDesc.Size = UDim2.new(1, -19, 0, 25)
    keyDesc.Position = UDim2.new(0, 9, 0, 45)
    keyDesc.BackgroundTransparency = 1
    keyDesc.Text = "This script requires a valid key to run.\nEnter your key below to continue."
    keyDesc.TextColor3 = theme.SubText
    keyDesc.TextSize = 10
    keyDesc.Font = Enum.Font.Gotham
    keyDesc.TextXAlignment = Enum.TextXAlignment.Left
    keyDesc.TextWrapped = true
    keyDesc.ZIndex = 152
    keyDesc.Parent = keyContainer
    
    -- Get Key button (if site configured)
    if self.Config.GetKeyFromSite and self.Config.KeySite ~= "" then
        local getKeyBtn = Instance.new("TextButton")
        getKeyBtn.Size = UDim2.new(0, 100, 0, 20)
        getKeyBtn.Position = UDim2.new(0.5, -50, 0, 74)
        getKeyBtn.BackgroundColor3 = theme.Element
        getKeyBtn.Text = "🌐  Get Key"
        getKeyBtn.TextColor3 = theme.Accent
        getKeyBtn.TextSize = 10
        getKeyBtn.Font = Enum.Font.GothamBold
        getKeyBtn.BorderSizePixel = 0
        getKeyBtn.ZIndex = 152
        getKeyBtn.Parent = keyContainer
        AddCorner(getKeyBtn, 5)
        AddStroke(getKeyBtn, theme.Accent, 1)
        
        getKeyBtn.MouseButton1Click:Connect(function()
            setclipboard(self.Config.KeySite)
            self:Notify("Key Site", "Link copied to clipboard!", 3, "success")
        end)
    end
    
    -- Input box
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, -19, 0, 29)
    inputBg.Position = UDim2.new(0, 9, 0, 102)
    inputBg.BackgroundColor3 = theme.Element
    inputBg.BorderSizePixel = 0
    inputBg.ZIndex = 152
    inputBg.Parent = keyContainer
    AddCorner(inputBg, 6)
    AddStroke(inputBg, theme.Border, 1.5)
    
    local lockIcon = Instance.new("TextLabel")
    lockIcon.Size = UDim2.new(0, 19, 1, 0)
    lockIcon.Position = UDim2.new(0, 5, 0, 0)
    lockIcon.BackgroundTransparency = 1
    lockIcon.Text = "🔒"
    lockIcon.TextSize = 12
    lockIcon.Font = Enum.Font.Gotham
    lockIcon.ZIndex = 153
    lockIcon.Parent = inputBg
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -31, 1, -6)
    keyInput.Position = UDim2.new(0, 25, 0, 3)
    keyInput.BackgroundTransparency = 1
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.PlaceholderColor3 = theme.SubText
    keyInput.TextColor3 = theme.Text
    keyInput.TextSize = 11
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.ZIndex = 153
    keyInput.Parent = inputBg
    
    -- Status label
    local keyStatus = Instance.new("TextLabel")
    keyStatus.Size = UDim2.new(1, -19, 0, 14)
    keyStatus.Position = UDim2.new(0, 9, 0, 136)
    keyStatus.BackgroundTransparency = 1
    keyStatus.Text = ""
    keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    keyStatus.TextSize = 10
    keyStatus.Font = Enum.Font.Gotham
    keyStatus.TextXAlignment = Enum.TextXAlignment.Center
    keyStatus.ZIndex = 152
    keyStatus.Parent = keyContainer
    
    -- Submit button
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 100, 0, 28)
    submitBtn.Position = UDim2.new(0.5, -50, 0, 158)
    submitBtn.BackgroundColor3 = theme.Accent
    submitBtn.Text = "Verify Key"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.TextSize = 11
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.BorderSizePixel = 0
    submitBtn.ZIndex = 152
    submitBtn.Parent = keyContainer
    AddCorner(submitBtn, 6)
    
    local function verifyKey()
        local entered = keyInput.Text:gsub("%s+", "")
        if entered == validKey then
            keyStatus.Text = "✔ Key accepted!"
            keyStatus.TextColor3 = Color3.fromRGB(80, 220, 80)
            Tween(submitBtn, {BackgroundColor3 = Color3.fromRGB(60, 180, 60)}, 0.3)
            
            if self.Config.KeySave then
                SaveFile(self.Config.KeyFileName, {key = entered})
            end
            
            task.wait(0.8)
            Tween(keyScreen, {BackgroundTransparency = 1}, 0.5)
            task.wait(0.6)
            keyScreen:Destroy()
            self.KeyVerified = true
            self:_OnReady()
        else
            keyStatus.Text = "✘ Invalid key. Try again."
            keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
            Tween(inputBg, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
            task.wait(0.4)
            Tween(inputBg, {BackgroundColor3 = theme.Element}, 0.3)
        end
    end
    
    submitBtn.MouseButton1Click:Connect(verifyKey)
    keyInput.FocusLost:Connect(function(enter)
        if enter then verifyKey() end
    end)
    
    -- Hover effect
    submitBtn.MouseEnter:Connect(function()
        Tween(submitBtn, {BackgroundColor3 = theme.AccentGlow}, 0.2)
    end)
    submitBtn.MouseLeave:Connect(function()
        Tween(submitBtn, {BackgroundColor3 = theme.Accent}, 0.2)
    end)
    
    -- Input focus glow
    keyInput.Focused:Connect(function()
        Tween(inputBg, {}, 0.2)
        local stroke = inputBg:FindFirstChildOfClass("UIStroke")
        if stroke then
            Tween(stroke, {Color = theme.Accent}, 0.2)
        end
    end)
    keyInput.FocusLost:Connect(function()
        local stroke = inputBg:FindFirstChildOfClass("UIStroke")
        if stroke then
            Tween(stroke, {Color = theme.Border}, 0.2)
        end
    end)
end

-- ═══════════════════════════════════════════════════
--              READY CALLBACK
-- ═══════════════════════════════════════════════════
function LolHub:_OnReady()
    -- Load auto-saved flags
    if self.Config.AutoSaveLoad and self.SaveData then
        for flag, val in pairs(self.SaveData) do
            self.Flags[flag] = val
        end
    end
    
    -- Fire any ready callbacks
    if self._readyCallback then
        self._readyCallback()
    end
end

function LolHub:OnReady(callback)
    self._readyCallback = callback
end

-- ═══════════════════════════════════════════════════
--              WINDOW CREATION
-- ═══════════════════════════════════════════════════
function LolHub:CreateWindow(windowConfig)
    windowConfig = windowConfig or {}
    local theme = self.Theme
    
    local winTitle = windowConfig.Title or self.Config.Title
    local winIcon  = windowConfig.Icon  or self.Config.WindowIcon

    -- ── Responsive layout detection ──────────────────
    local screen       = GetScreenSize()
    local isMobile     = screen.X <= 500
    local isSmallMob   = screen.X <= 320

    local TB_H         = isSmallMob and 24 or (isMobile and 26 or 28)   -- topbar height px
    local TAB_W        = isSmallMob and 76 or (isMobile and 82 or 88)   -- tab sidebar width px
    local ELEM_SPACING = isSmallMob and 4  or (isMobile and 5  or 8)    -- gap between elements

    local winSize = windowConfig.Size or (
        isSmallMob  and UDim2.new(0.98, 0, 0.88, 0) or
        isMobile    and UDim2.new(0.96, 0, 0.84, 0) or
        UDim2.new(0.92, 0, 0.82, 0)
    )
    local winPos  = windowConfig.Position or (
        isSmallMob  and UDim2.new(0.01, 0, 0.06, 0) or
        isMobile    and UDim2.new(0.02, 0, 0.08, 0) or
        UDim2.new(0.04, 0, 0.09, 0)
    )
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.IsMinimized = false
    Window.FullSize = winSize
    
    -- ─── Main Window Frame ───
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Window_" .. winTitle
    mainFrame.Size = winSize
    mainFrame.Position = winPos
    -- Convert to absolute position after first render for drag clamping
    task.defer(function()
        if mainFrame and mainFrame.Parent then
            local abs = mainFrame.AbsolutePosition
            mainFrame.Position = UDim2.new(0, abs.X, 0, abs.Y)
        end
    end)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BackgroundTransparency = self.Config.BlurBackground and 0.4 or 0
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 10
    mainFrame.Parent = self.ScreenGui
    AddCorner(mainFrame, 8)
    AddStroke(mainFrame, theme.Border, 1.5)
    
    local mainShadow = Instance.new("ImageLabel")
    mainShadow.Size = UDim2.new(1, 31, 1, 31)
    mainShadow.Position = UDim2.new(0, -16, 0, -16)
    mainShadow.BackgroundTransparency = 1
    mainShadow.Image = "rbxassetid://5028857472"
    mainShadow.ImageColor3 = Color3.fromRGB(0,0,0)
    mainShadow.ImageTransparency = 0.6
    mainShadow.ZIndex = 9
    mainShadow.Parent = mainFrame
    
    -- ─── Top Bar ───
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, TB_H)
    topBar.BackgroundColor3 = theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 11
    topBar.Parent = mainFrame
    AddCorner(topBar, 8)
    
    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, math.floor(TB_H/3))
    topBarFix.Position = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = theme.TopBar
    topBarFix.BorderSizePixel = 0
    topBarFix.ZIndex = 11
    topBarFix.Parent = topBar
    
    -- Accent line at bottom of topbar
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 1)
    accentLine.Position = UDim2.new(0, 0, 1, -1)
    accentLine.BackgroundColor3 = theme.Accent
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 12
    accentLine.Parent = topBar
    
    -- Icon
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Size = UDim2.new(0, isMobile and 16 or 18, 0, isMobile and 16 or 18)
    iconLabel.Position = UDim2.new(0, 6, 0.5, -9)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = winIcon ~= "" and ("rbxassetid://" .. winIcon) or ""
    iconLabel.ZIndex = 12
    iconLabel.Parent = topBar
    AddCorner(iconLabel, 4)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -94, 1, 0)
    titleLabel.Position = UDim2.new(0, winIcon ~= "" and 46 or 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = winTitle
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 12
    titleLabel.Parent = topBar
    
    -- ─── Window Buttons ───
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 62, 0, 19)
    btnContainer.Position = UDim2.new(1, -70, 0.5, -9)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ZIndex = 12
    btnContainer.Parent = topBar
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = btnContainer
    
    local function makeWindowBtn(icon, color, hoverColor, zIndex)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 18, 0, 18)
        btn.BackgroundColor3 = color
        btn.Text = icon
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.ZIndex = zIndex or 12
        btn.Parent = btnContainer
        AddCorner(btn, 4)
        
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = hoverColor}, 0.15)
            Tween(btn, {Size = UDim2.new(0, 19, 0, 19)}, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = color}, 0.15)
            Tween(btn, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
        end)
        return btn
    end
    
    -- Resize btn (green)
    local resizeBtn = makeWindowBtn("⤢", Color3.fromRGB(30, 160, 60), Color3.fromRGB(50, 200, 80))
    -- Minimize btn (yellow)
    local minimizeBtn = makeWindowBtn("─", Color3.fromRGB(200, 160, 0), Color3.fromRGB(240, 200, 0))
    -- Close btn (red)
    local closeBtn = makeWindowBtn("✕", Color3.fromRGB(200, 40, 40), Color3.fromRGB(240, 70, 70))
    
    -- Make draggable via topbar
    MakeDraggable(mainFrame, topBar)
    
    -- ─── Resize Button Logic ───
    local isResized = false
    resizeBtn.MouseButton1Click:Connect(function()
        isResized = not isResized
        if isResized then
            Tween(mainFrame, {Size = UDim2.new(0.98, 0, 0.94, 0)}, 0.35)
        else
            Tween(mainFrame, {Size = winSize}, 0.35)
        end
    end)
    
    -- ─── Minimize Button Logic ───
    minimizeBtn.MouseButton1Click:Connect(function()
        Window.IsMinimized = not Window.IsMinimized
        if Window.IsMinimized then
            local curPos = mainFrame.AbsolutePosition
            mainFrame.Position = UDim2.new(0, curPos.X, 0, curPos.Y)
            Tween(mainFrame, {Size = UDim2.new(0, mainFrame.AbsoluteSize.X, 0, TB_H)}, 0.3)
            minimizeBtn.Text = "▢"
        else
            local targetSize = isResized and UDim2.new(math.min(0.98, 1), 0, math.min(0.94, 1), 0) or winSize
            Tween(mainFrame, {Size = targetSize}, 0.3)
            minimizeBtn.Text = "─"
        end
    end)
    
    -- ─── Close Button Logic (with confirmation) ───
    closeBtn.MouseButton1Click:Connect(function()
        self:ShowConfirm("Close Window", "Are you sure you want to close this window?",
            function()
                -- Auto save on close
                if self.Config.AutoSaveLoad then
                    SaveFile(self.Config.AutoSaveFile, self.Flags)
                end
                Tween(mainFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, mainFrame.AbsoluteSize.X * 0.95, 0, mainFrame.AbsoluteSize.Y * 0.95)}, 0.3)
                task.wait(0.32)
                mainFrame:Destroy()
            end,
            nil
        )
    end)
    
    -- ─── Tab Bar ───
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(0, TAB_W, 1, -(TB_H+2))
    tabBar.Position = UDim2.new(0, 0, 0, TB_H + 2)
    tabBar.BackgroundColor3 = theme.TopBar
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 11
    tabBar.Parent = mainFrame
    
    local tabBarFix = Instance.new("Frame")
    tabBarFix.Size = UDim2.new(0, math.floor(TAB_W*0.08), 1, 0)
    tabBarFix.Position = UDim2.new(1, -8, 0, 0)
    tabBarFix.BackgroundColor3 = theme.TopBar
    tabBarFix.BorderSizePixel = 0
    tabBarFix.ZIndex = 11
    tabBarFix.Parent = tabBar
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Vertical
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabBar
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = tabBar
    
    -- ─── Content Area ───
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -(TAB_W+5), 1, -(TB_H+4))
    contentArea.Position = UDim2.new(0, TAB_W + 4, 0, TB_H + 2)
    contentArea.BackgroundTransparency = 1
    contentArea.ZIndex = 11
    contentArea.Parent = mainFrame
    
    -- Content scrollframe
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, 0, 1, 0)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 2
    contentScroll.ScrollBarImageColor3 = theme.Accent
    contentScroll.ZIndex = 11
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.Parent = contentArea
    contentScroll.Visible = false -- hidden until tab selected
    
    Window.MainFrame = mainFrame
    Window.TopBar = topBar
    Window.TabBar = tabBar
    Window.ContentArea = contentArea
    Window.ContentScroll = contentScroll
    Window._lib = self
    
    -- ─── Add Tab Method ───
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or ""
        local theme = self._lib.Theme
        
        local Tab = {}
        Tab.Name = tabName
        Tab.Elements = {}
        Tab._lib = self._lib
        Tab._window = self
        
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabName
        tabBtn.Size = UDim2.new(1, 0, 0, 22)
        tabBtn.BackgroundColor3 = theme.Element
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName
        tabBtn.TextColor3 = theme.SubText
        tabBtn.TextSize = 10
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.BorderSizePixel = 0
        tabBtn.ZIndex = 12
        tabBtn.Parent = self.TabBar
        AddCorner(tabBtn, 5)
        
        local tabPaddingInner = Instance.new("UIPadding")
        tabPaddingInner.PaddingLeft = UDim.new(0, 6)
        tabPaddingInner.Parent = tabBtn
        
        local tabIndicator = Instance.new("Frame")
        tabIndicator.Size = UDim2.new(0, 2, 0.7, 0)
        tabIndicator.Position = UDim2.new(0, -2, 0.15, 0)
        tabIndicator.BackgroundColor3 = theme.Accent
        tabIndicator.BorderSizePixel = 0
        tabIndicator.BackgroundTransparency = 1
        tabIndicator.ZIndex = 13
        tabIndicator.Parent = tabBtn
        AddCorner(tabIndicator, 4)
        
        -- Tab content frame
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, -6, 1, -6)
        tabFrame.Position = UDim2.new(0, 3, 0, 3)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.ZIndex = 12
        tabFrame.Parent = self.ContentScroll
        
        local elementList = Instance.new("UIListLayout")
        elementList.FillDirection = Enum.FillDirection.Vertical
        elementList.Padding = UDim.new(0, 5)
        elementList.Parent = tabFrame
        
        local tabFramePad = Instance.new("UIPadding")
        tabFramePad.PaddingTop = UDim.new(0, 2)
        tabFramePad.PaddingBottom = UDim.new(0, 5)
        tabFramePad.Parent = tabFrame
        
        Tab.Frame = tabFrame
        Tab.Button = tabBtn
        
        -- Select tab
        local function selectTab()
            -- Deselect all tabs
            for _, t in pairs(self.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1, TextColor3 = theme.SubText}, 0.2)
                local ind = t.Button:FindFirstChild("Frame")
                if ind then Tween(ind, {BackgroundTransparency = 1}, 0.2) end
                t.Frame.Visible = false
            end
            
            -- Select this tab
            Tween(tabBtn, {BackgroundColor3 = theme.Element, BackgroundTransparency = 0, TextColor3 = theme.Text}, 0.2)
            Tween(tabIndicator, {BackgroundTransparency = 0}, 0.2)
            tabFrame.Visible = true
            self.ContentScroll.Visible = true
            self.CurrentTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if self.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.7, BackgroundColor3 = theme.ElementHover}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        table.insert(self.Tabs, Tab)
        
        -- Auto-select first tab
        if #self.Tabs == 1 then
            selectTab()
        end
        
        -- ══════════════════════════════════════
        --     ELEMENT HELPER
        -- ══════════════════════════════════════

        local function mTS(sz)
            if _smallmob then return math.max(9, sz-2)
            elseif _mob then return math.max(10, sz-1)
            else return sz end
        end
        local function makeContainer(height)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, height)
            container.BackgroundColor3 = theme.Element
            container.BorderSizePixel = 0
            container.ZIndex = 13
            container.Parent = tabFrame
            AddCorner(container, 5)
            AddStroke(container, theme.Border, 1)
            return container
        end
        
        -- ──────────────────────────────────────
        --  1. BUTTON
        -- ──────────────────────────────────────
        function Tab:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local theme = self._lib.Theme
            local container = makeContainer(29)
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -12, 0, 21)
            btn.Position = UDim2.new(0, 6, 0.5, -11)
            btn.BackgroundColor3 = theme.Accent
            btn.Text = btnConfig.Name or "Button"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamSemibold
            btn.BorderSizePixel = 0
            btn.ZIndex = 14
            btn.Parent = container
            AddCorner(btn, 4)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = theme.AccentGlow}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = theme.Accent}, 0.15)
            end)
            btn.MouseButton1Click:Connect(function()
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(255,255,255)}, 0.08)
                task.wait(0.1)
                Tween(btn, {BackgroundColor3 = theme.Accent}, 0.15)
                if btnConfig.Callback then btnConfig.Callback() end
            end)
            
            return btn
        end
        
        -- ──────────────────────────────────────
        --  2. TOGGLE
        -- ──────────────────────────────────────
        function Tab:AddToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local theme = self._lib.Theme
            local flagName = toggleConfig.Flag or toggleConfig.Name
            local container = makeContainer(31)
            
            local defaultVal = toggleConfig.Default or false
            if flagName and self._lib.Flags[flagName] ~= nil then
                defaultVal = self._lib.Flags[flagName]
            end
            
            local currentVal = defaultVal
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 9, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleConfig.Name or "Toggle"
            label.TextColor3 = theme.Text
            label.TextSize = 11
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 14
            label.Parent = container
            
            if toggleConfig.Description then
                label.Size = UDim2.new(1, -50, 0.55, 0)
                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -50, 0.45, 0)
                desc.Position = UDim2.new(0, 9, 0.55, 0)
                desc.BackgroundTransparency = 1
                desc.Text = toggleConfig.Description
                desc.TextColor3 = theme.SubText
                desc.TextSize = 10
                desc.Font = Enum.Font.Gotham
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.ZIndex = 14
                desc.Parent = container
            end
            
            -- Toggle background
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 29, 0, 16)
            toggleBg.Position = UDim2.new(1, -38, 0.5, -8)
            toggleBg.BackgroundColor3 = currentVal and theme.Toggle_ON or theme.Toggle_OFF
            toggleBg.BorderSizePixel = 0
            toggleBg.ZIndex = 14
            toggleBg.Parent = container
            AddCorner(toggleBg, 8)
            
            -- Toggle knob
            local toggleKnob = Instance.new("Frame")
            toggleKnob.Size = UDim2.new(0, 12, 0, 12)
            toggleKnob.Position = currentVal and UDim2.new(0, 15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleKnob.BorderSizePixel = 0
            toggleKnob.ZIndex = 15
            toggleKnob.Parent = toggleBg
            AddCorner(toggleKnob, 6)
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 16
            toggleBtn.Parent = toggleBg
            
            local function setToggle(val, skipCallback)
                currentVal = val
                if flagName then self._lib.Flags[flagName] = val end
                
                Tween(toggleBg, {BackgroundColor3 = val and theme.Toggle_ON or theme.Toggle_OFF}, 0.2)
                Tween(toggleKnob, {Position = val and UDim2.new(0, 15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.2)
                
                if not skipCallback and toggleConfig.Callback then
                    toggleConfig.Callback(val)
                end
                
                -- Auto save
                if self._lib.Config.AutoSaveLoad and flagName then
                    self._lib.SaveData[flagName] = val
                    SaveFile(self._lib.Config.AutoSaveFile, self._lib.Flags)
                end
            end
            
            toggleBtn.MouseButton1Click:Connect(function()
                setToggle(not currentVal)
            end)
            toggleBtn.TouchTap:Connect(function()
                setToggle(not currentVal)
            end)
            
            -- Apply saved value
            if defaultVal then setToggle(true, true) end
            
            local toggleObj = {}
            function toggleObj:Set(val) setToggle(val) end
            function toggleObj:Get() return currentVal end
            
            if flagName then self._lib.Flags[flagName] = currentVal end
            return toggleObj
        end
        
        -- ──────────────────────────────────────
        --  3. SLIDER
        -- ──────────────────────────────────────
        function Tab:AddSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local theme = self._lib.Theme
            local flagName = sliderConfig.Flag or sliderConfig.Name
            local container = makeContainer(40)
            
            local minVal = sliderConfig.Min or 0
            local maxVal = sliderConfig.Max or 100
            local defaultVal = sliderConfig.Default or minVal
            if flagName and self._lib.Flags[flagName] ~= nil then
                defaultVal = self._lib.Flags[flagName]
            end
            local currentVal = math.clamp(defaultVal, minVal, maxVal)
            local step = sliderConfig.Step or 1
            
            -- Header row
            local headerRow = Instance.new("Frame")
            headerRow.Size = UDim2.new(1, -15, 0, 16)
            headerRow.Position = UDim2.new(0, 8, 0, 5)
            headerRow.BackgroundTransparency = 1
            headerRow.ZIndex = 14
            headerRow.Parent = container
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = sliderConfig.Name or "Slider"
            nameLabel.TextColor3 = theme.Text
            nameLabel.TextSize = 10
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 14
            nameLabel.Parent = headerRow
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
            valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(currentVal)
            valueLabel.TextColor3 = theme.Accent
            valueLabel.TextSize = 10
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = 14
            valueLabel.Parent = headerRow
            
            -- Track
            local trackBg = Instance.new("Frame")
            trackBg.Size = UDim2.new(1, -15, 0, 5)
            trackBg.Position = UDim2.new(0, 8, 0, 26)
            trackBg.BackgroundColor3 = theme.Toggle_OFF
            trackBg.BorderSizePixel = 0
            trackBg.ZIndex = 14
            trackBg.Parent = container
            AddCorner(trackBg, 4)
            
            local trackFill = Instance.new("Frame")
            trackFill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
            trackFill.BackgroundColor3 = theme.Accent
            trackFill.BorderSizePixel = 0
            trackFill.ZIndex = 15
            trackFill.Parent = trackBg
            AddCorner(trackFill, 4)
            
            -- Knob
            local knob = Instance.new("Frame")
            local fillPct = (currentVal - minVal) / (maxVal - minVal)
            knob.Size = UDim2.new(0, 10, 0, 10)
            knob.Position = UDim2.new(fillPct, -5, 0.5, -5)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.ZIndex = 16
            knob.Parent = trackBg
            AddCorner(knob, 5)
            AddStroke(knob, theme.Accent, 2)
            
            -- Interaction
            local sliding = false
            
            local function updateSlider(inputPos)
                local trackAbsPos = trackBg.AbsolutePosition
                local trackAbsSize = trackBg.AbsoluteSize
                local relX = math.clamp((inputPos.X - trackAbsPos.X) / trackAbsSize.X, 0, 1)
                local rawVal = minVal + relX * (maxVal - minVal)
                local steppedVal = math.round(rawVal / step) * step
                currentVal = math.clamp(steppedVal, minVal, maxVal)
                local pct = (currentVal - minVal) / (maxVal - minVal)
                
                trackFill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, -5, 0.5, -5)
                valueLabel.Text = tostring(currentVal)
                
                if flagName then self._lib.Flags[flagName] = currentVal end
                if sliderConfig.Callback then sliderConfig.Callback(currentVal) end
                
                if self._lib.Config.AutoSaveLoad and flagName then
                    self._lib.SaveData[flagName] = currentVal
                end
            end
            
            trackBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSlider(input.Position)
                end
            end)
            trackBg.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input.Position)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input.Position)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if sliding and self._lib.Config.AutoSaveLoad and flagName then
                        SaveFile(self._lib.Config.AutoSaveFile, self._lib.Flags)
                    end
                    sliding = false
                end
            end)
            
            local sliderObj = {}
            function sliderObj:Set(val)
                currentVal = math.clamp(val, minVal, maxVal)
                local pct = (currentVal - minVal) / (maxVal - minVal)
                Tween(trackFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.2)
                knob.Position = UDim2.new(pct, -5, 0.5, -5)
                valueLabel.Text = tostring(currentVal)
                if flagName then self._lib.Flags[flagName] = currentVal end
            end
            function sliderObj:Get() return currentVal end
            
            if flagName then self._lib.Flags[flagName] = currentVal end
            return sliderObj
        end
        
        -- ──────────────────────────────────────
        --  4. DROPDOWN
        -- ──────────────────────────────────────
        function Tab:AddDropdown(dropConfig)
            dropConfig = dropConfig or {}
            local theme = self._lib.Theme
            local flagName = dropConfig.Flag or dropConfig.Name
            local options = dropConfig.Options or {}
            local container = makeContainer(31)
            container.ClipsDescendants = false
            container.ZIndex = 20
            
            local defaultVal = dropConfig.Default or (options[1] or "Select...")
            if flagName and self._lib.Flags[flagName] ~= nil then
                defaultVal = self._lib.Flags[flagName]
            end
            local currentVal = defaultVal
            local isOpen = false
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.45, 0, 1, 0)
            label.Position = UDim2.new(0, 9, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = dropConfig.Name or "Dropdown"
            label.TextColor3 = theme.Text
            label.TextSize = 10
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 21
            label.Parent = container
            
            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.new(0.5, -6, 0, 21)
            dropBtn.Position = UDim2.new(0.5, 3, 0.5, -11)
            dropBtn.BackgroundColor3 = theme.Dropdown
            dropBtn.Text = currentVal .. "  ▾"
            dropBtn.TextColor3 = theme.Text
            dropBtn.TextSize = 10
            dropBtn.Font = Enum.Font.GothamSemibold
            dropBtn.BorderSizePixel = 0
            dropBtn.ZIndex = 21
            dropBtn.Parent = container
            AddCorner(dropBtn, 4)
            AddStroke(dropBtn, theme.Border, 1)
            
            -- Dropdown menu
            local dropMenu = Instance.new("Frame")
            dropMenu.Size = UDim2.new(0.5, -6, 0, 0)
            dropMenu.Position = UDim2.new(0.5, 3, 1, 2)
            dropMenu.BackgroundColor3 = theme.Dropdown
            dropMenu.BorderSizePixel = 0
            dropMenu.ClipsDescendants = true
            dropMenu.ZIndex = 25
            dropMenu.Visible = false
            dropMenu.Parent = container
            AddCorner(dropMenu, 5)
            AddStroke(dropMenu, theme.Border, 1)
            
            local menuList = Instance.new("UIListLayout")
            menuList.FillDirection = Enum.FillDirection.Vertical
            menuList.Padding = UDim.new(0, 2)
            menuList.Parent = dropMenu
            
            local menuPad = Instance.new("UIPadding")
            menuPad.PaddingTop = UDim.new(0, 2)
            menuPad.PaddingBottom = UDim.new(0, 2)
            menuPad.PaddingLeft = UDim.new(0, 2)
            menuPad.PaddingRight = UDim.new(0, 2)
            menuPad.Parent = dropMenu
            
            local menuHeight = math.min(#options, 5) * mobH(19) + 4
            
            for _, option in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 18)
                optBtn.BackgroundColor3 = option == currentVal and theme.Accent or Color3.fromRGB(0,0,0)
                optBtn.BackgroundTransparency = option == currentVal and 0 or 1
                optBtn.Text = option
                optBtn.TextColor3 = option == currentVal and Color3.fromRGB(255,255,255) or theme.Text
                optBtn.TextSize = 10
                optBtn.Font = Enum.Font.Gotham
                optBtn.BorderSizePixel = 0
                optBtn.ZIndex = 26
                optBtn.Parent = dropMenu
                AddCorner(optBtn, 4)
                
                optBtn.MouseEnter:Connect(function()
                    if option ~= currentVal then
                        Tween(optBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.ElementHover}, 0.15)
                    end
                end)
                optBtn.MouseLeave:Connect(function()
                    if option ~= currentVal then
                        Tween(optBtn, {BackgroundTransparency = 1}, 0.15)
                    end
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    currentVal = option
                    dropBtn.Text = option .. "  ▾"
                    if flagName then self._lib.Flags[flagName] = option end
                    
                    -- Reset all option highlights
                    for _, child in pairs(dropMenu:GetChildren()) do
                        if child:IsA("TextButton") then
                            Tween(child, {BackgroundTransparency = 1, TextColor3 = theme.Text}, 0.15)
                        end
                    end
                    Tween(optBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.Accent, TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
                    
                    if dropConfig.Callback then dropConfig.Callback(option) end
                    
                    if self._lib.Config.AutoSaveLoad and flagName then
                        self._lib.SaveData[flagName] = option
                        SaveFile(self._lib.Config.AutoSaveFile, self._lib.Flags)
                    end
                    
                    -- Close menu
                    isOpen = false
                    Tween(dropMenu, {Size = UDim2.new(0.5, -6, 0, 0)}, 0.2)
                    task.wait(0.2)
                    dropMenu.Visible = false
                end)
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropMenu.Visible = true
                    Tween(dropMenu, {Size = UDim2.new(0.5, -10, 0, menuHeight)}, 0.2)
                    dropBtn.Text = currentVal .. "  ▴"
                else
                    Tween(dropMenu, {Size = UDim2.new(0.5, -6, 0, 0)}, 0.2)
                    task.wait(0.2)
                    dropMenu.Visible = false
                    dropBtn.Text = currentVal .. "  ▾"
                end
            end)
            
            local dropObj = {}
            function dropObj:Set(val)
                currentVal = val
                dropBtn.Text = val .. "  ▾"
                if flagName then self._lib.Flags[flagName] = val end
            end
            function dropObj:Get() return currentVal end
            
            if flagName then self._lib.Flags[flagName] = currentVal end
            return dropObj
        end
        
        -- ──────────────────────────────────────
        --  5. TEXT INPUT
        -- ──────────────────────────────────────
        function Tab:AddInput(inputConfig)
            inputConfig = inputConfig or {}
            local theme = self._lib.Theme
            local flagName = inputConfig.Flag or inputConfig.Name
            local container = makeContainer(35)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -9, 0, 14)
            label.Position = UDim2.new(0, 9, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = inputConfig.Name or "Input"
            label.TextColor3 = theme.Text
            label.TextSize = 10
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 14
            label.Parent = container
            
            local inputBg = Instance.new("Frame")
            inputBg.Size = UDim2.new(1, -12, 0, 16)
            inputBg.Position = UDim2.new(0, 6, 0, 15)
            inputBg.BackgroundColor3 = theme.Background
            inputBg.BorderSizePixel = 0
            inputBg.ZIndex = 14
            inputBg.Parent = container
            AddCorner(inputBg, 4)
            AddStroke(inputBg, theme.Border, 1)
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -9, 1, 0)
            textBox.Position = UDim2.new(0, 4, 0, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = inputConfig.Default or ""
            textBox.PlaceholderText = inputConfig.Placeholder or "Type here..."
            textBox.PlaceholderColor3 = theme.SubText
            textBox.TextColor3 = theme.Text
            textBox.TextSize = 10
            textBox.Font = Enum.Font.Gotham
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = inputConfig.ClearOnFocus or false
            textBox.ZIndex = 15
            textBox.Parent = inputBg
            
            textBox.Focused:Connect(function()
                local stroke = inputBg:FindFirstChildOfClass("UIStroke")
                if stroke then Tween(stroke, {Color = theme.Accent}, 0.2) end
            end)
            textBox.FocusLost:Connect(function(enter)
                local stroke = inputBg:FindFirstChildOfClass("UIStroke")
                if stroke then Tween(stroke, {Color = theme.Border}, 0.2) end
                if flagName then self._lib.Flags[flagName] = textBox.Text end
                if inputConfig.Callback then inputConfig.Callback(textBox.Text, enter) end
            end)
            
            local inputObj = {}
            function inputObj:Set(val) textBox.Text = val end
            function inputObj:Get() return textBox.Text end
            
            if flagName then self._lib.Flags[flagName] = textBox.Text end
            return inputObj
        end
        
        -- ──────────────────────────────────────
        --  6. LABEL / TEXT
        -- ──────────────────────────────────────
        function Tab:AddLabel(labelConfig)
            labelConfig = labelConfig or {}
            local theme = self._lib.Theme
            local container = makeContainer(24)
            container.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -12, 1, 0)
            label.Position = UDim2.new(0, 6, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = labelConfig.Text or "Label"
            label.TextColor3 = labelConfig.Color or theme.SubText
            label.TextSize = labelConfig.Size or 13
            label.Font = labelConfig.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true
            label.ZIndex = 14
            label.Parent = container
            
            local labelObj = {}
            function labelObj:Set(text) label.Text = text end
            function labelObj:SetColor(color) label.TextColor3 = color end
            return labelObj
        end
        
        -- ──────────────────────────────────────
        --  7. SECTION / SEPARATOR
        -- ──────────────────────────────────────
        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            local theme = self._lib.Theme
            local container = makeContainer(22)
            container.BackgroundColor3 = theme.TopBar
            
            local sectionLine = Instance.new("Frame")
            sectionLine.Size = UDim2.new(0.3, 0, 0, 1)
            sectionLine.Position = UDim2.new(0, 6, 0.5, 0)
            sectionLine.BackgroundColor3 = theme.Accent
            sectionLine.BorderSizePixel = 0
            sectionLine.ZIndex = 14
            sectionLine.Parent = container
            
            local sectionLine2 = Instance.new("Frame")
            sectionLine2.Size = UDim2.new(0, 0, 0, 1)
            sectionLine2.Position = UDim2.new(1, -6, 0.5, 0)
            sectionLine2.AnchorPoint = Vector2.new(1, 0)
            sectionLine2.BackgroundColor3 = theme.Accent
            sectionLine2.BorderSizePixel = 0
            sectionLine2.ZIndex = 14
            sectionLine2.Parent = container
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(0.4, 0, 1, 0)
            sectionLabel.Position = UDim2.new(0.3, 3, 0, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionConfig.Name or "Section"
            sectionLabel.TextColor3 = theme.Accent
            sectionLabel.TextSize = 10
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Center
            sectionLabel.ZIndex = 14
            sectionLabel.Parent = container
            
            -- Update right line
            task.wait()
            local labelWidth = sectionLabel.AbsoluteSize.X
            local containerWidth = container.AbsoluteSize.X
            sectionLine2.Size = UDim2.new(0, containerWidth - (containerWidth * 0.3 + 5 + labelWidth + 15), 0, 1)
        end
        
        -- ──────────────────────────────────────
        --  8. COLORPICKER
        -- ──────────────────────────────────────
        function Tab:AddColorPicker(colorConfig)
            colorConfig = colorConfig or {}
            local theme = self._lib.Theme
            local flagName = colorConfig.Flag or colorConfig.Name
            local container = makeContainer(31)
            
            local defaultColor = colorConfig.Default or Color3.fromRGB(255, 255, 255)
            if flagName and self._lib.Flags[flagName] then
                local saved = self._lib.Flags[flagName]
                if type(saved) == "table" then
                    defaultColor = Color3.fromRGB(saved.r or 255, saved.g or 255, saved.b or 255)
                end
            end
            local currentColor = defaultColor
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -56, 1, 0)
            label.Position = UDim2.new(0, 9, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = colorConfig.Name or "Color"
            label.TextColor3 = theme.Text
            label.TextSize = 10
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 14
            label.Parent = container
            
            local colorPreview = Instance.new("TextButton")
            colorPreview.Size = UDim2.new(0, 38, 0, 19)
            colorPreview.Position = UDim2.new(1, -46, 0.5, -9)
            colorPreview.BackgroundColor3 = currentColor
            colorPreview.Text = ""
            colorPreview.BorderSizePixel = 0
            colorPreview.ZIndex = 14
            colorPreview.Parent = container
            AddCorner(colorPreview, 5)
            AddStroke(colorPreview, theme.Border, 1.5)
            
            local hexLabel = Instance.new("TextLabel")
            hexLabel.Size = UDim2.new(0, 38, 0, 9)
            hexLabel.Position = UDim2.new(1, -46, 1, -12)
            hexLabel.BackgroundTransparency = 1
            local r,g,b = math.floor(currentColor.R*255), math.floor(currentColor.G*255), math.floor(currentColor.B*255)
            hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
            hexLabel.TextColor3 = theme.SubText
            hexLabel.TextSize = 10
            hexLabel.Font = Enum.Font.Code
            hexLabel.TextXAlignment = Enum.TextXAlignment.Center
            hexLabel.ZIndex = 14
            hexLabel.Parent = container
            
            -- Simple color wheel popup (HSV sliders)
            local pickerOpen = false
            local pickerFrame
            
            colorPreview.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                if pickerOpen then
                    pickerFrame = Instance.new("Frame")
                    pickerFrame.Size = UDim2.new(0, 150, 0, 88)
                    pickerFrame.Position = UDim2.new(0, 0, 1, 4)
                    pickerFrame.BackgroundColor3 = theme.TopBar
                    pickerFrame.BorderSizePixel = 0
                    pickerFrame.ZIndex = 30
                    pickerFrame.ClipsDescendants = false
                    pickerFrame.Parent = container
                    AddCorner(pickerFrame, 6)
                    AddStroke(pickerFrame, theme.Border, 1.5)
                    
                    local h, s, v = Color3.toHSV(currentColor)
                    
                    local function makeHSVSlider(name, yPos, minV, maxV, defV)
                        local sliderLabel = Instance.new("TextLabel")
                        sliderLabel.Size = UDim2.new(0, 12, 0, 11)
                        sliderLabel.Position = UDim2.new(0, 8, 0, yPos)
                        sliderLabel.BackgroundTransparency = 1
                        sliderLabel.Text = name
                        sliderLabel.TextColor3 = theme.SubText
                        sliderLabel.TextSize = 10
                        sliderLabel.Font = Enum.Font.GothamBold
                        sliderLabel.ZIndex = 31
                        sliderLabel.Parent = pickerFrame
                        
                        local sTrack = Instance.new("Frame")
                        sTrack.Size = UDim2.new(0, 100, 0, 5)
                        sTrack.Position = UDim2.new(0, 32, 0, yPos + 5)
                        sTrack.BackgroundColor3 = theme.Toggle_OFF
                        sTrack.BorderSizePixel = 0
                        sTrack.ZIndex = 31
                        sTrack.Parent = pickerFrame
                        AddCorner(sTrack, 4)
                        
                        local sFill = Instance.new("Frame")
                        sFill.Size = UDim2.new(defV / maxV, 0, 1, 0)
                        sFill.BackgroundColor3 = theme.Accent
                        sFill.BorderSizePixel = 0
                        sFill.ZIndex = 32
                        sFill.Parent = sTrack
                        AddCorner(sFill, 4)
                        
                        local sVal = Instance.new("TextLabel")
                        sVal.Size = UDim2.new(0, 22, 0, 11)
                        sVal.Position = UDim2.new(0, 198, 0, yPos)
                        sVal.BackgroundTransparency = 1
                        sVal.Text = string.format("%.2f", defV)
                        sVal.TextColor3 = theme.Text
                        sVal.TextSize = 10
                        sVal.Font = Enum.Font.GothamBold
                        sVal.ZIndex = 31
                        sVal.Parent = pickerFrame
                        
                        local dragging2 = false
                        local value = defV
                        
                        sTrack.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging2 = true
                            end
                        end)
                        UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging2 = false
                            end
                        end)
                        UserInputService.InputChanged:Connect(function(inp)
                            if dragging2 and inp.UserInputType == Enum.UserInputType.MouseMovement then
                                local relX = math.clamp((inp.Position.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
                                value = minV + relX * (maxV - minV)
                                sFill.Size = UDim2.new(relX, 0, 1, 0)
                                sVal.Text = string.format("%.2f", value)
                                
                                if name == "H" then h = value
                                elseif name == "S" then s = value
                                elseif name == "V" then v = value end
                                
                                currentColor = Color3.fromHSV(h, s, v)
                                colorPreview.BackgroundColor3 = currentColor
                                local cr,cg,cb = math.floor(currentColor.R*255), math.floor(currentColor.G*255), math.floor(currentColor.B*255)
                                hexLabel.Text = string.format("#%02X%02X%02X", cr, cg, cb)
                                
                                if flagName then
                                    self._lib.Flags[flagName] = {r=cr, g=cg, b=cb}
                                end
                                if colorConfig.Callback then colorConfig.Callback(currentColor) end
                            end
                        end)
                        
                        return value
                    end
                    
                    makeHSVSlider("H", 15, 0, 1, h)
                    makeHSVSlider("S", 55, 0, 1, s)
                    makeHSVSlider("V", 95, 0, 1, v)
                    
                else
                    if pickerFrame then
                        pickerFrame:Destroy()
                        pickerFrame = nil
                    end
                end
            end)
            
            local colorObj = {}
            function colorObj:Set(color)
                currentColor = color
                colorPreview.BackgroundColor3 = color
                local cr,cg,cb = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)
                hexLabel.Text = string.format("#%02X%02X%02X", cr, cg, cb)
                if flagName then self._lib.Flags[flagName] = {r=cr, g=cg, b=cb} end
            end
            function colorObj:Get() return currentColor end
            
            if flagName then 
                local cr,cg,cb = math.floor(currentColor.R*255), math.floor(currentColor.G*255), math.floor(currentColor.B*255)
                self._lib.Flags[flagName] = {r=cr, g=cg, b=cb}
            end
            return colorObj
        end
        
        -- ──────────────────────────────────────
        --  9. KEYBIND
        -- ──────────────────────────────────────
        function Tab:AddKeybind(keybindConfig)
            keybindConfig = keybindConfig or {}
            local theme = self._lib.Theme
            local flagName = keybindConfig.Flag or keybindConfig.Name
            local container = makeContainer(31)
            
            local defaultKey = keybindConfig.Default or Enum.KeyCode.Unknown
            if flagName and self._lib.Flags[flagName] then
                pcall(function()
                    defaultKey = Enum.KeyCode[self._lib.Flags[flagName]]
                end)
            end
            local currentKey = defaultKey
            local listening = false
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -62, 1, 0)
            label.Position = UDim2.new(0, 9, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = keybindConfig.Name or "Keybind"
            label.TextColor3 = theme.Text
            label.TextSize = 10
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 14
            label.Parent = container
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0, 50, 0, 19)
            keyBtn.Position = UDim2.new(1, -58, 0.5, -9)
            keyBtn.BackgroundColor3 = theme.Element
            keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "None"
            keyBtn.TextColor3 = theme.Accent
            keyBtn.TextSize = 10
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.BorderSizePixel = 0
            keyBtn.ZIndex = 14
            keyBtn.Parent = container
            AddCorner(keyBtn, 4)
            AddStroke(keyBtn, theme.Border, 1)
            
            keyBtn.MouseButton1Click:Connect(function()
                if not listening then
                    listening = true
                    keyBtn.Text = "..."
                    keyBtn.TextColor3 = theme.AccentGlow
                end
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    keyBtn.Text = input.KeyCode.Name
                    keyBtn.TextColor3 = theme.Accent
                    listening = false
                    if flagName then self._lib.Flags[flagName] = input.KeyCode.Name end
                    if keybindConfig.Callback then keybindConfig.Callback(input.KeyCode) end
                elseif not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                    if keybindConfig.OnPress then keybindConfig.OnPress() end
                end
            end)
            
            local keybindObj = {}
            function keybindObj:Set(keyCode)
                currentKey = keyCode
                keyBtn.Text = keyCode.Name
                if flagName then self._lib.Flags[flagName] = keyCode.Name end
            end
            function keybindObj:Get() return currentKey end
            
            return keybindObj
        end
        
        -- ──────────────────────────────────────
        --  10. MULTI-SELECT CHECKBOX
        -- ──────────────────────────────────────
        function Tab:AddMultiSelect(msConfig)
            msConfig = msConfig or {}
            local theme = self._lib.Theme
            local flagName = msConfig.Flag or msConfig.Name
            local options = msConfig.Options or {}
            local height = 25 + math.ceil(#options / 2) * 19
            local container = makeContainer(height)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -9, 0, 18)
            label.Position = UDim2.new(0, 9, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = msConfig.Name or "Multi-Select"
            label.TextColor3 = theme.Text
            label.TextSize = 10
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 14
            label.Parent = container
            
            local selected = {}
            if flagName and self._lib.Flags[flagName] then
                selected = self._lib.Flags[flagName]
            elseif msConfig.Default then
                selected = msConfig.Default
            end
            
            local function isSelected(opt)
                for _, v in pairs(selected) do
                    if v == opt then return true end
                end
                return false
            end
            
            local row = 0
            local col = 0
            
            for idx, option in pairs(options) do
                col = (idx - 1) % 2
                row = math.floor((idx - 1) / 2)
                
                local checkContainer = Instance.new("Frame")
                checkContainer.Size = UDim2.new(0.5, -9, 0, 16)
                checkContainer.Position = UDim2.new(col * 0.5, col == 0 and 10 or 4, 0, 36 + row * 19)
                checkContainer.BackgroundTransparency = 1
                checkContainer.ZIndex = 14
                checkContainer.Parent = container
                
                local checkBox = Instance.new("Frame")
                checkBox.Size = UDim2.new(0, 12, 0, 12)
                checkBox.Position = UDim2.new(0, 0, 0.5, -6)
                checkBox.BackgroundColor3 = isSelected(option) and theme.Accent or theme.Element
                checkBox.BorderSizePixel = 0
                checkBox.ZIndex = 15
                checkBox.Parent = checkContainer
                AddCorner(checkBox, 4)
                AddStroke(checkBox, theme.Border, 1)
                
                local checkMark = Instance.new("TextLabel")
                checkMark.Size = UDim2.new(1, 0, 1, 0)
                checkMark.BackgroundTransparency = 1
                checkMark.Text = "✓"
                checkMark.TextColor3 = Color3.fromRGB(255,255,255)
                checkMark.TextSize = 10
                checkMark.Font = Enum.Font.GothamBold
                checkMark.TextTransparency = isSelected(option) and 0 or 1
                checkMark.ZIndex = 16
                checkMark.Parent = checkBox
                
                local optLabel = Instance.new("TextLabel")
                optLabel.Size = UDim2.new(1, -18, 1, 0)
                optLabel.Position = UDim2.new(0, 16, 0, 0)
                optLabel.BackgroundTransparency = 1
                optLabel.Text = option
                optLabel.TextColor3 = theme.Text
                optLabel.TextSize = 10
                optLabel.Font = Enum.Font.Gotham
                optLabel.TextXAlignment = Enum.TextXAlignment.Left
                optLabel.ZIndex = 15
                optLabel.Parent = checkContainer
                
                local clickBtn = Instance.new("TextButton")
                clickBtn.Size = UDim2.new(1, 0, 1, 0)
                clickBtn.BackgroundTransparency = 1
                clickBtn.Text = ""
                clickBtn.ZIndex = 17
                clickBtn.Parent = checkContainer
                
                clickBtn.MouseButton1Click:Connect(function()
                    local sel = isSelected(option)
                    if sel then
                        for i, v in pairs(selected) do
                            if v == option then table.remove(selected, i) break end
                        end
                        Tween(checkBox, {BackgroundColor3 = theme.Element}, 0.15)
                        Tween(checkMark, {TextTransparency = 1}, 0.15)
                    else
                        table.insert(selected, option)
                        Tween(checkBox, {BackgroundColor3 = theme.Accent}, 0.15)
                        Tween(checkMark, {TextTransparency = 0}, 0.15)
                    end
                    
                    if flagName then self._lib.Flags[flagName] = selected end
                    if msConfig.Callback then msConfig.Callback(selected) end
                end)
            end
            
            local msObj = {}
            function msObj:Get() return selected end
            function msObj:Set(opts) selected = opts end
            
            if flagName then self._lib.Flags[flagName] = selected end
            return msObj
        end
        
        -- ──────────────────────────────────────
        --  11. PROGRESSBAR
        -- ──────────────────────────────────────
        function Tab:AddProgressBar(pbConfig)
            pbConfig = pbConfig or {}
            local theme = self._lib.Theme
            local container = makeContainer(32)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.65, 0, 0, 14)
            label.Position = UDim2.new(0, 9, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = pbConfig.Name or "Progress"
            label.TextColor3 = theme.Text
            label.TextSize = 10
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 14
            label.Parent = container
            
            local currentVal = pbConfig.Default or 0
            local maxVal = pbConfig.Max or 100
            
            local percentLabel = Instance.new("TextLabel")
            percentLabel.Size = UDim2.new(0.35, -6, 0, 14)
            percentLabel.Position = UDim2.new(0.65, 0, 0, 4)
            percentLabel.BackgroundTransparency = 1
            percentLabel.Text = string.format("%.0f%%", (currentVal / maxVal) * 100)
            percentLabel.TextColor3 = theme.Accent
            percentLabel.TextSize = 10
            percentLabel.Font = Enum.Font.GothamBold
            percentLabel.TextXAlignment = Enum.TextXAlignment.Right
            percentLabel.ZIndex = 14
            percentLabel.Parent = container
            
            local pbBg = Instance.new("Frame")
            pbBg.Size = UDim2.new(1, -15, 0, 6)
            pbBg.Position = UDim2.new(0, 8, 0, 21)
            pbBg.BackgroundColor3 = theme.Toggle_OFF
            pbBg.BorderSizePixel = 0
            pbBg.ZIndex = 14
            pbBg.Parent = container
            AddCorner(pbBg, 4)
            
            local pbFill = Instance.new("Frame")
            pbFill.Size = UDim2.new(currentVal / maxVal, 0, 1, 0)
            pbFill.BackgroundColor3 = theme.Accent
            pbFill.BorderSizePixel = 0
            pbFill.ZIndex = 15
            pbFill.Parent = pbBg
            AddCorner(pbFill, 4)
            
            -- Shimmer effect
            local shimmer = Instance.new("Frame")
            shimmer.Size = UDim2.new(0, 38, 1, 0)
            shimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
            shimmer.BackgroundTransparency = 0.7
            shimmer.BorderSizePixel = 0
            shimmer.ZIndex = 16
            shimmer.ClipsDescendants = false
            shimmer.Parent = pbFill
            AddCorner(shimmer, 4)
            
            local function animateShimmer()
                while shimmer and shimmer.Parent do
                    shimmer.Position = UDim2.new(-0.5, 0, 0, 0)
                    Tween(shimmer, {Position = UDim2.new(1.5, 0, 0, 0)}, 1.5, "Sine", "InOut")
                    task.wait(2)
                end
            end
            task.spawn(animateShimmer)
            
            local pbObj = {}
            function pbObj:Set(val)
                currentVal = math.clamp(val, 0, maxVal)
                local pct = currentVal / maxVal
                Tween(pbFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.4)
                percentLabel.Text = string.format("%.0f%%", pct * 100)
            end
            function pbObj:Get() return currentVal end
            
            return pbObj
        end
        
        -- ──────────────────────────────────────
        --  12. PARAGRAPH (Rich text block)
        -- ──────────────────────────────────────
        function Tab:AddParagraph(paraConfig)
            paraConfig = paraConfig or {}
            local theme = self._lib.Theme
            local textContent = paraConfig.Content or "Paragraph text goes here."
            local lineCount = math.ceil(#textContent / 45)
            local height = math.max(38, 18 + lineCount * 10 + 8)
            local container = makeContainer(height)
            
            if paraConfig.Title then
                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, -9, 0, 14)
                titleLabel.Position = UDim2.new(0, 9, 0, 4)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = paraConfig.Title
                titleLabel.TextColor3 = theme.Text
                titleLabel.TextSize = 10
                titleLabel.Font = Enum.Font.GothamBold
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.ZIndex = 14
                titleLabel.Parent = container
            end
            
            local contentLabel = Instance.new("TextLabel")
            contentLabel.Size = UDim2.new(1, -24, 0, height - (paraConfig.Title and 32 or 12))
            contentLabel.Position = UDim2.new(0, 12, 0, paraConfig.Title and 26 or 6)
            contentLabel.BackgroundTransparency = 1
            contentLabel.Text = textContent
            contentLabel.TextColor3 = theme.SubText
            contentLabel.TextSize = 10
            contentLabel.Font = Enum.Font.Gotham
            contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            contentLabel.TextWrapped = true
            contentLabel.ZIndex = 14
            contentLabel.Parent = container
            
            local paraObj = {}
            function paraObj:Set(text)
                contentLabel.Text = text
            end
            return paraObj
        end
        
        return Tab
    end
    
    -- ─── Config Tab Method ───
    function Window:AddConfig()
        local theme = self._lib.Theme
        local lib = self._lib
        local configTab = self:AddTab({Name = "⚙  Config", Icon = ""})
        
        -- Theme dropdown
        local themeOptions = {}
        for name, _ in pairs(Themes) do
            table.insert(themeOptions, name)
        end
        table.sort(themeOptions)
        
        configTab:AddSection({Name = "Appearance"})
        
        configTab:AddDropdown({
            Name = "Theme",
            Options = themeOptions,
            Default = lib.Config.Theme,
            Flag = "_theme",
            Callback = function(selected)
                lib.Theme = Themes[selected] or Themes["Dark Neon"]
                lib.Config.Theme = selected
                lib:Notify("Theme", "Theme changed to: " .. selected, 3, "info")
                -- Apply theme changes (partial live-update)
                self.MainFrame.BackgroundColor3 = lib.Theme.Background
                self.TopBar.BackgroundColor3 = lib.Theme.TopBar
                self.TabBar.BackgroundColor3 = lib.Theme.TopBar
            end,
        })
        
        configTab:AddSection({Name = "Visual"})
        
        configTab:AddToggle({
            Name = "Background Blur",
            Description = "Sets background opacity to 60%",
            Flag = "_bgBlur",
            Default = lib.Config.BlurBackground,
            Callback = function(val)
                lib.Config.BlurBackground = val
                Tween(self.MainFrame, {BackgroundTransparency = val and 0.4 or 0}, 0.3)
            end,
        })
        
        configTab:AddSection({Name = "Auto Save & Load"})
        
        configTab:AddToggle({
            Name = "Auto Save & Load",
            Description = "Saves and loads your settings automatically",
            Flag = "_autoSave",
            Default = lib.Config.AutoSaveLoad,
            Callback = function(val)
                lib.Config.AutoSaveLoad = val
                if val then
                    SaveFile(lib.Config.AutoSaveFile, lib.Flags)
                    lib:Notify("Auto Save", "Auto Save & Load enabled!", 3, "success")
                else
                    lib:Notify("Auto Save", "Auto Save & Load disabled.", 3, "info")
                end
            end,
        })
        
        configTab:AddButton({
            Name = "Save Config Now",
            Callback = function()
                if SaveFile(lib.Config.AutoSaveFile, lib.Flags) then
                    lib:Notify("Config", "Configuration saved successfully!", 3, "success")
                else
                    lib:Notify("Config", "Failed to save config (executor may not support file I/O).", 4, "error")
                end
            end,
        })
        
        configTab:AddButton({
            Name = "Reset All Settings",
            Callback = function()
                lib:ShowConfirm("Reset Settings", "Reset all settings to default?",
                    function()
                        lib.Flags = {}
                        lib.SaveData = {}
                        if writefile then
                            pcall(function() writefile(lib.Config.AutoSaveFile, "{}") end)
                        end
                        lib:Notify("Config", "All settings have been reset.", 3, "info")
                    end, nil)
            end,
        })
        
        configTab:AddSection({Name = "Info"})
        
        configTab:AddParagraph({
            Title = "LolHub UI Library",
            Content = "Version 2.0 Ultra Pro Max\n12 Elements | Key System | Auto Save | 10 Themes\n\nFor support, join our Discord server.",
        })
        
        return configTab
    end
    
    table.insert(self.Windows, Window)
    return Window
end

-- ═══════════════════════════════════════════════════
--              NOTIFICATIONS
-- ═══════════════════════════════════════════════════
function LolHub:Notify(title, message, duration, notifType)
    local theme = self.Theme
    duration = duration or 4
    notifType = notifType or "info"
    
    local typeColors = {
        info = theme.Accent,
        success = Color3.fromRGB(60, 200, 80),
        error = Color3.fromRGB(220, 50, 50),
        warning = Color3.fromRGB(230, 180, 0),
    }
    local typeIcons = {
        info = "ℹ",
        success = "✔",
        error = "✕",
        warning = "⚠",
    }
    
    local accentColor = typeColors[notifType] or theme.Accent
    local icon = typeIcons[notifType] or "ℹ"
    
    -- Notification container (anchored bottom-right)
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    local _ns = GetScreenSize()
    local _nw = math.min(_ns.X - 16, 260)
    notifFrame.Size = UDim2.new(0, _nw, 0, 46)
    notifFrame.Position = UDim2.new(1.05, 0, 1, -(#self.Notifications + 1) * 50 - 12)
    notifFrame.BackgroundColor3 = theme.Notification
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 100
    notifFrame.Parent = self.ScreenGui
    AddCorner(notifFrame, 6)
    AddStroke(notifFrame, accentColor, 1.5)
    
    -- Accent side bar
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 1, -10)
    accentBar.Position = UDim2.new(0, 0, 0, 5)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 101
    accentBar.Parent = notifFrame
    AddCorner(accentBar, 4)
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 19, 0, 19)
    iconLabel.Position = UDim2.new(0, 8, 0.5, -9)
    iconLabel.BackgroundColor3 = accentColor
    iconLabel.BackgroundTransparency = 0.7
    iconLabel.Text = icon
    iconLabel.TextColor3 = accentColor
    iconLabel.TextSize = 12
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 101
    iconLabel.Parent = notifFrame
    AddCorner(iconLabel, 5)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -38, 0, 14)
    titleLabel.Position = UDim2.new(0, 31, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 101
    titleLabel.Parent = notifFrame
    
    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -38, 0, 16)
    msgLabel.Position = UDim2.new(0, 31, 0, 20)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = theme.SubText
    msgLabel.TextSize = 10
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.ZIndex = 101
    msgLabel.Parent = notifFrame
    
    -- Progress bar
    local progBg = Instance.new("Frame")
    progBg.Size = UDim2.new(1, 0, 0, 2)
    progBg.Position = UDim2.new(0, 0, 1, -2)
    progBg.BackgroundColor3 = theme.Element
    progBg.BorderSizePixel = 0
    progBg.ZIndex = 101
    progBg.Parent = notifFrame
    
    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(1, 0, 1, 0)
    progFill.BackgroundColor3 = accentColor
    progFill.BorderSizePixel = 0
    progFill.ZIndex = 102
    progFill.Parent = progBg
    
    -- Animate in
    Tween(notifFrame, {Position = UDim2.new(0, 8, 1, -(#self.Notifications + 1) * 54 - 8)}, 0.35, "Back", "Out")
    table.insert(self.Notifications, notifFrame)
    
    -- Progress and auto-dismiss
    task.spawn(function()
        Tween(progFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, "Linear")
        task.wait(duration)
        
        -- Animate out
        Tween(notifFrame, {Position = UDim2.new(1, 20, notifFrame.Position.Y.Scale, notifFrame.Position.Y.Offset)}, 0.3)
        task.wait(0.35)
        
        for i, n in pairs(self.Notifications) do
            if n == notifFrame then table.remove(self.Notifications, i) break end
        end
        notifFrame:Destroy()
        
        -- Restack remaining notifications
        for idx, n in pairs(self.Notifications) do
            Tween(n, {Position = UDim2.new(0, 8, 1, -idx * 54 - 8)}, 0.25)
        end
    end)
end

-- ═══════════════════════════════════════════════════
--              CONFIRM DIALOG
-- ═══════════════════════════════════════════════════
function LolHub:ShowConfirm(title, message, onYes, onCancel)
    local theme = self.Theme
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 90
    overlay.Parent = self.ScreenGui
    
    local dialog = Instance.new("Frame")
    dialog.Size = UDim2.new(0.82, 0, 0, 140)
    dialog.Position = UDim2.new(0.5, -106, 0.5, -50)
    dialog.BackgroundColor3 = theme.TopBar
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 91
    dialog.Parent = self.ScreenGui
    AddCorner(dialog, 9)
    AddStroke(dialog, theme.Border, 1.5)
    
    -- Scale in
    dialog.Size = UDim2.new(0, 0, 0, 0)
    dialog.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(dialog, {Size = UDim2.new(0.82, 0, 0, 140), Position = UDim2.new(0.5, -106, 0.5, -50)}, 0.3, "Back", "Out")
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -12, 0, 22)
    titleLabel.Position = UDim2.new(0, 6, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 92
    titleLabel.Parent = dialog
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -12, 0, 25)
    msgLabel.Position = UDim2.new(0, 6, 0, 29)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = theme.SubText
    msgLabel.TextSize = 10
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.ZIndex = 92
    msgLabel.Parent = dialog
    
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0.42, 0, 0, 24)
    cancelBtn.Position = UDim2.new(0.05, 0, 1, -31)
    cancelBtn.BackgroundColor3 = theme.Element
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = theme.Text
    cancelBtn.TextSize = 11
    cancelBtn.Font = Enum.Font.GothamSemibold
    cancelBtn.BorderSizePixel = 0
    cancelBtn.ZIndex = 92
    cancelBtn.Parent = dialog
    AddCorner(cancelBtn, 5)
    AddStroke(cancelBtn, theme.Border, 1)
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.42, 0, 0, 24)
    yesBtn.Position = UDim2.new(0.53, 0, 1, -31)
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = Color3.fromRGB(255,255,255)
    yesBtn.TextSize = 11
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.BorderSizePixel = 0
    yesBtn.ZIndex = 92
    yesBtn.Parent = dialog
    AddCorner(yesBtn, 5)
    
    yesBtn.MouseEnter:Connect(function() Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(240, 60, 60)}, 0.15) end)
    yesBtn.MouseLeave:Connect(function() Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}, 0.15) end)
    cancelBtn.MouseEnter:Connect(function() Tween(cancelBtn, {BackgroundColor3 = theme.ElementHover}, 0.15) end)
    cancelBtn.MouseLeave:Connect(function() Tween(cancelBtn, {BackgroundColor3 = theme.Element}, 0.15) end)
    
    local function closeDialog()
        Tween(dialog, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2, "Quart", "In")
        Tween(overlay, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.22)
        dialog:Destroy()
        overlay:Destroy()
    end
    
    cancelBtn.MouseButton1Click:Connect(function()
        closeDialog()
        if onCancel then onCancel() end
    end)
    
    yesBtn.MouseButton1Click:Connect(function()
        closeDialog()
        if onYes then onYes() end
    end)
end

-- ═══════════════════════════════════════════════════
--              AUTO SAVE LOOP
-- ═══════════════════════════════════════════════════
function LolHub:StartAutoSaveLoop(interval)
    interval = interval or 30
    task.spawn(function()
        while true do
            task.wait(interval)
            if self.Config.AutoSaveLoad then
                SaveFile(self.Config.AutoSaveFile, self.Flags)
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════
--              DESTROY
-- ═══════════════════════════════════════════════════
function LolHub:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- ═══════════════════════════════════════════════════
--              RETURN LIBRARY
-- ═══════════════════════════════════════════════════
return LolHub

--[[
═══════════════════════════════════════════════════
    USAGE EXAMPLE:
═══════════════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Elison999/Neon-Lira-V2-lib/refs/heads/main/Library.Lua"))()

local Lib = Library:Init({
    -- Key System
    KeyEnable = false,
    Key = "LolHub2024",
    KeyName = "LolHub Key System",
    KeySave = true,
    KeyFileName = "LolHub.json",
    GetKeyFromSite = false,
    KeySite = "https://pastebin.com/raw/...",

    -- Loading Screen
    LoadingName = "Loading Lol Hub",
    ImageId = "1234567891",

    -- Auto Save
    AutoSaveLoad = true,
    AutoSaveFile = "LolHub_Save.json",

    -- Theme & Window
    Theme = "Dark Neon",
    Title = "LolHub",
    WindowIcon = "1234567891",
})

local Window = Lib:CreateWindow({
    Title = "LolHub v2.0",
    Icon = "1234567891",
    Size = UDim2.new(0, 388, 0, 312),
})

local MainTab = Window:AddTab({ Name = "Main" })
local ESPTab = Window:AddTab({ Name = "ESP" })

-- 1. Button
MainTab:AddButton({
    Name = "Do Something",
    Callback = function()
        print("Button clicked!")
    end,
})

-- 2. Toggle
local myToggle = MainTab:AddToggle({
    Name = "Enable Feature",
    Flag = "FeatureEnabled",
    Default = false,
    Description = "Enables the main feature",
    Callback = function(val)
        print("Toggle:", val)
    end,
})

-- 3. Slider
local mySlider = MainTab:AddSlider({
    Name = "Speed",
    Flag = "PlayerSpeed",
    Min = 0,
    Max = 200,
    Default = 16,
    Step = 1,
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end,
})

-- 4. Dropdown
local myDropdown = MainTab:AddDropdown({
    Name = "Team",
    Flag = "SelectedTeam",
    Options = {"Attackers", "Defenders", "Support", "None"},
    Default = "None",
    Callback = function(val)
        print("Selected:", val)
    end,
})

-- 5. Input
local myInput = MainTab:AddInput({
    Name = "Player Name",
    Flag = "TargetPlayer",
    Placeholder = "Enter player name...",
    Callback = function(text, entered)
        if entered then print("Input:", text) end
    end,
})

-- 6. Label
MainTab:AddLabel({ Text = "Some information text", Bold = true })

-- 7. Section
MainTab:AddSection({ Name = "Visual" })

-- 8. ColorPicker
local myColor = ESPTab:AddColorPicker({
    Name = "ESP Color",
    Flag = "ESPColor",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end,
})

-- 9. Keybind
local myKeybind = ESPTab:AddKeybind({
    Name = "Toggle ESP",
    Flag = "ESPKey",
    Default = Enum.KeyCode.X,
    OnPress = function()
        print("ESP toggled!")
    end,
})

-- 10. Multi-Select
local myMulti = ESPTab:AddMultiSelect({
    Name = "Show On ESP",
    Flag = "ESPShow",
    Options = {"Players", "Items", "Chests", "Enemies"},
    Default = {"Players"},
    Callback = function(selected)
        print("Selected:", table.concat(selected, ", "))
    end,
})

-- 11. Progress Bar
local myProgress = ESPTab:AddProgressBar({
    Name = "Loading...",
    Default = 0,
    Max = 100,
})

-- 12. Paragraph
ESPTab:AddParagraph({
    Title = "About ESP",
    Content = "This ESP module highlights enemies, items, and more. Use the options above to configure.",
})

-- Config Tab (built-in)
Window:AddConfig()

-- Notifications
Lib:Notify("Welcome!", "LolHub loaded successfully.", 5, "success")

-- Start auto save loop (saves every 30 seconds)
Lib:StartAutoSaveLoop(30)

-- Check when ready (after key + loading)
Lib:OnReady(function()
    print("LolHub is ready!")
end)
]]
