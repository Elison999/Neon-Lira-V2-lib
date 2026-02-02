--[[
    Modern UI Library 10x - Roblox
    Sistema completo com Key System, Auto Save/Load, Temas e 12 Elementos
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

-- Configurações padrão
local defaultConfig = {
    WindowName = "Modern UI Library",
    ImageId = "",
    KeyEnable = false,
    Key = "1234",
    KeyName = "KeySystem",
    KeySave = false,
    KeyFileName = "UILibrary_Key.json",
    GetKeyFromSite = false,
    KeySite = "",
    AutoLoadKey = true,
    LoadingName = "Loading UI",
    LoadingImageId = "",
    AutoSaveLoad = true,
    ConfigFileName = "UILibrary_Config.json"
}

-- Temas modernos
local Themes = {
    ["Cyberpunk Neon"] = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(255, 20, 147),
        Background = Color3.fromRGB(15, 15, 25),
        Topbar = Color3.fromRGB(20, 20, 35),
        ElementBG = Color3.fromRGB(25, 25, 40),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentGlow = Color3.fromRGB(138, 43, 226)
    },
    ["Ocean Breeze"] = {
        Primary = Color3.fromRGB(0, 150, 255),
        Secondary = Color3.fromRGB(0, 200, 200),
        Background = Color3.fromRGB(10, 25, 40),
        Topbar = Color3.fromRGB(15, 35, 55),
        ElementBG = Color3.fromRGB(20, 40, 60),
        TextColor = Color3.fromRGB(240, 250, 255),
        AccentGlow = Color3.fromRGB(0, 200, 255)
    },
    ["Sunset Gradient"] = {
        Primary = Color3.fromRGB(255, 120, 50),
        Secondary = Color3.fromRGB(255, 80, 120),
        Background = Color3.fromRGB(30, 20, 35),
        Topbar = Color3.fromRGB(45, 30, 50),
        ElementBG = Color3.fromRGB(50, 35, 55),
        TextColor = Color3.fromRGB(255, 245, 235),
        AccentGlow = Color3.fromRGB(255, 100, 80)
    },
    ["Forest Green"] = {
        Primary = Color3.fromRGB(50, 205, 50),
        Secondary = Color3.fromRGB(34, 139, 34),
        Background = Color3.fromRGB(15, 25, 15),
        Topbar = Color3.fromRGB(20, 35, 20),
        ElementBG = Color3.fromRGB(25, 40, 25),
        TextColor = Color3.fromRGB(240, 255, 240),
        AccentGlow = Color3.fromRGB(50, 255, 50)
    },
    ["Royal Purple"] = {
        Primary = Color3.fromRGB(147, 51, 234),
        Secondary = Color3.fromRGB(192, 132, 252),
        Background = Color3.fromRGB(20, 15, 30),
        Topbar = Color3.fromRGB(30, 20, 45),
        ElementBG = Color3.fromRGB(35, 25, 50),
        TextColor = Color3.fromRGB(250, 245, 255),
        AccentGlow = Color3.fromRGB(167, 71, 254)
    },
    ["Crimson Fire"] = {
        Primary = Color3.fromRGB(220, 20, 60),
        Secondary = Color3.fromRGB(255, 69, 0),
        Background = Color3.fromRGB(25, 10, 15),
        Topbar = Color3.fromRGB(35, 15, 20),
        ElementBG = Color3.fromRGB(40, 20, 25),
        TextColor = Color3.fromRGB(255, 240, 245),
        AccentGlow = Color3.fromRGB(255, 40, 80)
    },
    ["Ice Blue"] = {
        Primary = Color3.fromRGB(135, 206, 250),
        Secondary = Color3.fromRGB(176, 224, 230),
        Background = Color3.fromRGB(15, 20, 30),
        Topbar = Color3.fromRGB(20, 30, 45),
        ElementBG = Color3.fromRGB(25, 35, 50),
        TextColor = Color3.fromRGB(240, 248, 255),
        AccentGlow = Color3.fromRGB(155, 226, 255)
    },
    ["Golden Luxury"] = {
        Primary = Color3.fromRGB(255, 215, 0),
        Secondary = Color3.fromRGB(218, 165, 32),
        Background = Color3.fromRGB(20, 20, 15),
        Topbar = Color3.fromRGB(30, 30, 20),
        ElementBG = Color3.fromRGB(35, 35, 25),
        TextColor = Color3.fromRGB(255, 250, 240),
        AccentGlow = Color3.fromRGB(255, 235, 50)
    },
    ["Midnight Dark"] = {
        Primary = Color3.fromRGB(100, 100, 120),
        Secondary = Color3.fromRGB(130, 130, 150),
        Background = Color3.fromRGB(10, 10, 15),
        Topbar = Color3.fromRGB(15, 15, 20),
        ElementBG = Color3.fromRGB(20, 20, 25),
        TextColor = Color3.fromRGB(220, 220, 230),
        AccentGlow = Color3.fromRGB(120, 120, 140)
    },
    ["Cherry Blossom"] = {
        Primary = Color3.fromRGB(255, 183, 197),
        Secondary = Color3.fromRGB(255, 105, 180),
        Background = Color3.fromRGB(30, 20, 25),
        Topbar = Color3.fromRGB(40, 25, 32),
        ElementBG = Color3.fromRGB(45, 30, 37),
        TextColor = Color3.fromRGB(255, 240, 245),
        AccentGlow = Color3.fromRGB(255, 150, 200)
    }
}

-- Funções auxiliares
local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return CreateInstance("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function AddGlow(parent, color, size)
    local glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = color,
        ImageTransparency = 0.5,
        Size = UDim2.new(1, size or 20, 1, size or 20),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 0,
        Parent = parent
    })
    AddCorner(glow, 12)
    return glow
end

-- Funções de Save/Load
function Library:SaveConfig(data, fileName)
    if not self.config.AutoSaveLoad then return end
    local success, result = pcall(function()
        writefile(fileName, HttpService:JSONEncode(data))
    end)
    return success
end

function Library:LoadConfig(fileName)
    if not self.config.AutoSaveLoad then return nil end
    local success, result = pcall(function()
        if isfile(fileName) then
            return HttpService:JSONDecode(readfile(fileName))
        end
    end)
    return success and result or nil
end

-- Sistema de Loading
function Library:CreateLoadingScreen()
    local LoadingScreen = CreateInstance("ScreenGui", {
        Name = "LoadingScreen",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Background = CreateInstance("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = LoadingScreen
    })

    local Container = CreateInstance("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Background
    })

    if self.config.LoadingImageId ~= "" then
        local LoadingImage = CreateInstance("ImageLabel", {
            Name = "LoadingImage",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 120, 0, 120),
            Position = UDim2.new(0.5, 0, 0, 20),
            AnchorPoint = Vector2.new(0.5, 0),
            Image = "rbxassetid://" .. self.config.LoadingImageId,
            Parent = Container
        })
        AddCorner(LoadingImage, 60)
    end

    local LoadingTitle = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 160),
        Font = Enum.Font.GothamBold,
        Text = self.config.LoadingName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Parent = Container
    })

    local ProgressBar = CreateInstance("Frame", {
        Name = "ProgressBar",
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(0.8, 0, 0, 6),
        Position = UDim2.new(0.5, 0, 0, 220),
        AnchorPoint = Vector2.new(0.5, 0),
        BorderSizePixel = 0,
        Parent = Container
    })
    AddCorner(ProgressBar, 3)

    local ProgressFill = CreateInstance("Frame", {
        Name = "Fill",
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = ProgressBar
    })
    AddCorner(ProgressFill, 3)

    local LoadingText = CreateInstance("TextLabel", {
        Name = "LoadingText",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 240),
        Font = Enum.Font.Gotham,
        Text = "Initializing...",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 14,
        Parent = Container
    })

    -- Animação de loading
    spawn(function()
        local steps = {
            {progress = 0.2, text = "Loading assets..."},
            {progress = 0.4, text = "Initializing components..."},
            {progress = 0.6, text = "Setting up interface..."},
            {progress = 0.8, text = "Finalizing..."},
            {progress = 1, text = "Complete!"}
        }

        for _, step in ipairs(steps) do
            Tween(ProgressFill, {Size = UDim2.new(step.progress, 0, 1, 0)}, 0.5)
            LoadingText.Text = step.text
            wait(0.4)
        end

        wait(0.3)
        Tween(Background, {BackgroundTransparency = 1}, 0.3)
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("GuiObject") then
                Tween(child, {Transparency = 1}, 0.3)
                if child:FindFirstChild("TextTransparency") then
                    Tween(child, {TextTransparency = 1}, 0.3)
                end
            end
        end
        wait(0.3)
        LoadingScreen:Destroy()
    end)

    return LoadingScreen
end

-- Sistema de Key
function Library:CreateKeySystem()
    local KeyScreen = CreateInstance("ScreenGui", {
        Name = "KeySystem",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Background = CreateInstance("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = KeyScreen
    })

    local KeyContainer = CreateInstance("Frame", {
        Name = "KeyContainer",
        BackgroundColor3 = self.currentTheme.Background,
        Size = UDim2.new(0, 450, 0, 350),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        Parent = Background
    })
    AddCorner(KeyContainer, 12)
    AddStroke(KeyContainer, self.currentTheme.Primary, 2)

    local KeyTitle = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = self.config.KeyName,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = KeyContainer
    })

    local KeyDescription = CreateInstance("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 60),
        Position = UDim2.new(0, 20, 0, 80),
        Font = Enum.Font.Gotham,
        Text = "Please enter the key to continue.\nThe key is required to access this UI.",
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = KeyContainer
    })

    local KeyInputFrame = CreateInstance("Frame", {
        Name = "InputFrame",
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -40, 0, 45),
        Position = UDim2.new(0, 20, 0, 160),
        BorderSizePixel = 0,
        Parent = KeyContainer
    })
    AddCorner(KeyInputFrame, 8)
    AddStroke(KeyInputFrame, self.currentTheme.Primary, 1)

    local KeyInput = CreateInstance("TextBox", {
        Name = "KeyInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter key here...",
        Text = "",
        TextColor3 = self.currentTheme.TextColor,
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = KeyInputFrame
    })

    local SubmitButton = CreateInstance("TextButton", {
        Name = "SubmitButton",
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(1, -40, 0, 45),
        Position = UDim2.new(0, 20, 0, 220),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Submit Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        AutoButtonColor = false,
        Parent = KeyContainer
    })
    AddCorner(SubmitButton, 8)

    if self.config.GetKeyFromSite and self.config.KeySite ~= "" then
        local GetKeyButton = CreateInstance("TextButton", {
            Name = "GetKeyButton",
            BackgroundColor3 = self.currentTheme.Secondary,
            Size = UDim2.new(1, -40, 0, 35),
            Position = UDim2.new(0, 20, 0, 280),
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = "Get Key",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            AutoButtonColor = false,
            Parent = KeyContainer
        })
        AddCorner(GetKeyButton, 8)

        GetKeyButton.MouseButton1Click:Connect(function()
            Tween(GetKeyButton, {BackgroundColor3 = self.currentTheme.Primary}, 0.2)
            wait(0.1)
            Tween(GetKeyButton, {BackgroundColor3 = self.currentTheme.Secondary}, 0.2)
            
            setclipboard(self.config.KeySite)
            GetKeyButton.Text = "Link Copied!"
            wait(2)
            GetKeyButton.Text = "Get Key"
        end)
    end

    local ErrorText = CreateInstance("TextLabel", {
        Name = "ErrorText",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 20, 0, 135),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 80, 80),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = false,
        Parent = KeyContainer
    })

    SubmitButton.MouseButton1Click:Connect(function()
        local enteredKey = KeyInput.Text
        local correctKey = self.config.Key

        if self.config.GetKeyFromSite and self.config.KeySite ~= "" then
            -- Implementar verificação de key do site aqui se necessário
        end

        if enteredKey == correctKey then
            if self.config.KeySave then
                self:SaveConfig({Key = enteredKey, Valid = true}, self.config.KeyFileName)
            end

            Tween(SubmitButton, {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}, 0.2)
            SubmitButton.Text = "✓ Key Accepted!"
            
            wait(0.5)
            Tween(Background, {BackgroundTransparency = 1}, 0.3)
            Tween(KeyContainer, {Size = UDim2.new(0, 450, 0, 0)}, 0.3)
            wait(0.3)
            KeyScreen:Destroy()
            
            self:CreateLoadingScreen()
            self:InitializeUI()
        else
            ErrorText.Text = "✗ Invalid key! Please try again."
            ErrorText.Visible = true
            Tween(SubmitButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
            Tween(KeyInputFrame, {Position = UDim2.new(0, 10, 0, 160)}, 0.1)
            wait(0.05)
            Tween(KeyInputFrame, {Position = UDim2.new(0, 30, 0, 160)}, 0.1)
            wait(0.05)
            Tween(KeyInputFrame, {Position = UDim2.new(0, 20, 0, 160)}, 0.1)
            wait(0.3)
            Tween(SubmitButton, {BackgroundColor3 = self.currentTheme.Primary}, 0.2)
            KeyInput.Text = ""
        end
    end)

    return KeyScreen
end

-- Criar UI Principal
function Library:InitializeUI()
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "ModernUILibrary",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = self.currentTheme.Background,
        Size = UDim2.new(0, 650, 0, 500),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    AddCorner(self.MainFrame, 12)
    AddStroke(self.MainFrame, self.currentTheme.Primary, 2)

    -- Topbar
    self:CreateTopbar()

    -- Tab Container
    self.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.currentTheme.Topbar,
        Size = UDim2.new(0, 160, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })

    local TabListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabContainer
    })

    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = self.TabContainer
    })

    -- Content Container
    self.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -170, 1, -70),
        Position = UDim2.new(0, 165, 0, 65),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.MainFrame
    })

    self.tabs = {}
    self.currentTab = nil
    self.minimized = false
    self.savedSize = self.MainFrame.Size
    self.savedPosition = self.MainFrame.Position

    -- Carregar configurações salvas
    if self.config.AutoSaveLoad then
        local savedConfig = self:LoadConfig(self.config.ConfigFileName)
        if savedConfig then
            self.savedElements = savedConfig.Elements or {}
            if savedConfig.Theme then
                self:SetTheme(savedConfig.Theme)
            end
            if savedConfig.BackgroundOpacity ~= nil then
                self.MainFrame.BackgroundTransparency = savedConfig.BackgroundOpacity and 0.4 or 0
            end
        end
    end
end

function Library:CreateTopbar()
    local Topbar = CreateInstance("Frame", {
        Name = "Topbar",
        BackgroundColor3 = self.currentTheme.Topbar,
        Size = UDim2.new(1, 0, 0, 50),
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })

    local TopbarCorner = AddCorner(Topbar, 12)

    local TopbarBottom = CreateInstance("Frame", {
        Name = "BottomCover",
        BackgroundColor3 = self.currentTheme.Topbar,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BorderSizePixel = 0,
        Parent = Topbar
    })

    -- Ícone
    if self.config.ImageId ~= "" then
        local Icon = CreateInstance("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 35, 0, 35),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = "rbxassetid://" .. self.config.ImageId,
            Parent = Topbar
        })
        AddCorner(Icon, 8)
    end

    -- Título
    local Title = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(0, self.config.ImageId ~= "" and 55 or 15, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = self.config.WindowName,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })

    -- Botões de controle
    local buttonSize = 35
    local buttonPadding = 5

    -- Botão Close
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        BackgroundColor3 = Color3.fromRGB(220, 50, 50),
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, -(buttonSize + 10), 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        AutoButtonColor = false,
        Parent = Topbar
    })
    AddCorner(CloseButton, 8)

    -- Botão Minimize
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        BackgroundColor3 = Color3.fromRGB(220, 180, 50),
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, -(buttonSize * 2 + 10 + buttonPadding), 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "—",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        AutoButtonColor = false,
        Parent = Topbar
    })
    AddCorner(MinimizeButton, 8)

    -- Botão Resize
    local ResizeButton = CreateInstance("TextButton", {
        Name = "ResizeButton",
        BackgroundColor3 = Color3.fromRGB(50, 180, 220),
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Position = UDim2.new(1, -(buttonSize * 3 + 10 + buttonPadding * 2), 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "⊡",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        AutoButtonColor = false,
        Parent = Topbar
    })
    AddCorner(ResizeButton, 8)

    -- Funcionalidade de arrastar
    local dragging, dragInput, dragStart, startPos

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position

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
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Funcionalidade Close com confirmação
    CloseButton.MouseButton1Click:Connect(function()
        self:CreateConfirmDialog("Are you sure you want to close?", function(confirmed)
            if confirmed then
                Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
                wait(0.3)
                self.ScreenGui:Destroy()
            end
        end)
    end)

    -- Funcionalidade Minimize
    MinimizeButton.MouseButton1Click:Connect(function()
        if not self.minimized then
            self.savedSize = self.MainFrame.Size
            Tween(self.MainFrame, {Size = UDim2.new(0, self.MainFrame.Size.X.Offset, 0, 50)}, 0.3)
            self.minimized = true
            MinimizeButton.Text = "▢"
        else
            Tween(self.MainFrame, {Size = self.savedSize}, 0.3)
            self.minimized = false
            MinimizeButton.Text = "—"
        end
    end)

    -- Funcionalidade Resize
    local resized = false
    ResizeButton.MouseButton1Click:Connect(function()
        if not resized then
            self.savedSize = self.MainFrame.Size
            Tween(self.MainFrame, {Size = UDim2.new(0, 450, 0, 400)}, 0.3)
            resized = true
        else
            Tween(self.MainFrame, {Size = self.savedSize}, 0.3)
            resized = false
        end
    end)
end

function Library:CreateConfirmDialog(message, callback)
    local ConfirmScreen = CreateInstance("ScreenGui", {
        Name = "ConfirmDialog",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Background = CreateInstance("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = ConfirmScreen
    })

    local DialogBox = CreateInstance("Frame", {
        Name = "DialogBox",
        BackgroundColor3 = self.currentTheme.Background,
        Size = UDim2.new(0, 350, 0, 180),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        Parent = Background
    })
    AddCorner(DialogBox, 12)
    AddStroke(DialogBox, self.currentTheme.Primary, 2)

    local Message = CreateInstance("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 80),
        Position = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 16,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = DialogBox
    })

    local YesButton = CreateInstance("TextButton", {
        Name = "YesButton",
        BackgroundColor3 = Color3.fromRGB(50, 200, 50),
        Size = UDim2.new(0, 140, 0, 40),
        Position = UDim2.new(0, 20, 1, -55),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Yes",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        AutoButtonColor = false,
        Parent = DialogBox
    })
    AddCorner(YesButton, 8)

    local CancelButton = CreateInstance("TextButton", {
        Name = "CancelButton",
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Size = UDim2.new(0, 140, 0, 40),
        Position = UDim2.new(1, -160, 1, -55),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "Cancel",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        AutoButtonColor = false,
        Parent = DialogBox
    })
    AddCorner(CancelButton, 8)

    YesButton.MouseButton1Click:Connect(function()
        ConfirmScreen:Destroy()
        callback(true)
    end)

    CancelButton.MouseButton1Click:Connect(function()
        ConfirmScreen:Destroy()
        callback(false)
    end)
end

-- Sistema de Tabs
function Library:AddTab(name, icon)
    local TabButton = CreateInstance("TextButton", {
        Name = name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "  " .. name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        Parent = self.TabContainer
    })
    AddCorner(TabButton, 8)

    if icon and icon ~= "" then
        local Icon = CreateInstance("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = "rbxassetid://" .. icon,
            Parent = TabButton
        })
        TabButton.Text = "      " .. name
    end

    local TabContent = CreateInstance("ScrollingFrame", {
        Name = name .. "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.currentTheme.Primary,
        BorderSizePixel = 0,
        Visible = false,
        Parent = self.ContentContainer
    })

    local ContentLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContent
    })

    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = TabContent
    })

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.tabs) do
            tab.Button.BackgroundColor3 = self.currentTheme.ElementBG
            tab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = self.currentTheme.Primary
        TabContent.Visible = true
        self.currentTab = name
    end)

    self.tabs[name] = {
        Button = TabButton,
        Content = TabContent,
        Elements = {}
    }

    if not self.currentTab then
        TabButton.BackgroundColor3 = self.currentTheme.Primary
        TabContent.Visible = true
        self.currentTab = name
    end

    return setmetatable({
        Library = self,
        TabName = name,
        Content = TabContent
    }, {__index = Library})
end

-- Elementos da UI

-- 1. Toggle
function Library:AddToggle(name, default, callback)
    local ToggleFrame = CreateInstance("Frame", {
        Name = "Toggle_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(ToggleFrame, 8)

    local ToggleLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })

    local ToggleButton = CreateInstance("TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = ToggleFrame
    })
    AddCorner(ToggleButton, 11)

    local ToggleCircle = CreateInstance("Frame", {
        Name = "Circle",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Parent = ToggleButton
    })
    AddCorner(ToggleCircle, 9)

    local toggled = default or false
    
    if self.savedElements and self.savedElements[name] ~= nil then
        toggled = self.savedElements[name]
    end

    local function UpdateToggle(state)
        toggled = state
        if toggled then
            Tween(ToggleButton, {BackgroundColor3 = self.currentTheme.Primary}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(1, -20, 0.5, 0)}, 0.2)
        else
            Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2)
        end
        
        if callback then
            callback(toggled)
        end
        
        self:SaveElementState(name, toggled)
    end

    UpdateToggle(toggled)

    ToggleButton.MouseButton1Click:Connect(function()
        UpdateToggle(not toggled)
    end)

    return {
        SetValue = UpdateToggle
    }
end

-- 2. Button
function Library:AddButton(name, callback)
    local ButtonFrame = CreateInstance("TextButton", {
        Name = "Button_" .. name,
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        AutoButtonColor = false,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(ButtonFrame, 8)

    ButtonFrame.MouseButton1Click:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = self.currentTheme.Secondary}, 0.1)
        wait(0.1)
        Tween(ButtonFrame, {BackgroundColor3 = self.currentTheme.Primary}, 0.1)
        
        if callback then
            callback()
        end
    end)

    return ButtonFrame
end

-- 3. Slider
function Library:AddSlider(name, min, max, default, callback)
    local SliderFrame = CreateInstance("Frame", {
        Name = "Slider_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 60),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(SliderFrame, 8)

    local SliderLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 8),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SliderFrame
    })

    local SliderValue = CreateInstance("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(1, -72, 0, 8),
        Font = Enum.Font.GothamBold,
        Text = tostring(default),
        TextColor3 = self.currentTheme.Primary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = SliderFrame
    })

    local SliderBar = CreateInstance("Frame", {
        Name = "Bar",
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 1, -18),
        BorderSizePixel = 0,
        Parent = SliderFrame
    })
    AddCorner(SliderBar, 3)

    local SliderFill = CreateInstance("Frame", {
        Name = "Fill",
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = SliderBar
    })
    AddCorner(SliderFill, 3)

    local SliderButton = CreateInstance("TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, -7, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = SliderFill
    })
    AddCorner(SliderButton, 7)

    local value = default or min
    
    if self.savedElements and self.savedElements[name] ~= nil then
        value = self.savedElements[name]
    end

    local function UpdateSlider(val)
        value = math.clamp(val, min, max)
        local percent = (value - min) / (max - min)
        
        Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        SliderValue.Text = tostring(math.floor(value))
        
        if callback then
            callback(value)
        end
        
        self:SaveElementState(name, value)
    end

    UpdateSlider(value)

    local dragging = false

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
            local mousePos = input.Position.X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local newValue = min + (percent * (max - min))
            UpdateSlider(newValue)
        end
    end)

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position.X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local newValue = min + (percent * (max - min))
            UpdateSlider(newValue)
        end
    end)

    return {
        SetValue = UpdateSlider
    }
end

-- 4. Dropdown
function Library:AddDropdown(name, options, default, callback)
    local DropdownFrame = CreateInstance("Frame", {
        Name = "Dropdown_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(DropdownFrame, 8)

    local DropdownLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DropdownFrame
    })

    local DropdownButton = CreateInstance("TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(0, 150, 0, 30),
        Position = UDim2.new(1, -162, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = default or options[1] or "Select",
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = DropdownFrame
    })
    AddCorner(DropdownButton, 6)

    local Arrow = CreateInstance("TextLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = "▼",
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 10,
        Parent = DropdownButton
    })

    local DropdownList = CreateInstance("Frame", {
        Name = "List",
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(0, 150, 0, 0),
        Position = UDim2.new(1, -162, 1, 5),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = DropdownFrame
    })
    AddCorner(DropdownList, 6)
    AddStroke(DropdownList, self.currentTheme.Primary, 1)

    local ListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = DropdownList
    })

    local selectedOption = default or options[1]
    
    if self.savedElements and self.savedElements[name] ~= nil then
        selectedOption = self.savedElements[name]
        DropdownButton.Text = selectedOption
    end

    local isOpen = false

    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            DropdownList.Visible = true
            Tween(DropdownList, {Size = UDim2.new(0, 150, 0, math.min(#options * 32, 150))}, 0.2)
            Tween(Arrow, {Rotation = 180}, 0.2)
        else
            Tween(DropdownList, {Size = UDim2.new(0, 150, 0, 0)}, 0.2)
            Tween(Arrow, {Rotation = 0}, 0.2)
            wait(0.2)
            DropdownList.Visible = false
        end
    end)

    for _, option in ipairs(options) do
        local OptionButton = CreateInstance("TextButton", {
            Name = option,
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            Size = UDim2.new(1, 0, 0, 30),
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = option,
            TextColor3 = self.currentTheme.TextColor,
            TextSize = 13,
            AutoButtonColor = false,
            Parent = DropdownList
        })
        AddCorner(OptionButton, 4)

        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownButton.Text = option
            
            isOpen = false
            Tween(DropdownList, {Size = UDim2.new(0, 150, 0, 0)}, 0.2)
            Tween(Arrow, {Rotation = 0}, 0.2)
            wait(0.2)
            DropdownList.Visible = false
            
            if callback then
                callback(option)
            end
            
            self:SaveElementState(name, option)
        end)

        OptionButton.MouseEnter:Connect(function()
            Tween(OptionButton, {BackgroundColor3 = self.currentTheme.Primary}, 0.1)
        end)

        OptionButton.MouseLeave:Connect(function()
            Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.1)
        end)
    end

    return {
        SetValue = function(option)
            selectedOption = option
            DropdownButton.Text = option
            self:SaveElementState(name, option)
        end
    }
end

-- 5. Textbox
function Library:AddTextbox(name, placeholder, callback)
    local TextboxFrame = CreateInstance("Frame", {
        Name = "Textbox_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(TextboxFrame, 8)

    local TextboxLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TextboxFrame
    })

    local TextboxInput = CreateInstance("TextBox", {
        Name = "Input",
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(0.55, 0, 0, 30),
        Position = UDim2.new(0.43, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        PlaceholderText = placeholder or "Enter text...",
        Text = "",
        TextColor3 = self.currentTheme.TextColor,
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 13,
        ClearTextOnFocus = false,
        Parent = TextboxFrame
    })
    AddCorner(TextboxInput, 6)

    if self.savedElements and self.savedElements[name] then
        TextboxInput.Text = self.savedElements[name]
    end

    TextboxInput.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(TextboxInput.Text)
        end
        self:SaveElementState(name, TextboxInput.Text)
    end)

    return {
        SetValue = function(text)
            TextboxInput.Text = text
            self:SaveElementState(name, text)
        end
    }
end

-- 6. Label
function Library:AddLabel(text)
    local LabelFrame = CreateInstance("Frame", {
        Name = "Label",
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 35),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(LabelFrame, 8)

    local Label = CreateInstance("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = LabelFrame
    })

    return {
        SetText = function(newText)
            Label.Text = newText
        end
    }
end

-- 7. Keybind
function Library:AddKeybind(name, default, callback)
    local KeybindFrame = CreateInstance("Frame", {
        Name = "Keybind_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(KeybindFrame, 8)

    local KeybindLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = KeybindFrame
    })

    local currentKey = default or Enum.KeyCode.F
    
    if self.savedElements and self.savedElements[name] then
        currentKey = Enum.KeyCode[self.savedElements[name]]
    end

    local KeybindButton = CreateInstance("TextButton", {
        Name = "Button",
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(1, -112, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = currentKey.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        AutoButtonColor = false,
        Parent = KeybindFrame
    })
    AddCorner(KeybindButton, 6)

    local listening = false

    KeybindButton.MouseButton1Click:Connect(function()
        listening = true
        KeybindButton.Text = "..."
        KeybindButton.BackgroundColor3 = self.currentTheme.Secondary
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            KeybindButton.Text = currentKey.Name
            KeybindButton.BackgroundColor3 = self.currentTheme.Primary
            listening = false
            self:SaveElementState(name, currentKey.Name)
        elseif not gameProcessed and input.KeyCode == currentKey and callback then
            callback()
        end
    end)

    return {
        SetKey = function(key)
            currentKey = key
            KeybindButton.Text = key.Name
            self:SaveElementState(name, key.Name)
        end
    }
end

-- 8. Color Picker
function Library:AddColorPicker(name, default, callback)
    local ColorFrame = CreateInstance("Frame", {
        Name = "ColorPicker_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(ColorFrame, 8)

    local ColorLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ColorFrame
    })

    local selectedColor = default or Color3.fromRGB(255, 255, 255)
    
    if self.savedElements and self.savedElements[name] then
        local saved = self.savedElements[name]
        selectedColor = Color3.new(saved[1], saved[2], saved[3])
    end

    local ColorDisplay = CreateInstance("TextButton", {
        Name = "Display",
        BackgroundColor3 = selectedColor,
        Size = UDim2.new(0, 40, 0, 26),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = ColorFrame
    })
    AddCorner(ColorDisplay, 6)
    AddStroke(ColorDisplay, Color3.fromRGB(255, 255, 255), 2)

    ColorDisplay.MouseButton1Click:Connect(function()
        -- Implementação simples de color picker
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(0, 0, 0)
        }
        
        local currentIndex = 1
        for i, color in ipairs(colors) do
            if color == selectedColor then
                currentIndex = i
                break
            end
        end
        
        currentIndex = currentIndex % #colors + 1
        selectedColor = colors[currentIndex]
        ColorDisplay.BackgroundColor3 = selectedColor
        
        if callback then
            callback(selectedColor)
        end
        
        self:SaveElementState(name, {selectedColor.R, selectedColor.G, selectedColor.B})
    end)

    return {
        SetColor = function(color)
            selectedColor = color
            ColorDisplay.BackgroundColor3 = color
            self:SaveElementState(name, {color.R, color.G, color.B})
        end
    }
end

-- 9. Paragraph
function Library:AddParagraph(title, content)
    local ParagraphFrame = CreateInstance("Frame", {
        Name = "Paragraph",
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 80),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(ParagraphFrame, 8)

    local ParagraphTitle = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 25),
        Position = UDim2.new(0, 12, 0, 8),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.currentTheme.Primary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ParagraphFrame
    })

    local ParagraphContent = CreateInstance("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 1, -35),
        Position = UDim2.new(0, 12, 0, 30),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ParagraphFrame
    })

    return {
        SetTitle = function(newTitle)
            ParagraphTitle.Text = newTitle
        end,
        SetContent = function(newContent)
            ParagraphContent.Text = newContent
        end
    }
end

-- 10. Divider
function Library:AddDivider(text)
    local DividerFrame = CreateInstance("Frame", {
        Name = "Divider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 30),
        Parent = self.tabs[self.TabName].Content
    })

    local Line1 = CreateInstance("Frame", {
        Name = "Line1",
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(0.35, 0, 0, 2),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Parent = DividerFrame
    })

    local DividerText = CreateInstance("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.25, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Text = text or "",
        TextColor3 = self.currentTheme.Primary,
        TextSize = 12,
        Parent = DividerFrame
    })

    local Line2 = CreateInstance("Frame", {
        Name = "Line2",
        BackgroundColor3 = self.currentTheme.Primary,
        Size = UDim2.new(0.35, 0, 0, 2),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BorderSizePixel = 0,
        Parent = DividerFrame
    })

    return DividerFrame
end

-- 11. Checkbox
function Library:AddCheckbox(name, default, callback)
    local CheckboxFrame = CreateInstance("Frame", {
        Name = "Checkbox_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(CheckboxFrame, 8)

    local CheckboxLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = CheckboxFrame
    })

    local CheckboxButton = CreateInstance("TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -36, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = CheckboxFrame
    })
    AddCorner(CheckboxButton, 4)
    AddStroke(CheckboxButton, self.currentTheme.Primary, 2)

    local CheckMark = CreateInstance("TextLabel", {
        Name = "CheckMark",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "✓",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Visible = false,
        Parent = CheckboxButton
    })

    local checked = default or false
    
    if self.savedElements and self.savedElements[name] ~= nil then
        checked = self.savedElements[name]
    end

    local function UpdateCheckbox(state)
        checked = state
        if checked then
            CheckboxButton.BackgroundColor3 = self.currentTheme.Primary
            CheckMark.Visible = true
        else
            CheckboxButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            CheckMark.Visible = false
        end
        
        if callback then
            callback(checked)
        end
        
        self:SaveElementState(name, checked)
    end

    UpdateCheckbox(checked)

    CheckboxButton.MouseButton1Click:Connect(function()
        UpdateCheckbox(not checked)
    end)

    return {
        SetValue = UpdateCheckbox
    }
end

-- 12. Multi-Dropdown
function Library:AddMultiDropdown(name, options, defaults, callback)
    local MultiDropFrame = CreateInstance("Frame", {
        Name = "MultiDropdown_" .. name,
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(1, -10, 0, 40),
        BorderSizePixel = 0,
        Parent = self.tabs[self.TabName].Content
    })
    AddCorner(MultiDropFrame, 8)

    local MultiDropLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -170, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MultiDropFrame
    })

    local selectedOptions = {}
    for _, opt in ipairs(defaults or {}) do
        selectedOptions[opt] = true
    end
    
    if self.savedElements and self.savedElements[name] then
        selectedOptions = self.savedElements[name]
    end

    local MultiDropButton = CreateInstance("TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(0, 150, 0, 30),
        Position = UDim2.new(1, -162, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = "Select...",
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = MultiDropFrame
    })
    AddCorner(MultiDropButton, 6)

    local Arrow = CreateInstance("TextLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = "▼",
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 10,
        Parent = MultiDropButton
    })

    local MultiDropList = CreateInstance("ScrollingFrame", {
        Name = "List",
        BackgroundColor3 = self.currentTheme.ElementBG,
        Size = UDim2.new(0, 150, 0, 0),
        Position = UDim2.new(1, -162, 1, 5),
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.currentTheme.Primary,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = MultiDropFrame
    })
    AddCorner(MultiDropList, 6)
    AddStroke(MultiDropList, self.currentTheme.Primary, 1)

    local ListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = MultiDropList
    })

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        MultiDropList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    end)

    local isOpen = false

    local function UpdateButtonText()
        local count = 0
        for _ in pairs(selectedOptions) do
            count = count + 1
        end
        
        if count == 0 then
            MultiDropButton.Text = "Select..."
        elseif count == 1 then
            for opt in pairs(selectedOptions) do
                MultiDropButton.Text = opt
                break
            end
        else
            MultiDropButton.Text = count .. " Selected"
        end
    end

    UpdateButtonText()

    MultiDropButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            MultiDropList.Visible = true
            Tween(MultiDropList, {Size = UDim2.new(0, 150, 0, math.min(#options * 32, 150))}, 0.2)
            Tween(Arrow, {Rotation = 180}, 0.2)
        else
            Tween(MultiDropList, {Size = UDim2.new(0, 150, 0, 0)}, 0.2)
            Tween(Arrow, {Rotation = 0}, 0.2)
            wait(0.2)
            MultiDropList.Visible = false
        end
    end)

    for _, option in ipairs(options) do
        local OptionFrame = CreateInstance("Frame", {
            Name = option,
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            Size = UDim2.new(1, 0, 0, 30),
            BorderSizePixel = 0,
            Parent = MultiDropList
        })
        AddCorner(OptionFrame, 4)

        local OptionCheck = CreateInstance("TextButton", {
            Name = "Check",
            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 6, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = OptionFrame
        })
        AddCorner(OptionCheck, 3)

        local CheckMark = CreateInstance("TextLabel", {
            Name = "Mark",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "✓",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Visible = selectedOptions[option] or false,
            Parent = OptionCheck
        })

        if selectedOptions[option] then
            OptionCheck.BackgroundColor3 = self.currentTheme.Primary
        end

        local OptionLabel = CreateInstance("TextButton", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            Font = Enum.Font.Gotham,
            Text = option,
            TextColor3 = self.currentTheme.TextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = OptionFrame
        })

        local function ToggleOption()
            selectedOptions[option] = not selectedOptions[option]
            
            if selectedOptions[option] then
                OptionCheck.BackgroundColor3 = self.currentTheme.Primary
                CheckMark.Visible = true
            else
                OptionCheck.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                CheckMark.Visible = false
                selectedOptions[option] = nil
            end
            
            UpdateButtonText()
            
            if callback then
                callback(selectedOptions)
            end
            
            self:SaveElementState(name, selectedOptions)
        end

        OptionCheck.MouseButton1Click:Connect(ToggleOption)
        OptionLabel.MouseButton1Click:Connect(ToggleOption)

        OptionFrame.MouseEnter:Connect(function()
            Tween(OptionFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}, 0.1)
        end)

        OptionFrame.MouseLeave:Connect(function()
            Tween(OptionFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.1)
        end)
    end

    return {
        SetValue = function(opts)
            selectedOptions = {}
            for _, opt in ipairs(opts) do
                selectedOptions[opt] = true
            end
            UpdateButtonText()
            self:SaveElementState(name, selectedOptions)
        end
    }
end

-- Config Tab
function Library:AddConfig()
    local ConfigTab = self:AddTab("⚙️ Config", "")
    
    -- Theme Selector
    local themeNames = {}
    for name in pairs(Themes) do
        table.insert(themeNames, name)
    end
    
    ConfigTab:AddDropdown("Theme", themeNames, "Cyberpunk Neon", function(theme)
        self:SetTheme(theme)
    end)
    
    -- Background Opacity Toggle
    ConfigTab:AddToggle("Background Transparency", false, function(enabled)
        if enabled then
            Tween(self.MainFrame, {BackgroundTransparency = 0.4}, 0.3)
        else
            Tween(self.MainFrame, {BackgroundTransparency = 0}, 0.3)
        end
        
        if self.config.AutoSaveLoad then
            local savedConfig = self:LoadConfig(self.config.ConfigFileName) or {}
            savedConfig.BackgroundOpacity = enabled
            self:SaveConfig(savedConfig, self.config.ConfigFileName)
        end
    end)
    
    -- Auto Save/Load Toggle
    ConfigTab:AddToggle("Auto Save & Load", self.config.AutoSaveLoad, function(enabled)
        self.config.AutoSaveLoad = enabled
    end)
    
    ConfigTab:AddDivider("Actions")
    
    -- Save Config Button
    ConfigTab:AddButton("Save Configuration", function()
        self:SaveAllConfigs()
        
        local notification = self:CreateNotification("Success", "Configuration saved!", 2)
    end)
    
    -- Load Config Button
    ConfigTab:AddButton("Load Configuration", function()
        self:LoadAllConfigs()
        
        local notification = self:CreateNotification("Success", "Configuration loaded!", 2)
    end)
    
    -- Reset Config Button
    ConfigTab:AddButton("Reset to Default", function()
        self:CreateConfirmDialog("Reset all settings to default?", function(confirmed)
            if confirmed then
                if isfile(self.config.ConfigFileName) then
                    delfile(self.config.ConfigFileName)
                end
                
                local notification = self:CreateNotification("Reset", "Settings reset to default!", 2)
            end
        end)
    end)
end

-- Funções de Tema
function Library:SetTheme(themeName)
    if not Themes[themeName] then return end
    
    self.currentTheme = Themes[themeName]
    
    -- Atualizar cores dos componentes principais
    if self.MainFrame then
        self.MainFrame.BackgroundColor3 = self.currentTheme.Background
        
        for _, child in ipairs(self.MainFrame:GetDescendants()) do
            if child.Name == "Topbar" or child.Name == "TabContainer" then
                child.BackgroundColor3 = self.currentTheme.Topbar
            elseif child:IsA("UIStroke") then
                child.Color = self.currentTheme.Primary
            end
        end
    end
    
    -- Salvar tema
    if self.config.AutoSaveLoad then
        local savedConfig = self:LoadConfig(self.config.ConfigFileName) or {}
        savedConfig.Theme = themeName
        self:SaveConfig(savedConfig, self.config.ConfigFileName)
    end
end

-- Save/Load de elementos
function Library:SaveElementState(name, value)
    if not self.config.AutoSaveLoad then return end
    
    local savedConfig = self:LoadConfig(self.config.ConfigFileName) or {}
    savedConfig.Elements = savedConfig.Elements or {}
    savedConfig.Elements[name] = value
    self:SaveConfig(savedConfig, self.config.ConfigFileName)
end

function Library:SaveAllConfigs()
    if not self.config.AutoSaveLoad then return end
    
    local configData = {
        Theme = self.currentTheme,
        Elements = self.savedElements or {},
        BackgroundOpacity = self.MainFrame.BackgroundTransparency > 0
    }
    
    self:SaveConfig(configData, self.config.ConfigFileName)
end

function Library:LoadAllConfigs()
    if not self.config.AutoSaveLoad then return end
    
    local savedConfig = self:LoadConfig(self.config.ConfigFileName)
    if savedConfig then
        self.savedElements = savedConfig.Elements or {}
        
        if savedConfig.Theme then
            self:SetTheme(savedConfig.Theme)
        end
        
        if savedConfig.BackgroundOpacity ~= nil then
            self.MainFrame.BackgroundTransparency = savedConfig.BackgroundOpacity and 0.4 or 0
        end
    end
end

-- Notificações
function Library:CreateNotification(title, message, duration)
    local NotificationGui = CreateInstance("ScreenGui", {
        Name = "Notification",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local NotificationFrame = CreateInstance("Frame", {
        Name = "NotificationFrame",
        BackgroundColor3 = self.currentTheme.Background,
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 320, 1, -100),
        AnchorPoint = Vector2.new(0, 1),
        BorderSizePixel = 0,
        Parent = NotificationGui
    })
    AddCorner(NotificationFrame, 10)
    AddStroke(NotificationFrame, self.currentTheme.Primary, 2)

    local NotifTitle = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 10),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.currentTheme.Primary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NotificationFrame
    })

    local NotifMessage = CreateInstance("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 35),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = self.currentTheme.TextColor,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = NotificationFrame
    })

    Tween(NotificationFrame, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back)

    spawn(function()
        wait(duration or 3)
        Tween(NotificationFrame, {Position = UDim2.new(1, 320, 1, -100)}, 0.3)
        wait(0.3)
        NotificationGui:Destroy()
    end)

    return NotificationGui
end

-- Função principal para criar a Window
function Library:CreateWindow(config)
    self.config = setmetatable(config or {}, {__index = defaultConfig})
    self.currentTheme = Themes["Cyberpunk Neon"]
    self.savedElements = {}

    -- Sistema de Key
    if self.config.KeyEnable then
        local keyValid = false
        
        if self.config.KeySave and self.config.AutoLoadKey then
            local savedKey = self:LoadConfig(self.config.KeyFileName)
            if savedKey and savedKey.Valid and savedKey.Key == self.config.Key then
                keyValid = true
            end
        end
        
        if not keyValid then
            self:CreateKeySystem()
            return self
        end
    end

    -- Criar UI diretamente se não precisar de key
    self:CreateLoadingScreen()
    self:InitializeUI()

    return self
end

return Library
