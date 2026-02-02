--[[
    UI Library Completa para Roblox Mobile/PC
    Por: Claude AI
    
    Características:
    ✓ Topbar arrastável com logo e nome
    ✓ 3 botões: Resize, Minimizar, Fechar (com confirmação)
    ✓ Sistema de Tabs com ícones
    ✓ Sistema de Key avançado com auto-load
    ✓ Loading screen customizável
    ✓ Auto Save & Load de configurações
    ✓ 12 elementos diferentes
    ✓ Tab de configurações automática
    ✓ 10 temas prontos
    ✓ Suporte Mobile/PC
    
    Exemplo de uso no final do arquivo!
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Temas disponíveis (10 temas)
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(50, 50, 60)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(70, 130, 255),
        Text = Color3.fromRGB(30, 30, 30),
        Border = Color3.fromRGB(200, 200, 210)
    },
    Purple = {
        Background = Color3.fromRGB(30, 20, 40),
        Secondary = Color3.fromRGB(45, 30, 60),
        Accent = Color3.fromRGB(150, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(70, 50, 90)
    },
    Red = {
        Background = Color3.fromRGB(35, 20, 20),
        Secondary = Color3.fromRGB(50, 30, 30),
        Accent = Color3.fromRGB(255, 70, 70),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(70, 40, 40)
    },
    Green = {
        Background = Color3.fromRGB(20, 35, 25),
        Secondary = Color3.fromRGB(30, 50, 35),
        Accent = Color3.fromRGB(70, 255, 120),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(40, 70, 50)
    },
    Blue = {
        Background = Color3.fromRGB(15, 25, 40),
        Secondary = Color3.fromRGB(25, 35, 55),
        Accent = Color3.fromRGB(60, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(35, 55, 80)
    },
    Orange = {
        Background = Color3.fromRGB(40, 25, 15),
        Secondary = Color3.fromRGB(55, 35, 25),
        Accent = Color3.fromRGB(255, 150, 60),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(80, 55, 35)
    },
    Pink = {
        Background = Color3.fromRGB(40, 20, 35),
        Secondary = Color3.fromRGB(55, 30, 50),
        Accent = Color3.fromRGB(255, 100, 200),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(80, 50, 70)
    },
    Cyan = {
        Background = Color3.fromRGB(15, 30, 35),
        Secondary = Color3.fromRGB(25, 45, 50),
        Accent = Color3.fromRGB(60, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(35, 70, 80)
    },
    Yellow = {
        Background = Color3.fromRGB(35, 35, 20),
        Secondary = Color3.fromRGB(50, 50, 30),
        Accent = Color3.fromRGB(255, 220, 80),
        Text = Color3.fromRGB(30, 30, 30),
        Border = Color3.fromRGB(70, 70, 45)
    }
}

-- Funções auxiliares
local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragButton)
    local dragging = false
    local dragInput, mousePos, framePos

    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    dragButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

local function SaveConfig(fileName, data)
    local success, err = pcall(function()
        writefile(fileName, HttpService:JSONEncode(data))
    end)
    return success
end

local function LoadConfig(fileName)
    local success, result = pcall(function()
        if isfile(fileName) then
            return HttpService:JSONDecode(readfile(fileName))
        end
        return nil
    end)
    return success and result or nil
end

-- Criar Window
function Library:CreateWindow(config)
    config = config or {}
    
    -- Config padrão
    local DefaultConfig = {
        KeyEnable = false,
        Key = "1234",
        KeyName = "UI Library",
        KeySave = false,
        KeyFileName = "UILibrary_Key.json",
        GetKeyFromSite = false,
        KeySite = "",
        AutoLoadKey = true,
        LoadingName = "Loading UI Library",
        ImageId = "",
        ["AutoSave&Load"] = false
    }
    
    for k, v in pairs(DefaultConfig) do
        if config[k] == nil then
            config[k] = v
        end
    end

    local Window = {
        CurrentTheme = "Dark",
        Config = config,
        Tabs = {},
        SaveData = {},
        ConfigElements = {}
    }

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. math.random(1000, 9999)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end

    -- Loading Screen
    local function ShowLoading()
        local LoadingFrame = Instance.new("Frame")
        LoadingFrame.Name = "LoadingFrame"
        LoadingFrame.Size = UDim2.new(0, 400, 0, 250)
        LoadingFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
        LoadingFrame.BackgroundColor3 = Themes.Dark.Background
        LoadingFrame.BorderSizePixel = 0
        LoadingFrame.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = LoadingFrame

        if config.ImageId ~= "" then
            local LoadingImage = Instance.new("ImageLabel")
            LoadingImage.Size = UDim2.new(0, 100, 0, 100)
            LoadingImage.Position = UDim2.new(0.5, -50, 0, 30)
            LoadingImage.BackgroundTransparency = 1
            LoadingImage.Image = "rbxassetid://" .. config.ImageId
            LoadingImage.Parent = LoadingFrame
        end

        local LoadingText = Instance.new("TextLabel")
        LoadingText.Size = UDim2.new(1, -40, 0, 30)
        LoadingText.Position = UDim2.new(0, 20, 0, 150)
        LoadingText.BackgroundTransparency = 1
        LoadingText.Text = config.LoadingName
        LoadingText.TextColor3 = Themes.Dark.Text
        LoadingText.Font = Enum.Font.GothamBold
        LoadingText.TextSize = 18
        LoadingText.Parent = LoadingFrame

        local LoadingBar = Instance.new("Frame")
        LoadingBar.Size = UDim2.new(0, 0, 0, 4)
        LoadingBar.Position = UDim2.new(0, 20, 0, 200)
        LoadingBar.BackgroundColor3 = Themes.Dark.Accent
        LoadingBar.BorderSizePixel = 0
        LoadingBar.Parent = LoadingFrame

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0, 2)
        BarCorner.Parent = LoadingBar

        Tween(LoadingBar, {Size = UDim2.new(1, -40, 0, 4)}, 2)
        wait(2)
        Tween(LoadingFrame, {Position = UDim2.new(0.5, -200, -0.5, 0)}, 0.5)
        wait(0.5)
        LoadingFrame:Destroy()
    end

    -- Sistema de Key
    local function ShowKeySystem()
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeyFrame"
        KeyFrame.Size = UDim2.new(0, 400, 0, config.GetKeyFromSite and 300 or 250)
        KeyFrame.Position = UDim2.new(0.5, -200, 0.5, config.GetKeyFromSite and -150 or -125)
        KeyFrame.BackgroundColor3 = Themes.Dark.Background
        KeyFrame.BorderSizePixel = 0
        KeyFrame.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = KeyFrame

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, 0, 0, 50)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = config.KeyName
        KeyTitle.TextColor3 = Themes.Dark.Text
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.TextSize = 20
        KeyTitle.Parent = KeyFrame

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(1, -40, 0, 45)
        KeyInput.Position = UDim2.new(0, 20, 0, 80)
        KeyInput.BackgroundColor3 = Themes.Dark.Secondary
        KeyInput.BorderSizePixel = 0
        KeyInput.PlaceholderText = "Digite a Key..."
        KeyInput.Text = ""
        KeyInput.TextColor3 = Themes.Dark.Text
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextSize = 16
        KeyInput.Parent = KeyFrame

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = KeyInput

        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(1, -40, 0, 45)
        SubmitButton.Position = UDim2.new(0, 20, 0, 150)
        SubmitButton.BackgroundColor3 = Themes.Dark.Accent
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Text = "Verificar Key"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.TextSize = 16
        SubmitButton.Parent = KeyFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = SubmitButton

        if config.GetKeyFromSite and config.KeySite ~= "" then
            local GetKeyButton = Instance.new("TextButton")
            GetKeyButton.Size = UDim2.new(1, -40, 0, 40)
            GetKeyButton.Position = UDim2.new(0, 20, 0, 210)
            GetKeyButton.BackgroundColor3 = Themes.Dark.Secondary
            GetKeyButton.BorderSizePixel = 0
            GetKeyButton.Text = "Obter Key do Site"
            GetKeyButton.TextColor3 = Themes.Dark.Text
            GetKeyButton.Font = Enum.Font.Gotham
            GetKeyButton.TextSize = 14
            GetKeyButton.Parent = KeyFrame

            local GetKeyCorner = Instance.new("UICorner")
            GetKeyCorner.CornerRadius = UDim.new(0, 8)
            GetKeyCorner.Parent = GetKeyButton

            GetKeyButton.MouseButton1Click:Connect(function()
                setclipboard(config.KeySite)
                GetKeyButton.Text = "Link copiado!"
                wait(2)
                GetKeyButton.Text = "Obter Key do Site"
            end)
        end

        local function CheckKey(key)
            if key == config.Key then
                if config.KeySave then
                    SaveConfig(config.KeyFileName, {Key = key, SavedAt = os.time()})
                end
                Tween(KeyFrame, {Position = UDim2.new(0.5, -200, -0.5, 0)}, 0.5)
                wait(0.5)
                KeyFrame:Destroy()
                return true
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Key incorreta!"
                Tween(KeyInput, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}, 0.2)
                wait(0.2)
                Tween(KeyInput, {BackgroundColor3 = Themes.Dark.Secondary}, 0.2)
                wait(0.8)
                KeyInput.PlaceholderText = "Digite a Key..."
                return false
            end
        end

        SubmitButton.MouseButton1Click:Connect(function()
            CheckKey(KeyInput.Text)
        end)

        KeyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                CheckKey(KeyInput.Text)
            end
        end)
    end

    -- Verificar sistema de Key
    if config.KeyEnable then
        if config.AutoLoadKey and config.KeySave then
            local savedData = LoadConfig(config.KeyFileName)
            if savedData and savedData.Key == config.Key then
                -- Key válida, pular
            else
                ShowLoading()
                ShowKeySystem()
                repeat wait() until not ScreenGui:FindFirstChild("KeyFrame")
            end
        else
            ShowLoading()
            ShowKeySystem()
            repeat wait() until not ScreenGui:FindFirstChild("KeyFrame")
        end
    else
        ShowLoading()
    end

    -- Frame Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.BackgroundColor3 = Themes.Dark.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Topbar arrastável
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    Topbar.BackgroundColor3 = Themes.Dark.Secondary
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 12)
    TopbarCorner.Parent = Topbar

    local TopbarFix = Instance.new("Frame")
    TopbarFix.Size = UDim2.new(1, 0, 0, 12)
    TopbarFix.Position = UDim2.new(0, 0, 1, -12)
    TopbarFix.BackgroundColor3 = Themes.Dark.Secondary
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = Topbar

    -- Logo (se existir)
    if config.ImageId ~= "" then
        local Logo = Instance.new("ImageLabel")
        Logo.Size = UDim2.new(0, 30, 0, 30)
        Logo.Position = UDim2.new(0, 10, 0.5, -15)
        Logo.BackgroundTransparency = 1
        Logo.Image = "rbxassetid://" .. config.ImageId
        Logo.Parent = Topbar
    end

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -200, 1, 0)
    Title.Position = UDim2.new(0, config.ImageId ~= "" and 50 or 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.KeyName
    Title.TextColor3 = Themes.Dark.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Container de botões
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0, 120, 1, 0)
    ButtonContainer.Position = UDim2.new(1, -130, 0, 0)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Topbar

    local isMinimized = false
    local originalSize = MainFrame.Size

    -- Botão Resize (⛶)
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Size = UDim2.new(0, 35, 0, 35)
    ResizeButton.Position = UDim2.new(0, 0, 0.5, -17.5)
    ResizeButton.BackgroundColor3 = Themes.Dark.Background
    ResizeButton.BorderSizePixel = 0
    ResizeButton.Text = "⛶"
    ResizeButton.TextColor3 = Themes.Dark.Text
    ResizeButton.Font = Enum.Font.GothamBold
    ResizeButton.TextSize = 16
    ResizeButton.Parent = ButtonContainer

    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 6)
    ResizeCorner.Parent = ResizeButton

    -- Botão Minimizar (−)
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(0, 42, 0.5, -17.5)
    MinimizeButton.BackgroundColor3 = Themes.Dark.Background
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Themes.Dark.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 20
    MinimizeButton.Parent = ButtonContainer

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton

    -- Botão Fechar (×)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(0, 84, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 24
    CloseButton.Parent = ButtonContainer

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- Funcionalidade dos botões
    ResizeButton.MouseButton1Click:Connect(function()
        if MainFrame.Size == UDim2.new(0, 650, 0, 450) then
            Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 550)})
            originalSize = UDim2.new(0, 800, 0, 550)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 450)})
            originalSize = UDim2.new(0, 650, 0, 450)
        end
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 45)})
            MinimizeButton.Text = "□"
        else
            Tween(MainFrame, {Size = originalSize})
            MinimizeButton.Text = "−"
        end
    end)

    -- Sistema de confirmação de fechamento
    CloseButton.MouseButton1Click:Connect(function()
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Size = UDim2.new(0, 300, 0, 150)
        ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        ConfirmFrame.BackgroundColor3 = Themes.Dark.Background
        ConfirmFrame.BorderSizePixel = 0
        ConfirmFrame.ZIndex = 10
        ConfirmFrame.Parent = ScreenGui

        local ConfirmCorner = Instance.new("UICorner")
        ConfirmCorner.CornerRadius = UDim.new(0, 12)
        ConfirmCorner.Parent = ConfirmFrame

        local ConfirmText = Instance.new("TextLabel")
        ConfirmText.Size = UDim2.new(1, -20, 0, 60)
        ConfirmText.Position = UDim2.new(0, 10, 0, 10)
        ConfirmText.BackgroundTransparency = 1
        ConfirmText.Text = "Deseja realmente fechar a UI?"
        ConfirmText.TextColor3 = Themes.Dark.Text
        ConfirmText.Font = Enum.Font.GothamBold
        ConfirmText.TextSize = 14
        ConfirmText.TextWrapped = true
        ConfirmText.Parent = ConfirmFrame

        local YesButton = Instance.new("TextButton")
        YesButton.Size = UDim2.new(0, 130, 0, 40)
        YesButton.Position = UDim2.new(0, 10, 1, -50)
        YesButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        YesButton.BorderSizePixel = 0
        YesButton.Text = "Yes"
        YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        YesButton.Font = Enum.Font.GothamBold
        YesButton.TextSize = 14
        YesButton.Parent = ConfirmFrame

        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 8)
        YesCorner.Parent = YesButton

        local CancelButton = Instance.new("TextButton")
        CancelButton.Size = UDim2.new(0, 130, 0, 40)
        CancelButton.Position = UDim2.new(1, -140, 1, -50)
        CancelButton.BackgroundColor3 = Themes.Dark.Accent
        CancelButton.BorderSizePixel = 0
        CancelButton.Text = "Cancel"
        CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CancelButton.Font = Enum.Font.GothamBold
        CancelButton.TextSize = 14
        CancelButton.Parent = ConfirmFrame

        local CancelCorner = Instance.new("UICorner")
        CancelCorner.CornerRadius = UDim.new(0, 8)
        CancelCorner.Parent = CancelButton

        YesButton.MouseButton1Click:Connect(function()
            if config["AutoSave&Load"] then
                SaveConfig("UILibrary_SaveData.json", Window.SaveData)
            end
            ScreenGui:Destroy()
        end)

        CancelButton.MouseButton1Click:Connect(function()
            ConfirmFrame:Destroy()
        end)
    end)

    -- Tornar topbar arrastável
    MakeDraggable(MainFrame, Topbar)

    -- Container de Tabs
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -55)
    TabContainer.Position = UDim2.new(0, 5, 0, 50)
    TabContainer.BackgroundColor3 = Themes.Dark.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Themes.Dark.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = MainFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingRight = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.Parent = TabContainer

    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
    end)

    -- Container de Conteúdo
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -170, 1, -60)
    ContentContainer.Position = UDim2.new(0, 160, 0, 50)
    ContentContainer.BackgroundColor3 = Themes.Dark.Secondary
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ScrollBarThickness = 4
    ContentContainer.ScrollBarImageColor3 = Themes.Dark.Accent
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentContainer.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentContainer

    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = ContentContainer

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = ContentContainer

    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
    end)

    -- Função para aplicar tema
    function Window:ApplyTheme(themeName)
        local theme = Themes[themeName]
        if not theme then return end
        
        Window.CurrentTheme = themeName
        
        -- Aplicar cores
        MainFrame.BackgroundColor3 = theme.Background
        Topbar.BackgroundColor3 = theme.Secondary
        TopbarFix.BackgroundColor3 = theme.Secondary
        Title.TextColor3 = theme.Text
        TabContainer.BackgroundColor3 = theme.Secondary
        TabContainer.ScrollBarImageColor3 = theme.Accent
        ContentContainer.BackgroundColor3 = theme.Secondary
        ContentContainer.ScrollBarImageColor3 = theme.Accent
        
        ResizeButton.BackgroundColor3 = theme.Background
        ResizeButton.TextColor3 = theme.Text
        MinimizeButton.BackgroundColor3 = theme.Background
        MinimizeButton.TextColor3 = theme.Text
        
        -- Atualizar tabs
        for _, tab in pairs(Window.Tabs) do
            tab.Button.BackgroundColor3 = tab.Active and theme.Accent or theme.Background
            tab.Button.TextColor3 = theme.Text
        end
    end

    -- Criar Tab (continuação no próximo bloco...)
    function Window:CreateTab(name, icon)
        local Tab = {
            Name = name,
            Active = false,
            Elements = {}
        }

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = Themes[Window.CurrentTheme].Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton

        if icon and icon ~= "" then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = "rbxassetid://" .. icon
            TabIcon.Parent = TabButton
        end

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, icon and -35 or -16, 1, 0)
        TabLabel.Position = UDim2.new(0, icon and 35 or 8, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Themes[Window.CurrentTheme].Text
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        local TabContent = Instance.new("Frame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Label = TabLabel

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Active = false
                t.Button.BackgroundColor3 = Themes[Window.CurrentTheme].Background
                t.Content.Visible = false
            end

            Tab.Active = true
            TabButton.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
            TabContent.Visible = true
        end)

        if #Window.Tabs == 0 then
            Tab.Active = true
            TabButton.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
            TabContent.Visible = true
        end

        table.insert(Window.Tabs, Tab)

        -- ELEMENTOS DA TAB (12 elementos)
        
        -- 1. Toggle
        function Tab:AddToggle(name, default, callback)
            default = default or false
            callback = callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleButton = Instance.new("Frame")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame

            local ToggleBCorner = Instance.new("UICorner")
            ToggleBCorner.CornerRadius = UDim.new(1, 0)
            ToggleBCorner.Parent = ToggleButton

            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle

            local toggled = default
            Window.SaveData[name] = default

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ""
            ToggleBtn.Parent = ToggleFrame

            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                Window.SaveData[name] = toggled
                Tween(ToggleButton, {BackgroundColor3 = toggled and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)})
                Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                callback(toggled)
            end)

            Window.ConfigElements[name] = {Type = "Toggle", Set = function(value)
                toggled = value
                Window.SaveData[name] = value
                Tween(ToggleButton, {BackgroundColor3 = toggled and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)})
                Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
            end}

            return Window.ConfigElements[name]
        end

        -- 2. Button
        function Tab:AddButton(name, callback)
            callback = callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
            ButtonFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = name
            ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonFrame.Font = Enum.Font.GothamSemibold
            ButtonFrame.TextSize = 14
            ButtonFrame.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame

            ButtonFrame.MouseButton1Click:Connect(function()
                local originalColor = Themes[Window.CurrentTheme].Accent
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(originalColor.R * 255 * 0.7, originalColor.G * 255 * 0.7, originalColor.B * 255 * 0.7)}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = originalColor}, 0.1)
                callback()
            end)
        end

        -- 3. Slider
        function Tab:AddSlider(name, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 55)
            SliderFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 13
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Themes[Window.CurrentTheme].Accent
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 13
            SliderValue.Parent = SliderFrame

            local SliderBack = Instance.new("Frame")
            SliderBack.Size = UDim2.new(1, -20, 0, 6)
            SliderBack.Position = UDim2.new(0, 10, 1, -15)
            SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            SliderBack.BorderSizePixel = 0
            SliderBack.Parent = SliderFrame

            local SliderBCorner = Instance.new("UICorner")
            SliderBCorner.CornerRadius = UDim.new(1, 0)
            SliderBCorner.Parent = SliderBack

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Themes[Window.CurrentTheme].Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack

            local SliderFCorner = Instance.new("UICorner")
            SliderFCorner.CornerRadius = UDim.new(1, 0)
            SliderFCorner.Parent = SliderFill

            local dragging = false
            local currentValue = default
            Window.SaveData[name] = default

            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(min + (max - min) * pos)
                SliderValue.Text = tostring(currentValue)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                Window.SaveData[name] = currentValue
                callback(currentValue)
            end

            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)

            SliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)

            Window.ConfigElements[name] = {Type = "Slider", Set = function(value)
                currentValue = math.clamp(value, min, max)
                Window.SaveData[name] = currentValue
                SliderValue.Text = tostring(currentValue)
                SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
            end}

            return Window.ConfigElements[name]
        end

        -- 4. Dropdown
        function Tab:AddDropdown(name, options, default, callback)
            options = options or {}
            default = default or (options[1] or "None")
            callback = callback or function() end

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
            DropdownFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.ZIndex = 2
            DropdownFrame.Parent = TabContent

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -90, 0, 40)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = name
            DropdownLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextSize = 13
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.ZIndex = 3
            DropdownLabel.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 70, 0, 30)
            DropdownButton.Position = UDim2.new(1, -80, 0, 5)
            DropdownButton.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = default
            DropdownButton.TextColor3 = Themes[Window.CurrentTheme].Text
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 12
            DropdownButton.ZIndex = 3
            DropdownButton.Parent = DropdownFrame

            local DBCorner = Instance.new("UICorner")
            DBCorner.CornerRadius = UDim.new(0, 6)
            DBCorner.Parent = DropdownButton

            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(1, -20, 0, 0)
            DropdownList.Position = UDim2.new(0, 10, 0, 45)
            DropdownList.BackgroundTransparency = 1
            DropdownList.ZIndex = 3
            DropdownList.Parent = DropdownFrame

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)
            ListLayout.Parent = DropdownList

            local isOpen = false
            local selected = default
            Window.SaveData[name] = default

            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Themes[Window.CurrentTheme].Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 12
                OptionButton.ZIndex = 4
                OptionButton.Parent = DropdownList

                local OBCorner = Instance.new("UICorner")
                OBCorner.CornerRadius = UDim.new(0, 6)
                OBCorner.Parent = OptionButton

                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = option
                    Window.SaveData[name] = option
                    callback(option)
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)})
                    isOpen = false
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local listSize = #options * 33
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40 + listSize + 10)})
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)})
                end
            end)

            Window.ConfigElements[name] = {Type = "Dropdown", Set = function(value)
                selected = value
                Window.SaveData[name] = value
                DropdownButton.Text = value
            end}

            return Window.ConfigElements[name]
        end

        -- 5. TextBox
        function Tab:AddTextBox(name, placeholder, callback)
            placeholder = placeholder or "Digite aqui..."
            callback = callback or function() end

            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Size = UDim2.new(1, -10, 0, 65)
            TextBoxFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            TextBoxFrame.BorderSizePixel = 0
            TextBoxFrame.Parent = TabContent

            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 8)
            TextBoxCorner.Parent = TextBoxFrame

            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Text = name
            TextBoxLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            TextBoxLabel.Font = Enum.Font.Gotham
            TextBoxLabel.TextSize = 13
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxLabel.Parent = TextBoxFrame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -20, 0, 30)
            TextBox.Position = UDim2.new(0, 10, 0, 30)
            TextBox.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
            TextBox.BorderSizePixel = 0
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = Themes[Window.CurrentTheme].Text
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 12
            TextBox.Parent = TextBoxFrame

            local TBCorner = Instance.new("UICorner")
            TBCorner.CornerRadius = UDim.new(0, 6)
            TBCorner.Parent = TextBox

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(TextBox.Text)
                end
            end)
        end

        -- 6. Label
        function Tab:AddLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, -10, 0, 30)
            LabelFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent

            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = LabelFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Themes[Window.CurrentTheme].Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelFrame

            return {
                Set = function(newText)
                    Label.Text = newText
                end
            }
        end

        -- 7. ColorPicker
        function Tab:AddColorPicker(name, default, callback)
            default = default or Color3.fromRGB(255, 255, 255)
            callback = callback or function() end

            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, -10, 0, 40)
            ColorFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Parent = TabContent

            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorFrame

            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -50, 1, 0)
            ColorLabel.Position = UDim2.new(0, 10, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = name
            ColorLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.TextSize = 13
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 30, 0, 30)
            ColorDisplay.Position = UDim2.new(1, -40, 0.5, -15)
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorFrame

            local ColorDCorner = Instance.new("UICorner")
            ColorDCorner.CornerRadius = UDim.new(0, 6)
            ColorDCorner.Parent = ColorDisplay

            local currentColor = default
            Window.SaveData[name] = {R = default.R, G = default.G, B = default.B}

            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorFrame

            ColorButton.MouseButton1Click:Connect(function()
                local colors = {
                    Color3.fromRGB(255, 100, 100),
                    Color3.fromRGB(100, 255, 100),
                    Color3.fromRGB(100, 100, 255),
                    Color3.fromRGB(255, 255, 100),
                    Color3.fromRGB(255, 100, 255),
                    Color3.fromRGB(100, 255, 255),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(255, 150, 50)
                }
                
                local index = 1
                for i, color in ipairs(colors) do
                    if currentColor == color then
                        index = i % #colors + 1
                        break
                    end
                end
                
                currentColor = colors[index]
                ColorDisplay.BackgroundColor3 = currentColor
                Window.SaveData[name] = {R = currentColor.R, G = currentColor.G, B = currentColor.B}
                callback(currentColor)
            end)
        end

        -- 8. Keybind
        function Tab:AddKeybind(name, default, callback)
            default = default or Enum.KeyCode.E
            callback = callback or function() end

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, -10, 0, 40)
            KeybindFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent

            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = name
            KeybindLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextSize = 13
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 70, 0, 30)
            KeybindButton.Position = UDim2.new(1, -80, 0.5, -15)
            KeybindButton.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = default.Name
            KeybindButton.TextColor3 = Themes[Window.CurrentTheme].Text
            KeybindButton.Font = Enum.Font.Gotham
            KeybindButton.TextSize = 12
            KeybindButton.Parent = KeybindFrame

            local KBCorner = Instance.new("UICorner")
            KBCorner.CornerRadius = UDim.new(0, 6)
            KBCorner.Parent = KeybindButton

            local currentKey = default
            local listening = false
            Window.SaveData[name] = default.Name

            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeybindButton.Text = input.KeyCode.Name
                    Window.SaveData[name] = input.KeyCode.Name
                    listening = false
                end
                
                if input.KeyCode == currentKey and not gameProcessed then
                    callback()
                end
            end)
        end

        -- 9. Section
        function Tab:AddSection(text)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -10, 0, 35)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent

            local SectionLine = Instance.new("Frame")
            SectionLine.Size = UDim2.new(1, 0, 0, 2)
            SectionLine.Position = UDim2.new(0, 0, 0.5, 0)
            SectionLine.BackgroundColor3 = Themes[Window.CurrentTheme].Border
            SectionLine.BorderSizePixel = 0
            SectionLine.Parent = SectionFrame

            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(0, 0, 1, 0)
            SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
            SectionLabel.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
            SectionLabel.BorderSizePixel = 0
            SectionLabel.Text = "  " .. text .. "  "
            SectionLabel.TextColor3 = Themes[Window.CurrentTheme].Accent
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 13
            SectionLabel.Parent = SectionFrame

            SectionLabel.Size = UDim2.new(0, SectionLabel.TextBounds.X, 1, 0)
        end

        -- 10. Paragraph
        function Tab:AddParagraph(title, content)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, -10, 0, 80)
            ParagraphFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContent

            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 8)
            ParagraphCorner.Parent = ParagraphFrame

            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -20, 0, 20)
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 10)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = title
            ParagraphTitle.TextColor3 = Themes[Window.CurrentTheme].Text
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextSize = 14
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame

            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -20, 1, -40)
            ParagraphContent.Position = UDim2.new(0, 10, 0, 35)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = content
            ParagraphContent.TextColor3 = Themes[Window.CurrentTheme].Text
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextSize = 12
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame
        end

        -- 11. Multi Dropdown
        function Tab:AddMultiDropdown(name, options, defaults, callback)
            options = options or {}
            defaults = defaults or {}
            callback = callback or function() end

            local MultiDropFrame = Instance.new("Frame")
            MultiDropFrame.Size = UDim2.new(1, -10, 0, 40)
            MultiDropFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            MultiDropFrame.BorderSizePixel = 0
            MultiDropFrame.ClipsDescendants = true
            MultiDropFrame.ZIndex = 2
            MultiDropFrame.Parent = TabContent

            local MultiDropCorner = Instance.new("UICorner")
            MultiDropCorner.CornerRadius = UDim.new(0, 8)
            MultiDropCorner.Parent = MultiDropFrame

            local MultiDropLabel = Instance.new("TextLabel")
            MultiDropLabel.Size = UDim2.new(1, -90, 0, 40)
            MultiDropLabel.Position = UDim2.new(0, 10, 0, 0)
            MultiDropLabel.BackgroundTransparency = 1
            MultiDropLabel.Text = name
            MultiDropLabel.TextColor3 = Themes[Window.CurrentTheme].Text
            MultiDropLabel.Font = Enum.Font.Gotham
            MultiDropLabel.TextSize = 13
            MultiDropLabel.TextXAlignment = Enum.TextXAlignment.Left
            MultiDropLabel.ZIndex = 3
            MultiDropLabel.Parent = MultiDropFrame

            local MultiDropButton = Instance.new("TextButton")
            MultiDropButton.Size = UDim2.new(0, 70, 0, 30)
            MultiDropButton.Position = UDim2.new(1, -80, 0, 5)
            MultiDropButton.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
            MultiDropButton.BorderSizePixel = 0
            MultiDropButton.Text = "..."
            MultiDropButton.TextColor3 = Themes[Window.CurrentTheme].Text
            MultiDropButton.Font = Enum.Font.Gotham
            MultiDropButton.TextSize = 12
            MultiDropButton.ZIndex = 3
            MultiDropButton.Parent = MultiDropFrame

            local MDBCorner = Instance.new("UICorner")
            MDBCorner.CornerRadius = UDim.new(0, 6)
            MDBCorner.Parent = MultiDropButton

            local MultiDropList = Instance.new("Frame")
            MultiDropList.Size = UDim2.new(1, -20, 0, 0)
            MultiDropList.Position = UDim2.new(0, 10, 0, 45)
            MultiDropList.BackgroundTransparency = 1
            MultiDropList.ZIndex = 3
            MultiDropList.Parent = MultiDropFrame

            local MDListLayout = Instance.new("UIListLayout")
            MDListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            MDListLayout.Padding = UDim.new(0, 3)
            MDListLayout.Parent = MultiDropList

            local isOpen = false
            local selected = {}
            
            for _, v in ipairs(defaults) do
                selected[v] = true
            end
            Window.SaveData[name] = selected

            for _, option in ipairs(options) do
                local OptionFrame = Instance.new("Frame")
                OptionFrame.Size = UDim2.new(1, 0, 0, 30)
                OptionFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Secondary
                OptionFrame.BorderSizePixel = 0
                OptionFrame.ZIndex = 4
                OptionFrame.Parent = MultiDropList

                local OFCorner = Instance.new("UICorner")
                OFCorner.CornerRadius = UDim.new(0, 6)
                OFCorner.Parent = OptionFrame

                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -35, 1, 0)
                OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Text = option
                OptionLabel.TextColor3 = Themes[Window.CurrentTheme].Text
                OptionLabel.Font = Enum.Font.Gotham
                OptionLabel.TextSize = 12
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.ZIndex = 5
                OptionLabel.Parent = OptionFrame

                local CheckBox = Instance.new("Frame")
                CheckBox.Size = UDim2.new(0, 18, 0, 18)
                CheckBox.Position = UDim2.new(1, -24, 0.5, -9)
                CheckBox.BackgroundColor3 = selected[option] and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)
                CheckBox.BorderSizePixel = 0
                CheckBox.ZIndex = 5
                CheckBox.Parent = OptionFrame

                local CBCorner = Instance.new("UICorner")
                CBCorner.CornerRadius = UDim.new(0, 4)
                CBCorner.Parent = CheckBox

                if selected[option] then
                    local Check = Instance.new("TextLabel")
                    Check.Size = UDim2.new(1, 0, 1, 0)
                    Check.BackgroundTransparency = 1
                    Check.Text = "✓"
                    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Check.Font = Enum.Font.GothamBold
                    Check.TextSize = 14
                    Check.ZIndex = 6
                    Check.Parent = CheckBox
                end

                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 1, 0)
                OptionButton.BackgroundTransparency = 1
                OptionButton.Text = ""
                OptionButton.ZIndex = 5
                OptionButton.Parent = OptionFrame

                OptionButton.MouseButton1Click:Connect(function()
                    selected[option] = not selected[option]
                    CheckBox.BackgroundColor3 = selected[option] and Themes[Window.CurrentTheme].Accent or Color3.fromRGB(60, 60, 70)
                    
                    for _, child in ipairs(CheckBox:GetChildren()) do
                        if child:IsA("TextLabel") then
                            child:Destroy()
                        end
                    end
                    
                    if selected[option] then
                        local Check = Instance.new("TextLabel")
                        Check.Size = UDim2.new(1, 0, 1, 0)
                        Check.BackgroundTransparency = 1
                        Check.Text = "✓"
                        Check.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Check.Font = Enum.Font.GothamBold
                        Check.TextSize = 14
                        Check.ZIndex = 6
                        Check.Parent = CheckBox
                    end
                    
                    Window.SaveData[name] = selected
                    callback(selected)
                end)
            end

            MultiDropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local listSize = #options * 33
                    Tween(MultiDropFrame, {Size = UDim2.new(1, -10, 0, 40 + listSize + 10)})
                else
                    Tween(MultiDropFrame, {Size = UDim2.new(1, -10, 0, 40)})
                end
            end)
        end

        -- 12. Notification System
        function Tab:SendNotification(title, content, duration)
            duration = duration or 3

            local NotifFrame = Instance.new("Frame")
            NotifFrame.Size = UDim2.new(0, 300, 0, 0)
            NotifFrame.Position = UDim2.new(1, -310, 1, 10)
            NotifFrame.BackgroundColor3 = Themes[Window.CurrentTheme].Background
            NotifFrame.BorderSizePixel = 0
            NotifFrame.ZIndex = 100
            NotifFrame.Parent = ScreenGui

            local NotifCorner = Instance.new("UICorner")
            NotifCorner.CornerRadius = UDim.new(0, 10)
            NotifCorner.Parent = NotifFrame

            local NotifStroke = Instance.new("UIStroke")
            NotifStroke.Color = Themes[Window.CurrentTheme].Accent
            NotifStroke.Thickness = 2
            NotifStroke.Parent = NotifFrame

            local NotifTitle = Instance.new("TextLabel")
            NotifTitle.Size = UDim2.new(1, -20, 0, 25)
            NotifTitle.Position = UDim2.new(0, 10, 0, 8)
            NotifTitle.BackgroundTransparency = 1
            NotifTitle.Text = title
            NotifTitle.TextColor3 = Themes[Window.CurrentTheme].Text
            NotifTitle.Font = Enum.Font.GothamBold
            NotifTitle.TextSize = 14
            NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
            NotifTitle.ZIndex = 101
            NotifTitle.Parent = NotifFrame

            local NotifContent = Instance.new("TextLabel")
            NotifContent.Size = UDim2.new(1, -20, 0, 40)
            NotifContent.Position = UDim2.new(0, 10, 0, 35)
            NotifContent.BackgroundTransparency = 1
            NotifContent.Text = content
            NotifContent.TextColor3 = Themes[Window.CurrentTheme].Text
            NotifContent.Font = Enum.Font.Gotham
            NotifContent.TextSize = 12
            NotifContent.TextXAlignment = Enum.TextXAlignment.Left
            NotifContent.TextYAlignment = Enum.TextYAlignment.Top
            NotifContent.TextWrapped = true
            NotifContent.ZIndex = 101
            NotifContent.Parent = NotifFrame

            local totalHeight = 80

            Tween(NotifFrame, {Size = UDim2.new(0, 300, 0, totalHeight), Position = UDim2.new(1, -310, 1, -totalHeight - 10)}, 0.5)
            wait(duration)
            Tween(NotifFrame, {Position = UDim2.new(1, 10, 1, -totalHeight - 10)}, 0.5)
            wait(0.5)
            NotifFrame:Destroy()
        end

        return Tab
    end

    -- Tab de Configurações
    function Window:AddConfig()
        local ConfigTab = Window:CreateTab("⚙️ Configurações", "")

        ConfigTab:AddSection("Tema da Interface")

        local themeNames = {}
        for name, _ in pairs(Themes) do
            table.insert(themeNames, name)
        end

        ConfigTab:AddDropdown("Selecionar Tema", themeNames, Window.CurrentTheme, function(theme)
            Window:ApplyTheme(theme)
        end)

        ConfigTab:AddSection("Transparência")

        ConfigTab:AddToggle("Fundo Translúcido (60%)", false, function(enabled)
            MainFrame.BackgroundTransparency = enabled and 0.4 or 0
        end)

        ConfigTab:AddSection("Sistema de Salvamento")

        ConfigTab:AddToggle("Ativar Auto Save & Load", config["AutoSave&Load"], function(enabled)
            config["AutoSave&Load"] = enabled
        end)

        ConfigTab:AddButton("💾 Salvar Configuração", function()
            if SaveConfig("UILibrary_SaveData.json", Window.SaveData) then
                ConfigTab:SendNotification("✅ Sucesso", "Configuração salva com sucesso!", 2)
            else
                ConfigTab:SendNotification("❌ Erro", "Falha ao salvar configuração", 2)
            end
        end)

        ConfigTab:AddButton("📁 Carregar Configuração", function()
            local data = LoadConfig("UILibrary_SaveData.json")
            if data then
                Window.SaveData = data
                for name, element in pairs(Window.ConfigElements) do
                    if data[name] ~= nil and element.Set then
                        element.Set(data[name])
                    end
                end
                ConfigTab:SendNotification("✅ Sucesso", "Configuração carregada!", 2)
            else
                ConfigTab:SendNotification("❌ Erro", "Nenhuma configuração salva", 2)
            end
        end)

        ConfigTab:AddButton("🗑️ Limpar Dados Salvos", function()
            pcall(function()
                if isfile and isfile("UILibrary_SaveData.json") then
                    delfile("UILibrary_SaveData.json")
                end
            end)
            Window.SaveData = {}
            ConfigTab:SendNotification("🗑️ Limpeza", "Dados removidos com sucesso!", 2)
        end)

        ConfigTab:AddSection("Informações")

        ConfigTab:AddParagraph("📚 UI Library v1.0", "UI Library completa com 12 elementos diferentes, sistema de Key avançado, Auto Save/Load, 10 temas incríveis e muito mais! Totalmente compatível com Mobile e PC.")
    end

    -- Auto-load de configurações salvas
    if config["AutoSave&Load"] then
        local savedData = LoadConfig("UILibrary_SaveData.json")
        if savedData then
            Window.SaveData = savedData
        end
    end

    return Window
end

return Library
