--[[
    UI Library Super Moderna para Roblox
    Desenvolvedor: Sênior Luau Developer
    Parte 1/3: Sistema Base, Loading e Key System
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility Functions
local Utility = {}

function Utility:Tween(object, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
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
            Utility:Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

function Utility:CreateRound(parent, radius)
    local round = Instance.new("UICorner")
    round.CornerRadius = UDim.new(0, radius or 8)
    round.Parent = parent
    return round
end

function Utility:CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 60)
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- File System Functions
local FileSystem = {}

function FileSystem:CheckFolder(folderName)
    if not isfolder then return false end
    if not isfolder(folderName) then
        makefolder(folderName)
    end
    return true
end

function FileSystem:SaveData(fileName, data)
    if not writefile then return false end
    local success, err = pcall(function()
        writefile(fileName, HttpService:JSONEncode(data))
    end)
    return success
end

function FileSystem:LoadData(fileName)
    if not readfile or not isfile then return nil end
    if isfile(fileName) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(fileName))
        end)
        if success then return data end
    end
    return nil
end

-- Theme System
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Tertiary = Color3.fromRGB(40, 40, 45),
        Accent = Color3.fromRGB(120, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    Ocean = {
        Primary = Color3.fromRGB(15, 25, 35),
        Secondary = Color3.fromRGB(25, 40, 55),
        Tertiary = Color3.fromRGB(35, 55, 75),
        Accent = Color3.fromRGB(70, 150, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 220)
    },
    Neon = {
        Primary = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(20, 20, 30),
        Tertiary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(255, 0, 150),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 100, 200)
    },
    Forest = {
        Primary = Color3.fromRGB(20, 30, 20),
        Secondary = Color3.fromRGB(30, 45, 30),
        Tertiary = Color3.fromRGB(40, 60, 40),
        Accent = Color3.fromRGB(100, 200, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 220, 180)
    },
    Sunset = {
        Primary = Color3.fromRGB(30, 20, 25),
        Secondary = Color3.fromRGB(45, 30, 35),
        Tertiary = Color3.fromRGB(60, 40, 50),
        Accent = Color3.fromRGB(255, 120, 80),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(255, 180, 160)
    },
    Purple = {
        Primary = Color3.fromRGB(25, 15, 35),
        Secondary = Color3.fromRGB(40, 25, 55),
        Tertiary = Color3.fromRGB(55, 35, 75),
        Accent = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(220, 180, 255)
    },
    Red = {
        Primary = Color3.fromRGB(30, 15, 15),
        Secondary = Color3.fromRGB(45, 25, 25),
        Tertiary = Color3.fromRGB(60, 35, 35),
        Accent = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(255, 180, 180)
    },
    Gold = {
        Primary = Color3.fromRGB(25, 20, 10),
        Secondary = Color3.fromRGB(40, 35, 20),
        Tertiary = Color3.fromRGB(55, 50, 30),
        Accent = Color3.fromRGB(255, 215, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(255, 235, 150)
    },
    Ice = {
        Primary = Color3.fromRGB(15, 20, 25),
        Secondary = Color3.fromRGB(25, 35, 45),
        Tertiary = Color3.fromRGB(35, 50, 65),
        Accent = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 235, 255)
    },
    Fire = {
        Primary = Color3.fromRGB(25, 10, 5),
        Secondary = Color3.fromRGB(40, 20, 10),
        Tertiary = Color3.fromRGB(55, 30, 15),
        Accent = Color3.fromRGB(255, 100, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(255, 200, 150)
    },
    Mint = {
        Primary = Color3.fromRGB(15, 25, 20),
        Secondary = Color3.fromRGB(25, 40, 35),
        Tertiary = Color3.fromRGB(35, 55, 50),
        Accent = Color3.fromRGB(100, 255, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 255, 220)
    },
    Cherry = {
        Primary = Color3.fromRGB(30, 10, 15),
        Secondary = Color3.fromRGB(45, 20, 25),
        Tertiary = Color3.fromRGB(60, 30, 40),
        Accent = Color3.fromRGB(255, 50, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(255, 180, 200)
    },
    Space = {
        Primary = Color3.fromRGB(10, 5, 20),
        Secondary = Color3.fromRGB(20, 15, 35),
        Tertiary = Color3.fromRGB(30, 25, 50),
        Accent = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 255)
    },
    Emerald = {
        Primary = Color3.fromRGB(10, 20, 15),
        Secondary = Color3.fromRGB(20, 35, 25),
        Tertiary = Color3.fromRGB(30, 50, 40),
        Accent = Color3.fromRGB(80, 200, 120),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 255, 200)
    },
    Cyber = {
        Primary = Color3.fromRGB(5, 15, 20),
        Secondary = Color3.fromRGB(15, 25, 35),
        Tertiary = Color3.fromRGB(25, 40, 50),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 255, 255)
    }
}

-- Loading Screen
function Library:CreateLoadingScreen(config)
    local LoadingScreen = Instance.new("ScreenGui")
    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.ResetOnSpawn = false
    LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingScreen.Parent = game:GetService("CoreGui")
    
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.3
    Background.BorderSizePixel = 0
    Background.Parent = LoadingScreen
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 400, 0, 250)
    Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Container.BorderSizePixel = 0
    Container.Parent = Background
    Utility:CreateRound(Container, 12)
    Utility:CreateStroke(Container, Color3.fromRGB(120, 120, 255), 2)
    
    if config.LoadingIcon and config.LoadingIcon ~= "" then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 80, 0, 80)
        Icon.Position = UDim2.new(0.5, 0, 0, 30)
        Icon.AnchorPoint = Vector2.new(0.5, 0)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://" .. config.LoadingIcon
        Icon.Parent = Container
        Utility:CreateRound(Icon, 40)
    end
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, config.LoadingIcon and 120 or 30)
    Title.BackgroundTransparency = 1
    Title.Text = config.LoadingName or "Welcome!"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Container
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(1, -60, 0, 6)
    ProgressBar.Position = UDim2.new(0, 30, 1, -50)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = Container
    Utility:CreateRound(ProgressBar, 3)
    
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new(0, 0, 1, 0)
    Progress.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    Progress.BorderSizePixel = 0
    Progress.Parent = ProgressBar
    Utility:CreateRound(Progress, 3)
    
    -- Animate loading
    Utility:Tween(Progress, {Size = UDim2.new(1, 0, 1, 0)}, 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    task.wait(1.5)
    Utility:Tween(Container, {Position = UDim2.new(0.5, 0, 0.5, -100)}, 0.3)
    Utility:Tween(Background, {BackgroundTransparency = 1}, 0.3)
    task.wait(0.3)
    LoadingScreen:Destroy()
end

-- Key System
function Library:CreateKeySystem(config)
    if not config.KeySystem then return true end
    
    local keyFolder = "UILibrary_Keys"
    FileSystem:CheckFolder(keyFolder)
    
    local keyFile = keyFolder .. "/" .. (config.KeyJsonName or "key") .. ".json"
    
    -- Check saved key
    if config.KeySave then
        local savedData = FileSystem:LoadData(keyFile)
        if savedData and savedData.key == config.Key then
            return true
        end
    end
    
    -- Create Key UI
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystem"
    KeyGui.ResetOnSpawn = false
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    KeyGui.Parent = game:GetService("CoreGui")
    
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.5
    Background.BorderSizePixel = 0
    Background.Parent = KeyGui
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 450, 0, 300)
    Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Container.BorderSizePixel = 0
    Container.Parent = Background
    Utility:CreateRound(Container, 12)
    Utility:CreateStroke(Container, Color3.fromRGB(120, 120, 255), 2)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = config.KeyName or "Key System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Container
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Name = "KeyBox"
    KeyBox.Size = UDim2.new(1, -60, 0, 45)
    KeyBox.Position = UDim2.new(0, 30, 0, 80)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyBox.BorderSizePixel = 0
    KeyBox.PlaceholderText = "Enter Key..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 16
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = Container
    Utility:CreateRound(KeyBox, 8)
    
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Size = UDim2.new(1, -60, 0, 45)
    GetKeyBtn.Position = UDim2.new(0, 30, 0, 145)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.TextSize = 16
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = Container
    Utility:CreateRound(GetKeyBtn, 8)
    
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Name = "SubmitBtn"
    SubmitBtn.Size = UDim2.new(1, -60, 0, 45)
    SubmitBtn.Position = UDim2.new(0, 30, 0, 210)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 16
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = Container
    Utility:CreateRound(SubmitBtn, 8)
    
    local validKey = false
    
    GetKeyBtn.MouseButton1Click:Connect(function()
        Utility:Tween(GetKeyBtn, {BackgroundColor3 = Color3.fromRGB(100, 100, 200)}, 0.1)
        task.wait(0.1)
        Utility:Tween(GetKeyBtn, {BackgroundColor3 = Color3.fromRGB(80, 80, 180)}, 0.1)
        
        if config.GetKeyFromSite and setclipboard then
            setclipboard(config.GetKeyFromSite)
            Title.Text = "Link Copied!"
            task.wait(1)
            Title.Text = config.KeyName or "Key System"
        end
    end)
    
    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text == config.Key then
            validKey = true
            if config.KeySave then
                FileSystem:SaveData(keyFile, {key = config.Key})
            end
            Utility:Tween(Container, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            Utility:Tween(Background, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            KeyGui:Destroy()
        else
            Title.Text = "Invalid Key!"
            Title.TextColor3 = Color3.fromRGB(255, 80, 80)
            Utility:Tween(Container, {Position = UDim2.new(0.5, -10, 0.5, 0)}, 0.05)
            Utility:Tween(Container, {Position = UDim2.new(0.5, 10, 0.5, 0)}, 0.05)
            Utility:Tween(Container, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.05)
            task.wait(1)
            Title.Text = config.KeyName or "Key System"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    
    repeat task.wait() until validKey or not KeyGui.Parent
    return validKey
end

Library.Utility = Utility
Library.FileSystem = FileSystem
Library.Themes = Themes

--[[
    UI Library Super Moderna para Roblox
    Desenvolvedor: Sênior Luau Developer
    Parte 2/3: Window, TopBar, Tabs e Elementos Básicos
]]

-- Continuação da Parte 1
-- Assume que Library, Utility, FileSystem e Themes já existem

-- Window Constructor
function Library:CreateWindow(config)
    config = config or {}
    
    -- Show loading screen
    if config.LoadingName or config.LoadingIcon then
        self:CreateLoadingScreen(config)
    end
    
    -- Validate key system
    local keyValid = self:CreateKeySystem(config)
    if not keyValid then return end
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Window Object
    local Window = {
        ScreenGui = ScreenGui,
        Config = config,
        CurrentTheme = Themes[config.Theme] or Themes.Dark,
        Tabs = {},
        Elements = {},
        Flags = {},
        ConfigTab = nil,
        SaveFile = "UILibrary_Configs/" .. (config.SaveFileName or "config") .. ".json"
    }
    
    -- Setup save folder
    FileSystem:CheckFolder("UILibrary_Configs")
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.BackgroundColor3 = Window.CurrentTheme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Utility:CreateRound(MainFrame, 12)
    Utility:CreateStroke(MainFrame, Window.CurrentTheme.Accent, 2)
    Window.MainFrame = MainFrame
    
    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Window.CurrentTheme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarRound = Instance.new("UICorner")
    TopBarRound.CornerRadius = UDim.new(0, 12)
    TopBarRound.Parent = TopBar
    
    local TopBarExtend = Instance.new("Frame")
    TopBarExtend.Size = UDim2.new(1, 0, 0, 20)
    TopBarExtend.Position = UDim2.new(0, 0, 1, -20)
    TopBarExtend.BackgroundColor3 = Window.CurrentTheme.Secondary
    TopBarExtend.BorderSizePixel = 0
    TopBarExtend.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name or "UI Library"
    Title.TextColor3 = Window.CurrentTheme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- TopBar Buttons Container
    local ButtonsContainer = Instance.new("Frame")
    ButtonsContainer.Name = "ButtonsContainer"
    ButtonsContainer.Size = UDim2.new(0, 100, 1, 0)
    ButtonsContainer.Position = UDim2.new(1, -110, 0, 0)
    ButtonsContainer.BackgroundTransparency = 1
    ButtonsContainer.Parent = TopBar
    
    local ButtonsList = Instance.new("UIListLayout")
    ButtonsList.FillDirection = Enum.FillDirection.Horizontal
    ButtonsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonsList.VerticalAlignment = Enum.VerticalAlignment.Center
    ButtonsList.Padding = UDim.new(0, 5)
    ButtonsList.Parent = ButtonsContainer
    
    -- Resize Button
    local ResizeBtn = Instance.new("TextButton")
    ResizeBtn.Name = "ResizeBtn"
    ResizeBtn.Size = UDim2.new(0, 28, 0, 28)
    ResizeBtn.BackgroundColor3 = Window.CurrentTheme.Tertiary
    ResizeBtn.BorderSizePixel = 0
    ResizeBtn.Text = "⊡"
    ResizeBtn.TextColor3 = Window.CurrentTheme.Text
    ResizeBtn.TextSize = 16
    ResizeBtn.Font = Enum.Font.GothamBold
    ResizeBtn.Parent = ButtonsContainer
    Utility:CreateRound(ResizeBtn, 6)
    
    local isResized = false
    local originalSize = MainFrame.Size
    ResizeBtn.MouseButton1Click:Connect(function()
        isResized = not isResized
        if isResized then
            Utility:Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 350)}, 0.3)
        else
            Utility:Tween(MainFrame, {Size = originalSize}, 0.3)
        end
    end)
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    MinimizeBtn.BackgroundColor3 = Window.CurrentTheme.Tertiary
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Window.CurrentTheme.Text
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = ButtonsContainer
    Utility:CreateRound(MinimizeBtn, 6)
    
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Utility:Tween(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 40)}, 0.3)
        else
            Utility:Tween(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 450)}, 0.3)
        end
    end)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = ButtonsContainer
    Utility:CreateRound(CloseBtn, 6)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Window:CreateConfirmModal()
    end)
    
    -- Make draggable
    Utility:MakeDraggable(MainFrame, TopBar)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -60)
    ContentContainer.Position = UDim2.new(0, 10, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Tab Buttons Container
    local TabButtonsContainer = Instance.new("Frame")
    TabButtonsContainer.Name = "TabButtonsContainer"
    TabButtonsContainer.Size = UDim2.new(0, 150, 1, 0)
    TabButtonsContainer.BackgroundColor3 = Window.CurrentTheme.Secondary
    TabButtonsContainer.BorderSizePixel = 0
    TabButtonsContainer.Parent = ContentContainer
    Utility:CreateRound(TabButtonsContainer, 8)
    
    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.Padding = UDim.new(0, 5)
    TabButtonsList.Parent = TabButtonsContainer
    
    local TabButtonsPadding = Instance.new("UIPadding")
    TabButtonsPadding.PaddingTop = UDim.new(0, 10)
    TabButtonsPadding.PaddingBottom = UDim.new(0, 10)
    TabButtonsPadding.PaddingLeft = UDim.new(0, 10)
    TabButtonsPadding.PaddingRight = UDim.new(0, 10)
    TabButtonsPadding.Parent = TabButtonsContainer
    
    -- Tab Content Container
    local TabContentContainer = Instance.new("Frame")
    TabContentContainer.Name = "TabContentContainer"
    TabContentContainer.Size = UDim2.new(1, -160, 1, 0)
    TabContentContainer.Position = UDim2.new(0, 160, 0, 0)
    TabContentContainer.BackgroundTransparency = 1
    TabContentContainer.Parent = ContentContainer
    
    Window.TabButtonsContainer = TabButtonsContainer
    Window.TabContentContainer = TabContentContainer
    
    -- Confirm Modal Function
    function Window:CreateConfirmModal()
        local Modal = Instance.new("Frame")
        Modal.Name = "ConfirmModal"
        Modal.Size = UDim2.new(1, 0, 1, 0)
        Modal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Modal.BackgroundTransparency = 0.5
        Modal.BorderSizePixel = 0
        Modal.ZIndex = 10
        Modal.Parent = ScreenGui
        
        local ModalContainer = Instance.new("Frame")
        ModalContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        ModalContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        ModalContainer.Size = UDim2.new(0, 300, 0, 150)
        ModalContainer.BackgroundColor3 = self.CurrentTheme.Primary
        ModalContainer.BorderSizePixel = 0
        ModalContainer.ZIndex = 11
        ModalContainer.Parent = Modal
        Utility:CreateRound(ModalContainer, 10)
        Utility:CreateStroke(ModalContainer, self.CurrentTheme.Accent, 2)
        
        local ModalTitle = Instance.new("TextLabel")
        ModalTitle.Size = UDim2.new(1, -20, 0, 40)
        ModalTitle.Position = UDim2.new(0, 10, 0, 10)
        ModalTitle.BackgroundTransparency = 1
        ModalTitle.Text = "Close UI?"
        ModalTitle.TextColor3 = self.CurrentTheme.Text
        ModalTitle.TextSize = 18
        ModalTitle.Font = Enum.Font.GothamBold
        ModalTitle.ZIndex = 12
        ModalTitle.Parent = ModalContainer
        
        local ModalText = Instance.new("TextLabel")
        ModalText.Size = UDim2.new(1, -20, 0, 30)
        ModalText.Position = UDim2.new(0, 10, 0, 50)
        ModalText.BackgroundTransparency = 1
        ModalText.Text = "Are you sure?"
        ModalText.TextColor3 = self.CurrentTheme.TextDark
        ModalText.TextSize = 14
        ModalText.Font = Enum.Font.Gotham
        ModalText.ZIndex = 12
        ModalText.Parent = ModalContainer
        
        local CancelBtn = Instance.new("TextButton")
        CancelBtn.Size = UDim2.new(0.45, 0, 0, 35)
        CancelBtn.Position = UDim2.new(0.05, 0, 1, -45)
        CancelBtn.BackgroundColor3 = self.CurrentTheme.Tertiary
        CancelBtn.BorderSizePixel = 0
        CancelBtn.Text = "Cancel"
        CancelBtn.TextColor3 = self.CurrentTheme.Text
        CancelBtn.TextSize = 14
        CancelBtn.Font = Enum.Font.GothamBold
        CancelBtn.ZIndex = 12
        CancelBtn.Parent = ModalContainer
        Utility:CreateRound(CancelBtn, 6)
        
        local YesBtn = Instance.new("TextButton")
        YesBtn.Size = UDim2.new(0.45, 0, 0, 35)
        YesBtn.Position = UDim2.new(0.5, 0, 1, -45)
        YesBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        YesBtn.BorderSizePixel = 0
        YesBtn.Text = "Yes"
        YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        YesBtn.TextSize = 14
        YesBtn.Font = Enum.Font.GothamBold
        YesBtn.ZIndex = 12
        YesBtn.Parent = ModalContainer
        Utility:CreateRound(YesBtn, 6)
        
        CancelBtn.MouseButton1Click:Connect(function()
            Utility:Tween(ModalContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            Utility:Tween(Modal, {BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            Modal:Destroy()
        end)
        
        YesBtn.MouseButton1Click:Connect(function()
            Utility:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            task.wait(0.3)
            ScreenGui:Destroy()
        end)
    end
    
    -- Add Tab Function
    function Window:AddTab(name)
        local Tab = {
            Name = name,
            Sections = {},
            Elements = {},
            Visible = false
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = self.CurrentTheme.Tertiary
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = self.CurrentTheme.TextDark
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = self.TabButtonsContainer
        Utility:CreateRound(TabButton, 6)
        
        local TabButtonPadding = Instance.new("UIPadding")
        TabButtonPadding.PaddingLeft = UDim.new(0, 10)
        TabButtonPadding.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = self.CurrentTheme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = self.TabContentContainer
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.Padding = UDim.new(0, 10)
        TabContentList.Parent = TabContent
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 10)
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.ContentList = TabContentList
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Visible = false
                tab.Content.Visible = false
                tab.Button.BackgroundTransparency = 1
                tab.Button.TextColor3 = self.CurrentTheme.TextDark
            end
            
            Tab.Visible = true
            TabContent.Visible = true
            Utility:Tween(TabButton, {BackgroundTransparency = 0, BackgroundColor3 = self.CurrentTheme.Accent}, 0.2)
            TabButton.TextColor3 = self.CurrentTheme.Text
        end)
        
        table.insert(self.Tabs, Tab)
        
        if #self.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Add Section Function
        function Tab:AddSection(name)
            local Section = {
                Name = name,
                Elements = {}
            }
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            Utility:CreateRound(SectionFrame, 8)
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -20, 0, 30)
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Window.CurrentTheme.Text
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Name = "ElementsContainer"
            ElementsContainer.Size = UDim2.new(1, -20, 1, -40)
            ElementsContainer.Position = UDim2.new(0, 10, 0, 40)
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Parent = SectionFrame
            
            local ElementsList = Instance.new("UIListLayout")
            ElementsList.Padding = UDim.new(0, 8)
            ElementsList.Parent = ElementsContainer
            
            ElementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ElementsList.AbsoluteContentSize.Y + 50)
            end)
            
            Section.Frame = SectionFrame
            Section.Container = ElementsContainer
            
            table.insert(Tab.Sections, Section)
            
            -- Add Label
            function Section:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(1, 0, 0, 25)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Window.CurrentTheme.Text
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = ElementsContainer
                
                local LabelObj = {Element = Label}
                
                function LabelObj:UpdateText(newText)
                    Label.Text = newText
                end
                
                table.insert(Section.Elements, LabelObj)
                return LabelObj
            end
            
            -- Add Button
            function Section:AddButton(config)
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = "Button"
                ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
                ButtonFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Parent = ElementsContainer
                Utility:CreateRound(ButtonFrame, 6)
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.BackgroundTransparency = 1
                Button.Text = config.Name or "Button"
                Button.TextColor3 = Window.CurrentTheme.Text
                Button.TextSize = 13
                Button.Font = Enum.Font.GothamBold
                Button.Parent = ButtonFrame
                
                Button.MouseEnter:Connect(function()
                    Utility:Tween(ButtonFrame, {BackgroundColor3 = Window.CurrentTheme.Accent}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    Utility:Tween(ButtonFrame, {BackgroundColor3 = Window.CurrentTheme.Tertiary}, 0.2)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Utility:Tween(ButtonFrame, {Size = UDim2.new(1, -5, 0, 30)}, 0.1)
                    Utility:Tween(ButtonFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
                    if config.Callback then
                        config.Callback()
                    end
                end)
                
                local ButtonObj = {Element = ButtonFrame}
                table.insert(Section.Elements, ButtonObj)
                return ButtonObj
            end
            
            -- Add Toggle
            function Section:AddToggle(config)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = ElementsContainer
                Utility:CreateRound(ToggleFrame, 6)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Name or "Toggle"
                ToggleLabel.TextColor3 = Window.CurrentTheme.Text
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                Utility:CreateRound(ToggleButton, 10)
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Parent = ToggleButton
                Utility:CreateRound(ToggleIndicator, 8)
                
                local toggled = config.Default or false
                local flag = config.Flag
                
                if flag then
                    Window.Flags[flag] = toggled
                end
                
                local function UpdateToggle(value)
                    toggled = value
                    if flag then
                        Window.Flags[flag] = toggled
                    end
                    
                    if toggled then
                        Utility:Tween(ToggleButton, {BackgroundColor3 = Window.CurrentTheme.Accent}, 0.2)
                        Utility:Tween(ToggleIndicator, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                    else
                        Utility:Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
                        Utility:Tween(ToggleIndicator, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    end
                    
                    if config.Callback then
                        config.Callback(toggled)
                    end
                    
                    Window:SaveConfig()
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    UpdateToggle(not toggled)
                end)
                
                UpdateToggle(toggled)
                
                local ToggleObj = {
                    Element = ToggleFrame,
                    SetValue = UpdateToggle,
                    Flag = flag
                }
                
                table.insert(Section.Elements, ToggleObj)
                table.insert(Window.Elements, ToggleObj)
                return ToggleObj
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Save/Load Config Functions
    function Window:SaveConfig()
        local data = {}
        for _, element in pairs(self.Elements) do
            if element.Flag then
                data[element.Flag] = self.Flags[element.Flag]
            end
        end
        FileSystem:SaveData(self.SaveFile, data)
    end
    
    function Window:LoadConfig()
        local data = FileSystem:LoadData(self.SaveFile)
        if data then
            for flag, value in pairs(data) do
                if self.Flags[flag] ~= nil then
                    self.Flags[flag] = value
                    for _, element in pairs(self.Elements) do
                        if element.Flag == flag and element.SetValue then
                            element.SetValue(value)
                        end
                    end
                end
            end
        end
    end
    
    return Window
end

--[[
    UI Library Super Moderna para Roblox
    Desenvolvedor: Sênior Luau Developer
    Parte 3/3: Elementos Avançados e Sistema de Configuração
]]

-- Continuação da Parte 2
-- Assume que Section já tem AddLabel, AddButton e AddToggle

-- Add Slider
function Section:AddSlider(config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ElementsContainer
    Utility:CreateRound(SliderFrame, 6)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name or "Slider"
    SliderLabel.TextColor3 = Window.CurrentTheme.Text
    SliderLabel.TextSize = 13
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(config.Default or config.Min or 0)
    ValueLabel.TextColor3 = Window.CurrentTheme.Accent
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 1, -15)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    Utility:CreateRound(SliderBar, 3)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = Window.CurrentTheme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    Utility:CreateRound(SliderFill, 3)
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 14, 0, 14)
    SliderButton.Position = UDim2.new(0, -7, 0.5, -7)
    SliderButton.BackgroundColor3 = Window.CurrentTheme.Accent
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderFill
    Utility:CreateRound(SliderButton, 7)
    
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local currentValue = default
    local flag = config.Flag
    local dragging = false
    
    if flag then
        Window.Flags[flag] = currentValue
    end
    
    local function UpdateSlider(value)
        value = math.clamp(value, min, max)
        if config.Increment then
            value = math.floor(value / config.Increment) * config.Increment
        end
        currentValue = value
        
        if flag then
            Window.Flags[flag] = currentValue
        end
        
        local percent = (currentValue - min) / (max - min)
        Utility:Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        ValueLabel.Text = tostring(currentValue)
        
        if config.Callback then
            config.Callback(currentValue)
        end
        
        Window:SaveConfig()
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mousePos = input.Position.X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = min + (max - min) * percent
            UpdateSlider(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = min + (max - min) * percent
            UpdateSlider(value)
        end
    end)
    
    UpdateSlider(currentValue)
    
    local SliderObj = {
        Element = SliderFrame,
        SetValue = UpdateSlider,
        Flag = flag
    }
    
    table.insert(Section.Elements, SliderObj)
    table.insert(Window.Elements, SliderObj)
    return SliderObj
end

-- Add Dropdown
function Section:AddDropdown(config)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = false
    DropdownFrame.ZIndex = 2
    DropdownFrame.Parent = ElementsContainer
    Utility:CreateRound(DropdownFrame, 6)
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 35)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.ZIndex = 3
    DropdownButton.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = config.Name or "Dropdown"
    DropdownLabel.TextColor3 = Window.CurrentTheme.Text
    DropdownLabel.TextSize = 13
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.ZIndex = 3
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownIcon = Instance.new("TextLabel")
    DropdownIcon.Size = UDim2.new(0, 20, 1, 0)
    DropdownIcon.Position = UDim2.new(1, -25, 0, 0)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Text = "▼"
    DropdownIcon.TextColor3 = Window.CurrentTheme.Text
    DropdownIcon.TextSize = 10
    DropdownIcon.Font = Enum.Font.Gotham
    DropdownIcon.ZIndex = 3
    DropdownIcon.Parent = DropdownFrame
    
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Name = "Options"
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 0, 1, 5)
    OptionsContainer.BackgroundColor3 = Window.CurrentTheme.Secondary
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.Visible = false
    OptionsContainer.ZIndex = 5
    OptionsContainer.Parent = DropdownFrame
    Utility:CreateRound(OptionsContainer, 6)
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.Padding = UDim.new(0, 2)
    OptionsList.Parent = OptionsContainer
    
    local OptionsPadding = Instance.new("UIPadding")
    OptionsPadding.PaddingTop = UDim.new(0, 5)
    OptionsPadding.PaddingBottom = UDim.new(0, 5)
    OptionsPadding.Parent = OptionsContainer
    
    local isOpen = false
    local selectedValue = config.Default or (config.Options and config.Options[1]) or ""
    local flag = config.Flag
    
    if flag then
        Window.Flags[flag] = selectedValue
    end
    
    local function UpdateDropdown(value)
        selectedValue = value
        DropdownLabel.Text = (config.Name or "Dropdown") .. ": " .. tostring(value)
        
        if flag then
            Window.Flags[flag] = selectedValue
        end
        
        if config.Callback then
            config.Callback(selectedValue)
        end
        
        Window:SaveConfig()
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            OptionsContainer.Visible = true
            local optionsHeight = math.min(#config.Options * 32 + 10, 150)
            Utility:Tween(OptionsContainer, {Size = UDim2.new(1, 0, 0, optionsHeight)}, 0.2)
            Utility:Tween(DropdownIcon, {Rotation = 180}, 0.2)
        else
            Utility:Tween(OptionsContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            Utility:Tween(DropdownIcon, {Rotation = 0}, 0.2)
            task.wait(0.2)
            OptionsContainer.Visible = false
        end
    end)
    
    for _, option in ipairs(config.Options or {}) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundColor3 = Window.CurrentTheme.Tertiary
        OptionButton.BackgroundTransparency = 0.5
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = tostring(option)
        OptionButton.TextColor3 = Window.CurrentTheme.Text
        OptionButton.TextSize = 12
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.ZIndex = 6
        OptionButton.Parent = OptionsContainer
        Utility:CreateRound(OptionButton, 4)
        
        OptionButton.MouseEnter:Connect(function()
            Utility:Tween(OptionButton, {BackgroundTransparency = 0}, 0.1)
        end)
        
        OptionButton.MouseLeave:Connect(function()
            Utility:Tween(OptionButton, {BackgroundTransparency = 0.5}, 0.1)
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            UpdateDropdown(option)
            DropdownButton.MouseButton1Click:Fire()
        end)
    end
    
    UpdateDropdown(selectedValue)
    
    local DropdownObj = {
        Element = DropdownFrame,
        SetValue = UpdateDropdown,
        Flag = flag
    }
    
    table.insert(Section.Elements, DropdownObj)
    table.insert(Window.Elements, DropdownObj)
    return DropdownObj
end

-- Add Textbox
function Section:AddTextbox(config)
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = "Textbox"
    TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
    TextboxFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
    TextboxFrame.BorderSizePixel = 0
    TextboxFrame.Parent = ElementsContainer
    Utility:CreateRound(TextboxFrame, 6)
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Size = UDim2.new(1, -20, 0, 25)
    TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = config.Name or "Textbox"
    TextboxLabel.TextColor3 = Window.CurrentTheme.Text
    TextboxLabel.TextSize = 13
    TextboxLabel.Font = Enum.Font.Gotham
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.Parent = TextboxFrame
    
    local Textbox = Instance.new("TextBox")
    Textbox.Size = UDim2.new(1, -20, 0, 25)
    Textbox.Position = UDim2.new(0, 10, 1, -30)
    Textbox.BackgroundColor3 = Window.CurrentTheme.Secondary
    Textbox.BorderSizePixel = 0
    Textbox.PlaceholderText = config.Placeholder or "Enter text..."
    Textbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    Textbox.Text = config.Default or ""
    Textbox.TextColor3 = Window.CurrentTheme.Text
    Textbox.TextSize = 12
    Textbox.Font = Enum.Font.Gotham
    Textbox.ClearTextOnFocus = false
    Textbox.Parent = TextboxFrame
    Utility:CreateRound(Textbox, 4)
    
    local flag = config.Flag
    
    if flag then
        Window.Flags[flag] = Textbox.Text
    end
    
    local function UpdateTextbox(value)
        Textbox.Text = value
        if flag then
            Window.Flags[flag] = value
        end
        Window:SaveConfig()
    end
    
    Textbox.FocusLost:Connect(function()
        if flag then
            Window.Flags[flag] = Textbox.Text
        end
        if config.Callback then
            config.Callback(Textbox.Text)
        end
        Window:SaveConfig()
    end)
    
    local TextboxObj = {
        Element = TextboxFrame,
        SetValue = UpdateTextbox,
        Flag = flag
    }
    
    table.insert(Section.Elements, TextboxObj)
    table.insert(Window.Elements, TextboxObj)
    return TextboxObj
end

-- Add Keybind
function Section:AddKeybind(config)
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = "Keybind"
    KeybindFrame.Size = UDim2.new(1, 0, 0, 35)
    KeybindFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
    KeybindFrame.BorderSizePixel = 0
    KeybindFrame.Parent = ElementsContainer
    Utility:CreateRound(KeybindFrame, 6)
    
    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
    KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = config.Name or "Keybind"
    KeybindLabel.TextColor3 = Window.CurrentTheme.Text
    KeybindLabel.TextSize = 13
    KeybindLabel.Font = Enum.Font.Gotham
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.Parent = KeybindFrame
    
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(0, 70, 0, 25)
    KeybindButton.Position = UDim2.new(1, -75, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Window.CurrentTheme.Secondary
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = config.Default or "None"
    KeybindButton.TextColor3 = Window.CurrentTheme.Accent
    KeybindButton.TextSize = 11
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.Parent = KeybindFrame
    Utility:CreateRound(KeybindButton, 4)
    
    local currentKey = config.Default or "None"
    local flag = config.Flag
    local isBinding = false
    
    if flag then
        Window.Flags[flag] = currentKey
    end
    
    local function UpdateKeybind(key)
        currentKey = key
        KeybindButton.Text = key
        if flag then
            Window.Flags[flag] = currentKey
        end
        Window:SaveConfig()
    end
    
    KeybindButton.MouseButton1Click:Connect(function()
        isBinding = true
        KeybindButton.Text = "..."
        Utility:Tween(KeybindButton, {BackgroundColor3 = Window.CurrentTheme.Accent}, 0.2)
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if isBinding then
            local key = input.KeyCode.Name
            if key ~= "Unknown" then
                UpdateKeybind(key)
                isBinding = false
                Utility:Tween(KeybindButton, {BackgroundColor3 = Window.CurrentTheme.Secondary}, 0.2)
            end
        elseif input.KeyCode.Name == currentKey and config.Callback then
            config.Callback()
        end
    end)
    
    local KeybindObj = {
        Element = KeybindFrame,
        SetValue = UpdateKeybind,
        Flag = flag
    }
    
    table.insert(Section.Elements, KeybindObj)
    table.insert(Window.Elements, KeybindObj)
    return KeybindObj
end

-- Add ColorPicker
function Section:AddColorPicker(config)
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = "ColorPicker"
    ColorFrame.Size = UDim2.new(1, 0, 0, 35)
    ColorFrame.BackgroundColor3 = Window.CurrentTheme.Tertiary
    ColorFrame.BorderSizePixel = 0
    ColorFrame.Parent = ElementsContainer
    Utility:CreateRound(ColorFrame, 6)
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Size = UDim2.new(1, -60, 1, 0)
    ColorLabel.Position = UDim2.new(0, 10, 0, 0)
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Text = config.Name or "Color"
    ColorLabel.TextColor3 = Window.CurrentTheme.Text
    ColorLabel.TextSize = 13
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorLabel.Parent = ColorFrame
    
    local defaultColor = config.Default or Color3.fromRGB(255, 255, 255)
    
    local ColorDisplay = Instance.new("TextButton")
    ColorDisplay.Size = UDim2.new(0, 40, 0, 25)
    ColorDisplay.Position = UDim2.new(1, -45, 0.5, -12.5)
    ColorDisplay.BackgroundColor3 = defaultColor
    ColorDisplay.BorderSizePixel = 0
    ColorDisplay.Text = ""
    ColorDisplay.Parent = ColorFrame
    Utility:CreateRound(ColorDisplay, 4)
    Utility:CreateStroke(ColorDisplay, Window.CurrentTheme.Text, 1)
    
    local currentColor = defaultColor
    local flag = config.Flag
    
    if flag then
        Window.Flags[flag] = currentColor
    end
    
    local function UpdateColor(color)
        currentColor = color
        ColorDisplay.BackgroundColor3 = color
        if flag then
            Window.Flags[flag] = currentColor
        end
        if config.Callback then
            config.Callback(currentColor)
        end
        Window:SaveConfig()
    end
    
    ColorDisplay.MouseButton1Click:Connect(function()
        local r = math.random(0, 255)
        local g = math.random(0, 255)
        local b = math.random(0, 255)
        UpdateColor(Color3.fromRGB(r, g, b))
    end)
    
    local ColorObj = {
        Element = ColorFrame,
        SetValue = UpdateColor,
        Flag = flag
    }
    
    table.insert(Section.Elements, ColorObj)
    table.insert(Window.Elements, ColorObj)
    return ColorObj
end

-- Add Config Tab Function
function Window:AddConfig()
    if self.ConfigTab then return end
    
    local ConfigTab = self:AddTab("⚙️ Config")
    self.ConfigTab = ConfigTab
    
    local ThemeSection = ConfigTab:AddSection("Theme Settings")
    
    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end
    table.sort(themeNames)
    
    ThemeSection:AddDropdown({
        Name = "Select Theme",
        Options = themeNames,
        Default = "Dark",
        Callback = function(theme)
            self:ApplyTheme(theme)
        end
    })
    
    local SaveSection = ConfigTab:AddSection("Config Management")
    
    SaveSection:AddButton({
        Name = "Save Config",
        Callback = function()
            self:SaveConfig()
            SaveSection:AddLabel("✓ Config Saved!")
        end
    })
    
    SaveSection:AddButton({
        Name = "Load Config",
        Callback = function()
            self:LoadConfig()
            SaveSection:AddLabel("✓ Config Loaded!")
        end
    })
end

-- Apply Theme Function
function Window:ApplyTheme(themeName)
    local theme = Themes[themeName]
    if not theme then return end
    
    self.CurrentTheme = theme
    
    -- Update Main Frame
    Utility:Tween(self.MainFrame, {BackgroundColor3 = theme.Primary}, 0.3)
    for _, obj in pairs(self.MainFrame:GetDescendants()) do
        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if obj.Name == "TopBar" or obj.Name == "TopBarExtend" then
                Utility:Tween(obj, {BackgroundColor3 = theme.Secondary}, 0.3)
            elseif obj.Name == "TabButtonsContainer" or obj.Parent.Name == "TabButtonsContainer" then
                Utility:Tween(obj, {BackgroundColor3 = theme.Secondary}, 0.3)
            elseif obj.Name:find("Section") or obj.Name == "Button" or obj.Name == "Toggle" or 
                   obj.Name == "Slider" or obj.Name == "Dropdown" or obj.Name == "Textbox" or 
                   obj.Name == "Keybind" or obj.Name == "ColorPicker" then
                if obj.Name:find("Section") and obj:IsA("Frame") then
                    Utility:Tween(obj, {BackgroundColor3 = theme.Secondary}, 0.3)
                else
                    Utility:Tween(obj, {BackgroundColor3 = theme.Tertiary}, 0.3)
                end
            end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            if obj.Name ~= "CloseBtn" and obj.Text ~= "×" and obj.Text ~= "Yes" and obj.Text ~= "Cancel" then
                if obj.Name:find("Value") or obj.Name:find("KeybindButton") then
                    Utility:Tween(obj, {TextColor3 = theme.Accent}, 0.3)
                else
                    Utility:Tween(obj, {TextColor3 = theme.Text}, 0.3)
                end
            end
        elseif obj:IsA("UIStroke") then
            Utility:Tween(obj, {Color = theme.Accent}, 0.3)
        end
    end
    
    -- Update specific accent colors
    for _, element in pairs(self.Elements) do
        if element.Element then
            for _, child in pairs(element.Element:GetDescendants()) do
                if child.Name == "SliderFill" or child.Name == "Progress" then
                    Utility:Tween(child, {BackgroundColor3 = theme.Accent}, 0.3)
                end
            end
        end
    end
end

-- Final initialization
task.wait()
Window:LoadConfig()

return Library
