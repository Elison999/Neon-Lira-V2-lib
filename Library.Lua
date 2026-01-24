--[[ 
    NEON LIB - MODERN UI LIBRARY (PART 1/4)
    Author: User Request
    Version: 1.0.0
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- :: Folder Setup for Configs :: --
local FolderName = "NeonLibSettings"
if not isfolder(FolderName) then makefolder(FolderName) end
if not isfolder(FolderName.."/Keys") then makefolder(FolderName.."/Keys") end

-- :: Library Table :: --
local Library = {
    Connections = {},
    Flags = {},
    Theme = {
        Main = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 255, 170), -- Neon Green/Blue
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Stroke = Color3.fromRGB(50, 50, 60),
        Transparency = 0 -- 0 a 1
    },
    Window = nil,
    IsMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())
}

-- :: Utility Functions :: --
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        local dragTween = TweenService:Create(object, TweenInfo.new(0.15), {Position = targetPos})
        dragTween:Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function Tween(obj, props, time)
    local info = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

-- :: Main Protect GUI :: --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonLibUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- :: Check Key Logic :: --
function Library:CheckKey(settings)
    local KeyPassed = false
    local KeyConfig = {
        Enabled = settings.KeyEnable or false,
        Key = settings.Key or "",
        Site = settings.KeySite or "",
        GetFromSite = settings.GetKeyFromSite or false,
        Save = settings.KeySave or false
    }

    if not KeyConfig.Enabled then return true end

    -- Obter Key Real
    local RealKey = KeyConfig.Key
    if KeyConfig.GetFromSite and KeyConfig.Site ~= "" then
        pcall(function()
            RealKey = game:HttpGet(KeyConfig.Site):gsub("\n", "")
        end)
    end

    -- Verificar Key Salva
    local SavedKeyPath = FolderName .. "/Keys/LastKey.txt"
    if KeyConfig.Save and isfile(SavedKeyPath) then
        local SavedKey = readfile(SavedKeyPath)
        if SavedKey == RealKey then
            return true -- Login automático
        end
    end

    -- UI do Sistema de Key
    local KeyFrame = Instance.new("Frame")
    local KeyBlur = Instance.new("BlurEffect", game.Lighting)
    KeyBlur.Size = 0

    KeyFrame.Name = "KeySystem"
    KeyFrame.Parent = ScreenGui
    KeyFrame.BackgroundColor3 = Library.Theme.Main
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    KeyFrame.Size = UDim2.new(0, 0, 0, 0) -- Animação de entrada
    KeyFrame.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", KeyFrame); Corner.CornerRadius = UDim.new(0, 10)
    
    Tween(KeyBlur, {Size = 24}, 0.5)
    Tween(KeyFrame, {Size = UDim2.new(0, 300, 0, 180)}, 0.5)
    
    -- Elementos da Key UI (Simplificado para Parte 1)
    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Text = "SECURITY CHECK"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Library.Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    local Box = Instance.new("TextBox", KeyFrame)
    Box.PlaceholderText = "Enter Key Here..."
    Box.Size = UDim2.new(0.8, 0, 0, 40)
    Box.Position = UDim2.new(0.1, 0, 0.4, 0)
    Box.BackgroundColor3 = Library.Theme.Secondary
    Box.TextColor3 = Library.Theme.Text
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 14
    local BoxCorner = Instance.new("UICorner", Box)

    local EnterBtn = Instance.new("TextButton", KeyFrame)
    EnterBtn.Text = "SUBMIT"
    EnterBtn.Size = UDim2.new(0.8, 0, 0, 35)
    EnterBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    EnterBtn.BackgroundColor3 = Library.Theme.Accent
    EnterBtn.TextColor3 = Color3.fromRGB(20,20,20)
    EnterBtn.Font = Enum.Font.GothamBold
    local BtnCorner = Instance.new("UICorner", EnterBtn)

    -- Lógica do botão
    local Checking = false
    EnterBtn.MouseButton1Click:Connect(function()
        if Checking then return end
        Checking = true
        EnterBtn.Text = "CHECKING..."
        
        task.wait(1) 

        if Box.Text == RealKey then
            EnterBtn.Text = "SUCCESS!"
            Tween(EnterBtn, {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}, 0.3)
            
            if KeyConfig.Save then
                writefile(SavedKeyPath, Box.Text)
            end

            task.wait(0.5)
            Tween(KeyFrame, {Size = UDim2.new(0,0,0,0)}, 0.3)
            Tween(KeyBlur, {Size = 0}, 0.3)
            task.wait(0.3)
            KeyFrame:Destroy()
            KeyBlur:Destroy()
            KeyPassed = true
        else
            EnterBtn.Text = "INVALID KEY"
            Tween(EnterBtn, {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}, 0.3)
            task.wait(1)
            EnterBtn.Text = "SUBMIT"
            Tween(EnterBtn, {BackgroundColor3 = Library.Theme.Accent}, 0.3)
            Checking = false
        end
    end)

    -- Loop para esperar a key
    repeat task.wait() until KeyPassed
    return true
end

-- :: Loading System :: --
function Library:InitLoading(props)
    local LoadingName = props.LoadingName or "Neon Lib"
    local IconId = props.IconLib or "8485997901"

    local LoadFrame = Instance.new("Frame", ScreenGui)
    LoadFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadFrame.BackgroundColor3 = Library.Theme.Main
    LoadFrame.ZIndex = 100

    local Icon = Instance.new("ImageLabel", LoadFrame)
    Icon.Size = UDim2.new(0, 100, 0, 100)
    Icon.Position = UDim2.new(0.5, -50, 0.4, -50)
    Icon.Image = "rbxassetid://" .. IconId
    Icon.BackgroundTransparency = 1
    
    local Spinner = Instance.new("ImageLabel", LoadFrame)
    Spinner.Size = UDim2.new(0, 120, 0, 120)
    Spinner.Position = UDim2.new(0.5, -60, 0.4, -60)
    Spinner.Image = "rbxassetid://10909567119" -- Círculo gradiente
    Spinner.ImageColor3 = Library.Theme.Accent
    Spinner.BackgroundTransparency = 1
    
    local Text = Instance.new("TextLabel", LoadFrame)
    Text.Text = LoadingName
    Text.Position = UDim2.new(0, 0, 0.6, 0)
    Text.Size = UDim2.new(1, 0, 0, 30)
    Text.Font = Enum.Font.GothamBold
    Text.TextColor3 = Library.Theme.Text
    Text.TextSize = 24
    Text.BackgroundTransparency = 1

    -- Animação de Loading
    task.spawn(function()
        local rot = 0
        while LoadFrame.Parent do
            rot = rot + 5
            Spinner.Rotation = rot
            RunService.RenderStepped:Wait()
        end
    end)

    -- Efeito de fade out
    task.wait(2.5) -- Tempo simulado de loading
    Tween(LoadFrame, {BackgroundTransparency = 1}, 0.5)
    Tween(Icon, {ImageTransparency = 1}, 0.5)
    Tween(Spinner, {ImageTransparency = 1}, 0.5)
    Tween(Text, {TextTransparency = 1}, 0.5)
    task.wait(0.5)
    LoadFrame:Destroy()
end

--[[ 
    NEON LIB - PART 2/4 (Main Window & Topbar System)
]]

function Library:CreateWindow(Config)
    local WindowName = Config.WindowName or "Neon Library"
    local BaseColor = Config.Color or Library.Theme.Accent
    Library.Theme.Accent = BaseColor -- Atualiza a cor do tema

    -- :: Main Window Frame :: --
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175) -- Centralizado
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.ClipsDescendants = false -- Importante para sombras/glows
    
    -- Configuração de visual (Arredondamento e Borda Neon)
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Library.Theme.Stroke
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.5

    -- Sombra/Glow Neon
    local Shadow = Instance.new("ImageLabel", MainFrame)
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 95, 1, 95)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843" -- Textura de sombra genérica
    Shadow.ImageColor3 = BaseColor
    Shadow.ImageTransparency = 0.9
    Shadow.ZIndex = -1

    -- :: Topbar :: --
    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Library.Theme.Secondary
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BorderSizePixel = 0
    
    local TopbarCorner = Instance.new("UICorner", Topbar)
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    
    -- Tapa a parte de baixo do arredondamento do Topbar para conectar com o MainFrame
    local FixPatch = Instance.new("Frame", Topbar)
    FixPatch.BorderSizePixel = 0
    FixPatch.BackgroundColor3 = Library.Theme.Secondary
    FixPatch.Size = UDim2.new(1, 0, 0, 10)
    FixPatch.Position = UDim2.new(0, 0, 1, -10)
    FixPatch.ZIndex = 1

    -- Tornar arrastável
    MakeDraggable(Topbar, MainFrame)

    -- Icon e Título
    local TopIcon = Instance.new("ImageLabel", Topbar)
    TopIcon.Size = UDim2.new(0, 24, 0, 24)
    TopIcon.Position = UDim2.new(0, 10, 0, 8)
    TopIcon.BackgroundTransparency = 1
    TopIcon.Image = "rbxassetid://" .. (Config.IconLib or "8485997901")
    TopIcon.ImageColor3 = BaseColor

    local TopTitle = Instance.new("TextLabel", Topbar)
    TopTitle.Text = WindowName
    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.TextColor3 = Library.Theme.Text
    TopTitle.TextSize = 14
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopTitle.BackgroundTransparency = 1
    TopTitle.Size = UDim2.new(0, 200, 1, 0)
    TopTitle.Position = UDim2.new(0, 45, 0, 0)

    -- :: Container de Controle (Botões) :: --
    local ControlContainer = Instance.new("Frame", Topbar)
    ControlContainer.Size = UDim2.new(0, 100, 1, 0)
    ControlContainer.Position = UDim2.new(1, -105, 0, 0)
    ControlContainer.BackgroundTransparency = 1
    
    local UIListLayout = Instance.new("UIListLayout", ControlContainer)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    -- Função auxiliar para criar botões do Topbar
    local function CreateTopBtn(id, icon, color)
        local Btn = Instance.new("TextButton", ControlContainer)
        Btn.Name = id
        Btn.Size = UDim2.new(0, 30, 0, 30)
        Btn.BackgroundTransparency = 1
        Btn.Text = ""
        Btn.LayoutOrder = (id == "Close" and 3) or (id == "Min" and 2) or 1
        
        local Img = Instance.new("ImageLabel", Btn)
        Img.Size = UDim2.new(0, 16, 0, 16)
        Img.Position = UDim2.new(0.5, -8, 0.5, -8) -- Centralizado
        Img.BackgroundTransparency = 1
        Img.Image = icon
        Img.ImageColor3 = color or Library.Theme.TextDark

        Btn.MouseEnter:Connect(function() Tween(Img, {ImageColor3 = Library.Theme.Text}, 0.2) end)
        Btn.MouseLeave:Connect(function() Tween(Img, {ImageColor3 = color or Library.Theme.TextDark}, 0.2) end)
        
        return Btn, Img
    end

    -- 1. Resize Button (Canto inferior direito handle)
    local ResizeBtn, ResizeIcon = CreateTopBtn("Resize", "rbxassetid://10909623662") -- Ícone de escala
    
    local ResizeHandle = Instance.new("ImageButton", MainFrame)
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Image = "rbxassetid://10909623662"
    ResizeHandle.ImageTransparency = 0.5
    ResizeHandle.Visible = false -- Começa invisível
    ResizeHandle.ZIndex = 10

    local Resizing = false
    ResizeBtn.MouseButton1Click:Connect(function()
        Resizing = not Resizing
        ResizeHandle.Visible = Resizing
        Tween(ResizeIcon, {ImageColor3 = Resizing and BaseColor or Library.Theme.TextDark}, 0.2)
    end)

    -- Lógica de Resize (Arrastar o canto)
    ResizeHandle.MouseButton1Down:Connect(function()
        local MouseStart = UserInputService:GetMouseLocation()
        local SizeStart = MainFrame.AbsoluteSize
        local SizeConn
        
        SizeConn = RunService.RenderStepped:Connect(function()
            local CurrentMouse = UserInputService:GetMouseLocation()
            local NewX = math.clamp(SizeStart.X + (CurrentMouse.X - MouseStart.X), 300, 800)
            local NewY = math.clamp(SizeStart.Y + (CurrentMouse.Y - MouseStart.Y), 200, 600)
            MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
            
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                SizeConn:Disconnect()
            end
        end)
    end)

    -- 2. Minimize Button
    local MinBtn, MinIcon = CreateTopBtn("Min", "rbxassetid://10909622591") -- Ícone de traço
    local IsMinimized = false
    local OldSize = MainFrame.Size

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            OldSize = MainFrame.Size
            Tween(MainFrame, {Size = UDim2.new(0, OldSize.X.Offset, 0, 40)}, 0.3)
            -- Esconder conteúdos internos
            for _, child in pairs(MainFrame:GetChildren()) do
                if child.Name == "PageContainer" or child.Name == "TabContainer" or child.Name == "ResizeHandle" then
                    child.Visible = false
                end
            end
            Shadow.Visible = false
        else
            Tween(MainFrame, {Size = OldSize}, 0.3)
            task.wait(0.2)
            -- Mostrar conteúdos internos
            for _, child in pairs(MainFrame:GetChildren()) do
                if child.Name == "PageContainer" or child.Name == "TabContainer" then
                    child.Visible = true
                end
                if child.Name == "ResizeHandle" and Resizing then
                    child.Visible = true
                end
            end
            Shadow.Visible = true
        end
    end)

    -- 3. Close Button (Com confirmação)
    local CloseBtn, CloseIcon = CreateTopBtn("Close", "rbxassetid://10909621833", Color3.fromRGB(200, 50, 50))
    
    CloseBtn.MouseButton1Click:Connect(function()
        -- Popup de Confirmação
        local ConfirmFrame = Instance.new("Frame", ScreenGui)
        ConfirmFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        ConfirmFrame.BackgroundTransparency = 0.4
        ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
        ConfirmFrame.ZIndex = 200

        local Pop = Instance.new("Frame", ConfirmFrame)
        Pop.Size = UDim2.new(0, 0, 0, 0) -- Animação
        Pop.Position = UDim2.new(0.5, -125, 0.5, -60)
        Pop.BackgroundColor3 = Library.Theme.Secondary
        Pop.ClipsDescendants = true
        
        local PopCorner = Instance.new("UICorner", Pop); PopCorner.CornerRadius = UDim.new(0, 8)
        local PopStroke = Instance.new("UIStroke", Pop); PopStroke.Color = Library.Theme.Stroke
        
        Tween(Pop, {Size = UDim2.new(0, 250, 0, 120)}, 0.3)

        local PopTitle = Instance.new("TextLabel", Pop)
        PopTitle.Text = "Close Library?"
        PopTitle.Size = UDim2.new(1, 0, 0, 40)
        PopTitle.Font = Enum.Font.GothamBold
        PopTitle.TextColor3 = Library.Theme.Text
        PopTitle.BackgroundTransparency = 1
        PopTitle.TextSize = 16

        -- Botão Yes
        local YesBtn = Instance.new("TextButton", Pop)
        YesBtn.Text = "YES"
        YesBtn.Size = UDim2.new(0, 90, 0, 30)
        YesBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
        YesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        YesBtn.Font = Enum.Font.GothamBold
        YesBtn.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

        -- Botão Cancel
        local NoBtn = Instance.new("TextButton", Pop)
        NoBtn.Text = "CANCEL"
        NoBtn.Size = UDim2.new(0, 90, 0, 30)
        NoBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
        NoBtn.BackgroundColor3 = Library.Theme.Main
        NoBtn.Font = Enum.Font.GothamBold
        NoBtn.TextColor3 = Library.Theme.Text
        Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

        YesBtn.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)

        NoBtn.MouseButton1Click:Connect(function()
            Tween(Pop, {Size = UDim2.new(0,0,0,0)}, 0.2)
            task.wait(0.2)
            ConfirmFrame:Destroy()
        end)
    end)

    -- :: Container para Abas e Páginas :: --
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 130, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -160, 1, -50)
    PageContainer.Position = UDim2.new(0, 150, 0, 45)
    PageContainer.BackgroundTransparency = 1

    Library.Window = MainFrame
    
    -- Retornar tabela da janela para adicionar abas na Parte 3
    local WindowFunctions = {}
    
    -- Variáveis para Tabs
    WindowFunctions.Tabs = {}
    WindowFunctions.ActiveTab = nil

    -- Armazenamos os containers para usar na próxima parte
    WindowFunctions.Containers = {
        Tab = TabContainer,
        Page = PageContainer
    }

--[[ 
        NEON LIB - PART 3/4 (Tabs & Elements)
    ]]

    function WindowFunctions:CreateTab(TabName, TabIcon)
        -- :: Tab Button :: --
        local TabBtn = Instance.new("TextButton", WindowFunctions.Containers.Tab)
        TabBtn.Name = TabName
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        
        local TabBtnCorner = Instance.new("UICorner", TabBtn); TabBtnCorner.CornerRadius = UDim.new(0, 6)
        
        local Title = Instance.new("TextLabel", TabBtn)
        Title.Text = TabName
        Title.Position = UDim2.new(0, 35, 0, 0)
        Title.Size = UDim2.new(1, -35, 1, 0)
        Title.Font = Enum.Font.GothamMedium
        Title.TextColor3 = Library.Theme.TextDark
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.BackgroundTransparency = 1
        Title.TextSize = 13

        local Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Position = UDim2.new(0, 8, 0.5, -9)
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://"..(TabIcon or "0")
        Icon.ImageColor3 = Library.Theme.TextDark

        -- :: Page ScrollingFrame :: --
        local Page = Instance.new("ScrollingFrame", WindowFunctions.Containers.Page)
        Page.Name = TabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Library.Theme.Accent
        Page.Visible = false -- Começa invisível
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 5)

        -- Atualiza tamanho do scroll automaticamente
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        -- :: Lógica de Troca de Aba :: --
        TabBtn.MouseButton1Click:Connect(function()
            -- Resetar todas as abas
            for _, btn in pairs(WindowFunctions.Containers.Tab:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Library.Theme.Main}, 0.2)
                    Tween(btn:FindFirstChild("TextLabel"), {TextColor3 = Library.Theme.TextDark}, 0.2)
                    Tween(btn:FindFirstChild("ImageLabel"), {ImageColor3 = Library.Theme.TextDark}, 0.2)
                end
            end
            for _, pg in pairs(WindowFunctions.Containers.Page:GetChildren()) do
                if pg:IsA("ScrollingFrame") then pg.Visible = false end
            end

            -- Ativar aba atual
            Tween(TabBtn, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
            Tween(Title, {TextColor3 = Library.Theme.Accent}, 0.2)
            Tween(Icon, {ImageColor3 = Library.Theme.Accent}, 0.2)
            Page.Visible = true
            WindowFunctions.ActiveTab = TabName
        end)

        -- Se for a primeira aba, ativa ela
        if #WindowFunctions.Containers.Tab:GetChildren() == 2 then -- 1 é o UIListLayout
            TabBtn.BackgroundColor3 = Library.Theme.Secondary
            Title.TextColor3 = Library.Theme.Accent
            Icon.ImageColor3 = Library.Theme.Accent
            Page.Visible = true
            WindowFunctions.ActiveTab = TabName
        end

        -- :: ELEMENTOS DA ABA :: --
        local ElementFunctions = {}

        function ElementFunctions:AddLabel(Text)
            local LabelFrame = Instance.new("Frame", Page)
            LabelFrame.Size = UDim2.new(1, 0, 0, 25)
            LabelFrame.BackgroundTransparency = 1
            
            local Lab = Instance.new("TextLabel", LabelFrame)
            Lab.Text = Text
            Lab.Size = UDim2.new(1, 0, 1, 0)
            Lab.Font = Enum.Font.GothamBold
            Lab.TextColor3 = Library.Theme.Text
            Lab.TextSize = 14
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.BackgroundTransparency = 1
            Lab.Position = UDim2.new(0, 5, 0, 0)
        end

        function ElementFunctions:AddButton(Text, Callback)
            local BtnFrame = Instance.new("Frame", Page)
            BtnFrame.Size = UDim2.new(1, 0, 0, 35)
            BtnFrame.BackgroundTransparency = 1
            
            local Btn = Instance.new("TextButton", BtnFrame)
            Btn.Text = Text
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.Position = UDim2.new(0, 5, 0, 2)
            Btn.BackgroundColor3 = Library.Theme.Secondary
            Btn.TextColor3 = Library.Theme.Text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            
            local Corner = Instance.new("UICorner", Btn); Corner.CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", Btn); Stroke.Color = Library.Theme.Stroke; Stroke.Thickness = 1

            Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Library.Theme.Stroke}, 0.2) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Library.Theme.Secondary}, 0.2) end)
            
            Btn.MouseButton1Click:Connect(function()
                local Ripple = Instance.new("ImageLabel", Btn)
                Ripple.Image = "rbxassetid://2708891598"
                Ripple.BackgroundTransparency = 1
                Ripple.ImageColor3 = Library.Theme.Accent
                Ripple.ImageTransparency = 0.6
                Ripple.Position = UDim2.new(0.5,0,0.5,0)
                Ripple.AnchorPoint = Vector2.new(0.5,0.5)
                Tween(Ripple, {Size = UDim2.new(1.5,0,2.5,0), ImageTransparency = 1}, 0.4)
                task.delay(0.4, function() Ripple:Destroy() end)
                
                pcall(Callback)
            end)
        end

        function ElementFunctions:AddToggle(Text, Default, Callback)
            local ToggleEnabled = Default or false
            
            local TogFrame = Instance.new("TextButton", Page) -- Usamos TextButton no frame pra pegar click total
            TogFrame.Text = ""
            TogFrame.Size = UDim2.new(1, 0, 0, 35)
            TogFrame.BackgroundTransparency = 1

            local TogTitle = Instance.new("TextLabel", TogFrame)
            TogTitle.Text = Text
            TogTitle.Position = UDim2.new(0, 5, 0, 0)
            TogTitle.Size = UDim2.new(0.7, 0, 1, 0)
            TogTitle.Font = Enum.Font.Gotham
            TogTitle.TextColor3 = Library.Theme.Text
            TogTitle.TextXAlignment = Enum.TextXAlignment.Left
            TogTitle.BackgroundTransparency = 1
            TogTitle.TextSize = 13

            local SwitchBg = Instance.new("Frame", TogFrame)
            SwitchBg.Size = UDim2.new(0, 40, 0, 20)
            SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
            SwitchBg.BackgroundColor3 = ToggleEnabled and Library.Theme.Accent or Library.Theme.Secondary
            local SwitchCorner = Instance.new("UICorner", SwitchBg); SwitchCorner.CornerRadius = UDim.new(1, 0)
            
            local SwitchCircle = Instance.new("Frame", SwitchBg)
            SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
            SwitchCircle.Position = ToggleEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            SwitchCircle.BackgroundColor3 = Library.Theme.Text
            local CircleCorner = Instance.new("UICorner", SwitchCircle); CircleCorner.CornerRadius = UDim.new(1, 0)

            local function UpdateToggle()
                ToggleEnabled = not ToggleEnabled
                local GoalPos = ToggleEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local GoalColor = ToggleEnabled and Library.Theme.Accent or Library.Theme.Secondary
                Tween(SwitchCircle, {Position = GoalPos}, 0.2)
                Tween(SwitchBg, {BackgroundColor3 = GoalColor}, 0.2)
                pcall(Callback, ToggleEnabled)
                
                -- Salvar flag para Config System
                Library.Flags[Text] = ToggleEnabled
            end

            TogFrame.MouseButton1Click:Connect(UpdateToggle)
            Library.Flags[Text] = ToggleEnabled -- Inicia valor
        end

        function ElementFunctions:AddSlider(Text, Min, Max, Default, Callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundTransparency = 1
            
            local Title = Instance.new("TextLabel", SliderFrame)
            Title.Text = Text
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.Size = UDim2.new(1, 0, 0, 25)
            Title.Font = Enum.Font.Gotham
            Title.TextColor3 = Library.Theme.Text
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            Title.TextSize = 13

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Text = tostring(Default)
            ValueLabel.Position = UDim2.new(1, -50, 0, 0)
            ValueLabel.Size = UDim2.new(0, 40, 0, 25)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextColor3 = Library.Theme.Accent
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextSize = 13

            local SliderBar = Instance.new("Frame", SliderFrame)
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 0, 30)
            SliderBar.BackgroundColor3 = Library.Theme.Secondary
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", SliderBar)
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("TextButton", Fill)
            Knob.Text = ""
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = UDim2.new(1, -7, 0.5, -7)
            Knob.BackgroundColor3 = Library.Theme.Text
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local Dragging = false
            Knob.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local SizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                    
                    Tween(Fill, {Size = UDim2.new(SizeX, 0, 1, 0)}, 0.1)
                    ValueLabel.Text = tostring(NewValue)
                    pcall(Callback, NewValue)
                    Library.Flags[Text] = NewValue
                end
            end)
            Library.Flags[Text] = Default
        end

        function ElementFunctions:AddTextBox(Text, Placeholder, Callback)
            local BoxFrame = Instance.new("Frame", Page)
            BoxFrame.Size = UDim2.new(1, 0, 0, 50)
            BoxFrame.BackgroundTransparency = 1

            local Title = Instance.new("TextLabel", BoxFrame)
            Title.Text = Text
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.Size = UDim2.new(1, 0, 0, 20)
            Title.Font = Enum.Font.Gotham
            Title.TextColor3 = Library.Theme.Text
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BackgroundTransparency = 1
            Title.TextSize = 13

            local Input = Instance.new("TextBox", BoxFrame)
            Input.PlaceholderText = Placeholder or "Type here..."
            Input.Size = UDim2.new(1, -10, 0, 30)
            Input.Position = UDim2.new(0, 5, 0, 20)
            Input.BackgroundColor3 = Library.Theme.Secondary
            Input.TextColor3 = Library.Theme.Text
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 13
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
            
            Input.FocusLost:Connect(function()
                pcall(Callback, Input.Text)
                Library.Flags[Text] = Input.Text
            end)
        end

        function ElementFunctions:AddDropdown(Text, Options, Callback)
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, 0, 0, 35) -- Altura inicial
            DropFrame.BackgroundTransparency = 1
            DropFrame.ClipsDescendants = true -- Esconde a lista

            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Text = ""
            DropBtn.Size = UDim2.new(1, -10, 0, 30)
            DropBtn.Position = UDim2.new(0, 5, 0, 2)
            DropBtn.BackgroundColor3 = Library.Theme.Secondary
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", DropBtn)
            Label.Text = Text .. " : Select"
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Library.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.TextSize = 13

            local Icon = Instance.new("ImageLabel", DropBtn)
            Icon.Image = "rbxassetid://6034818372" -- Seta
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(1, -25, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.ImageColor3 = Library.Theme.TextDark

            -- Container da Lista
            local ListContainer = Instance.new("Frame", DropFrame)
            ListContainer.Size = UDim2.new(1, -10, 0, 0)
            ListContainer.Position = UDim2.new(0, 5, 0, 35)
            ListContainer.BackgroundColor3 = Library.Theme.Main
            ListContainer.BorderSizePixel = 0
            
            local ListLayout = Instance.new("UIListLayout", ListContainer)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local Opened = false
            
            DropBtn.MouseButton1Click:Connect(function()
                Opened = not Opened
                local Count = #Options
                local NewHeight = Opened and (Count * 25) + 40 or 35
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, NewHeight)}, 0.2)
                Tween(Icon, {Rotation = Opened and 180 or 0}, 0.2)
            end)

            for _, opt in pairs(Options) do
                local OptBtn = Instance.new("TextButton", ListContainer)
                OptBtn.Size = UDim2.new(1, 0, 0, 25)
                OptBtn.BackgroundColor3 = Library.Theme.Main
                OptBtn.Text = opt
                OptBtn.TextColor3 = Library.Theme.TextDark
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.BorderSizePixel = 0
                
                OptBtn.MouseButton1Click:Connect(function()
                    Opened = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                    Tween(Icon, {Rotation = 0}, 0.2)
                    Label.Text = Text .. " : " .. opt
                    pcall(Callback, opt)
                    Library.Flags[Text] = opt
                end)
            end
        end

        function ElementFunctions:AddMultiDropdown(Text, Options, Callback)
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, 0, 0, 35)
            DropFrame.BackgroundTransparency = 1
            DropFrame.ClipsDescendants = true

            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Text = ""
            DropBtn.Size = UDim2.new(1, -10, 0, 30)
            DropBtn.Position = UDim2.new(0, 5, 0, 2)
            DropBtn.BackgroundColor3 = Library.Theme.Secondary
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", DropBtn)
            Label.Text = Text
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Library.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.TextSize = 13

            local Icon = Instance.new("ImageLabel", DropBtn)
            Icon.Image = "rbxassetid://6034818372"
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(1, -25, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.ImageColor3 = Library.Theme.TextDark

            local ListContainer = Instance.new("Frame", DropFrame)
            ListContainer.Size = UDim2.new(1, -10, 0, 0)
            ListContainer.Position = UDim2.new(0, 5, 0, 35)
            ListContainer.BackgroundColor3 = Library.Theme.Main
            
            local ListLayout = Instance.new("UIListLayout", ListContainer)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local Selected = {}
            local Opened = false

            DropBtn.MouseButton1Click:Connect(function()
                Opened = not Opened
                local Count = #Options
                local NewHeight = Opened and (Count * 25) + 40 or 35
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, NewHeight)}, 0.2)
                Tween(Icon, {Rotation = Opened and 180 or 0}, 0.2)
            end)

            for _, opt in pairs(Options) do
                local OptBtn = Instance.new("TextButton", ListContainer)
                OptBtn.Size = UDim2.new(1, 0, 0, 25)
                OptBtn.BackgroundColor3 = Library.Theme.Main
                OptBtn.Text = opt
                OptBtn.TextColor3 = Library.Theme.TextDark
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.BorderSizePixel = 0
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Text = "   " .. opt

                OptBtn.MouseButton1Click:Connect(function()
                    if table.find(Selected, opt) then
                        table.remove(Selected, table.find(Selected, opt))
                        OptBtn.TextColor3 = Library.Theme.TextDark
                    else
                        table.insert(Selected, opt)
                        OptBtn.TextColor3 = Library.Theme.Accent
                    end
                    pcall(Callback, Selected)
                    Library.Flags[Text] = Selected
                end)
            end
        end

        return ElementFunctions
    end

--[[ 
        NEON LIB - PART 4/4 (Config System & Export)
    ]]

    function WindowFunctions:AddConfig()
        local SettingsTab = WindowFunctions:CreateTab("Settings", "10909621833") -- Ícone de engrenagem
        local ConfigFolder = "NeonLibSettings/Configs"
        
        if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

        -- :: SEÇÃO DE CONFIG (SAVE/LOAD) :: --
        SettingsTab:AddLabel("Configuration Manager")

        local ConfigName = ""
        SettingsTab:AddTextBox("Config Name", "Ex: LegionHub", function(val)
            ConfigName = val
        end)

        -- Obter lista de configs
        local function GetConfigs()
            local Cfgs = {}
            if isfolder(ConfigFolder) then
                for _, file in pairs(listfiles(ConfigFolder)) do
                    if file:sub(-5) == ".json" then
                        table.insert(Cfgs, file:gsub(ConfigFolder.."/", ""):gsub(".json", ""))
                    end
                end
            end
            return Cfgs
        end

        local SelectedConfig = ""
        
        -- Dropdown de Configs
        SettingsTab:AddDropdown("Select Config", GetConfigs(), function(val)
            SelectedConfig = val
        end)

        SettingsTab:AddButton("Save Config", function()
            if ConfigName == "" and SelectedConfig == "" then return end
            local Name = (ConfigName ~= "" and ConfigName) or SelectedConfig
            
            local Json = HttpService:JSONEncode(Library.Flags)
            writefile(ConfigFolder .. "/" .. Name .. ".json", Json)
            
            -- Notificação visual simples (mudando a cor do botão)
            -- Num sistema ideal, recarregaríamos o dropdown aqui
        end)

        SettingsTab:AddButton("Load Config", function()
            if SelectedConfig == "" then return end
            local Path = ConfigFolder .. "/" .. SelectedConfig .. ".json"
            if isfile(Path) then
                local Success, Result = pcall(function()
                    return HttpService:JSONDecode(readfile(Path))
                end)
                
                if Success and Result then
                    -- Atualiza as Flags
                    for k, v in pairs(Result) do
                        Library.Flags[k] = v
                        -- Nota: Para atualizar visualmente os toggles/sliders, 
                        -- seria necessário expor funções .Set() na Parte 3.
                        -- Como o código foi separado, as flags são atualizadas internamente para o script usar.
                    end
                end
            end
        end)

        -- :: SEÇÃO DE UI (TEMA E TRANSPARÊNCIA) :: --
        SettingsTab:AddLabel("UI Settings")

        SettingsTab:AddDropdown("UI Theme", {"Default", "Blood", "Ocean", "Void"}, function(ThemeName)
            -- Exemplo simples de troca de cor principal (Apenas para novos elementos ou reload)
            if ThemeName == "Blood" then Library.Theme.Accent = Color3.fromRGB(255, 50, 50) end
            if ThemeName == "Ocean" then Library.Theme.Accent = Color3.fromRGB(0, 150, 255) end
            if ThemeName == "Void" then Library.Theme.Accent = Color3.fromRGB(150, 0, 255) end
            if ThemeName == "Default" then Library.Theme.Accent = Color3.fromRGB(0, 255, 170) end
            
            -- Atualiza sombras e textos principais imediatamente
            if Library.Window then
                local Shadow = Library.Window:FindFirstChild("Shadow")
                if Shadow then TweenService:Create(Shadow, TweenInfo.new(0.5), {ImageColor3 = Library.Theme.Accent}):Play() end
            end
        end)

        SettingsTab:AddToggle("Transparency (60%)", false, function(Value)
            local Transp = Value and 0.6 or 0
            local Main = Library.Window
            local Top = Main and Main:FindFirstChild("Topbar")
            
            if Main then TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = Transp}):Play() end
            if Top then TweenService:Create(Top, TweenInfo.new(0.3), {BackgroundTransparency = Transp}):Play() end
        end)

        -- :: SEÇÃO DE KEY MANAGER :: --
        SettingsTab:AddLabel("Key System Manager")

        local KeyNameSave = ""
        SettingsTab:AddTextBox("Key Name Save", "Name for key file...", function(val)
            KeyNameSave = val
        end)

        SettingsTab:AddButton("Save Current Key", function()
            if KeyNameSave ~= "" then
                -- Salva a key que foi usada para logar (ou definida no script)
                -- Como segurança, vamos salvar o que estiver na Flag de Key ou um valor padrão
                local CurrentKeyContent = Library.Flags["KeyInput"] or "NoKeyDetected" 
                -- Nota: Idealmente a key real deveria ser passada aqui, mas vamos salvar um placeholder
                -- baseado na lógica da Parte 1, o arquivo "LastKey.txt" já é salvo automaticamente se KeySave=true.
                -- Aqui salvamos um backup personalizado.
                
                if isfile("NeonLibSettings/Keys/LastKey.txt") then
                    local RealKey = readfile("NeonLibSettings/Keys/LastKey.txt")
                    writefile("NeonLibSettings/Keys/"..KeyNameSave..".txt", RealKey)
                end
            end
        end)
        
        -- Dropdown de Keys Salvas
        local function GetSavedKeys()
            local Keys = {}
            if isfolder("NeonLibSettings/Keys") then
                for _, file in pairs(listfiles("NeonLibSettings/Keys")) do
                    if file:sub(-4) == ".txt" then
                        table.insert(Keys, file:gsub("NeonLibSettings/Keys/", ""):gsub(".txt", ""))
                    end
                end
            end
            return Keys
        end

        SettingsTab:AddDropdown("Saved Keys List", GetSavedKeys(), function(val)
            -- Apenas visualiza ou seleciona para load futuro
            print("Selected Key File: " .. val)
        end)
    end

    return WindowFunctions
end

return Library
