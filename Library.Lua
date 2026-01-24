--[[ 
    Modern UI Library - Senior Developer Edition
    Features: OOP, Tweening, Key System, Auto-Config, 15 Themes, Resize/Min/Close
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

--// File System Check (Studio Support)
local writefile = writefile or function(file, data) print("[Simulated] Writing file: " .. file) end
local readfile = readfile or function(file) print("[Simulated] Reading file: " .. file) return "" end
local isfile = isfile or function(file) return false end
local isfolder = isfolder or function(folder) return false end
local makefolder = makefolder or function(folder) print("[Simulated] Making folder: " .. folder) end
local delfile = delfile or function(file) print("[Simulated] Deleting file: " .. file) end

--// Library Object
local Library = {}
Library.__index = Library
Library.Flags = {}
Library.Theme = {}
Library.CurrentWindow = nil

--// Constants & Utility
local MOUSE = game.Players.LocalPlayer:GetMouse()

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

local function MakeResizable(dragHandle, frame, minSize)
    local dragging, dragStart, startSize
    minSize = minSize or Vector2.new(400, 300)

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startSize = frame.AbsoluteSize
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = math.max(minSize.X, startSize.X + delta.X)
            local newY = math.max(minSize.Y, startSize.Y + delta.Y)
            frame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

--// Themes System
local Themes = {
    Default = { Main = Color3.fromRGB(25, 25, 25), Secondary = Color3.fromRGB(35, 35, 35), Accent = Color3.fromRGB(0, 122, 255), Text = Color3.fromRGB(255, 255, 255) },
    Dark = { Main = Color3.fromRGB(20, 20, 20), Secondary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(100, 100, 100), Text = Color3.fromRGB(240, 240, 240) },
    Light = { Main = Color3.fromRGB(240, 240, 240), Secondary = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(0, 122, 255), Text = Color3.fromRGB(20, 20, 20) },
    Blood = { Main = Color3.fromRGB(20, 10, 10), Secondary = Color3.fromRGB(30, 15, 15), Accent = Color3.fromRGB(200, 40, 40), Text = Color3.fromRGB(255, 200, 200) },
    Ocean = { Main = Color3.fromRGB(10, 20, 30), Secondary = Color3.fromRGB(15, 30, 45), Accent = Color3.fromRGB(0, 150, 255), Text = Color3.fromRGB(200, 240, 255) },
    Forest = { Main = Color3.fromRGB(20, 30, 20), Secondary = Color3.fromRGB(30, 45, 30), Accent = Color3.fromRGB(40, 180, 80), Text = Color3.fromRGB(220, 255, 220) },
    Midnight = { Main = Color3.fromRGB(15, 15, 25), Secondary = Color3.fromRGB(25, 25, 40), Accent = Color3.fromRGB(100, 100, 255), Text = Color3.fromRGB(230, 230, 255) },
    Cyberpunk = { Main = Color3.fromRGB(10, 10, 15), Secondary = Color3.fromRGB(20, 20, 30), Accent = Color3.fromRGB(255, 0, 120), Text = Color3.fromRGB(0, 255, 255) },
    Synthwave = { Main = Color3.fromRGB(25, 0, 25), Secondary = Color3.fromRGB(40, 0, 40), Accent = Color3.fromRGB(255, 180, 0), Text = Color3.fromRGB(0, 255, 255) },
    Dracula = { Main = Color3.fromRGB(40, 42, 54), Secondary = Color3.fromRGB(68, 71, 90), Accent = Color3.fromRGB(189, 147, 249), Text = Color3.fromRGB(248, 248, 242) },
    Monokai = { Main = Color3.fromRGB(39, 40, 34), Secondary = Color3.fromRGB(62, 61, 50), Accent = Color3.fromRGB(166, 226, 46), Text = Color3.fromRGB(248, 248, 242) },
    Discord = { Main = Color3.fromRGB(54, 57, 63), Secondary = Color3.fromRGB(47, 49, 54), Accent = Color3.fromRGB(114, 137, 218), Text = Color3.fromRGB(255, 255, 255) },
    Spotify = { Main = Color3.fromRGB(25, 20, 20), Secondary = Color3.fromRGB(40, 40, 40), Accent = Color3.fromRGB(30, 215, 96), Text = Color3.fromRGB(255, 255, 255) },
    Gold = { Main = Color3.fromRGB(25, 25, 25), Secondary = Color3.fromRGB(35, 35, 35), Accent = Color3.fromRGB(255, 215, 0), Text = Color3.fromRGB(255, 255, 255) },
    Amethyst = { Main = Color3.fromRGB(20, 10, 30), Secondary = Color3.fromRGB(30, 15, 45), Accent = Color3.fromRGB(155, 89, 182), Text = Color3.fromRGB(255, 255, 255) },
}

--// Helper: Create Instance
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

--// Main Window Function
function Library:CreateWindow(Settings)
    Settings = Settings or {}
    Settings.Name = Settings.Name or "UI Library"
    Settings.LoadingName = Settings.LoadingName or "Welcome Back!"
    Settings.LoadingIcon = Settings.LoadingIcon or ""
    Settings.Theme = Settings.Theme or "Default"
    Settings.Folder = Settings.Folder or "ModernUI"
    Settings.ConfigName = Settings.ConfigName or "Config"
    
    -- Check/Create Folder
    if not isfolder(Settings.Folder) then makefolder(Settings.Folder) end

    -- Update Global Theme
    Library.Theme = Themes[Settings.Theme] or Themes.Default
    
    local ScreenGui = Create("ScreenGui", { Name = "ModernUI", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    
    --// LOADING SYSTEM
    local LoadingFrame = Create("Frame", {
        Name = "Loading", Parent = ScreenGui, Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = Library.Theme.Main, ZIndex = 999
    })
    local LoadingIcon = Create("ImageLabel", {
        Parent = LoadingFrame, Size = UDim2.new(0, 80, 0, 80), Position = UDim2.new(0.5, -40, 0.4, -40),
        BackgroundTransparency = 1, Image = "rbxassetid://"..Settings.LoadingIcon
    })
    local LoadingText = Create("TextLabel", {
        Parent = LoadingFrame, Size = UDim2.new(0, 200, 0, 30), Position = UDim2.new(0.5, -100, 0.4, 50),
        BackgroundTransparency = 1, Text = Settings.LoadingName, TextColor3 = Library.Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 18, TextTransparency = 1
    })

    -- Loading Animation
    Tween(LoadingText, {TextTransparency = 0}, 1)
    task.wait(2)
    Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
    Tween(LoadingIcon, {ImageTransparency = 1}, 0.5)
    Tween(LoadingText, {TextTransparency = 1}, 0.5)
    task.wait(0.5)
    LoadingFrame.Visible = false

    --// KEY SYSTEM LOGIC
    if Settings.KeySystem then
        local Passed = false
        local KeyFile = Settings.Folder .. "/Key.txt"
        
        -- Check Saved Key
        if Settings.KeySave and isfile(KeyFile) then
            local SavedKey = readfile(KeyFile)
            if SavedKey == Settings.Key then Passed = true end
        end

        if not Passed then
            LoadingFrame.Visible = true
            LoadingFrame.BackgroundTransparency = 0
            LoadingText.TextTransparency = 0
            LoadingText.Text = "Key System Required"
            
            local KeyFrame = Create("Frame", {
                Parent = LoadingFrame, Size = UDim2.new(0, 300, 0, 120), Position = UDim2.new(0.5, -150, 0.5, 0),
                BackgroundColor3 = Library.Theme.Secondary, BackgroundTransparency = 0
            })
            Create("UICorner", { Parent = KeyFrame, CornerRadius = UDim.new(0, 8) })
            
            local KeyBox = Create("TextBox", {
                Parent = KeyFrame, Size = UDim2.new(0.8, 0, 0, 30), Position = UDim2.new(0.1, 0, 0.2, 0),
                BackgroundColor3 = Library.Theme.Main, TextColor3 = Library.Theme.Text, PlaceholderText = "Enter Key...",
                Font = Enum.Font.Gotham, TextSize = 14
            })
            Create("UICorner", { Parent = KeyBox, CornerRadius = UDim.new(0, 6) })

            local EnterBtn = Create("TextButton", {
                Parent = KeyFrame, Size = UDim2.new(0.35, 0, 0, 30), Position = UDim2.new(0.1, 0, 0.6, 0),
                BackgroundColor3 = Library.Theme.Accent, Text = "Submit", TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamBold, TextSize = 14
            })
            Create("UICorner", { Parent = EnterBtn, CornerRadius = UDim.new(0, 6) })

            local LinkBtn = Create("TextButton", {
                Parent = KeyFrame, Size = UDim2.new(0.35, 0, 0, 30), Position = UDim2.new(0.55, 0, 0.6, 0),
                BackgroundColor3 = Library.Theme.Main, Text = "Get Key", TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 14
            })
            Create("UICorner", { Parent = LinkBtn, CornerRadius = UDim.new(0, 6) })

            LinkBtn.MouseButton1Click:Connect(function()
                setclipboard(Settings.GetKeyFromSite or "https://example.com/key")
                LinkBtn.Text = "Copied!"
                task.wait(1)
                LinkBtn.Text = "Get Key"
            end)

            local waiting = true
            EnterBtn.MouseButton1Click:Connect(function()
                if KeyBox.Text == Settings.Key then
                    if Settings.KeySave then writefile(KeyFile, KeyBox.Text) end
                    waiting = false
                else
                    KeyBox.Text = ""
                    KeyBox.PlaceholderText = "Invalid Key!"
                    task.wait(1)
                    KeyBox.PlaceholderText = "Enter Key..."
                end
            end)

            repeat task.wait() until not waiting
            Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
            LoadingFrame.Visible = false
        end
    end

    --// MAIN UI CONSTRUCTION
    local MainFrame = Create("Frame", {
        Name = "Main", Parent = ScreenGui, Size = UDim2.new(0, 550, 0, 350), Position = UDim2.new(0.5, -275, 0.5, -175),
        BackgroundColor3 = Library.Theme.Main, ClipsDescendants = true
    })
    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 10) })
    Create("UIStroke", { Parent = MainFrame, Color = Library.Theme.Secondary, Thickness = 2 })

    local Topbar = Create("Frame", {
        Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Secondary
    })
    Create("UICorner", { Parent = Topbar, CornerRadius = UDim.new(0, 10) })
    -- Fix bottom corners of topbar
    local HideCorner = Create("Frame", {
        Parent = Topbar, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Library.Theme.Secondary, BorderSizePixel = 0
    })

    local Title = Create("TextLabel", {
        Parent = Topbar, Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1, Text = Settings.Name, TextColor3 = Library.Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Control Buttons (Min, Close)
    local ButtonContainer = Create("Frame", {
        Parent = Topbar, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -100, 0, 0),
        BackgroundTransparency = 1
    })
    local Layout = Create("UIListLayout", {
        Parent = ButtonContainer, FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 5)
    })
    Create("UIPadding", { Parent = ButtonContainer, PaddingRight = UDim.new(0, 10) })

    local function CreateTopBtn(icon, color, callback)
        local btn = Create("TextButton", {
            Parent = ButtonContainer, Size = UDim2.new(0, 24, 0, 24),
            BackgroundColor3 = color or Library.Theme.Main, Text = "", AutoButtonColor = false
        })
        Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })
        local img = Create("ImageLabel", {
            Parent = btn, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7),
            BackgroundTransparency = 1, Image = icon
        })
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Minimize
    local Minimized = false
    local OldSize = MainFrame.Size
    CreateTopBtn("rbxassetid://6034824579", Library.Theme.Accent, function() -- Left arrow icon
        Minimized = not Minimized
        if Minimized then
            OldSize = MainFrame.Size
            Tween(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 40)})
            for _,v in pairs(MainFrame:GetChildren()) do
                if v.Name ~= "Topbar" and v.Name ~= "UICorner" and v.Name ~= "UIStroke" then v.Visible = false end
            end
        else
            Tween(MainFrame, {Size = OldSize})
            task.wait(0.3)
            for _,v in pairs(MainFrame:GetChildren()) do v.Visible = true end
        end
    end)

    -- Close with Modal
    CreateTopBtn("rbxassetid://6031094678", Color3.fromRGB(200, 50, 50), function()
        local Modal = Create("Frame", {
            Parent = ScreenGui, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.5, ZIndex = 2000
        })
        local Alert = Create("Frame", {
            Parent = Modal, Size = UDim2.new(0, 300, 0, 150), Position = UDim2.new(0.5, -150, 0.5, -75),
            BackgroundColor3 = Library.Theme.Main
        })
        Create("UICorner", { Parent = Alert, CornerRadius = UDim.new(0, 10) })
        Create("TextLabel", {
            Parent = Alert, Size = UDim2.new(1,0,0,50), Text = "Are you sure?",
            TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 18
        })
        
        local Yes = Create("TextButton", {
            Parent = Alert, Size = UDim2.new(0, 100, 0, 35), Position = UDim2.new(0.5, 10, 0.6, 0),
            BackgroundColor3 = Color3.fromRGB(200, 50, 50), Text = "Yes", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham
        })
        Create("UICorner", { Parent = Yes, CornerRadius = UDim.new(0,6) })
        
        local No = Create("TextButton", {
            Parent = Alert, Size = UDim2.new(0, 100, 0, 35), Position = UDim2.new(0.5, -110, 0.6, 0),
            BackgroundColor3 = Library.Theme.Secondary, Text = "Cancel", TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham
        })
        Create("UICorner", { Parent = No, CornerRadius = UDim.new(0,6) })

        Yes.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
        No.MouseButton1Click:Connect(function() Modal:Destroy() end)
    end)

    -- Resizer
    local ResizeBtn = Create("TextButton", {
        Parent = MainFrame, Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(1, -15, 1, -15),
        BackgroundTransparency = 1, Text = ""
    })
    MakeResizable(ResizeBtn, MainFrame)
    MakeDraggable(Topbar, MainFrame)

    -- Container for Tabs and Content
    local TabContainer = Create("ScrollingFrame", {
        Parent = MainFrame, Size = UDim2.new(0, 120, 1, -50), Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1, ScrollBarThickness = 0
    })
    local TabLayout = Create("UIListLayout", { Parent = TabContainer, Padding = UDim.new(0, 5) })

    local ContentContainer = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(1, -145, 1, -50), Position = UDim2.new(0, 135, 0, 45),
        BackgroundTransparency = 1
    })

    --// THEME UPDATER
    local UIStorage = {} -- Store elements to update colors
    local function AddToTheme(obj, prop, themeKey)
        table.insert(UIStorage, {Obj = obj, Prop = prop, Key = themeKey})
    end
    
    local function UpdateAllThemes(newThemeName)
        local t = Themes[newThemeName]
        if not t then return end
        Library.Theme = t
        
        MainFrame.BackgroundColor3 = t.Main
        MainFrame.UIStroke.Color = t.Secondary
        Topbar.BackgroundColor3 = t.Secondary
        HideCorner.BackgroundColor3 = t.Secondary
        Title.TextColor3 = t.Text
        
        for _, data in pairs(UIStorage) do
            if data.Obj and data.Obj.Parent then -- check existence
                pcall(function()
                    data.Obj[data.Prop] = t[data.Key]
                end)
            end
        end
    end

    --// AUTO SAVE & LOAD
    local function SaveConfig()
        if Settings.ConfigName then
            local json = HttpService:JSONEncode(Library.Flags)
            writefile(Settings.Folder .. "/" .. Settings.ConfigName .. ".json", json)
        end
    end

    local function LoadConfig()
        local path = Settings.Folder .. "/" .. Settings.ConfigName .. ".json"
        if isfile(path) then
            local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
            if success then
                Library.Flags = decoded
                -- Note: Values are updated, but visual update requires specific handling per element (done below)
                return true
            end
        end
        return false
    end
    
    local IsConfigLoaded = LoadConfig()

    --// WINDOW METHODS
    local Window = {}
    local FirstTab = true

    function Window:CreateTab(TabName)
        local Tab = {}
        
        -- Tab Button
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = FirstTab and Library.Theme.Accent or Library.Theme.Secondary,
            Text = TabName, TextColor3 = FirstTab and Color3.new(1,1,1) or Library.Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14
        })
        Create("UICorner", { Parent = TabBtn, CornerRadius = UDim.new(0, 6) })
        
        AddToTheme(TabBtn, "BackgroundColor3", FirstTab and "Accent" or "Secondary")
        AddToTheme(TabBtn, "TextColor3", FirstTab and "Text" or "Text") -- logic handled manually below

        -- Tab Content
        local TabContent = Create("ScrollingFrame", {
            Parent = ContentContainer, Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, Visible = FirstTab, ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent
        })
        AddToTheme(TabContent, "ScrollBarImageColor3", "Accent")
        Create("UIListLayout", { Parent = TabContent, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder })
        Create("UIPadding", { Parent = TabContent, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })

        -- Tab Selection Logic
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {BackgroundColor3 = Library.Theme.Secondary, TextColor3 = Library.Theme.Text})
                end
            end
            for _, v in pairs(ContentContainer:GetChildren()) do
                v.Visible = false
            end
            Tween(TabBtn, {BackgroundColor3 = Library.Theme.Accent, TextColor3 = Color3.new(1,1,1)})
            TabContent.Visible = true
        end)

        if FirstTab then FirstTab = false end

        function Tab:CreateSection(SecName)
            local Section = {}
            
            local SecFrame = Create("Frame", {
                Parent = TabContent, Size = UDim2.new(1, 0, 0, 30), -- Height expands
                BackgroundColor3 = Library.Theme.Secondary, BackgroundTransparency = 0.5
            })
            Create("UICorner", { Parent = SecFrame, CornerRadius = UDim.new(0, 8) })
            AddToTheme(SecFrame, "BackgroundColor3", "Secondary")

            local SecLabel = Create("TextLabel", {
                Parent = SecFrame, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, Text = SecName, TextColor3 = Library.Theme.Accent,
                Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
            })
            AddToTheme(SecLabel, "TextColor3", "Accent")

            local Container = Create("Frame", {
                Parent = SecFrame, Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 0, 25),
                BackgroundTransparency = 1
            })
            local SecLayout = Create("UIListLayout", { Parent = Container, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

            SecLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Container.Size = UDim2.new(1, -10, 0, SecLayout.AbsoluteContentSize.Y)
                SecFrame.Size = UDim2.new(1, 0, 0, SecLayout.AbsoluteContentSize.Y + 35)
            end)

            -- 1. BUTTON
            function Section:CreateButton(Name, Callback)
                Callback = Callback or function() end
                
                local Btn = Create("TextButton", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.Main, Text = Name,
                    TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 14
                })
                Create("UICorner", { Parent = Btn, CornerRadius = UDim.new(0, 6) })
                AddToTheme(Btn, "BackgroundColor3", "Main")
                AddToTheme(Btn, "TextColor3", "Text")

                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn, {Size = UDim2.new(0.95, 0, 0, 32)}, 0.1)
                    task.wait(0.1)
                    Tween(Btn, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
                    Callback()
                end)
            end

            -- 2. TOGGLE
            function Section:CreateToggle(Name, Flag, Callback)
                Callback = Callback or function() end
                Flag = Flag or Name
                local Toggled = Library.Flags[Flag] or false

                local ToggleFrame = Create("TextButton", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.Main, Text = "", AutoButtonColor = false
                })
                Create("UICorner", { Parent = ToggleFrame, CornerRadius = UDim.new(0, 6) })
                AddToTheme(ToggleFrame, "BackgroundColor3", "Main")

                local Label = Create("TextLabel", {
                    Parent = ToggleFrame, Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = Name, TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                })
                AddToTheme(Label, "TextColor3", "Text")

                local ToggleIcon = Create("Frame", {
                    Parent = ToggleFrame, Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10),
                    BackgroundColor3 = Toggled and Library.Theme.Accent or Color3.fromRGB(60,60,60)
                })
                Create("UICorner", { Parent = ToggleIcon, CornerRadius = UDim.new(1, 0) })
                
                local Circle = Create("Frame", {
                    Parent = ToggleIcon, Size = UDim2.new(0, 16, 0, 16),
                    Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Color3.new(1,1,1)
                })
                Create("UICorner", { Parent = Circle, CornerRadius = UDim.new(1, 0) })

                local function UpdateToggle()
                    Library.Flags[Flag] = Toggled
                    local GoalPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local GoalColor = Toggled and Library.Theme.Accent or Color3.fromRGB(60,60,60)
                    Tween(Circle, {Position = GoalPos}, 0.2)
                    Tween(ToggleIcon, {BackgroundColor3 = GoalColor}, 0.2)
                    Callback(Toggled)
                    SaveConfig()
                end
                
                -- Init if loaded
                if Toggled then Callback(Toggled) end

                ToggleFrame.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    UpdateToggle()
                end)
            end

            -- 3. SLIDER
            function Section:CreateSlider(Name, Flag, Min, Max, Default, Callback)
                Callback = Callback or function() end
                Flag = Flag or Name
                local Value = Library.Flags[Flag] or Default or Min

                local SliderFrame = Create("Frame", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 45),
                    BackgroundColor3 = Library.Theme.Main
                })
                Create("UICorner", { Parent = SliderFrame, CornerRadius = UDim.new(0, 6) })
                AddToTheme(SliderFrame, "BackgroundColor3", "Main")

                local Label = Create("TextLabel", {
                    Parent = SliderFrame, Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1, Text = Name, TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                })
                AddToTheme(Label, "TextColor3", "Text")

                local ValLabel = Create("TextLabel", {
                    Parent = SliderFrame, Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 5),
                    BackgroundTransparency = 1, Text = tostring(Value), TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right
                })
                AddToTheme(ValLabel, "TextColor3", "Text")

                local SlideBG = Create("Frame", {
                    Parent = SliderFrame, Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                })
                Create("UICorner", { Parent = SlideBG, CornerRadius = UDim.new(1, 0) })

                local Fill = Create("Frame", {
                    Parent = SlideBG, Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
                    BackgroundColor3 = Library.Theme.Accent
                })
                Create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1, 0) })
                AddToTheme(Fill, "BackgroundColor3", "Accent")

                local dragging = false
                local function move(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - SlideBG.AbsolutePosition.X) / SlideBG.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    Fill.Size = pos
                    
                    local val = math.floor(Min + ((Max - Min) * pos.X.Scale))
                    ValLabel.Text = tostring(val)
                    Library.Flags[Flag] = val
                    Callback(val)
                end

                SlideBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        move(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        SaveConfig()
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        move(input)
                    end
                end)
                
                -- Init
                if Value ~= Default then Callback(Value) end
            end

            -- 4. DROPDOWN
            function Section:CreateDropdown(Name, Flag, Options, Callback)
                Callback = Callback or function() end
                Flag = Flag or Name
                local CurrentOption = Library.Flags[Flag] or Options[1]
                local IsOpen = false

                local DropFrame = Create("Frame", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.Main, ClipsDescendants = true, ZIndex = 5
                })
                Create("UICorner", { Parent = DropFrame, CornerRadius = UDim.new(0, 6) })
                AddToTheme(DropFrame, "BackgroundColor3", "Main")

                local Label = Create("TextLabel", {
                    Parent = DropFrame, Size = UDim2.new(1, -30, 0, 32), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = Name .. ": " .. CurrentOption, TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                })
                AddToTheme(Label, "TextColor3", "Text")

                local Arrow = Create("ImageLabel", {
                    Parent = DropFrame, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -25, 0, 6),
                    BackgroundTransparency = 1, Image = "rbxassetid://6034818372", ImageColor3 = Library.Theme.Text
                })
                AddToTheme(Arrow, "ImageColor3", "Text")

                local Btn = Create("TextButton", {
                    Parent = DropFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""
                })

                local DropContainer = Create("Frame", {
                    Parent = DropFrame, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1
                })
                local DropLayout = Create("UIListLayout", { Parent = DropContainer, SortOrder = Enum.SortOrder.LayoutOrder })

                local function RefreshList()
                    for _, v in pairs(DropContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    for _, opt in pairs(Options) do
                        local OptBtn = Create("TextButton", {
                            Parent = DropContainer, Size = UDim2.new(1, 0, 0, 30),
                            BackgroundColor3 = Library.Theme.Secondary, Text = opt,
                            TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 14
                        })
                        AddToTheme(OptBtn, "BackgroundColor3", "Secondary")
                        AddToTheme(OptBtn, "TextColor3", "Text")
                        
                        OptBtn.MouseButton1Click:Connect(function()
                            CurrentOption = opt
                            Label.Text = Name .. ": " .. opt
                            Library.Flags[Flag] = opt
                            Callback(opt)
                            SaveConfig()
                            IsOpen = false
                            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                            Tween(Arrow, {Rotation = 0}, 0.2)
                        end)
                    end
                end
                
                RefreshList()

                Btn.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    if IsOpen then
                        local Height = math.min(#Options * 30, 150)
                        Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 32 + Height)}, 0.2)
                        Tween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                -- Auto Update function for dynamic dropdowns (Themes)
                function DropFrame:UpdateOptions(NewOptions)
                    Options = NewOptions
                    RefreshList()
                    if IsOpen then
                         local Height = math.min(#Options * 30, 150)
                         Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 32 + Height)}, 0.2)
                    end
                end

                return DropFrame
            end

            -- 5. TEXTBOX
            function Section:CreateTextbox(Name, Flag, Placeholder, Callback)
                Callback = Callback or function() end
                Flag = Flag or Name
                
                local BoxFrame = Create("Frame", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.Main
                })
                Create("UICorner", { Parent = BoxFrame, CornerRadius = UDim.new(0, 6) })
                AddToTheme(BoxFrame, "BackgroundColor3", "Main")

                local Label = Create("TextLabel", {
                    Parent = BoxFrame, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = Name, TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                })
                AddToTheme(Label, "TextColor3", "Text")

                local Box = Create("TextBox", {
                    Parent = BoxFrame, Size = UDim2.new(0, 100, 0, 24), Position = UDim2.new(1, -110, 0, 4),
                    BackgroundColor3 = Library.Theme.Secondary, Text = Library.Flags[Flag] or "",
                    PlaceholderText = Placeholder or "Type...", TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14
                })
                Create("UICorner", { Parent = Box, CornerRadius = UDim.new(0, 4) })
                AddToTheme(Box, "BackgroundColor3", "Secondary")
                AddToTheme(Box, "TextColor3", "Text")

                Box.FocusLost:Connect(function()
                    Library.Flags[Flag] = Box.Text
                    Callback(Box.Text)
                    SaveConfig()
                end)
            end

            -- 6. KEYBIND
            function Section:CreateKeybind(Name, Flag, DefaultKey, Callback)
                Callback = Callback or function() end
                Flag = Flag or Name
                local CurrentKey = Library.Flags[Flag] or DefaultKey or Enum.KeyCode.E

                local KeyFrame = Create("Frame", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Library.Theme.Main
                })
                Create("UICorner", { Parent = KeyFrame, CornerRadius = UDim.new(0, 6) })
                AddToTheme(KeyFrame, "BackgroundColor3", "Main")

                local Label = Create("TextLabel", {
                    Parent = KeyFrame, Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = Name, TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                })
                AddToTheme(Label, "TextColor3", "Text")

                local KeyBtn = Create("TextButton", {
                    Parent = KeyFrame, Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(1, -90, 0, 4),
                    BackgroundColor3 = Library.Theme.Secondary, Text = string.sub(tostring(CurrentKey), 14),
                    TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 14
                })
                Create("UICorner", { Parent = KeyBtn, CornerRadius = UDim.new(0, 4) })
                AddToTheme(KeyBtn, "BackgroundColor3", "Secondary")
                AddToTheme(KeyBtn, "TextColor3", "Text")

                local Listening = false

                KeyBtn.MouseButton1Click:Connect(function()
                    Listening = true
                    KeyBtn.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        KeyBtn.Text = string.sub(tostring(CurrentKey), 14)
                        Library.Flags[Flag] = CurrentKey -- Note: Saving Enums in JSON requires serialization, keeping simple here
                        Listening = false
                        Callback(CurrentKey)
                    elseif not Listening and input.KeyCode == CurrentKey then
                        Callback(CurrentKey)
                    end
                end)
            end

            -- 7. LABEL
            function Section:CreateLabel(Text)
                local Lab = Create("TextLabel", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1, Text = Text, TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 14
                })
                AddToTheme(Lab, "TextColor3", "Text")
            end

            -- 8. COLOR PICKER (Simplified RGB)
            function Section:CreateColorPicker(Name, Flag, Default, Callback)
                 -- Due to complexity of a full canvas picker in a single script, we use RGB inputs + Preview
                 Callback = Callback or function() end
                 Flag = Flag or Name
                 local CurrentColor = Library.Flags[Flag] and Color3.new(unpack(Library.Flags[Flag])) or Default or Color3.new(1,1,1)
                 
                 local PickerFrame = Create("Frame", {
                     Parent = Container, Size = UDim2.new(1, 0, 0, 60),
                     BackgroundColor3 = Library.Theme.Main
                 })
                 Create("UICorner", { Parent = PickerFrame, CornerRadius = UDim.new(0, 6) })
                 AddToTheme(PickerFrame, "BackgroundColor3", "Main")
                 
                 local Label = Create("TextLabel", {
                     Parent = PickerFrame, Size = UDim2.new(0, 100, 0, 30), Position = UDim2.new(0, 10, 0, 0),
                     BackgroundTransparency = 1, Text = Name, TextColor3 = Library.Theme.Text,
                     Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
                 })
                 AddToTheme(Label, "TextColor3", "Text")
                 
                 local Preview = Create("Frame", {
                     Parent = PickerFrame, Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0, 5),
                     BackgroundColor3 = CurrentColor
                 })
                 Create("UICorner", {Parent=Preview, CornerRadius=UDim.new(0,4)})
                 
                 local function UpdateColor()
                     Library.Flags[Flag] = {CurrentColor.R, CurrentColor.G, CurrentColor.B}
                     Preview.BackgroundColor3 = CurrentColor
                     Callback(CurrentColor)
                     SaveConfig()
                 end
                 
                 -- RGB Sliders would take too much space, let's do a simple Hue Slider
                 local HueSlider = Create("Frame", {
                     Parent = PickerFrame, Size = UDim2.new(1, -20, 0, 10), Position = UDim2.new(0, 10, 0, 40),
                     BackgroundColor3 = Color3.new(1,1,1)
                 })
                 Create("UIGradient", {
                     Parent = HueSlider, Color = ColorSequence.new({
                         ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
                         ColorSequenceKeypoint.new(0.17, Color3.new(1,1,0)),
                         ColorSequenceKeypoint.new(0.33, Color3.new(0,1,0)),
                         ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
                         ColorSequenceKeypoint.new(0.67, Color3.new(0,0,1)),
                         ColorSequenceKeypoint.new(0.83, Color3.new(1,0,1)),
                         ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
                     })
                 })
                 Create("UICorner", {Parent=HueSlider, CornerRadius=UDim.new(1,0)})
                 
                 local Knob = Create("Frame", {
                     Parent = HueSlider, Size = UDim2.new(0, 8, 0, 14), Position = UDim2.new(0,0,0.5,-7),
                     BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 1
                 })
                 
                 local dragging = false
                 HueSlider.InputBegan:Connect(function(input)
                     if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                 end)
                 UserInputService.InputEnded:Connect(function(input)
                     if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                 end)
                 UserInputService.InputChanged:Connect(function(input)
                     if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                         local pos = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                         Knob.Position = UDim2.new(pos, -4, 0.5, -7)
                         CurrentColor = Color3.fromHSV(pos, 1, 1)
                         UpdateColor()
                     end
                 end)
            end
            
            return Section
        end

        return Tab
    end

    function Window:AddConfig()
        local ConfigTab = Window:CreateTab("Config")
        local ConfigSec = ConfigTab:CreateSection("Theme System")
        
        -- Theme List
        local ThemeNames = {}
        for k, v in pairs(Themes) do table.insert(ThemeNames, k) end
        table.sort(ThemeNames)
        
        ConfigSec:CreateDropdown("Select Theme", "ThemeConfig", ThemeNames, function(val)
            UpdateAllThemes(val)
        end)
        
        ConfigSec:CreateButton("Force Save Config", function()
            SaveConfig()
        end)
        
        ConfigSec:CreateLabel("Auto-saving is enabled by default.")
    end

    Library.CurrentWindow = Window
    return Window
end

return Library
