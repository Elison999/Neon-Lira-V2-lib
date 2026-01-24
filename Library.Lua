--[[
    NEON LIB - PART 1/4
    Setup, Assets, Utilities, Loading & Key System
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Open = true,
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(0, 255, 170), -- Neon Green/Cyan default
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Elements = Color3.fromRGB(35, 35, 40)
    },
    Icons = {
        Logo = "rbxassetid://8485997901", -- Loading Icon solicitado
        Home = "rbxassetid://131948203611073",
        Minimize = "rbxassetid://116382519234568",
        Close = "rbxassetid://101967696350111",
        Config = "rbxassetid://11308562750",
        Visual = "rbxassetid://16369898474",
        Combat = "rbxassetid://4391741908",
        Store = "rbxassetid://13429538960",
        Crosshair = "rbxassetid://12614416526",
        Map = "rbxassetid://13549782540",
        Player = "rbxassetid://7199219794",
        Misc = "rbxassetid://114882667336771"
    }
}

-- Proteger a UI contra detecção simples e colocar no CoreGui se possível
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonLib_" .. tostring(math.random(1000, 9999))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- --- UTILITIES ---
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local newPos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15), {Position = newPos}):Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local function CreateRipple(btn)
    spawn(function()
        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 1.000
        ripple.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ripple.BorderSizePixel = 0
        ripple.Image = "rbxassetid://2708891598"
        ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ripple.ImageTransparency = 0.800
        ripple.Parent = btn
        
        -- Logic to position ripple at mouse/touch
        -- (Simplificado para o centro para Mobile/PC compatibility generic)
        ripple.Position = UDim2.new(0.5, -25, 0.5, -25) 
        ripple.Size = UDim2.new(0, 50, 0, 50)

        local tween = TweenService:Create(ripple, TweenInfo.new(0.5), {Size = UDim2.new(1.5,0,1.5,0), ImageTransparency = 1})
        tween:Play()
        tween.Completed:Wait()
        ripple:Destroy()
    end)
end

-- --- KEY & LOADING SYSTEM ---

function Library:Init(Settings)
    Settings = Settings or {}
    local KeyEnable = Settings.KeyEnable or false
    local Key = Settings.Key or "1234"
    local GetKeyFromSite = Settings.GetKeyFromSite or false
    local KeySite = Settings.KeySite or ""
    local KeySave = Settings.KeySave or false
    local LoadingName = Settings.LoadingName or "Neon Lib"
    local FileName = "NeonLib_Key.txt"

    -- Logic to get real key
    local RealKey = Key
    if GetKeyFromSite and KeySite ~= "" then
        pcall(function()
            RealKey = game:HttpGet(KeySite)
            RealKey = string.gsub(RealKey, "\n", ""):gsub(" ", "") -- Limpar espaços
        end)
    end

    -- Check Saved Key
    local SavedKey = ""
    if KeySave and isfile and isfile(FileName) then
        SavedKey = readfile(FileName)
    end

    -- Create Loading/Key UI
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Library.Theme.Background
    LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    LoadingFrame.Size = UDim2.new(0, 300, 0, 200)
    LoadingFrame.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = LoadingFrame

    local LoadingIcon = Instance.new("ImageLabel")
    LoadingIcon.Parent = LoadingFrame
    LoadingIcon.BackgroundTransparency = 1
    LoadingIcon.Position = UDim2.new(0.5, -40, 0.2, 0)
    LoadingIcon.Size = UDim2.new(0, 80, 0, 80)
    LoadingIcon.Image = Library.Icons.Logo

    -- Animation Loading Icon
    spawn(function()
        while LoadingFrame.Parent do
            TweenService:Create(LoadingIcon, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 360}):Play()
            wait(2)
            LoadingIcon.Rotation = 0
        end
    end)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = LoadingFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 0.65, 0)
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextColor3 = Library.Theme.Text
    StatusLabel.TextSize = 18
    StatusLabel.Text = LoadingName

    -- Validation Logic
    local function FinishLoading()
        StatusLabel.Text = "Carregado com Sucesso!"
        wait(1)
        TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        LoadingIcon.ImageTransparency = 1
        StatusLabel.TextTransparency = 1
        wait(0.5)
        LoadingFrame:Destroy()
        -- Call Window Creation (Parte 2)
        if Library.OnLoad then Library.OnLoad() end
    end

    if KeyEnable then
        if KeySave and SavedKey == RealKey then
            StatusLabel.Text = "Chave Salva Encontrada..."
            wait(1)
            FinishLoading()
            return
        end

        -- Key Input UI
        LoadingFrame.Size = UDim2.new(0, 300, 0, 260)
        local KeyBox = Instance.new("TextBox")
        KeyBox.Parent = LoadingFrame
        KeyBox.BackgroundColor3 = Library.Theme.Elements
        KeyBox.Position = UDim2.new(0.1, 0, 0.75, 0)
        KeyBox.Size = UDim2.new(0.6, 0, 0, 35)
        KeyBox.Font = Enum.Font.Gotham
        KeyBox.PlaceholderText = "Digite a Key..."
        KeyBox.Text = ""
        KeyBox.TextColor3 = Library.Theme.Text
        Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

        local EnterBtn = Instance.new("TextButton")
        EnterBtn.Parent = LoadingFrame
        EnterBtn.BackgroundColor3 = Library.Theme.Accent
        EnterBtn.Position = UDim2.new(0.72, 0, 0.75, 0)
        EnterBtn.Size = UDim2.new(0.18, 0, 0, 35)
        EnterBtn.Font = Enum.Font.GothamBold
        EnterBtn.Text = "Entrar"
        EnterBtn.TextColor3 = Color3.new(0,0,0)
        Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 6)

        EnterBtn.MouseButton1Click:Connect(function()
            if KeyBox.Text == RealKey then
                if KeySave and writefile then
                    writefile(FileName, KeyBox.Text)
                end
                KeyBox:Destroy()
                EnterBtn:Destroy()
                FinishLoading()
            else
                KeyBox.Text = "Key Incorreta!"
                wait(1)
                KeyBox.Text = ""
            end
        end)
    else
        wait(2) -- Fake loading
        FinishLoading()
    end
end

--[[
    NEON LIB - PART 2/4
    Main Window, Topbar, Control Buttons & Tab System
]]

function Library:CreateWindow(Config)
    Config = Config or {}
    local TitleText = Config.Title or "Neon Library"
    
    -- State Variables
    local Minimized = false
    local Expanded = false -- Para o botão de resize
    local CurrentTab = nil
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175) -- Centralizado
    MainFrame.Size = UDim2.new(0, 500, 0, 350) -- Tamanho Padrão
    MainFrame.ClipsDescendants = true -- Importante para animações
    MainFrame.Visible = false -- Só aparece após o Loading da Parte 1

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Library.Theme.Header
    MainStroke.Thickness = 1

    -- --- TOPBAR ---
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Library.Theme.Header
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BorderSizePixel = 0
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar

    -- Fix para o canto inferior da topbar ficar reto quando maximizado, mas arredondado em cima
    local FixPatch = Instance.new("Frame")
    FixPatch.Parent = Topbar
    FixPatch.BorderSizePixel = 0
    FixPatch.BackgroundColor3 = Library.Theme.Header
    FixPatch.Size = UDim2.new(1, 0, 0, 10)
    FixPatch.Position = UDim2.new(0, 0, 1, -10)
    FixPatch.ZIndex = 1

    -- Topbar Icon & Title
    local TopbarIcon = Instance.new("ImageLabel")
    TopbarIcon.Parent = Topbar
    TopbarIcon.BackgroundTransparency = 1
    TopbarIcon.Position = UDim2.new(0, 10, 0, 5)
    TopbarIcon.Size = UDim2.new(0, 30, 0, 30)
    TopbarIcon.Image = Library.Icons.Logo
    TopbarIcon.ZIndex = 2

    local TopbarTitle = Instance.new("TextLabel")
    TopbarTitle.Parent = Topbar
    TopbarTitle.BackgroundTransparency = 1
    TopbarTitle.Position = UDim2.new(0, 50, 0, 0)
    TopbarTitle.Size = UDim2.new(0, 200, 1, 0)
    TopbarTitle.Font = Enum.Font.GothamBold
    TopbarTitle.Text = TitleText
    TopbarTitle.TextColor3 = Library.Theme.Text
    TopbarTitle.TextSize = 16
    TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopbarTitle.ZIndex = 2

    -- Make UI Draggable via Topbar
    MakeDraggable(Topbar, MainFrame)

    -- --- CONTROL BUTTONS CONTAINER ---
    local ControlsHolder = Instance.new("Frame")
    ControlsHolder.Parent = Topbar
    ControlsHolder.BackgroundTransparency = 1
    ControlsHolder.Position = UDim2.new(1, -100, 0, 0)
    ControlsHolder.Size = UDim2.new(0, 100, 1, 0)
    ControlsHolder.ZIndex = 2
    
    local ControlLayout = Instance.new("UIListLayout")
    ControlLayout.Parent = ControlsHolder
    ControlLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ControlLayout.Padding = UDim.new(0, 5)

    -- Função Helper para criar botões da Topbar
    local function CreateControlBtn(Order, IconId, Color)
        local Btn = Instance.new("ImageButton")
        Btn.Parent = ControlsHolder
        Btn.BackgroundTransparency = 1
        Btn.LayoutOrder = Order
        Btn.Size = UDim2.new(0, 40, 0, 40)
        Btn.Image = IconId
        Btn.ImageColor3 = Color or Library.Theme.TextDark
        
        -- Efeito Hover
        Btn.MouseEnter:Connect(function() 
            TweenService:Create(Btn, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.Text}):Play() 
        end)
        Btn.MouseLeave:Connect(function() 
            TweenService:Create(Btn, TweenInfo.new(0.2), {ImageColor3 = Color or Library.Theme.TextDark}):Play() 
        end)
        return Btn
    end

    -- 1. Resize Button (Toggle Size)
    local ResizeBtn = CreateControlBtn(1, "rbxassetid://98686616459399") -- Ícone genérico de expandir/setas
    -- Como não tenho o ID exato de resize na sua lista, usei um placeholder visual, mas a logica funciona.
    -- Se quiser usar um da sua lista, troque aqui.
    ResizeBtn.ImageRectOffset = Vector2.new(0,0) -- Caso seja spritesheet
    
    ResizeBtn.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 700, 0, 500)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 500, 0, 350)}):Play()
        end
    end)

    -- 2. Minimize Button
    local MinBtn = CreateControlBtn(2, Library.Icons.Minimize)
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 40)}):Play()
            -- Esconder conteúdo
            for _, v in pairs(MainFrame:GetChildren()) do
                if v.Name ~= "Topbar" and v.Name ~= "UICorner" and v.Name ~= "UIStroke" then
                    v.Visible = false
                end
            end
        else
            -- Restaurar tamanho baseado se está expandido ou não
            local TargetSize = Expanded and UDim2.new(0, 700, 0, 500) or UDim2.new(0, 500, 0, 350)
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = TargetSize}):Play()
            wait(0.2)
            for _, v in pairs(MainFrame:GetChildren()) do
                if v.Name ~= "Topbar" and v.Name ~= "UICorner" and v.Name ~= "UIStroke" and v.Name ~= "CloseModal" then
                    v.Visible = true
                end
            end
        end
    end)

    -- 3. Close Button
    local CloseBtn = CreateControlBtn(3, Library.Icons.Close, Color3.fromRGB(200, 50, 50))
    
    -- Modal de Confirmação de Fechamento
    local CloseModal = Instance.new("Frame")
    CloseModal.Name = "CloseModal"
    CloseModal.Parent = MainFrame
    CloseModal.BackgroundColor3 = Color3.fromRGB(0,0,0)
    CloseModal.BackgroundTransparency = 0.5
    CloseModal.Size = UDim2.new(1, 0, 1, 0)
    CloseModal.Visible = false
    CloseModal.ZIndex = 10

    local ModalFrame = Instance.new("Frame")
    ModalFrame.Parent = CloseModal
    ModalFrame.BackgroundColor3 = Library.Theme.Elements
    ModalFrame.Size = UDim2.new(0, 250, 0, 120)
    ModalFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
    Instance.new("UICorner", ModalFrame).CornerRadius = UDim.new(0, 8)

    local ModalText = Instance.new("TextLabel")
    ModalText.Parent = ModalFrame
    ModalText.BackgroundTransparency = 1
    ModalText.Size = UDim2.new(1, 0, 0.5, 0)
    ModalText.Text = "Fechar Library?"
    ModalText.TextColor3 = Library.Theme.Text
    ModalText.Font = Enum.Font.GothamBold
    ModalText.TextSize = 18

    local function CreateModalBtn(Text, Color, Callback)
        local btn = Instance.new("TextButton")
        btn.Parent = ModalFrame
        btn.BackgroundColor3 = Color
        btn.Text = Text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.Size = UDim2.new(0.4, 0, 0.3, 0)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(Callback)
        return btn
    end

    local BtnYes = CreateModalBtn("Yes", Color3.fromRGB(200, 50, 50), function() ScreenGui:Destroy() end)
    BtnYes.Position = UDim2.new(0.55, 0, 0.6, 0)
    
    local BtnCancel = CreateModalBtn("Cancel", Library.Theme.Accent, function() CloseModal.Visible = false end)
    BtnCancel.Position = UDim2.new(0.05, 0, 0.6, 0)

    CloseBtn.MouseButton1Click:Connect(function()
        CloseModal.Visible = true
    end)

    -- --- CONTENT AREA (SIDEBAR & PAGES) ---
    
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.Active = true
    Sidebar.BackgroundColor3 = Library.Theme.Background
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 50, 1, -40) -- Sidebar fina apenas com ícones para modernidade
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ScrollBarThickness = 0
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Parent = Sidebar
    SidebarLine.BackgroundColor3 = Library.Theme.Elements
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 10)
    
    -- Padding Top
    local SidePad = Instance.new("UIPadding")
    SidePad.Parent = Sidebar
    SidePad.PaddingTop = UDim.new(0, 10)

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 60, 0, 50) -- Espaço para a sidebar
    PagesContainer.Size = UDim2.new(1, -70, 1, -60)
    PagesContainer.ClipsDescendants = true

    -- Conecta o Loading System com a abertura da janela
    Library.OnLoad = function()
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    end

    -- --- WINDOW OBJECT ---
    local Window = {}

    function Window:Tab(TabConfig)
        TabConfig = TabConfig or {}
        local TabName = TabConfig.Name or "Tab"
        local TabIcon = TabConfig.Icon or ""

        -- 1. Create Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.Parent = PagesContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Library.Theme.Accent
        Page.Visible = false 
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        
        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingLeft = UDim.new(0, 5)
        PagePad.PaddingRight = UDim.new(0, 5)
        PagePad.PaddingBottom = UDim.new(0, 10)

        -- Auto-Resize Canvas
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        -- 2. Create Sidebar Button
        local TabBtn = Instance.new("ImageButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Library.Theme.Background
        TabBtn.Size = UDim2.new(0, 36, 0, 36)
        TabBtn.Image = TabIcon
        TabBtn.ImageColor3 = Library.Theme.TextDark
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        -- Tooltip simples (opcional, mostra o nome quando passa o mouse)
        -- ...

        local function UpdateTab()
            -- Reset all tabs
            for _, child in pairs(Sidebar:GetChildren()) do
                if child:IsA("ImageButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.TextDark, BackgroundColor3 = Library.Theme.Background}):Play()
                end
            end
            for _, child in pairs(PagesContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            -- Active state
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.Accent, BackgroundColor3 = Library.Theme.Elements}):Play()
        end

        TabBtn.MouseButton1Click:Connect(UpdateTab)

        -- Selecionar primeira tab automaticamente
        if CurrentTab == nil then
            CurrentTab = TabName
            UpdateTab()
        end

        return Page -- Retorna a página para a Parte 3 adicionar elementos nela
    end

    return Window
end

--[[
    NEON LIB - PART 3/4
    UI Elements (Buttons, Toggles, Sliders, MultiDropdowns, etc.)
]]

        local Elements = {}

        -- --- FUNÇÃO AUXILIAR PARA ELEMENTOS ---
        local function CreateElementFrame(Height)
            local Frame = Instance.new("Frame")
            Frame.Name = "Element"
            Frame.Parent = Page
            Frame.BackgroundColor3 = Library.Theme.Elements
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, -10, 0, Height)
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame
            
            return Frame
        end

        local function AddLabel(Text)
            local Lab = Instance.new("TextLabel")
            Lab.Parent = CreateElementFrame(30)
            Lab.BackgroundTransparency = 1
            Lab.Size = UDim2.new(1, -20, 1, 0)
            Lab.Position = UDim2.new(0, 10, 0, 0)
            Lab.Font = Enum.Font.Gotham
            Lab.TextColor3 = Library.Theme.TextDark
            Lab.TextSize = 14
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Text = Text
        end

        -- 1. BUTTON
        function Elements:AddButton(Text, Callback)
            Callback = Callback or function() end
            
            local Frame = CreateElementFrame(35)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Frame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.GothamBold
            Btn.Text = Text
            Btn.TextColor3 = Library.Theme.Text
            Btn.TextSize = 14
            
            Btn.MouseButton1Click:Connect(function()
                CreateRipple(Frame) -- Efeito visual da Parte 1
                Callback()
            end)
        end

        -- 2. TOGGLE
        function Elements:AddToggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local Frame = CreateElementFrame(35)
            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("Frame")
            SwitchBg.Parent = Frame
            SwitchBg.BackgroundColor3 = Toggled and Library.Theme.Accent or Color3.fromRGB(60,60,60)
            SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
            SwitchBg.Size = UDim2.new(0, 40, 0, 20)
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame")
            Circle.Parent = SwitchBg
            Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Circle.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = Frame
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            local function UpdateToggle()
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetColor = Toggled and Library.Theme.Accent or Color3.fromRGB(60,60,60)
                
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = TargetPos}):Play()
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
                Callback(Toggled)
            end

            Trigger.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
            end)
            
            -- Retorna objeto para controle externo
            return {
                Set = function(self, Val) 
                    Toggled = Val 
                    UpdateToggle() 
                end
            }
        end

        -- 3. SLIDER
        function Elements:AddSlider(Text, Min, Max, Default, Callback)
            Min, Max = Min or 0, Max or 100
            Default = Default or Min
            Callback = Callback or function() end
            
            local Value = Default
            local Dragging = false

            local Frame = CreateElementFrame(50)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(0.6, 0, 0, 20)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Frame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
            ValueLabel.Size = UDim2.new(0.25, 0, 0, 20)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = Library.Theme.TextDark
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("Frame")
            Bar.Parent = Frame
            Bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Bar.Position = UDim2.new(0, 10, 0, 35)
            Bar.Size = UDim2.new(1, -20, 0, 5)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Parent = Fill
            Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Knob.Position = UDim2.new(1, -5, 0.5, -5)
            Knob.Size = UDim2.new(0, 10, 0, 10)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = Frame
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            local function UpdateSlider(Input)
                local SizeX = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                
                if Value ~= NewValue then
                    Value = NewValue
                    ValueLabel.Text = tostring(Value)
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
                    Callback(Value)
                end
            end

            Trigger.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(Input)
                end
            end)
            
            return {
                Set = function(self, Val)
                    Value = math.clamp(Val, Min, Max)
                    ValueLabel.Text = tostring(Value)
                    local Percent = (Value - Min) / (Max - Min)
                    TweenService:Create(Fill, TweenInfo.new(0.3), {Size = UDim2.new(Percent, 0, 1, 0)}):Play()
                    Callback(Value)
                end
            }
        end

        -- 4. TEXTBOX
        function Elements:AddTextbox(Text, Default, Callback)
            Default = Default or ""
            Callback = Callback or function() end
            
            local Frame = CreateElementFrame(35)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox")
            Box.Parent = Frame
            Box.BackgroundColor3 = Color3.fromRGB(50,50,55)
            Box.Position = UDim2.new(1, -110, 0.5, -12)
            Box.Size = UDim2.new(0, 100, 0, 24)
            Box.Font = Enum.Font.Gotham
            Box.Text = Default
            Box.TextColor3 = Library.Theme.Text
            Box.TextSize = 12
            Box.PlaceholderText = "Type..."
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

            Box.FocusLost:Connect(function(Enter)
                Callback(Box.Text)
            end)
            
            return {
                Set = function(self, txt)
                    Box.Text = txt
                    Callback(txt)
                end
            }
        end

        -- 5. MULTI DROPDOWN
        function Elements:AddMultiDropdown(Text, Options, Default, Callback)
            Options = Options or {}
            Default = Default or {} -- Table de strings
            Callback = Callback or function() end
            
            local Selected = {}
            -- Copia defaults
            for _, v in pairs(Default) do Selected[v] = true end
            
            local DropdownOpen = false
            local Frame = CreateElementFrame(35)
            Frame.ClipsDescendants = true
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.6, 0, 0, 35)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local MainBtn = Instance.new("TextButton")
            MainBtn.Parent = Frame
            MainBtn.BackgroundColor3 = Color3.fromRGB(50,50,55)
            MainBtn.Position = UDim2.new(1, -140, 0, 5)
            MainBtn.Size = UDim2.new(0, 130, 0, 25)
            MainBtn.Font = Enum.Font.Gotham
            MainBtn.Text = "Select..."
            MainBtn.TextColor3 = Library.Theme.Text
            MainBtn.TextSize = 12
            Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 4)
            
            local Icon = Instance.new("ImageLabel")
            Icon.Parent = MainBtn
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(1, -20, 0, 5)
            Icon.Size = UDim2.new(0, 15, 0, 15)
            Icon.Image = "rbxassetid://6031091004" -- Arrow Down
            Icon.ImageColor3 = Library.Theme.TextDark

            local Container = Instance.new("Frame")
            Container.Parent = Frame
            Container.BackgroundColor3 = Color3.fromRGB(45,45,50)
            Container.Position = UDim2.new(0, 10, 0, 40)
            Container.Size = UDim2.new(1, -20, 0, 0)
            Container.Visible = false
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = Container
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            
            local function RefreshText()
                local count = 0
                for _ in pairs(Selected) do count = count + 1 end
                if count == 0 then MainBtn.Text = "None"
                else MainBtn.Text = count .. " Selected" end
            end
            RefreshText()

            -- Populate
            local function RefreshList()
                -- Clear old
                for _, v in pairs(Container:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                -- Add new
                local CanvasHeight = 0
                for _, Option in ipairs(Options) do
                    local Item = Instance.new("TextButton")
                    Item.Parent = Container
                    Item.BackgroundColor3 = Color3.fromRGB(45,45,50)
                    Item.Size = UDim2.new(1, 0, 0, 25)
                    Item.Font = Enum.Font.Gotham
                    Item.Text = "  " .. Option
                    Item.TextColor3 = Selected[Option] and Library.Theme.Accent or Library.Theme.TextDark
                    Item.TextXAlignment = Enum.TextXAlignment.Left
                    
                    Item.MouseButton1Click:Connect(function()
                        if Selected[Option] then
                            Selected[Option] = nil
                            Item.TextColor3 = Library.Theme.TextDark
                        else
                            Selected[Option] = true
                            Item.TextColor3 = Library.Theme.Accent
                        end
                        RefreshText()
                        
                        -- Return array of strings
                        local ReturnTable = {}
                        for k, _ in pairs(Selected) do table.insert(ReturnTable, k) end
                        Callback(ReturnTable)
                    end)
                    CanvasHeight = CanvasHeight + 27
                end
                return CanvasHeight
            end

            MainBtn.MouseButton1Click:Connect(function()
                DropdownOpen = not DropdownOpen
                local ListHeight = RefreshList()
                
                if DropdownOpen then
                    TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 180}):Play()
                    Container.Visible = true
                    TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 45 + ListHeight)}):Play()
                    TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, ListHeight)}):Play()
                else
                    TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 35)}):Play()
                    TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    wait(0.3)
                    Container.Visible = false
                end
            end)
            
            return {
                Refresh = function(self, NewOptions)
                    Options = NewOptions
                    RefreshList()
                end
            }
        end

        return Elements

--[[
    NEON LIB - PART 4/4
    Config System & Finalization
]]

    function Window:AddConfig()
        local ConfigTab = Window:Tab({Name = "Settings", Icon = Library.Icons.Config})
        local Elements = ConfigTab -- Reutiliza as funções de criação de elementos na aba Config
        
        Elements:AddLabel("UI Settings")

        -- 1. Transparência (60%)
        Elements:AddToggle("Blur / Transparency (60%)", false, function(Value)
            local TargetTransparency = Value and 0.4 or 0 -- 0.4 de alpha = 60% visivel, ou ajusta conforme gosto
            TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = Value and 0.6 or 0}):Play()
        end)

        -- 2. Dropdown de Temas
        Elements:AddDropdown("Theme Selection", {"Neon Green", "Cyber Red", "Void Purple", "Ocean Blue"}, {"Neon Green"}, function(Selected)
            -- Apenas exemplo visual, para funcionar 100% precisaria atualizar todas as cores da tabela Library.Theme e recarregar
            print("Tema selecionado: " .. tostring(Selected))
        end)

        Elements:AddLabel("Key System Config")

        -- 3. Key Management
        local KeyInput = ""
        Elements:AddTextbox("Saved Key", "...", function(Text)
            KeyInput = Text
        end)

        Elements:AddButton("Update Saved Key", function()
            if writefile then
                writefile("NeonLib_Key.txt", KeyInput)
                -- Notificação simples mudando o texto do titulo temporariamente
                local OldText = TopbarTitle.Text
                TopbarTitle.Text = "Key Saved!"
                wait(2)
                TopbarTitle.Text = OldText
            end
        end)

        Elements:AddLabel("Config Manager")

        -- 4. Save/Load Config System
        local ConfigName = ""
        Elements:AddTextbox("Config Name", "default", function(Text)
            ConfigName = Text
        end)

        -- Lista de configs existentes
        local ConfigList = {}
        if isfolder and isfolder("NeonConfigs") then
            for _, file in pairs(listfiles("NeonConfigs")) do
                table.insert(ConfigList, file:match("([^/]+)$"):gsub(".json", ""))
            end
        elseif makefolder then
            makefolder("NeonConfigs")
        end

        local ConfigDropdown = Elements:AddDropdown("Select Config", ConfigList, {}, function(Sel)
            ConfigName = Sel
        end)

        Elements:AddButton("Save Config", function()
            if ConfigName ~= "" and writefile then
                -- Exemplo: Salvar configurações atuais (precisa integrar com sistema de flags global)
                -- Aqui salvamos um arquivo de teste
                local ConfigData = HttpService:JSONEncode({SavedAt = os.time(), Theme = "Neon Green"})
                writefile("NeonConfigs/" .. ConfigName .. ".json", ConfigData)
                
                -- Atualizar dropdown
                ConfigDropdown:Refresh(listfiles("NeonConfigs"))
            end
        end)

        Elements:AddButton("Load Config", function()
            if ConfigName ~= "" and isfile and isfile("NeonConfigs/" .. ConfigName .. ".json") then
                local Content = readfile("NeonConfigs/" .. ConfigName .. ".json")
                print("Config Carregada: ", Content)
                -- Aqui você colocaria a lógica para setar os valores dos toggles/sliders
            end
        end)
    end

    -- Dropdown simples que faltou na Parte 3 (Adicionando aqui para compatibilidade com AddConfig)
    function Elements:AddDropdown(Text, Options, Default, Callback)
        -- Versão simplificada do MultiDropdown para Single Select
        return Elements:AddMultiDropdown(Text, Options, Default, function(Tbl)
            if #Tbl > 0 then Callback(Tbl[1]) end
        end)
    end

    return Window
end

return Library
