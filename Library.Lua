--[[
    Roblox UI Library - Advanced Edition
    Criado com sistema de Key, Loading, AutoSave, Themes e 12 Elementos
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configurações padrão
local DefaultConfig = {
    KeyEnable = false,
    Key = "1234",
    KeyName = "KeySystem",
    KeySave = false,
    KeyFileName = "LolHub.JSON",
    GetKeyFromSite = false,
    KeySite = "",
    LoadingName = "Loading Lol Hub",
    ImageId = "",
    AutoSaveLoad = true,
    Theme = "Dark"
}

-- Sistema de Themes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 30),
        Topbar = Color3.fromRGB(35, 35, 40),
        ElementBG = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(50, 50, 60)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Topbar = Color3.fromRGB(220, 220, 230),
        ElementBG = Color3.fromRGB(230, 230, 240),
        Accent = Color3.fromRGB(70, 130, 255),
        Text = Color3.fromRGB(20, 20, 30),
        SubText = Color3.fromRGB(100, 100, 120),
        Border = Color3.fromRGB(200, 200, 210)
    },
    Blue = {
        Background = Color3.fromRGB(15, 25, 45),
        Topbar = Color3.fromRGB(25, 40, 70),
        ElementBG = Color3.fromRGB(20, 30, 55),
        Accent = Color3.fromRGB(60, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 180, 220),
        Border = Color3.fromRGB(40, 60, 100)
    },
    Purple = {
        Background = Color3.fromRGB(30, 20, 40),
        Topbar = Color3.fromRGB(50, 30, 70),
        ElementBG = Color3.fromRGB(40, 25, 55),
        Accent = Color3.fromRGB(150, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 150, 230),
        Border = Color3.fromRGB(70, 40, 100)
    },
    Red = {
        Background = Color3.fromRGB(35, 20, 20),
        Topbar = Color3.fromRGB(60, 30, 30),
        ElementBG = Color3.fromRGB(45, 25, 25),
        Accent = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(230, 150, 150),
        Border = Color3.fromRGB(80, 40, 40)
    },
    Green = {
        Background = Color3.fromRGB(20, 35, 25),
        Topbar = Color3.fromRGB(30, 60, 40),
        ElementBG = Color3.fromRGB(25, 45, 30),
        Accent = Color3.fromRGB(80, 255, 120),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 230, 170),
        Border = Color3.fromRGB(40, 80, 50)
    },
    Orange = {
        Background = Color3.fromRGB(40, 30, 20),
        Topbar = Color3.fromRGB(70, 50, 30),
        ElementBG = Color3.fromRGB(55, 40, 25),
        Accent = Color3.fromRGB(255, 140, 50),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(230, 180, 130),
        Border = Color3.fromRGB(100, 70, 40)
    },
    Cyan = {
        Background = Color3.fromRGB(15, 35, 40),
        Topbar = Color3.fromRGB(25, 60, 70),
        ElementBG = Color3.fromRGB(20, 45, 55),
        Accent = Color3.fromRGB(50, 200, 220),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(130, 210, 230),
        Border = Color3.fromRGB(35, 80, 90)
    },
    Pink = {
        Background = Color3.fromRGB(40, 20, 35),
        Topbar = Color3.fromRGB(70, 30, 60),
        ElementBG = Color3.fromRGB(55, 25, 45),
        Accent = Color3.fromRGB(255, 100, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(230, 150, 210),
        Border = Color3.fromRGB(100, 40, 80)
    },
    Yellow = {
        Background = Color3.fromRGB(40, 40, 20),
        Topbar = Color3.fromRGB(70, 70, 30),
        ElementBG = Color3.fromRGB(55, 55, 25),
        Accent = Color3.fromRGB(255, 220, 50),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(230, 220, 130),
        Border = Color3.fromRGB(100, 100, 40)
    }
}

-- Funções de Utilidade
local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Sistema de Save/Load
local function SaveConfig(fileName, data)
    local success, err = pcall(function()
        writefile(fileName, HttpService:JSONEncode(data))
    end)
    return success
end

local function LoadConfig(fileName)
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(fileName))
    end)
    if success then
        return data
    end
    return nil
end

-- Criar Loading Screen
local function CreateLoadingScreen(config)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadingScreen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.3
    Background.BorderSizePixel = 0
    Background.Parent = ScreenGui
    
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Size = UDim2.new(0, 400, 0, 300)
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = Background
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = LoadingFrame
    
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 120, 0, 120)
    Logo.Position = UDim2.new(0.5, 0, 0, 30)
    Logo.AnchorPoint = Vector2.new(0.5, 0)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://" .. (config.ImageId or "")
    Logo.Parent = LoadingFrame
    
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(1, -40, 0, 30)
    LoadingText.Position = UDim2.new(0, 20, 0, 170)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = config.LoadingName or "Loading..."
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 20
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Parent = LoadingFrame
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(1, -60, 0, 8)
    ProgressBar.Position = UDim2.new(0, 30, 0, 220)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = LoadingFrame
    
    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(1, 0)
    ProgressBarCorner.Parent = ProgressBar
    
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new(0, 0, 1, 0)
    Progress.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Progress.BorderSizePixel = 0
    Progress.Parent = ProgressBar
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
    local PercentText = Instance.new("TextLabel")
    PercentText.Name = "PercentText"
    PercentText.Size = UDim2.new(1, 0, 0, 30)
    PercentText.Position = UDim2.new(0, 0, 0, 245)
    PercentText.BackgroundTransparency = 1
    PercentText.Text = "0%"
    PercentText.TextColor3 = Color3.fromRGB(180, 180, 180)
    PercentText.TextSize = 16
    PercentText.Font = Enum.Font.Gotham
    PercentText.Parent = LoadingFrame
    
    -- Animação de loading
    task.spawn(function()
        for i = 0, 100, 2 do
            wait(0.02)
            Tween(Progress, {Size = UDim2.new(i/100, 0, 1, 0)}, 0.1)
            PercentText.Text = i .. "%"
        end
        wait(0.5)
        Tween(Background, {BackgroundTransparency = 1}, 0.3)
        Tween(LoadingFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    return ScreenGui
end

-- Criar Key System
local function CreateKeySystem(config, callback)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.3
    Background.BorderSizePixel = 0
    Background.Parent = ScreenGui
    
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 450, 0, 350)
    KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = Background
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = KeyFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Title.Text = config.KeyName or "Key System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0
    Title.Parent = KeyFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = Title
    
    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 100, 0, 100)
    Logo.Position = UDim2.new(0.5, 0, 0, 70)
    Logo.AnchorPoint = Vector2.new(0.5, 0)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://" .. (config.ImageId or "")
    Logo.Parent = KeyFrame
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, -60, 0, 40)
    KeyInput.Position = UDim2.new(0, 30, 0, 190)
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.BorderSizePixel = 0
    KeyInput.Parent = KeyFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = KeyInput
    
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(0, 150, 0, 40)
    SubmitButton.Position = UDim2.new(0.5, -75, 0, 250)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SubmitButton.Text = "Submit"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 18
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Parent = KeyFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = SubmitButton
    
    if config.GetKeyFromSite and config.KeySite ~= "" then
        local GetKeyButton = Instance.new("TextButton")
        GetKeyButton.Name = "GetKeyButton"
        GetKeyButton.Size = UDim2.new(0, 150, 0, 30)
        GetKeyButton.Position = UDim2.new(0.5, -75, 0, 305)
        GetKeyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        GetKeyButton.Text = "Get Key"
        GetKeyButton.TextColor3 = Color3.fromRGB(200, 200, 210)
        GetKeyButton.TextSize = 14
        GetKeyButton.Font = Enum.Font.Gotham
        GetKeyButton.BorderSizePixel = 0
        GetKeyButton.Parent = KeyFrame
        
        local GetKeyCorner = Instance.new("UICorner")
        GetKeyCorner.CornerRadius = UDim.new(0, 8)
        GetKeyCorner.Parent = GetKeyButton
        
        GetKeyButton.MouseButton1Click:Connect(function()
            setclipboard(config.KeySite)
            GetKeyButton.Text = "Link Copied!"
            wait(2)
            GetKeyButton.Text = "Get Key"
        end)
    end
    
    SubmitButton.MouseButton1Click:Connect(function()
        local enteredKey = KeyInput.Text
        local correctKey = config.Key
        
        if enteredKey == correctKey then
            if config.KeySave then
                SaveConfig(config.KeyFileName, {Key = enteredKey})
            end
            Tween(Background, {BackgroundTransparency = 1}, 0.3)
            Tween(KeyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            wait(0.3)
            ScreenGui:Destroy()
            callback(true)
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Wrong Key!"
            Tween(KeyFrame, {Position = UDim2.new(0.5, -10, 0.5, 0)}, 0.05)
            Tween(KeyFrame, {Position = UDim2.new(0.5, 10, 0.5, 0)}, 0.05)
            Tween(KeyFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.05)
            wait(1)
            KeyInput.PlaceholderText = "Enter Key..."
        end
    end)
end

-- Criar Window Principal
function Library:CreateWindow(config)
    config = config or {}
    for k, v in pairs(DefaultConfig) do
        if config[k] == nil then
            config[k] = v
        end
    end
    
    local Window = {}
    Window.Config = config
    Window.Tabs = {}
    Window.Elements = {}
    Window.SaveData = {}
    Window.CurrentTheme = config.Theme
    Window.BackgroundOpacity = false
    
    -- Verificar Key System
    local function InitializeWindow()
        -- Criar Loading Screen
        CreateLoadingScreen(config)
        wait(2)
        
        -- Criar GUI
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "UILibrary"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = game.CoreGui
        Window.ScreenGui = ScreenGui
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 600, 0, 450)
        MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
        MainFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
        MainFrame.BorderSizePixel = 0
        MainFrame.ClipsDescendants = true
        MainFrame.Parent = ScreenGui
        Window.MainFrame = MainFrame
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 10)
        MainCorner.Parent = MainFrame
        
        -- Topbar
        local Topbar = Instance.new("Frame")
        Topbar.Name = "Topbar"
        Topbar.Size = UDim2.new(1, 0, 0, 40)
        Topbar.BackgroundColor3 = Themes[Window.CurrentTheme].Topbar
        Topbar.BorderSizePixel = 0
        Topbar.Parent = MainFrame
        
        local TopbarCorner = Instance.new("UICorner")
        TopbarCorner.CornerRadius = UDim.new(0, 10)
        TopbarCorner.Parent = Topbar
        
        local TopbarFix = Instance.new("Frame")
        TopbarFix.Size = UDim2.new(1, 0, 0, 20)
        TopbarFix.Position = UDim2.new(0, 0, 1, -20)
        TopbarFix.BackgroundColor3 = Themes[Window.CurrentTheme].Topbar
        TopbarFix.BorderSizePixel = 0
        TopbarFix.Parent = Topbar
        
        MakeDraggable(MainFrame, Topbar)
        
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 28, 0, 28)
        Icon.Position = UDim2.new(0, 8, 0, 6)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://" .. (config.ImageId or "")
        Icon.Parent = Topbar
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -150, 1, 0)
        Title.Position = UDim2.new(0, 42, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = config.WindowName or "UI Library"
        Title.TextColor3 = Themes[Window.CurrentTheme].Text
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Topbar
        
        -- Botões do Topbar
        local buttonX = -10
        
        -- Botão Close
        local CloseButton = Instance.new("TextButton")
        CloseButton.Name = "CloseButton"
        CloseButton.Size = UDim2.new(0, 30, 0, 30)
        CloseButton.Position = UDim2.new(1, buttonX, 0, 5)
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        CloseButton.Text = "✕"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 18
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.BorderSizePixel = 0
        CloseButton.Parent = Topbar
        buttonX = buttonX - 35
        
        local CloseCorner = Instance.new("UICorner")
        CloseCorner.CornerRadius = UDim.new(0, 6)
        CloseCorner.Parent = CloseButton
        
        -- Botão Minimize
        local MinimizeButton = Instance.new("TextButton")
        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
        MinimizeButton.Position = UDim2.new(1, buttonX, 0, 5)
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
        MinimizeButton.Text = "─"
        MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MinimizeButton.TextSize = 18
        MinimizeButton.Font = Enum.Font.GothamBold
        MinimizeButton.BorderSizePixel = 0
        MinimizeButton.Parent = Topbar
        buttonX = buttonX - 35
        
        local MinimizeCorner = Instance.new("UICorner")
        MinimizeCorner.CornerRadius = UDim.new(0, 6)
        MinimizeCorner.Parent = MinimizeButton
        
        -- Botão Resize
        local ResizeButton = Instance.new("TextButton")
        ResizeButton.Name = "ResizeButton"
        ResizeButton.Size = UDim2.new(0, 30, 0, 30)
        ResizeButton.Position = UDim2.new(1, buttonX, 0, 5)
        ResizeButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        ResizeButton.Text = "⇱"
        ResizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ResizeButton.TextSize = 18
        ResizeButton.Font = Enum.Font.GothamBold
        ResizeButton.BorderSizePixel = 0
        ResizeButton.Parent = Topbar
        
        local ResizeCorner = Instance.new("UICorner")
        ResizeCorner.CornerRadius = UDim.new(0, 6)
        ResizeCorner.Parent = ResizeButton
        
        -- Funcionalidade Minimize
        local isMinimized = false
        MinimizeButton.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            if isMinimized then
                Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
                MinimizeButton.Text = "+"
            else
                Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.3)
                MinimizeButton.Text = "─"
            end
        end)
        
        -- Funcionalidade Resize
        local isResized = false
        ResizeButton.MouseButton1Click:Connect(function()
            isResized = not isResized
            if isResized then
                Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 550)}, 0.3)
            else
                Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.3)
            end
        end)
        
        -- Funcionalidade Close com confirmação
        CloseButton.MouseButton1Click:Connect(function()
            local ConfirmFrame = Instance.new("Frame")
            ConfirmFrame.Name = "ConfirmFrame"
            ConfirmFrame.Size = UDim2.new(0, 300, 0, 150)
            ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
            ConfirmFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            ConfirmFrame.BorderSizePixel = 0
            ConfirmFrame.ZIndex = 10
            ConfirmFrame.Parent = MainFrame
            
            local ConfirmCorner = Instance.new("UICorner")
            ConfirmCorner.CornerRadius = UDim.new(0, 10)
            ConfirmCorner.Parent = ConfirmFrame
            
            local ConfirmText = Instance.new("TextLabel")
            ConfirmText.Size = UDim2.new(1, -20, 0, 60)
            ConfirmText.Position = UDim2.new(0, 10, 0, 20)
            ConfirmText.BackgroundTransparency = 1
            ConfirmText.Text = "Are you sure you want to close?"
            ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmText.TextSize = 16
            ConfirmText.Font = Enum.Font.Gotham
            ConfirmText.TextWrapped = true
            ConfirmText.Parent = ConfirmFrame
            
            local YesButton = Instance.new("TextButton")
            YesButton.Size = UDim2.new(0, 120, 0, 35)
            YesButton.Position = UDim2.new(0, 20, 1, -50)
            YesButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
            YesButton.Text = "Yes"
            YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            YesButton.TextSize = 16
            YesButton.Font = Enum.Font.GothamBold
            YesButton.BorderSizePixel = 0
            YesButton.Parent = ConfirmFrame
            
            local YesCorner = Instance.new("UICorner")
            YesCorner.CornerRadius = UDim.new(0, 6)
            YesCorner.Parent = YesButton
            
            local CancelButton = Instance.new("TextButton")
            CancelButton.Size = UDim2.new(0, 120, 0, 35)
            CancelButton.Position = UDim2.new(1, -140, 1, -50)
            CancelButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            CancelButton.Text = "Cancel"
            CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CancelButton.TextSize = 16
            CancelButton.Font = Enum.Font.GothamBold
            CancelButton.BorderSizePixel = 0
            CancelButton.Parent = ConfirmFrame
            
            local CancelCorner = Instance.new("UICorner")
            CancelCorner.CornerRadius = UDim.new(0, 6)
            CancelCorner.Parent = CancelButton
            
            YesButton.MouseButton1Click:Connect(function()
                ScreenGui:Destroy()
            end)
            
            CancelButton.MouseButton1Click:Connect(function()
                ConfirmFrame:Destroy()
            end)
        end)
        
        -- Container para Tabs
        local TabContainer = Instance.new("Frame")
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(0, 150, 1, -50)
        TabContainer.Position = UDim2.new(0, 5, 0, 45)
        TabContainer.BackgroundColor3 = Themes[Window.CurrentTheme].ElementBG
        TabContainer.BorderSizePixel = 0
        TabContainer.Parent = MainFrame
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabContainer
        
        local TabList = Instance.new("UIListLayout")
        TabList.Padding = UDim.new(0, 5)
        TabList.Parent = TabContainer
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingTop = UDim.new(0, 5)
        TabPadding.PaddingLeft = UDim.new(0, 5)
        TabPadding.PaddingRight = UDim.new(0, 5)
        TabPadding.Parent = TabContainer
        
        -- Container para Elementos
        local ElementContainer = Instance.new("Frame")
        ElementContainer.Name = "ElementContainer"
        ElementContainer.Size = UDim2.new(1, -165, 1, -50)
        ElementContainer.Position = UDim2.new(0, 160, 0, 45)
        ElementContainer.BackgroundColor3 = Themes[Window.CurrentTheme].ElementBG
        ElementContainer.BorderSizePixel = 0
        ElementContainer.Parent = MainFrame
        
        local ElementCorner = Instance.new("UICorner")
        ElementCorner.CornerRadius = UDim.new(0, 8)
        ElementCorner.Parent = ElementContainer
        
        Window.TabContainer = TabContainer
        Window.ElementContainer = ElementContainer
        
        -- Função para atualizar tema
        function Window:UpdateTheme(themeName)
            if not Themes[themeName] then return end
            Window.CurrentTheme = themeName
            local theme = Themes[themeName]
            
            MainFrame.BackgroundColor3 = theme.Background
            Topbar.BackgroundColor3 = theme.Topbar
            TopbarFix.BackgroundColor3 = theme.Topbar
            Title.TextColor3 = theme.Text
            TabContainer.BackgroundColor3 = theme.ElementBG
            ElementContainer.BackgroundColor3 = theme.ElementBG
            
            -- Atualizar todos os elementos
            for _, element in pairs(Window.Elements) do
                if element.UpdateTheme then
                    element:UpdateTheme(theme)
                end
            end
        end
        
        -- Função para alterar opacidade do fundo
        function Window:SetBackgroundOpacity(enabled)
            Window.BackgroundOpacity = enabled
            if enabled then
                MainFrame.BackgroundTransparency = 0.4
            else
                MainFrame.BackgroundTransparency = 0
            end
        end
        
        -- Carregar dados salvos
        if config.AutoSaveLoad then
            local savedData = LoadConfig("UILibrary_SaveData.json")
            if savedData then
                Window.SaveData = savedData
                -- Aplicar configurações salvas
                if savedData.Theme then
                    Window:UpdateTheme(savedData.Theme)
                end
                if savedData.BackgroundOpacity ~= nil then
                    Window:SetBackgroundOpacity(savedData.BackgroundOpacity)
                end
            end
        end
    end
    
    -- Verificar se precisa mostrar Key System
    if config.KeyEnable then
        local savedKey = nil
        if config.KeySave then
            savedKey = LoadConfig(config.KeyFileName)
        end
        
        if savedKey and savedKey.Key == config.Key then
            InitializeWindow()
        else
            CreateKeySystem(config, function(success)
                if success then
                    InitializeWindow()
                end
            end)
        end
    else
        InitializeWindow()
    end
    
    -- Função para adicionar Tab
    function Window:AddTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}
        Tab.Active = false
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = Themes[Window.CurrentTheme].Border
        TabButton.Text = name
        TabButton.TextColor3 = Themes[Window.CurrentTheme].SubText
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.BorderSizePixel = 0
        TabButton.Parent = Window.TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Themes[Window.CurrentTheme].Accent
        TabContent.Visible = false
        TabContent.Parent = Window.ElementContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        Tab.TabButton = TabButton
        Tab.TabContent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Active = false
                tab.TabContent.Visible = false
                tab.TabButton.BackgroundColor3 = Themes[Window.CurrentTheme].Border
                tab.TabButton.TextColor3 = Themes[Window.CurrentTheme].SubText
            end
            
            Tab.Active = true
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
            TabButton.TextColor3 = Themes[Window.CurrentTheme].Text
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click()
        end
        
        -- ELEMENTOS DA TAB
        
        -- 1. Button
        function Tab:AddButton(options)
            local Button = {}
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ButtonFrame.Text = ""
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonText = Instance.new("TextLabel")
            ButtonText.Size = UDim2.new(1, -15, 1, 0)
            ButtonText.Position = UDim2.new(0, 10, 0, 0)
            ButtonText.BackgroundTransparency = 1
            ButtonText.Text = options.Name or "Button"
            ButtonText.TextColor3 = Themes[Window.CurrentTheme].Text
            ButtonText.TextSize = 14
            ButtonText.Font = Enum.Font.Gotham
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left
            ButtonText.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Themes[Window.CurrentTheme].Accent}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Themes[Window.CurrentTheme].Background}, 0.1)
                if options.Callback then
                    options.Callback()
                end
            end)
            
            function Button:UpdateTheme(theme)
                ButtonFrame.BackgroundColor3 = theme.Background
                ButtonText.TextColor3 = theme.Text
            end
            
            table.insert(Window.Elements, Button)
            return Button
        end
        
        -- 2. Toggle
        function Tab:AddToggle(options)
            local Toggle = {}
            Toggle.Value = options.Default or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleText = Instance.new("TextLabel")
            ToggleText.Size = UDim2.new(1, -60, 1, 0)
            ToggleText.Position = UDim2.new(0, 10, 0, 0)
            ToggleText.BackgroundTransparency = 1
            ToggleText.Text = options.Name or "Toggle"
            ToggleText.TextColor3 = Themes[Window.CurrentTheme].Text
            ToggleText.TextSize = 14
            ToggleText.Font = Enum.Font.Gotham
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = Toggle.Value and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = Toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                Tween(ToggleButton, {BackgroundColor3 = Toggle.Value and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)}, 0.2)
                Tween(ToggleCircle, {Position = Toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                
                if options.Callback then
                    options.Callback(Toggle.Value)
                end
                
                if Window.Config.AutoSaveLoad then
                    Window.SaveData[options.Name] = Toggle.Value
                    SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                end
            end)
            
            -- Carregar valor salvo
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] ~= nil then
                Toggle.Value = Window.SaveData[options.Name]
                ToggleButton.BackgroundColor3 = Toggle.Value and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)
                ToggleCircle.Position = Toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            end
            
            function Toggle:Set(value)
                Toggle.Value = value
                Tween(ToggleButton, {BackgroundColor3 = value and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)}, 0.2)
                Tween(ToggleCircle, {Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
            end
            
            function Toggle:UpdateTheme(theme)
                ToggleFrame.BackgroundColor3 = theme.Background
                ToggleText.TextColor3 = theme.Text
                if Toggle.Value then
                    ToggleButton.BackgroundColor3 = theme.Accent
                end
            end
            
            table.insert(Window.Elements, Toggle)
            return Toggle
        end
        
        -- 3. Slider
        function Tab:AddSlider(options)
            local Slider = {}
            Slider.Value = options.Default or options.Min or 0
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderText = Instance.new("TextLabel")
            SliderText.Size = UDim2.new(1, -20, 0, 20)
            SliderText.Position = UDim2.new(0, 10, 0, 5)
            SliderText.BackgroundTransparency = 1
            SliderText.Text = (options.Name or "Slider") .. ": " .. Slider.Value
            SliderText.TextColor3 = Themes[Window.CurrentTheme].Text
            SliderText.TextSize = 14
            SliderText.Font = Enum.Font.Gotham
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Slider.Value - options.Min) / (options.Max - options.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = UserInputService:GetMouseLocation()
                    local relativePos = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    Slider.Value = math.floor(options.Min + (options.Max - options.Min) * relativePos)
                    
                    SliderText.Text = (options.Name or "Slider") .. ": " .. Slider.Value
                    Tween(SliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
                    
                    if options.Callback then
                        options.Callback(Slider.Value)
                    end
                    
                    if Window.Config.AutoSaveLoad then
                        Window.SaveData[options.Name] = Slider.Value
                        SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                    end
                end
            end)
            
            -- Carregar valor salvo
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] then
                Slider.Value = Window.SaveData[options.Name]
                SliderText.Text = (options.Name or "Slider") .. ": " .. Slider.Value
                SliderFill.Size = UDim2.new((Slider.Value - options.Min) / (options.Max - options.Min), 0, 1, 0)
            end
            
            function Slider:Set(value)
                Slider.Value = math.clamp(value, options.Min, options.Max)
                SliderText.Text = (options.Name or "Slider") .. ": " .. Slider.Value
                Tween(SliderFill, {Size = UDim2.new((Slider.Value - options.Min) / (options.Max - options.Min), 0, 1, 0)}, 0.2)
            end
            
            function Slider:UpdateTheme(theme)
                SliderFrame.BackgroundColor3 = theme.Background
                SliderText.TextColor3 = theme.Text
                SliderFill.BackgroundColor3 = theme.Accent
            end
            
            table.insert(Window.Elements, Slider)
            return Slider
        end
        
        -- 4. Dropdown
        function Tab:AddDropdown(options)
            local Dropdown = {}
            Dropdown.Value = options.Default or options.Options[1] or ""
            Dropdown.Open = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownHeader = Instance.new("TextButton")
            DropdownHeader.Size = UDim2.new(1, 0, 0, 40)
            DropdownHeader.BackgroundTransparency = 1
            DropdownHeader.Text = ""
            DropdownHeader.Parent = DropdownFrame
            
            local DropdownText = Instance.new("TextLabel")
            DropdownText.Size = UDim2.new(1, -50, 1, 0)
            DropdownText.Position = UDim2.new(0, 10, 0, 0)
            DropdownText.BackgroundTransparency = 1
            DropdownText.Text = (options.Name or "Dropdown") .. ": " .. Dropdown.Value
            DropdownText.TextColor3 = Themes[Window.CurrentTheme].Text
            DropdownText.TextSize = 14
            DropdownText.Font = Enum.Font.Gotham
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left
            DropdownText.Parent = DropdownHeader
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Themes[Window.CurrentTheme].SubText
            DropdownArrow.TextSize = 12
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.Parent = DropdownHeader
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, -10, 0, 0)
            DropdownList.Position = UDim2.new(0, 5, 0, 45)
            DropdownList.BackgroundTransparency = 1
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Themes[Window.CurrentTheme].Accent
            DropdownList.Parent = DropdownFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = DropdownList
            
            for _, option in ipairs(options.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Themes[Window.CurrentTheme].ElementBG
                OptionButton.Text = option
                OptionButton.TextColor3 = Themes[Window.CurrentTheme].Text
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    Dropdown.Value = option
                    DropdownText.Text = (options.Name or "Dropdown") .. ": " .. option
                    
                    Dropdown.Open = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    
                    if options.Callback then
                        options.Callback(option)
                    end
                    
                    if Window.Config.AutoSaveLoad then
                        Window.SaveData[options.Name] = option
                        SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                    end
                end)
            end
            
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            
            DropdownHeader.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                if Dropdown.Open then
                    local listHeight = math.min(120, ListLayout.AbsoluteContentSize.Y)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + listHeight + 10)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    DropdownList.Size = UDim2.new(1, -10, 0, listHeight)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            -- Carregar valor salvo
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] then
                Dropdown.Value = Window.SaveData[options.Name]
                DropdownText.Text = (options.Name or "Dropdown") .. ": " .. Dropdown.Value
            end
            
            function Dropdown:Set(value)
                Dropdown.Value = value
                DropdownText.Text = (options.Name or "Dropdown") .. ": " .. value
            end
            
            function Dropdown:UpdateTheme(theme)
                DropdownFrame.BackgroundColor3 = theme.Background
                DropdownText.TextColor3 = theme.Text
                DropdownArrow.TextColor3 = theme.SubText
            end
            
            table.insert(Window.Elements, Dropdown)
            return Dropdown
        end
        
        -- 5. Label
        function Tab:AddLabel(text)
            local Label = {}
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.Size = UDim2.new(1, 0, 0, 30)
            LabelFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = LabelFrame
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(1, -20, 1, 0)
            LabelText.Position = UDim2.new(0, 10, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = text or "Label"
            LabelText.TextColor3 = Themes[Window.CurrentTheme].Text
            LabelText.TextSize = 14
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Parent = LabelFrame
            
            function Label:Set(newText)
                LabelText.Text = newText
            end
            
            function Label:UpdateTheme(theme)
                LabelFrame.BackgroundColor3 = theme.Background
                LabelText.TextColor3 = theme.Text
            end
            
            table.insert(Window.Elements, Label)
            return Label
        end
        
        -- 6. TextBox
        function Tab:AddTextBox(options)
            local TextBox = {}
            TextBox.Value = options.Default or ""
            
            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Name = "TextBox"
            TextBoxFrame.Size = UDim2.new(1, 0, 0, 45)
            TextBoxFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            TextBoxFrame.BorderSizePixel = 0
            TextBoxFrame.Parent = TabContent
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 6)
            TextBoxCorner.Parent = TextBoxFrame
            
            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Size = UDim2.new(1, -20, 0, 15)
            TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Text = options.Name or "TextBox"
            TextBoxLabel.TextColor3 = Themes[Window.CurrentTheme].SubText
            TextBoxLabel.TextSize = 12
            TextBoxLabel.Font = Enum.Font.Gotham
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxLabel.Parent = TextBoxFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -20, 0, 25)
            InputBox.Position = UDim2.new(0, 10, 0, 20)
            InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            InputBox.PlaceholderText = options.Placeholder or "Enter text..."
            InputBox.Text = TextBox.Value
            InputBox.TextColor3 = Themes[Window.CurrentTheme].Text
            InputBox.PlaceholderColor3 = Themes[Window.CurrentTheme].SubText
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.BorderSizePixel = 0
            InputBox.Parent = TextBoxFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 4)
            InputCorner.Parent = InputBox
            
            InputBox.FocusLost:Connect(function()
                TextBox.Value = InputBox.Text
                if options.Callback then
                    options.Callback(InputBox.Text)
                end
                
                if Window.Config.AutoSaveLoad then
                    Window.SaveData[options.Name] = InputBox.Text
                    SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                end
            end)
            
            -- Carregar valor salvo
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] then
                TextBox.Value = Window.SaveData[options.Name]
                InputBox.Text = TextBox.Value
            end
            
            function TextBox:Set(value)
                TextBox.Value = value
                InputBox.Text = value
            end
            
            function TextBox:UpdateTheme(theme)
                TextBoxFrame.BackgroundColor3 = theme.Background
                TextBoxLabel.TextColor3 = theme.SubText
                InputBox.TextColor3 = theme.Text
                InputBox.PlaceholderColor3 = theme.SubText
            end
            
            table.insert(Window.Elements, TextBox)
            return TextBox
        end
        
        -- 7. Keybind
        function Tab:AddKeybind(options)
            local Keybind = {}
            Keybind.Value = options.Default or Enum.KeyCode.E
            Keybind.Listening = false
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "Keybind"
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 6)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindText = Instance.new("TextLabel")
            KeybindText.Size = UDim2.new(1, -110, 1, 0)
            KeybindText.Position = UDim2.new(0, 10, 0, 0)
            KeybindText.BackgroundTransparency = 1
            KeybindText.Text = options.Name or "Keybind"
            KeybindText.TextColor3 = Themes[Window.CurrentTheme].Text
            KeybindText.TextSize = 14
            KeybindText.Font = Enum.Font.Gotham
            KeybindText.TextXAlignment = Enum.TextXAlignment.Left
            KeybindText.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 90, 0, 25)
            KeybindButton.Position = UDim2.new(1, -100, 0.5, -12.5)
            KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            KeybindButton.Text = Keybind.Value.Name
            KeybindButton.TextColor3 = Themes[Window.CurrentTheme].Text
            KeybindButton.TextSize = 13
            KeybindButton.Font = Enum.Font.Gotham
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Parent = KeybindFrame
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
            KeybindButtonCorner.Parent = KeybindButton
            
            KeybindButton.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                KeybindButton.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if Keybind.Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind.Value = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        Keybind.Listening = false
                        
                        if Window.Config.AutoSaveLoad then
                            Window.SaveData[options.Name] = input.KeyCode.Name
                            SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                        end
                    end
                elseif input.KeyCode == Keybind.Value and not gameProcessed then
                    if options.Callback then
                        options.Callback()
                    end
                end
            end)
            
            -- Carregar valor salvo
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] then
                Keybind.Value = Enum.KeyCode[Window.SaveData[options.Name]]
                KeybindButton.Text = Keybind.Value.Name
            end
            
            function Keybind:Set(keycode)
                Keybind.Value = keycode
                KeybindButton.Text = keycode.Name
            end
            
            function Keybind:UpdateTheme(theme)
                KeybindFrame.BackgroundColor3 = theme.Background
                KeybindText.TextColor3 = theme.Text
                KeybindButton.TextColor3 = theme.Text
            end
            
            table.insert(Window.Elements, Keybind)
            return Keybind
        end
        
        -- 8. ColorPicker
        function Tab:AddColorPicker(options)
            local ColorPicker = {}
            ColorPicker.Value = options.Default or Color3.fromRGB(255, 255, 255)
            
            local ColorPickerFrame = Instance.new("Frame")
            ColorPickerFrame.Name = "ColorPicker"
            ColorPickerFrame.Size = UDim2.new(1, 0, 0, 40)
            ColorPickerFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ColorPickerFrame.BorderSizePixel = 0
            ColorPickerFrame.Parent = TabContent
            
            local ColorPickerCorner = Instance.new("UICorner")
            ColorPickerCorner.CornerRadius = UDim.new(0, 6)
            ColorPickerCorner.Parent = ColorPickerFrame
            
            local ColorPickerText = Instance.new("TextLabel")
            ColorPickerText.Size = UDim2.new(1, -60, 1, 0)
            ColorPickerText.Position = UDim2.new(0, 10, 0, 0)
            ColorPickerText.BackgroundTransparency = 1
            ColorPickerText.Text = options.Name or "Color Picker"
            ColorPickerText.TextColor3 = Themes[Window.CurrentTheme].Text
            ColorPickerText.TextSize = 14
            ColorPickerText.Font = Enum.Font.Gotham
            ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
            ColorPickerText.Parent = ColorPickerFrame
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 40, 0, 25)
            ColorDisplay.Position = UDim2.new(1, -50, 0.5, -12.5)
            ColorDisplay.BackgroundColor3 = ColorPicker.Value
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorPickerFrame
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorDisplay
            
            -- Sistema simplificado de color picker (RGB sliders)
            ColorButton.MouseButton1Click:Connect(function()
                -- Aqui você pode implementar um color picker mais avançado
                -- Por simplicidade, vou usar valores aleatórios
                local r = math.random(0, 255)
                local g = math.random(0, 255)
                local b = math.random(0, 255)
                ColorPicker.Value = Color3.fromRGB(r, g, b)
                ColorDisplay.BackgroundColor3 = ColorPicker.Value
                
                if options.Callback then
                    options.Callback(ColorPicker.Value)
                end
                
                if Window.Config.AutoSaveLoad then
                    Window.SaveData[options.Name] = {R = r, G = g, B = b}
                    SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                end
            end)
            
            -- Carregar valor salvo
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] then
                local saved = Window.SaveData[options.Name]
                ColorPicker.Value = Color3.fromRGB(saved.R, saved.G, saved.B)
                ColorDisplay.BackgroundColor3 = ColorPicker.Value
            end
            
            function ColorPicker:Set(color)
                ColorPicker.Value = color
                ColorDisplay.BackgroundColor3 = color
            end
            
            function ColorPicker:UpdateTheme(theme)
                ColorPickerFrame.BackgroundColor3 = theme.Background
                ColorPickerText.TextColor3 = theme.Text
            end
            
            table.insert(Window.Elements, ColorPicker)
            return ColorPicker
        end
        
        -- 9. Section (Separator)
        function Tab:AddSection(text)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 25)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionText = Instance.new("TextLabel")
            SectionText.Size = UDim2.new(1, -20, 1, 0)
            SectionText.Position = UDim2.new(0, 10, 0, 0)
            SectionText.BackgroundTransparency = 1
            SectionText.Text = text or "Section"
            SectionText.TextColor3 = Themes[Window.CurrentTheme].Accent
            SectionText.TextSize = 15
            SectionText.Font = Enum.Font.GothamBold
            SectionText.TextXAlignment = Enum.TextXAlignment.Left
            SectionText.Parent = SectionFrame
            
            local SectionLine = Instance.new("Frame")
            SectionLine.Size = UDim2.new(1, -20, 0, 1)
            SectionLine.Position = UDim2.new(0, 10, 1, -5)
            SectionLine.BackgroundColor3 = Themes[Window.CurrentTheme].Border
            SectionLine.BorderSizePixel = 0
            SectionLine.Parent = SectionFrame
            
            function Section:UpdateTheme(theme)
                SectionText.TextColor3 = theme.Accent
                SectionLine.BackgroundColor3 = theme.Border
            end
            
            table.insert(Window.Elements, Section)
            return Section
        end
        
        -- 10. Paragraph
        function Tab:AddParagraph(title, content)
            local Paragraph = {}
            
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = "Paragraph"
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 60)
            ParagraphFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContent
            
            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 6)
            ParagraphCorner.Parent = ParagraphFrame
            
            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -20, 0, 20)
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = title or "Title"
            ParagraphTitle.TextColor3 = Themes[Window.CurrentTheme].Text
            ParagraphTitle.TextSize = 14
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame
            
            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -20, 1, -30)
            ParagraphContent.Position = UDim2.new(0, 10, 0, 25)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = content or "Content"
            ParagraphContent.TextColor3 = Themes[Window.CurrentTheme].SubText
            ParagraphContent.TextSize = 12
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame
            
            function Paragraph:Set(newTitle, newContent)
                ParagraphTitle.Text = newTitle
                ParagraphContent.Text = newContent
            end
            
            function Paragraph:UpdateTheme(theme)
                ParagraphFrame.BackgroundColor3 = theme.Background
                ParagraphTitle.TextColor3 = theme.Text
                ParagraphContent.TextColor3 = theme.SubText
            end
            
            table.insert(Window.Elements, Paragraph)
            return Paragraph
        end
        
        -- 11. MultiDropdown (Checkbox list)
        function Tab:AddMultiDropdown(options)
            local MultiDropdown = {}
            MultiDropdown.Values = {}
            MultiDropdown.Open = false
            
            local MultiDropdownFrame = Instance.new("Frame")
            MultiDropdownFrame.Name = "MultiDropdown"
            MultiDropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            MultiDropdownFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            MultiDropdownFrame.BorderSizePixel = 0
            MultiDropdownFrame.ClipsDescendants = true
            MultiDropdownFrame.Parent = TabContent
            
            local MultiDropdownCorner = Instance.new("UICorner")
            MultiDropdownCorner.CornerRadius = UDim.new(0, 6)
            MultiDropdownCorner.Parent = MultiDropdownFrame
            
            local DropdownHeader = Instance.new("TextButton")
            DropdownHeader.Size = UDim2.new(1, 0, 0, 40)
            DropdownHeader.BackgroundTransparency = 1
            DropdownHeader.Text = ""
            DropdownHeader.Parent = MultiDropdownFrame
            
            local DropdownText = Instance.new("TextLabel")
            DropdownText.Size = UDim2.new(1, -50, 1, 0)
            DropdownText.Position = UDim2.new(0, 10, 0, 0)
            DropdownText.BackgroundTransparency = 1
            DropdownText.Text = (options.Name or "Multi Select") .. ": None"
            DropdownText.TextColor3 = Themes[Window.CurrentTheme].Text
            DropdownText.TextSize = 14
            DropdownText.Font = Enum.Font.Gotham
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left
            DropdownText.Parent = DropdownHeader
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -30, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Themes[Window.CurrentTheme].SubText
            DropdownArrow.TextSize = 12
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.Parent = DropdownHeader
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, -10, 0, 0)
            DropdownList.Position = UDim2.new(0, 5, 0, 45)
            DropdownList.BackgroundTransparency = 1
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Themes[Window.CurrentTheme].Accent
            DropdownList.Parent = MultiDropdownFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = DropdownList
            
            local function UpdateText()
                local count = 0
                for _ in pairs(MultiDropdown.Values) do count = count + 1 end
                if count == 0 then
                    DropdownText.Text = (options.Name or "Multi Select") .. ": None"
                else
                    DropdownText.Text = (options.Name or "Multi Select") .. ": " .. count .. " selected"
                end
            end
            
            for _, option in ipairs(options.Options) do
                local OptionFrame = Instance.new("Frame")
                OptionFrame.Size = UDim2.new(1, 0, 0, 30)
                OptionFrame.BackgroundColor3 = Themes[Window.CurrentTheme].ElementBG
                OptionFrame.BorderSizePixel = 0
                OptionFrame.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionFrame
                
                local Checkbox = Instance.new("Frame")
                Checkbox.Size = UDim2.new(0, 16, 0, 16)
                Checkbox.Position = UDim2.new(0, 8, 0.5, -8)
                Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                Checkbox.BorderSizePixel = 0
                Checkbox.Parent = OptionFrame
                
                local CheckboxCorner = Instance.new("UICorner")
                CheckboxCorner.CornerRadius = UDim.new(0, 3)
                CheckboxCorner.Parent = Checkbox
                
                local Checkmark = Instance.new("TextLabel")
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.BackgroundTransparency = 1
                Checkmark.Text = "✓"
                Checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
                Checkmark.TextSize = 14
                Checkmark.Font = Enum.Font.GothamBold
                Checkmark.Visible = false
                Checkmark.Parent = Checkbox
                
                local OptionText = Instance.new("TextLabel")
                OptionText.Size = UDim2.new(1, -35, 1, 0)
                OptionText.Position = UDim2.new(0, 30, 0, 0)
                OptionText.BackgroundTransparency = 1
                OptionText.Text = option
                OptionText.TextColor3 = Themes[Window.CurrentTheme].Text
                OptionText.TextSize = 13
                OptionText.Font = Enum.Font.Gotham
                OptionText.TextXAlignment = Enum.TextXAlignment.Left
                OptionText.Parent = OptionFrame
                
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 1, 0)
                OptionButton.BackgroundTransparency = 1
                OptionButton.Text = ""
                OptionButton.Parent = OptionFrame
                
                OptionButton.MouseButton1Click:Connect(function()
                    if MultiDropdown.Values[option] then
                        MultiDropdown.Values[option] = nil
                        Checkmark.Visible = false
                        Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    else
                        MultiDropdown.Values[option] = true
                        Checkmark.Visible = true
                        Checkbox.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
                    end
                    
                    UpdateText()
                    
                    if options.Callback then
                        local selected = {}
                        for k in pairs(MultiDropdown.Values) do
                            table.insert(selected, k)
                        end
                        options.Callback(selected)
                    end
                    
                    if Window.Config.AutoSaveLoad then
                        Window.SaveData[options.Name] = MultiDropdown.Values
                        SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                    end
                end)
            end
            
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            
            DropdownHeader.MouseButton1Click:Connect(function()
                MultiDropdown.Open = not MultiDropdown.Open
                if MultiDropdown.Open then
                    local listHeight = math.min(120, ListLayout.AbsoluteContentSize.Y)
                    Tween(MultiDropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + listHeight + 10)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    DropdownList.Size = UDim2.new(1, -10, 0, listHeight)
                else
                    Tween(MultiDropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            -- Carregar valores salvos
            if Window.Config.AutoSaveLoad and Window.SaveData[options.Name] then
                MultiDropdown.Values = Window.SaveData[options.Name]
                UpdateText()
            end
            
            function MultiDropdown:UpdateTheme(theme)
                MultiDropdownFrame.BackgroundColor3 = theme.Background
                DropdownText.TextColor3 = theme.Text
                DropdownArrow.TextColor3 = theme.SubText
            end
            
            table.insert(Window.Elements, MultiDropdown)
            return MultiDropdown
        end
        
        -- 12. Image
        function Tab:AddImage(options)
            local Image = {}
            
            local ImageFrame = Instance.new("Frame")
            ImageFrame.Name = "Image"
            ImageFrame.Size = UDim2.new(1, 0, 0, options.Height or 150)
            ImageFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ImageFrame.BorderSizePixel = 0
            ImageFrame.Parent = TabContent
            
            local ImageCorner = Instance.new("UICorner")
            ImageCorner.CornerRadius = UDim.new(0, 6)
            ImageCorner.Parent = ImageFrame
            
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Size = UDim2.new(1, -10, 1, -10)
            ImageLabel.Position = UDim2.new(0, 5, 0, 5)
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = "rbxassetid://" .. (options.ImageId or "")
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Parent = ImageFrame
            
            local ImageLabelCorner = Instance.new("UICorner")
            ImageLabelCorner.CornerRadius = UDim.new(0, 4)
            ImageLabelCorner.Parent = ImageLabel
            
            function Image:Set(imageId)
                ImageLabel.Image = "rbxassetid://" .. imageId
            end
            
            function Image:UpdateTheme(theme)
                ImageFrame.BackgroundColor3 = theme.Background
            end
            
            table.insert(Window.Elements, Image)
            return Image
        end
        
        return Tab
    end
    
    -- Função especial para Config Tab
    function Window:AddConfig()
        local ConfigTab = Window:AddTab("⚙️ Config")
        
        ConfigTab:AddSection("Theme Settings")
        
        -- Dropdown de temas
        ConfigTab:AddDropdown({
            Name = "Theme",
            Options = {"Dark", "Light", "Blue", "Purple", "Red", "Green", "Orange", "Cyan", "Pink", "Yellow"},
            Default = Window.CurrentTheme,
            Callback = function(value)
                Window:UpdateTheme(value)
                if Window.Config.AutoSaveLoad then
                    Window.SaveData.Theme = value
                    SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                end
            end
        })
        
        -- Toggle de Background Opacity
        ConfigTab:AddToggle({
            Name = "Background Opacity (60%)",
            Default = Window.BackgroundOpacity,
            Callback = function(value)
                Window:SetBackgroundOpacity(value)
                if Window.Config.AutoSaveLoad then
                    Window.SaveData.BackgroundOpacity = value
                    SaveConfig("UILibrary_SaveData.json", Window.SaveData)
                end
            end
        })
        
        ConfigTab:AddSection("Save Settings")
        
        -- Toggle de AutoSave & Load
        ConfigTab:AddToggle({
            Name = "Auto Save & Load",
            Default = Window.Config.AutoSaveLoad,
            Callback = function(value)
                Window.Config.AutoSaveLoad = value
            end
        })
        
        ConfigTab:AddButton({
            Name = "Clear Saved Data",
            Callback = function()
                Window.SaveData = {}
                SaveConfig("UILibrary_SaveData.json", {})
                print("Saved data cleared!")
            end
        })
        
        return ConfigTab
    end
    
    return Window
end

return Library

