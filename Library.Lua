--[[
    ╔═══════════════════════════════════════════════════╗
    ║          MODERN ROBLOX UI LIBRARY V2.0            ║
    ║              Mobile-First Design                  ║
    ╚═══════════════════════════════════════════════════╝
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utilitários
local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function RippleEffect(button, X, Y)
    local Ripple = Instance.new("ImageLabel")
    Ripple.Name = "Ripple"
    Ripple.Parent = button
    Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Ripple.BackgroundTransparency = 0.6
    Ripple.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Ripple.ImageTransparency = 0.6
    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    Ripple.Position = UDim2.new(0, X, 0, Y)
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.ZIndex = button.ZIndex + 1
    
    local TweenSize = TweenService:Create(Ripple, TweenInfo.new(0.5), {Size = UDim2.new(2, 0, 2, 0), ImageTransparency = 1})
    TweenSize:Play()
    TweenSize.Completed:Connect(function()
        Ripple:Destroy()
    end)
end

-- Temas
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 38),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 190),
        Border = Color3.fromRGB(50, 50, 60)
    },
    Neon = {
        Primary = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(18, 18, 25),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 255, 255),
        Border = Color3.fromRGB(0, 200, 200)
    },
    Ocean = {
        Primary = Color3.fromRGB(15, 32, 48),
        Secondary = Color3.fromRGB(25, 48, 68),
        Accent = Color3.fromRGB(52, 152, 219),
        Text = Color3.fromRGB(236, 240, 241),
        SubText = Color3.fromRGB(149, 165, 166),
        Border = Color3.fromRGB(41, 128, 185)
    },
    Sunset = {
        Primary = Color3.fromRGB(44, 22, 45),
        Secondary = Color3.fromRGB(60, 32, 62),
        Accent = Color3.fromRGB(255, 107, 107),
        Text = Color3.fromRGB(255, 250, 240),
        SubText = Color3.fromRGB(255, 180, 162),
        Border = Color3.fromRGB(255, 140, 105)
    },
    Forest = {
        Primary = Color3.fromRGB(22, 32, 26),
        Secondary = Color3.fromRGB(32, 46, 36),
        Accent = Color3.fromRGB(76, 175, 80),
        Text = Color3.fromRGB(232, 245, 233),
        SubText = Color3.fromRGB(165, 214, 167),
        Border = Color3.fromRGB(56, 142, 60)
    },
    Royal = {
        Primary = Color3.fromRGB(25, 20, 40),
        Secondary = Color3.fromRGB(40, 32, 60),
        Accent = Color3.fromRGB(186, 104, 200),
        Text = Color3.fromRGB(255, 245, 250),
        SubText = Color3.fromRGB(225, 190, 231),
        Border = Color3.fromRGB(156, 39, 176)
    },
    Cherry = {
        Primary = Color3.fromRGB(40, 20, 25),
        Secondary = Color3.fromRGB(55, 28, 35),
        Accent = Color3.fromRGB(244, 67, 54),
        Text = Color3.fromRGB(255, 235, 238),
        SubText = Color3.fromRGB(255, 205, 210),
        Border = Color3.fromRGB(229, 57, 53)
    },
    Midnight = {
        Primary = Color3.fromRGB(12, 15, 25),
        Secondary = Color3.fromRGB(20, 25, 38),
        Accent = Color3.fromRGB(79, 195, 247),
        Text = Color3.fromRGB(245, 250, 255),
        SubText = Color3.fromRGB(176, 190, 197),
        Border = Color3.fromRGB(33, 150, 243)
    },
    Amber = {
        Primary = Color3.fromRGB(38, 28, 18),
        Secondary = Color3.fromRGB(50, 38, 25),
        Accent = Color3.fromRGB(255, 193, 7),
        Text = Color3.fromRGB(255, 248, 225),
        SubText = Color3.fromRGB(255, 236, 179),
        Border = Color3.fromRGB(255, 160, 0)
    },
    Crimson = {
        Primary = Color3.fromRGB(30, 15, 18),
        Secondary = Color3.fromRGB(45, 22, 28),
        Accent = Color3.fromRGB(220, 53, 69),
        Text = Color3.fromRGB(255, 240, 245),
        SubText = Color3.fromRGB(255, 209, 220),
        Border = Color3.fromRGB(200, 35, 51)
    }
}

-- Sistema de Save/Load
local SaveSystem = {}
SaveSystem.ConfigFolder = "RobloxUILibrary"

function SaveSystem:Save(fileName, data)
    local success, err = pcall(function()
        writefile(self.ConfigFolder .. "/" .. fileName, HttpService:JSONEncode(data))
    end)
    return success
end

function SaveSystem:Load(fileName)
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(self.ConfigFolder .. "/" .. fileName))
    end)
    return success and result or nil
end

function SaveSystem:Exists(fileName)
    return pcall(function()
        return readfile(self.ConfigFolder .. "/" .. fileName)
    end)
end

function SaveSystem:Initialize()
    if not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
    end
end

SaveSystem:Initialize()

-- Criar Window
function Library:CreateWindow(config)
    local WindowConfig = {
        Name = config.Name or "UI Library",
        ImageId = config.ImageId or "",
        Theme = config.Theme or "Dark",
        KeyEnable = config.KeyEnable or false,
        Key = config.Key or "",
        KeyName = config.KeyName or "KeySystem",
        KeySave = config.KeySave or false,
        KeyFileName = config.KeyFileName or "Key.json",
        GetKeyFromSite = config.GetKeyFromSite or false,
        KeySite = config.KeySite or "",
        AutoLoadKey = config.AutoLoadKey or true,
        LoadingName = config.LoadingName or "Loading...",
        LoadingImageId = config.LoadingImageId or "",
        AutoSaveLoad = config.AutoSaveLoad or true,
        ConfigFileName = config.ConfigFileName or "Config.json"
    }

    local Window = {}
    Window.Tabs = {}
    Window.CurrentTheme = Themes[WindowConfig.Theme] or Themes.Dark
    Window.Elements = {}
    Window.Minimized = false
    Window.ConfigData = {}

    -- Criar ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Função de Loading
    local function ShowLoading()
        local LoadingFrame = Instance.new("Frame")
        LoadingFrame.Name = "LoadingFrame"
        LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
        LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
        LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        LoadingFrame.BackgroundTransparency = 0.3
        LoadingFrame.BorderSizePixel = 0
        LoadingFrame.ZIndex = 1000
        LoadingFrame.Parent = ScreenGui

        local LoadingContainer = Instance.new("Frame")
        LoadingContainer.Name = "Container"
        LoadingContainer.Size = UDim2.new(0, 300, 0, 200)
        LoadingContainer.Position = UDim2.new(0.5, -150, 0.5, -100)
        LoadingContainer.BackgroundColor3 = Window.CurrentTheme.Secondary
        LoadingContainer.BorderSizePixel = 0
        LoadingContainer.ZIndex = 1001
        LoadingContainer.Parent = LoadingFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = LoadingContainer

        if WindowConfig.LoadingImageId ~= "" then
            local LoadingImage = Instance.new("ImageLabel")
            LoadingImage.Size = UDim2.new(0, 80, 0, 80)
            LoadingImage.Position = UDim2.new(0.5, -40, 0, 30)
            LoadingImage.BackgroundTransparency = 1
            LoadingImage.Image = "rbxassetid://" .. WindowConfig.LoadingImageId
            LoadingImage.ZIndex = 1002
            LoadingImage.Parent = LoadingContainer
        end

        local LoadingText = Instance.new("TextLabel")
        LoadingText.Size = UDim2.new(1, -40, 0, 30)
        LoadingText.Position = UDim2.new(0, 20, 0, 120)
        LoadingText.BackgroundTransparency = 1
        LoadingText.Text = WindowConfig.LoadingName
        LoadingText.TextColor3 = Window.CurrentTheme.Text
        LoadingText.Font = Enum.Font.GothamBold
        LoadingText.TextSize = 18
        LoadingText.ZIndex = 1002
        LoadingText.Parent = LoadingContainer

        local LoadingBar = Instance.new("Frame")
        LoadingBar.Size = UDim2.new(0, 0, 0, 4)
        LoadingBar.Position = UDim2.new(0, 20, 0, 165)
        LoadingBar.BackgroundColor3 = Window.CurrentTheme.Accent
        LoadingBar.BorderSizePixel = 0
        LoadingBar.ZIndex = 1002
        LoadingBar.Parent = LoadingContainer

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0, 2)
        BarCorner.Parent = LoadingBar

        Tween(LoadingBar, {Size = UDim2.new(1, -40, 0, 4)}, 2)

        task.wait(2.5)
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.3)
        Tween(LoadingContainer, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        LoadingFrame:Destroy()
    end

    -- Sistema de Key
    local function ShowKeySystem()
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeyFrame"
        KeyFrame.Size = UDim2.new(1, 0, 1, 0)
        KeyFrame.Position = UDim2.new(0, 0, 0, 0)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        KeyFrame.BackgroundTransparency = 0.3
        KeyFrame.BorderSizePixel = 0
        KeyFrame.ZIndex = 1000
        KeyFrame.Parent = ScreenGui

        local KeyContainer = Instance.new("Frame")
        KeyContainer.Name = "Container"
        KeyContainer.Size = UDim2.new(0, 350, 0, 250)
        KeyContainer.Position = UDim2.new(0.5, -175, 0.5, -125)
        KeyContainer.BackgroundColor3 = Window.CurrentTheme.Secondary
        KeyContainer.BorderSizePixel = 0
        KeyContainer.ZIndex = 1001
        KeyContainer.Parent = KeyFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = KeyContainer

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, -40, 0, 40)
        KeyTitle.Position = UDim2.new(0, 20, 0, 20)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = WindowConfig.KeyName
        KeyTitle.TextColor3 = Window.CurrentTheme.Text
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.TextSize = 22
        KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
        KeyTitle.ZIndex = 1002
        KeyTitle.Parent = KeyContainer

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(1, -40, 0, 45)
        KeyInput.Position = UDim2.new(0, 20, 0, 80)
        KeyInput.BackgroundColor3 = Window.CurrentTheme.Primary
        KeyInput.BorderSizePixel = 0
        KeyInput.PlaceholderText = "Digite a Key..."
        KeyInput.PlaceholderColor3 = Window.CurrentTheme.SubText
        KeyInput.Text = ""
        KeyInput.TextColor3 = Window.CurrentTheme.Text
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextSize = 14
        KeyInput.ZIndex = 1002
        KeyInput.Parent = KeyContainer

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = KeyInput

        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(1, -40, 0, 45)
        SubmitButton.Position = UDim2.new(0, 20, 0, 145)
        SubmitButton.BackgroundColor3 = Window.CurrentTheme.Accent
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Text = "Verificar Key"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.TextSize = 16
        SubmitButton.ZIndex = 1002
        SubmitButton.Parent = KeyContainer

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = SubmitButton

        if WindowConfig.GetKeyFromSite and WindowConfig.KeySite ~= "" then
            local GetKeyButton = Instance.new("TextButton")
            GetKeyButton.Size = UDim2.new(1, -40, 0, 35)
            GetKeyButton.Position = UDim2.new(0, 20, 0, 205)
            GetKeyButton.BackgroundColor3 = Window.CurrentTheme.Border
            GetKeyButton.BorderSizePixel = 0
            GetKeyButton.Text = "Obter Key do Site"
            GetKeyButton.TextColor3 = Window.CurrentTheme.Text
            GetKeyButton.Font = Enum.Font.Gotham
            GetKeyButton.TextSize = 14
            GetKeyButton.ZIndex = 1002
            GetKeyButton.Parent = KeyContainer

            local GetKeyCorner = Instance.new("UICorner")
            GetKeyCorner.CornerRadius = UDim.new(0, 8)
            GetKeyCorner.Parent = GetKeyButton

            GetKeyButton.MouseButton1Click:Connect(function()
                setclipboard(WindowConfig.KeySite)
                GetKeyButton.Text = "Link Copiado!"
                task.wait(2)
                GetKeyButton.Text = "Obter Key do Site"
            end)
        end

        SubmitButton.MouseButton1Click:Connect(function()
            if KeyInput.Text == WindowConfig.Key then
                if WindowConfig.KeySave then
                    SaveSystem:Save(WindowConfig.KeyFileName, {Key = WindowConfig.Key})
                end
                Tween(KeyFrame, {BackgroundTransparency = 1}, 0.3)
                Tween(KeyContainer, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                KeyFrame:Destroy()
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Key Incorreta!"
                task.wait(1.5)
                KeyInput.PlaceholderText = "Digite a Key..."
            end
        end)
    end

    -- Verificar Key System
    if WindowConfig.KeyEnable then
        local keyValid = false
        
        if WindowConfig.AutoLoadKey and WindowConfig.KeySave then
            local savedKey = SaveSystem:Load(WindowConfig.KeyFileName)
            if savedKey and savedKey.Key == WindowConfig.Key then
                keyValid = true
            end
        end

        if not keyValid then
            ShowLoading()
            ShowKeySystem()
            repeat task.wait() until not ScreenGui:FindFirstChild("KeyFrame")
        else
            ShowLoading()
        end
    else
        ShowLoading()
    end

    -- Criar Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Window.CurrentTheme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.BackgroundColor3 = Window.CurrentTheme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 10)
    TopBarCorner.Parent = TopBar

    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Window.CurrentTheme.Secondary
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar

    -- Logo/Image
    if WindowConfig.ImageId ~= "" then
        local Logo = Instance.new("ImageLabel")
        Logo.Size = UDim2.new(0, 30, 0, 30)
        Logo.Position = UDim2.new(0, 10, 0.5, -15)
        Logo.BackgroundTransparency = 1
        Logo.Image = "rbxassetid://" .. WindowConfig.ImageId
        Logo.Parent = TopBar
    end

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, WindowConfig.ImageId ~= "" and 50 or 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowConfig.Name
    Title.TextColor3 = Window.CurrentTheme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Botões do TopBar
    local ButtonSize = UDim2.new(0, 35, 0, 35)
    local ButtonYPos = 0.5

    -- Botão Fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = ButtonSize
    CloseButton.Position = UDim2.new(1, -40, ButtonYPos, -17.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20
    CloseButton.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- Botão Minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = ButtonSize
    MinimizeButton.Position = UDim2.new(1, -80, ButtonYPos, -17.5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 16
    MinimizeButton.Parent = TopBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton

    -- Botão Resize
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Size = ButtonSize
    ResizeButton.Position = UDim2.new(1, -120, ButtonYPos, -17.5)
    ResizeButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    ResizeButton.BorderSizePixel = 0
    ResizeButton.Text = "⛶"
    ResizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResizeButton.Font = Enum.Font.GothamBold
    ResizeButton.TextSize = 16
    ResizeButton.Parent = TopBar

    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 6)
    ResizeCorner.Parent = ResizeButton

    -- Container de Tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -55)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundColor3 = Window.CurrentTheme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 8)
    TabContainerCorner.Parent = TabContainer

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = Window.CurrentTheme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Container de Conteúdo
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -165, 1, -55)
    ContentContainer.Position = UDim2.new(0, 155, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame

    -- Drag System
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Tween(MainFrame, {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }, 0.1)
    end

    TopBar.InputBegan:Connect(function(input)
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

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Minimize Function
    MinimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 45)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.3)
            MinimizeButton.Text = "─"
        end
    end)

    -- Resize Function
    local resized = false
    ResizeButton.MouseButton1Click:Connect(function()
        resized = not resized
        if resized then
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.3)
        end
    end)

    -- Close Function com Confirmação
    CloseButton.MouseButton1Click:Connect(function()
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Name = "ConfirmFrame"
        ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
        ConfirmFrame.Position = UDim2.new(0, 0, 0, 0)
        ConfirmFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ConfirmFrame.BackgroundTransparency = 0.5
        ConfirmFrame.BorderSizePixel = 0
        ConfirmFrame.ZIndex = 100
        ConfirmFrame.Parent = ScreenGui

        local ConfirmBox = Instance.new("Frame")
        ConfirmBox.Size = UDim2.new(0, 300, 0, 150)
        ConfirmBox.Position = UDim2.new(0.5, -150, 0.5, -75)
        ConfirmBox.BackgroundColor3 = Window.CurrentTheme.Secondary
        ConfirmBox.BorderSizePixel = 0
        ConfirmBox.ZIndex = 101
        ConfirmBox.Parent = ConfirmFrame

        local ConfirmCorner = Instance.new("UICorner")
        ConfirmCorner.CornerRadius = UDim.new(0, 10)
        ConfirmCorner.Parent = ConfirmBox

        local ConfirmText = Instance.new("TextLabel")
        ConfirmText.Size = UDim2.new(1, -40, 0, 60)
        ConfirmText.Position = UDim2.new(0, 20, 0, 20)
        ConfirmText.BackgroundTransparency = 1
        ConfirmText.Text = "Deseja realmente fechar a UI?"
        ConfirmText.TextColor3 = Window.CurrentTheme.Text
        ConfirmText.Font = Enum.Font.GothamBold
        ConfirmText.TextSize = 14
        ConfirmText.TextWrapped = true
        ConfirmText.ZIndex = 102
        ConfirmText.Parent = ConfirmBox

        local YesButton = Instance.new("TextButton")
        YesButton.Size = UDim2.new(0, 130, 0, 40)
        YesButton.Position = UDim2.new(0, 15, 1, -55)
        YesButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        YesButton.BorderSizePixel = 0
        YesButton.Text = "Sim"
        YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        YesButton.Font = Enum.Font.GothamBold
        YesButton.TextSize = 14
        YesButton.ZIndex = 102
        YesButton.Parent = ConfirmBox

        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 8)
        YesCorner.Parent = YesButton

        local NoButton = Instance.new("TextButton")
        NoButton.Size = UDim2.new(0, 130, 0, 40)
        NoButton.Position = UDim2.new(1, -145, 1, -55)
        NoButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        NoButton.BorderSizePixel = 0
        NoButton.Text = "Não"
        NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        NoButton.Font = Enum.Font.GothamBold
        NoButton.TextSize = 14
        NoButton.ZIndex = 102
        NoButton.Parent = ConfirmBox

        local NoCorner = Instance.new("UICorner")
        NoCorner.CornerRadius = UDim.new(0, 8)
        NoCorner.Parent = NoButton

        YesButton.MouseButton1Click:Connect(function()
            if WindowConfig.AutoSaveLoad then
                Window:SaveConfig()
            end
            ScreenGui:Destroy()
        end)

        NoButton.MouseButton1Click:Connect(function()
            ConfirmFrame:Destroy()
        end)
    end)

    -- Função para Criar Tab
    function Window:AddTab(name, imageId)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Window.CurrentTheme.Primary
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabList

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        if imageId and imageId ~= "" then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Size = UDim2.new(0, 24, 0, 24)
            TabIcon.Position = UDim2.new(0, 8, 0.5, -12)
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = "rbxassetid://" .. imageId
            TabIcon.ImageColor3 = Window.CurrentTheme.SubText
            TabIcon.Parent = TabButton
        end

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, imageId and -40 or -16, 1, 0)
        TabLabel.Position = UDim2.new(0, imageId and 36 or 8, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Window.CurrentTheme.SubText
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Window.CurrentTheme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabContent

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = Window.CurrentTheme.Primary
                tab.Label.TextColor3 = Window.CurrentTheme.SubText
                if tab.Icon then
                    tab.Icon.ImageColor3 = Window.CurrentTheme.SubText
                end
                tab.Content.Visible = false
            end

            TabButton.BackgroundColor3 = Window.CurrentTheme.Accent
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            if TabButton:FindFirstChildOfClass("ImageLabel") then
                TabButton:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            TabContent.Visible = true
        end)

        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Icon = TabButton:FindFirstChildOfClass("ImageLabel")
        Tab.Content = TabContent

        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Window.CurrentTheme.Accent
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            if Tab.Icon then
                Tab.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            TabContent.Visible = true
        end

        table.insert(Window.Tabs, Tab)

        -- Elementos da Tab

        -- 1. BUTTON
        function Tab:AddButton(config)
            local buttonConfig = {
                Name = config.Name or "Button",
                Callback = config.Callback or function() end
            }

            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 1, -10)
            Button.Position = UDim2.new(0, 5, 0, 5)
            Button.BackgroundTransparency = 1
            Button.Text = buttonConfig.Name
            Button.TextColor3 = Window.CurrentTheme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 14
            Button.Parent = ButtonFrame

            Button.MouseButton1Click:Connect(function()
                RippleEffect(ButtonFrame, Button.AbsolutePosition.X, Button.AbsolutePosition.Y)
                buttonConfig.Callback()
            end)

            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Window.CurrentTheme.Border}, 0.2)
            end)

            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Window.CurrentTheme.Secondary}, 0.2)
            end)

            return Button
        end

        -- 2. TOGGLE
        function Tab:AddToggle(config)
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleConfig.Name
            ToggleLabel.TextColor3 = Window.CurrentTheme.Text
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
            ToggleButton.BackgroundColor3 = toggleConfig.Default and Window.CurrentTheme.Accent or Window.CurrentTheme.Border
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame

            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
            ToggleIndicator.Position = toggleConfig.Default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator

            local toggled = toggleConfig.Default
            Window.ConfigData[toggleConfig.Name] = toggled

            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                Window.ConfigData[toggleConfig.Name] = toggled

                Tween(ToggleButton, {BackgroundColor3 = toggled and Window.CurrentTheme.Accent or Window.CurrentTheme.Border}, 0.2)
                Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.2)

                toggleConfig.Callback(toggled)
            end)

            return {
                Set = function(value)
                    toggled = value
                    Window.ConfigData[toggleConfig.Name] = toggled
                    Tween(ToggleButton, {BackgroundColor3 = toggled and Window.CurrentTheme.Accent or Window.CurrentTheme.Border}, 0.2)
                    Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.2)
                end
            }
        end

        -- 3. SLIDER
        function Tab:AddSlider(config)
            local sliderConfig = {
                Name = config.Name or "Slider",
                Min = config.Min or 0,
                Max = config.Max or 100,
                Default = config.Default or 50,
                Callback = config.Callback or function() end
            }

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -24, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderConfig.Name
            SliderLabel.TextColor3 = Window.CurrentTheme.Text
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -62, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(sliderConfig.Default)
            SliderValue.TextColor3 = Window.CurrentTheme.Accent
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 1, -16)
            SliderBar.BackgroundColor3 = Window.CurrentTheme.Border
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame

            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Window.CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar

            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar

            local dragging = false
            local currentValue = sliderConfig.Default
            Window.ConfigData[sliderConfig.Name] = currentValue

            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * pos)
                Window.ConfigData[sliderConfig.Name] = currentValue

                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderValue.Text = tostring(currentValue)
                sliderConfig.Callback(currentValue)
            end

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            return {
                Set = function(value)
                    currentValue = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                    Window.ConfigData[sliderConfig.Name] = currentValue
                    local pos = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderValue.Text = tostring(currentValue)
                end
            }
        end

        -- 4. DROPDOWN
        function Tab:AddDropdown(config)
            local dropdownConfig = {
                Name = config.Name or "Dropdown",
                Options = config.Options or {"Option 1", "Option 2"},
                Default = config.Default or "",
                Callback = config.Callback or function() end
            }

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -70, 0, 40)
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownConfig.Name
            DropdownLabel.TextColor3 = Window.CurrentTheme.Text
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame

            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(0, 100, 0, 40)
            DropdownValue.Position = UDim2.new(1, -130, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = dropdownConfig.Default ~= "" and dropdownConfig.Default or "Selecione"
            DropdownValue.TextColor3 = Window.CurrentTheme.Accent
            DropdownValue.Font = Enum.Font.Gotham
            DropdownValue.TextSize = 13
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.Parent = DropdownFrame

            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, 40)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Window.CurrentTheme.SubText
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.TextSize = 12
            DropdownArrow.Parent = DropdownFrame

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, -10, 0, 0)
            DropdownList.Position = UDim2.new(0, 5, 0, 45)
            DropdownList.BackgroundTransparency = 1
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 3
            DropdownList.ScrollBarImageColor3 = Window.CurrentTheme.Accent
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.Visible = false
            DropdownList.Parent = DropdownFrame

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)
            ListLayout.Parent = DropdownList

            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            end)

            local isOpen = false
            local selectedValue = dropdownConfig.Default
            Window.ConfigData[dropdownConfig.Name] = selectedValue

            for _, option in ipairs(dropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Window.CurrentTheme.Primary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Window.CurrentTheme.Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 13
                OptionButton.Parent = DropdownList

                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 5)
                OptionCorner.Parent = OptionButton

                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Window.CurrentTheme.Border}, 0.2)
                end)

                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Window.CurrentTheme.Primary}, 0.2)
                end)

                OptionButton.MouseButton1Click:Connect(function()
                    selectedValue = option
                    Window.ConfigData[dropdownConfig.Name] = selectedValue
                    DropdownValue.Text = option
                    dropdownConfig.Callback(option)

                    isOpen = false
                    DropdownList.Visible = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    Tween(DropdownArrow, {Rotation = 0}, 0.3)
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                DropdownList.Visible = isOpen

                if isOpen then
                    local contentHeight = math.min(#dropdownConfig.Options * 33, 150)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + contentHeight + 10)}, 0.3)
                    Tween(DropdownArrow, {Rotation = 180}, 0.3)
                    DropdownList.Size = UDim2.new(1, -10, 0, contentHeight)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    Tween(DropdownArrow, {Rotation = 0}, 0.3)
                end
            end)

            return {
                Set = function(value)
                    selectedValue = value
                    Window.ConfigData[dropdownConfig.Name] = selectedValue
                    DropdownValue.Text = value
                end
            }
        end

        -- 5. TEXTBOX
        function Tab:AddTextbox(config)
            local textboxConfig = {
                Name = config.Name or "Textbox",
                Default = config.Default or "",
                Placeholder = config.Placeholder or "Digite aqui...",
                Callback = config.Callback or function() end
            }

            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
            TextboxFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent

            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -24, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 12, 0, 8)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxConfig.Name
            TextboxLabel.TextColor3 = Window.CurrentTheme.Text
            TextboxLabel.Font = Enum.Font.GothamSemibold
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame

            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -24, 0, 32)
            Textbox.Position = UDim2.new(0, 12, 1, -40)
            Textbox.BackgroundColor3 = Window.CurrentTheme.Primary
            Textbox.BorderSizePixel = 0
            Textbox.Text = textboxConfig.Default
            Textbox.PlaceholderText = textboxConfig.Placeholder
            Textbox.PlaceholderColor3 = Window.CurrentTheme.SubText
            Textbox.TextColor3 = Window.CurrentTheme.Text
            Textbox.Font = Enum.Font.Gotham
            Textbox.TextSize = 13
            Textbox.TextXAlignment = Enum.TextXAlignment.Left
            Textbox.Parent = TextboxFrame

            local TextboxInputCorner = Instance.new("UICorner")
            TextboxInputCorner.CornerRadius = UDim.new(0, 6)
            TextboxInputCorner.Parent = Textbox

            local TextboxPadding = Instance.new("UIPadding")
            TextboxPadding.PaddingLeft = UDim.new(0, 10)
            TextboxPadding.PaddingRight = UDim.new(0, 10)
            TextboxPadding.Parent = Textbox

            Window.ConfigData[textboxConfig.Name] = textboxConfig.Default

            Textbox.FocusLost:Connect(function()
                Window.ConfigData[textboxConfig.Name] = Textbox.Text
                textboxConfig.Callback(Textbox.Text)
            end)

            return {
                Set = function(value)
                    Textbox.Text = value
                    Window.ConfigData[textboxConfig.Name] = value
                end
            }
        end

        -- 6. LABEL
        function Tab:AddLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "LabelFrame"
            LabelFrame.Size = UDim2.new(1, 0, 0, 35)
            LabelFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent

            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = LabelFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -24, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Label"
            Label.TextColor3 = Window.CurrentTheme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame

            return {
                Set = function(newText)
                    Label.Text = newText
                end
            }
        end

        -- 7. PARAGRAPH
        function Tab:AddParagraph(config)
            local paragraphConfig = {
                Title = config.Title or "Paragraph",
                Content = config.Content or "Content"
            }

            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = "ParagraphFrame"
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 80)
            ParagraphFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContent

            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 8)
            ParagraphCorner.Parent = ParagraphFrame

            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -24, 0, 22)
            ParagraphTitle.Position = UDim2.new(0, 12, 0, 8)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = paragraphConfig.Title
            ParagraphTitle.TextColor3 = Window.CurrentTheme.Text
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextSize = 15
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame

            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -24, 1, -38)
            ParagraphContent.Position = UDim2.new(0, 12, 0, 30)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = paragraphConfig.Content
            ParagraphContent.TextColor3 = Window.CurrentTheme.SubText
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextSize = 13
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame

            return {
                Set = function(title, content)
                    ParagraphTitle.Text = title
                    ParagraphContent.Text = content
                end
            }
        end

        -- 8. COLORPICKER
        function Tab:AddColorpicker(config)
            local colorpickerConfig = {
                Name = config.Name or "Colorpicker",
                Default = config.Default or Color3.fromRGB(255, 255, 255),
                Callback = config.Callback or function() end
            }

            local ColorpickerFrame = Instance.new("Frame")
            ColorpickerFrame.Name = "ColorpickerFrame"
            ColorpickerFrame.Size = UDim2.new(1, 0, 0, 40)
            ColorpickerFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            ColorpickerFrame.BorderSizePixel = 0
            ColorpickerFrame.Parent = TabContent

            local ColorpickerCorner = Instance.new("UICorner")
            ColorpickerCorner.CornerRadius = UDim.new(0, 8)
            ColorpickerCorner.Parent = ColorpickerFrame

            local ColorpickerLabel = Instance.new("TextLabel")
            ColorpickerLabel.Size = UDim2.new(1, -70, 1, 0)
            ColorpickerLabel.Position = UDim2.new(0, 12, 0, 0)
            ColorpickerLabel.BackgroundTransparency = 1
            ColorpickerLabel.Text = colorpickerConfig.Name
            ColorpickerLabel.TextColor3 = Window.CurrentTheme.Text
            ColorpickerLabel.Font = Enum.Font.GothamSemibold
            ColorpickerLabel.TextSize = 14
            ColorpickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorpickerLabel.Parent = ColorpickerFrame

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 35, 0, 25)
            ColorDisplay.Position = UDim2.new(1, -45, 0.5, -12.5)
            ColorDisplay.BackgroundColor3 = colorpickerConfig.Default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorpickerFrame

            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
            ColorDisplayCorner.Parent = ColorDisplay

            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorDisplay

            local currentColor = colorpickerConfig.Default
            Window.ConfigData[colorpickerConfig.Name] = {
                R = currentColor.R,
                G = currentColor.G,
                B = currentColor.B
            }

            ColorButton.MouseButton1Click:Connect(function()
                -- Implementação simplificada - apenas cores aleatórias para demonstração
                currentColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
                ColorDisplay.BackgroundColor3 = currentColor
                Window.ConfigData[colorpickerConfig.Name] = {
                    R = currentColor.R,
                    G = currentColor.G,
                    B = currentColor.B
                }
                colorpickerConfig.Callback(currentColor)
            end)

            return {
                Set = function(color)
                    currentColor = color
                    ColorDisplay.BackgroundColor3 = color
                    Window.ConfigData[colorpickerConfig.Name] = {
                        R = color.R,
                        G = color.G,
                        B = color.B
                    }
                end
            }
        end

        -- 9. KEYBIND
        function Tab:AddKeybind(config)
            local keybindConfig = {
                Name = config.Name or "Keybind",
                Default = config.Default or Enum.KeyCode.E,
                Callback = config.Callback or function() end
            }

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "KeybindFrame"
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent

            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindConfig.Name
            KeybindLabel.TextColor3 = Window.CurrentTheme.Text
            KeybindLabel.Font = Enum.Font.GothamSemibold
            KeybindLabel.TextSize = 14
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 75, 0, 28)
            KeybindButton.Position = UDim2.new(1, -85, 0.5, -14)
            KeybindButton.BackgroundColor3 = Window.CurrentTheme.Primary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = keybindConfig.Default.Name
            KeybindButton.TextColor3 = Window.CurrentTheme.Accent
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.TextSize = 12
            KeybindButton.Parent = KeybindFrame

            local KeybindBtnCorner = Instance.new("UICorner")
            KeybindBtnCorner.CornerRadius = UDim.new(0, 6)
            KeybindBtnCorner.Parent = KeybindButton

            local currentKey = keybindConfig.Default
            local listening = false
            Window.ConfigData[keybindConfig.Name] = currentKey.Name

            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        currentKey = input.KeyCode
                        Window.ConfigData[keybindConfig.Name] = currentKey.Name
                        KeybindButton.Text = currentKey.Name
                        listening = false
                    end
                end

                if input.KeyCode == currentKey and not gameProcessed then
                    keybindConfig.Callback()
                end
            end)

            return {
                Set = function(key)
                    currentKey = key
                    Window.ConfigData[keybindConfig.Name] = key.Name
                    KeybindButton.Text = key.Name
                end
            }
        end

        -- 10. DIVIDER
        function Tab:AddDivider(text)
            local DividerFrame = Instance.new("Frame")
            DividerFrame.Name = "DividerFrame"
            DividerFrame.Size = UDim2.new(1, 0, 0, 30)
            DividerFrame.BackgroundTransparency = 1
            DividerFrame.Parent = TabContent

            if text and text ~= "" then
                local DividerLabel = Instance.new("TextLabel")
                DividerLabel.Size = UDim2.new(0, #text * 8 + 20, 1, 0)
                DividerLabel.Position = UDim2.new(0.5, -(#text * 8 + 20) / 2, 0, 0)
                DividerLabel.BackgroundTransparency = 1
                DividerLabel.Text = text
                DividerLabel.TextColor3 = Window.CurrentTheme.SubText
                DividerLabel.Font = Enum.Font.GothamBold
                DividerLabel.TextSize = 13
                DividerLabel.Parent = DividerFrame

                local LeftLine = Instance.new("Frame")
                LeftLine.Size = UDim2.new(0.5, -(#text * 8 + 20) / 2 - 10, 0, 2)
                LeftLine.Position = UDim2.new(0, 0, 0.5, -1)
                LeftLine.BackgroundColor3 = Window.CurrentTheme.Border
                LeftLine.BorderSizePixel = 0
                LeftLine.Parent = DividerFrame

                local RightLine = Instance.new("Frame")
                RightLine.Size = UDim2.new(0.5, -(#text * 8 + 20) / 2 - 10, 0, 2)
                RightLine.Position = UDim2.new(0.5, (#text * 8 + 20) / 2 + 10, 0.5, -1)
                RightLine.BackgroundColor3 = Window.CurrentTheme.Border
                RightLine.BorderSizePixel = 0
                RightLine.Parent = DividerFrame
            else
                local Line = Instance.new("Frame")
                Line.Size = UDim2.new(1, 0, 0, 2)
                Line.Position = UDim2.new(0, 0, 0.5, -1)
                Line.BackgroundColor3 = Window.CurrentTheme.Border
                Line.BorderSizePixel = 0
                Line.Parent = DividerFrame
            end
        end

        -- 11. SECTION
        function Tab:AddSection(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "SectionFrame"
            SectionFrame.Size = UDim2.new(1, 0, 0, 35)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent

            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, -12, 1, 0)
            SectionLabel.Position = UDim2.new(0, 6, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = "➤ " .. name
            SectionLabel.TextColor3 = Window.CurrentTheme.Accent
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame

            return {
                Set = function(newName)
                    SectionLabel.Text = "➤ " .. newName
                end
            }
        end

        -- 12. MULTI DROPDOWN
        function Tab:AddMultiDropdown(config)
            local multiDropConfig = {
                Name = config.Name or "Multi Dropdown",
                Options = config.Options or {"Option 1", "Option 2"},
                Default = config.Default or {},
                Callback = config.Callback or function() end
            }

            local MultiDropFrame = Instance.new("Frame")
            MultiDropFrame.Name = "MultiDropFrame"
            MultiDropFrame.Size = UDim2.new(1, 0, 0, 40)
            MultiDropFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            MultiDropFrame.BorderSizePixel = 0
            MultiDropFrame.ClipsDescendants = true
            MultiDropFrame.Parent = TabContent

            local MultiDropCorner = Instance.new("UICorner")
            MultiDropCorner.CornerRadius = UDim.new(0, 8)
            MultiDropCorner.Parent = MultiDropFrame

            local MultiDropButton = Instance.new("TextButton")
            MultiDropButton.Size = UDim2.new(1, 0, 0, 40)
            MultiDropButton.BackgroundTransparency = 1
            MultiDropButton.Text = ""
            MultiDropButton.Parent = MultiDropFrame

            local MultiDropLabel = Instance.new("TextLabel")
            MultiDropLabel.Size = UDim2.new(1, -70, 0, 40)
            MultiDropLabel.Position = UDim2.new(0, 12, 0, 0)
            MultiDropLabel.BackgroundTransparency = 1
            MultiDropLabel.Text = multiDropConfig.Name
            MultiDropLabel.TextColor3 = Window.CurrentTheme.Text
            MultiDropLabel.Font = Enum.Font.GothamSemibold
            MultiDropLabel.TextSize = 14
            MultiDropLabel.TextXAlignment = Enum.TextXAlignment.Left
            MultiDropLabel.Parent = MultiDropFrame

            local MultiDropArrow = Instance.new("TextLabel")
            MultiDropArrow.Size = UDim2.new(0, 20, 0, 40)
            MultiDropArrow.Position = UDim2.new(1, -25, 0, 0)
            MultiDropArrow.BackgroundTransparency = 1
            MultiDropArrow.Text = "▼"
            MultiDropArrow.TextColor3 = Window.CurrentTheme.SubText
            MultiDropArrow.Font = Enum.Font.GothamBold
            MultiDropArrow.TextSize = 12
            MultiDropArrow.Parent = MultiDropFrame

            local MultiDropList = Instance.new("ScrollingFrame")
            MultiDropList.Size = UDim2.new(1, -10, 0, 0)
            MultiDropList.Position = UDim2.new(0, 5, 0, 45)
            MultiDropList.BackgroundTransparency = 1
            MultiDropList.BorderSizePixel = 0
            MultiDropList.ScrollBarThickness = 3
            MultiDropList.ScrollBarImageColor3 = Window.CurrentTheme.Accent
            MultiDropList.CanvasSize = UDim2.new(0, 0, 0, 0)
            MultiDropList.Visible = false
            MultiDropList.Parent = MultiDropFrame

            local MultiListLayout = Instance.new("UIListLayout")
            MultiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            MultiListLayout.Padding = UDim.new(0, 3)
            MultiListLayout.Parent = MultiDropList

            MultiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                MultiDropList.CanvasSize = UDim2.new(0, 0, 0, MultiListLayout.AbsoluteContentSize.Y)
            end)

            local isOpen = false
            local selectedValues = {}
            for _, v in ipairs(multiDropConfig.Default) do
                selectedValues[v] = true
            end
            Window.ConfigData[multiDropConfig.Name] = selectedValues

            for _, option in ipairs(multiDropConfig.Options) do
                local OptionFrame = Instance.new("Frame")
                OptionFrame.Size = UDim2.new(1, 0, 0, 30)
                OptionFrame.BackgroundColor3 = Window.CurrentTheme.Primary
                OptionFrame.BorderSizePixel = 0
                OptionFrame.Parent = MultiDropList

                local OptionFrameCorner = Instance.new("UICorner")
                OptionFrameCorner.CornerRadius = UDim.new(0, 5)
                OptionFrameCorner.Parent = OptionFrame

                local OptionCheckbox = Instance.new("Frame")
                OptionCheckbox.Size = UDim2.new(0, 18, 0, 18)
                OptionCheckbox.Position = UDim2.new(0, 8, 0.5, -9)
                OptionCheckbox.BackgroundColor3 = selectedValues[option] and Window.CurrentTheme.Accent or Window.CurrentTheme.Border
                OptionCheckbox.BorderSizePixel = 0
                OptionCheckbox.Parent = OptionFrame

                local CheckboxCorner = Instance.new("UICorner")
                CheckboxCorner.CornerRadius = UDim.new(0, 4)
                CheckboxCorner.Parent = OptionCheckbox

                local CheckMark = Instance.new("TextLabel")
                CheckMark.Size = UDim2.new(1, 0, 1, 0)
                CheckMark.BackgroundTransparency = 1
                CheckMark.Text = selectedValues[option] and "✓" or ""
                CheckMark.TextColor3 = Color3.fromRGB(255, 255, 255)
                CheckMark.Font = Enum.Font.GothamBold
                CheckMark.TextSize = 14
                CheckMark.Parent = OptionCheckbox

                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -34, 1, 0)
                OptionLabel.Position = UDim2.new(0, 30, 0, 0)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Text = option
                OptionLabel.TextColor3 = Window.CurrentTheme.Text
                OptionLabel.Font = Enum.Font.Gotham
                OptionLabel.TextSize = 13
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.Parent = OptionFrame

                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 1, 0)
                OptionButton.BackgroundTransparency = 1
                OptionButton.Text = ""
                OptionButton.Parent = OptionFrame

                OptionButton.MouseButton1Click:Connect(function()
                    selectedValues[option] = not selectedValues[option]
                    Window.ConfigData[multiDropConfig.Name] = selectedValues

                    if selectedValues[option] then
                        OptionCheckbox.BackgroundColor3 = Window.CurrentTheme.Accent
                        CheckMark.Text = "✓"
                    else
                        OptionCheckbox.BackgroundColor3 = Window.CurrentTheme.Border
                        CheckMark.Text = ""
                    end

                    local selected = {}
                    for k, v in pairs(selectedValues) do
                        if v then table.insert(selected, k) end
                    end
                    multiDropConfig.Callback(selected)
                end)

                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionFrame, {BackgroundColor3 = Window.CurrentTheme.Border}, 0.2)
                end)

                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionFrame, {BackgroundColor3 = Window.CurrentTheme.Primary}, 0.2)
                end)
            end

            MultiDropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                MultiDropList.Visible = isOpen

                if isOpen then
                    local contentHeight = math.min(#multiDropConfig.Options * 33, 150)
                    Tween(MultiDropFrame, {Size = UDim2.new(1, 0, 0, 40 + contentHeight + 10)}, 0.3)
                    Tween(MultiDropArrow, {Rotation = 180}, 0.3)
                    MultiDropList.Size = UDim2.new(1, -10, 0, contentHeight)
                else
                    Tween(MultiDropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    Tween(MultiDropArrow, {Rotation = 0}, 0.3)
                end
            end)

            return {
                Set = function(values)
                    selectedValues = {}
                    for _, v in ipairs(values) do
                        selectedValues[v] = true
                    end
                    Window.ConfigData[multiDropConfig.Name] = selectedValues
                end
            }
        end

        return Tab
    end

    -- Sistema de Config
    function Window:AddConfig()
        local ConfigTab = self:AddTab("⚙️ Configurações", "")

        ConfigTab:AddSection("Tema")

        local themeNames = {}
        for name, _ in pairs(Themes) do
            table.insert(themeNames, name)
        end

        ConfigTab:AddDropdown({
            Name = "Tema",
            Options = themeNames,
            Default = WindowConfig.Theme,
            Callback = function(theme)
                self:ChangeTheme(theme)
            end
        })

        ConfigTab:AddToggle({
            Name = "Fundo Transparente",
            Default = false,
            Callback = function(enabled)
                MainFrame.BackgroundTransparency = enabled and 0.4 or 0
            end
        })

        ConfigTab:AddDivider()

        ConfigTab:AddSection("Sistema de Save")

        ConfigTab:AddToggle({
            Name = "Auto Save & Load",
            Default = WindowConfig.AutoSaveLoad,
            Callback = function(enabled)
                WindowConfig.AutoSaveLoad = enabled
            end
        })

        ConfigTab:AddButton({
            Name = "Salvar Configuração",
            Callback = function()
                self:SaveConfig()
            end
        })

        ConfigTab:AddButton({
            Name = "Carregar Configuração",
            Callback = function()
                self:LoadConfig()
            end
        })

        ConfigTab:AddButton({
            Name = "Resetar Configuração",
            Callback = function()
                self.ConfigData = {}
                SaveSystem:Save(WindowConfig.ConfigFileName, {})
            end
        })
    end

    function Window:ChangeTheme(themeName)
        local theme = Themes[themeName]
        if not theme then return end

        self.CurrentTheme = theme

        -- Atualizar cores
        Tween(MainFrame, {BackgroundColor3 = theme.Primary}, 0.3)
        Tween(TopBar, {BackgroundColor3 = theme.Secondary}, 0.3)
        Tween(TopBarFix, {BackgroundColor3 = theme.Secondary}, 0.3)
        Tween(TabContainer, {BackgroundColor3 = theme.Secondary}, 0.3)

        Title.TextColor3 = theme.Text

        -- Atualizar todas as tabs
        for _, tab in pairs(self.Tabs) do
            if tab.Button.BackgroundColor3 == self.CurrentTheme.Accent then
                tab.Button.BackgroundColor3 = theme.Accent
                tab.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                tab.Button.BackgroundColor3 = theme.Primary
                tab.Label.TextColor3 = theme.SubText
            end
        end
    end

    function Window:SaveConfig()
        if SaveSystem:Save(WindowConfig.ConfigFileName, self.ConfigData) then
            print("Configuração salva com sucesso!")
        end
    end

    function Window:LoadConfig()
        local data = SaveSystem:Load(WindowConfig.ConfigFileName)
        if data then
            self.ConfigData = data
            print("Configuração carregada com sucesso!")
            -- Aplicar configurações carregadas aos elementos
        end
    end

    -- Auto Load Config
    if WindowConfig.AutoSaveLoad then
        Window:LoadConfig()
    end

    return Window
end

return Library
