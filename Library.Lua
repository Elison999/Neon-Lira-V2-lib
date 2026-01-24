--[[ 
    NEON LIB - MODERN UI LIBRARY (PART 1)
    Compatible: Mobile/PC
    Parent: PlayerGui (No CoreGui)
]]

local NeonLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- Apenas para verificação, usaremos PlayerGui

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--// Utility Functions
local function MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        local NewPos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15), {Position = NewPos}):Play()
    end

    topbar.InputBegan:Connect(function(input)
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

    topbar.InputChanged:Connect(function(input)
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

local function CreateTween(obj, props, time)
    local info = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

--// Icons Table
local Icons = {
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
    Misc = "rbxassetid://114882667336771",
    Loading = "rbxassetid://8485997901" -- IconLib request
}

--// File System Logic (Safe Wrap)
local function SaveKey(key)
    if writefile then
        if not isfolder("NeonLib") then makefolder("NeonLib") end
        writefile("NeonLib/Key.txt", key)
    end
end

local function LoadKey()
    if readfile and isfile("NeonLib/Key.txt") then
        return readfile("NeonLib/Key.txt")
    end
    return nil
end

--// Main Window Function
function NeonLib:CreateWindow(Settings)
    local WindowName = Settings.Name or "Neon Lib"
    local LoadingName = Settings.LoadingTitle or "Neon Lib"
    local KeySettings = Settings.KeySystem or {}
    
    -- Configuração Padrão do Key System
    KeySettings.Enabled = KeySettings.KeyEnable or false
    KeySettings.Key = KeySettings.Key or "1234"
    KeySettings.Site = KeySettings.KeySite or ""
    KeySettings.UseSite = KeySettings.GetKeyFromSite or false
    KeySettings.Save = KeySettings.KeySave or false

    -- Destroi UI antiga se existir
    if Player.PlayerGui:FindFirstChild("NeonLibUI") then
        Player.PlayerGui.NeonLibUI:Destroy()
    end

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonLibUI"
    ScreenGui.Parent = Player.PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    --// LOADING SYSTEM
    local LoadingFrame = Instance.new("Frame")
    local LoadingIcon = Instance.new("ImageLabel")
    local LoadingText = Instance.new("TextLabel")
    local LoadingBarBack = Instance.new("Frame")
    local LoadingBarFill = Instance.new("Frame")

    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.ZIndex = 100

    LoadingIcon.Parent = LoadingFrame
    LoadingIcon.BackgroundTransparency = 1
    LoadingIcon.Position = UDim2.new(0.5, -50, 0.4, -50)
    LoadingIcon.Size = UDim2.new(0, 100, 0, 100)
    LoadingIcon.Image = Icons.Loading

    LoadingText.Parent = LoadingFrame
    LoadingText.BackgroundTransparency = 1
    LoadingText.Position = UDim2.new(0.5, -150, 0.55, 0)
    LoadingText.Size = UDim2.new(0, 300, 0, 30)
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = LoadingName
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 24

    LoadingBarBack.Parent = LoadingFrame
    LoadingBarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    LoadingBarBack.Position = UDim2.new(0.5, -100, 0.65, 0)
    LoadingBarBack.Size = UDim2.new(0, 200, 0, 6)
    LoadingBarBack.BorderSizePixel = 0
    Instance.new("UICorner", LoadingBarBack).CornerRadius = UDim.new(1, 0)

    LoadingBarFill.Parent = LoadingBarBack
    LoadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 180) -- Neon Cyan
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingBarFill.BorderSizePixel = 0
    Instance.new("UICorner", LoadingBarFill).CornerRadius = UDim.new(1, 0)

    -- Animação de Loading simples
    CreateTween(LoadingBarFill, {Size = UDim2.new(1, 0, 1, 0)}, 2)
    task.wait(2.2)
    CreateTween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
    CreateTween(LoadingIcon, {ImageTransparency = 1}, 0.5)
    CreateTween(LoadingText, {TextTransparency = 1}, 0.5)
    CreateTween(LoadingBarBack, {BackgroundTransparency = 1}, 0.5)
    CreateTween(LoadingBarFill, {BackgroundTransparency = 1}, 0.5)
    task.wait(0.5)
    LoadingFrame.Visible = false

    --// KEY SYSTEM CHECK
    if KeySettings.Enabled then
        local Passed = false
        local SavedKey = LoadKey()
        local RealKey = KeySettings.Key
        
        if KeySettings.UseSite and KeySettings.Site ~= "" then
            pcall(function()
                RealKey = game:HttpGet(KeySettings.Site):gsub("\n", ""):gsub(" ", "")
            end)
        end

        -- Auto Login
        if KeySettings.Save and SavedKey and SavedKey == RealKey then
            Passed = true
        end

        if not Passed then
            LoadingFrame.Visible = true
            LoadingFrame.BackgroundTransparency = 0.1
            LoadingText.TextTransparency = 0
            LoadingText.Text = "Key System Required"
            
            -- Key UI Elements
            local KeyBox = Instance.new("TextBox")
            local CheckBtn = Instance.new("TextButton")
            local LinkBtn = Instance.new("TextButton")

            KeyBox.Parent = LoadingFrame
            KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            KeyBox.Position = UDim2.new(0.5, -100, 0.65, 0)
            KeyBox.Size = UDim2.new(0, 200, 0, 35)
            KeyBox.Font = Enum.Font.Gotham
            KeyBox.PlaceholderText = "Enter Key..."
            KeyBox.Text = ""
            KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeyBox.TextSize = 14
            Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

            CheckBtn.Parent = LoadingFrame
            CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
            CheckBtn.Position = UDim2.new(0.5, -100, 0.72, 0)
            CheckBtn.Size = UDim2.new(0, 95, 0, 35)
            CheckBtn.Font = Enum.Font.GothamBold
            CheckBtn.Text = "Check Key"
            CheckBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
            CheckBtn.TextSize = 14
            Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 6)

            LinkBtn.Parent = LoadingFrame
            LinkBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            LinkBtn.Position = UDim2.new(0.5, 5, 0.72, 0)
            LinkBtn.Size = UDim2.new(0, 95, 0, 35)
            LinkBtn.Font = Enum.Font.GothamBold
            LinkBtn.Text = "Get Key"
            LinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            LinkBtn.TextSize = 14
            Instance.new("UICorner", LinkBtn).CornerRadius = UDim.new(0, 6)
            
            local function CloseKeyUI()
                 CreateTween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
                 KeyBox.Visible = false
                 CheckBtn.Visible = false
                 LinkBtn.Visible = false
                 LoadingText.Visible = false
                 LoadingFrame.Visible = false
            end

            LinkBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(KeySettings.Site)
                    LinkBtn.Text = "Copied!"
                    task.wait(1)
                    LinkBtn.Text = "Get Key"
                end
            end)

            CheckBtn.MouseButton1Click:Connect(function()
                if KeyBox.Text == RealKey then
                    if KeySettings.Save then
                        SaveKey(KeyBox.Text)
                    end
                    CheckBtn.Text = "Correct!"
                    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    task.wait(0.5)
                    CloseKeyUI()
                else
                    CheckBtn.Text = "Incorrect"
                    CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    task.wait(1)
                    CheckBtn.Text = "Check Key"
                    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
                end
            end)
            
            -- Wait for key
            repeat task.wait() until not LoadingFrame.Visible
        end
    end

    --// MAIN UI CONSTRUCTION
    local MainFrame = Instance.new("Frame")
    local Topbar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Icon = Instance.new("ImageLabel")
    local MainContent = Instance.new("Frame") -- Onde os elementos ficam
    local TabContainer = Instance.new("ScrollingFrame") -- Onde os botões das abas ficam
    local PagesContainer = Instance.new("Frame") -- Onde as páginas (Seções) ficam
    
    -- Resize/Control Handles
    local ResizeBtn = Instance.new("ImageButton")
    local MinBtn = Instance.new("ImageButton")
    local CloseBtn = Instance.new("ImageButton")

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Glow Shadow
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = MainFrame
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -15, 0, -15)
    Glow.Size = UDim2.new(1, 30, 1, 30)
    Glow.Image = "rbxassetid://5028857472"
    Glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Glow.ZIndex = 0

    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BorderSizePixel = 0
    local TopbarCorner = Instance.new("UICorner", Topbar)
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    
    -- Fix bottom corners of topbar not being square when expanded
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Parent = Topbar
    TopbarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Position = UDim2.new(0,0,1,-5)
    TopbarFix.Size = UDim2.new(1,0,0,5)

    Icon.Parent = Topbar
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 10, 0, 5)
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Image = Icons.Loading -- Using loading icon as main logo as requested logic

    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = WindowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    --// CONTROL BUTTONS (Min, Close)
    local ButtonLayout = Instance.new("UIListLayout")
    local ButtonContainer = Instance.new("Frame")
    
    ButtonContainer.Parent = Topbar
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(1, -70, 0, 0)
    ButtonContainer.Size = UDim2.new(0, 70, 1, 0)
    
    ButtonLayout.Parent = ButtonContainer
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ButtonLayout.Padding = UDim.new(0, 5)

    MinBtn.Parent = ButtonContainer
    MinBtn.BackgroundTransparency = 1
    MinBtn.Size = UDim2.new(0, 25, 0, 25)
    MinBtn.Image = Icons.Minimize
    MinBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.LayoutOrder = 1

    CloseBtn.Parent = ButtonContainer
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Image = Icons.Close
    CloseBtn.ImageColor3 = Color3.fromRGB(200, 100, 100)
    CloseBtn.LayoutOrder = 2

    --// RESIZE BUTTON
    ResizeBtn.Name = "ResizeHandle"
    ResizeBtn.Parent = MainFrame
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
    ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
    ResizeBtn.Image = "rbxassetid://16443329241" -- Generic Corner Drag Icon usually, putting placeholder or invisible logic
    -- Criando um visual para o resize
    local ResizeVisual = Instance.new("Frame", ResizeBtn)
    ResizeVisual.Size = UDim2.new(1,0,1,0)
    ResizeVisual.BackgroundTransparency = 1
    -- (Adicionar logica de icon de resize ou deixar invisivel clicavel no canto)
    ResizeBtn.Image = "" -- Using invisible area
    ResizeBtn.ZIndex = 10

    --// LOGICA DOS BOTÕES
    MakeDraggable(Topbar, MainFrame)

    -- Minimize Logic
    local Minimized = false
    local OldSize = UDim2.new(0, 500, 0, 350)
    
    MinBtn.MouseButton1Click:Connect(function()
        if not Minimized then
            OldSize = MainFrame.Size
            CreateTween(MainFrame, {Size = UDim2.new(0, OldSize.X.Offset, 0, 40)}, 0.3)
            MainContent.Visible = false
            PagesContainer.Visible = false
            TabContainer.Visible = false
            ResizeBtn.Visible = false
            Minimized = true
        else
            CreateTween(MainFrame, {Size = OldSize}, 0.3)
            task.wait(0.2)
            MainContent.Visible = true
            PagesContainer.Visible = true
            TabContainer.Visible = true
            ResizeBtn.Visible = true
            Minimized = false
        end
    end)

    -- Close Logic (Confirmation)
    CloseBtn.MouseButton1Click:Connect(function()
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Parent = ScreenGui
        ConfirmFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        ConfirmFrame.BackgroundTransparency = 0.5
        ConfirmFrame.Size = UDim2.new(1,0,1,0)
        ConfirmFrame.ZIndex = 200

        local Modal = Instance.new("Frame")
        Modal.Parent = ConfirmFrame
        Modal.Size = UDim2.new(0, 300, 0, 150)
        Modal.Position = UDim2.new(0.5, -150, 0.5, -75)
        Modal.BackgroundColor3 = Color3.fromRGB(30,30,35)
        Instance.new("UICorner", Modal).CornerRadius = UDim.new(0,10)

        local Txt = Instance.new("TextLabel", Modal)
        Txt.Size = UDim2.new(1,0,0.6,0)
        Txt.Text = "Close Library?"
        Txt.TextColor3 = Color3.fromRGB(255,255,255)
        Txt.BackgroundTransparency = 1
        Txt.Font = Enum.Font.GothamBold
        Txt.TextSize = 20

        local Yes = Instance.new("TextButton", Modal)
        Yes.Size = UDim2.new(0,100,0,40)
        Yes.Position = UDim2.new(0.5, 10, 0.7, 0)
        Yes.Text = "Yes"
        Yes.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Yes.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", Yes)

        local Cancel = Instance.new("TextButton", Modal)
        Cancel.Size = UDim2.new(0,100,0,40)
        Cancel.Position = UDim2.new(0.5, -110, 0.7, 0)
        Cancel.Text = "Cancel"
        Cancel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Cancel.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", Cancel)

        Yes.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        Cancel.MouseButton1Click:Connect(function()
            ConfirmFrame:Destroy()
        end)
    end)

    -- Resize Logic
    local Resizing = false
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local MousePos = UserInputService:GetMouseLocation()
            local CurrentPos = MainFrame.AbsolutePosition
            local NewSizeX = MousePos.X - CurrentPos.X
            local NewSizeY = MousePos.Y - CurrentPos.Y
            
            -- Minimum Size
            if NewSizeX < 400 then NewSizeX = 400 end
            if NewSizeY < 300 then NewSizeY = 300 end

            MainFrame.Size = UDim2.new(0, NewSizeX, 0, NewSizeY)
        end
    end)

    --// CONTAINERS SETUP
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 50, 1, -60) -- Sidebar style for icons
    TabContainer.ScrollBarThickness = 0
    
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 70, 0, 50)
    PagesContainer.Size = UDim2.new(1, -80, 1, -60)
    
    -- Passando variáveis para a Parte 2
    local WindowFunctions = {}
    WindowFunctions.MainFrame = MainFrame
    WindowFunctions.TabContainer = TabContainer
    WindowFunctions.PagesContainer = PagesContainer
    WindowFunctions.Icons = Icons
    
    return WindowFunctions
end

--[[ 
    NEON LIB - PART 2 (ELEMENTS & LOGIC)
    Cole isso logo APÓS a Parte 1.
]]

-- Vamos modificar o comportamento para adicionar as funções à Library criada na Parte 1
-- Assumindo que você vai usar: local Window = NeonLib:CreateWindow(...)

local function AddElementsToWindow(WindowObj)
    local MainFrame = WindowObj.MainFrame
    local TabContainer = WindowObj.TabContainer
    local PagesContainer = WindowObj.PagesContainer
    local Icons = WindowObj.Icons

    local FirstTab = true

    --// UPDATE SYSTEM (UIListLayout)
    local function UpdateLayout(frame)
        if frame:FindFirstChild("UIListLayout") then
            -- Força atualização do tamanho do canvas
            local layout = frame.UIListLayout
            local contentSize = layout.AbsoluteContentSize
            frame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
        end
    end

    function WindowObj:CreateTab(Name, IconId)
        local TabName = Name or "Tab"
        local TabIconId = IconId or Icons.Misc

        -- Tab Button (Sidebar)
        local TabBtn = Instance.new("ImageButton")
        TabBtn.Name = TabName
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 40, 0, 40)
        TabBtn.Image = TabIconId
        TabBtn.ImageColor3 = Color3.fromRGB(150, 150, 160) -- Cor inativa

        local TabCorner = Instance.new("UICorner", TabBtn)
        TabCorner.CornerRadius = UDim.new(0, 8)

        -- Tab Page (Content)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.Parent = PagesContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)
        Page.Visible = false

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Switch Logic
        TabBtn.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("ImageButton") then
                    game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 160)}):Play()
                end
            end
            for _, pg in pairs(PagesContainer:GetChildren()) do
                if pg:IsA("ScrollingFrame") then
                    pg.Visible = false
                end
            end

            -- Active
            game:GetService("TweenService"):Create(TabBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(0, 255, 180)}):Play()
            Page.Visible = true
        end)

        if FirstTab then
            FirstTab = false
            TabBtn.ImageColor3 = Color3.fromRGB(0, 255, 180)
            Page.Visible = true
        end

        local Elements = {}

        --// BUTTON
        function Elements:AddButton(Text, Callback)
            Callback = Callback or function() end
            
            local BtnFrame = Instance.new("Frame")
            local Btn = Instance.new("TextButton")
            
            BtnFrame.Parent = Page
            BtnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            BtnFrame.Size = UDim2.new(1, -10, 0, 40)
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
            
            Btn.Parent = BtnFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 14
            
            Btn.MouseButton1Click:Connect(function()
                -- Animation
                game:GetService("TweenService"):Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                task.wait(0.1)
                game:GetService("TweenService"):Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                pcall(Callback)
            end)
        end

        --// TOGGLE
        function Elements:AddToggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local ToggleFrame = Instance.new("Frame")
            local ToggleText = Instance.new("TextLabel")
            local Switch = Instance.new("TextButton")
            local Circle = Instance.new("Frame")

            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            ToggleText.Parent = ToggleFrame
            ToggleText.BackgroundTransparency = 1
            ToggleText.Position = UDim2.new(0, 15, 0, 0)
            ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleText.Font = Enum.Font.GothamMedium
            ToggleText.Text = Text
            ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.TextSize = 14
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left

            Switch.Parent = ToggleFrame
            Switch.BackgroundColor3 = Toggled and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(50, 50, 55)
            Switch.Position = UDim2.new(1, -60, 0.5, -10)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Text = ""
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            Circle.Parent = Switch
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            Switch.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetColor = Toggled and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(50, 50, 55)
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

                game:GetService("TweenService"):Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
                game:GetService("TweenService"):Create(Circle, TweenInfo.new(0.2), {Position = TargetPos}):Play()
                
                pcall(Callback, Toggled)
            end)
        end

        --// MULTI DROPDOWN
        function Elements:AddMultiDropdown(Text, Options, Callback)
            Options = Options or {}
            Callback = Callback or function() end
            local Selected = {}

            local DropFrame = Instance.new("Frame")
            local DropBtn = Instance.new("TextButton")
            local DropLabel = Instance.new("TextLabel")
            local Arrow = Instance.new("ImageLabel")
            local List = Instance.new("Frame")
            local ListLayout = Instance.new("UIListLayout")

            DropFrame.Parent = Page
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropFrame.Size = UDim2.new(1, -10, 0, 40) -- Tamanho fechado
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

            DropBtn.Parent = DropFrame
            DropBtn.BackgroundTransparency = 1
            DropBtn.Size = UDim2.new(1, 0, 0, 40)
            DropBtn.Text = ""

            DropLabel.Parent = DropFrame
            DropLabel.BackgroundTransparency = 1
            DropLabel.Position = UDim2.new(0, 15, 0, 0)
            DropLabel.Size = UDim2.new(0.7, 0, 0, 40)
            DropLabel.Font = Enum.Font.GothamMedium
            DropLabel.Text = Text .. " [...]"
            DropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left

            Arrow.Parent = DropFrame
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -30, 0, 10)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Image = "rbxassetid://6034818372" -- Down Arrow
            Arrow.Rotation = 0

            List.Parent = DropFrame
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 45)
            List.Size = UDim2.new(1, 0, 0, 0)

            ListLayout.Parent = List
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 5)

            local Open = false

            -- Generate Items
            for _, opt in pairs(Options) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Parent = List
                ItemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                ItemBtn.Size = UDim2.new(1, -20, 0, 30)
                ItemBtn.Position = UDim2.new(0, 10, 0, 0)
                ItemBtn.Font = Enum.Font.Gotham
                ItemBtn.Text = opt
                ItemBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                ItemBtn.TextSize = 12
                Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 4)

                ItemBtn.MouseButton1Click:Connect(function()
                    if table.find(Selected, opt) then
                        for i,v in pairs(Selected) do if v == opt then table.remove(Selected, i) end end
                        ItemBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                    else
                        table.insert(Selected, opt)
                        ItemBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    end
                    -- Update Title
                    DropLabel.Text = Text .. " [" .. table.concat(Selected, ", ") .. "]"
                    pcall(Callback, Selected)
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local ContentSize = ListLayout.AbsoluteContentSize.Y + 50
                if Open then
                    game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, ContentSize)}):Play()
                    game:GetService("TweenService"):Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                    game:GetService("TweenService"):Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end
            end)
        end

        --// TEXTBOX
        function Elements:AddTextbox(Placeholder, Callback)
            Callback = Callback or function() end
            local BoxFrame = Instance.new("Frame")
            local Box = Instance.new("TextBox")

            BoxFrame.Parent = Page
            BoxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            BoxFrame.Size = UDim2.new(1, -10, 0, 40)
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)

            Box.Parent = BoxFrame
            Box.BackgroundTransparency = 1
            Box.Position = UDim2.new(0, 10, 0, 0)
            Box.Size = UDim2.new(1, -20, 1, 0)
            Box.Font = Enum.Font.GothamMedium
            Box.PlaceholderText = Placeholder
            Box.Text = ""
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.TextSize = 14
            Box.ClearTextOnFocus = false

            Box.FocusLost:Connect(function(enter)
                if enter then
                    pcall(Callback, Box.Text)
                end
            end)
        end
        
        --// DROPDOWN (SINGLE)
        function Elements:AddDropdown(Text, Options, Callback)
            -- Simplificada para o config, similar ao Multi mas single choice
            Options = Options or {}
            Callback = Callback or function() end
            
            local DropFrame = Instance.new("Frame")
            local DropBtn = Instance.new("TextButton")
            local DropLabel = Instance.new("TextLabel")
            local List = Instance.new("Frame")
            local ListLayout = Instance.new("UIListLayout")
            
            DropFrame.Parent = Page
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropFrame.Size = UDim2.new(1, -10, 0, 40)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
            
            DropBtn.Parent = DropFrame
            DropBtn.BackgroundTransparency = 1
            DropBtn.Size = UDim2.new(1, 0, 0, 40)
            DropBtn.Text = ""
            
            DropLabel.Parent = DropFrame
            DropLabel.BackgroundTransparency = 1
            DropLabel.Position = UDim2.new(0, 15, 0, 0)
            DropLabel.Size = UDim2.new(0.7, 0, 0, 40)
            DropLabel.Font = Enum.Font.GothamMedium
            DropLabel.Text = Text
            DropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left

            List.Parent = DropFrame
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 45)
            List.Size = UDim2.new(1, 0, 0, 0)
            
            ListLayout.Parent = List
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 5)

            local Open = false
            
            local function RefreshOptions()
                for _, child in pairs(List:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                for _, opt in pairs(Options) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Parent = List
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                    ItemBtn.Size = UDim2.new(1, -20, 0, 30)
                    ItemBtn.Text = opt
                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 4)
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        DropLabel.Text = Text .. ": " .. opt
                        pcall(Callback, opt)
                        -- Close
                        Open = false
                         game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                    end)
                end
            end
            RefreshOptions()

            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local ContentSize = ListLayout.AbsoluteContentSize.Y + 50
                if Open then
                    game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, ContentSize)}):Play()
                else
                    game:GetService("TweenService"):Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                end
            end)
            
            -- Retorna função para atualizar lista dinamicamente
            return {
                Refresh = function(NewOptions)
                    Options = NewOptions
                    RefreshOptions()
                end
            }
        end

        return Elements
    end

    function WindowObj:AddConfig()
        local ConfigTab = WindowObj:CreateTab("Config", Icons.Config)
        
        -- Theme Logic (Simples)
        ConfigTab:AddDropdown("Theme", {"Dark", "Light (Beta)", "Neon Blue"}, function(val)
            -- Apenas visual demonstrativo
            print("Theme Selected: "..val)
        end)
        
        -- Transparency Toggle (60% Transferência)
        ConfigTab:AddToggle("Transparency 60%", false, function(state)
            if state then
                game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
            else
                game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            end
        end)

        -- Config Save System
        local ConfigName = "default"
        ConfigTab:AddTextbox("Config Name...", function(text)
            ConfigName = text
        end)

        local SavedKeysDropdown = ConfigTab:AddDropdown("Saved Keys", {}, function(val)
            print("Selected Key: " .. val)
        end)
        
        local function UpdateFiles()
            local Keys = {}
            if listfiles and isfolder("NeonLib") then
                 for _, file in pairs(listfiles("NeonLib")) do
                     table.insert(Keys, file:gsub("NeonLib\\", ""):gsub(".json", ""))
                 end
            end
            SavedKeysDropdown.Refresh(Keys)
        end
        
        -- Save Button
        ConfigTab:AddButton("Save Config", function()
            if writefile then
                if not isfolder("NeonLib") then makefolder("NeonLib") end
                -- Exemplo salvando um dummy data
                local Data = {Name = ConfigName, Date = os.time()}
                writefile("NeonLib/"..ConfigName..".json", game:GetService("HttpService"):JSONEncode(Data))
                UpdateFiles()
            end
        end)

        -- Load Button
        ConfigTab:AddButton("Load Config", function()
            if readfile and isfile("NeonLib/"..ConfigName..".json") then
                print("Loaded config: " .. ConfigName)
            end
        end)
        
        UpdateFiles() -- Init
    end
end

--================================================================================--
-- EXEMPLO DE USO (INTEGRAÇÃO AUTOMÁTICA)
--================================================================================--

-- 1. Cria a Janela (Isso veio da Parte 1, mas a gente chama de fora)
-- ATENÇÃO: Se você colou os scripts juntos, a variável 'NeonLib' da Parte 1 está acessível.

local MyWindow = NeonLib:CreateWindow({
    Name = "Neon Hub | Ultimate",
    LoadingTitle = "Carregando Scripts...",
    KeySystem = {
        KeyEnable = false, -- Mude para true se quiser testar a key
        Key = "1234",
        KeySave = true
    }
})

-- 2. Adiciona as funções da Parte 2 na Janela criada
AddElementsToWindow(MyWindow)

-- 3. Cria as Abas e Elementos
local HomeTab = MyWindow:CreateTab("Home", MyWindow.Icons.Home)
local CombatTab = MyWindow:CreateTab("Combat", MyWindow.Icons.Combat)
local VisualTab = MyWindow:CreateTab("Visual", MyWindow.Icons.Visual)

-- Home Elements
HomeTab:AddButton("Destroy GUI", function()
    game.CoreGui:FindFirstChild("NeonLibUI"):Destroy() -- Ou PlayerGui
end)

HomeTab:AddToggle("Auto Farm", false, function(state)
    print("Auto Farm is now:", state)
end)

HomeTab:AddMultiDropdown("Select Targets", {"Player", "NPC", "Boss"}, function(selected)
    print("Selected:", table.concat(selected, ", "))
end)

-- Combat Elements
CombatTab:AddToggle("Kill Aura", true, function(v) print(v) end)
CombatTab:AddButton("Silent Aim", function() print("Clicked") end)

-- 4. Adiciona o Menu de Configurações (Pedido no prompt)
MyWindow:AddConfig()

-- Notificação de sucesso no console (F9)
print("Neon Lib Loaded Successfully!")
