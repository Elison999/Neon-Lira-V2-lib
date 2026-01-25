-- ██╗   ██╗██╗    ██╗     ██╗██████╗ ██████╗  █████╗ ██████╗ ██╗   ██╗
-- ██║   ██║██║    ██║     ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
-- ██║   ██║██║    ██║     ██║██████╔╝██████╔╝███████║██████╔╝ ╚████╔╝ 
-- ██║   ██║██║    ██║     ██║██╔══██╗██╔══██╗██╔══██║██╔══██╗  ╚██╔╝  
-- ╚██████╔╝██║    ███████╗██║██████╔╝██║  ██║██║  ██║██║  ██║   ██║   
--  ╚═════╝ ╚═╝    ╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
-- Modern Roblox UI Library v1.0 - LOADSTRING READY
-- Usage: local Library = loadstring(game:HttpGet("YOUR_URL"))()

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Verificação de funções de arquivo
local isfile = isfile or function() return false end
local readfile = readfile or function() return "" end
local writefile = writefile or function() end
local makefolder = makefolder or function() end
local isfolder = isfolder or function() return false end

-- Configuração de pasta
if not isfolder("UILibraryConfig") then
    makefolder("UILibraryConfig")
end

-- Variáveis Globais
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Temas Pré-configurados (15 Temas)
Library.Themes = {
    ["Dark Blue"] = {
        Primary = Color3.fromRGB(20, 25, 40),
        Secondary = Color3.fromRGB(30, 35, 50),
        Accent = Color3.fromRGB(60, 120, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    ["Purple Dream"] = {
        Primary = Color3.fromRGB(25, 15, 35),
        Secondary = Color3.fromRGB(35, 25, 50),
        Accent = Color3.fromRGB(150, 80, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    ["Ocean"] = {
        Primary = Color3.fromRGB(15, 30, 40),
        Secondary = Color3.fromRGB(25, 45, 60),
        Accent = Color3.fromRGB(50, 150, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    ["Forest"] = {
        Primary = Color3.fromRGB(20, 30, 20),
        Secondary = Color3.fromRGB(30, 45, 30),
        Accent = Color3.fromRGB(80, 180, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    ["Crimson"] = {
        Primary = Color3.fromRGB(30, 15, 15),
        Secondary = Color3.fromRGB(45, 25, 25),
        Accent = Color3.fromRGB(200, 50, 80),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    ["Sunset"] = {
        Primary = Color3.fromRGB(35, 20, 15),
        Secondary = Color3.fromRGB(50, 30, 25),
        Accent = Color3.fromRGB(255, 120, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    ["Midnight"] = {
        Primary = Color3.fromRGB(10, 10, 20),
        Secondary = Color3.fromRGB(15, 15, 30),
        Accent = Color3.fromRGB(100, 100, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150)
    },
    ["Cherry Blossom"] = {
        Primary = Color3.fromRGB(30, 20, 25),
        Secondary = Color3.fromRGB(45, 30, 40),
        Accent = Color3.fromRGB(255, 150, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 190)
    },
    ["Emerald"] = {
        Primary = Color3.fromRGB(15, 25, 20),
        Secondary = Color3.fromRGB(25, 40, 30),
        Accent = Color3.fromRGB(50, 200, 150),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 190)
    },
    ["Gold Rush"] = {
        Primary = Color3.fromRGB(25, 20, 10),
        Secondary = Color3.fromRGB(40, 35, 20),
        Accent = Color3.fromRGB(255, 200, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 150)
    },
    ["Ice"] = {
        Primary = Color3.fromRGB(20, 25, 30),
        Secondary = Color3.fromRGB(30, 40, 50),
        Accent = Color3.fromRGB(150, 220, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 220)
    },
    ["Lava"] = {
        Primary = Color3.fromRGB(30, 15, 10),
        Secondary = Color3.fromRGB(45, 25, 15),
        Accent = Color3.fromRGB(255, 80, 20),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 150, 130)
    },
    ["Toxic"] = {
        Primary = Color3.fromRGB(15, 25, 10),
        Secondary = Color3.fromRGB(25, 40, 15),
        Accent = Color3.fromRGB(150, 255, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 150)
    },
    ["Royal"] = {
        Primary = Color3.fromRGB(20, 15, 30),
        Secondary = Color3.fromRGB(35, 25, 50),
        Accent = Color3.fromRGB(180, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 220)
    },
    ["Monochrome"] = {
        Primary = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150)
    }
}

-- Utilidades
local Utility = {}

function Utility:Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:Create(class, properties)
    local object = Instance.new(class)
    for prop, val in pairs(properties) do
        if prop ~= "Parent" then
            object[prop] = val
        end
    end
    object.Parent = properties.Parent
    return object
end

function Utility:MakeDraggable(frame, handle)
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
            Utility:Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

function Utility:CreateRipple(button, color)
    local circle = Utility:Create("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = button
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = circle
    })
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Utility:Tween(circle, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        circle:Destroy()
    end)
end

-- Sistema de Loading
function Library:CreateLoading(options)
    options = options or {}
    local loadingName = options.LoadingName or "Welcome Back!"
    local loadingIcon = options.LoadingIcon or "rbxassetid://10723434711"
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "LoadingScreen",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local Background = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    local Container = Utility:Create("Frame", {
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0,
        Parent = Background
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Container
    })
    
    local Icon = Utility:Create("ImageLabel", {
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = loadingIcon,
        Parent = Container
    })
    
    local Title = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0.5, 0, 0.55, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = loadingName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = Container
    })
    
    local ProgressBar = Utility:Create("Frame", {
        Size = UDim2.new(0, 300, 0, 6),
        Position = UDim2.new(0.5, 0, 0.75, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = Container
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ProgressBar
    })
    
    local Progress = Utility:Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(60, 120, 200),
        BorderSizePixel = 0,
        Parent = ProgressBar
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Progress
    })
    
    -- Animação de Loading
    Utility:Tween(Progress, {Size = UDim2.new(1, 0, 1, 0)}, 2)
    
    -- Rotação do ícone
    RunService.RenderStepped:Connect(function()
        if Icon then
            Icon.Rotation = Icon.Rotation + 2
        end
    end)
    
    task.delay(2.2, function()
        Utility:Tween(Background, {BackgroundTransparency = 1}, 0.5)
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("GuiObject") then
                Utility:Tween(child, {ImageTransparency = 1}, 0.5)
                Utility:Tween(child, {TextTransparency = 1}, 0.5)
                Utility:Tween(child, {BackgroundTransparency = 1}, 0.5)
            end
        end
        Utility:Tween(Container, {BackgroundTransparency = 1}, 0.5)
        task.wait(0.6)
        ScreenGui:Destroy()
    end)
    
    return ScreenGui
end

-- Sistema de Key
function Library:CreateKeySystem(options)
    options = options or {}
    local keyName = options.KeyName or "Key System"
    local correctKey = options.Key or "DefaultKey123"
    local keySave = options.KeySave or false
    local keyJsonName = options.KeyJsonName or "SavedKey.json"
    local getSiteKey = options.GetKeyFromSite or "https://example.com/getkey"
    
    -- Verificar se a key foi salva
    if keySave and isfile("UILibraryConfig/" .. keyJsonName) then
        local savedKey = readfile("UILibraryConfig/" .. keyJsonName)
        if savedKey == correctKey then
            return true
        end
    end
    
    local validated = false
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "KeySystem",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local Background = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    local Container = Utility:Create("Frame", {
        Size = UDim2.new(0, 450, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0,
        Parent = Background
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Container
    })
    
    local Title = Utility:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BorderSizePixel = 0,
        Text = keyName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = Container
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Title
    })
    
    local KeyBox = Utility:Create("TextBox", {
        Size = UDim2.new(0, 350, 0, 45),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0,
        PlaceholderText = "Enter Key...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = Container
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = KeyBox
    })
    
    local SubmitBtn = Utility:Create("TextButton", {
        Size = UDim2.new(0, 165, 0, 40),
        Position = UDim2.new(0.28, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(60, 120, 200),
        BorderSizePixel = 0,
        Text = "Submit",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = Container
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = SubmitBtn
    })
    
    local GetKeyBtn = Utility:Create("TextButton", {
        Size = UDim2.new(0, 165, 0, 40),
        Position = UDim2.new(0.72, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(80, 80, 100),
        BorderSizePixel = 0,
        Text = "Get Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = Container
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = GetKeyBtn
    })
    
    local StatusLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0.5, 0, 0.88, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = Container
    })
    
    -- Botão Submit
    SubmitBtn.MouseButton1Click:Connect(function()
        Utility:CreateRipple(SubmitBtn)
        if KeyBox.Text == correctKey then
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            StatusLabel.Text = "Key Validated! Loading..."
            
            if keySave then
                writefile("UILibraryConfig/" .. keyJsonName, correctKey)
            end
            
            validated = true
            task.wait(1)
            Utility:Tween(Background, {BackgroundTransparency = 1}, 0.3)
            Utility:Tween(Container, {BackgroundTransparency = 1}, 0.3)
            for _, child in ipairs(Container:GetDescendants()) do
                if child:IsA("GuiObject") then
                    Utility:Tween(child, {BackgroundTransparency = 1}, 0.3)
                    Utility:Tween(child, {TextTransparency = 1}, 0.3)
                end
            end
            task.wait(0.4)
            ScreenGui:Destroy()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            StatusLabel.Text = "Invalid Key!"
            Utility:Tween(Container, {Position = UDim2.new(0.5, 10, 0.5, 0)}, 0.05)
            task.wait(0.05)
            Utility:Tween(Container, {Position = UDim2.new(0.5, -10, 0.5, 0)}, 0.05)
            task.wait(0.05)
            Utility:Tween(Container, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.05)
        end
    end)
    
    -- Botão Get Key
    GetKeyBtn.MouseButton1Click:Connect(function()
        Utility:CreateRipple(GetKeyBtn)
        setclipboard(getSiteKey)
        StatusLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        StatusLabel.Text = "Link copied to clipboard!"
    end)
    
    -- Aguardar validação
    repeat task.wait() until validated
    
    return validated
end

-- PARTE 2: Window, Topbar, Tabs e Elementos Base

-- Criar Window
function Library:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "UI Library"
    local windowSize = options.Size or UDim2.new(0, 600, 0, 450)
    local theme = options.Theme or "Dark Blue"
    local keySystemEnabled = options.KeySystem or false
    local showLoading = options.ShowLoading ~= false
    
    -- Loading Screen
    if showLoading then
        self:CreateLoading({
            LoadingName = options.LoadingName,
            LoadingIcon = options.LoadingIcon
        })
        task.wait(2.5)
    end
    
    -- Key System
    if keySystemEnabled then
        local validated = self:CreateKeySystem({
            KeyName = options.KeyName,
            Key = options.Key,
            KeySave = options.KeySave,
            KeyJsonName = options.KeyJsonName,
            GetKeyFromSite = options.GetKeyFromSite
        })
        if not validated then
            return
        end
    end
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTheme = theme
    Window.ConfigEnabled = false
    Window.Elements = {}
    
    -- ScreenGui Principal
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "MainUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    Window.ScreenGui = ScreenGui
    
    -- Container Principal
    local MainFrame = Utility:Create("Frame", {
        Size = windowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Themes[theme].Primary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    Window.MainFrame = MainFrame
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame
    })
    
    -- Topbar
    local Topbar = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Themes[theme].Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    Window.Topbar = Topbar
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Topbar
    })
    
    local TopbarBottom = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Library.Themes[theme].Secondary,
        BorderSizePixel = 0,
        Parent = Topbar
    })
    
    -- Título
    local TitleLabel = Utility:Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = Library.Themes[theme].Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })
    
    Window.TitleLabel = TitleLabel
    
    -- Botões da Topbar
    local ButtonContainer = Utility:Create("Frame", {
        Size = UDim2.new(0, 120, 0, 30),
        Position = UDim2.new(1, -130, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Parent = Topbar
    })
    
    -- Botão Resize
    local ResizeBtn = Utility:Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Themes[theme].Accent,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "⛶",
        TextColor3 = Library.Themes[theme].Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = ButtonContainer
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = ResizeBtn
    })
    
    -- Botão Minimize
    local MinimizeBtn = Utility:Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundColor3 = Library.Themes[theme].Accent,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Library.Themes[theme].Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = ButtonContainer
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MinimizeBtn
    })
    
    -- Botão Close
    local CloseBtn = Utility:Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 80, 0, 0),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = ButtonContainer
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseBtn
    })
    
    -- Drag System
    Utility:MakeDraggable(MainFrame, Topbar)
    
    -- Resize Functionality
    local resized = false
    local originalSize = windowSize
    ResizeBtn.MouseButton1Click:Connect(function()
        Utility:CreateRipple(ResizeBtn, Library.Themes[Window.CurrentTheme].Accent)
        resized = not resized
        if resized then
            Utility:Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 550)}, 0.3)
        else
            Utility:Tween(MainFrame, {Size = originalSize}, 0.3)
        end
    end)
    
    -- Minimize Functionality
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        Utility:CreateRipple(MinimizeBtn, Library.Themes[Window.CurrentTheme].Accent)
        minimized = not minimized
        if minimized then
            Utility:Tween(MainFrame, {Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 40)}, 0.3)
            MinimizeBtn.Text = "□"
        else
            local targetSize = resized and UDim2.new(0, 800, 0, 550) or originalSize
            Utility:Tween(MainFrame, {Size = targetSize}, 0.3)
            MinimizeBtn.Text = "─"
        end
    end)
    
    -- Close Modal
    function Window:CreateCloseModal()
        local ModalBg = Utility:Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            ZIndex = 1000,
            Parent = ScreenGui
        })
        
        local Modal = Utility:Create("Frame", {
            Size = UDim2.new(0, 350, 0, 180),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary,
            BorderSizePixel = 0,
            ZIndex = 1001,
            Parent = ModalBg
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = Modal
        })
        
        local ModalTitle = Utility:Create("TextLabel", {
            Size = UDim2.new(1, -40, 0, 30),
            Position = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Text = "Close Confirmation",
            TextColor3 = Library.Themes[Window.CurrentTheme].Text,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 1002,
            Parent = Modal
        })
        
        local ModalDesc = Utility:Create("TextLabel", {
            Size = UDim2.new(1, -40, 0, 40),
            Position = UDim2.new(0, 20, 0, 55),
            BackgroundTransparency = 1,
            Text = "Are you sure you want to close the UI?",
            TextColor3 = Library.Themes[Window.CurrentTheme].TextDark,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 1002,
            Parent = Modal
        })
        
        local CancelBtn = Utility:Create("TextButton", {
            Size = UDim2.new(0, 140, 0, 38),
            Position = UDim2.new(0, 20, 1, -55),
            BackgroundColor3 = Library.Themes[Window.CurrentTheme].Accent,
            BorderSizePixel = 0,
            Text = "Cancel",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            ZIndex = 1002,
            Parent = Modal
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = CancelBtn
        })
        
        local YesBtn = Utility:Create("TextButton", {
            Size = UDim2.new(0, 140, 0, 38),
            Position = UDim2.new(1, -160, 1, -55),
            BackgroundColor3 = Color3.fromRGB(200, 50, 50),
            BorderSizePixel = 0,
            Text = "Yes",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            ZIndex = 1002,
            Parent = Modal
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = YesBtn
        })
        
        CancelBtn.MouseButton1Click:Connect(function()
            Utility:CreateRipple(CancelBtn, Library.Themes[Window.CurrentTheme].Accent)
            Utility:Tween(ModalBg, {BackgroundTransparency = 1}, 0.2)
            Utility:Tween(Modal, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            ModalBg:Destroy()
        end)
        
        YesBtn.MouseButton1Click:Connect(function()
            Utility:CreateRipple(YesBtn, Color3.fromRGB(200, 50, 50))
            Utility:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            Utility:Tween(ModalBg, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            ScreenGui:Destroy()
        end)
    end
    
    CloseBtn.MouseButton1Click:Connect(function()
        Utility:CreateRipple(CloseBtn, Color3.fromRGB(200, 50, 50))
        Window:CreateCloseModal()
    end)
    
    -- Container de Tabs
    local TabContainer = Utility:Create("Frame", {
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = Library.Themes[theme].Secondary,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    Window.TabContainer = TabContainer
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TabContainer
    })
    
    Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })
    
    Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = TabContainer
    })
    
    -- Container de Conteúdo
    local ContentContainer = Utility:Create("Frame", {
        Size = UDim2.new(1, -180, 1, -50),
        Position = UDim2.new(0, 170, 0, 45),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    Window.ContentContainer = ContentContainer
    
    -- Criar Tab
    function Window:AddTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Sections = {}
        
        local TabButton = Utility:Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Parent = TabContainer
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        local TabIcon = Utility:Create("TextLabel", {
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Text = icon or "📁",
            TextColor3 = Library.Themes[Window.CurrentTheme].TextDark,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            Parent = TabButton
        })
        
        local TabLabel = Utility:Create("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Library.Themes[Window.CurrentTheme].TextDark,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        local TabContent = Utility:Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Themes[Window.CurrentTheme].Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentContainer
        })
        
        Tab.Content = TabContent
        
        Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })
        
        Utility:Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = TabContent
        })
        
        -- Auto-resize canvas
        TabContent:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            Utility:CreateRipple(TabButton, Library.Themes[Window.CurrentTheme].Accent)
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundTransparency = 1
                tab.Icon.TextColor3 = Library.Themes[Window.CurrentTheme].TextDark
                tab.Label.TextColor3 = Library.Themes[Window.CurrentTheme].TextDark
            end
            
            TabContent.Visible = true
            Utility:Tween(TabButton, {BackgroundTransparency = 0}, 0.2)
            TabIcon.TextColor3 = Library.Themes[Window.CurrentTheme].Accent
            TabLabel.TextColor3 = Library.Themes[Window.CurrentTheme].Text
        end)
        
        Tab.Button = TabButton
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.BackgroundTransparency = 0
            TabContent.Visible = true
            TabIcon.TextColor3 = Library.Themes[Window.CurrentTheme].Accent
            TabLabel.TextColor3 = Library.Themes[Window.CurrentTheme].Text
        end
        
        -- Adicionar Section
        function Tab:AddSection(name)
            local Section = {}
            
            local SectionFrame = Utility:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            Section.Frame = SectionFrame
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = SectionFrame
            })
            
            local SectionTitle = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionFrame
            })
            
            local ElementContainer = Utility:Create("Frame", {
                Size = UDim2.new(1, -20, 1, -40),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                Parent = SectionFrame
            })
            
            Section.Container = ElementContainer
            
            Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = ElementContainer
            })
            
            -- Auto-resize section
            ElementContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ElementContainer.UIListLayout.AbsoluteContentSize.Y + 45)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 20)
            end)
            
            table.insert(Tab.Sections, Section)
            
            -- ELEMENTOS DA SECTION
            
            -- Label (Texto)
            function Section:AddLabel(text)
                local Label = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Library.Themes[Window.CurrentTheme].TextDark,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ElementContainer
                })
                
                table.insert(Window.Elements, {Type = "Label", Object = Label})
                
                return {
                    SetText = function(self, newText)
                        Label.Text = newText
                    end
                }
            end
            
            -- Button (Botão)
            function Section:AddButton(options)
                options = options or {}
                local buttonText = options.Name or "Button"
                local callback = options.Callback or function() end
                
                local ButtonFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ButtonFrame
                })
                
                local Button = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = buttonText,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    Parent = ButtonFrame
                })
                
                Button.MouseButton1Click:Connect(function()
                    Utility:CreateRipple(ButtonFrame, Library.Themes[Window.CurrentTheme].Accent)
                    pcall(callback)
                end)
                
                Button.MouseEnter:Connect(function()
                    Utility:Tween(ButtonFrame, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Accent}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    Utility:Tween(ButtonFrame, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary}, 0.2)
                end)
                
                table.insert(Window.Elements, {Type = "Button", Object = ButtonFrame})
                
                return {
                    SetText = function(self, newText)
                        Button.Text = newText
                    end
                }
            end
            
            -- Toggle
            function Section:AddToggle(options)
                options = options or {}
                local toggleName = options.Name or "Toggle"
                local defaultValue = options.Default or false
                local callback = options.Callback or function() end
                local saveFlag = options.Flag
                
                local toggled = defaultValue
                
                local ToggleFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ToggleFrame
                })
                
                local ToggleLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = toggleName,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Utility:Create("TextButton", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -45, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = toggled and Library.Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70),
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = ToggleFrame
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = ToggleButton
                })
                
                local ToggleIndicator = Utility:Create("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = ToggleButton
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = ToggleIndicator
                })
                
                local function Toggle()
                    toggled = not toggled
                    
                    Utility:Tween(ToggleButton, {
                        BackgroundColor3 = toggled and Library.Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)
                    }, 0.2)
                    
                    Utility:Tween(ToggleIndicator, {
                        Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    }, 0.2)
                    
                    pcall(callback, toggled)
                    
                    if saveFlag then
                        Library:SaveConfig(saveFlag, toggled)
                    end
                end
                
                ToggleButton.MouseButton1Click:Connect(Toggle)
                
                ToggleFrame.MouseEnter:Connect(function()
                    Utility:Tween(ToggleFrame, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary}, 0.2)
                end)
                
                ToggleFrame.MouseLeave:Connect(function()
                    Utility:Tween(ToggleFrame, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary}, 0.2)
                end)
                
                table.insert(Window.Elements, {Type = "Toggle", Object = ToggleFrame, Toggle = ToggleButton, Indicator = ToggleIndicator})
                
                if saveFlag then
                    local saved = Library:LoadConfig(saveFlag)
                    if saved ~= nil then
                        if saved ~= toggled then
                            Toggle()
                        end
                    end
                end
                
                return {
                    Set = function(self, value)
                        if value ~= toggled then
                            Toggle()
                        end
                    end,
                    Get = function(self)
                        return toggled
                    end
                }
            end
            
            -- Slider
            function Section:AddSlider(options)
                options = options or {}
                local sliderName = options.Name or "Slider"
                local minValue = options.Min or 0
                local maxValue = options.Max or 100
                local defaultValue = options.Default or minValue
                local increment = options.Increment or 1
                local callback = options.Callback or function() end
                local saveFlag = options.Flag
                
                local currentValue = defaultValue
                
                local SliderFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = SliderFrame
                })
                
                local SliderLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = sliderName,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local ValueLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(0.35, 0, 0, 20),
                    Position = UDim2.new(0.65, 0, 0, 5),
                    BackgroundTransparency = 1,
                    Text = tostring(currentValue),
                    TextColor3 = Library.Themes[Window.CurrentTheme].Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local SliderTrack = Utility:Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 4),
                    Position = UDim2.new(0, 10, 1, -15),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                    BorderSizePixel = 0,
                    Parent = SliderFrame
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderTrack
                })
                
                local SliderFill = Utility:Create("Frame", {
                    Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Accent,
                    BorderSizePixel = 0,
                    Parent = SliderTrack
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderFill
                })
                
                local SliderButton = Utility:Create("TextButton", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -7, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = SliderTrack
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderButton
                })
                
                local dragging = false
                
                local function UpdateSlider(input)
                    local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local value = math.floor((minValue + (maxValue - minValue) * percent) / increment + 0.5) * increment
                    value = math.clamp(value, minValue, maxValue)
                    
                    currentValue = value
                    ValueLabel.Text = tostring(value)
                    
                    Utility:Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                    Utility:Tween(SliderButton, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.1)
                    
                    pcall(callback, value)
                    
                    if saveFlag then
                        Library:SaveConfig(saveFlag, value)
                    end
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateSlider(input)
                    end
                end)
                
                table.insert(Window.Elements, {Type = "Slider", Object = SliderFrame, Fill = SliderFill, Button = SliderButton})
                
                if saveFlag then
                    local saved = Library:LoadConfig(saveFlag)
                    if saved ~= nil then
                        currentValue = saved
                        ValueLabel.Text = tostring(saved)
                        local percent = (saved - minValue) / (maxValue - minValue)
                        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        SliderButton.Position = UDim2.new(percent, -7, 0.5, -7)
                    end
                end
                
                return {
                    Set = function(self, value)
                        value = math.clamp(value, minValue, maxValue)
                        currentValue = value
                        ValueLabel.Text = tostring(value)
                        local percent = (value - minValue) / (maxValue - minValue)
                        Utility:Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
                        Utility:Tween(SliderButton, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.2)
                    end,
                    Get = function(self)
                        return currentValue
                    end
                }
            end
            
            -- Dropdown
            function Section:AddDropdown(options)
                options = options or {}
                local dropdownName = options.Name or "Dropdown"
                local items = options.Options or {"Option 1", "Option 2", "Option 3"}
                local defaultValue = options.Default or items[1]
                local callback = options.Callback or function() end
                local saveFlag = options.Flag
                
                local selected = defaultValue
                local opened = false
                
                local DropdownFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = DropdownFrame
                })
                
                local DropdownLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = dropdownName,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownButton
                })
                
                local SelectedLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(0.35, -20, 1, 0),
                    Position = UDim2.new(0.65, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = selected,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = DropdownButton
                })
                
                local Arrow = Utility:Create("TextLabel", {
                    Size = UDim2.new(0, 15, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = Library.Themes[Window.CurrentTheme].TextDark,
                    Font = Enum.Font.GothamBold,
                    TextSize = 10,
                    Parent = DropdownButton
                })
                
                local ItemsContainer = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = DropdownFrame
                })
                
                Utility:Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = ItemsContainer
                })
                
                local function Toggle()
                    opened = not opened
                    local targetSize = opened and UDim2.new(1, 0, 0, 35 + (#items * 27) + (#items * 2)) or UDim2.new(1, 0, 0, 35)
                    
                    Utility:Tween(DropdownFrame, {Size = targetSize}, 0.3)
                    Utility:Tween(Arrow, {Rotation = opened and 180 or 0}, 0.3)
                    
                    TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 20)
                end
                
                for _, item in ipairs(items) do
                    local ItemButton = Utility:Create("TextButton", {
                        Size = UDim2.new(1, -10, 0, 25),
                        BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary,
                        BorderSizePixel = 0,
                        Text = item,
                        TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        Parent = ItemsContainer
                    })
                    
                    Utility:Create("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = ItemButton
                    })
                    
                    ItemButton.MouseButton1Click:Connect(function()
                        selected = item
                        SelectedLabel.Text = item
                        Toggle()
                        pcall(callback, item)
                        
                        if saveFlag then
                            Library:SaveConfig(saveFlag, item)
                        end
                    end)
                    
                    ItemButton.MouseEnter:Connect(function()
                        Utility:Tween(ItemButton, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Accent}, 0.2)
                    end)
                    
                    ItemButton.MouseLeave:Connect(function()
                        Utility:Tween(ItemButton, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary}, 0.2)
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(Toggle)
                
                table.insert(Window.Elements, {Type = "Dropdown", Object = DropdownFrame})
                
                if saveFlag then
                    local saved = Library:LoadConfig(saveFlag)
                    if saved ~= nil then
                        selected = saved
                        SelectedLabel.Text = saved
                    end
                end
                
                return {
                    Set = function(self, value)
                        selected = value
                        SelectedLabel.Text = value
                    end,
                    Get = function(self)
                        return selected
                    end
                }
            end
            
            -- Textbox
            function Section:AddTextbox(options)
                options = options or {}
                local textboxName = options.Name or "Textbox"
                local placeholder = options.Placeholder or "Enter text..."
                local defaultText = options.Default or ""
                local callback = options.Callback or function() end
                local saveFlag = options.Flag
                
                local TextboxFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = TextboxFrame
                })
                
                local TextboxLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = textboxName,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TextboxFrame
                })
                
                local Textbox = Utility:Create("TextBox", {
                    Size = UDim2.new(1, -20, 0, 28),
                    Position = UDim2.new(0, 10, 0, 27),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Library.Themes[Window.CurrentTheme].TextDark,
                    Text = defaultText,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    Parent = TextboxFrame
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Textbox
                })
                
                Utility:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = Textbox
                })
                
                Textbox.FocusLost:Connect(function()
                    pcall(callback, Textbox.Text)
                    
                    if saveFlag then
                        Library:SaveConfig(saveFlag, Textbox.Text)
                    end
                end)
                
                table.insert(Window.Elements, {Type = "Textbox", Object = TextboxFrame, Input = Textbox})
                
                if saveFlag then
                    local saved = Library:LoadConfig(saveFlag)
                    if saved ~= nil then
                        Textbox.Text = saved
                    end
                end
                
                return {
                    Set = function(self, text)
                        Textbox.Text = text
                    end,
                    Get = function(self)
                        return Textbox.Text
                    end
                }
            end
            
            -- Keybind
            function Section:AddKeybind(options)
                options = options or {}
                local keybindName = options.Name or "Keybind"
                local defaultKey = options.Default or Enum.KeyCode.E
                local callback = options.Callback or function() end
                local saveFlag = options.Flag
                
                local currentKey = defaultKey
                local binding = false
                
                local KeybindFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = KeybindFrame
                })
                
                local KeybindLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = keybindName,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = Utility:Create("TextButton", {
                    Size = UDim2.new(0, 70, 0, 25),
                    Position = UDim2.new(1, -75, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary,
                    BorderSizePixel = 0,
                    Text = currentKey.Name,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    Parent = KeybindFrame
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeybindButton
                })
                
                KeybindButton.MouseButton1Click:Connect(function()
                    binding = true
                    KeybindButton.Text = "..."
                    Utility:Tween(KeybindButton, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Accent}, 0.2)
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            KeybindButton.Text = input.KeyCode.Name
                            binding = false
                            Utility:Tween(KeybindButton, {BackgroundColor3 = Library.Themes[Window.CurrentTheme].Secondary}, 0.2)
                            
                            if saveFlag then
                                Library:SaveConfig(saveFlag, input.KeyCode.Name)
                            end
                        end
                    elseif not gameProcessed and input.KeyCode == currentKey then
                        pcall(callback)
                    end
                end)
                
                table.insert(Window.Elements, {Type = "Keybind", Object = KeybindFrame, Button = KeybindButton})
                
                if saveFlag then
                    local saved = Library:LoadConfig(saveFlag)
                    if saved ~= nil then
                        currentKey = Enum.KeyCode[saved]
                        KeybindButton.Text = saved
                    end
                end
                
                return {
                    Set = function(self, key)
                        currentKey = key
                        KeybindButton.Text = key.Name
                    end,
                    Get = function(self)
                        return currentKey
                    end
                }
            end
            
            -- ColorPicker
            function Section:AddColorPicker(options)
                options = options or {}
                local pickerName = options.Name or "Color"
                local defaultColor = options.Default or Color3.fromRGB(255, 255, 255)
                local callback = options.Callback or function() end
                local saveFlag = options.Flag
                
                local currentColor = defaultColor
                
                local PickerFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Library.Themes[Window.CurrentTheme].Primary,
                    BorderSizePixel = 0,
                    Parent = ElementContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = PickerFrame
                })
                
                local PickerLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = pickerName,
                    TextColor3 = Library.Themes[Window.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = PickerFrame
                })
                
                local ColorDisplay = Utility:Create("Frame", {
                    Size = UDim2.new(0, 50, 0, 25),
                    Position = UDim2.new(1, -55, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = currentColor,
                    BorderSizePixel = 0,
                    Parent = PickerFrame
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ColorDisplay
                })
                
                Utility:Create("UIStroke", {
                    Color = Library.Themes[Window.CurrentTheme].TextDark,
                    Thickness = 1,
                    Parent = ColorDisplay
                })
                
                local ColorButton = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = ColorDisplay
                })
                
                ColorButton.MouseButton1Click:Connect(function()
                    -- Simple RGB randomizer (real color picker would be complex)
                    local r = math.random(0, 255)
                    local g = math.random(0, 255)
                    local b = math.random(0, 255)
                    currentColor = Color3.fromRGB(r, g, b)
                    
                    Utility:Tween(ColorDisplay, {BackgroundColor3 = currentColor}, 0.3)
                    pcall(callback, currentColor)
                    
                    if saveFlag then
                        Library:SaveConfig(saveFlag, {r, g, b})
                    end
                end)
                
                table.insert(Window.Elements, {Type = "ColorPicker", Object = PickerFrame, Display = ColorDisplay})
                
                if saveFlag then
                    local saved = Library:LoadConfig(saveFlag)
                    if saved ~= nil and type(saved) == "table" then
                        currentColor = Color3.fromRGB(saved[1], saved[2], saved[3])
                        ColorDisplay.BackgroundColor3 = currentColor
                    end
                end
                
                return {
                    Set = function(self, color)
                        currentColor = color
                        Utility:Tween(ColorDisplay, {BackgroundColor3 = color}, 0.2)
                    end,
                    Get = function(self)
                        return currentColor
                    end
                }
            end
    
    -- Sistema de Save/Load
    function Library:SaveConfig(flag, value)
        local configPath = "UILibraryConfig/Config.json"
        local config = {}
        
        if isfile(configPath) then
            local success, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(configPath))
            end)
            if success then
                config = decoded
            end
        end
        
        config[flag] = value
        
        local encoded = game:GetService("HttpService"):JSONEncode(config)
        writefile(configPath, encoded)
    end
    
    function Library:LoadConfig(flag)
        local configPath = "UILibraryConfig/Config.json"
        
        if isfile(configPath) then
            local success, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(configPath))
            end)
            if success and decoded[flag] ~= nil then
                return decoded[flag]
            end
        end
        
        return nil
    end
    
    -- Aplicar Tema
    function Window:ApplyTheme(themeName)
        if not Library.Themes[themeName] then return end
        
        Window.CurrentTheme = themeName
        local theme = Library.Themes[themeName]
        
        Utility:Tween(MainFrame, {BackgroundColor3 = theme.Primary}, 0.3)
        Utility:Tween(Topbar, {BackgroundColor3 = theme.Secondary}, 0.3)
        Utility:Tween(TopbarBottom, {BackgroundColor3 = theme.Secondary}, 0.3)
        Utility:Tween(TitleLabel, {TextColor3 = theme.Text}, 0.3)
        Utility:Tween(TabContainer, {BackgroundColor3 = theme.Secondary}, 0.3)
        
        for _, element in pairs(Window.Elements) do
            if element.Type == "Label" then
                Utility:Tween(element.Object, {TextColor3 = theme.TextDark}, 0.3)
            elseif element.Type == "Button" then
                Utility:Tween(element.Object, {BackgroundColor3 = theme.Primary}, 0.3)
            elseif element.Type == "Toggle" then
                Utility:Tween(element.Object, {BackgroundColor3 = theme.Primary}, 0.3)
            end
        end
        
        for _, tab in pairs(Window.Tabs) do
            Utility:Tween(tab.Label, {TextColor3 = tab.Content.Visible and theme.Text or theme.TextDark}, 0.3)
            Utility:Tween(tab.Icon, {TextColor3 = tab.Content.Visible and theme.Accent or theme.TextDark}, 0.3)
        end
    end
    
    return Window
end

            return Section
        end
        
        return Tab
    end
    
    -- Sistema AddConfig (Cria aba automática de configuração)
    function Window:AddConfig()
        if Window.ConfigEnabled then return end
        Window.ConfigEnabled = true
        
        local ConfigTab = Window:AddTab("⚙️ Settings", "⚙️")
        local ThemeSection = ConfigTab:AddSection("Theme Settings")
        
        local themeNames = {}
        for name, _ in pairs(Library.Themes) do
            table.insert(themeNames, name)
        end
        table.sort(themeNames)
        
        ThemeSection:AddDropdown({
            Name = "Select Theme",
            Options = themeNames,
            Default = Window.CurrentTheme,
            Callback = function(theme)
                Window:ApplyTheme(theme)
            end,
            Flag = "SelectedTheme"
        })
        
        ThemeSection:AddLabel("Choose from 15 pre-configured themes")
        
        local InfoSection = ConfigTab:AddSection("UI Information")
        InfoSection:AddLabel("UI Library v1.0")
        InfoSection:AddLabel("Created with OOP Architecture")
        InfoSection:AddLabel("Auto-Save: Enabled")
        
        InfoSection:AddButton({
            Name = "Reset All Settings",
            Callback = function()
                if isfile("UILibraryConfig/Config.json") then
                    writefile("UILibraryConfig/Config.json", "{}")
                    InfoSection:AddLabel("Settings Reset!")
                end
            end
        })
    end
    
    return Window
end

return Library
