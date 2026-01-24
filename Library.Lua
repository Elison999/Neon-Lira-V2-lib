--[[ 
    NEON LIB - MODERN UI LIBRARY (PART 1)
    Compatible: PC / Mobile
    Version: 1.0.0
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Proteção de GUI
local Viewport = CoreGui or Player.PlayerGui

-- Tabela Principal da Library
local NeonLib = {
    Settings = {
        Name = "Neon Lib",
        Theme = "Default",
        Icon = "rbxassetid://8485997901", -- Icone Padrão de Loading
        KeySystem = {
            Enabled = false,
            Key = "1234",
            Site = "",
            UseSite = false,
            SaveKey = false,
            FileName = "NeonLibKey.json"
        }
    },
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 25),
            Secondary = Color3.fromRGB(35, 35, 35),
            Stroke = Color3.fromRGB(60, 60, 60),
            Accent = Color3.fromRGB(0, 255, 170), -- Neon Green
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(150, 150, 150),
            Hover = Color3.fromRGB(45, 45, 45)
        },
        DarkBlue = {
            Main = Color3.fromRGB(20, 20, 30),
            Secondary = Color3.fromRGB(30, 30, 45),
            Stroke = Color3.fromRGB(50, 50, 70),
            Accent = Color3.fromRGB(50, 100, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(170, 170, 190),
            Hover = Color3.fromRGB(40, 40, 60)
        }
    },
    Icons = {
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
        Search = "rbxassetid://6031154871", -- Extra útil
        Arrow = "rbxassetid://6034818372" -- Seta para dropdowns
    },
    OpenWindows = {}
}

-- Funções Utilitárias
local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function MakeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frame, TweenInfo.new(0.15), {Position = targetPos}):Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
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

local function MakeResizable(handle, frame)
    local dragging, dragStart, startSize
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = frame.Size
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset + delta.X, startSize.Y.Scale, startSize.Y.Offset + delta.Y)
            -- Limite minimo
            if newSize.X.Offset > 300 and newSize.Y.Offset > 200 then
                 TweenService:Create(frame, TweenInfo.new(0.1), {Size = newSize}):Play()
            end
        end
    end)
end

-- Sistema de Arquivos (Key Save)
local function SaveKey(key)
    if not writefile then return end
    local data = {Key = key}
    writefile(NeonLib.Settings.KeySystem.FileName, HttpService:JSONEncode(data))
end

local function LoadKey()
    if not readfile or not isfile then return nil end
    if isfile(NeonLib.Settings.KeySystem.FileName) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(NeonLib.Settings.KeySystem.FileName))
        end)
        if success and result.Key then
            return result.Key
        end
    end
    return nil
end

-- Inicialização da Library
function NeonLib:MakeWindow(options)
    -- Atualiza Configurações
    NeonLib.Settings.Name = options.Name or NeonLib.Settings.Name
    NeonLib.Settings.Icon = options.Icon or NeonLib.Settings.Icon
    NeonLib.Settings.KeySystem.Enabled = options.KeyEnable or false
    NeonLib.Settings.KeySystem.Key = options.Key or "1234"
    NeonLib.Settings.KeySystem.UseSite = options.GetKeyFromSite or false
    NeonLib.Settings.KeySystem.Site = options.KeySite or ""
    NeonLib.Settings.KeySystem.SaveKey = options.KeySave or false
    
    local CurrentTheme = NeonLib.Themes[NeonLib.Settings.Theme]
    
    -- ScreenGui Principal
    local ScreenGui = Create("ScreenGui", {
        Name = "NeonLib_" .. tostring(math.random(1, 10000)),
        Parent = Viewport,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    -- Proteção contra detecção simples de GUI
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end

    -------------------------------------------------------------------------
    -- SISTEMA DE LOADING
    -------------------------------------------------------------------------
    local LoadingFrame = Create("Frame", {
        Name = "Loading",
        Parent = ScreenGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        ZIndex = 100
    })

    local LoadingIcon = Create("ImageLabel", {
        Parent = LoadingFrame,
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0.4, -40),
        BackgroundTransparency = 1,
        Image = "rbxassetid://"..options.IconLib or NeonLib.Settings.Icon,
        ImageColor3 = CurrentTheme.Accent
    })
    
    local LoadingTitle = Create("TextLabel", {
        Parent = LoadingFrame,
        Size = UDim2.new(0, 200, 0, 30),
        Position = UDim2.new(0.5, -100, 0.5, 10),
        BackgroundTransparency = 1,
        Text = options.LoadingName or "Neon Lib",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 24
    })
    
    local LoadingBarBack = Create("Frame", {
        Parent = LoadingFrame,
        Size = UDim2.new(0, 200, 0, 4),
        Position = UDim2.new(0.5, -100, 0.5, 50),
        BackgroundColor3 = CurrentTheme.Stroke,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = LoadingBarBack, CornerRadius = UDim.new(1, 0)})
    
    local LoadingBarFill = Create("Frame", {
        Parent = LoadingBarBack,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Accent,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = LoadingBarFill, CornerRadius = UDim.new(1, 0)})

    -- Animação de Loading
    local function DoLoading()
        TweenService:Create(LoadingBarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(1.5)
        TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadingIcon, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        TweenService:Create(LoadingTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(LoadingBarBack, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        LoadingBarFill.BackgroundTransparency = 1
        task.wait(0.5)
        LoadingFrame.Visible = false
    end

    -------------------------------------------------------------------------
    -- SISTEMA DE KEY (Se habilitado)
    -------------------------------------------------------------------------
    local function CheckKeySystem()
        if not NeonLib.Settings.KeySystem.Enabled then return true end
        
        local SavedKey = LoadKey()
        if NeonLib.Settings.KeySystem.SaveKey and SavedKey then
            if SavedKey == NeonLib.Settings.KeySystem.Key then
                return true -- Auto Login
            end
        end

        local KeyVerified = false
        
        local KeyFrame = Create("Frame", {
            Parent = ScreenGui,
            Size = UDim2.new(0, 350, 0, 200),
            Position = UDim2.new(0.5, -175, 0.5, -100),
            BackgroundColor3 = CurrentTheme.Main,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 101
        })
        Create("UICorner", {Parent = KeyFrame, CornerRadius = UDim.new(0, 8)})
        Create("UIStroke", {Parent = KeyFrame, Color = CurrentTheme.Stroke, Thickness = 1})

        -- Elementos da Key UI...
        local KeyTitle = Create("TextLabel", {
            Parent = KeyFrame,
            Text = "Security Check",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            TextColor3 = CurrentTheme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 18
        })
        
        local KeyInput = Create("TextBox", {
            Parent = KeyFrame,
            Size = UDim2.new(0.8, 0, 0, 40),
            Position = UDim2.new(0.1, 0, 0.35, 0),
            BackgroundColor3 = CurrentTheme.Secondary,
            TextColor3 = CurrentTheme.Text,
            PlaceholderText = "Enter Key Here...",
            Font = Enum.Font.Gotham,
            TextSize = 14
        })
        Create("UICorner", {Parent = KeyInput, CornerRadius = UDim.new(0, 6)})

        local CheckBtn = Create("TextButton", {
            Parent = KeyFrame,
            Size = UDim2.new(0.35, 0, 0, 35),
            Position = UDim2.new(0.1, 0, 0.7, 0),
            BackgroundColor3 = CurrentTheme.Accent,
            Text = "Check Key",
            TextColor3 = Color3.fromRGB(0,0,0),
            Font = Enum.Font.GothamBold,
            TextSize = 14
        })
        Create("UICorner", {Parent = CheckBtn, CornerRadius = UDim.new(0, 6)})

        local LinkBtn = Create("TextButton", {
            Parent = KeyFrame,
            Size = UDim2.new(0.35, 0, 0, 35),
            Position = UDim2.new(0.55, 0, 0.7, 0),
            BackgroundColor3 = CurrentTheme.Secondary,
            Text = "Get Key",
            TextColor3 = CurrentTheme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14
        })
        Create("UICorner", {Parent = LinkBtn, CornerRadius = UDim.new(0, 6)})

        -- Lógica dos botões
        LinkBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(NeonLib.Settings.KeySystem.Site)
                LinkBtn.Text = "Copied!"
                task.wait(1)
                LinkBtn.Text = "Get Key"
            end
        end)

        CheckBtn.MouseButton1Click:Connect(function()
            local Inputted = KeyInput.Text
            if Inputted == NeonLib.Settings.KeySystem.Key then
                KeyVerified = true
                if NeonLib.Settings.KeySystem.SaveKey then
                    SaveKey(Inputted)
                end
                KeyFrame:Destroy()
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Invalid Key!"
                task.wait(1)
                KeyInput.PlaceholderText = "Enter Key Here..."
            end
        end)

        -- Esperar loading terminar antes de mostrar Key
        task.wait(1.6) 
        KeyFrame.Visible = true
        
        repeat task.wait() until KeyVerified
        return true
    end

    -------------------------------------------------------------------------
    -- JANELA PRINCIPAL
    -------------------------------------------------------------------------
    
    DoLoading()
    CheckKeySystem()

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Size = UDim2.new(0, 550, 0, 350), -- Tamanho Padrão
        Position = UDim2.new(0.5, -275, 0.5, -175),
        BackgroundColor3 = CurrentTheme.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 8)})
    
    local MainStroke = Create("UIStroke", {
        Parent = MainFrame,
        Color = CurrentTheme.Stroke,
        Thickness = 1
    })

    -- Resizer
    local Resizer = Create("TextButton", {
        Parent = MainFrame,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BackgroundTransparency = 1,
        Text = "◢",
        TextColor3 = CurrentTheme.TextDark,
        ZIndex = 10
    })
    MakeResizable(Resizer, MainFrame)

    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = CurrentTheme.Secondary,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Topbar, CornerRadius = UDim.new(0, 8)})
    
    -- Fix para cantos inferiores da Topbar não serem redondos
    local TopbarFix = Create("Frame", {
        Parent = Topbar,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = CurrentTheme.Secondary,
        BorderSizePixel = 0
    })

    MakeDraggable(Topbar, MainFrame)

    local TopbarTitle = Create("TextLabel", {
        Parent = Topbar,
        Text = NeonLib.Settings.Name,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TopbarIcon = Create("ImageLabel", {
        Parent = Topbar,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://"..options.IconLib or NeonLib.Settings.Icon,
        ImageColor3 = CurrentTheme.Accent
    })

    -- Botões da Topbar (Minimize, Close)
    local ButtonsContainer = Create("Frame", {
        Parent = Topbar,
        Size = UDim2.new(0, 70, 1, 0),
        Position = UDim2.new(1, -75, 0, 0),
        BackgroundTransparency = 1
    })
    
    local function CreateTopBtn(icon, pos, callback)
        local btn = Create("ImageButton", {
            Parent = ButtonsContainer,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, pos, 0.5, -12),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = CurrentTheme.TextDark
        })
        btn.MouseEnter:Connect(function() 
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = CurrentTheme.Text}):Play() 
        end)
        btn.MouseLeave:Connect(function() 
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = CurrentTheme.TextDark}):Play() 
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Botão Minimize
    local IsMinimized = false
    local PreMinimizeSize = MainFrame.Size
    
    CreateTopBtn(NeonLib.Icons.Minimize, 0, function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            PreMinimizeSize = MainFrame.Size
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 40)}):Play()
            -- Esconder conteúdo
            for _, v in pairs(MainFrame:GetChildren()) do
                if v.Name == "Container" or v.Name == "Sidebar" then v.Visible = false end
            end
            Resizer.Visible = false
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = PreMinimizeSize}):Play()
            task.wait(0.2)
            for _, v in pairs(MainFrame:GetChildren()) do
                if v.Name == "Container" or v.Name == "Sidebar" then v.Visible = true end
            end
            Resizer.Visible = true
        end
    end)

    -- Botão Close (Com confirmação)
    CreateTopBtn(NeonLib.Icons.Close, 35, function()
        local ConfirmFrame = Create("Frame", {
            Parent = ScreenGui,
            Size = UDim2.new(0, 250, 0, 120),
            Position = UDim2.new(0.5, -125, 0.5, -60),
            BackgroundColor3 = CurrentTheme.Secondary,
            ZIndex = 200
        })
        Create("UICorner", {Parent = ConfirmFrame, CornerRadius = UDim.new(0, 8)})
        Create("UIStroke", {Parent = ConfirmFrame, Color = CurrentTheme.Stroke, Thickness = 1})

        local ConfirmText = Create("TextLabel", {
            Parent = ConfirmFrame,
            Text = "Close Library?",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            TextColor3 = CurrentTheme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 16
        })

        local YesBtn = Create("TextButton", {
            Parent = ConfirmFrame,
            Text = "Yes",
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(0, 15, 0, 70),
            BackgroundColor3 = Color3.fromRGB(200, 50, 50),
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham
        })
        Create("UICorner", {Parent = YesBtn, CornerRadius = UDim.new(0, 6)})

        local NoBtn = Create("TextButton", {
            Parent = ConfirmFrame,
            Text = "Cancel",
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(1, -115, 0, 70),
            BackgroundColor3 = CurrentTheme.Hover,
            TextColor3 = CurrentTheme.Text,
            Font = Enum.Font.Gotham
        })
        Create("UICorner", {Parent = NoBtn, CornerRadius = UDim.new(0, 6)})

        YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
        NoBtn.MouseButton1Click:Connect(function() ConfirmFrame:Destroy() end)
    end)

    -------------------------------------------------------------------------
    -- ESTRUTURA DE ABAS (Sidebar & Container)
    -------------------------------------------------------------------------
    local Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Parent = MainFrame,
        Size = UDim2.new(0, 50, 1, -40), -- Expandido ao passar mouse se quiser, mas vamos manter fixo icone
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = CurrentTheme.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 0
    })
    local SidebarLayout = Create("UIListLayout", {
        Parent = Sidebar,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Create("UIPadding", {Parent = Sidebar, TopPadding = UDim.new(0, 10)})

    local PagesContainer = Create("Frame", {
        Name = "Container",
        Parent = MainFrame,
        Size = UDim2.new(1, -50, 1, -40),
        Position = UDim2.new(0, 50, 0, 40),
        BackgroundTransparency = 1
    })

    -- Objeto Window Retornado
    local Window = {}
    
    -- Função AddTab
    function Window:AddTab(tabConfig)
        local TabName = tabConfig.Name or "Tab"
        local TabIcon = tabConfig.Icon or NeonLib.Icons.Home
        
        -- Página (Scroll)
        local Page = Create("ScrollingFrame", {
            Name = TabName,
            Parent = PagesContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = CurrentTheme.Accent,
            Visible = false -- Oculto por padrão
        })
        Create("UIPadding", {Parent = Page, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})
        local PageLayout = Create("UIListLayout", {
            Parent = Page,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        -- Lógica de auto-update do CanvasSize
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Botão da Sidebar
        local TabBtn = Create("ImageButton", {
            Parent = Sidebar,
            Size = UDim2.new(0, 32, 0, 32),
            BackgroundTransparency = 1,
            Image = "rbxassetid://"..TabIcon,
            ImageColor3 = CurrentTheme.TextDark
        })
        
        -- Efeito de Seleção
        TabBtn.MouseButton1Click:Connect(function()
            -- Resetar todos
            for _, p in pairs(PagesContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("ImageButton") then 
                    TweenService:Create(b, TweenInfo.new(0.2), {ImageColor3 = CurrentTheme.TextDark}):Play() 
                end 
            end
            
            -- Ativar atual
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {ImageColor3 = CurrentTheme.Accent}):Play()
        end)

        -- Selecionar primeira tab automaticamente
        if #PagesContainer:GetChildren() == 1 then
            Page.Visible = true
            TabBtn.ImageColor3 = CurrentTheme.Accent
        end

-- (Continuação de Window:AddTab da Parte 1...)

        local Tab = {}

        -- ELEMENTO: SECTION / LABEL
        function Tab:AddLabel(text)
            local LabelFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1
            })
            
            local LabelText = Create("TextLabel", {
                Parent = LabelFrame,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = CurrentTheme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            return LabelFrame
        end

        -- ELEMENTO: BUTTON
        function Tab:AddButton(options)
            local Callback = options.Callback or function() end
            
            local BtnFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CurrentTheme.Secondary,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            
            local BtnTrigger = Create("TextButton", {
                Parent = BtnFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = options.Name or "Button",
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14
            })

            BtnTrigger.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Hover}):Play()
            end)
            BtnTrigger.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Secondary}):Play()
            end)
            BtnTrigger.MouseButton1Click:Connect(function()
                -- Efeito de clique
                local Ripple = Create("Frame", {
                    Parent = BtnFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.8,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0)
                })
                Create("UICorner", {Parent = Ripple, CornerRadius = UDim.new(0, 6)})
                TweenService:Create(Ripple, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                game:GetService("Debris"):AddItem(Ripple, 0.4)
                
                Callback()
            end)
        end

        -- ELEMENTO: TOGGLE
        function Tab:AddToggle(options)
            local State = options.Default or false
            local Callback = options.Callback or function() end
            
            local ToggleFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CurrentTheme.Secondary,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})
            
            local ToggleTitle = Create("TextLabel", {
                Parent = ToggleFrame,
                Text = options.Name or "Toggle",
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBg = Create("Frame", {
                Parent = ToggleFrame,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = State and CurrentTheme.Accent or Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SwitchBg, CornerRadius = UDim.new(1, 0)})

            local SwitchCircle = Create("Frame", {
                Parent = SwitchBg,
                Size = UDim2.new(0, 16, 0, 16),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SwitchCircle, CornerRadius = UDim.new(1, 0)})

            local Trigger = Create("TextButton", {
                Parent = ToggleFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ""
            })

            Trigger.MouseButton1Click:Connect(function()
                State = not State
                Callback(State)
                
                if State then
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Accent}):Play()
                    TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                else
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
            end)
        end

        -- ELEMENTO: SLIDER
        function Tab:AddSlider(options)
            local Min = options.Min or 0
            local Max = options.Max or 100
            local Default = options.Default or Min
            local Callback = options.Callback or function() end
            
            local SliderFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = CurrentTheme.Secondary,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 6)})
            
            local SliderTitle = Create("TextLabel", {
                Parent = SliderFrame,
                Text = options.Name or "Slider",
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                Text = tostring(Default),
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = CurrentTheme.TextDark,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local BarBack = Create("Frame", {
                Parent = SliderFrame,
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = BarBack, CornerRadius = UDim.new(1, 0)})

            local BarFill = Create("Frame", {
                Parent = BarBack,
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = CurrentTheme.Accent,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = BarFill, CornerRadius = UDim.new(1, 0)})
            
            local Knob = Create("Frame", {
                Parent = BarFill,
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(1, -6, 0.5, -6),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

            local IsDragging = false
            local Trigger = Create("TextButton", {
                Parent = SliderFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ""
            })

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local SizeX = math.clamp((input.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
                    local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                    
                    TweenService:Create(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
                    ValueLabel.Text = tostring(NewValue)
                    Callback(NewValue)
                end
            end)
        end

        -- ELEMENTO: DROPDOWN (Normal)
        function Tab:AddDropdown(options)
            local Items = options.Items or {}
            local Default = options.Default
            local Callback = options.Callback or function() end
            local IsOpen = false

            local DropFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CurrentTheme.Secondary,
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 6)})

            local DropTitle = Create("TextLabel", {
                Parent = DropFrame,
                Text = (options.Name or "Dropdown") .. ": " .. (Default or "..."),
                Size = UDim2.new(0.8, 0, 0, 36),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Arrow = Create("ImageLabel", {
                Parent = DropFrame,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0, 8),
                BackgroundTransparency = 1,
                Image = NeonLib.Icons.Arrow,
                ImageColor3 = CurrentTheme.TextDark
            })

            local Trigger = Create("TextButton", {
                Parent = DropFrame,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = ""
            })

            local ListLayout = Create("UIListLayout", {
                Parent = DropFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            })
            Create("UIPadding", {Parent = DropFrame, PaddingTop = UDim.new(0, 36)})

            local function RefreshItems()
                for _, v in pairs(DropFrame:GetChildren()) do
                    if v:IsA("TextButton") and v ~= Trigger then v:Destroy() end
                end
                
                for _, item in pairs(Items) do
                    local ItemBtn = Create("TextButton", {
                        Parent = DropFrame,
                        Size = UDim2.new(1, -10, 0, 25),
                        Position = UDim2.new(0, 5, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Text = item,
                        TextColor3 = CurrentTheme.TextDark,
                        Font = Enum.Font.Gotham,
                        TextSize = 13
                    })
                    Create("UICorner", {Parent = ItemBtn, CornerRadius = UDim.new(0, 4)})
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        IsOpen = false
                        DropTitle.Text = (options.Name or "Dropdown") .. ": " .. item
                        TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        Callback(item)
                    end)
                end
            end

            RefreshItems()

            Trigger.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                local ContentSize = 36 + (#Items * 27) + 5
                
                if IsOpen then
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, ContentSize)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end
            end)
        end

        -- ELEMENTO: MULTI DROPDOWN
        function Tab:AddMultiDropdown(options)
            local Items = options.Items or {}
            local Selected = {}
            local Callback = options.Callback or function() end
            local IsOpen = false

            local MultiFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CurrentTheme.Secondary,
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = MultiFrame, CornerRadius = UDim.new(0, 6)})

            local MultiTitle = Create("TextLabel", {
                Parent = MultiFrame,
                Text = (options.Name or "Multi Select"),
                Size = UDim2.new(0.8, 0, 0, 36),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Arrow = Create("ImageLabel", {
                Parent = MultiFrame,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0, 8),
                BackgroundTransparency = 1,
                Image = NeonLib.Icons.Arrow,
                ImageColor3 = CurrentTheme.TextDark
            })

            local Trigger = Create("TextButton", {
                Parent = MultiFrame,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = ""
            })
            
            Create("UIListLayout", {
                Parent = MultiFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            })
            Create("UIPadding", {Parent = MultiFrame, PaddingTop = UDim.new(0, 36)})

            local function UpdateTitle()
                local count = 0
                for _ in pairs(Selected) do count = count + 1 end
                MultiTitle.Text = (options.Name or "Multi Select") .. " [" .. count .. "]"
            end

            local function BuildList()
                for _, item in pairs(Items) do
                    local ItemBtn = Create("TextButton", {
                        Parent = MultiFrame,
                        Size = UDim2.new(1, -10, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        Text = item,
                        TextColor3 = CurrentTheme.TextDark,
                        Font = Enum.Font.Gotham,
                        TextSize = 13
                    })
                    Create("UICorner", {Parent = ItemBtn, CornerRadius = UDim.new(0, 4)})
                    
                    -- Indicador de Check
                    local Check = Create("Frame", {
                        Parent = ItemBtn,
                        Size = UDim2.new(0, 10, 0, 10),
                        Position = UDim2.new(1, -15, 0.5, -5),
                        BackgroundColor3 = CurrentTheme.Secondary,
                        BorderSizePixel = 0
                    })
                    Create("UICorner", {Parent = Check, CornerRadius = UDim.new(0, 2)})

                    ItemBtn.MouseButton1Click:Connect(function()
                        if Selected[item] then
                            Selected[item] = nil
                            TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Secondary}):Play()
                            TweenService:Create(ItemBtn, TweenInfo.new(0.2), {TextColor3 = CurrentTheme.TextDark}):Play()
                        else
                            Selected[item] = true
                            TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Accent}):Play()
                            TweenService:Create(ItemBtn, TweenInfo.new(0.2), {TextColor3 = CurrentTheme.Text}):Play()
                        end
                        UpdateTitle()
                        Callback(Selected)
                    end)
                end
            end
            
            BuildList()

            Trigger.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                local ContentSize = 36 + (#Items * 27) + 5
                
                if IsOpen then
                    TweenService:Create(MultiFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, ContentSize)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    TweenService:Create(MultiFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end
            end)
        end
        
        -- ELEMENTO: TEXTBOX
        function Tab:AddTextbox(options)
            local Callback = options.Callback or function() end
            
            local TextboxFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CurrentTheme.Secondary,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = TextboxFrame, CornerRadius = UDim.new(0, 6)})
            
            local Label = Create("TextLabel", {
                Parent = TextboxFrame,
                Text = options.Name or "Textbox",
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Input = Create("TextBox", {
                Parent = TextboxFrame,
                Size = UDim2.new(0.35, 0, 0.7, 0),
                Position = UDim2.new(0.62, 0, 0.15, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Text = options.Default or "",
                PlaceholderText = "Type..."
            })
            Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 4)})
            
            Input.FocusLost:Connect(function(enter)
                Callback(Input.Text)
            end)
        end

        return Tab
    end

    -------------------------------------------------------------------------
    -- SISTEMA DE CONFIGURAÇÃO (Window:AddConfig)
    -------------------------------------------------------------------------
    function Window:AddConfig()
        local ConfigTab = Window:AddTab({Name = "Settings", Icon = NeonLib.Icons.Config})
        
        ConfigTab:AddLabel("Visual Settings")
        
        -- Toggle: Transparência 60%
        ConfigTab:AddToggle({
            Name = "Transparent Mode (60%)",
            Default = false,
            Callback = function(val)
                local MainFrame = ScreenGui:FindFirstChild("MainFrame")
                if MainFrame then
                    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = val and 0.6 or 0}):Play()
                end
            end
        })
        
        -- Dropdown: Temas (Simulação simples, troca reinicia UI idealmente, mas aqui muda as cores base se fosse reativo)
        -- Nota: Para um sistema de tema realtime completo, precisaria de uma tabela proxy, mas faremos o básico.
        ConfigTab:AddDropdown({
            Name = "UI Theme",
            Items = {"Default", "DarkBlue"},
            Default = "Default",
            Callback = function(val)
                NeonLib.Settings.Theme = val
                -- Aviso visual
                print("Theme changed to " .. val .. " (Restart UI to apply full changes)")
            end
        })
        
        ConfigTab:AddLabel("Key System Config")
        
        local KeyToSave = ""
        ConfigTab:AddTextbox({
            Name = "Custom Key",
            Default = NeonLib.Settings.KeySystem.Key,
            Callback = function(text)
                KeyToSave = text
            end
        })
        
        -- Salvar Key em arquivo
        ConfigTab:AddButton({
            Name = "Save Key for Auto-Login",
            Callback = function()
                if writefile and KeyToSave ~= "" then
                   local data = {Key = KeyToSave}
                   writefile(NeonLib.Settings.KeySystem.FileName, HttpService:JSONEncode(data))
                   NeonLib.Settings.KeySystem.Key = KeyToSave
                end
            end
        })
        
        -- Lista de Keys Salvas (Se houvesse multiplas, aqui mostra a atual lida do arquivo)
        local SavedKeys = {}
        if isfile and isfile(NeonLib.Settings.KeySystem.FileName) then
            table.insert(SavedKeys, "Current Saved Key")
        else
            table.insert(SavedKeys, "No Keys Saved")
        end
        
        ConfigTab:AddDropdown({
            Name = "Saved Keys",
            Items = SavedKeys,
            Default = SavedKeys[1],
            Callback = function(val)
                -- Lógica para carregar
            end
        })
        
        ConfigTab:AddLabel("Config Manager")
        
        -- Botões Save/Load (Para configs do script)
        -- Nota: Isso requer que o usuário do script faça a lógica de exportar as flags.
        ConfigTab:AddButton({
            Name = "Save Configuration",
            Callback = function()
                print("Config Saved (Placeholder)")
            end
        })
        
        ConfigTab:AddButton({
            Name = "Load Configuration",
            Callback = function()
                print("Config Loaded (Placeholder)")
            end
        })
    end

    return Window
end

return NeonLib
