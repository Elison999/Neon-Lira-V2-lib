--[[ 
    NEON LIB - MODERN UI LIBRARY (REWORKED)
    Compatível: Mobile/PC
    Parent: PlayerGui (NUNCA CoreGui)
    Autor: Rework por assistant
    Nota: Mantive compatibilidade de API com a versão original
]]

local NeonLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Garantir LocalPlayer
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = Player:GetMouse()

--// Utilidades
local function SafeWaitForChild(instance, name, timeout)
    local t0 = tick()
    while not instance:FindFirstChild(name) do
        if timeout and tick() - t0 > timeout then return nil end
        task.wait()
    end
    return instance:FindFirstChild(name)
end

local function CreateTween(obj, props, time, easingStyle, easingDir)
    local info = TweenInfo.new(time or 0.3, easingStyle or Enum.EasingStyle.Quart, easingDir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function Clamp(v, a, b)
    if v < a then return a end
    if v > b then return b end
    return v
end

local function SafeDestroy(obj)
    if obj and obj.Destroy then
        pcall(function() obj:Destroy() end)
    end
end

-- Modern theme defaults (exponíveis)
local DefaultTheme = {
    Background = Color3.fromRGB(18, 18, 24),
    Panel = Color3.fromRGB(28, 28, 34),
    Accent = Color3.fromRGB(0, 230, 160), -- neon green
    Text = Color3.fromRGB(240, 240, 245),
    Muted = Color3.fromRGB(150, 150, 160),
    Danger = Color3.fromRGB(220, 80, 80)
}

--// Icons Table (mantive suas keys, você pode trocar IDs)
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
    Loading = "rbxassetid://8485997901"
}

--// File system (safe wrappers)
local function SaveKey(key)
    if writefile then
        if not isfolder("NeonLib") then makefolder("NeonLib") end
        pcall(writefile, "NeonLib/Key.txt", key)
    end
end

local function LoadKey()
    if readfile and isfile("NeonLib/Key.txt") then
        local ok, res = pcall(readfile, "NeonLib/Key.txt")
        if ok then return res end
    end
    return nil
end

--// Helper: hover animation for buttons
local function AddHoverEffect(button, hoverProps, leaveProps, duration)
    duration = duration or 0.12
    button.MouseEnter:Connect(function()
        pcall(function() CreateTween(button, hoverProps, duration) end)
    end)
    button.MouseLeave:Connect(function()
        pcall(function() CreateTween(button, leaveProps, duration) end)
    end)
end

--// MAIN WINDOW
function NeonLib:CreateWindow(Settings)
    Settings = Settings or {}
    local WindowName = Settings.Name or "Neon Lib"
    local LoadingName = Settings.LoadingTitle or "Neon Lib"
    local KeySettings = Settings.KeySystem or {}
    local Theme = Settings.Theme or DefaultTheme

    -- KeySettings defaults (compat)
    KeySettings.Enabled = KeySettings.KeyEnable or false
    KeySettings.Key = KeySettings.Key or "1234"
    KeySettings.Site = KeySettings.KeySite or ""
    KeySettings.UseSite = KeySettings.GetKeyFromSite or false
    KeySettings.Save = KeySettings.KeySave or false

    -- Destrói UI antiga se existir com segurança
    local existing = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("NeonLibUI")
    if existing then SafeDestroy(existing) end

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonLibUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Accessibility: allow toggling UI with Ctrl+N
    local Visible = true
    local function ToggleUI()
        Visible = not Visible
        ScreenGui.Enabled = Visible
    end
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.N and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            ToggleUI()
        end
    end)

    --// LOADING UI
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Theme.Background
    LoadingFrame.BackgroundTransparency = 0
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.ZIndex = 100

    local LoadingIcon = Instance.new("ImageLabel")
    LoadingIcon.Parent = LoadingFrame
    LoadingIcon.BackgroundTransparency = 1
    LoadingIcon.Position = UDim2.new(0.5, -60, 0.35, -60)
    LoadingIcon.Size = UDim2.new(0, 120, 0, 120)
    LoadingIcon.Image = Icons.Loading
    LoadingIcon.ScaleType = Enum.ScaleType.Fit

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Parent = LoadingFrame
    LoadingText.BackgroundTransparency = 1
    LoadingText.Position = UDim2.new(0.5, -200, 0.6, 0)
    LoadingText.Size = UDim2.new(0, 400, 0, 30)
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = LoadingName
    LoadingText.TextColor3 = Theme.Text
    LoadingText.TextSize = 20
    LoadingText.TextXAlignment = Enum.TextXAlignment.Center

    local LoadingBarBack = Instance.new("Frame")
    LoadingBarBack.Parent = LoadingFrame
    LoadingBarBack.BackgroundColor3 = Theme.Panel
    LoadingBarBack.Position = UDim2.new(0.5, -150, 0.72, 0)
    LoadingBarBack.Size = UDim2.new(0, 300, 0, 8)
    LoadingBarBack.BorderSizePixel = 0
    local backCorner = Instance.new("UICorner", LoadingBarBack); backCorner.CornerRadius = UDim.new(1,0)
    local backStroke = Instance.new("UIStroke", LoadingBarBack); backStroke.Color = Color3.fromRGB(12,12,12); backStroke.Transparency = 0.6; backStroke.Thickness = 1

    local LoadingBarFill = Instance.new("Frame")
    LoadingBarFill.Parent = LoadingBarBack
    LoadingBarFill.BackgroundColor3 = Theme.Accent
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    local fillCorner = Instance.new("UICorner", LoadingBarFill); fillCorner.CornerRadius = UDim.new(1,0)

    -- Loading animation
    CreateTween(LoadingBarFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.8)
    task.wait(1.9)
    CreateTween(LoadingFrame, {BackgroundTransparency = 1}, 0.35)
    CreateTween(LoadingIcon, {ImageTransparency = 1}, 0.35)
    CreateTween(LoadingText, {TextTransparency = 1}, 0.35)
    CreateTween(LoadingBarBack, {BackgroundTransparency = 1}, 0.35)
    CreateTween(LoadingBarFill, {BackgroundTransparency = 1}, 0.35)
    task.wait(0.4)
    LoadingFrame.Visible = false

    --// KEY SYSTEM
    if KeySettings.Enabled then
        local Passed = false
        local SavedKey = LoadKey()
        local RealKey = KeySettings.Key

        if KeySettings.UseSite and KeySettings.Site ~= "" then
            pcall(function()
                local ok, res = pcall(function() return game:HttpGet(KeySettings.Site) end)
                if ok and res then RealKey = tostring(res):gsub("\n",""):gsub(" ","") end
            end)
        end

        if KeySettings.Save and SavedKey and SavedKey == RealKey then
            Passed = true
        end

        if not Passed then
            LoadingFrame.Visible = true
            LoadingFrame.BackgroundTransparency = 0
            LoadingText.TextTransparency = 0
            LoadingText.Text = "Key System Required"

            -- Key UI Elements
            local KeyBox = Instance.new("TextBox")
            local CheckBtn = Instance.new("TextButton")
            local LinkBtn = Instance.new("TextButton")

            KeyBox.Parent = LoadingFrame
            KeyBox.BackgroundColor3 = Theme.Panel
            KeyBox.Position = UDim2.new(0.5, -120, 0.65, 0)
            KeyBox.Size = UDim2.new(0, 240, 0, 38)
            KeyBox.Font = Enum.Font.Gotham
            KeyBox.PlaceholderText = "Enter Key..."
            KeyBox.Text = ""
            KeyBox.TextColor3 = Theme.Text
            KeyBox.TextSize = 14
            local kbCorner = Instance.new("UICorner", KeyBox); kbCorner.CornerRadius = UDim.new(0,7)
            local kbStroke = Instance.new("UIStroke", KeyBox); kbStroke.Color = Color3.fromRGB(10,10,10); kbStroke.Transparency = 0.6

            CheckBtn.Parent = LoadingFrame
            CheckBtn.BackgroundColor3 = Theme.Accent
            CheckBtn.Position = UDim2.new(0.5, -120, 0.75, 0)
            CheckBtn.Size = UDim2.new(0, 115, 0, 36)
            CheckBtn.Font = Enum.Font.GothamBold
            CheckBtn.Text = "Check Key"
            CheckBtn.TextColor3 = Color3.fromRGB(20,20,20)
            CheckBtn.TextSize = 14
            local cbCorner = Instance.new("UICorner", CheckBtn); cbCorner.CornerRadius = UDim.new(0,7)

            LinkBtn.Parent = LoadingFrame
            LinkBtn.BackgroundColor3 = Theme.Panel
            LinkBtn.Position = UDim2.new(0.5, 5, 0.75, 0)
            LinkBtn.Size = UDim2.new(0, 115, 0, 36)
            LinkBtn.Font = Enum.Font.GothamBold
            LinkBtn.Text = "Get Key"
            LinkBtn.TextColor3 = Theme.Text
            LinkBtn.TextSize = 14
            local lbCorner = Instance.new("UICorner", LinkBtn); lbCorner.CornerRadius = UDim.new(0,7)

            local function CloseKeyUI()
                CreateTween(LoadingFrame, {BackgroundTransparency = 1}, 0.35)
                KeyBox.Visible = false
                CheckBtn.Visible = false
                LinkBtn.Visible = false
                LoadingText.Visible = false
                LoadingFrame.Visible = false
            end

            LinkBtn.MouseButton1Click:Connect(function()
                if setclipboard and KeySettings.Site and KeySettings.Site ~= "" then
                    pcall(setclipboard, KeySettings.Site)
                    LinkBtn.Text = "Copied!"
                    task.wait(1)
                    LinkBtn.Text = "Get Key"
                elseif KeySettings.Site and KeySettings.Site ~= "" then
                    -- fallback: try to open in browser (limited in exploitable contexts)
                    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(KeySettings.Site) end)
                    LinkBtn.Text = "Opened"
                    task.wait(1)
                    LinkBtn.Text = "Get Key"
                end
            end)

            CheckBtn.MouseButton1Click:Connect(function()
                if KeyBox.Text == RealKey then
                    if KeySettings.Save then SaveKey(KeyBox.Text) end
                    CheckBtn.Text = "Correct!"
                    CheckBtn.BackgroundColor3 = Color3.fromRGB(0,200,80)
                    task.wait(0.4)
                    CloseKeyUI()
                else
                    CheckBtn.Text = "Incorrect"
                    CheckBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
                    task.wait(0.9)
                    CheckBtn.Text = "Check Key"
                    CheckBtn.BackgroundColor3 = Theme.Accent
                end
            end)

            -- Wait for key UI to close
            repeat task.wait() until not LoadingFrame.Visible
        end
    end

    --// MAIN UI CONSTRUCTION
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
    MainFrame.Size = UDim2.new(0, 640, 0, 440)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    local mainCorner = Instance.new("UICorner", MainFrame); mainCorner.CornerRadius = UDim.new(0,12)
    local mainStroke = Instance.new("UIStroke", MainFrame); mainStroke.Color = Color3.fromRGB(10,10,10); mainStroke.Transparency = 0.6; mainStroke.Thickness = 1

    -- Edge glow (subtle)
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = MainFrame
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -18, 0, -18)
    Glow.Size = UDim2.new(1, 36, 1, 36)
    Glow.Image = "rbxassetid://5028857472"
    Glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Glow.ZIndex = 0
    Glow.ImageTransparency = 0.9

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Theme.Panel
    Topbar.Size = UDim2.new(1, 0, 0, 48)
    Topbar.BorderSizePixel = 0
    local topCorner = Instance.new("UICorner", Topbar); topCorner.CornerRadius = UDim.new(0,12)
    local topStroke = Instance.new("UIStroke", Topbar); topStroke.Color = Color3.fromRGB(8,8,8); topStroke.Transparency = 0.7; topStroke.Thickness = 1

    -- Topbar fix for bottom corners
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Parent = Topbar
    TopbarFix.BackgroundColor3 = Theme.Panel
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Position = UDim2.new(0,0,1,-8)
    TopbarFix.Size = UDim2.new(1,0,0,8)

    -- Icon + Title
    local Icon = Instance.new("ImageLabel")
    Icon.Parent = Topbar
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 14, 0.5, -16)
    Icon.Size = UDim2.new(0, 32, 0, 32)
    Icon.Image = Icons.Loading
    Icon.ScaleType = Enum.ScaleType.Fit

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 58, 0, 0)
    Title.Size = UDim2.new(0, 260, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = WindowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Control buttons
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Parent = Topbar
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(1, -120, 0.5, -12)
    ButtonContainer.Size = UDim2.new(0, 100, 0, 28)

    local UIList = Instance.new("UIListLayout", ButtonContainer)
    UIList.FillDirection = Enum.FillDirection.Horizontal
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIList.VerticalAlignment = Enum.VerticalAlignment.Center
    UIList.Padding = UDim.new(0,8)

    local MinBtn = Instance.new("ImageButton")
    MinBtn.Parent = ButtonContainer
    MinBtn.BackgroundTransparency = 1
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Image = Icons.Minimize
    MinBtn.ImageColor3 = Theme.Text
    MinBtn.AutoButtonColor = false

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = ButtonContainer
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Image = Icons.Close
    CloseBtn.ImageColor3 = Theme.Danger
    CloseBtn.AutoButtonColor = false

    AddHoverEffect(MinBtn, {ImageColor3 = Theme.Accent}, {ImageColor3 = Theme.Text}, 0.12)
    AddHoverEffect(CloseBtn, {ImageColor3 = Color3.fromRGB(255,120,120)}, {ImageColor3 = Theme.Danger}, 0.12)

    -- Resize handle (corner)
    local ResizeBtn = Instance.new("ImageButton")
    ResizeBtn.Name = "ResizeHandle"
    ResizeBtn.Parent = MainFrame
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Position = UDim2.new(1, -24, 1, -24)
    ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
    ResizeBtn.Image = "" -- empty; clickable region
    ResizeBtn.ZIndex = 10
    ResizeBtn.AutoButtonColor = false

    -- Visual cue for resize (subtle)
    local ResizeVisual = Instance.new("Frame", ResizeBtn)
    ResizeVisual.Size = UDim2.new(1,0,1,0)
    ResizeVisual.BackgroundTransparency = 0.9
    local rvCorner = Instance.new("UICorner", ResizeVisual); rvCorner.CornerRadius = UDim.new(0,4)

    -- Draggable topbar
    local function MakeDraggable(topbar, object)
        local Dragging, DragInput, DragStart, StartPosition

        local function Update(input)
            local Delta = input.Position - DragStart
            local NewPos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            CreateTween(object, {Position = NewPos}, 0.12, Enum.EasingStyle.Cubic)
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
                pcall(Update, input)
            end
        end)
    end

    MakeDraggable(Topbar, MainFrame)

    -- Minimize logic
    local Minimized = false
    local OldSize = MainFrame.Size
    MinBtn.MouseButton1Click:Connect(function()
        if not Minimized then
            OldSize = MainFrame.Size
            CreateTween(MainFrame, {Size = UDim2.new(0, OldSize.X.Offset, 0, 48)}, 0.25)
            Minimized = true
            -- hide content after tween
            task.delay(0.25, function()
                for _, child in pairs(MainFrame:GetChildren()) do
                    if child ~= Topbar and child ~= Glow and child ~= ResizeBtn then
                        child.Visible = false
                    end
                end
            end)
        else
            for _, child in pairs(MainFrame:GetChildren()) do child.Visible = true end
            CreateTween(MainFrame, {Size = OldSize}, 0.25)
            Minimized = false
        end
    end)

    -- Close logic (confirmation modal)
    CloseBtn.MouseButton1Click:Connect(function()
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Parent = ScreenGui
        ConfirmFrame.BackgroundColor3 = Color3.new(0,0,0)
        ConfirmFrame.BackgroundTransparency = 0.5
        ConfirmFrame.Size = UDim2.new(1,0,1,0)
        ConfirmFrame.ZIndex = 300

        local Modal = Instance.new("Frame")
        Modal.Parent = ConfirmFrame
        Modal.Size = UDim2.new(0, 360, 0, 170)
        Modal.Position = UDim2.new(0.5, -180, 0.5, -85)
        Modal.BackgroundColor3 = Theme.Panel
        local mCorner = Instance.new("UICorner", Modal); mCorner.CornerRadius = UDim.new(0,10)
        local mStroke = Instance.new("UIStroke", Modal); mStroke.Color = Color3.fromRGB(8,8,8); mStroke.Transparency = 0.7

        local Txt = Instance.new("TextLabel", Modal)
        Txt.Size = UDim2.new(1,0,0.6,0)
        Txt.Position = UDim2.new(0,0,0,8)
        Txt.Text = "Close Library?"
        Txt.TextColor3 = Theme.Text
        Txt.BackgroundTransparency = 1
        Txt.Font = Enum.Font.GothamBold
        Txt.TextSize = 20

        local Yes = Instance.new("TextButton", Modal)
        Yes.Size = UDim2.new(0,120,0,40)
        Yes.Position = UDim2.new(0.5, 10, 0.7, 0)
        Yes.Text = "Yes"
        Yes.BackgroundColor3 = Theme.Danger
        Yes.TextColor3 = Color3.new(1,1,1)
        local yc = Instance.new("UICorner", Yes)

        local Cancel = Instance.new("TextButton", Modal)
        Cancel.Size = UDim2.new(0,120,0,40)
        Cancel.Position = UDim2.new(0.5, -130, 0.7, 0)
        Cancel.Text = "Cancel"
        Cancel.BackgroundColor3 = Theme.Panel
        Cancel.TextColor3 = Theme.Text
        local cc = Instance.new("UICorner", Cancel)

        Yes.MouseButton1Click:Connect(function()
            SafeDestroy(ScreenGui)
        end)
        Cancel.MouseButton1Click:Connect(function()
            SafeDestroy(ConfirmFrame)
        end)
    end)

    -- Resize logic (mouse/touch)
    local Resizing = false
    local minW, minH = 420, 320
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
        if not Resizing then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local MousePos = UserInputService:GetMouseLocation()
            local CurrentPos = MainFrame.AbsolutePosition
            local NewSizeX = math.floor(MousePos.X - CurrentPos.X)
            local NewSizeY = math.floor(MousePos.Y - CurrentPos.Y)

            -- Clamp to viewport
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
            NewSizeX = Clamp(NewSizeX, minW, viewport.X - 40)
            NewSizeY = Clamp(NewSizeY, minH, viewport.Y - 40)

            MainFrame.Size = UDim2.new(0, NewSizeX, 0, NewSizeY)
        end
    end)

    --// CONTAINERS
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Theme.Panel
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 12, 0, 64)
    TabContainer.Size = UDim2.new(0, 64, 1, -84)
    TabContainer.ScrollBarThickness = 0
    TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None

    -- Ensure layout exists for tab container
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0,10)
    TabContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
    end)

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 88, 0, 64)
    PagesContainer.Size = UDim2.new(1, -104, 1, -84)
    PagesContainer.ClipsDescendants = true

    -- Expor funções e variáveis
    local WindowFunctions = {}
    WindowFunctions.MainFrame = MainFrame
    WindowFunctions.TabContainer = TabContainer
    WindowFunctions.PagesContainer = PagesContainer
    WindowFunctions.Icons = Icons
    WindowFunctions.Theme = Theme

    -- Função para atualizar tema dinamicamente
    function WindowFunctions:SetTheme(newTheme)
        for k,v in pairs(newTheme) do
            self.Theme[k] = v
        end
        -- Aplica cores principais imediatamente
        MainFrame.BackgroundColor3 = self.Theme.Background
        Topbar.BackgroundColor3 = self.Theme.Panel
        Title.TextColor3 = self.Theme.Text
        LoadingBarFill.BackgroundColor3 = self.Theme.Accent
    end

    -- Return objeto
    -- Adicionarei elementos na Parte 2 via função externa (compat)
    -- Retorno de API
    return WindowFunctions
end

--------------------------------------------------------------------------------
-- PARTE 2: ELEMENTS & LOGIC (adiciona após CreateWindow)
--------------------------------------------------------------------------------

-- Esta função adiciona as APIs de criação de abas/elementos ao WindowFunctions retornado
local function AddElementsToWindow(WindowObj)
    local MainFrame = WindowObj.MainFrame
    local TabContainer = WindowObj.TabContainer
    local PagesContainer = WindowObj.PagesContainer
    local Icons = WindowObj.Icons
    local Theme = WindowObj.Theme or DefaultTheme

    local FirstTab = true

    -- Helper para atualizar layout do scrolling frame (pages)
    local function AttachListLayout(scrollingFrame)
        if not scrollingFrame then return end
        if not scrollingFrame:FindFirstChildOfClass("UIListLayout") then
            local layout = Instance.new("UIListLayout", scrollingFrame)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0,8)
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end)
        end
    end

    function WindowObj:CreateTab(Name, IconId)
        local TabName = Name or "Tab"
        local TabIconId = IconId or Icons.Misc

        -- Tab Button (Sidebar)
        local TabBtn = Instance.new("ImageButton")
        TabBtn.Name = TabName .. "_Btn"
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 48, 0, 48)
        TabBtn.Image = TabIconId
        TabBtn.ImageColor3 = Theme.Muted
        TabBtn.AutoButtonColor = false
        local tabCorner = Instance.new("UICorner", TabBtn); tabCorner.CornerRadius = UDim.new(0,10)
        local tabStroke = Instance.new("UIStroke", TabBtn); tabStroke.Color = Color3.fromRGB(8,8,8); tabStroke.Transparency = 0.7

        AddHoverEffect(TabBtn, {ImageColor3 = Theme.Accent}, {ImageColor3 = Theme.Muted}, 0.12)

        -- Tab Page (ScrollingFrame)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.Parent = PagesContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 6
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.Visible = false
        Page.VerticalScrollBarInset = Enum.ScrollBarInset.Always

        AttachListLayout(Page)

        -- Switch logic
        TabBtn.MouseButton1Click:Connect(function()
            -- deactivate all tabs
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("ImageButton") then
                    CreateTween(btn, {ImageColor3 = Theme.Muted}, 0.18)
                end
            end
            for _, pg in pairs(PagesContainer:GetChildren()) do
                if pg:IsA("ScrollingFrame") then pg.Visible = false end
            end
            -- activate
            CreateTween(TabBtn, {ImageColor3 = Theme.Accent}, 0.18)
            Page.Visible = true
        end)

        if FirstTab then
            FirstTab = false
            TabBtn.ImageColor3 = Theme.Accent
            Page.Visible = true
        end

        local Elements = {}

        -- BUTTON
        function Elements:AddButton(Text, Callback)
            Callback = Callback or function() end
            local BtnFrame = Instance.new("Frame")
            BtnFrame.Parent = Page
            BtnFrame.BackgroundColor3 = Theme.Panel
            BtnFrame.Size = UDim2.new(1, -12, 0, 44)
            local bc = Instance.new("UICorner", BtnFrame); bc.CornerRadius = UDim.new(0,8)
            local bstroke = Instance.new("UIStroke", BtnFrame); bstroke.Color = Color3.fromRGB(6,6,6); bstroke.Transparency = 0.75

            local Btn = Instance.new("TextButton")
            Btn.Parent = BtnFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.GothamSemibold
            Btn.Text = Text
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 14
            Btn.AutoButtonColor = false

            AddHoverEffect(BtnFrame, {BackgroundColor3 = Color3.fromRGB(38,38,44)}, {BackgroundColor3 = Theme.Panel}, 0.12)

            Btn.MouseButton1Click:Connect(function()
                -- click feedback
                CreateTween(BtnFrame, {BackgroundColor3 = Color3.fromRGB(46,46,52)}, 0.08)
                task.delay(0.08, function() CreateTween(BtnFrame, {BackgroundColor3 = Theme.Panel}, 0.12) end)
                pcall(Callback)
            end)
        end

        -- TOGGLE
        function Elements:AddToggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Theme.Panel
            ToggleFrame.Size = UDim2.new(1, -12, 0, 44)
            local tc = Instance.new("UICorner", ToggleFrame); tc.CornerRadius = UDim.new(0,8)
            local tstroke = Instance.new("UIStroke", ToggleFrame); tstroke.Color = Color3.fromRGB(6,6,6); tstroke.Transparency = 0.75

            local ToggleText = Instance.new("TextLabel")
            ToggleText.Parent = ToggleFrame
            ToggleText.BackgroundTransparency = 1
            ToggleText.Position = UDim2.new(0, 12, 0, 0)
            ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleText.Font = Enum.Font.Gotham
            ToggleText.Text = Text
            ToggleText.TextColor3 = Theme.Text
            ToggleText.TextSize = 14
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left

            local Switch = Instance.new("Frame")
            Switch.Parent = ToggleFrame
            Switch.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(50,50,56)
            Switch.Position = UDim2.new(1, -64, 0.5, -12)
            Switch.Size = UDim2.new(0, 48, 0, 24)
            local sc = Instance.new("UICorner", Switch); sc.CornerRadius = UDim.new(1,0)

            local Circle = Instance.new("Frame")
            Circle.Parent = Switch
            Circle.BackgroundColor3 = Theme.Text
            Circle.Position = Toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
            Circle.Size = UDim2.new(0, 20, 0, 20)
            local cc = Instance.new("UICorner", Circle); cc.CornerRadius = UDim.new(1,0)

            local ClickArea = Instance.new("TextButton", ToggleFrame)
            ClickArea.BackgroundTransparency = 1
            ClickArea.Size = UDim2.new(1, 0, 1, 0)
            ClickArea.Text = ""
            ClickArea.AutoButtonColor = false

            ClickArea.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local targetColor = Toggled and Theme.Accent or Color3.fromRGB(50,50,56)
                local targetPos = Toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
                CreateTween(Switch, {BackgroundColor3 = targetColor}, 0.18)
                CreateTween(Circle, {Position = targetPos}, 0.18)
                pcall(Callback, Toggled)
            end)
        end

        -- MULTI DROPDOWN
        function Elements:AddMultiDropdown(Text, Options, Callback)
            Options = Options or {}
            Callback = Callback or function() end
            local Selected = {}

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Page
            DropFrame.BackgroundColor3 = Theme.Panel
            DropFrame.Size = UDim2.new(1, -12, 0, 44)
            DropFrame.ClipsDescendants = true
            local dc = Instance.new("UICorner", DropFrame); dc.CornerRadius = UDim.new(0,8)
            local dstroke = Instance.new("UIStroke", DropFrame); dstroke.Color = Color3.fromRGB(6,6,6); dstroke.Transparency = 0.75

            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = DropFrame
            DropBtn.BackgroundTransparency = 1
            DropBtn.Size = UDim2.new(1, 0, 0, 44)
            DropBtn.Text = ""

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Parent = DropFrame
            DropLabel.BackgroundTransparency = 1
            DropLabel.Position = UDim2.new(0, 12, 0, 0)
            DropLabel.Size = UDim2.new(0.7, 0, 0, 44)
            DropLabel.Font = Enum.Font.Gotham
            DropLabel.Text = Text .. " [...]"
            DropLabel.TextColor3 = Theme.Text
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = DropFrame
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -36, 0.5, -10)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Image = "rbxassetid://6034818372"
            Arrow.Rotation = 0

            local List = Instance.new("Frame")
            List.Parent = DropFrame
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 50)
            List.Size = UDim2.new(1, 0, 0, 0)
            local ListLayout = Instance.new("UIListLayout", List)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0,6)

            local Open = false

            -- Generate items
            local function rebuildItems()
                for _, child in pairs(List:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
                for _, opt in pairs(Options) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Parent = List
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(34,34,38)
                    ItemBtn.Size = UDim2.new(1, -24, 0, 32)
                    ItemBtn.Position = UDim2.new(0, 12, 0, 0)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = opt
                    ItemBtn.TextColor3 = Theme.Muted
                    ItemBtn.TextSize = 13
                    local ic = Instance.new("UICorner", ItemBtn); ic.CornerRadius = UDim.new(0,6)
                    ItemBtn.AutoButtonColor = false

                    ItemBtn.MouseButton1Click:Connect(function()
                        if table.find(Selected, opt) then
                            for i,v in pairs(Selected) do if v == opt then table.remove(Selected, i) break end end
                            ItemBtn.TextColor3 = Theme.Muted
                            ItemBtn.BackgroundColor3 = Color3.fromRGB(34,34,38)
                        else
                            table.insert(Selected, opt)
                            ItemBtn.TextColor3 = Theme.Accent
                            ItemBtn.BackgroundColor3 = Color3.fromRGB(44,44,50)
                        end
                        DropLabel.Text = Text .. " [" .. table.concat(Selected, ", ") .. "]"
                        pcall(Callback, Selected)
                    end)
                end
            end
            rebuildItems()

            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local ContentSize = ListLayout.AbsoluteContentSize.Y + 60
                if Open then
                    CreateTween(DropFrame, {Size = UDim2.new(1, -12, 0, ContentSize)}, 0.22)
                    CreateTween(Arrow, {Rotation = 180}, 0.22)
                else
                    CreateTween(DropFrame, {Size = UDim2.new(1, -12, 0, 44)}, 0.22)
                    CreateTween(Arrow, {Rotation = 0}, 0.22)
                end
            end)
        end

        -- TEXTBOX
        function Elements:AddTextbox(Placeholder, Callback)
            Callback = Callback or function() end
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Parent = Page
            BoxFrame.BackgroundColor3 = Theme.Panel
            BoxFrame.Size = UDim2.new(1, -12, 0, 44)
            local bc = Instance.new("UICorner", BoxFrame); bc.CornerRadius = UDim.new(0,8)
            local bstroke = Instance.new("UIStroke", BoxFrame); bstroke.Color = Color3.fromRGB(6,6,6); bstroke.Transparency = 0.75

            local Box = Instance.new("TextBox")
            Box.Parent = BoxFrame
            Box.BackgroundTransparency = 1
            Box.Position = UDim2.new(0, 12, 0, 0)
            Box.Size = UDim2.new(1, -24, 1, 0)
            Box.Font = Enum.Font.Gotham
            Box.PlaceholderText = Placeholder
            Box.Text = ""
            Box.TextColor3 = Theme.Text
            Box.TextSize = 14
            Box.ClearTextOnFocus = false

            Box.FocusLost:Connect(function(enter)
                if enter then pcall(Callback, Box.Text) end
            end)
        end

        -- DROPDOWN (single)
        function Elements:AddDropdown(Text, Options, Callback)
            Options = Options or {}
            Callback = Callback or function() end

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Page
            DropFrame.BackgroundColor3 = Theme.Panel
            DropFrame.Size = UDim2.new(1, -12, 0, 44)
            DropFrame.ClipsDescendants = true
            local dc = Instance.new("UICorner", DropFrame); dc.CornerRadius = UDim.new(0,8)
            local dstroke = Instance.new("UIStroke", DropFrame); dstroke.Color = Color3.fromRGB(6,6,6); dstroke.Transparency = 0.75

            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = DropFrame
            DropBtn.BackgroundTransparency = 1
            DropBtn.Size = UDim2.new(1, 0, 0, 44)
            DropBtn.Text = ""

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Parent = DropFrame
            DropLabel.BackgroundTransparency = 1
            DropLabel.Position = UDim2.new(0, 12, 0, 0)
            DropLabel.Size = UDim2.new(0.7, 0, 0, 44)
            DropLabel.Font = Enum.Font.Gotham
            DropLabel.Text = Text
            DropLabel.TextColor3 = Theme.Text
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left

            local List = Instance.new("Frame")
            List.Parent = DropFrame
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 50)
            List.Size = UDim2.new(1, 0, 0, 0)
            local ListLayout = Instance.new("UIListLayout", List)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0,6)

            local Open = false

            local function RefreshOptions()
                for _, child in pairs(List:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, opt in pairs(Options) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Parent = List
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(34,34,38)
                    ItemBtn.Size = UDim2.new(1, -24, 0, 32)
                    ItemBtn.Text = opt
                    ItemBtn.TextColor3 = Theme.Text
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.TextSize = 13
                    local ic = Instance.new("UICorner", ItemBtn); ic.CornerRadius = UDim.new(0,6)
                    ItemBtn.AutoButtonColor = false

                    ItemBtn.MouseButton1Click:Connect(function()
                        DropLabel.Text = Text .. ": " .. opt
                        pcall(Callback, opt)
                        Open = false
                        CreateTween(DropFrame, {Size = UDim2.new(1, -12, 0, 44)}, 0.22)
                    end)
                end
            end
            RefreshOptions()

            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local ContentSize = ListLayout.AbsoluteContentSize.Y + 60
                if Open then
                    CreateTween(DropFrame, {Size = UDim2.new(1, -12, 0, ContentSize)}, 0.22)
                else
                    CreateTween(DropFrame, {Size = UDim2.new(1, -12, 0, 44)}, 0.22)
                end
            end)

            return {
                Refresh = function(NewOptions)
                    Options = NewOptions
                    RefreshOptions()
                end
            }
        end

        return Elements
    end

    -- AddConfig convenience
    function WindowObj:AddConfig()
        local ConfigTab = WindowObj:CreateTab("Config", Icons.Config)
        ConfigTab:AddDropdown("Theme", {"Dark", "Light (Beta)", "Neon Blue"}, function(val)
            if val == "Dark" then
                WindowObj:SetTheme(DefaultTheme)
            elseif val == "Light (Beta)" then
                WindowObj:SetTheme({
                    Background = Color3.fromRGB(245,245,250),
                    Panel = Color3.fromRGB(255,255,255),
                    Accent = Color3.fromRGB(50,160,255),
                    Text = Color3.fromRGB(20,20,26),
                    Muted = Color3.fromRGB(110,110,120),
                    Danger = Color3.fromRGB(200,70,70)
                })
            elseif val == "Neon Blue" then
                WindowObj:SetTheme({
                    Background = Color3.fromRGB(12,14,24),
                    Panel = Color3.fromRGB(22,26,38),
                    Accent = Color3.fromRGB(0,160,255),
                    Text = Color3.fromRGB(235,235,245),
                    Muted = Color3.fromRGB(140,140,155),
                    Danger = Color3.fromRGB(200,70,70)
                })
            end
        end)

        ConfigTab:AddToggle("Transparency 60%", false, function(state)
            if state then
                CreateTween(MainFrame, {BackgroundTransparency = 0.6}, 0.4)
            else
                CreateTween(MainFrame, {BackgroundTransparency = 0}, 0.4)
            end
        end)

        local ConfigName = "default"
        ConfigTab:AddTextbox("Config Name...", function(text)
            if text and text ~= "" then ConfigName = text end
        end)

        local SavedKeysDropdown = ConfigTab:AddDropdown("Saved Keys", {}, function(val)
            print("Selected Key: " .. val)
        end)

        local function UpdateFiles()
            local Keys = {}
            if listfiles and isfolder("NeonLib") then
                for _, file in pairs(listfiles("NeonLib")) do
                    local name = file:gsub("NeonLib[/\\]", ""):gsub("%.json$", "")
                    table.insert(Keys, name)
                end
            end
            SavedKeysDropdown.Refresh(Keys)
        end

        ConfigTab:AddButton("Save Config", function()
            if writefile then
                if not isfolder("NeonLib") then makefolder("NeonLib") end
                local Data = {Name = ConfigName, Date = os.time(), Theme = WindowObj.Theme}
                pcall(writefile, "NeonLib/"..ConfigName..".json", HttpService:JSONEncode(Data))
                UpdateFiles()
            end
        end)

        ConfigTab:AddButton("Load Config", function()
            if readfile and isfile("NeonLib/"..ConfigName..".json") then
                local ok, raw = pcall(readfile, "NeonLib/"..ConfigName..".json")
                if ok then
                    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
                    if ok2 and data and data.Theme then
                        WindowObj:SetTheme(data.Theme)
                    end
                    print("Loaded config: " .. ConfigName)
                end
            end
        end)

        UpdateFiles()
    end
end
