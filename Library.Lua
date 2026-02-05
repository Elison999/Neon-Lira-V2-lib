--[[
    Modern Roblox Mobile UI Library - Part 1
    Features: Key System, Loading, Draggable Topbar, Tabs, AutoSave/Load
    Elements: Button, Toggle, Slider, Dropdown, TextBox, Label
--]]

local ModernUI = {}
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configurações Globais
local Config = {
    FolderName = "ModernUI_Configs",
    FileName = "UIConfig.json",
    AutoSave = true,
    Theme = "Dark",
    Transparency = false,
    SavedData = {}
}

-- Temas (20 primeiros, Parte 2 terá mais 20)
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Topbar = Color3.fromRGB(35, 35, 35),
        TabBackground = Color3.fromRGB(30, 30, 30),
        ElementBackground = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 170, 255),
        Success = Color3.fromRGB(0, 255, 100),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Topbar = Color3.fromRGB(220, 220, 220),
        TabBackground = Color3.fromRGB(230, 230, 230),
        ElementBackground = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 120, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Error = Color3.fromRGB(220, 50, 50)
    },
    Midnight = {
        Background = Color3.fromRGB(15, 15, 35),
        Topbar = Color3.fromRGB(25, 25, 50),
        TabBackground = Color3.fromRGB(20, 20, 40),
        ElementBackground = Color3.fromRGB(35, 35, 60),
        Text = Color3.fromRGB(220, 220, 255),
        Accent = Color3.fromRGB(100, 100, 255),
        Success = Color3.fromRGB(100, 255, 150),
        Error = Color3.fromRGB(255, 100, 100)
    },
    Forest = {
        Background = Color3.fromRGB(20, 40, 20),
        Topbar = Color3.fromRGB(30, 60, 30),
        TabBackground = Color3.fromRGB(25, 50, 25),
        ElementBackground = Color3.fromRGB(40, 80, 40),
        Text = Color3.fromRGB(220, 255, 220),
        Accent = Color3.fromRGB(100, 255, 100),
        Success = Color3.fromRGB(150, 255, 150),
        Error = Color3.fromRGB(255, 100, 100)
    },
    Sunset = {
        Background = Color3.fromRGB(40, 20, 30),
        Topbar = Color3.fromRGB(60, 30, 45),
        TabBackground = Color3.fromRGB(50, 25, 37),
        ElementBackground = Color3.fromRGB(80, 40, 60),
        Text = Color3.fromRGB(255, 220, 230),
        Accent = Color3.fromRGB(255, 100, 150),
        Success = Color3.fromRGB(255, 150, 200),
        Error = Color3.fromRGB(255, 80, 80)
    },
    Ocean = {
        Background = Color3.fromRGB(20, 30, 50),
        Topbar = Color3.fromRGB(30, 45, 75),
        TabBackground = Color3.fromRGB(25, 37, 62),
        ElementBackground = Color3.fromRGB(40, 60, 100),
        Text = Color3.fromRGB(220, 230, 255),
        Accent = Color3.fromRGB(100, 200, 255),
        Success = Color3.fromRGB(100, 255, 200),
        Error = Color3.fromRGB(255, 100, 120)
    },
    Cyber = {
        Background = Color3.fromRGB(10, 10, 10),
        Topbar = Color3.fromRGB(20, 0, 40),
        TabBackground = Color3.fromRGB(15, 0, 30),
        ElementBackground = Color3.fromRGB(30, 0, 60),
        Text = Color3.fromRGB(0, 255, 255),
        Accent = Color3.fromRGB(255, 0, 255),
        Success = Color3.fromRGB(0, 255, 0),
        Error = Color3.fromRGB(255, 0, 0)
    },
    Gold = {
        Background = Color3.fromRGB(30, 25, 15),
        Topbar = Color3.fromRGB(50, 42, 25),
        TabBackground = Color3.fromRGB(40, 35, 20),
        ElementBackground = Color3.fromRGB(70, 60, 35),
        Text = Color3.fromRGB(255, 235, 200),
        Accent = Color3.fromRGB(255, 215, 0),
        Success = Color3.fromRGB(255, 235, 100),
        Error = Color3.fromRGB(255, 100, 80)
    },
    Cherry = {
        Background = Color3.fromRGB(40, 15, 20),
        Topbar = Color3.fromRGB(60, 25, 35),
        TabBackground = Color3.fromRGB(50, 20, 28),
        ElementBackground = Color3.fromRGB(80, 35, 50),
        Text = Color3.fromRGB(255, 220, 225),
        Accent = Color3.fromRGB(255, 80, 120),
        Success = Color3.fromRGB(255, 150, 180),
        Error = Color3.fromRGB(200, 50, 50)
    },
    Matrix = {
        Background = Color3.fromRGB(0, 10, 0),
        Topbar = Color3.fromRGB(0, 20, 0),
        TabBackground = Color3.fromRGB(0, 15, 0),
        ElementBackground = Color3.fromRGB(0, 30, 0),
        Text = Color3.fromRGB(0, 255, 0),
        Accent = Color3.fromRGB(50, 255, 50),
        Success = Color3.fromRGB(100, 255, 100),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Lavender = {
        Background = Color3.fromRGB(35, 30, 50),
        Topbar = Color3.fromRGB(50, 45, 75),
        TabBackground = Color3.fromRGB(42, 37, 62),
        ElementBackground = Color3.fromRGB(65, 55, 95),
        Text = Color3.fromRGB(235, 220, 255),
        Accent = Color3.fromRGB(200, 150, 255),
        Success = Color3.fromRGB(180, 255, 200),
        Error = Color3.fromRGB(255, 120, 150)
    },
    Coffee = {
        Background = Color3.fromRGB(40, 30, 25),
        Topbar = Color3.fromRGB(60, 45, 38),
        TabBackground = Color3.fromRGB(50, 37, 31),
        ElementBackground = Color3.fromRGB(80, 60, 50),
        Text = Color3.fromRGB(245, 235, 220),
        Accent = Color3.fromRGB(210, 180, 140),
        Success = Color3.fromRGB(200, 230, 180),
        Error = Color3.fromRGB(230, 100, 90)
    },
    Neon = {
        Background = Color3.fromRGB(5, 5, 15),
        Topbar = Color3.fromRGB(10, 10, 30),
        TabBackground = Color3.fromRGB(8, 8, 25),
        ElementBackground = Color3.fromRGB(20, 20, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 50, 150),
        Success = Color3.fromRGB(50, 255, 100),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Pastel = {
        Background = Color3.fromRGB(255, 240, 245),
        Topbar = Color3.fromRGB(255, 220, 230),
        TabBackground = Color3.fromRGB(255, 230, 240),
        ElementBackground = Color3.fromRGB(255, 245, 250),
        Text = Color3.fromRGB(80, 60, 70),
        Accent = Color3.fromRGB(255, 182, 193),
        Success = Color3.fromRGB(152, 251, 152),
        Error = Color3.fromRGB(255, 160, 122)
    },
    Vampire = {
        Background = Color3.fromRGB(15, 10, 15),
        Topbar = Color3.fromRGB(30, 20, 25),
        TabBackground = Color3.fromRGB(25, 15, 20),
        ElementBackground = Color3.fromRGB(45, 30, 35),
        Text = Color3.fromRGB(220, 200, 200),
        Accent = Color3.fromRGB(180, 30, 50),
        Success = Color3.fromRGB(200, 100, 120),
        Error = Color3.fromRGB(150, 30, 30)
    },
    Discord = {
        Background = Color3.fromRGB(54, 57, 63),
        Topbar = Color3.fromRGB(47, 49, 54),
        TabBackground = Color3.fromRGB(54, 57, 63),
        ElementBackground = Color3.fromRGB(64, 68, 75),
        Text = Color3.fromRGB(220, 221, 222),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(59, 165, 93),
        Error = Color3.fromRGB(237, 66, 69)
    },
    Spotify = {
        Background = Color3.fromRGB(18, 18, 18),
        Topbar = Color3.fromRGB(24, 24, 24),
        TabBackground = Color3.fromRGB(18, 18, 18),
        ElementBackground = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(30, 215, 96),
        Success = Color3.fromRGB(30, 215, 96),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Youtube = {
        Background = Color3.fromRGB(33, 33, 33),
        Topbar = Color3.fromRGB(40, 40, 40),
        TabBackground = Color3.fromRGB(33, 33, 33),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 0, 0),
        Success = Color3.fromRGB(255, 50, 50),
        Error = Color3.fromRGB(200, 0, 0)
    },
    Twitch = {
        Background = Color3.fromRGB(24, 24, 27),
        Topbar = Color3.fromRGB(46, 46, 52),
        TabBackground = Color3.fromRGB(24, 24, 27),
        ElementBackground = Color3.fromRGB(50, 50, 60),
        Text = Color3.fromRGB(239, 239, 241),
        Accent = Color3.fromRGB(169, 112, 255),
        Success = Color3.fromRGB(0, 255, 127),
        Error = Color3.fromRGB(255, 69, 58)
    },
    Glass = {
        Background = Color3.fromRGB(20, 20, 20),
        Topbar = Color3.fromRGB(30, 30, 30),
        TabBackground = Color3.fromRGB(25, 25, 25),
        ElementBackground = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 200, 255),
        Success = Color3.fromRGB(100, 255, 150),
        Error = Color3.fromRGB(255, 100, 100)
    }
}

-- Variáveis de Estado
local CurrentWindow = nil
local Elements = {}
local Tabs = {}
local ActiveTab = nil
local IsMinimized = false
local IsDragging = false
local DragStart = nil
local StartPos = nil
local SavedValues = {}
local ConfigTabAdded = false

-- Funções Utilitárias
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbar, frame)
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = true
            DragStart = input.Position
            StartPos = frame.Position
            
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not IsDragging then
                    connection:Disconnect()
                    return
                end
                
                local delta = input.Position - DragStart
                frame.Position = UDim2.new(
                    StartPos.X.Scale, 
                    StartPos.X.Offset + delta.X,
                    StartPos.Y.Scale, 
                    StartPos.Y.Offset + delta.Y
                )
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    IsDragging = false
                end
            end)
        end
    end)
end

-- Sistema de Save/Load
local function SaveConfig()
    if not Config.AutoSave then return end
    
    local data = {
        Theme = Config.Theme,
        Transparency = Config.Transparency,
        AutoSave = Config.AutoSave,
        Values = SavedValues
    }
    
    local success, result = pcall(function()
        if writefile then
            writefile(Config.FolderName .. "/" .. Config.FileName, HttpService:JSONEncode(data))
        end
    end)
    
    return success
end

local function LoadConfig()
    local success, result = pcall(function()
        if readfile and isfile and isfile(Config.FolderName .. "/" .. Config.FileName) then
            return HttpService:JSONDecode(readfile(Config.FolderName .. "/" .. Config.FileName))
        end
        return nil
    end)
    
    if success and result then
        Config.Theme = result.Theme or "Dark"
        Config.Transparency = result.Transparency or false
        Config.AutoSave = result.AutoSave ~= false
        SavedValues = result.Values or {}
        return true
    end
    return false
end

local function EnsureFolder()
    pcall(function()
        if makefolder and not isfolder(Config.FolderName) then
            makefolder(Config.FolderName)
        end
    end)
end

-- Sistema de Key
function ModernUI:VerifyKey(keySettings)
    if not keySettings.KeyEnable then return true end
    
    local keyValid = false
    local savedKey = nil
    
    -- Verificar key salva
    if keySettings.KeySave and keySettings.KeyFileName then
        pcall(function()
            if isfile and isfile(keySettings.KeyFileName) then
                savedKey = readfile(keySettings.KeyFileName)
            end
        end)
    end
    
    -- Auto load key
    if keySettings.AutoLoadKey and savedKey and savedKey == keySettings.Key then
        return true
    end
    
    -- Verificar key do site
    if keySettings.GetKeyFromSite and keySettings.KeySite then
        pcall(function()
            local response = game:HttpGet(keySettings.KeySite)
            if response and response:find(keySettings.Key) then
                keyValid = true
            end
        end)
    end
    
    return keyValid
end

function ModernUI:CreateKeyWindow(keySettings)
    local keyGui = CreateInstance("ScreenGui", {
        Name = "KeySystem",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })
    
    local mainFrame = CreateInstance("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 320, 0, 220),
        Position = UDim2.new(0.5, -160, 0.5, -110),
        BackgroundColor3 = Themes[Config.Theme].Background,
        BorderSizePixel = 0,
        Parent = keyGui
    })
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainFrame})
    CreateInstance("UIStroke", {Color = Themes[Config.Theme].Accent, Thickness = 2, Parent = mainFrame})
    
    local topbar = CreateInstance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Themes[Config.Theme].Topbar,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = topbar})
    
    local title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = keySettings.KeyName or "Key System",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topbar
    })
    
    local keyBox = CreateInstance("TextBox", {
        Name = "KeyBox",
        Size = UDim2.new(0.9, 0, 0, 45),
        Position = UDim2.new(0.05, 0, 0, 65),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "Enter Key...",
        TextColor3 = Themes[Config.Theme].Text,
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 16,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = mainFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = keyBox})
    
    local statusLabel = CreateInstance("TextLabel", {
        Name = "Status",
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = UDim2.new(0.05, 0, 0, 115),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Themes[Config.Theme].Error,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = mainFrame
    })
    
    local submitBtn = CreateInstance("TextButton", {
        Name = "Submit",
        Size = UDim2.new(0.9, 0, 0, 40),
        Position = UDim2.new(0.05, 0, 0, 150),
        BackgroundColor3 = Themes[Config.Theme].Accent,
        BorderSizePixel = 0,
        Text = "Submit",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = mainFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = submitBtn})
    
    local getKeyBtn = CreateInstance("TextButton", {
        Name = "GetKey",
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0, 195),
        BackgroundTransparency = 1,
        Text = "Get Key",
        TextColor3 = Themes[Config.Theme].Accent,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = mainFrame
    })
    
    MakeDraggable(topbar, mainFrame)
    
    local function ValidateKey()
        local enteredKey = keyBox.Text
        if enteredKey == keySettings.Key then
            if keySettings.KeySave and keySettings.KeyFileName then
                pcall(function()
                    if writefile then
                        writefile(keySettings.KeyFileName, enteredKey)
                    end
                end)
            end
            Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            wait(0.3)
            keyGui:Destroy()
            return true
        else
            statusLabel.Text = "Invalid Key!"
            Tween(keyBox, {BackgroundColor3 = Themes[Config.Theme].Error}, 0.2)
            wait(0.2)
            Tween(keyBox, {BackgroundColor3 = Themes[Config.Theme].ElementBackground}, 0.2)
            return false
        end
    end
    
    submitBtn.MouseButton1Click:Connect(ValidateKey)
    getKeyBtn.MouseButton1Click:Connect(function()
        if keySettings.KeySite then
            pcall(function()
                setclipboard(keySettings.KeySite)
                statusLabel.Text = "Link copied!"
                statusLabel.TextColor3 = Themes[Config.Theme].Success
            end)
        end
    end)
    
    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ValidateKey()
        end
    end)
    
    return keyGui
end

-- Loading Screen
function ModernUI:CreateLoadingScreen(settings)
    local loadingGui = CreateInstance("ScreenGui", {
        Name = "LoadingScreen",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })
    
    local bg = CreateInstance("Frame", {
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.3,
        Parent = loadingGui
    })
    
    local mainFrame = CreateInstance("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 280, 0, 200),
        Position = UDim2.new(0.5, -140, 0.5, -100),
        BackgroundColor3 = Themes[Config.Theme].Background,
        BorderSizePixel = 0,
        Parent = loadingGui
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 16), Parent = mainFrame})
    
    local imageLabel = CreateInstance("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0, 20),
        BackgroundTransparency = 1,
        Image = settings.ImageId or "",
        Parent = mainFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = imageLabel})
    
    local title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 110),
        BackgroundTransparency = 1,
        Text = settings.LoadingName or "Loading...",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = mainFrame
    })
    
    local progressBarBg = CreateInstance("Frame", {
        Name = "ProgressBg",
        Size = UDim2.new(0.8, 0, 0, 8),
        Position = UDim2.new(0.1, 0, 0, 155),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = progressBarBg})
    
    local progressBar = CreateInstance("Frame", {
        Name = "Progress",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Themes[Config.Theme].Accent,
        BorderSizePixel = 0,
        Parent = progressBarBg
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = progressBar})
    
    local percentLabel = CreateInstance("TextLabel", {
        Name = "Percent",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 170),
        BackgroundTransparency = 1,
        Text = "0%",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = mainFrame
    })
    
    -- Animação de loading
    spawn(function()
        for i = 0, 100, 2 do
            progressBar.Size = UDim2.new(i/100, 0, 1, 0)
            percentLabel.Text = i .. "%"
            wait(0.05)
        end
        wait(0.3)
        Tween(loadingGui, {BackgroundTransparency = 1}, 0.5)
        for _, child in pairs(loadingGui:GetDescendants()) do
            if child:IsA("GuiObject") then
                Tween(child, {BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1}, 0.5)
            end
        end
        wait(0.5)
        loadingGui:Destroy()
    end)
    
    return loadingGui
end

-- Janela Principal
function ModernUI:CreateWindow(windowSettings)
    EnsureFolder()
    LoadConfig()
    
    -- Verificar Key
    if windowSettings.KeySettings and windowSettings.KeySettings.KeyEnable then
        if not self:VerifyKey(windowSettings.KeySettings) then
            self:CreateKeyWindow(windowSettings.KeySettings)
            repeat wait() until not game.CoreGui:FindFirstChild("KeySystem")
        end
    end
    
    -- Loading Screen
    if windowSettings.LoadingSettings then
        self:CreateLoadingScreen(windowSettings.LoadingSettings)
        wait(2.5)
    end
    
    local gui = CreateInstance("ScreenGui", {
        Name = "ModernUI",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })
    
    local mainFrame = CreateInstance("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 320, 0, 450),
        Position = UDim2.new(0.5, -160, 0.5, -225),
        BackgroundColor3 = Themes[Config.Theme].Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainFrame})
    
    -- Topbar Arrastável
    local topbar = CreateInstance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Themes[Config.Theme].Topbar,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = topbar})
    
    -- Fixar cantos arredondados no topo
    local fixCorner = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Themes[Config.Theme].Topbar,
        BorderSizePixel = 0,
        Parent = topbar
    })
    
    -- Ícone/Imagem
    local icon = CreateInstance("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 12, 0.5, -16),
        BackgroundTransparency = 1,
        Image = windowSettings.ImageId or "",
        Parent = topbar
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = icon})
    
    -- Nome da Window
    local title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 52, 0, 0),
        BackgroundTransparency = 1,
        Text = windowSettings.Name or "Modern UI",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = topbar
    })
    
    -- Botões do Topbar
    local btnSize = 28
    local btnSpacing = 34
    
    -- Botão Resize
    local resizeBtn = CreateInstance("ImageButton", {
        Name = "Resize",
        Size = UDim2.new(0, btnSize, 0, btnSize),
        Position = UDim2.new(1, -100, 0.5, -btnSize/2),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926307971",
        ImageRectOffset = Vector2.new(164, 284),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Themes[Config.Theme].Text,
        Parent = topbar
    })
    
    -- Botão Minimizar
    local minBtn = CreateInstance("ImageButton", {
        Name = "Minimize",
        Size = UDim2.new(0, btnSize, 0, btnSize),
        Position = UDim2.new(1, -66, 0.5, -btnSize/2),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926307971",
        ImageRectOffset = Vector2.new(884, 284),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Themes[Config.Theme].Text,
        Parent = topbar
    })
    
    -- Botão Fechar
    local closeBtn = CreateInstance("ImageButton", {
        Name = "Close",
        Size = UDim2.new(0, btnSize, 0, btnSize),
        Position = UDim2.new(1, -36, 0.5, -btnSize/2),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926307971",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = Themes[Config.Theme].Error,
        Parent = topbar
    })
    
    -- Container de Tabs
    local tabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 70, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Themes[Config.Theme].TabBackground,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    
    local tabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = tabContainer
    })
    CreateInstance("UIListLayout", {Padding = UDim.new(0, 5), Parent = tabList})
    
    -- Container de Conteúdo
    local contentContainer = CreateInstance("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -75, 1, -55),
        Position = UDim2.new(0, 75, 0, 55),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    
    -- Sistema de Drag
    MakeDraggable(topbar, mainFrame)
    
    -- Variáveis de controle
    local isSmall = false
    local tabCount = 0
    
    -- Função Minimizar
    minBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            Tween(mainFrame, {Size = UDim2.new(0, 320, 0, 50)}, 0.3)
            tabContainer.Visible = false
            contentContainer.Visible = false
        else
            Tween(mainFrame, {Size = isSmall and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 320, 0, 450)}, 0.3)
            tabContainer.Visible = true
            contentContainer.Visible = true
        end
    end)
    
    -- Função Resize
    resizeBtn.MouseButton1Click:Connect(function()
        isSmall = not isSmall
        if not IsMinimized then
            Tween(mainFrame, {
                Size = isSmall and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 320, 0, 450),
                Position = UDim2.new(0.5, isSmall and -140 or -160, 0.5, isSmall and -175 or -225)
            }, 0.3)
        end
    end)
    
    -- Função Fechar com Confirmação
    closeBtn.MouseButton1Click:Connect(function()
        -- Criar modal de confirmação
        local modal = CreateInstance("Frame", {
            Name = "ConfirmModal",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            Parent = gui
        })
        
        local confirmFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 260, 0, 140),
            Position = UDim2.new(0.5, -130, 0.5, -70),
            BackgroundColor3 = Themes[Config.Theme].Background,
            Parent = modal
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = confirmFrame})
        
        CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            Position = UDim2.new(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Text = "Close UI?",
            TextColor3 = Themes[Config.Theme].Text,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            Parent = confirmFrame
        })
        
        CreateInstance("TextLabel", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 50),
            BackgroundTransparency = 1,
            Text = "Are you sure you want to close?",
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = confirmFrame
        })
        
        local cancelBtn = CreateInstance("TextButton", {
            Size = UDim2.new(0, 100, 0, 35),
            Position = UDim2.new(0, 20, 1, -55),
            BackgroundColor3 = Themes[Config.Theme].ElementBackground,
            Text = "Cancel",
            TextColor3 = Themes[Config.Theme].Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = confirmFrame
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = cancelBtn})
        
        local yesBtn = CreateInstance("TextButton", {
            Size = UDim2.new(0, 100, 0, 35),
            Position = UDim2.new(1, -120, 1, -55),
            BackgroundColor3 = Themes[Config.Theme].Error,
            Text = "Yes",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = confirmFrame
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = yesBtn})
        
        cancelBtn.MouseButton1Click:Connect(function()
            Tween(modal, {BackgroundTransparency = 1}, 0.2)
            Tween(confirmFrame, {Position = UDim2.new(0.5, -130, 0.5, -50), Size = UDim2.new(0, 260, 0, 0)}, 0.2)
            wait(0.2)
            modal:Destroy()
        end)
        
        yesBtn.MouseButton1Click:Connect(function()
            SaveConfig()
            gui:Destroy()
        end)
    end)
    
    -- Objeto Window
    local Window = {}
    Window.Tabs = {}
    Window.Elements = {}
    
    -- Função para criar Tab
    function Window:CreateTab(tabSettings)
        tabCount = tabCount + 1
        
        local tabBtn = CreateInstance("ImageButton", {
            Name = tabSettings.Name or "Tab" .. tabCount,
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0, 5, 0, (tabCount-1) * 65 + 5),
            BackgroundColor3 = Themes[Config.Theme].ElementBackground,
            Parent = tabList
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = tabBtn})
        
        local tabIcon = CreateInstance("ImageLabel", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0.5, -15, 0, 8),
            BackgroundTransparency = 1,
            Image = tabSettings.ImageId or "",
            Parent = tabBtn
        })
        
        local tabName = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.new(0, 0, 1, -20),
            BackgroundTransparency = 1,
            Text = tabSettings.Name or "Tab",
            TextColor3 = Themes[Config.Theme].Text,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            Parent = tabBtn
        })
        
        -- Página da Tab
        local tabPage = CreateInstance("ScrollingFrame", {
            Name = tabSettings.Name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Themes[Config.Theme].Accent,
            Visible = false,
            Parent = contentContainer
        })
        CreateInstance("UIListLayout", {Padding = UDim.new(0, 8), Parent = tabPage})
        CreateInstance("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = tabPage})
        
        -- Seleção de Tab
        tabBtn.MouseButton1Click:Connect(function()
            if ActiveTab then
                Tween(ActiveTab.Button, {BackgroundColor3 = Themes[Config.Theme].ElementBackground}, 0.2)
                ActiveTab.Page.Visible = false
            end
            ActiveTab = {Button = tabBtn, Page = tabPage}
            Tween(tabBtn, {BackgroundColor3 = Themes[Config.Theme].Accent}, 0.2)
            tabPage.Visible = true
        end)
        
        -- Ativar primeira tab
        if tabCount == 1 then
            ActiveTab = {Button = tabBtn, Page = tabPage}
            Tween(tabBtn, {BackgroundColor3 = Themes[Config.Theme].Accent}, 0)
            tabPage.Visible = true
        end
        
        -- Objeto Tab
        local Tab = {}
        Tab.Page = tabPage
        Tab.Elements = {}
        
        -- 1. BOTÃO
        function Tab:AddButton(btnSettings)
            local btn = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                Text = btnSettings.Name or "Button",
                TextColor3 = Themes[Config.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = tabPage
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
            
            local btnIcon = CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Image = btnSettings.ImageId or "",
                Parent = btn
            })
            
            btn.MouseButton1Click:Connect(function()
                Tween(btn, {Size = UDim2.new(0.95, 0, 0, 38)}, 0.1)
                wait(0.1)
                Tween(btn, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
                if btnSettings.Callback then
                    btnSettings.Callback()
                end
            end)
            
            return btn
        end
        
        -- 2. TOGGLE
        function Tab:AddToggle(toggleSettings)
            local toggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                Parent = tabPage
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = toggleFrame})
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = toggleSettings.Name or "Toggle",
                TextColor3 = Themes[Config.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })
            
            local toggleBtn = CreateInstance("Frame", {
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -52, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Parent = toggleFrame
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggleBtn})
            
            local circle = CreateInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 2, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = toggleBtn
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
            
            local enabled = toggleSettings.Default or false
            local elementId = toggleSettings.Flag or toggleSettings.Name
            
            if Config.AutoSave and SavedValues[elementId] ~= nil then
                enabled = SavedValues[elementId]
            end
            
            local function UpdateToggle()
                if enabled then
                    Tween(toggleBtn, {BackgroundColor3 = Themes[Config.Theme].Accent}, 0.2)
                    Tween(circle, {Position = UDim2.new(0, 22, 0.5, -10)}, 0.2)
                else
                    Tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
                    Tween(circle, {Position = UDim2.new(0, 2, 0.5, -10)}, 0.2)
                end
                
                SavedValues[elementId] = enabled
                if toggleSettings.Callback then
                    toggleSettings.Callback(enabled)
                end
                SaveConfig()
            end
            
            UpdateToggle()
            
            toggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    enabled = not enabled
                    UpdateToggle()
                end
            end)
            
            return {
                Set = function(value)
                    enabled = value
                    UpdateToggle()
                end,
                Get = function() return enabled end
            }
        end
        
        -- 3. SLIDER
        function Tab:AddSlider(sliderSettings)
            local sliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                Parent = tabPage
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sliderFrame})
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(0.6, 0, 0, 25),
                Position = UDim2.new(0, 12, 0, 5),
                BackgroundTransparency = 1,
                Text = sliderSettings.Name or "Slider",
                TextColor3 = Themes[Config.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })
            
            local valueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.3, 0, 0, 25),
                Position = UDim2.new(0.7, -5, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(sliderSettings.Default or sliderSettings.Min or 0),
                TextColor3 = Themes[Config.Theme].Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })
            
            local sliderBg = CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 38),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Parent = sliderFrame
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderBg})
            
            local sliderFill = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Themes[Config.Theme].Accent,
                BorderSizePixel = 0,
                Parent = sliderBg
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderFill})
            
            local sliderKnob = CreateInstance("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, -8, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = sliderFill
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderKnob})
            
            local min = sliderSettings.Min or 0
            local max = sliderSettings.Max or 100
            local value = sliderSettings.Default or min
            local elementId = sliderSettings.Flag or sliderSettings.Name
            
            if Config.AutoSave and SavedValues[elementId] ~= nil then
                value = SavedValues[elementId]
            end
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                valueLabel.Text = tostring(value)
                
                SavedValues[elementId] = value
                if sliderSettings.Callback then
                    sliderSettings.Callback(value)
                end
                SaveConfig()
            end
            
            local dragging = false
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            -- Set initial value
            local initialPos = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
            valueLabel.Text = tostring(value)
            
            return {
                Set = function(val)
                    value = math.clamp(val, min, max)
                    local pos = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    SavedValues[elementId] = value
                    SaveConfig()
                end,
                Get = function() return value end
            }
        end
        
        -- 4. DROPDOWN
        function Tab:AddDropdown(dropdownSettings)
            local dropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                Parent = tabPage
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = dropdownFrame})
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = dropdownSettings.Name or "Dropdown",
                TextColor3 = Themes[Config.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })
            
            local selectedLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.4, -30, 1, 0),
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = dropdownSettings.Default or "Select...",
                TextColor3 = Themes[Config.Theme].Accent,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdownFrame
            })
            
            local arrow = CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "rbxassetid://3926307971",
                ImageRectOffset = Vector2.new(324, 524),
                ImageRectSize = Vector2.new(36, 36),
                ImageColor3 = Themes[Config.Theme].Text,
                Parent = dropdownFrame
            })
            
            local optionsFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 10,
                Parent = dropdownFrame
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = optionsFrame})
            
            local optionsList = CreateInstance("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ZIndex = 10,
                Parent = optionsFrame
            })
            CreateInstance("UIListLayout", {Padding = UDim.new(0, 2), Parent = optionsList})
            
            local selected = dropdownSettings.Default
            local options = dropdownSettings.Options or {}
            local elementId = dropdownSettings.Flag or dropdownSettings.Name
            local isOpen = false
            
            if Config.AutoSave and SavedValues[elementId] ~= nil then
                selected = SavedValues[elementId]
                selectedLabel.Text = selected
            end
            
            local function ToggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    optionsFrame.Visible = true
                    Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, math.min(#options * 35, 150))}, 0.2)
                    Tween(arrow, {Rotation = 180}, 0.2)
                else
                    Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    wait(0.2)
                    optionsFrame.Visible = false
                    Tween(arrow, {Rotation = 0}, 0.2)
                end
            end
            
            for _, option in pairs(options) do
                local optionBtn = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                    Text = option,
                    TextColor3 = Themes[Config.Theme].Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    ZIndex = 10,
                    Parent = optionsList
                })
                
                optionBtn.MouseButton1Click:Connect(function()
                    selected = option
                    selectedLabel.Text = selected
                    SavedValues[elementId] = selected
                    ToggleDropdown()
                    if dropdownSettings.Callback then
                        dropdownSettings.Callback(selected)
                    end
                    SaveConfig()
                end)
                
                optionBtn.MouseEnter:Connect(function()
                    Tween(optionBtn, {BackgroundColor3 = Themes[Config.Theme].Accent}, 0.2)
                end)
                optionBtn.MouseLeave:Connect(function()
                    Tween(optionBtn, {BackgroundColor3 = Themes[Config.Theme].ElementBackground}, 0.2)
                end)
            end
            
            dropdownFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ToggleDropdown()
                end
            end)
            
            return {
                Set = function(val)
                    selected = val
                    selectedLabel.Text = selected
                    SavedValues[elementId] = selected
                    SaveConfig()
                end,
                Get = function() return selected end,
                Refresh = function(newOptions)
                    options = newOptions
                    for _, child in pairs(optionsList:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    -- Recriar opções...
                end
            }
        end
        
        -- 5. TEXTBOX
        function Tab:AddTextBox(textboxSettings)
            local boxFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 70),
                BackgroundColor3 = Themes[Config.Theme].ElementBackground,
                Parent = tabPage
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = boxFrame})
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = textboxSettings.Name or "TextBox",
                TextColor3 = Themes[Config.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = boxFrame
            })
            
            local textBox = CreateInstance("TextBox", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundColor3 = Themes[Config.Theme].Background,
                BorderSizePixel = 0,
                Text = textboxSettings.Default or "",
                PlaceholderText = textboxSettings.Placeholder or "Type here...",
                TextColor3 = Themes[Config.Theme].Text,
                PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = boxFrame
            })
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = textBox})
            
            local elementId = textboxSettings.Flag or textboxSettings.Name
            
            if Config.AutoSave and SavedValues[elementId] ~= nil then
                textBox.Text = SavedValues[elementId]
            end
            
            textBox.FocusLost:Connect(function()
                SavedValues[elementId] = textBox.Text
                if textboxSettings.Callback then
                    textboxSettings.Callback(textBox.Text)
                end
                SaveConfig()
            end)
            
            return {
                Set = function(text)
                    textBox.Text = text
                    SavedValues[elementId] = text
                    SaveConfig()
                end,
                Get = function() return textBox.Text end
            }
        end
        
        -- 6. LABEL
        function Tab:AddLabel(labelSettings)
            local labelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = tabPage
            })
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = labelSettings.Text or "Label",
                TextColor3 = labelSettings.Color or Themes[Config.Theme].Text,
                TextSize = labelSettings.Size or 14,
                Font = labelSettings.Bold and Enum.Font.GothamBold or Enum.Font.Gotham,
                TextXAlignment = labelSettings.Alignment or Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = labelFrame
            })
            
            return {
                Set = function(text)
                    label.Text = text
                end,
                Get = function() return label.Text end
            }
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Config Tab (AddConfig)
    function Window:AddConfig()
        if ConfigTabAdded then return end
        ConfigTabAdded = true
        
        local configTab = self:CreateTab({
            Name = "Config",
            ImageId = "rbxassetid://3926307971"
        })
        
        -- Dropdown de Temas (20 temas na Parte 1)
        local themeDropdown = configTab:AddDropdown({
            Name = "Theme",
            Options = {"Dark", "Light", "Midnight", "Forest", "Sunset", "Ocean", "Cyber", "Gold", "Cherry", "Matrix", "Lavender", "Coffee", "Neon", "Pastel", "Vampire", "Discord", "Spotify", "Youtube", "Twitch", "Glass"},
            Default = Config.Theme,
            Callback = function(selected)
                Config.Theme = selected
                -- Atualizar cores (simplificado - na prática precisaria atualizar todos os elementos)
                SaveConfig()
            end
        })
        
        -- Toggle Transparência
        local transparencyToggle = configTab:AddToggle({
            Name = "Transparency Mode",
            Default = Config.Transparency,
            Callback = function(value)
                Config.Transparency = value
                if value then
                    mainFrame.BackgroundTransparency = 0.4
                    topbar.BackgroundTransparency = 0.4
                    tabContainer.BackgroundTransparency = 0.4
                else
                    mainFrame.BackgroundTransparency = 0
                    topbar.BackgroundTransparency = 0
                    tabContainer.BackgroundTransparency = 0
                end
                SaveConfig()
            end
        })
        
        -- Toggle AutoSave
        local autosaveToggle = configTab:AddToggle({
            Name = "Auto Save & Load",
            Default = Config.AutoSave,
            Callback = function(value)
                Config.AutoSave = value
                SaveConfig()
            end
        })
        
        -- Botão Export Config
        configTab:AddButton({
            Name = "Export Config",
            Callback = function()
                local json = HttpService:JSONEncode(SavedValues)
                pcall(function()
                    setclipboard(json)
                end)
            end
        })
        
        -- Botão Import Config
        configTab:AddButton({
            Name = "Import Config",
            Callback = function()
                -- Simplificado - na prática abriria um textbox
            end
        })
        
        return configTab
    end
    
    CurrentWindow = Window
    return Window
end

-- CONTINUAÇÃO: Temas Adicionais e Elementos Extra da Parte 2

-- Temas Adicionais (21-40) - Adicionar à tabela Themes existente
local AdditionalThemes = {
    Amethyst = {
        Background = Color3.fromRGB(30, 20, 40),
        Topbar = Color3.fromRGB(45, 30, 60),
        TabBackground = Color3.fromRGB(38, 25, 50),
        ElementBackground = Color3.fromRGB(60, 40, 80),
        Text = Color3.fromRGB(230, 210, 255),
        Accent = Color3.fromRGB(180, 100, 255),
        Success = Color3.fromRGB(150, 255, 150),
        Error = Color3.fromRGB(255, 100, 120)
    },
    Crimson = {
        Background = Color3.fromRGB(40, 10, 15),
        Topbar = Color3.fromRGB(60, 15, 25),
        TabBackground = Color3.fromRGB(50, 12, 20),
        ElementBackground = Color3.fromRGB(85, 25, 40),
        Text = Color3.fromRGB(255, 220, 225),
        Accent = Color3.fromRGB(220, 50, 80),
        Success = Color3.fromRGB(255, 150, 170),
        Error = Color3.fromRGB(200, 50, 50)
    },
    Arctic = {
        Background = Color3.fromRGB(240, 248, 255),
        Topbar = Color3.fromRGB(220, 240, 255),
        TabBackground = Color3.fromRGB(230, 245, 255),
        ElementBackground = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(40, 60, 80),
        Accent = Color3.fromRGB(100, 180, 255),
        Success = Color3.fromRGB(100, 220, 150),
        Error = Color3.fromRGB(255, 120, 100)
    },
    Slate = {
        Background = Color3.fromRGB(30, 35, 40),
        Topbar = Color3.fromRGB(45, 50, 58),
        TabBackground = Color3.fromRGB(38, 42, 48),
        ElementBackground = Color3.fromRGB(55, 62, 71),
        Text = Color3.fromRGB(220, 225, 230),
        Accent = Color3.fromRGB(130, 150, 180),
        Success = Color3.fromRGB(120, 220, 150),
        Error = Color3.fromRGB(220, 100, 100)
    },
    Mint = {
        Background = Color3.fromRGB(245, 255, 250),
        Topbar = Color3.fromRGB(220, 255, 240),
        TabBackground = Color3.fromRGB(235, 255, 245),
        ElementBackground = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(40, 80, 60),
        Accent = Color3.fromRGB(100, 220, 150),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(255, 120, 100)
    },
    Coral = {
        Background = Color3.fromRGB(45, 30, 30),
        Topbar = Color3.fromRGB(65, 45, 45),
        TabBackground = Color3.fromRGB(55, 38, 38),
        ElementBackground = Color3.fromRGB(90, 65, 65),
        Text = Color3.fromRGB(255, 230, 225),
        Accent = Color3.fromRGB(255, 130, 110),
        Success = Color3.fromRGB(150, 255, 180),
        Error = Color3.fromRGB(255, 80, 80)
    },
    DeepSea = {
        Background = Color3.fromRGB(10, 25, 45),
        Topbar = Color3.fromRGB(15, 40, 70),
        TabBackground = Color3.fromRGB(12, 32, 58),
        ElementBackground = Color3.fromRGB(25, 60, 100),
        Text = Color3.fromRGB(200, 230, 255),
        Accent = Color3.fromRGB(0, 180, 220),
        Success = Color3.fromRGB(50, 255, 150),
        Error = Color3.fromRGB(255, 80, 100)
    },
    SunsetV2 = {
        Background = Color3.fromRGB(45, 25, 35),
        Topbar = Color3.fromRGB(70, 40, 55),
        TabBackground = Color3.fromRGB(58, 32, 45),
        ElementBackground = Color3.fromRGB(95, 55, 75),
        Text = Color3.fromRGB(255, 220, 230),
        Accent = Color3.fromRGB(255, 140, 100),
        Success = Color3.fromRGB(255, 200, 150),
        Error = Color3.fromRGB(255, 80, 90)
    },
    Galaxy = {
        Background = Color3.fromRGB(15, 10, 35),
        Topbar = Color3.fromRGB(25, 18, 55),
        TabBackground = Color3.fromRGB(20, 14, 45),
        ElementBackground = Color3.fromRGB(40, 30, 80),
        Text = Color3.fromRGB(230, 220, 255),
        Accent = Color3.fromRGB(180, 100, 255),
        Success = Color3.fromRGB(150, 255, 200),
        Error = Color3.fromRGB(255, 100, 150)
    },
    Lemon = {
        Background = Color3.fromRGB(45, 45, 25),
        Topbar = Color3.fromRGB(65, 65, 38),
        TabBackground = Color3.fromRGB(55, 55, 32),
        ElementBackground = Color3.fromRGB(90, 90, 50),
        Text = Color3.fromRGB(255, 255, 220),
        Accent = Color3.fromRGB(255, 240, 100),
        Success = Color3.fromRGB(200, 255, 150),
        Error = Color3.fromRGB(255, 120, 100)
    },
    Rose = {
        Background = Color3.fromRGB(45, 25, 35),
        Topbar = Color3.fromRGB(65, 38, 52),
        TabBackground = Color3.fromRGB(55, 32, 44),
        ElementBackground = Color3.fromRGB(90, 55, 75),
        Text = Color3.fromRGB(255, 220, 235),
        Accent = Color3.fromRGB(255, 150, 180),
        Success = Color3.fromRGB(255, 200, 220),
        Error = Color3.fromRGB(230, 80, 100)
    },
    Emerald = {
        Background = Color3.fromRGB(15, 40, 30),
        Topbar = Color3.fromRGB(25, 60, 45),
        TabBackground = Color3.fromRGB(20, 50, 38),
        ElementBackground = Color3.fromRGB(35, 85, 65),
        Text = Color3.fromRGB(220, 255, 240),
        Accent = Color3.fromRGB(80, 220, 150),
        Success = Color3.fromRGB(100, 255, 180),
        Error = Color3.fromRGB(255, 100, 100)
    },
    Azure = {
        Background = Color3.fromRGB(20, 35, 60),
        Topbar = Color3.fromRGB(30, 55, 90),
        TabBackground = Color3.fromRGB(25, 45, 75),
        ElementBackground = Color3.fromRGB(45, 80, 130),
        Text = Color3.fromRGB(220, 235, 255),
        Accent = Color3.fromRGB(100, 180, 255),
        Success = Color3.fromRGB(100, 255, 200),
        Error = Color3.fromRGB(255, 100, 120)
    },
    Monochrome = {
        Background = Color3.fromRGB(20, 20, 20),
        Topbar = Color3.fromRGB(40, 40, 40),
        TabBackground = Color3.fromRGB(30, 30, 30),
        ElementBackground = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(200, 255, 200),
        Error = Color3.fromRGB(255, 100, 100)
    },
    Peach = {
        Background = Color3.fromRGB(255, 240, 230),
        Topbar = Color3.fromRGB(255, 220, 205),
        TabBackground = Color3.fromRGB(255, 230, 218),
        ElementBackground = Color3.fromRGB(255, 245, 240),
        Text = Color3.fromRGB(80, 50, 40),
        Accent = Color3.fromRGB(255, 180, 150),
        Success = Color3.fromRGB(150, 230, 180),
        Error = Color3.fromRGB(255, 130, 110)
    },
    Berry = {
        Background = Color3.fromRGB(35, 15, 30),
        Topbar = Color3.fromRGB(55, 25, 48),
        TabBackground = Color3.fromRGB(45, 20, 40),
        ElementBackground = Color3.fromRGB(75, 35, 68),
        Text = Color3.fromRGB(255, 220, 245),
        Accent = Color3.fromRGB(220, 100, 180),
        Success = Color3.fromRGB(200, 255, 200),
        Error = Color3.fromRGB(255, 100, 130)
    },
    Citrus = {
        Background = Color3.fromRGB(50, 45, 25),
        Topbar = Color3.fromRGB(75, 68, 38),
        TabBackground = Color3.fromRGB(62, 55, 32),
        ElementBackground = Color3.fromRGB(100, 90, 50),
        Text = Color3.fromRGB(255, 250, 220),
        Accent = Color3.fromRGB(255, 200, 80),
        Success = Color3.fromRGB(200, 255, 120),
        Error = Color3.fromRGB(255, 120, 100)
    },
    Frost = {
        Background = Color3.fromRGB(230, 245, 255),
        Topbar = Color3.fromRGB(210, 235, 255),
        TabBackground = Color3.fromRGB(220, 240, 255),
        ElementBackground = Color3.fromRGB(240, 250, 255),
        Text = Color3.fromRGB(40, 60, 80),
        Accent = Color3.fromRGB(150, 210, 255),
        Success = Color3.fromRGB(150, 255, 200),
        Error = Color3.fromRGB(255, 150, 150)
    },
    Inferno = {
        Background = Color3.fromRGB(35, 15, 10),
        Topbar = Color3.fromRGB(55, 25, 15),
        TabBackground = Color3.fromRGB(45, 20, 12),
        ElementBackground = Color3.fromRGB(75, 35, 20),
        Text = Color3.fromRGB(255, 220, 210),
        Accent = Color3.fromRGB(255, 100, 50),
        Success = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 60, 60)
    },
    Aurora = {
        Background = Color3.fromRGB(20, 30, 40),
        Topbar = Color3.fromRGB(35, 50, 65),
        TabBackground = Color3.fromRGB(28, 40, 52),
        ElementBackground = Color3.fromRGB(50, 75, 95),
        Text = Color3.fromRGB(220, 240, 255),
        Accent = Color3.fromRGB(100, 255, 200),
        Success = Color3.fromRGB(150, 255, 180),
        Error = Color3.fromRGB(255, 120, 140)
    }
}

-- Mesclar temas adicionais
for name, theme in pairs(AdditionalThemes) do
    Themes[name] = theme
end

-- Sistema de Notificações
local NotificationQueue = {}
local IsProcessingQueue = false

function ModernUI:Notify(notificationSettings)
    table.insert(NotificationQueue, notificationSettings)
    if not IsProcessingQueue then
        self:ProcessNotificationQueue()
    end
end

function ModernUI:ProcessNotificationQueue()
    IsProcessingQueue = true
    
    while #NotificationQueue > 0 do
        local settings = table.remove(NotificationQueue, 1)
        self:ShowNotification(settings)
        wait(settings.Duration and settings.Duration + 0.5 or 3.5)
    end
    
    IsProcessingQueue = false
end

function ModernUI:ShowNotification(settings)
    local notifGui = CreateInstance("ScreenGui", {
        Name = "Notification",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })
    
    local notifFrame = CreateInstance("Frame", {
        Size = UDim2.new(0, 280, 0, 0),
        Position = UDim2.new(1, -300, 0, 20),
        BackgroundColor3 = Themes[Config.Theme].Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = notifGui
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = notifFrame})
    CreateInstance("UIStroke", {Color = Themes[Config.Theme].Accent, Thickness = 1, Parent = notifFrame})
    
    local icon = CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Image = settings.ImageId or "rbxassetid://3926307971",
        ImageColor3 = settings.Type == "Error" and Themes[Config.Theme].Error or 
                     (settings.Type == "Success" and Themes[Config.Theme].Success or Themes[Config.Theme].Accent),
        Parent = notifFrame
    })
    
    local title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 0, 25),
        Position = UDim2.new(0, 60, 0, 8),
        BackgroundTransparency = 1,
        Text = settings.Title or "Notification",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifFrame
    })
    
    local message = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 0, 35),
        Position = UDim2.new(0, 60, 0, 30),
        BackgroundTransparency = 1,
        Text = settings.Message or "",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notifFrame
    })
    
    local progressBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Themes[Config.Theme].Accent,
        BorderSizePixel = 0,
        Parent = notifFrame
    })
    
    -- Calcular altura baseada no texto
    local textHeight = math.max(60, 35 + message.TextBounds.Y)
    notifFrame.Size = UDim2.new(0, 280, 0, textHeight)
    
    -- Animação de entrada
    Tween(notifFrame, {Position = UDim2.new(1, -300, 0, 20)}, 0.3)
    
    -- Barra de progresso
    local duration = settings.Duration or 3
    Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration)
    
    -- Auto fechar
    spawn(function()
        wait(duration)
        Tween(notifFrame, {Position = UDim2.new(1, 20, 0, 20)}, 0.3)
        wait(0.3)
        notifGui:Destroy()
    end)
    
    -- Fechar ao clicar
    notifFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            Tween(notifFrame, {Position = UDim2.new(1, 20, 0, 20)}, 0.2)
            wait(0.2)
            notifGui:Destroy()
        end
    end)
end

-- Atualizar função CreateTab da Parte 1 para incluir novos elementos
-- Adicione estas funções dentro do objeto Tab (antes do return Tab)

-- 7. COLORPICKER
function Tab:AddColorPicker(colorSettings)
    local colorFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        Parent = tabPage
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = colorFrame})
    
    local label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = colorSettings.Name or "Color",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = colorFrame
    })
    
    local colorDisplay = CreateInstance("TextButton", {
        Size = UDim2.new(0, 50, 0, 28),
        Position = UDim2.new(1, -62, 0.5, -14),
        BackgroundColor3 = colorSettings.Default or Color3.fromRGB(255, 0, 0),
        Text = "",
        Parent = colorFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = colorDisplay})
    CreateInstance("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Parent = colorDisplay})
    
    local pickerFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = colorFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = pickerFrame})
    
    -- Hue Slider
    local hueSlider = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = pickerFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = hueSlider})
    
    local hueGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Parent = hueSlider
    })
    
    local hueKnob = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 1, 4),
        Position = UDim2.new(0, -6, 0, -2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = hueSlider
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 2), Parent = hueKnob})
    
    -- Saturation/Value Box
    local svBox = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = pickerFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = svBox})
    
    local satGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Parent = svBox
    })
    
    local valFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0,
        ZIndex = 10,
        Parent = svBox
    })
    
    local valGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Transparency = NumberSequence.new(1, 0),
        Rotation = 90,
        Parent = valFrame
    })
    
    local svKnob = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -6, 0, -6),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = svBox
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = svKnob})
    
    local rgbLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 125),
        BackgroundTransparency = 1,
        Text = "255, 0, 0",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ZIndex = 10,
        Parent = pickerFrame
    })
    
    local currentColor = colorSettings.Default or Color3.fromRGB(255, 0, 0)
    local hue, sat, val = 0, 1, 1
    local elementId = colorSettings.Flag or colorSettings.Name
    local isOpen = false
    
    if Config.AutoSave and SavedValues[elementId] then
        local saved = SavedValues[elementId]
        if typeof(saved) == "table" and saved.R then
            currentColor = Color3.fromRGB(saved.R, saved.G, saved.B)
        end
    end
    
    local function UpdateColor()
        local newColor = Color3.fromHSV(hue, sat, val)
        currentColor = newColor
        colorDisplay.BackgroundColor3 = newColor
        svBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        rgbLabel.Text = string.format("%d, %d, %d", math.floor(newColor.R * 255), math.floor(newColor.G * 255), math.floor(newColor.B * 255))
        
        SavedValues[elementId] = {R = math.floor(newColor.R * 255), G = math.floor(newColor.G * 255), B = math.floor(newColor.B * 255)}
        if colorSettings.Callback then
            colorSettings.Callback(newColor)
        end
        SaveConfig()
    end
    
    local function TogglePicker()
        isOpen = not isOpen
        if isOpen then
            pickerFrame.Visible = true
            Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 150)}, 0.2)
        else
            Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            wait(0.2)
            pickerFrame.Visible = false
        end
    end
    
    -- Hue dragging
    local hueDragging = false
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local pos = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
            hue = pos
            hueKnob.Position = UDim2.new(pos, -6, 0, -2)
            UpdateColor()
        end
    end)
    
    -- SV dragging
    local svDragging = false
    svBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local x = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
            sat = x
            val = 1 - y
            svKnob.Position = UDim2.new(x, -6, y, -6)
            UpdateColor()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local pos = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
            hue = pos
            hueKnob.Position = UDim2.new(pos, -6, 0, -2)
            UpdateColor()
        elseif svDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local x = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
            sat = x
            val = 1 - y
            svKnob.Position = UDim2.new(x, -6, y, -6)
            UpdateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
            svDragging = false
        end
    end)
    
    colorDisplay.MouseButton1Click:Connect(TogglePicker)
    
    -- Set initial
    colorDisplay.BackgroundColor3 = currentColor
    
    return {
        Set = function(color)
            currentColor = color
            colorDisplay.BackgroundColor3 = color
            SavedValues[elementId] = {R = math.floor(color.R * 255), G = math.floor(color.G * 255), B = math.floor(color.B * 255)}
            SaveConfig()
        end,
        Get = function() return currentColor end
    }
end

-- 8. KEYBIND
function Tab:AddKeybind(keybindSettings)
    local bindFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        Parent = tabPage
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = bindFrame})
    
    local label = CreateInstance("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = keybindSettings.Name or "Keybind",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = bindFrame
    })
    
    local bindBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 70, 0, 28),
        Position = UDim2.new(1, -82, 0.5, -14),
        BackgroundColor3 = Themes[Config.Theme].Background,
        Text = keybindSettings.Default and keybindSettings.Default.Name or "None",
        TextColor3 = Themes[Config.Theme].Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = bindFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = bindBtn})
    
    local currentKey = keybindSettings.Default
    local elementId = keybindSettings.Flag or keybindSettings.Name
    local listening = false
    
    if Config.AutoSave and SavedValues[elementId] then
        currentKey = Enum.KeyCode[SavedValues[elementId]]
        bindBtn.Text = currentKey and currentKey.Name or "None"
    end
    
    bindBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        bindBtn.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                bindBtn.Text = currentKey.Name
                SavedValues[elementId] = currentKey.Name
                SaveConfig()
                listening = false
                connection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.Touch then
                bindBtn.Text = currentKey and currentKey.Name or "None"
                listening = false
                connection:Disconnect()
            end
        end)
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == currentKey and keybindSettings.Callback and not listening then
            keybindSettings.Callback()
        end
    end)
    
    return {
        Set = function(key)
            currentKey = key
            bindBtn.Text = key and key.Name or "None"
            SavedValues[elementId] = key and key.Name or nil
            SaveConfig()
        end,
        Get = function() return currentKey end
    }
end

-- 9. PARAGRAPH
function Tab:AddParagraph(paragraphSettings)
    local paraFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        Parent = tabPage
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = paraFrame})
    
    local title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = paragraphSettings.Title or "Title",
        TextColor3 = Themes[Config.Theme].Accent,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = paraFrame
    })
    
    local content = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 28),
        BackgroundTransparency = 1,
        Text = paragraphSettings.Content or "Content text here...",
        TextColor3 = Themes[Config.Theme].Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = paraFrame
    })
    
    -- Ajustar altura baseada no texto
    spawn(function()
        wait()
        local textHeight = content.TextBounds.Y
        paraFrame.Size = UDim2.new(1, 0, 0, 35 + textHeight)
    end)
    
    return {
        SetTitle = function(text) title.Text = text end,
        SetContent = function(text) 
            content.Text = text
            local textHeight = content.TextBounds.Y
            paraFrame.Size = UDim2.new(1, 0, 0, 35 + textHeight)
        end
    }
end

-- 10. DIVIDER
function Tab:AddDivider(dividerSettings)
    local divFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = tabPage
    })
    
    local line = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0.5, 0),
        BackgroundColor3 = dividerSettings.Color or Themes[Config.Theme].Accent,
        BackgroundTransparency = 0.5,
        Parent = divFrame
    })
    
    if dividerSettings.Text then
        local textLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0.5, -50, 0, 0),
            BackgroundColor3 = Themes[Config.Theme].Background,
            Text = dividerSettings.Text,
            TextColor3 = dividerSettings.Color or Themes[Config.Theme].Accent,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = divFrame
        })
    end
    
    return divFrame
end

-- 11. NOTIFICATION (Elemento local na tab)
function Tab:AddNotificationToggle(notifSettings)
    return self:AddToggle({
        Name = notifSettings.Name or "Notifications",
        Default = notifSettings.Default or true,
        Callback = function(value)
            -- Controla se notificações globais estão ativas
            _G.ModernUINotifications = value
        end
    })
end

-- 12. IMAGEBUTTON
function Tab:AddImageButton(imgBtnSettings)
    local btnFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = Themes[Config.Theme].ElementBackground,
        Parent = tabPage
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = btnFrame})
    
    local imgBtn = CreateInstance("ImageButton", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Image = imgBtnSettings.ImageId or "",
        ScaleType = Enum.ScaleType.Crop,
        Parent = btnFrame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = imgBtn})
    
    if imgBtnSettings.Text then
        local textBg = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 1, -30),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            Parent = imgBtn
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 0, 0, 8), Parent = textBg})
        
        local textLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = imgBtnSettings.Text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = textBg
        })
    end
    
    -- Efeito de hover/click
    imgBtn.MouseButton1Down:Connect(function()
        Tween(imgBtn, {Size = UDim2.new(0.95, 0, 0.95, 0), Position = UDim2.new(0.025, 0, 0.025, 0)}, 0.1)
    end)
    
    imgBtn.MouseButton1Up:Connect(function()
        Tween(imgBtn, {Size = UDim2.new(1, -20, 1, -20), Position = UDim2.new(0, 10, 0, 10)}, 0.1)
    end)
    
    imgBtn.MouseButton1Click:Connect(function()
        if imgBtnSettings.Callback then
            imgBtnSettings.Callback()
        end
    end)
    
    return imgBtn
end

-- Atualizar Config Tab para incluir todos os 40 temas
function Window:AddConfig()
    if ConfigTabAdded then return end
    ConfigTabAdded = true
    
    local configTab = self:CreateTab({
        Name = "Config",
        ImageId = "rbxassetid://3926307971"
    })
    
    -- Lista completa de 40 temas
    local allThemes = {
        "Dark", "Light", "Midnight", "Forest", "Sunset", "Ocean", "Cyber", "Gold", "Cherry", "Matrix",
        "Lavender", "Coffee", "Neon", "Pastel", "Vampire", "Discord", "Spotify", "Youtube", "Twitch", "Glass",
        "Amethyst", "Crimson", "Arctic", "Slate", "Mint", "Coral", "DeepSea", "SunsetV2", "Galaxy", "Lemon",
        "Rose", "Emerald", "Azure", "Monochrome", "Peach", "Berry", "Citrus", "Frost", "Inferno", "Aurora"
    }
    
    local themeDropdown = configTab:AddDropdown({
        Name = "Theme",
        Options = allThemes,
        Default = Config.Theme,
        Callback = function(selected)
            Config.Theme = selected
            ModernUI:Notify({
                Title = "Theme Changed",
                Message = "Theme set to " .. selected,
                Type = "Success",
                Duration = 2
            })
            SaveConfig()
        end
    })
    
    local transparencyToggle = configTab:AddToggle({
        Name = "Transparency Mode (60%)",
        Default = Config.Transparency,
        Callback = function(value)
            Config.Transparency = value
            SaveConfig()
        end
    })
    
    local autosaveToggle = configTab:AddToggle({
        Name = "Auto Save & Load",
        Default = Config.AutoSave,
        Callback = function(value)
            Config.AutoSave = value
            SaveConfig()
        end
    })
    
    -- Botão para aplicar tema imediatamente
    configTab:AddButton({
        Name = "Apply Theme",
        Callback = function()
            ModernUI:Notify({
                Title = "Info",
                Message = "Restart script to apply theme fully",
                Type = "Info",
                Duration = 3
            })
        end
    })
    
    -- Botão Reset Config
    configTab:AddButton({
        Name = "Reset All Settings",
        Callback = function()
            pcall(function()
                if delfile then
                    delfile(Config.FolderName .. "/" .. Config.FileName)
                end
            end)
            SavedValues = {}
            ModernUI:Notify({
                Title = "Reset",
                Message = "All settings reset! Restart script.",
                Type = "Success",
                Duration = 3
            })
        end
    })
    
    return configTab
end

-- Função auxiliar para atualizar tema em tempo real (limitada)
function ModernUI:UpdateTheme(themeName)
    if Themes[themeName] then
        Config.Theme = themeName
        -- Notificar usuário que precisa reiniciar para algumas mudanças
        return true
    end
    return false
end

-- Retornar biblioteca completa
return ModernUI
