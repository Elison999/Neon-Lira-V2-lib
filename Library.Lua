--[[ 
    NEON LIB - MODERN UI LIBRARY (PART 1) - Aesthetic improvements + Decal IDs for icons
    Compatible: Mobile/PC
    Author: AI Assistant (improved visuals)
    Notes:
    - Icons table now contains plain Decal ids (numbers as strings). FormatAssetId will convert to rbxassetid:// when used.
    - UI visuals improved: gradients, subtle drop shadow, refined paddings, hover/tween polish.
    - No breaking changes to existing public API.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Use PlayerGui instead of CoreGui (protection)
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Utility: format asset ids (accepts number, "12345", "rbxassetid://12345" or decal id)
local function FormatAssetId(id)
    if not id then return "" end
    local s = tostring(id)
    if s:find("rbxassetid://") then
        return s
    end
    -- if already a full URL (http) or decal url, return as-is (developer might pass external)
    if s:find("^http") then return s end
    -- if numeric or numeric string -> make rbxassetid://
    if tonumber(s) then
        return "rbxassetid://" .. s
    end
    -- otherwise return original
    return s
end

-- Library Table
local Library = {
    Flags = {},
    Theme = {
        Main = Color3.fromRGB(18, 18, 20),
        Secondary = Color3.fromRGB(30, 30, 34),
        Accent = Color3.fromRGB(0, 230, 170), -- Soft neon green
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(170, 170, 170),
        Stroke = Color3.fromRGB(45, 45, 50),
        Transparency = 0
    },
    -- Icons changed to Decal ids (plain numbers as strings).
    Icons = {
        Home = "131948203611073",
        Minimize = "116382519234568",
        Close = "101967696350111",
        Config = "11308562750",
        Visual = "16369898474",
        Combat = "4391741908",
        Store = "13429538960",
        Crosshair = "12614416526",
        Map = "13549782540",
        Player = "7199219794",
        Misc = "114882667336771",
        Resize = "12543323087",
        Warning = "11401835376"
    }
}

-- Small helper: create soft drop shadow behind a frame
local function CreateShadow(parent, targetFrame, zIndex)
    -- optional: use a common shadow decal (will be formatted via FormatAssetId)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Parent = parent
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = FormatAssetId("6014260683") -- common rounded shadow decal
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.6
    shadow.ZIndex = zIndex or 0

    local function sync()
        if not targetFrame.Parent then shadow:Destroy() return end
        shadow.Position = targetFrame.Position
        shadow.Size = targetFrame.Size + UDim2.new(0, 24, 0, 24)
        shadow.Rotation = 0
        shadow.AnchorPoint = targetFrame.AnchorPoint
    end
    -- initial
    sync()
    -- keep synced on render step to avoid layout jitter
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not targetFrame.Parent then
            conn:Disconnect()
            if shadow then shadow:Destroy() end
            return
        end
        sync()
    end)
    return shadow
end

-- Utility Functions (draggable, ripple) with slight polish
local function MakeDraggable(topbarobject, object)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local pos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(object, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos}):Play()
    end

    topbarobject.InputBegan:Connect(function(input)
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

    topbarobject.InputChanged:Connect(function(input)
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

local function CreateRipple(Button)
    task.spawn(function()
        local Ripple = Instance.new("ImageLabel")
        Ripple.Name = "Ripple"
        Ripple.Parent = Button
        Ripple.BackgroundTransparency = 1
        Ripple.BorderSizePixel = 0
        Ripple.Image = FormatAssetId("2708891598")
        Ripple.ImageColor3 = Color3.new(1,1,1)
        Ripple.ImageTransparency = 0.82
        Ripple.ScaleType = Enum.ScaleType.Fit
        Ripple.ZIndex = Button.ZIndex + 5

        local mousePos = UserInputService:GetMouseLocation()
        local btnPos = Button.AbsolutePosition
        local rx = mousePos.X - btnPos.X
        local ry = mousePos.Y - btnPos.Y
        Ripple.Position = UDim2.new(0, rx, 0, ry)
        Ripple.Size = UDim2.new(0, 0, 0, 0)

        local target = 240
        local tween = TweenService:Create(Ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, target, 0, target),
            Position = UDim2.new(0, rx - target/2, 0, ry - target/2),
            ImageTransparency = 1
        })
        tween:Play()
        tween.Completed:Wait()
        if Ripple and Ripple.Parent then Ripple:Destroy() end
    end)
end

-- ScreenGUI Setup
local NeonLibGui = Instance.new("ScreenGui")
NeonLibGui.Name = "NeonLib_" .. tostring(math.random(1000,9999))
NeonLibGui.Parent = PlayerGui
NeonLibGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NeonLibGui.ResetOnSpawn = false

-- Constructor
function Library:CreateWindow(Settings)
    local WindowFunctions = {}
    
    Settings = Settings or {}
    Settings.Name = Settings.Name or "Neon Lib"
    Settings.LoadingName = Settings.LoadingName or "Neon Lib"
    Settings.Icon = Settings.Icon or Settings.IconLib or Library.Icons.Home
    Settings.KeyEnable = Settings.KeyEnable or false
    Settings.Key = Settings.Key or "1234"
    Settings.KeySite = Settings.KeySite or ""
    Settings.GetKeyFromSite = Settings.GetKeyFromSite or false
    Settings.KeySave = Settings.KeySave or false
    
    local KeyFileName = "NeonLib_Key_" .. Settings.Name:gsub(" ", "") .. ".txt"
    local Verified = false

    local function CheckSavedKey()
        if not Settings.KeySave then return false end
        if type(isfile) == "function" and isfile(KeyFileName) then
            local SavedKey = readfile(KeyFileName)
            if Settings.GetKeyFromSite and Settings.KeySite and Settings.KeySite ~= "" then
                local Success, SiteKey = pcall(function()
                    return game:HttpGet(Settings.KeySite)
                end)
                if Success and SiteKey then
                    SiteKey = SiteKey:gsub("\n", ""):gsub(" ", "")
                    return SavedKey == SiteKey
                else
                    return false
                end
            else
                return SavedKey == Settings.Key
            end
        end
        return false
    end

    local function SaveKey(keyToSave)
        if Settings.KeySave and type(writefile) == "function" then
            writefile(KeyFileName, keyToSave)
        end
    end

    -- LOADING SYSTEM
    local LoadingFrame = Instance.new("Frame")
    local LoadingIcon = Instance.new("ImageLabel")
    local LoadingTitle = Instance.new("TextLabel")
    local LoadingBarBack = Instance.new("Frame")
    local LoadingBarFill = Instance.new("Frame")

    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = NeonLibGui
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingFrame.BackgroundColor3 = Library.Theme.Main
    LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingFrame.Size = UDim2.new(0, 0, 0, 0) -- Starts small
    LoadingFrame.ClipsDescendants = true
    
    local LCorner = Instance.new("UICorner")
    LCorner.CornerRadius = UDim.new(0, 12)
    LCorner.Parent = LoadingFrame

    -- soft shadow for loading box
    CreateShadow(NeonLibGui, LoadingFrame, 2)

    LoadingIcon.Name = "Icon"
    LoadingIcon.Parent = LoadingFrame
    LoadingIcon.AnchorPoint = Vector2.new(0.5, 0)
    LoadingIcon.BackgroundTransparency = 1
    LoadingIcon.Position = UDim2.new(0.5, 0, 0.12, 0)
    LoadingIcon.Size = UDim2.new(0, 72, 0, 72)
    LoadingIcon.Image = FormatAssetId(Settings.Icon)
    LoadingIcon.ImageColor3 = Library.Theme.Accent
    LoadingIcon.ScaleType = Enum.ScaleType.Fit

    LoadingTitle.Parent = LoadingFrame
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Position = UDim2.new(0, 0, 0.55, 0)
    LoadingTitle.Size = UDim2.new(1, 0, 0, 28)
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Text = Settings.LoadingName
    LoadingTitle.TextColor3 = Library.Theme.Text
    LoadingTitle.TextSize = 22

    LoadingBarBack.Parent = LoadingFrame
    LoadingBarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
    LoadingBarBack.Position = UDim2.new(0.1, 0, 0.78, 0)
    LoadingBarBack.Size = UDim2.new(0.8, 0, 0, 8)
    local backCorner = Instance.new("UICorner", LoadingBarBack)
    backCorner.CornerRadius = UDim.new(1, 0)

    LoadingBarFill.Parent = LoadingBarBack
    LoadingBarFill.BackgroundColor3 = Library.Theme.Accent
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", LoadingBarFill).CornerRadius = UDim.new(1, 0)

    local function PlayLoading()
        LoadingFrame.Visible = true
        TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 320, 0, 220)}):Play()
        task.wait(0.55)
        TweenService:Create(LoadingBarFill, TweenInfo.new(1.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(1.45)
        TweenService:Create(LoadingFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.38)
        LoadingFrame.Visible = false
    end

    -- KEY SYSTEM UI
    if Settings.KeyEnable then
        if CheckSavedKey() then
            Verified = true
            PlayLoading()
        else
            local KeyFrame = Instance.new("Frame")
            KeyFrame.Name = "KeySystem"
            KeyFrame.Parent = NeonLibGui
            KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            KeyFrame.BackgroundColor3 = Library.Theme.Main
            KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            KeyFrame.Size = UDim2.new(0, 380, 0, 230)
            Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
            local stroke = Instance.new("UIStroke", KeyFrame)
            stroke.Color = Library.Theme.Stroke
            stroke.Thickness = 1

            CreateShadow(NeonLibGui, KeyFrame, 3)

            local KeyTitle = Instance.new("TextLabel")
            KeyTitle.Text = "Key System"
            KeyTitle.Font = Enum.Font.GothamBold
            KeyTitle.TextSize = 20
            KeyTitle.TextColor3 = Library.Theme.Text
            KeyTitle.Size = UDim2.new(1,0,0,40)
            KeyTitle.BackgroundTransparency = 1
            KeyTitle.Parent = KeyFrame

            local KeyBox = Instance.new("TextBox")
            KeyBox.Parent = KeyFrame
            KeyBox.BackgroundColor3 = Library.Theme.Secondary
            KeyBox.Position = UDim2.new(0.07, 0, 0.33, 0)
            KeyBox.Size = UDim2.new(0.86, 0, 0, 44)
            KeyBox.Font = Enum.Font.Gotham
            KeyBox.PlaceholderText = "Enter Key..."
            KeyBox.Text = ""
            KeyBox.TextColor3 = Library.Theme.Text
            KeyBox.TextSize = 15
            Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)
            local kbStroke = Instance.new("UIStroke", KeyBox)
            kbStroke.Color = Library.Theme.Stroke
            kbStroke.Thickness = 1

            local CheckBtn = Instance.new("TextButton")
            CheckBtn.Parent = KeyFrame
            CheckBtn.BackgroundColor3 = Library.Theme.Accent
            CheckBtn.Position = UDim2.new(0.07, 0, 0.68, 0)
            CheckBtn.Size = UDim2.new(0.4, 0, 0, 38)
            CheckBtn.Font = Enum.Font.GothamBold
            CheckBtn.Text = "Check"
            CheckBtn.TextColor3 = Library.Theme.Main
            CheckBtn.TextSize = 15
            Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 8)

            local LinkBtn = Instance.new("TextButton")
            LinkBtn.Parent = KeyFrame
            LinkBtn.BackgroundColor3 = Library.Theme.Secondary
            LinkBtn.Position = UDim2.new(0.53, 0, 0.68, 0)
            LinkBtn.Size = UDim2.new(0.4, 0, 0, 38)
            LinkBtn.Font = Enum.Font.GothamBold
            LinkBtn.Text = "Get Key"
            LinkBtn.TextColor3 = Library.Theme.Text
            LinkBtn.TextSize = 15
            Instance.new("UICorner", LinkBtn).CornerRadius = UDim.new(0, 8)
            
            LinkBtn.MouseEnter:Connect(function()
                TweenService:Create(LinkBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45,45,48)}):Play()
            end)
            LinkBtn.MouseLeave:Connect(function()
                TweenService:Create(LinkBtn, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.Secondary}):Play()
            end)

            LinkBtn.MouseButton1Click:Connect(function()
                if type(setclipboard) == "function" and Settings.KeySite and Settings.KeySite ~= "" then
                    setclipboard(Settings.KeySite)
                    LinkBtn.Text = "Copied!"
                    task.wait(1)
                    LinkBtn.Text = "Get Key"
                else
                    LinkBtn.Text = "Unavailable"
                    task.wait(1)
                    LinkBtn.Text = "Get Key"
                end
            end)

            CheckBtn.MouseButton1Click:Connect(function()
                local InputKey = KeyBox.Text
                local Valid = false
                
                if Settings.GetKeyFromSite and Settings.KeySite and Settings.KeySite ~= "" then
                    local Success, SiteKey = pcall(function()
                        return game:HttpGet(Settings.KeySite)
                    end)
                    if Success and SiteKey then
                        SiteKey = SiteKey:gsub("\n", ""):gsub(" ", "")
                        if InputKey == SiteKey then Valid = true end
                    end
                else
                    if InputKey == Settings.Key then Valid = true end
                end

                if Valid then
                    CheckBtn.Text = "Success!"
                    SaveKey(InputKey)
                    task.wait(0.45)
                    KeyFrame:Destroy()
                    Verified = true
                    PlayLoading()
                else
                    CheckBtn.Text = "Incorrect"
                    CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
                    task.wait(1)
                    CheckBtn.Text = "Check"
                    CheckBtn.BackgroundColor3 = Library.Theme.Accent
                end
            end)

            repeat task.wait() until Verified
        end
    else
        PlayLoading()
    end

    -- MAIN UI STRUCTURE
    local MainFrame = Instance.new("Frame")
    local Topbar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local IconImg = Instance.new("ImageLabel")
    local Container = Instance.new("Frame")
    local TabContainer = Instance.new("ScrollingFrame") -- Sidebar
    local ElementsContainer = Instance.new("Frame") -- where elements reside

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = NeonLibGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Library.Theme.Main
    MainFrame.BackgroundTransparency = Library.Theme.Transparency
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 680, 0, 420)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 12)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Library.Theme.Stroke
    MainStroke.Thickness = 1

    -- drop shadow
    CreateShadow(NeonLibGui, MainFrame, 1)

    -- Topbar
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Library.Theme.Secondary
    Topbar.Size = UDim2.new(1, 0, 0, 48)
    Topbar.ClipsDescendants = true
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 12)
    
    -- subtle gradient on topbar
    local topGrad = Instance.new("UIGradient", Topbar)
    topGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Library.Theme.Secondary:lerp(Library.Theme.Main, 0.06)),
        ColorSequenceKeypoint.new(1, Library.Theme.Secondary)
    }
    topGrad.Rotation = 90

    -- Hide bottom corners of topbar by overlay
    local TopbarHider = Instance.new("Frame")
    TopbarHider.Parent = Topbar
    TopbarHider.BackgroundColor3 = Topbar.BackgroundColor3
    TopbarHider.BorderSizePixel = 0
    TopbarHider.Position = UDim2.new(0,0,0.83,0)
    TopbarHider.Size = UDim2.new(1,0,0.17,0)
    TopbarHider.ZIndex = 2

    MakeDraggable(Topbar, MainFrame)

    IconImg.Parent = Topbar
    IconImg.Position = UDim2.new(0, 12, 0, 8)
    IconImg.Size = UDim2.new(0, 28, 0, 28)
    IconImg.Image = FormatAssetId(Settings.Icon)
    IconImg.ImageColor3 = Library.Theme.Accent
    IconImg.BackgroundTransparency = 1
    IconImg.ScaleType = Enum.ScaleType.Fit

    Title.Parent = Topbar
    Title.Position = UDim2.new(0, 48, 0, 0)
    Title.Size = UDim2.new(0, 280, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Settings.Name
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Topbar Buttons Holder
    local ButtonHolder = Instance.new("Frame", Topbar)
    ButtonHolder.AnchorPoint = Vector2.new(1, 0.5)
    ButtonHolder.Position = UDim2.new(1, -12, 0.5, 0)
    ButtonHolder.Size = UDim2.new(0, 120, 0, 28)
    ButtonHolder.BackgroundTransparency = 1
    local UIListLayout = Instance.new("UIListLayout", ButtonHolder)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

    local function CreateTopBtn(id, icon, callback)
        local btn = Instance.new("ImageButton")
        btn.Name = id
        btn.Parent = ButtonHolder
        btn.BackgroundColor3 = Color3.fromRGB(45,45,48)
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.Image = FormatAssetId(icon)
        btn.ImageColor3 = Library.Theme.Text
        btn.AutoButtonColor = false
        btn.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Library.Theme.Stroke
        stroke.Thickness = 1

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Library.Theme.Accent, ImageColor3 = Library.Theme.Main, Size = UDim2.new(0, 30, 0, 30)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(45,45,48), ImageColor3 = Library.Theme.Text, Size = UDim2.new(0, 28, 0, 28)}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            CreateRipple(btn)
            callback()
        end)
        return btn
    end

    -- Close Logic with Prompt (kept, but styled)
    CreateTopBtn("Close", Library.Icons.Close, function()
        local Prompt = Instance.new("Frame")
        Prompt.Parent = NeonLibGui
        Prompt.Size = UDim2.new(1, 0, 1, 0)
        Prompt.BackgroundColor3 = Color3.new(0,0,0)
        Prompt.BackgroundTransparency = 0.55
        Prompt.ZIndex = 120

        local PBox = Instance.new("Frame")
        PBox.Parent = Prompt
        PBox.Size = UDim2.new(0, 340, 0, 160)
        PBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        PBox.AnchorPoint = Vector2.new(0.5, 0.5)
        PBox.BackgroundColor3 = Library.Theme.Main
        Instance.new("UICorner", PBox).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", PBox).Color = Library.Theme.Stroke

        CreateShadow(Prompt, PBox, 200)

        local PText = Instance.new("TextLabel")
        PText.Parent = PBox
        PText.Size = UDim2.new(1, 0, 0.6, 0)
        PText.Text = "Close Library?"
        PText.Font = Enum.Font.GothamBold
        PText.TextColor3 = Library.Theme.Text
        PText.TextSize = 20
        PText.BackgroundTransparency = 1

        local YesBtn = Instance.new("TextButton")
        YesBtn.Parent = PBox
        YesBtn.Size = UDim2.new(0.42, 0, 0, 36)
        YesBtn.Position = UDim2.new(0.06, 0, 0.7, 0)
        YesBtn.BackgroundColor3 = Color3.fromRGB(235, 70, 70)
        YesBtn.Text = "Yes"
        YesBtn.TextColor3 = Color3.new(1,1,1)
        YesBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 8)

        local CancelBtn = Instance.new("TextButton")
        CancelBtn.Parent = PBox
        CancelBtn.Size = UDim2.new(0.42, 0, 0, 36)
        CancelBtn.Position = UDim2.new(0.52, 0, 0.7, 0)
        CancelBtn.BackgroundColor3 = Library.Theme.Secondary
        CancelBtn.Text = "Cancel"
        CancelBtn.TextColor3 = Library.Theme.Text
        CancelBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 8)

        YesBtn.MouseButton1Click:Connect(function()
            NeonLibGui:Destroy()
        end)
        CancelBtn.MouseButton1Click:Connect(function()
            Prompt:Destroy()
        end)
    end)

    -- Minimize Logic
    local Minimized = false
    local OldSize = MainFrame.Size
    CreateTopBtn("Minimize", Library.Icons.Minimize, function()
        Minimized = not Minimized
        if Minimized then
            OldSize = MainFrame.Size
            TweenService:Create(MainFrame, TweenInfo.new(0.28), {Size = UDim2.new(0, 680, 0, 48)}):Play()
            Container.Visible = false
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.28), {Size = OldSize}):Play()
            task.wait(0.28)
            Container.Visible = true
        end
    end)

    -- Resize Logic
    local IsLarge = false
    CreateTopBtn("Resize", Library.Icons.Resize, function()
        IsLarge = not IsLarge
        if IsLarge then
            TweenService:Create(MainFrame, TweenInfo.new(0.28), {Size = UDim2.new(0, 920, 0, 560)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.28), {Size = UDim2.new(0, 680, 0, 420)}):Play()
        end
    end)

    -- Container Setup
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundColor3 = Color3.new(1,1,1)
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 48)
    Container.Size = UDim2.new(1, 0, 1, -48)

    -- Sidebar (Tabs) - wider to show icons nicely
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Container
    TabContainer.BackgroundColor3 = Library.Theme.Secondary
    TabContainer.BackgroundTransparency = 0.6
    TabContainer.Size = UDim2.new(0, 76, 1, 0)
    TabContainer.ScrollBarThickness = 0
    TabContainer.ClipsDescendants = true
    
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 12)

    local TabPadding = Instance.new("UIPadding", TabContainer)
    TabPadding.PaddingTop = UDim.new(0, 14)
    TabPadding.PaddingBottom = UDim.new(0, 12)

    -- Pages Area
    ElementsContainer.Name = "Elements"
    ElementsContainer.Parent = Container
    ElementsContainer.Position = UDim2.new(0, 86, 0, 0)
    ElementsContainer.Size = UDim2.new(1, -96, 1, 0)
    ElementsContainer.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    -- registry for theme-updatable objects
    local ElementsRegistry = {}

    local function RegisterTheme(obj, prop, themeIndex)
        table.insert(ElementsRegistry, {Object = obj, Property = prop, ThemeIndex = themeIndex})
        if obj and obj[prop] ~= nil and Library.Theme[themeIndex] ~= nil then
            obj[prop] = Library.Theme[themeIndex]
        end
    end

    local function UpdateAllThemes()
        for _, reg in pairs(ElementsRegistry) do
            if reg.Object and reg.Object.Parent then
                local propset = {}
                propset[reg.Property] = Library.Theme[reg.ThemeIndex]
                TweenService:Create(reg.Object, TweenInfo.new(0.28), propset):Play()
            end
        end
    end

    function WindowFunctions:AddTab(TabName, TabIconId)
        local TabFunctions = {}
        local TabButton = Instance.new("ImageButton")
        local TabPage = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")
        local PagePadding = Instance.new("UIPadding")

        TabButton.Name = TabName
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = FirstTab and Library.Theme.Accent or Library.Theme.Main
        TabButton.Size = UDim2.new(0, 52, 0, 52)
        TabButton.Image = FormatAssetId(TabIconId)
        TabButton.ImageColor3 = FirstTab and Library.Theme.Main or Library.Theme.Text
        TabButton.AutoButtonColor = false
        TabButton.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 10)

        -- nicer tooltip
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Parent = TabButton
        Tooltip.Visible = false
        Tooltip.Text = TabName
        Tooltip.BackgroundColor3 = Color3.fromRGB(42,42,42)
        Tooltip.TextColor3 = Color3.new(1,1,1)
        Tooltip.Position = UDim2.new(1, 12, 0.5, -12)
        Tooltip.Size = UDim2.new(0, math.clamp(#TabName * 7 + 12, 60, 220), 0, 24)
        Tooltip.ZIndex = 50
        Tooltip.Font = Enum.Font.Gotham
        Tooltip.TextSize = 13
        Instance.new("UICorner", Tooltip)
        Tooltip.Visible = false

        TabButton.MouseEnter:Connect(function()
            Tooltip.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 56, 0, 56)}):Play()
        end)
        TabButton.MouseLeave:Connect(function()
            Tooltip.Visible = false
            TweenService:Create(TabButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 52, 0, 52)}):Play()
        end)

        -- Page setup
        TabPage.Name = TabName .. "_Page"
        TabPage.Parent = ElementsContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = FirstTab
        TabPage.ScrollBarThickness = 6
        TabPage.ScrollBarImageColor3 = Library.Theme.Accent
        
        PageLayout.Parent = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        
        PagePadding.Parent = TabPage
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 12)
        PagePadding.PaddingRight = UDim.new(0, 12)
        PagePadding.PaddingBottom = UDim.new(0, 12)

        -- Switch tab logic
        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("ImageButton") then
                    TweenService:Create(child, TweenInfo.new(0.18), {BackgroundColor3 = Library.Theme.Main, ImageColor3 = Library.Theme.Text}):Play()
                end
            end
            for _, child in pairs(ElementsContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            
            TabPage.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.18), {BackgroundColor3 = Library.Theme.Accent, ImageColor3 = Library.Theme.Main}):Play()
        end)

        if FirstTab then FirstTab = false end

        -- ELEMENTS --

        -- 1. Label
        function TabFunctions:AddLabel(Text)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabPage
            Label.Size = UDim2.new(1, 0, 0, 26)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.Text = Text
            Label.TextColor3 = Library.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            RegisterTheme(Label, "TextColor3", "Text")
        end

        -- 2. Button
        function TabFunctions:AddButton(Text, Callback)
            Callback = Callback or function() end
            local ButtonFrame = Instance.new("TextButton")
            
            ButtonFrame.Parent = TabPage
            ButtonFrame.BackgroundColor3 = Library.Theme.Secondary
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.Text = Text
            ButtonFrame.Font = Enum.Font.GothamSemibold
            ButtonFrame.TextColor3 = Library.Theme.Text
            ButtonFrame.TextSize = 14
            ButtonFrame.AutoButtonColor = false
            
            Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", ButtonFrame)
            Stroke.Color = Library.Theme.Stroke
            Stroke.Thickness = 1

            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.Secondary:lerp(Library.Theme.Main, 0.06)}):Play()
            end)
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme.Secondary}):Play()
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                CreateRipple(ButtonFrame)
                Callback()
            end)
            
            RegisterTheme(ButtonFrame, "BackgroundColor3", "Secondary")
            RegisterTheme(ButtonFrame, "TextColor3", "Text")
        end

        -- 3. Toggle
        function TabFunctions:AddToggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = Library.Theme.Secondary
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

            local Title = Instance.new("TextLabel")
            Title.Parent = ToggleFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = Text
            Title.TextColor3 = Library.Theme.Text
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchInfo = Instance.new("Frame")
            SwitchInfo.Parent = ToggleFrame
            SwitchInfo.AnchorPoint = Vector2.new(1, 0.5)
            SwitchInfo.Position = UDim2.new(0.96, 0, 0.5, 0)
            SwitchInfo.Size = UDim2.new(0, 44, 0, 24)
            SwitchInfo.BackgroundColor3 = Toggled and Library.Theme.Accent or Color3.fromRGB(64,64,64)
            Instance.new("UICorner", SwitchInfo).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame")
            Circle.Parent = SwitchInfo
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.Position = UDim2.new(Toggled and 0.55 or 0.05, 0, 0.5, 0)
            Circle.Size = UDim2.new(0, 18, 0, 18)
            Circle.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Callback(Toggled)
                TweenService:Create(SwitchInfo, TweenInfo.new(0.18), {
                    BackgroundColor3 = Toggled and Library.Theme.Accent or Color3.fromRGB(64,64,64)
                }):Play()
                TweenService:Create(Circle, TweenInfo.new(0.18), {
                    Position = UDim2.new(Toggled and 0.55 or 0.05, 0, 0.5, 0)
                }):Play()
            end)
        end

        -- 4. Slider
        function TabFunctions:AddSlider(Text, Min, Max, Default, Callback)
            Default = math.clamp(Default or Min, Min, Max)
            local Value = Default

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabPage
            SliderFrame.BackgroundColor3 = Library.Theme.Secondary
            SliderFrame.Size = UDim2.new(1, 0, 0, 56)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Title = Instance.new("TextLabel")
            Title.Parent = SliderFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 6)
            Title.Size = UDim2.new(1, -24, 0, 20)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = Text
            Title.TextColor3 = Library.Theme.Text
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0, 12, 0, 6)
            ValueLabel.Size = UDim2.new(1, -24, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = Library.Theme.Text
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Color3.fromRGB(64,64,64)
            SliderBar.Position = UDim2.new(0, 12, 0, 34)
            SliderBar.Size = UDim2.new(1, -24, 0, 8)
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBar
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.Size = UDim2.new((Value - Min)/(Max - Min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            RegisterTheme(Fill, "BackgroundColor3", "Accent")

            local Dragging = false
            
            local function Update(Input)
                local SizeX = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                Value = NewValue
                ValueLabel.Text = tostring(Value)
                TweenService:Create(Fill, TweenInfo.new(0.12), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
                Callback(Value)
            end

            SliderBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    Update(Input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    Update(Input)
                end
            end)
        end

        -- 5. Dropdown
        function TabFunctions:AddDropdown(Text, Options, Callback)
            local DropdownOpen = false
            local Selected = Options[1] or "None"
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = Library.Theme.Secondary
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)
            
            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Parent = DropdownFrame
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Size = UDim2.new(1,0,0,40)
            ClickBtn.Text = ""
            
            local Title = Instance.new("TextLabel")
            Title.Parent = DropdownFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0.5, 0, 0, 40)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = Text
            Title.TextColor3 = Library.Theme.Text
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Status = Instance.new("TextLabel")
            Status.Parent = DropdownFrame
            Status.BackgroundTransparency = 1
            Status.Position = UDim2.new(0.5, 0, 0, 0)
            Status.Size = UDim2.new(0.45, -12, 0, 40)
            Status.Font = Enum.Font.Gotham
            Status.Text = Selected
            Status.TextColor3 = Library.Theme.Accent
            Status.TextSize = 14
            Status.TextXAlignment = Enum.TextXAlignment.Right
            RegisterTheme(Status, "TextColor3", "Accent")
            
            local Icon = Instance.new("ImageLabel")
            Icon.Parent = DropdownFrame
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.95, -14, 0.5, -8)
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Image = FormatAssetId("6034818372")
            Icon.ImageColor3 = Library.Theme.Text
            
            local List = Instance.new("Frame")
            List.Parent = DropdownFrame
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 40)
            List.Size = UDim2.new(1, 0, 0, 0)
            
            local ListLayout = Instance.new("UIListLayout", List)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local function RefreshList()
                for _, v in pairs(List:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                for _, opt in pairs(Options) do
                    local Item = Instance.new("TextButton")
                    Item.Parent = List
                    Item.BackgroundColor3 = Library.Theme.Secondary
                    Item.BackgroundTransparency = 0.6
                    Item.Size = UDim2.new(1, 0, 0, 34)
                    Item.Font = Enum.Font.Gotham
                    Item.Text = opt
                    Item.TextColor3 = Library.Theme.TextDark
                    Item.TextSize = 13
                    
                    Item.MouseButton1Click:Connect(function()
                        Selected = opt
                        Status.Text = Selected
                        Callback(Selected)
                        DropdownOpen = false
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.28), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                        TweenService:Create(Icon, TweenInfo.new(0.28), {Rotation = 0}):Play()
                    end)
                end
            end
            
            RefreshList()
            
            ClickBtn.MouseButton1Click:Connect(function()
                DropdownOpen = not DropdownOpen
                local Height = DropdownOpen and (40 + (#Options * 34)) or 40
                TweenService:Create(DropdownFrame, TweenInfo.new(0.28), {Size = UDim2.new(1, 0, 0, Height)}):Play()
                TweenService:Create(Icon, TweenInfo.new(0.28), {Rotation = DropdownOpen and 180 or 0}):Play()
            end)
        end

        -- 6. MultiDropdown
        function TabFunctions:AddMultiDropdown(Text, Options, Callback)
            local DropdownOpen = false
            local SelectedItems = {}
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = Library.Theme.Secondary
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)
            
            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Parent = DropdownFrame
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Size = UDim2.new(1,0,0,40)
            ClickBtn.Text = ""

            local Title = Instance.new("TextLabel")
            Title.Parent = DropdownFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0.5, 0, 0, 40)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = Text
            Title.TextColor3 = Library.Theme.Text
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Status = Instance.new("TextLabel")
            Status.Parent = DropdownFrame
            Status.BackgroundTransparency = 1
            Status.Position = UDim2.new(0.5, 0, 0, 0)
            Status.Size = UDim2.new(0.45, -12, 0, 40)
            Status.Font = Enum.Font.Gotham
            Status.Text = "None"
            Status.TextColor3 = Library.Theme.Accent
            Status.TextSize = 14
            Status.TextXAlignment = Enum.TextXAlignment.Right
            RegisterTheme(Status, "TextColor3", "Accent")

            local Icon = Instance.new("ImageLabel")
            Icon.Parent = DropdownFrame
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.95, -14, 0.5, -8)
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Image = FormatAssetId("6034818372")
            Icon.ImageColor3 = Library.Theme.Text

            local List = Instance.new("Frame")
            List.Parent = DropdownFrame
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 40)
            List.Size = UDim2.new(1, 0, 0, 0)
            
            local ListLayout = Instance.new("UIListLayout", List)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local function UpdateText()
                local txt = ""
                local count = 0
                for k, v in pairs(SelectedItems) do
                    if v then
                        count = count + 1
                        if count == 1 then txt = k else txt = txt .. ", " .. k end
                    end
                end
                if txt == "" then txt = "None" end
                Status.Text = txt
                Callback(SelectedItems)
            end

            for _, opt in pairs(Options) do
                SelectedItems[opt] = false

                local Item = Instance.new("TextButton")
                Item.Parent = List
                Item.BackgroundColor3 = Library.Theme.Secondary
                Item.BackgroundTransparency = 0.6
                Item.Size = UDim2.new(1, 0, 0, 34)
                Item.Font = Enum.Font.Gotham
                Item.Text = opt
                Item.TextColor3 = Library.Theme.TextDark
                Item.TextSize = 13
                Item.TextXAlignment = Enum.TextXAlignment.Left
                
                local Check = Instance.new("Frame", Item)
                Check.Position = UDim2.new(0, 10, 0.5, -7)
                Check.Size = UDim2.new(0, 16, 0, 16)
                Check.BackgroundColor3 = Color3.fromRGB(40,40,40)
                Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)
                
                local Inner = Instance.new("Frame", Check)
                Inner.Size = UDim2.new(1, -4, 1, -4)
                Inner.Position = UDim2.new(0,2,0,2)
                Inner.BackgroundColor3 = Library.Theme.Accent
                Inner.BackgroundTransparency = 1
                Instance.new("UICorner", Inner).CornerRadius = UDim.new(0, 3)

                local Pad = Instance.new("UIPadding", Item)
                Pad.PaddingLeft = UDim.new(0, 36)

                Item.MouseButton1Click:Connect(function()
                    SelectedItems[opt] = not SelectedItems[opt]
                    Inner.BackgroundTransparency = SelectedItems[opt] and 0 or 1
                    Item.TextColor3 = SelectedItems[opt] and Library.Theme.Text or Library.Theme.TextDark
                    UpdateText()
                end)
            end
            
            ClickBtn.MouseButton1Click:Connect(function()
                DropdownOpen = not DropdownOpen
                local Height = DropdownOpen and (40 + (#Options * 34)) or 40
                TweenService:Create(DropdownFrame, TweenInfo.new(0.28), {Size = UDim2.new(1, 0, 0, Height)}):Play()
                TweenService:Create(Icon, TweenInfo.new(0.28), {Rotation = DropdownOpen and 180 or 0}):Play()
            end)
        end
        
        -- 7. Textbox
        function TabFunctions:AddTextbox(Text, Placeholder, Callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Parent = TabPage
            BoxFrame.BackgroundColor3 = Library.Theme.Secondary
            BoxFrame.Size = UDim2.new(1, 0, 0, 44)
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 8)
            
            local Title = Instance.new("TextLabel")
            Title.Parent = BoxFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0.4, 0, 1, 0)
            Title.Font = Enum.Font.GothamSemibold
            Title.Text = Text
            Title.TextColor3 = Library.Theme.Text
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Input = Instance.new("TextBox")
            Input.Parent = BoxFrame
            Input.BackgroundColor3 = Color3.fromRGB(42, 42, 44)
            Input.Position = UDim2.new(0.5, 0, 0.15, 0)
            Input.Size = UDim2.new(0.46, 0, 0.7, 0)
            Input.Font = Enum.Font.Gotham
            Input.PlaceholderText = Placeholder or "Type here..."
            Input.Text = ""
            Input.TextColor3 = Library.Theme.Text
            Input.TextSize = 13
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)
            
            Input.FocusLost:Connect(function(Enter)
                Callback(Input.Text)
            end)
        end

        return TabFunctions
    end

    -- CONFIG SYSTEM --
    function WindowFunctions:AddConfig()
        local ConfigTab = WindowFunctions:AddTab("Config", Library.Icons.Config)
        
        ConfigTab:AddLabel("Theme Settings")
        
        local Themes = {
            ["Neon Green"] = {Accent = Color3.fromRGB(0, 230, 170)},
            ["Blood Red"] = {Accent = Color3.fromRGB(235, 70, 70)},
            ["Sky Blue"] = {Accent = Color3.fromRGB(0, 160, 255)},
            ["Void Purple"] = {Accent = Color3.fromRGB(170, 60, 255)},
            ["Sunny Orange"] = {Accent = Color3.fromRGB(255, 170, 50)}
        }
        
        local ThemeNames = {}
        for name, _ in pairs(Themes) do table.insert(ThemeNames, name) end
        
        ConfigTab:AddDropdown("Select Theme", ThemeNames, function(val)
            local NewTheme = Themes[val]
            if NewTheme then
                Library.Theme.Accent = NewTheme.Accent
                UpdateAllThemes()
                for _, obj in pairs(NeonLibGui:GetDescendants()) do
                    if obj:IsA("ImageLabel") and obj.Name == "Icon" then
                        TweenService:Create(obj, TweenInfo.new(0.28), {ImageColor3 = Library.Theme.Accent}):Play()
                    end
                end
            end
        end)
        
        ConfigTab:AddToggle("Transparent UI (60%)", false, function(state)
            local target = state and 0.6 or 0
            TweenService:Create(MainFrame, TweenInfo.new(0.45), {BackgroundTransparency = target}):Play()
        end)
        
        ConfigTab:AddLabel("Key Manager")
        
        local SavedKeyName = ""
        ConfigTab:AddTextbox("Saved Key Name", "Ex: MainAccount", function(txt)
            SavedKeyName = txt
        end)
        
        local function GetConfigs()
            local configs = {}
            if type(isfolder) == "function" then
                if not isfolder("NeonLib") and type(makefolder) == "function" then
                    makefolder("NeonLib")
                end
                if type(listfiles) == "function" then
                    local files = listfiles("NeonLib")
                    for _, f in pairs(files) do
                        local filename = f:match("[^/\\]+$") or f
                        filename = filename:gsub("%.json$", "")
                        table.insert(configs, filename)
                    end
                end
            end
            return configs
        end
        
        ConfigTab:AddDropdown("Load Config", GetConfigs(), function(val)
            print("Loaded: " .. val)
        end)
        
        ConfigTab:AddButton("Save Config", function()
            if SavedKeyName ~= "" and type(writefile) == "function" then
                writefile("NeonLib/" .. SavedKeyName .. ".json", HttpService:JSONEncode({Time = os.time()}))
            end
        end)
    end
    
    -- keepalive loop (visual integrity)
    task.spawn(function()
        while NeonLibGui.Parent do
            task.wait(5)
        end
    end)

    return WindowFunctions
end

return Library
