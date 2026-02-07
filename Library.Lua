--[[
    Neon Lira V2 - Modern UI Library
    Designed for Mobile Roblox
    Created with love ❤️
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configurações
local CONFIG = {
    SaveFolder = "NeonLiraV2",
    ConfigFile = "config.json",
    AutoSaveInterval = 5
}

-- Temas disponíveis
local THEMES = {
    Neon = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(75, 0, 130),
        Accent = Color3.fromRGB(255, 20, 147),
        Background = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 200)
    },
    Ocean = {
        Primary = Color3.fromRGB(0, 150, 199),
        Secondary = Color3.fromRGB(0, 119, 182),
        Accent = Color3.fromRGB(72, 202, 228),
        Background = Color3.fromRGB(10, 25, 35),
        Surface = Color3.fromRGB(20, 40, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 200, 210)
    },
    Sunset = {
        Primary = Color3.fromRGB(255, 107, 107),
        Secondary = Color3.fromRGB(255, 78, 80),
        Accent = Color3.fromRGB(255, 159, 64),
        Background = Color3.fromRGB(25, 15, 20),
        Surface = Color3.fromRGB(40, 25, 30),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 180, 180)
    },
    Forest = {
        Primary = Color3.fromRGB(46, 213, 115),
        Secondary = Color3.fromRGB(32, 191, 107),
        Accent = Color3.fromRGB(123, 237, 159),
        Background = Color3.fromRGB(15, 25, 15),
        Surface = Color3.fromRGB(25, 40, 25),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 200, 180)
    },
    Midnight = {
        Primary = Color3.fromRGB(59, 62, 102),
        Secondary = Color3.fromRGB(47, 50, 85),
        Accent = Color3.fromRGB(130, 142, 250),
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 30),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(170, 170, 190)
    },
    Sakura = {
        Primary = Color3.fromRGB(255, 183, 197),
        Secondary = Color3.fromRGB(255, 151, 171),
        Accent = Color3.fromRGB(255, 218, 224),
        Background = Color3.fromRGB(25, 20, 22),
        Surface = Color3.fromRGB(40, 30, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 180, 190)
    },
    Gold = {
        Primary = Color3.fromRGB(255, 215, 0),
        Secondary = Color3.fromRGB(218, 165, 32),
        Accent = Color3.fromRGB(255, 235, 59),
        Background = Color3.fromRGB(20, 18, 10),
        Surface = Color3.fromRGB(35, 30, 18),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 190, 170)
    },
    Ice = {
        Primary = Color3.fromRGB(174, 214, 241),
        Secondary = Color3.fromRGB(133, 193, 233),
        Accent = Color3.fromRGB(214, 234, 248),
        Background = Color3.fromRGB(15, 20, 25),
        Surface = Color3.fromRGB(25, 35, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(190, 200, 210)
    },
    Fire = {
        Primary = Color3.fromRGB(255, 71, 87),
        Secondary = Color3.fromRGB(255, 56, 56),
        Accent = Color3.fromRGB(255, 165, 2),
        Background = Color3.fromRGB(25, 10, 10),
        Surface = Color3.fromRGB(40, 18, 18),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 180, 180)
    },
    Matrix = {
        Primary = Color3.fromRGB(0, 255, 65),
        Secondary = Color3.fromRGB(0, 200, 50),
        Accent = Color3.fromRGB(100, 255, 150),
        Background = Color3.fromRGB(0, 5, 0),
        Surface = Color3.fromRGB(5, 15, 5),
        Text = Color3.fromRGB(0, 255, 65),
        TextDim = Color3.fromRGB(0, 180, 45)
    }
}

-- Função para criar tweens suaves
local function Tween(object, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(object, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

-- Função para salvar configurações
local function SaveConfig(fileName, data)
    local success, err = pcall(function()
        writefile(CONFIG.SaveFolder .. "/" .. fileName, HttpService:JSONEncode(data))
    end)
    if not success then
        warn("Erro ao salvar configuração:", err)
    end
end

-- Função para carregar configurações
local function LoadConfig(fileName)
    local success, result = pcall(function()
        if isfile(CONFIG.SaveFolder .. "/" .. fileName) then
            return HttpService:JSONDecode(readfile(CONFIG.SaveFolder .. "/" .. fileName))
        end
        return nil
    end)
    
    if success then
        return result
    else
        return nil
    end
end

-- Criar pasta de configuração
if not isfolder(CONFIG.SaveFolder) then
    makefolder(CONFIG.SaveFolder)
end

-- Função principal para criar a biblioteca
function Library:CreateWindow(options)
    local Window = {
        CurrentTheme = THEMES.Neon,
        TransparencyMode = false,
        AutoSaveEnabled = options.AutoSaveLoad or false,
        Tabs = {},
        Elements = {},
        ConfigData = {}
    }
    
    options = options or {}
    local windowName = options.Name or "Neon Lira V2"
    local imageId = options.ImageId or ""
    
    -- Sistema de Key
    local keyOptions = {
        KeyEnable = options.KeyEnable or false,
        Key = options.Key or "1234",
        KeyName = options.KeyName or "KeySystem",
        KeySave = options.KeySave or false,
        KeyFileName = options.KeyFileName or "key.json",
        GetKeyFromSite = options.GetKeyFromSite or false,
        KeySite = options.KeySite or ""
    }
    
    -- Loading
    local loadingOptions = {
        LoadingName = options.LoadingName or "Loading Hub",
        ImageId = options.ImageId or ""
    }
    
    -- ScreenGui Principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonLiraV2"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Criar tela de Loading
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "Loading"
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = ScreenGui
    
    local LoadingImage = Instance.new("ImageLabel")
    LoadingImage.Size = UDim2.new(0, 120, 0, 120)
    LoadingImage.Position = UDim2.new(0.5, -60, 0.4, -60)
    LoadingImage.BackgroundTransparency = 1
    LoadingImage.Image = "rbxassetid://" .. loadingOptions.ImageId
    LoadingImage.Parent = LoadingFrame
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Size = UDim2.new(0, 300, 0, 40)
    LoadingTitle.Position = UDim2.new(0.5, -150, 0.55, 0)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Text = loadingOptions.LoadingName
    LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingTitle.TextSize = 24
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Parent = LoadingFrame
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 0, 4)
    LoadingBar.Position = UDim2.new(0.5, -150, 0.65, 0)
    LoadingBar.BackgroundColor3 = Window.CurrentTheme.Primary
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = LoadingFrame
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(0, 4)
    LoadingBarCorner.Parent = LoadingBar
    
    -- Animar loading
    task.spawn(function()
        Tween(LoadingBar, {Size = UDim2.new(0, 300, 0, 4)}, 2, Enum.EasingStyle.Linear)
        task.wait(2.5)
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
        Tween(LoadingImage, {ImageTransparency = 1}, 0.5)
        Tween(LoadingTitle, {TextTransparency = 1}, 0.5)
        Tween(LoadingBar, {BackgroundTransparency = 1}, 0.5)
        task.wait(0.6)
        LoadingFrame:Destroy()
    end)
    
    -- Sistema de Key
    if keyOptions.KeyEnable then
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeySystem"
        KeyFrame.Size = UDim2.new(0, 380, 0, 280)
        KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
        KeyFrame.BackgroundColor3 = Window.CurrentTheme.Surface
        KeyFrame.BorderSizePixel = 0
        KeyFrame.Visible = false
        KeyFrame.Parent = ScreenGui
        
        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 12)
        KeyCorner.Parent = KeyFrame
        
        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, -40, 0, 50)
        KeyTitle.Position = UDim2.new(0, 20, 0, 20)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = keyOptions.KeyName
        KeyTitle.TextColor3 = Window.CurrentTheme.Text
        KeyTitle.TextSize = 22
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
        KeyTitle.Parent = KeyFrame
        
        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(1, -40, 0, 45)
        KeyInput.Position = UDim2.new(0, 20, 0, 90)
        KeyInput.BackgroundColor3 = Window.CurrentTheme.Background
        KeyInput.BorderSizePixel = 0
        KeyInput.PlaceholderText = "Digite a Key"
        KeyInput.PlaceholderColor3 = Window.CurrentTheme.TextDim
        KeyInput.Text = ""
        KeyInput.TextColor3 = Window.CurrentTheme.Text
        KeyInput.TextSize = 16
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.ClearTextOnFocus = false
        KeyInput.Parent = KeyFrame
        
        local KeyInputCorner = Instance.new("UICorner")
        KeyInputCorner.CornerRadius = UDim.new(0, 8)
        KeyInputCorner.Parent = KeyInput
        
        local KeyInputPadding = Instance.new("UIPadding")
        KeyInputPadding.PaddingLeft = UDim.new(0, 15)
        KeyInputPadding.Parent = KeyInput
        
        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(1, -40, 0, 45)
        SubmitButton.Position = UDim2.new(0, 20, 0, 155)
        SubmitButton.BackgroundColor3 = Window.CurrentTheme.Primary
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Text = "Verificar Key"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 16
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.Parent = KeyFrame
        
        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 8)
        SubmitCorner.Parent = SubmitButton
        
        local GetKeyButton = Instance.new("TextButton")
        GetKeyButton.Size = UDim2.new(1, -40, 0, 40)
        GetKeyButton.Position = UDim2.new(0, 20, 0, 215)
        GetKeyButton.BackgroundColor3 = Window.CurrentTheme.Secondary
        GetKeyButton.BorderSizePixel = 0
        GetKeyButton.Text = "Obter Key"
        GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKeyButton.TextSize = 14
        GetKeyButton.Font = Enum.Font.Gotham
        GetKeyButton.Visible = keyOptions.GetKeyFromSite
        GetKeyButton.Parent = KeyFrame
        
        local GetKeyCorner = Instance.new("UICorner")
        GetKeyCorner.CornerRadius = UDim.new(0, 8)
        GetKeyCorner.Parent = GetKeyButton
        
        -- Verificar key salva
        local savedKey = nil
        if keyOptions.KeySave then
            savedKey = LoadConfig(keyOptions.KeyFileName)
        end
        
        local function VerifyKey(inputKey)
            local correctKey = keyOptions.Key
            
            if keyOptions.GetKeyFromSite and keyOptions.KeySite ~= "" then
                local success, siteKey = pcall(function()
                    return game:HttpGet(keyOptions.KeySite)
                end)
                if success then
                    correctKey = siteKey:gsub("%s+", "")
                end
            end
            
            return inputKey == correctKey
        end
        
        if savedKey and VerifyKey(savedKey.key) then
            KeyFrame:Destroy()
        else
            task.wait(2.5)
            KeyFrame.Visible = true
            Tween(KeyFrame, {BackgroundTransparency = 0}, 0.3)
            
            SubmitButton.MouseButton1Click:Connect(function()
                local inputText = KeyInput.Text
                
                if VerifyKey(inputText) then
                    if keyOptions.KeySave then
                        SaveConfig(keyOptions.KeyFileName, {key = inputText})
                    end
                    
                    Tween(KeyFrame, {BackgroundTransparency = 1}, 0.3)
                    for _, child in pairs(KeyFrame:GetChildren()) do
                        if child:IsA("GuiObject") then
                            Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
                        end
                    end
                    task.wait(0.4)
                    KeyFrame:Destroy()
                else
                    -- Animação de erro
                    for i = 1, 3 do
                        Tween(KeyFrame, {Position = UDim2.new(0.5, -180, 0.5, -140)}, 0.05)
                        task.wait(0.05)
                        Tween(KeyFrame, {Position = UDim2.new(0.5, -200, 0.5, -140)}, 0.05)
                        task.wait(0.05)
                    end
                    Tween(KeyFrame, {Position = UDim2.new(0.5, -190, 0.5, -140)}, 0.1)
                end
            end)
            
            GetKeyButton.MouseButton1Click:Connect(function()
                if keyOptions.GetKeyFromSite and keyOptions.KeySite ~= "" then
                    setclipboard(keyOptions.KeySite)
                end
            end)
        end
    end
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 520, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
    MainFrame.BackgroundColor3 = Window.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundColor3 = Window.CurrentTheme.Primary
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 14)
    TopbarCorner.Parent = Topbar
    
    local TopbarBottom = Instance.new("Frame")
    TopbarBottom.Size = UDim2.new(1, 0, 0, 14)
    TopbarBottom.Position = UDim2.new(0, 0, 1, -14)
    TopbarBottom.BackgroundColor3 = Window.CurrentTheme.Primary
    TopbarBottom.BorderSizePixel = 0
    TopbarBottom.Parent = Topbar
    
    -- Logo
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(0, 35, 0, 35)
    LogoImage.Position = UDim2.new(0, 12, 0, 7)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "rbxassetid://" .. imageId
    LogoImage.Parent = Topbar
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = LogoImage
    
    -- Título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 300, 1, 0)
    TitleLabel.Position = UDim2.new(0, 55, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar
    
    -- Botões da Topbar
    local ButtonsFrame = Instance.new("Frame")
    ButtonsFrame.Size = UDim2.new(0, 110, 0, 30)
    ButtonsFrame.Position = UDim2.new(1, -120, 0, 10)
    ButtonsFrame.BackgroundTransparency = 1
    ButtonsFrame.Parent = Topbar
    
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Size = UDim2.new(0, 30, 0, 30)
    ResizeButton.Position = UDim2.new(0, 0, 0, 0)
    ResizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ResizeButton.BackgroundTransparency = 0.9
    ResizeButton.BorderSizePixel = 0
    ResizeButton.Text = "⛶"
    ResizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResizeButton.TextSize = 16
    ResizeButton.Font = Enum.Font.GothamBold
    ResizeButton.Parent = ButtonsFrame
    
    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 6)
    ResizeCorner.Parent = ResizeButton
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(0, 38, 0, 0)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.BackgroundTransparency = 0.9
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = ButtonsFrame
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(0, 76, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundTransparency = 0.9
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = ButtonsFrame
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Sistema de arrastar
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Tween(MainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
    end
    
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Funcionalidade dos botões
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 50)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(MainFrame, {Size = originalSize}, 0.3)
            MinimizeButton.Text = "−"
        end
    end)
    
    local isResized = false
    ResizeButton.MouseButton1Click:Connect(function()
        isResized = not isResized
        if isResized then
            originalSize = MainFrame.Size
            Tween(MainFrame, {Size = UDim2.new(0, 720, 0, 520)}, 0.3)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 520, 0, 420)}, 0.3)
        end
    end)
    
    -- Sistema de confirmação de fechamento
    local ConfirmFrame = Instance.new("Frame")
    ConfirmFrame.Size = UDim2.new(0, 300, 0, 150)
    ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    ConfirmFrame.BackgroundColor3 = Window.CurrentTheme.Surface
    ConfirmFrame.BorderSizePixel = 0
    ConfirmFrame.Visible = false
    ConfirmFrame.ZIndex = 10
    ConfirmFrame.Parent = ScreenGui
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 12)
    ConfirmCorner.Parent = ConfirmFrame
    
    local ConfirmTitle = Instance.new("TextLabel")
    ConfirmTitle.Size = UDim2.new(1, -40, 0, 60)
    ConfirmTitle.Position = UDim2.new(0, 20, 0, 20)
    ConfirmTitle.BackgroundTransparency = 1
    ConfirmTitle.Text = "Deseja fechar a UI?"
    ConfirmTitle.TextColor3 = Window.CurrentTheme.Text
    ConfirmTitle.TextSize = 18
    ConfirmTitle.Font = Enum.Font.GothamBold
    ConfirmTitle.ZIndex = 10
    ConfirmTitle.Parent = ConfirmFrame
    
    local YesButton = Instance.new("TextButton")
    YesButton.Size = UDim2.new(0, 120, 0, 40)
    YesButton.Position = UDim2.new(0, 20, 0, 90)
    YesButton.BackgroundColor3 = Window.CurrentTheme.Primary
    YesButton.BorderSizePixel = 0
    YesButton.Text = "Sim"
    YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    YesButton.TextSize = 16
    YesButton.Font = Enum.Font.GothamBold
    YesButton.ZIndex = 10
    YesButton.Parent = ConfirmFrame
    
    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 8)
    YesCorner.Parent = YesButton
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Size = UDim2.new(0, 120, 0, 40)
    CancelButton.Position = UDim2.new(0, 160, 0, 90)
    CancelButton.BackgroundColor3 = Window.CurrentTheme.Secondary
    CancelButton.BorderSizePixel = 0
    CancelButton.Text = "Cancelar"
    CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CancelButton.TextSize = 16
    CancelButton.Font = Enum.Font.GothamBold
    CancelButton.ZIndex = 10
    CancelButton.Parent = ConfirmFrame
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 8)
    CancelCorner.Parent = CancelButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ConfirmFrame.Visible = true
        Tween(ConfirmFrame, {BackgroundTransparency = 0}, 0.2)
    end)
    
    YesButton.MouseButton1Click:Connect(function()
        if Window.AutoSaveEnabled then
            SaveConfig(CONFIG.ConfigFile, Window.ConfigData)
        end
        ScreenGui:Destroy()
    end)
    
    CancelButton.MouseButton1Click:Connect(function()
        Tween(ConfirmFrame, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.2)
        ConfirmFrame.Visible = false
    end)
    
    -- Container das Tabs
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(0, 140, 1, -60)
    TabBar.Position = UDim2.new(0, 10, 0, 55)
    TabBar.BackgroundColor3 = Window.CurrentTheme.Surface
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 4
    TabBar.ScrollBarImageColor3 = Window.CurrentTheme.Primary
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.Parent = MainFrame
    
    local TabBarCorner = Instance.new("UICorner")
    TabBarCorner.CornerRadius = UDim.new(0, 10)
    TabBarCorner.Parent = TabBar
    
    local TabBarLayout = Instance.new("UIListLayout")
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarLayout.Padding = UDim.new(0, 6)
    TabBarLayout.Parent = TabBar
    
    local TabBarPadding = Instance.new("UIPadding")
    TabBarPadding.PaddingTop = UDim.new(0, 8)
    TabBarPadding.PaddingBottom = UDim.new(0, 8)
    TabBarPadding.PaddingLeft = UDim.new(0, 8)
    TabBarPadding.PaddingRight = UDim.new(0, 8)
    TabBarPadding.Parent = TabBar
    
    -- Container do conteúdo
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -170, 1, -60)
    ContentFrame.Position = UDim2.new(0, 160, 0, 55)
    ContentFrame.BackgroundColor3 = Window.CurrentTheme.Surface
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    -- Atualizar tamanho do canvas
    TabBarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, 0, 0, TabBarLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Funções da Window
    function Window:UpdateTheme(theme)
        Window.CurrentTheme = THEMES[theme] or THEMES.Neon
        
        MainFrame.BackgroundColor3 = Window.CurrentTheme.Background
        Topbar.BackgroundColor3 = Window.CurrentTheme.Primary
        TopbarBottom.BackgroundColor3 = Window.CurrentTheme.Primary
        TitleLabel.TextColor3 = Window.CurrentTheme.Text
        TabBar.BackgroundColor3 = Window.CurrentTheme.Surface
        TabBar.ScrollBarImageColor3 = Window.CurrentTheme.Primary
        ContentFrame.BackgroundColor3 = Window.CurrentTheme.Surface
        
        for _, tab in pairs(Window.Tabs) do
            if tab.IsActive then
                tab.Button.BackgroundColor3 = Window.CurrentTheme.Primary
            else
                tab.Button.BackgroundColor3 = Window.CurrentTheme.Background
            end
            tab.Button.TextColor3 = Window.CurrentTheme.Text
        end
    end
    
    function Window:SetTransparency(enabled)
        Window.TransparencyMode = enabled
        local transparency = enabled and 0.4 or 0
        
        Tween(MainFrame, {BackgroundTransparency = transparency}, 0.3)
        Tween(Topbar, {BackgroundTransparency = transparency}, 0.3)
        Tween(TabBar, {BackgroundTransparency = transparency}, 0.3)
        Tween(ContentFrame, {BackgroundTransparency = transparency}, 0.3)
        
        for _, tab in pairs(Window.Tabs) do
            Tween(tab.Button, {BackgroundTransparency = transparency}, 0.3)
        end
    end
    
    function Window:AddTab(name)
        local Tab = {
            Name = name,
            IsActive = false,
            Elements = {}
        }
        
        -- Botão da Tab
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Window.CurrentTheme.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Window.CurrentTheme.Text
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Parent = TabBar
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        -- Container da Tab
        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Name = name
        TabContainer.Size = UDim2.new(1, -20, 1, -20)
        TabContainer.Position = UDim2.new(0, 10, 0, 10)
        TabContainer.BackgroundTransparency = 1
        TabContainer.BorderSizePixel = 0
        TabContainer.ScrollBarThickness = 4
        TabContainer.ScrollBarImageColor3 = Window.CurrentTheme.Primary
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContainer.Visible = false
        TabContainer.Parent = ContentFrame
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.Parent = TabContainer
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end)
        
        Tab.Button = TabButton
        Tab.Container = TabContainer
        
        -- Ativar tab
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.IsActive = false
                t.Container.Visible = false
                Tween(t.Button, {BackgroundColor3 = Window.CurrentTheme.Background}, 0.2)
            end
            
            Tab.IsActive = true
            Tab.Container.Visible = true
            Tween(TabButton, {BackgroundColor3 = Window.CurrentTheme.Primary}, 0.2)
        end)
        
        -- Se for a primeira tab, ativar
        if #Window.Tabs == 0 then
            Tab.IsActive = true
            Tab.Container.Visible = true
            TabButton.BackgroundColor3 = Window.CurrentTheme.Primary
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Elementos da Tab
        function Tab:AddButton(options)
            local Button = {}
            local buttonName = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Window.CurrentTheme.Background
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = buttonName
            ButtonFrame.TextColor3 = Window.CurrentTheme.Text
            ButtonFrame.TextSize = 14
            ButtonFrame.Font = Enum.Font.Gotham
            ButtonFrame.Parent = TabContainer
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Window.CurrentTheme.Primary}, 0.1)
                task.wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Window.CurrentTheme.Background}, 0.1)
                callback()
            end)
            
            return Button
        end
        
        function Tab:AddToggle(options)
            local Toggle = {}
            local toggleName = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            Toggle.Value = default
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Window.CurrentTheme.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContainer
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Window.CurrentTheme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 24)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleButton.BackgroundColor3 = Toggle.Value and Window.CurrentTheme.Primary or Window.CurrentTheme.Secondary
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = Toggle.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            function Toggle:SetValue(value)
                Toggle.Value = value
                
                Tween(ToggleButton, {BackgroundColor3 = value and Window.CurrentTheme.Primary or Window.CurrentTheme.Secondary}, 0.2)
                Tween(ToggleCircle, {Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2)
                
                callback(value)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[toggleName] = value
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggle:SetValue(not Toggle.Value)
            end)
            
            table.insert(Tab.Elements, {Type = "Toggle", Name = toggleName, Object = Toggle})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[toggleName] ~= nil then
                    Toggle:SetValue(saved[toggleName])
                end
            end
            
            return Toggle
        end
        
        function Tab:AddSlider(options)
            local Slider = {}
            local sliderName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            Slider.Value = default
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Window.CurrentTheme.Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContainer
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -24, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderName
            SliderLabel.TextColor3 = Window.CurrentTheme.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -62, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Window.CurrentTheme.Primary
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBg = Instance.new("Frame")
            SliderBg.Size = UDim2.new(1, -24, 0, 6)
            SliderBg.Position = UDim2.new(0, 12, 1, -16)
            SliderBg.BackgroundColor3 = Window.CurrentTheme.Secondary
            SliderBg.BorderSizePixel = 0
            SliderBg.Parent = SliderFrame
            
            local SliderBgCorner = Instance.new("UICorner")
            SliderBgCorner.CornerRadius = UDim.new(1, 0)
            SliderBgCorner.Parent = SliderBg
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Window.CurrentTheme.Primary
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBg
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBg
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                
                Slider.Value = value
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                
                callback(value)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[sliderName] = value
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            function Slider:SetValue(value)
                value = math.clamp(value, min, max)
                Slider.Value = value
                SliderValue.Text = tostring(value)
                local pos = (value - min) / (max - min)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
                callback(value)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[sliderName] = value
                end
            end
            
            table.insert(Tab.Elements, {Type = "Slider", Name = sliderName, Object = Slider})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[sliderName] then
                    Slider:SetValue(saved[sliderName])
                end
            end
            
            return Slider
        end
        
        function Tab:AddDropdown(options)
            local Dropdown = {}
            local dropdownName = options.Name or "Dropdown"
            local items = options.Options or {}
            local default = options.Default or items[1]
            local callback = options.Callback or function() end
            
            Dropdown.Value = default
            Dropdown.Items = items
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Window.CurrentTheme.Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = false
            DropdownFrame.Parent = TabContainer
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownName
            DropdownLabel.TextColor3 = Window.CurrentTheme.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(0, 100, 1, 0)
            DropdownValue.Position = UDim2.new(1, -112, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = default
            DropdownValue.TextColor3 = Window.CurrentTheme.Primary
            DropdownValue.TextSize = 13
            DropdownValue.Font = Enum.Font.GothamBold
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.Parent = DropdownFrame
            
            local DropdownIcon = Instance.new("TextLabel")
            DropdownIcon.Size = UDim2.new(0, 20, 1, 0)
            DropdownIcon.Position = UDim2.new(1, -30, 0, 0)
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Text = "▼"
            DropdownIcon.TextColor3 = Window.CurrentTheme.Text
            DropdownIcon.TextSize = 12
            DropdownIcon.Font = Enum.Font.Gotham
            DropdownIcon.Parent = DropdownFrame
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 0, 45)
            DropdownList.BackgroundColor3 = Window.CurrentTheme.Surface
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Window.CurrentTheme.Primary
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, #items * 35)
            DropdownList.Visible = false
            DropdownList.ZIndex = 5
            DropdownList.Parent = DropdownFrame
            
            local DropdownListCorner = Instance.new("UICorner")
            DropdownListCorner.CornerRadius = UDim.new(0, 8)
            DropdownListCorner.Parent = DropdownList
            
            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownListLayout.Padding = UDim.new(0, 2)
            DropdownListLayout.Parent = DropdownList
            
            local isOpen = false
            
            for _, item in ipairs(items) do
                local ItemButton = Instance.new("TextButton")
                ItemButton.Size = UDim2.new(1, 0, 0, 30)
                ItemButton.BackgroundColor3 = item == default and Window.CurrentTheme.Primary or Color3.fromRGB(0, 0, 0)
                ItemButton.BackgroundTransparency = item == default and 0 or 1
                ItemButton.BorderSizePixel = 0
                ItemButton.Text = item
                ItemButton.TextColor3 = Window.CurrentTheme.Text
                ItemButton.TextSize = 13
                ItemButton.Font = Enum.Font.Gotham
                ItemButton.ZIndex = 5
                ItemButton.Parent = DropdownList
                
                ItemButton.MouseButton1Click:Connect(function()
                    Dropdown.Value = item
                    DropdownValue.Text = item
                    
                    for _, btn in ipairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            Tween(btn, {BackgroundTransparency = 1}, 0.2)
                        end
                    end
                    Tween(ItemButton, {BackgroundTransparency = 0, BackgroundColor3 = Window.CurrentTheme.Primary}, 0.2)
                    
                    callback(item)
                    
                    if Window.AutoSaveEnabled then
                        Window.ConfigData[dropdownName] = item
                    end
                    
                    isOpen = false
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    DropdownList.Visible = false
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    DropdownList.Visible = true
                    local listHeight = math.min(#items * 32, 150)
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    DropdownList.Visible = false
                end
            end)
            
            function Dropdown:SetValue(value)
                if table.find(items, value) then
                    Dropdown.Value = value
                    DropdownValue.Text = value
                    
                    for _, btn in ipairs(DropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            if btn.Text == value then
                                Tween(btn, {BackgroundTransparency = 0, BackgroundColor3 = Window.CurrentTheme.Primary}, 0.2)
                            else
                                Tween(btn, {BackgroundTransparency = 1}, 0.2)
                            end
                        end
                    end
                    
                    callback(value)
                    
                    if Window.AutoSaveEnabled then
                        Window.ConfigData[dropdownName] = value
                    end
                end
            end
            
            table.insert(Tab.Elements, {Type = "Dropdown", Name = dropdownName, Object = Dropdown})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[dropdownName] then
                    Dropdown:SetValue(saved[dropdownName])
                end
            end
            
            return Dropdown
        end
        
        function Tab:AddTextbox(options)
            local Textbox = {}
            local textboxName = options.Name or "Textbox"
            local placeholder = options.Placeholder or "Digite aqui..."
            local callback = options.Callback or function() end
            
            Textbox.Value = ""
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
            TextboxFrame.BackgroundColor3 = Window.CurrentTheme.Background
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContainer
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -24, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 12, 0, 8)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxName
            TextboxLabel.TextColor3 = Window.CurrentTheme.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local TextboxInput = Instance.new("TextBox")
            TextboxInput.Size = UDim2.new(1, -24, 0, 35)
            TextboxInput.Position = UDim2.new(0, 12, 1, -43)
            TextboxInput.BackgroundColor3 = Window.CurrentTheme.Surface
            TextboxInput.BorderSizePixel = 0
            TextboxInput.PlaceholderText = placeholder
            TextboxInput.PlaceholderColor3 = Window.CurrentTheme.TextDim
            TextboxInput.Text = ""
            TextboxInput.TextColor3 = Window.CurrentTheme.Text
            TextboxInput.TextSize = 13
            TextboxInput.Font = Enum.Font.Gotham
            TextboxInput.ClearTextOnFocus = false
            TextboxInput.Parent = TextboxFrame
            
            local TextboxInputCorner = Instance.new("UICorner")
            TextboxInputCorner.CornerRadius = UDim.new(0, 6)
            TextboxInputCorner.Parent = TextboxInput
            
            local TextboxPadding = Instance.new("UIPadding")
            TextboxPadding.PaddingLeft = UDim.new(0, 10)
            TextboxPadding.PaddingRight = UDim.new(0, 10)
            TextboxPadding.Parent = TextboxInput
            
            TextboxInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Textbox.Value = TextboxInput.Text
                    callback(Textbox.Value)
                    
                    if Window.AutoSaveEnabled then
                        Window.ConfigData[textboxName] = Textbox.Value
                    end
                end
            end)
            
            function Textbox:SetValue(value)
                Textbox.Value = value
                TextboxInput.Text = value
                callback(value)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[textboxName] = value
                end
            end
            
            table.insert(Tab.Elements, {Type = "Textbox", Name = textboxName, Object = Textbox})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[textboxName] then
                    Textbox:SetValue(saved[textboxName])
                end
            end
            
            return Textbox
        end
        
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundColor3 = Window.CurrentTheme.Background
            Label.BorderSizePixel = 0
            Label.Text = text
            Label.TextColor3 = Window.CurrentTheme.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabContainer
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = Label
            
            local LabelPadding = Instance.new("UIPadding")
            LabelPadding.PaddingLeft = UDim.new(0, 12)
            LabelPadding.Parent = Label
            
            return Label
        end
        
        function Tab:AddKeybind(options)
            local Keybind = {}
            local keybindName = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.E
            local callback = options.Callback or function() end
            
            Keybind.Value = default
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Window.CurrentTheme.Background
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContainer
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindName
            KeybindLabel.TextColor3 = Window.CurrentTheme.Text
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 70, 0, 28)
            KeybindButton.Position = UDim2.new(1, -82, 0.5, -14)
            KeybindButton.BackgroundColor3 = Window.CurrentTheme.Primary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = default.Name
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.Parent = KeybindFrame
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
            KeybindButtonCorner.Parent = KeybindButton
            
            local binding = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                binding = true
                KeybindButton.Text = "..."
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        Keybind.Value = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        connection:Disconnect()
                        
                        if Window.AutoSaveEnabled then
                            Window.ConfigData[keybindName] = input.KeyCode.Name
                        end
                    end
                end)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Keybind.Value then
                    callback()
                end
            end)
            
            function Keybind:SetValue(keycode)
                Keybind.Value = keycode
                KeybindButton.Text = keycode.Name
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[keybindName] = keycode.Name
                end
            end
            
            table.insert(Tab.Elements, {Type = "Keybind", Name = keybindName, Object = Keybind})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[keybindName] then
                    local keyCode = Enum.KeyCode[saved[keybindName]]
                    if keyCode then
                        Keybind:SetValue(keyCode)
                    end
                end
            end
            
            return Keybind
        end
        
        function Tab:AddColorPicker(options)
            local ColorPicker = {}
            local colorName = options.Name or "Color Picker"
            local default = options.Default or Color3.fromRGB(255, 255, 255)
            local callback = options.Callback or function() end
            
            ColorPicker.Value = default
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, 0, 0, 40)
            ColorFrame.BackgroundColor3 = Window.CurrentTheme.Background
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Parent = TabContainer
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorFrame
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -80, 1, 0)
            ColorLabel.Position = UDim2.new(0, 12, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = colorName
            ColorLabel.TextColor3 = Window.CurrentTheme.Text
            ColorLabel.TextSize = 14
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 60, 0, 28)
            ColorDisplay.Position = UDim2.new(1, -72, 0.5, -14)
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorFrame
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorDisplay
            
            ColorButton.MouseButton1Click:Connect(function()
                -- Sistema simples de cor aleatória para mobile
                local r = math.random(0, 255)
                local g = math.random(0, 255)
                local b = math.random(0, 255)
                local newColor = Color3.fromRGB(r, g, b)
                
                ColorPicker.Value = newColor
                Tween(ColorDisplay, {BackgroundColor3 = newColor}, 0.2)
                callback(newColor)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[colorName] = {r, g, b}
                end
            end)
            
            function ColorPicker:SetValue(color)
                ColorPicker.Value = color
                Tween(ColorDisplay, {BackgroundColor3 = color}, 0.2)
                callback(color)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[colorName] = {color.R * 255, color.G * 255, color.B * 255}
                end
            end
            
            table.insert(Tab.Elements, {Type = "ColorPicker", Name = colorName, Object = ColorPicker})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[colorName] then
                    local r, g, b = saved[colorName][1], saved[colorName][2], saved[colorName][3]
                    ColorPicker:SetValue(Color3.fromRGB(r, g, b))
                end
            end
            
            return ColorPicker
        end
        
        function Tab:AddParagraph(title, content)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 80)
            ParagraphFrame.BackgroundColor3 = Window.CurrentTheme.Background
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContainer
            
            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 8)
            ParagraphCorner.Parent = ParagraphFrame
            
            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -24, 0, 25)
            ParagraphTitle.Position = UDim2.new(0, 12, 0, 8)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = title
            ParagraphTitle.TextColor3 = Window.CurrentTheme.Text
            ParagraphTitle.TextSize = 15
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame
            
            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -24, 1, -38)
            ParagraphContent.Position = UDim2.new(0, 12, 0, 33)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = content
            ParagraphContent.TextColor3 = Window.CurrentTheme.TextDim
            ParagraphContent.TextSize = 13
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame
            
            return ParagraphFrame
        end
        
        function Tab:AddDivider(text)
            local DividerFrame = Instance.new("Frame")
            DividerFrame.Size = UDim2.new(1, 0, 0, 25)
            DividerFrame.BackgroundTransparency = 1
            DividerFrame.Parent = TabContainer
            
            local DividerLine = Instance.new("Frame")
            DividerLine.Size = UDim2.new(1, text and -80 or 0, 0, 2)
            DividerLine.Position = UDim2.new(0, 0, 0.5, -1)
            DividerLine.BackgroundColor3 = Window.CurrentTheme.Primary
            DividerLine.BorderSizePixel = 0
            DividerLine.Parent = DividerFrame
            
            if text then
                local DividerText = Instance.new("TextLabel")
                DividerText.Size = UDim2.new(0, 70, 1, 0)
                DividerText.Position = UDim2.new(1, -70, 0, 0)
                DividerText.BackgroundTransparency = 1
                DividerText.Text = text
                DividerText.TextColor3 = Window.CurrentTheme.Primary
                DividerText.TextSize = 13
                DividerText.Font = Enum.Font.GothamBold
                DividerText.TextXAlignment = Enum.TextXAlignment.Right
                DividerText.Parent = DividerFrame
            end
            
            return DividerFrame
        end
        
        function Tab:AddInput(options)
            local Input = {}
            local inputName = options.Name or "Input"
            local placeholder = options.Placeholder or "Digite..."
            local callback = options.Callback or function() end
            
            Input.Value = ""
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 40)
            InputFrame.BackgroundColor3 = Window.CurrentTheme.Background
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabContainer
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
            InputCorner.Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(0, 100, 1, 0)
            InputLabel.Position = UDim2.new(0, 12, 0, 0)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = inputName
            InputLabel.TextColor3 = Window.CurrentTheme.Text
            InputLabel.TextSize = 14
            InputLabel.Font = Enum.Font.Gotham
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -130, 0, 30)
            InputBox.Position = UDim2.new(0, 115, 0, 5)
            InputBox.BackgroundColor3 = Window.CurrentTheme.Surface
            InputBox.BorderSizePixel = 0
            InputBox.PlaceholderText = placeholder
            InputBox.PlaceholderColor3 = Window.CurrentTheme.TextDim
            InputBox.Text = ""
            InputBox.TextColor3 = Window.CurrentTheme.Text
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = InputFrame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox
            
            local InputPadding = Instance.new("UIPadding")
            InputPadding.PaddingLeft = UDim.new(0, 8)
            InputPadding.PaddingRight = UDim.new(0, 8)
            InputPadding.Parent = InputBox
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Input.Value = InputBox.Text
                    callback(Input.Value)
                    
                    if Window.AutoSaveEnabled then
                        Window.ConfigData[inputName] = Input.Value
                    end
                end
            end)
            
            function Input:SetValue(value)
                Input.Value = value
                InputBox.Text = value
                callback(value)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[inputName] = value
                end
            end
            
            table.insert(Tab.Elements, {Type = "Input", Name = inputName, Object = Input})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[inputName] then
                    Input:SetValue(saved[inputName])
                end
            end
            
            return Input
        end
        
        function Tab:AddCheckbox(options)
            local Checkbox = {}
            local checkboxName = options.Name or "Checkbox"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            Checkbox.Value = default
            
            local CheckboxFrame = Instance.new("Frame")
            CheckboxFrame.Size = UDim2.new(1, 0, 0, 40)
            CheckboxFrame.BackgroundColor3 = Window.CurrentTheme.Background
            CheckboxFrame.BorderSizePixel = 0
            CheckboxFrame.Parent = TabContainer
            
            local CheckboxCorner = Instance.new("UICorner")
            CheckboxCorner.CornerRadius = UDim.new(0, 8)
            CheckboxCorner.Parent = CheckboxFrame
            
            local CheckboxLabel = Instance.new("TextLabel")
            CheckboxLabel.Size = UDim2.new(1, -50, 1, 0)
            CheckboxLabel.Position = UDim2.new(0, 12, 0, 0)
            CheckboxLabel.BackgroundTransparency = 1
            CheckboxLabel.Text = checkboxName
            CheckboxLabel.TextColor3 = Window.CurrentTheme.Text
            CheckboxLabel.TextSize = 14
            CheckboxLabel.Font = Enum.Font.Gotham
            CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            CheckboxLabel.Parent = CheckboxFrame
            
            local CheckboxButton = Instance.new("TextButton")
            CheckboxButton.Size = UDim2.new(0, 24, 0, 24)
            CheckboxButton.Position = UDim2.new(1, -36, 0.5, -12)
            CheckboxButton.BackgroundColor3 = default and Window.CurrentTheme.Primary or Window.CurrentTheme.Surface
            CheckboxButton.BorderSizePixel = 0
            CheckboxButton.Text = default and "✓" or ""
            CheckboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxButton.TextSize = 16
            CheckboxButton.Font = Enum.Font.GothamBold
            CheckboxButton.Parent = CheckboxFrame
            
            local CheckboxButtonCorner = Instance.new("UICorner")
            CheckboxButtonCorner.CornerRadius = UDim.new(0, 6)
            CheckboxButtonCorner.Parent = CheckboxButton
            
            function Checkbox:SetValue(value)
                Checkbox.Value = value
                
                Tween(CheckboxButton, {BackgroundColor3 = value and Window.CurrentTheme.Primary or Window.CurrentTheme.Surface}, 0.2)
                CheckboxButton.Text = value and "✓" or ""
                
                callback(value)
                
                if Window.AutoSaveEnabled then
                    Window.ConfigData[checkboxName] = value
                end
            end
            
            CheckboxButton.MouseButton1Click:Connect(function()
                Checkbox:SetValue(not Checkbox.Value)
            end)
            
            table.insert(Tab.Elements, {Type = "Checkbox", Name = checkboxName, Object = Checkbox})
            
            if Window.AutoSaveEnabled then
                local saved = LoadConfig(CONFIG.ConfigFile)
                if saved and saved[checkboxName] ~= nil then
                    Checkbox:SetValue(saved[checkboxName])
                end
            end
            
            return Checkbox
        end
        
        return Tab
    end
    
    -- Tab de Configuração
    function Window:AddConfig()
        local ConfigTab = Window:AddTab("⚙ Config")
        
        ConfigTab:AddParagraph("Configurações", "Personalize a aparência e comportamento da UI")
        
        ConfigTab:AddDivider("Tema")
        
        local themes = {}
        for name, _ in pairs(THEMES) do
            table.insert(themes, name)
        end
        
        ConfigTab:AddDropdown({
            Name = "Tema",
            Options = themes,
            Default = "Neon",
            Callback = function(value)
                Window:UpdateTheme(value)
            end
        })
        
        ConfigTab:AddDivider("Visual")
        
        ConfigTab:AddToggle({
            Name = "Modo Transparência",
            Default = false,
            Callback = function(value)
                Window:SetTransparency(value)
            end
        })
        
        ConfigTab:AddDivider("Sistema")
        
        ConfigTab:AddToggle({
            Name = "Auto Save & Load",
            Default = Window.AutoSaveEnabled,
            Callback = function(value)
                Window.AutoSaveEnabled = value
                
                if value then
                    SaveConfig(CONFIG.ConfigFile, Window.ConfigData)
                end
            end
        })
        
        ConfigTab:AddDivider()
        
        ConfigTab:AddButton({
            Name = "Salvar Configuração Atual",
            Callback = function()
                SaveConfig(CONFIG.ConfigFile, Window.ConfigData)
            end
        })
        
        ConfigTab:AddButton({
            Name = "Resetar Configuração",
            Callback = function()
                Window.ConfigData = {}
                if isfile(CONFIG.SaveFolder .. "/" .. CONFIG.ConfigFile) then
                    delfile(CONFIG.SaveFolder .. "/" .. CONFIG.ConfigFile)
                end
            end
        })
        
        return ConfigTab
    end
    
    -- Auto save periódico
    if Window.AutoSaveEnabled then
        task.spawn(function()
            while task.wait(CONFIG.AutoSaveInterval) do
                if Window.AutoSaveEnabled then
                    SaveConfig(CONFIG.ConfigFile, Window.ConfigData)
                end
            end
        end)
    end
    
    return Window
end

return Library
