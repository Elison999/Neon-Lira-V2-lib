--[[
    Advanced UI Library for Roblox
    Biblioteca UI completa com sistema de key, loading, auto save/load e mais
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
    ImageId = "rbxassetid://0",
    AutoSaveLoad = true
}

-- Temas disponíveis
local Themes = {
    Default = {
        Primary = Color3.fromRGB(45, 45, 45),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(60, 60, 60)
    },
    Dark = {
        Primary = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(240, 240, 240),
        Border = Color3.fromRGB(40, 40, 50)
    },
    Blue = {
        Primary = Color3.fromRGB(30, 40, 60),
        Secondary = Color3.fromRGB(20, 30, 50),
        Accent = Color3.fromRGB(50, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(50, 60, 80)
    },
    Red = {
        Primary = Color3.fromRGB(60, 30, 30),
        Secondary = Color3.fromRGB(50, 20, 20),
        Accent = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(80, 40, 40)
    },
    Green = {
        Primary = Color3.fromRGB(25, 50, 35),
        Secondary = Color3.fromRGB(20, 40, 30),
        Accent = Color3.fromRGB(80, 200, 120),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(35, 70, 50)
    },
    Purple = {
        Primary = Color3.fromRGB(50, 30, 60),
        Secondary = Color3.fromRGB(40, 20, 50),
        Accent = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(70, 40, 80)
    },
    Orange = {
        Primary = Color3.fromRGB(60, 40, 25),
        Secondary = Color3.fromRGB(50, 30, 20),
        Accent = Color3.fromRGB(255, 150, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(80, 55, 35)
    },
    Pink = {
        Primary = Color3.fromRGB(60, 30, 50),
        Secondary = Color3.fromRGB(50, 20, 40),
        Accent = Color3.fromRGB(255, 100, 180),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(80, 40, 70)
    },
    Cyan = {
        Primary = Color3.fromRGB(25, 50, 55),
        Secondary = Color3.fromRGB(20, 40, 45),
        Accent = Color3.fromRGB(80, 220, 230),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(35, 70, 75)
    },
    Yellow = {
        Primary = Color3.fromRGB(60, 55, 25),
        Secondary = Color3.fromRGB(50, 45, 20),
        Accent = Color3.fromRGB(255, 220, 80),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(80, 75, 35)
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

local function MakeDraggable(frame, dragFrame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragFrame.InputBegan:Connect(function(input)
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
    
    dragFrame.InputChanged:Connect(function(input)
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

-- Sistema de salvamento
local function SaveConfig(fileName, data)
    if not isfolder("UILibraryConfigs") then
        makefolder("UILibraryConfigs")
    end
    writefile("UILibraryConfigs/" .. fileName, HttpService:JSONEncode(data))
end

local function LoadConfig(fileName)
    if isfile("UILibraryConfigs/" .. fileName) then
        return HttpService:JSONDecode(readfile("UILibraryConfigs/" .. fileName))
    end
    return nil
end

-- Criar Window
function Library:CreateWindow(config)
    local self = setmetatable({}, {__index = Library})
    
    -- Merge configurações
    self.Config = {}
    for k, v in pairs(DefaultConfig) do
        self.Config[k] = config[k] ~= nil and config[k] or v
    end
    self.Config.Name = config.Name or "UI Library"
    
    self.Tabs = {}
    self.Elements = {}
    self.SaveData = {}
    self.CurrentTheme = Themes.Default
    self.BackgroundTransparency = false
    
    -- Carregar configuração salva
    if self.Config.AutoSaveLoad then
        local savedData = LoadConfig(self.Config.Name .. "_Config.json")
        if savedData then
            self.SaveData = savedData
        end
    end
    
    -- Criar ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "UILibrary",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Sistema de Loading
    if self.Config.LoadingName then
        self:ShowLoading()
    end
    
    -- Sistema de Key
    if self.Config.KeyEnable then
        task.spawn(function()
            self:ShowKeySystem()
        end)
        return self
    end
    
    -- Criar UI principal
    self:CreateMainUI()
    
    return self
end

-- Sistema de Loading
function Library:ShowLoading()
    local LoadingFrame = CreateInstance("Frame", {
        Name = "LoadingFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -200, 0.5, -100),
        Size = UDim2.new(0, 400, 0, 200),
        ZIndex = 100
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = LoadingFrame
    })
    
    if self.Config.ImageId and self.Config.ImageId ~= "rbxassetid://0" then
        CreateInstance("ImageLabel", {
            Parent = LoadingFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -50, 0.2, 0),
            Size = UDim2.new(0, 100, 0, 100),
            Image = self.Config.ImageId,
            ScaleType = Enum.ScaleType.Fit
        })
    end
    
    CreateInstance("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.65, 0),
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = self.Config.LoadingName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    local ProgressBar = CreateInstance("Frame", {
        Parent = LoadingFrame,
        BackgroundColor3 = Color3.fromRGB(100, 200, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0.85, 0),
        Size = UDim2.new(0, 0, 0, 4)
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ProgressBar
    })
    
    -- Animar barra de progresso
    Tween(ProgressBar, {Size = UDim2.new(0.8, 0, 0, 4)}, 2)
    
    task.wait(2)
    LoadingFrame:Destroy()
end

-- Sistema de Key
function Library:ShowKeySystem()
    local KeyFrame = CreateInstance("Frame", {
        Name = "KeyFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -200, 0.5, -150),
        Size = UDim2.new(0, 400, 0, 300),
        ZIndex = 100
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = KeyFrame
    })
    
    CreateInstance("TextLabel", {
        Parent = KeyFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.05, 0),
        Size = UDim2.new(1, 0, 0, 40),
        Font = Enum.Font.GothamBold,
        Text = self.Config.KeyName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })
    
    if self.Config.ImageId and self.Config.ImageId ~= "rbxassetid://0" then
        CreateInstance("ImageLabel", {
            Parent = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -40, 0.2, 0),
            Size = UDim2.new(0, 80, 0, 80),
            Image = self.Config.ImageId,
            ScaleType = Enum.ScaleType.Fit
        })
    end
    
    local KeyInput = CreateInstance("TextBox", {
        Parent = KeyFrame,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0.55, 0),
        Size = UDim2.new(0.8, 0, 0, 40),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter Key...",
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = KeyInput
    })
    
    local function CheckKey(inputKey)
        local correctKey = self.Config.Key
        
        if self.Config.GetKeyFromSite and self.Config.KeySite ~= "" then
            local success, result = pcall(function()
                return game:HttpGet(self.Config.KeySite)
            end)
            if success then
                correctKey = result:gsub("%s+", "")
            end
        end
        
        return inputKey == correctKey
    end
    
    local SubmitButton = CreateInstance("TextButton", {
        Parent = KeyFrame,
        BackgroundColor3 = Color3.fromRGB(100, 200, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0.72, 0),
        Size = UDim2.new(0.8, 0, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "Submit",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = SubmitButton
    })
    
    -- Verificar key salva
    if self.Config.KeySave then
        local savedKey = LoadConfig(self.Config.KeyFileName)
        if savedKey and CheckKey(savedKey.key) then
            KeyFrame:Destroy()
            self:CreateMainUI()
            return
        end
    end
    
    SubmitButton.MouseButton1Click:Connect(function()
        if CheckKey(KeyInput.Text) then
            if self.Config.KeySave then
                SaveConfig(self.Config.KeyFileName, {key = KeyInput.Text})
            end
            KeyFrame:Destroy()
            self:CreateMainUI()
        else
            Tween(KeyInput, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
            task.wait(0.5)
            Tween(KeyInput, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
        end
    end)
    
    if self.Config.KeySite ~= "" then
        local GetKeyButton = CreateInstance("TextButton", {
            Parent = KeyFrame,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            BorderSizePixel = 0,
            Position = UDim2.new(0.1, 0, 0.87, 0),
            Size = UDim2.new(0.8, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = "Get Key",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = GetKeyButton
        })
        
        GetKeyButton.MouseButton1Click:Connect(function()
            setclipboard(self.Config.KeySite)
        end)
    end
end

-- Criar UI Principal
function Library:CreateMainUI()
    -- Main Frame
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = self.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -350, 0.5, -250),
        Size = UDim2.new(0, 700, 0, 500),
        ClipsDescendants = true
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = self.MainFrame
    })
    
    -- Topbar
    self.Topbar = CreateInstance("Frame", {
        Name = "Topbar",
        Parent = self.MainFrame,
        BackgroundColor3 = self.CurrentTheme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = self.Topbar
    })
    
    -- Logo/Imagem
    if self.Config.ImageId and self.Config.ImageId ~= "rbxassetid://0" then
        CreateInstance("ImageLabel", {
            Parent = self.Topbar,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = self.Config.ImageId,
            ScaleType = Enum.ScaleType.Fit
        })
    end
    
    -- Título
    CreateInstance("TextLabel", {
        Parent = self.Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = self.Config.Name,
        TextColor3 = self.CurrentTheme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Botões do topbar
    local buttonSize = 30
    local buttonPadding = 5
    
    -- Botão Fechar
    local CloseButton = CreateInstance("TextButton", {
        Parent = self.Topbar,
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -(buttonSize + buttonPadding), 0.5, -buttonSize/2),
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseButton
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        self:ShowCloseConfirmation()
    end)
    
    -- Botão Minimizar
    local MinimizeButton = CreateInstance("TextButton", {
        Parent = self.Topbar,
        BackgroundColor3 = Color3.fromRGB(255, 200, 80),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -(buttonSize * 2 + buttonPadding * 2), 0.5, -buttonSize/2),
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MinimizeButton
    })
    
    self.Minimized = false
    self.OriginalSize = self.MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            Tween(self.MainFrame, {Size = UDim2.new(0, 700, 0, 40)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(self.MainFrame, {Size = self.OriginalSize}, 0.3)
            MinimizeButton.Text = "-"
        end
    end)
    
    -- Botão Resize
    local ResizeButton = CreateInstance("TextButton", {
        Parent = self.Topbar,
        BackgroundColor3 = Color3.fromRGB(100, 200, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -(buttonSize * 3 + buttonPadding * 3), 0.5, -buttonSize/2),
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        Font = Enum.Font.GothamBold,
        Text = "⇄",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = ResizeButton
    })
    
    self.Resized = false
    
    ResizeButton.MouseButton1Click:Connect(function()
        self.Resized = not self.Resized
        if self.Resized then
            Tween(self.MainFrame, {Size = UDim2.new(0, 900, 0, 600)}, 0.3)
        else
            Tween(self.MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
        end
    end)
    
    -- Fazer topbar arrastável
    MakeDraggable(self.MainFrame, self.Topbar)
    
    -- Container de Tabs
    self.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = self.MainFrame,
        BackgroundColor3 = self.CurrentTheme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40)
    })
    
    -- Container de Conteúdo
    self.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -150, 1, -40)
    })
    
    CreateInstance("UIListLayout", {
        Parent = self.TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    CreateInstance("UIPadding", {
        Parent = self.TabContainer,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
end

-- Confirmação de fechar
function Library:ShowCloseConfirmation()
    local ConfirmFrame = CreateInstance("Frame", {
        Name = "ConfirmFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 2,
        BorderColor3 = self.CurrentTheme.Accent,
        Position = UDim2.new(0.5, -150, 0.5, -75),
        Size = UDim2.new(0, 300, 0, 150),
        ZIndex = 200
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = ConfirmFrame
    })
    
    CreateInstance("TextLabel", {
        Parent = ConfirmFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.1, 0),
        Size = UDim2.new(1, 0, 0.4, 0),
        Font = Enum.Font.GothamBold,
        Text = "Close UI?",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })
    
    local YesButton = CreateInstance("TextButton", {
        Parent = ConfirmFrame,
        BackgroundColor3 = Color3.fromRGB(100, 200, 100),
        BorderSizePixel = 0,
        Position = UDim2.new(0.55, 0, 0.6, 0),
        Size = UDim2.new(0.35, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "Yes",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = YesButton
    })
    
    local CancelButton = CreateInstance("TextButton", {
        Parent = ConfirmFrame,
        BackgroundColor3 = Color3.fromRGB(200, 100, 100),
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0.6, 0),
        Size = UDim2.new(0.35, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "Cancel",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CancelButton
    })
    
    YesButton.MouseButton1Click:Connect(function()
        if self.Config.AutoSaveLoad then
            SaveConfig(self.Config.Name .. "_Config.json", self.SaveData)
        end
        self.ScreenGui:Destroy()
    end)
    
    CancelButton.MouseButton1Click:Connect(function()
        ConfirmFrame:Destroy()
    end)
end

-- Aplicar tema
function Library:ApplyTheme(themeName)
    if Themes[themeName] then
        self.CurrentTheme = Themes[themeName]
        
        self.MainFrame.BackgroundColor3 = self.CurrentTheme.Primary
        self.Topbar.BackgroundColor3 = self.CurrentTheme.Secondary
        self.TabContainer.BackgroundColor3 = self.CurrentTheme.Secondary
        
        for _, tab in pairs(self.Tabs) do
            if tab.Button then
                if tab.Selected then
                    tab.Button.BackgroundColor3 = self.CurrentTheme.Accent
                else
                    tab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end
            end
        end
    end
end

-- Criar Tab
function Library:CreateTab(name)
    local Tab = {}
    Tab.Name = name
    Tab.Elements = {}
    Tab.Selected = false
    
    -- Botão da Tab
    Tab.Button = CreateInstance("TextButton", {
        Name = name,
        Parent = self.TabContainer,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 35),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = self.CurrentTheme.Text,
        TextSize = 14
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Tab.Button
    })
    
    -- Container de conteúdo da tab
    Tab.Container = CreateInstance("ScrollingFrame", {
        Name = name .. "Content",
        Parent = self.ContentContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        Visible = false
    })
    
    CreateInstance("UIListLayout", {
        Parent = Tab.Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    CreateInstance("UIPadding", {
        Parent = Tab.Container,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })
    
    -- Auto-resize canvas
    Tab.Container.ChildAdded:Connect(function()
        task.wait()
        local contentSize = Tab.Container.UIListLayout.AbsoluteContentSize
        Tab.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end)
    
    Tab.Button.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Selected = false
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        
        Tab.Selected = true
        Tab.Container.Visible = true
        Tab.Button.BackgroundColor3 = self.CurrentTheme.Accent
    end)
    
    -- Se é a primeira tab, selecionar automaticamente
    if #self.Tabs == 0 then
        Tab.Selected = true
        Tab.Container.Visible = true
        Tab.Button.BackgroundColor3 = self.CurrentTheme.Accent
    end
    
    table.insert(self.Tabs, Tab)
    
    -- Funções de elementos
    function Tab:AddButton(config)
        local Button = CreateInstance("TextButton", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35),
            Font = Enum.Font.Gotham,
            Text = config.Name or "Button",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = Button
        })
        
        Button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
        end)
        
        return Button
    end
    
    function Tab:AddToggle(config)
        local ToggleFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ToggleFrame
        })
        
        CreateInstance("TextLabel", {
            Parent = ToggleFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.7, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = config.Name or "Toggle",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local ToggleButton = CreateInstance("TextButton", {
            Parent = ToggleFrame,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            BorderSizePixel = 0,
            Position = UDim2.new(1, -55, 0.5, -12),
            Size = UDim2.new(0, 45, 0, 24),
            Text = ""
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleButton
        })
        
        local ToggleIndicator = CreateInstance("Frame", {
            Parent = ToggleButton,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 2, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleIndicator
        })
        
        local toggled = config.Default or false
        
        -- Carregar valor salvo
        local saveKey = "Toggle_" .. config.Name
        if self.SaveData[saveKey] ~= nil then
            toggled = self.SaveData[saveKey]
        end
        
        local function UpdateToggle()
            if toggled then
                Tween(ToggleButton, {BackgroundColor3 = self.CurrentTheme.Accent}, 0.2)
                Tween(ToggleIndicator, {Position = UDim2.new(1, -22, 0.5, -10)}, 0.2)
            else
                Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
                Tween(ToggleIndicator, {Position = UDim2.new(0, 2, 0.5, -10)}, 0.2)
            end
            
            if self.Config.AutoSaveLoad then
                self.SaveData[saveKey] = toggled
            end
            
            if config.Callback then
                config.Callback(toggled)
            end
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            UpdateToggle()
        end)
        
        UpdateToggle()
        
        return ToggleFrame
    end
    
    function Tab:AddSlider(config)
        local SliderFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 50)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = SliderFrame
        })
        
        local Title = CreateInstance("TextLabel", {
            Parent = SliderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(0.7, 0, 0, 20),
            Font = Enum.Font.Gotham,
            Text = config.Name or "Slider",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local ValueLabel = CreateInstance("TextLabel", {
            Parent = SliderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.7, 0, 0, 5),
            Size = UDim2.new(0.3, -10, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = tostring(config.Default or config.Min or 0),
            TextColor3 = self.CurrentTheme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        
        local SliderBack = CreateInstance("Frame", {
            Parent = SliderFrame,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 1, -18),
            Size = UDim2.new(1, -20, 0, 6)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SliderBack
        })
        
        local SliderFill = CreateInstance("Frame", {
            Parent = SliderBack,
            BackgroundColor3 = self.CurrentTheme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SliderFill
        })
        
        local min = config.Min or 0
        local max = config.Max or 100
        local value = config.Default or min
        
        -- Carregar valor salvo
        local saveKey = "Slider_" .. config.Name
        if self.SaveData[saveKey] ~= nil then
            value = self.SaveData[saveKey]
        end
        
        local function UpdateSlider(val)
            value = math.clamp(val, min, max)
            local percent = (value - min) / (max - min)
            
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = tostring(math.floor(value))
            
            if self.Config.AutoSaveLoad then
                self.SaveData[saveKey] = value
            end
            
            if config.Callback then
                config.Callback(value)
            end
        end
        
        local dragging = false
        
        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local percent = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                UpdateSlider(min + (max - min) * percent)
            end
        end)
        
        SliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                UpdateSlider(min + (max - min) * percent)
            end
        end)
        
        UpdateSlider(value)
        
        return SliderFrame
    end
    
    function Tab:AddDropdown(config)
        local DropdownFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35),
            ClipsDescendants = true
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = DropdownFrame
        })
        
        local DropdownButton = CreateInstance("TextButton", {
            Parent = DropdownFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.Gotham,
            Text = config.Name .. ": " .. (config.Default or "None"),
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14
        })
        
        local OptionsContainer = CreateInstance("Frame", {
            Parent = DropdownFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 35),
            Size = UDim2.new(1, 0, 0, 0)
        })
        
        CreateInstance("UIListLayout", {
            Parent = OptionsContainer,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2)
        })
        
        local open = false
        local selected = config.Default or "None"
        
        -- Carregar valor salvo
        local saveKey = "Dropdown_" .. config.Name
        if self.SaveData[saveKey] ~= nil then
            selected = self.SaveData[saveKey]
            DropdownButton.Text = config.Name .. ": " .. selected
        end
        
        for _, option in ipairs(config.Options or {}) do
            local OptionButton = CreateInstance("TextButton", {
                Parent = OptionsContainer,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = option,
                TextColor3 = self.CurrentTheme.Text,
                TextSize = 13
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = OptionButton
            })
            
            OptionButton.MouseButton1Click:Connect(function()
                selected = option
                DropdownButton.Text = config.Name .. ": " .. selected
                open = false
                Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 35)}, 0.2)
                
                if self.Config.AutoSaveLoad then
                    self.SaveData[saveKey] = selected
                end
                
                if config.Callback then
                    config.Callback(selected)
                end
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            open = not open
            if open then
                local optionsCount = #(config.Options or {})
                Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 35 + (optionsCount * 32))}, 0.2)
            else
                Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 35)}, 0.2)
            end
        end)
        
        -- Callback inicial
        if config.Callback then
            config.Callback(selected)
        end
        
        return DropdownFrame
    end
    
    function Tab:AddTextbox(config)
        local TextboxFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TextboxFrame
        })
        
        local Textbox = CreateInstance("TextBox", {
            Parent = TextboxFrame,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(1, -10, 1, -10),
            Font = Enum.Font.Gotham,
            PlaceholderText = config.Placeholder or config.Name or "Enter text...",
            Text = config.Default or "",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = Textbox
        })
        
        -- Carregar valor salvo
        local saveKey = "Textbox_" .. config.Name
        if self.SaveData[saveKey] ~= nil then
            Textbox.Text = self.SaveData[saveKey]
        end
        
        Textbox.FocusLost:Connect(function()
            if self.Config.AutoSaveLoad then
                self.SaveData[saveKey] = Textbox.Text
            end
            
            if config.Callback then
                config.Callback(Textbox.Text)
            end
        end)
        
        return TextboxFrame
    end
    
    function Tab:AddLabel(config)
        local Label = CreateInstance("TextLabel", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35),
            Font = Enum.Font.Gotham,
            Text = config.Text or "Label",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = Label
        })
        
        return Label
    end
    
    function Tab:AddKeybind(config)
        local KeybindFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = KeybindFrame
        })
        
        CreateInstance("TextLabel", {
            Parent = KeybindFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.6, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = config.Name or "Keybind",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local KeyButton = CreateInstance("TextButton", {
            Parent = KeybindFrame,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Position = UDim2.new(0.65, 0, 0.15, 0),
            Size = UDim2.new(0.3, 0, 0.7, 0),
            Font = Enum.Font.GothamBold,
            Text = config.Default and config.Default.Name or "None",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 12
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = KeyButton
        })
        
        local currentKey = config.Default
        local binding = false
        
        -- Carregar valor salvo
        local saveKey = "Keybind_" .. config.Name
        if self.SaveData[saveKey] ~= nil then
            currentKey = Enum.KeyCode[self.SaveData[saveKey]]
            if currentKey then
                KeyButton.Text = currentKey.Name
            end
        end
        
        KeyButton.MouseButton1Click:Connect(function()
            binding = true
            KeyButton.Text = "..."
        end)
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if binding then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeyButton.Text = currentKey.Name
                    binding = false
                    
                    if self.Config.AutoSaveLoad then
                        self.SaveData[saveKey] = currentKey.Name
                    end
                end
            elseif currentKey and input.KeyCode == currentKey and not gameProcessed then
                if config.Callback then
                    config.Callback()
                end
            end
        end)
        
        return KeybindFrame
    end
    
    function Tab:AddColorPicker(config)
        local ColorFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ColorFrame
        })
        
        CreateInstance("TextLabel", {
            Parent = ColorFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.7, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = config.Name or "Color Picker",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local ColorDisplay = CreateInstance("Frame", {
            Parent = ColorFrame,
            BackgroundColor3 = config.Default or Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 2,
            BorderColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(1, -45, 0.5, -12),
            Size = UDim2.new(0, 35, 0, 24)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ColorDisplay
        })
        
        -- Carregar valor salvo
        local saveKey = "ColorPicker_" .. config.Name
        if self.SaveData[saveKey] ~= nil then
            local savedColor = self.SaveData[saveKey]
            ColorDisplay.BackgroundColor3 = Color3.new(savedColor[1], savedColor[2], savedColor[3])
        end
        
        local ColorButton = CreateInstance("TextButton", {
            Parent = ColorDisplay,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = ""
        })
        
        ColorButton.MouseButton1Click:Connect(function()
            -- Implementação simplificada
            local randomColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            ColorDisplay.BackgroundColor3 = randomColor
            
            if self.Config.AutoSaveLoad then
                self.SaveData[saveKey] = {randomColor.R, randomColor.G, randomColor.B}
            end
            
            if config.Callback then
                config.Callback(randomColor)
            end
        end)
        
        return ColorFrame
    end
    
    function Tab:AddParagraph(config)
        local ParagraphFrame = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = self.CurrentTheme.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 70)
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ParagraphFrame
        })
        
        CreateInstance("TextLabel", {
            Parent = ParagraphFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = config.Title or "Title",
            TextColor3 = self.CurrentTheme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        CreateInstance("TextLabel", {
            Parent = ParagraphFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 1, -30),
            Font = Enum.Font.Gotham,
            Text = config.Content or "Content",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        return ParagraphFrame
    end
    
    function Tab:AddSection(name)
        local Section = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 30)
        })
        
        CreateInstance("TextLabel", {
            Parent = Section,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = self.CurrentTheme.Accent,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local Line = CreateInstance("Frame", {
            Parent = Section,
            BackgroundColor3 = self.CurrentTheme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2)
        })
        
        return Section
    end
    
    function Tab:AddDivider()
        local Divider = CreateInstance("Frame", {
            Parent = Tab.Container,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 1)
        })
        
        return Divider
    end
    
    return Tab
end

-- Tab de configuração
function Library:AddConfig()
    local ConfigTab = self:CreateTab("⚙️ Config")
    
    ConfigTab:AddSection("Theme Settings")
    
    ConfigTab:AddDropdown({
        Name = "Theme",
        Options = {"Default", "Dark", "Blue", "Red", "Green", "Purple", "Orange", "Pink", "Cyan", "Yellow"},
        Default = "Default",
        Callback = function(value)
            self:ApplyTheme(value)
        end
    })
    
    ConfigTab:AddToggle({
        Name = "Background Transparency",
        Default = self.BackgroundTransparency,
        Callback = function(value)
            self.BackgroundTransparency = value
            if value then
                self.MainFrame.BackgroundTransparency = 0.4
            else
                self.MainFrame.BackgroundTransparency = 0
            end
        end
    })
    
    ConfigTab:AddDivider()
    
    ConfigTab:AddSection("Save Settings")
    
    ConfigTab:AddToggle({
        Name = "Auto Save & Load",
        Default = self.Config.AutoSaveLoad,
        Callback = function(value)
            self.Config.AutoSaveLoad = value
        end
    })
    
    ConfigTab:AddButton({
        Name = "Save Configuration",
        Callback = function()
            SaveConfig(self.Config.Name .. "_Config.json", self.SaveData)
        end
    })
    
    ConfigTab:AddButton({
        Name = "Load Configuration",
        Callback = function()
            local loaded = LoadConfig(self.Config.Name .. "_Config.json")
            if loaded then
                self.SaveData = loaded
                -- Recarregar UI (simplificado)
            end
        end
    })
    
    ConfigTab:AddButton({
        Name = "Reset Configuration",
        Callback = function()
            self.SaveData = {}
            SaveConfig(self.Config.Name .. "_Config.json", {})
        end
    })
    
    return ConfigTab
end

return Library

