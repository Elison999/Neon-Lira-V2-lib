--[[ 
    Modern UI Library - Neon Lira V3 (Refactor)
    Muito mais moderno, modular e seguro que a versão original.
    Principais melhorias:
    - Arquitetura modular (ThemeManager, InputManager, Serializer)
    - Serialização robusta (Color3, Enum.KeyCode, Vector2, tabelas)
    - Input centralizado para evitar vazamentos de eventos
    - Cleanup/teardown para evitar listeners persistentes
    - Correções de bugs: divisões por zero, propriedade Visible em não-GuiObjects, imagens vazias
    - UI responsiva, animações suaves e efeitos modernos
    - Auto-save com debounce e compatibilidade Studio / Executor
    - Melhor UX: feedback visual, hover, ripple, confirmação de close, minimizar seguro
    - Compatível com PlayerGui (fallback para CoreGui)
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Player context
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- Environment-safe file API (studio-friendly fallbacks)
local function safe_writefile(path, data)
    if writefile then
        local ok, err = pcall(function() writefile(path, data) end)
        if not ok then warn("[ModernUI] writefile failed:", err) end
    else
        warn("[ModernUI] writefile not available; simulated write to:", path)
    end
end

local function safe_readfile(path)
    if readfile then
        local ok, res = pcall(function() return readfile(path) end)
        if ok then return res end
        warn("[ModernUI] readfile failed for:", path)
    else
        warn("[ModernUI] readfile not available; simulated read from:", path)
    end
    return nil
end

local function safe_isfile(path)
    if isfile then
        local ok, res = pcall(function() return isfile(path) end)
        if ok then return res end
    end
    return false
end

local function safe_isfolder(path)
    if isfolder then
        local ok, res = pcall(function() return isfolder(path) end)
        if ok then return res end
    end
    return false
end

local function safe_makefolder(path)
    if makefolder then
        pcall(function() makefolder(path) end)
    else
        warn("[ModernUI] makefolder not available:", path)
    end
end

-- Utility: safe Instance creation (ignores invalid props)
local function Create(class, props)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

-- Quick Tween helper
local function QuickTween(instance, props, time, easingStyle, easingDirection)
    local info = TweenInfo.new(time or 0.25, easingStyle or Enum.EasingStyle.Quint, easingDirection or Enum.EasingDirection.Out)
    local tw = TweenService:Create(instance, info, props)
    tw:Play()
    return tw
end

-- Serializer: encode/decode values for JSON persistence
local Serializer = {}
do
    local function isSimpleType(v)
        local t = typeof(v)
        return t == "string" or t == "number" or t == "boolean" or t == "nil"
    end

    function Serializer.encodeValue(v)
        local t = typeof(v)
        if t == "Color3" then
            return { __type = "Color3", r = v.R, g = v.G, b = v.B }
        elseif t == "EnumItem" then
            -- Save as {__type="Enum", enumType="Enum.KeyCode", name="E"}
            return { __type = "Enum", enumType = tostring(v.EnumType), name = v.Name }
        elseif t == "Vector2" then
            return { __type = "Vector2", x = v.X, y = v.Y }
        elseif t == "UDim2" then
            return { __type = "UDim2", xScale = v.X.Scale, xOffset = v.X.Offset, yScale = v.Y.Scale, yOffset = v.Y.Offset }
        elseif t == "table" then
            local out = {}
            for k, val in pairs(v) do
                out[k] = Serializer.encodeValue(val)
            end
            return out
        elseif isSimpleType(v) then
            return v
        else
            -- fallback tostring
            return { __type = "string", value = tostring(v) }
        end
    end

    local function resolveEnum(enumTypeStr, name)
        -- iterate Enums to find a match
        for _, enumTable in pairs(Enum:GetEnums()) do
            if tostring(enumTable) == enumTypeStr then
                return enumTable[name]
            end
        end
        return nil
    end

    function Serializer.decodeValue(v)
        if type(v) ~= "table" then return v end
        if v.__type == "Color3" then return Color3.new(v.r, v.g, v.b) end
        if v.__type == "Enum" and v.enumType and v.name then
            local resolved = resolveEnum(v.enumType, v.name)
            return resolved
        end
        if v.__type == "Vector2" then return Vector2.new(v.x, v.y) end
        if v.__type == "UDim2" then return UDim2.new(v.xScale, v.xOffset, v.yScale, v.yOffset) end
        if v.__type == "string" and v.value then return v.value end
        -- generic table
        local out = {}
        for k, val in pairs(v) do out[k] = Serializer.decodeValue(val) end
        return out
    end

    function Serializer.encodeTable(tbl)
        local out = {}
        for k, v in pairs(tbl) do out[k] = Serializer.encodeValue(v) end
        return out
    end

    function Serializer.decodeTable(tbl)
        local out = {}
        for k, v in pairs(tbl) do out[k] = Serializer.decodeValue(v) end
        return out
    end
end

-- ThemeManager: reactive theme system, supports subscribers and transforms
local ThemeManager = {}
do
    ThemeManager.themes = {
        Default = { Main = Color3.fromRGB(25,25,25), Secondary = Color3.fromRGB(35,35,35), Accent = Color3.fromRGB(0,122,255), Text = Color3.fromRGB(255,255,255) },
        Dark = { Main = Color3.fromRGB(20,20,20), Secondary = Color3.fromRGB(30,30,30), Accent = Color3.fromRGB(100,100,100), Text = Color3.fromRGB(240,240,240) },
        Light = { Main = Color3.fromRGB(240,240,240), Secondary = Color3.fromRGB(255,255,255), Accent = Color3.fromRGB(0,122,255), Text = Color3.fromRGB(20,20,20) },
        Blood = { Main = Color3.fromRGB(20,10,10), Secondary = Color3.fromRGB(30,15,15), Accent = Color3.fromRGB(200,40,40), Text = Color3.fromRGB(255,200,200) },
        Ocean = { Main = Color3.fromRGB(10,20,30), Secondary = Color3.fromRGB(15,30,45), Accent = Color3.fromRGB(0,150,255), Text = Color3.fromRGB(200,240,255) },
        Forest = { Main = Color3.fromRGB(20,30,20), Secondary = Color3.fromRGB(30,45,30), Accent = Color3.fromRGB(40,180,80), Text = Color3.fromRGB(220,255,220) },
        Midnight = { Main = Color3.fromRGB(15,15,25), Secondary = Color3.fromRGB(25,25,40), Accent = Color3.fromRGB(100,100,255), Text = Color3.fromRGB(230,230,255) },
        Cyberpunk = { Main = Color3.fromRGB(10,10,15), Secondary = Color3.fromRGB(20,20,30), Accent = Color3.fromRGB(255,0,120), Text = Color3.fromRGB(0,255,255) },
        Synthwave = { Main = Color3.fromRGB(25,0,25), Secondary = Color3.fromRGB(40,0,40), Accent = Color3.fromRGB(255,180,0), Text = Color3.fromRGB(0,255,255) },
        Dracula = { Main = Color3.fromRGB(40,42,54), Secondary = Color3.fromRGB(68,71,90), Accent = Color3.fromRGB(189,147,249), Text = Color3.fromRGB(248,248,242) },
        Monokai = { Main = Color3.fromRGB(39,40,34), Secondary = Color3.fromRGB(62,61,50), Accent = Color3.fromRGB(166,226,46), Text = Color3.fromRGB(248,248,242) },
        Discord = { Main = Color3.fromRGB(54,57,63), Secondary = Color3.fromRGB(47,49,54), Accent = Color3.fromRGB(114,137,218), Text = Color3.fromRGB(255,255,255) },
        Spotify = { Main = Color3.fromRGB(25,20,20), Secondary = Color3.fromRGB(40,40,40), Accent = Color3.fromRGB(30,215,96), Text = Color3.fromRGB(255,255,255) },
        Gold = { Main = Color3.fromRGB(25,25,25), Secondary = Color3.fromRGB(35,35,35), Accent = Color3.fromRGB(255,215,0), Text = Color3.fromRGB(255,255,255) },
        Amethyst = { Main = Color3.fromRGB(20,10,30), Secondary = Color3.fromRGB(30,15,45), Accent = Color3.fromRGB(155,89,182), Text = Color3.fromRGB(255,255,255) },
    }
    ThemeManager.current = ThemeManager.themes.Default
    ThemeManager.subscribers = {} -- { {obj=GuiObject, prop="BackgroundColor3", key="Main", transform=function() end} }

    function ThemeManager:Subscribe(obj, prop, key, transform)
        table.insert(self.subscribers, { obj = obj, prop = prop, key = key, transform = transform })
        -- apply now (pcall to avoid errors)
        pcall(function()
            local v = self.current[key]
            if transform then v = transform(v) end
            obj[prop] = v
        end)
    end

    function ThemeManager:ApplyTheme(name)
        local t = self.themes[name]
        if not t then return false end
        self.current = t
        for _, s in ipairs(self.subscribers) do
            if s.obj and s.obj.Parent then
                pcall(function()
                    local v = t[s.key]
                    if s.transform then v = s.transform(v) end
                    s.obj[s.prop] = v
                end)
            end
        end
        return true
    end

    function ThemeManager:GetThemeNames()
        local out = {}
        for k, _ in pairs(self.themes) do table.insert(out, k) end
        table.sort(out)
        return out
    end
end

-- InputManager: central event distribution with registration + teardown
local InputManager = {}
do
    InputManager.handlers = {} -- id -> {onBegin, onChanged, onEnd}
    local idCounter = 0

    function InputManager:Register(handler)
        idCounter = idCounter + 1
        self.handlers[idCounter] = handler
        return idCounter
    end

    function InputManager:Unregister(id)
        self.handlers[id] = nil
    end

    -- global listeners push events to registered handlers
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        for _, h in pairs(InputManager.handlers) do
            if h.onBegin then
                pcall(function() h.onBegin(input, gameProcessed) end)
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        for _, h in pairs(InputManager.handlers) do
            if h.onChanged then
                pcall(function() h.onChanged(input, gameProcessed) end)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        for _, h in pairs(InputManager.handlers) do
            if h.onEnd then
                pcall(function() h.onEnd(input, gameProcessed) end)
            end
        end
    end)
end

-- Library core
local Library = {}
Library.__index = Library
Library.Flags = {}
Library.Theme = ThemeManager
Library._windows = {}
Library._saveDebounces = {}

-- Default settings
local DEFAULT_SETTINGS = {
    Name = "Neon Lira UI",
    LoadingName = "Welcome Back!",
    LoadingIcon = "", -- asset id string or empty
    Theme = "Default",
    Folder = "ModernUI",
    ConfigName = "Config",
    KeySystem = false,
    Key = nil,
    KeySave = true,
    GetKeyFromSite = nil
}

-- Utility: choose parent (PlayerGui preferred)
local function chooseParent()
    if PlayerGui then return PlayerGui end
    -- fallback to CoreGui if permitted
    return CoreGui
end

-- Draggable with bounds clamping and cleanup
local function MakeDraggable(topbar, object)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local conn1, conn2, conn3

    local function update(input)
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        -- clamp to viewport
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        local absSize = object.AbsoluteSize
        newX = math.clamp(newX, 0 - absSize.X + 40, viewport.X - 40)
        newY = math.clamp(newY, 0, viewport.Y - 40)
        object.Position = UDim2.new(0, newX, 0, newY)
    end

    conn1 = topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            -- wait for end (handled in InputEnded below)
        end
    end)

    conn2 = topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    conn3 = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            pcall(update, input)
        end
    end)

    -- cleanup on destroy
    local destroyConn
    destroyConn = object.AncestryChanged:Connect(function(_, parent)
        if not parent then
            conn1:Disconnect()
            conn2:Disconnect()
            conn3:Disconnect()
            destroyConn:Disconnect()
        end
    end)
end

-- Resizable with min size checks
local function MakeResizable(dragHandle, frame, minSize)
    minSize = minSize or Vector2.new(300, 200)
    local dragging = false
    local dragStart = nil
    local startSize = nil
    local connChanged, connEnded

    connChanged = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = math.max(minSize.X, startSize.X + delta.X)
            local newY = math.max(minSize.Y, startSize.Y + delta.Y)
            frame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    connEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startSize = frame.AbsoluteSize
        end
    end)

    -- cleanup when removed
    local destroyConn
    destroyConn = frame.AncestryChanged:Connect(function(_, parent)
        if not parent then
            connChanged:Disconnect()
            connEnded:Disconnect()
            destroyConn:Disconnect()
        end
    end)
end

-- Helper: safe set Visible (only GuiObjects)
local function safeSetVisible(instances, visible)
    for _, v in pairs(instances) do
        if v and v.Parent and v:IsA("GuiObject") and v.Name ~= "Topbar" then
            pcall(function() v.Visible = visible end)
        end
    end
end

-- Core Window builder
function Library:CreateWindow(settings)
    settings = settings or {}
    for k, v in pairs(DEFAULT_SETTINGS) do
        if settings[k] == nil then settings[k] = v end
    end

    -- ensure folder exists
    if not safe_isfolder(settings.Folder) then
        safe_makefolder(settings.Folder)
    end

    -- load saved theme if present
    if settings.Theme and ThemeManager.themes[settings.Theme] then
        ThemeManager:ApplyTheme(settings.Theme)
    else
        ThemeManager:ApplyTheme("Default")
    end

    local parent = chooseParent()
    local screenGui = Create("ScreenGui", { Name = ("NeonLira_%s"):format(http and http.request and http.request or math.random()), Parent = parent, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    -- try to set ResetOnSpawn false (pcall for secure env)
    pcall(function() screenGui.ResetOnSpawn = false end)

    -- Loading overlay
    local LoadingFrame = Create("Frame", {
        Name = "__Loading", Parent = screenGui, Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = ThemeManager.current.Main, ZIndex = 9999
    })
    Create("UICorner", { Parent = LoadingFrame, CornerRadius = UDim.new(0,0) })
    local LoadingIcon = Create("ImageLabel", {
        Parent = LoadingFrame, Size = UDim2.new(0, 96, 0, 96), Position = UDim2.new(0.5, -48, 0.35, -48),
        BackgroundTransparency = 1
    })
    if type(settings.LoadingIcon) == "string" and #settings.LoadingIcon > 0 then
        pcall(function() LoadingIcon.Image = "rbxassetid://"..settings.LoadingIcon end)
    else
        LoadingIcon.Image = "" -- keep empty
    end

    local LoadingText = Create("TextLabel", {
        Parent = LoadingFrame, Size = UDim2.new(0, 380, 0, 36), Position = UDim2.new(0.5, -190, 0.55, -18),
        BackgroundTransparency = 1, Text = settings.LoadingName, TextColor3 = ThemeManager.current.Text,
        Font = Enum.Font.GothamBold, TextSize = 20, TextTransparency = 1
    })

    QuickTween(LoadingText, {TextTransparency = 0}, 0.9)
    task.defer(function()
        task.wait(1.8)
        QuickTween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
        QuickTween(LoadingIcon, {ImageTransparency = 1}, 0.5)
        QuickTween(LoadingText, {TextTransparency = 1}, 0.5)
        task.wait(0.5)
        pcall(function() LoadingFrame.Visible = false end)
    end)

    -- Key system (safe)
    if settings.KeySystem then
        local passed = false
        local KeyPath = settings.Folder .. "/Key.txt"
        if settings.KeySave and safe_isfile(KeyPath) then
            local saved = safe_readfile(KeyPath)
            if saved and tostring(saved) == tostring(settings.Key) then
                passed = true
            end
        end

        if not passed then
            -- show blocking loading with key prompt
            LoadingFrame.Visible = true
            LoadingFrame.BackgroundTransparency = 0
            LoadingText.TextTransparency = 0
            LoadingText.Text = "Key System Required"

            local KeyFrame = Create("Frame", {
                Parent = LoadingFrame, Size = UDim2.new(0, 340, 0, 140), Position = UDim2.new(0.5, -170, 0.5, -70),
                BackgroundColor3 = ThemeManager.current.Secondary
            })
            Create("UICorner", { Parent = KeyFrame, CornerRadius = UDim.new(0,10) })
            Create("UIStroke", { Parent = KeyFrame, Thickness = 1, Color = ThemeManager.current.Main })

            local KeyBox = Create("TextBox", {
                Parent = KeyFrame, Size = UDim2.new(0.9,0,0,32), Position = UDim2.new(0.05,0,0.2,0),
                BackgroundColor3 = ThemeManager.current.Main, TextColor3 = ThemeManager.current.Text, PlaceholderText = "Enter Key...", Font = Enum.Font.Gotham, TextSize = 14
            })
            Create("UICorner", { Parent = KeyBox, CornerRadius = UDim.new(0,6) })

            local EnterBtn = Create("TextButton", {
                Parent = KeyFrame, Size = UDim2.new(0.4,0,0,32), Position = UDim2.new(0.05,0,0.6,0),
                BackgroundColor3 = ThemeManager.current.Accent, Text = "Submit", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 14
            })
            Create("UICorner", { Parent = EnterBtn, CornerRadius = UDim.new(0,6) })

            local LinkBtn = Create("TextButton", {
                Parent = KeyFrame, Size = UDim2.new(0.4,0,0,32), Position = UDim2.new(0.55,0,0.6,0),
                BackgroundColor3 = ThemeManager.current.Main, Text = "Get Key", TextColor3 = ThemeManager.current.Text, Font = Enum.Font.GothamBold, TextSize = 14
            })
            Create("UICorner", { Parent = LinkBtn, CornerRadius = UDim.new(0,6) })

            LinkBtn.MouseButton1Click:Connect(function()
                if type(settings.GetKeyFromSite) == "string" and #settings.GetKeyFromSite > 0 then
                    pcall(function() setclipboard(settings.GetKeyFromSite) end)
                    LinkBtn.Text = "Copied!"
                    task.delay(1, function() LinkBtn.Text = "Get Key" end)
                else
                    LinkBtn.Text = "Unavailable"
                    task.delay(1, function() LinkBtn.Text = "Get Key" end)
                end
            end)

            local waiting = true
            EnterBtn.MouseButton1Click:Connect(function()
                if KeyBox.Text == tostring(settings.Key) then
                    if settings.KeySave then
                        safe_writefile(KeyPath, tostring(KeyBox.Text))
                    end
                    waiting = false
                else
                    KeyBox.Text = ""
                    KeyBox.PlaceholderText = "Invalid Key!"
                    task.wait(0.9)
                    KeyBox.PlaceholderText = "Enter Key..."
                end
            end)

            repeat task.wait() until not waiting
            QuickTween(LoadingFrame, {BackgroundTransparency = 1}, 0.5)
            LoadingFrame.Visible = false
        end
    end

    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "Main", Parent = screenGui, Size = UDim2.new(0, 720, 0, 480),
        Position = UDim2.new(0.5, -360, 0.5, -240), BackgroundColor3 = ThemeManager.current.Main, ClipsDescendants = true
    })
    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 12) })
    Create("UIStroke", { Parent = MainFrame, Color = ThemeManager.current.Secondary, Thickness = 2, Transparency = 0.15 })

    -- Topbar
    local Topbar = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(1,0,0,48), BackgroundColor3 = ThemeManager.current.Secondary
    })
    Create("UICorner", { Parent = Topbar, CornerRadius = UDim.new(0, 12) })
    local Title = Create("TextLabel", {
        Parent = Topbar, Text = settings.Name, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text,
        Font = Enum.Font.GothamBold, TextSize = 18, Position = UDim2.new(0, 16, 0, 0), Size = UDim2.new(0.7,0,1,0), TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Control buttons (minimize, close)
    local BtnContainer = Create("Frame", { Parent = Topbar, Size = UDim2.new(0, 120, 1,0), Position = UDim2.new(1, -130, 0, 0), BackgroundTransparency = 1 })
    Create("UIListLayout", { Parent = BtnContainer, FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8) })
    Create("UIPadding", { Parent = BtnContainer, PaddingRight = UDim.new(0, 12) })

    local function makeTopBtn(icon, color)
        local b = Create("TextButton", { Parent = BtnContainer, Size = UDim2.new(0, 28, 0, 28), BackgroundColor3 = color or ThemeManager.current.Main, AutoButtonColor = false })
        Create("UICorner", { Parent = b, CornerRadius = UDim.new(0, 8) })
        local img = Create("ImageLabel", { Parent = b, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0.5, -8, 0.5, -8), BackgroundTransparency = 1 })
        if icon and #icon > 0 then pcall(function() img.Image = icon end) end
        return b
    end

    local minimized = false
    local oldSize = MainFrame.Size

    local MinBtn = makeTopBtn("rbxassetid://6034824579", ThemeManager.current.Accent)
    local CloseBtn = makeTopBtn("rbxassetid://6031094678", Color3.fromRGB(220, 60, 60))

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            oldSize = MainFrame.Size
            QuickTween(MainFrame, {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 48)}, 0.18)
            task.delay(0.18, function()
                safeSetVisible(MainFrame:GetChildren(), false)
                if Topbar and Topbar.Parent then Topbar.Visible = true end
            end)
        else
            QuickTween(MainFrame, {Size = oldSize}, 0.22)
            task.delay(0.22, function() safeSetVisible(MainFrame:GetChildren(), true) end)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        -- confirmation modal
        local modal = Create("Frame", { Parent = screenGui, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.45, ZIndex = 99999 })
        local card = Create("Frame", { Parent = modal, Size = UDim2.new(0, 360, 0, 160), Position = UDim2.new(0.5, -180, 0.5, -80), BackgroundColor3 = ThemeManager.current.Main })
        Create("UICorner", { Parent = card, CornerRadius = UDim.new(0, 10) })
        Create("TextLabel", { Parent = card, Size = UDim2.new(1,0,0,56), Text = "Close UI?", BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.GothamBold, TextSize = 18 })

        local yes = Create("TextButton", { Parent = card, Size = UDim2.new(0, 120, 0, 38), Position = UDim2.new(0.5, -60, 1, -52), BackgroundColor3 = Color3.fromRGB(220,60,60), Text = "Yes", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham })
        Create("UICorner", { Parent = yes, CornerRadius = UDim.new(0,8) })
        local no = Create("TextButton", { Parent = card, Size = UDim2.new(0, 120, 0, 38), Position = UDim2.new(0.5, 10, 1, -52), BackgroundColor3 = ThemeManager.current.Secondary, Text = "Cancel", TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham })
        Create("UICorner", { Parent = no, CornerRadius = UDim.new(0,8) })

        yes.MouseButton1Click:Connect(function()
            pcall(function() screenGui:Destroy() end)
        end)
        no.MouseButton1Click:Connect(function() modal:Destroy() end)
    end)

    -- Make draggable & resizable
    MakeDraggable(Topbar, MainFrame)
    local Resizer = Create("TextButton", { Parent = MainFrame, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -20, 1, -20), BackgroundTransparency = 1 })
    MakeResizable(Resizer, MainFrame, Vector2.new(320, 210))

    -- Layout: Tabs and Content
    local TabContainer = Create("ScrollingFrame", { Parent = MainFrame, Size = UDim2.new(0, 160, 1, -68), Position = UDim2.new(0, 12, 0, 56), BackgroundTransparency = 1, ScrollBarThickness = 6 })
    Create("UIListLayout", { Parent = TabContainer, Padding = UDim.new(0, 8) })
    local ContentContainer = Create("Frame", { Parent = MainFrame, Size = UDim2.new(1, -196, 1, -68), Position = UDim2.new(0, 180, 0, 56), BackgroundTransparency = 1 })
    Create("UIListLayout", { Parent = ContentContainer, SortOrder = Enum.SortOrder.LayoutOrder })

    -- Theme-subscribe core visuals
    ThemeManager:Subscribe(MainFrame, "BackgroundColor3", "Main")
    ThemeManager:Subscribe(Topbar, "BackgroundColor3", "Secondary")
    ThemeManager:Subscribe(Title, "TextColor3", "Text")

    -- UI storage for theme updating of created elements
    local UIStorage = {}
    local function AddToTheme(obj, prop, key, transform)
        ThemeManager:Subscribe(obj, prop, key, transform)
        table.insert(UIStorage, { Obj = obj, Prop = prop, Key = key, Transform = transform })
    end

    -- Config persistence helpers
    local function SaveConfigDebounced()
        local path = settings.Folder .. "/" .. settings.ConfigName .. ".json"
        if Library._saveDebounces[path] then
            Library._saveDebounces[path]:Cancel()
        end
        -- simple debounce: schedule write after 0.6s
        local cancelled = false
        local handle = {}
        function handle:Cancel() cancelled = true end
        Library._saveDebounces[path] = handle
        task.delay(0.6, function()
            if cancelled then return end
            local encoded = Serializer.encodeTable(Library.Flags)
            local ok, json = pcall(function() return HttpService:JSONEncode(encoded) end)
            if ok then
                safe_writefile(path, json)
            else
                warn("[ModernUI] Failed to encode config:", json)
            end
            Library._saveDebounces[path] = nil
        end)
    end

    local function SaveConfigImmediate()
        local path = settings.Folder .. "/" .. settings.ConfigName .. ".json"
        local encoded = Serializer.encodeTable(Library.Flags)
        local ok, json = pcall(function() return HttpService:JSONEncode(encoded) end)
        if ok then
            safe_writefile(path, json)
        else
            warn("[ModernUI] Failed to encode config:", json)
        end
    end

    local function LoadConfig()
        local path = settings.Folder .. "/" .. settings.ConfigName .. ".json"
        if safe_isfile(path) then
            local raw = safe_readfile(path)
            if raw then
                local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and decoded then
                    local decodedTable = Serializer.decodeTable(decoded)
                    -- merge into Library.Flags but don't overwrite keys that are nil in file
                    for k, v in pairs(decodedTable) do Library.Flags[k] = v end
                    return true
                end
            end
        end
        return false
    end

    -- attempt load
    pcall(LoadConfig)

    -- Window API
    local Window = {}
    Window.__index = Window
    Window._tabFirst = true
    Window._tabs = {}
    Window._components = {} -- for cleanup

    function Window:CreateTab(name)
        local tab = {}
        tab.Name = name

        local btn = Create("TextButton", { Parent = TabContainer, Size = UDim2.new(1,0,0,40), BackgroundColor3 = (Window._tabFirst and ThemeManager.current.Accent or ThemeManager.current.Secondary), Text = name, TextColor3 = (Window._tabFirst and Color3.new(1,1,1) or ThemeManager.current.Text), Font = Enum.Font.Gotham, TextSize = 16 })
        Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0,8) })
        AddToTheme(btn, "BackgroundColor3", Window._tabFirst and "Accent" or "Secondary")
        AddToTheme(btn, "TextColor3", "Text")

        local content = Create("ScrollingFrame", { Parent = ContentContainer, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = Window._tabFirst, ScrollBarThickness = 6 })
        Create("UIListLayout", { Parent = content, Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder })
        Create("UIPadding", { Parent = content, PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,8) })

        -- tab switch logic
        btn.MouseButton1Click:Connect(function()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    QuickTween(child, {BackgroundColor3 = ThemeManager.current.Secondary}, 0.15)
                    pcall(function() child.TextColor3 = ThemeManager.current.Text end)
                end
            end
            for _, c in pairs(ContentContainer:GetChildren()) do pcall(function() c.Visible = false end) end
            QuickTween(btn, {BackgroundColor3 = ThemeManager.current.Accent}, 0.18)
            pcall(function() btn.TextColor3 = Color3.new(1,1,1) end)
            content.Visible = true
        end)

        Window._tabFirst = false

        -- Section factory
        function tab:CreateSection(sectionName)
            local section = {}
            local SecFrame = Create("Frame", { Parent = content, Size = UDim2.new(1,0,0,36), BackgroundColor3 = ThemeManager.current.Secondary })
            Create("UICorner", { Parent = SecFrame, CornerRadius = UDim.new(0,8) })
            AddToTheme(SecFrame, "BackgroundColor3", "Secondary")
            local SecLabel = Create("TextLabel", { Parent = SecFrame, Text = sectionName, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Accent, Font = Enum.Font.GothamBold, TextSize = 14, Position = UDim2.new(0,12,0,6) })
            AddToTheme(SecLabel, "TextColor3", "Accent")

            local Container = Create("Frame", { Parent = SecFrame, Size = UDim2.new(1,-16,0,0), Position = UDim2.new(0,8,0,28), BackgroundTransparency = 1 })
            local layout = Create("UIListLayout", { Parent = Container, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder })
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local h = layout.AbsoluteContentSize.Y
                Container.Size = UDim2.new(1,-16,0,h)
                SecFrame.Size = UDim2.new(1,0,0,h + 34)
            end)

            -- central component creation helpers (return component for API)
            -- 1) Button
            function section:CreateButton(text, callback)
                callback = callback or function() end
                local btn = Create("TextButton", { Parent = Container, Size = UDim2.new(1,0,0,38), BackgroundColor3 = ThemeManager.current.Main, Text = text, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14 })
                Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0,8) })
                AddToTheme(btn, "BackgroundColor3", "Main")
                AddToTheme(btn, "TextColor3", "Text")

                -- ripple effect (simple)
                btn.MouseButton1Click:Connect(function()
                    QuickTween(btn, {Size = UDim2.new(0.98,0,0,38)}, 0.06)
                    task.wait(0.06)
                    QuickTween(btn, {Size = UDim2.new(1,0,0,38)}, 0.08)
                    pcall(callback)
                end)
                return btn
            end

            -- 2) Toggle
            function section:CreateToggle(text, flagName, callback)
                callback = callback or function() end
                flagName = flagName or text
                local initial = Library.Flags[flagName]
                if initial == nil then initial = false end
                local frame = Create("Frame", { Parent = Container, Size = UDim2.new(1,0,0,36), BackgroundColor3 = ThemeManager.current.Main })
                Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0,8) })
                AddToTheme(frame, "BackgroundColor3", "Main")
                local label = Create("TextLabel", { Parent = frame, Text = text, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(0,12,0,6) })
                AddToTheme(label, "TextColor3", "Text")

                local toggleBg = Create("Frame", { Parent = frame, Size = UDim2.new(0,44,0,22), Position = UDim2.new(1,-58,0.5,-11), BackgroundColor3 = initial and ThemeManager.current.Accent or Color3.fromRGB(80,80,80) })
                Create("UICorner", { Parent = toggleBg, CornerRadius = UDim.new(1,0) })
                AddToTheme(toggleBg, "BackgroundColor3", "Accent", function(v) return initial and v or Color3.fromRGB(80,80,80) end)
                local knob = Create("Frame", { Parent = toggleBg, Size = UDim2.new(0,16,0,16), Position = initial and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,6,0.5,-8), BackgroundColor3 = Color3.new(1,1,1) })
                Create("UICorner", { Parent = knob, CornerRadius = UDim.new(1,0) })

                local toggled = initial
                local function update()
                    Library.Flags[flagName] = toggled
                    QuickTween(knob, {Position = toggled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,6,0.5,-8)}, 0.18)
                    QuickTween(toggleBg, {BackgroundColor3 = toggled and ThemeManager.current.Accent or Color3.fromRGB(80,80,80)}, 0.18)
                    pcall(callback, toggled)
                    SaveConfigDebounced()
                end

                -- init
                if toggled then pcall(callback, toggled) end

                frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggled = not toggled
                        update()
                    end
                end)

                -- store component for cleanup
                table.insert(Window._components, { Instance = frame })
                return {
                    Frame = frame,
                    Get = function() return toggled end,
                    Set = function(val) toggled = val update() end
                }
            end

            -- 3) Slider
            function section:CreateSlider(text, flagName, min, max, default, callback)
                callback = callback or function() end
                flagName = flagName or text
                min = min or 0
                max = max or 100
                if max == min then max = min + 1 end -- avoid division by zero
                local value = Library.Flags[flagName] or default or min

                local frame = Create("Frame", { Parent = Container, Size = UDim2.new(1,0,0,56), BackgroundColor3 = ThemeManager.current.Main })
                Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0,8) })
                AddToTheme(frame, "BackgroundColor3", "Main")
                local label = Create("TextLabel", { Parent = frame, Text = text, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(0,12,0,6) })
                AddToTheme(label, "TextColor3", "Text")
                local valLabel = Create("TextLabel", { Parent = frame, Text = tostring(value), BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(1,-72,0,6), Size = UDim2.new(0,60,0,20), TextXAlignment = Enum.TextXAlignment.Right })
                AddToTheme(valLabel, "TextColor3", "Text")

                local track = Create("Frame", { Parent = frame, Size = UDim2.new(1,-24,0,10), Position = UDim2.new(0,12,0,36), BackgroundColor3 = Color3.fromRGB(65,65,65) })
                Create("UICorner", { Parent = track, CornerRadius = UDim.new(1,0) })
                local fill = Create("Frame", { Parent = track, Size = UDim2.new(math.clamp((value - min) / (max - min), 0, 1),0,1,0), BackgroundColor3 = ThemeManager.current.Accent })
                Create("UICorner", { Parent = fill, CornerRadius = UDim.new(1,0) })
                AddToTheme(fill, "BackgroundColor3", "Accent")

                local dragging = false
                local function move(input)
                    local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    local val = math.floor(min + ((max - min) * rel))
                    valLabel.Text = tostring(val)
                    value = val
                    Library.Flags[flagName] = value
                    pcall(callback, value)
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        move(input)
                    end
                end)
                local connChanged = UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        move(input)
                    end
                end)
                local connEnd = UserInputService.InputEnded:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        SaveConfigDebounced()
                    end
                end)

                table.insert(Window._components, { Instance = frame, Connections = { connChanged, connEnd } })
                -- init callback
                if value ~= default then pcall(callback, value) end

                return {
                    Frame = frame,
                    Get = function() return value end,
                    Set = function(v) value = math.clamp(v, min, max) fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0) valLabel.Text = tostring(value) Library.Flags[flagName] = value SaveConfigDebounced() end
                }
            end

            -- 4) Dropdown
            function section:CreateDropdown(text, flagName, options, callback)
                callback = callback or function() end
                flagName = flagName or text
                options = options or {}
                local current = Library.Flags[flagName] or options[1]
                local open = false

                local frame = Create("Frame", { Parent = Container, Size = UDim2.new(1,0,0,36), BackgroundColor3 = ThemeManager.current.Main, ClipsDescendants = true })
                Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0,8) })
                AddToTheme(frame, "BackgroundColor3", "Main")
                local label = Create("TextLabel", { Parent = frame, Text = (text .. ": " .. tostring(current)), BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(0,12,0,6) })
                AddToTheme(label, "TextColor3", "Text")
                local arrow = Create("ImageLabel", { Parent = frame, Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-32,0,10), BackgroundTransparency = 1 })
                pcall(function() arrow.Image = "rbxassetid://6034818372" end)
                AddToTheme(arrow, "ImageColor3", "Text")
                local btn = Create("TextButton", { Parent = frame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "" })

                local container = Create("Frame", { Parent = frame, Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,36), BackgroundTransparency = 1 })
                local listLayout = Create("UIListLayout", { Parent = container })

                local function refresh()
                    for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, opt in ipairs(options) do
                        local b = Create("TextButton", { Parent = container, Size = UDim2.new(1,0,0,34), BackgroundColor3 = ThemeManager.current.Secondary, Text = opt, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14 })
                        Create("UICorner", { Parent = b, CornerRadius = UDim.new(0,6) })
                        AddToTheme(b, "BackgroundColor3", "Secondary")
                        AddToTheme(b, "TextColor3", "Text")
                        b.MouseButton1Click:Connect(function()
                            current = opt
                            label.Text = (text .. ": " .. tostring(current))
                            Library.Flags[flagName] = current
                            pcall(callback, current)
                            SaveConfigDebounced()
                            open = false
                            QuickTween(frame, {Size = UDim2.new(1,0,0,36)}, 0.18)
                            QuickTween(arrow, {Rotation = 0}, 0.18)
                        end)
                    end
                end

                refresh()

                btn.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        local height = math.min(#options * 34, 240)
                        QuickTween(frame, {Size = UDim2.new(1,0,0,36 + height)}, 0.18)
                        QuickTween(arrow, {Rotation = 180}, 0.18)
                    else
                        QuickTween(frame, {Size = UDim2.new(1,0,0,36)}, 0.18)
                        QuickTween(arrow, {Rotation = 0}, 0.18)
                    end
                end)

                table.insert(Window._components, { Instance = frame })
                return {
                    Frame = frame,
                    UpdateOptions = function(newOptions) options = newOptions refresh() end,
                    Get = function() return current end,
                    Set = function(v) current = v label.Text = (text .. ": " .. tostring(current)) Library.Flags[flagName] = current SaveConfigDebounced() end
                }
            end

            -- 5) Textbox
            function section:CreateTextbox(text, flagName, placeholder, callback)
                callback = callback or function() end
                flagName = flagName or text
                local frame = Create("Frame", { Parent = Container, Size = UDim2.new(1,0,0,36), BackgroundColor3 = ThemeManager.current.Main })
                Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0,8) })
                AddToTheme(frame, "BackgroundColor3", "Main")

                local label = Create("TextLabel", { Parent = frame, Text = text, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(0,12,0,6) })
                AddToTheme(label, "TextColor3", "Text")

                local box = Create("TextBox", { Parent = frame, Size = UDim2.new(0,240,0,26), Position = UDim2.new(1,-260,0,5), BackgroundColor3 = ThemeManager.current.Secondary, Text = Library.Flags[flagName] or "", PlaceholderText = placeholder or "Type...", TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14 })
                Create("UICorner", { Parent = box, CornerRadius = UDim.new(0,6) })
                AddToTheme(box, "BackgroundColor3", "Secondary")
                AddToTheme(box, "TextColor3", "Text")

                box.FocusLost:Connect(function(enterPressed)
                    Library.Flags[flagName] = box.Text
                    pcall(callback, box.Text)
                    SaveConfigDebounced()
                end)

                table.insert(Window._components, { Instance = frame })
                return {
                    Frame = frame,
                    Get = function() return box.Text end,
                    Set = function(v) box.Text = tostring(v) Library.Flags[flagName] = box.Text SaveConfigDebounced() end
                }
            end

            -- 6) Keybind
            function section:CreateKeybind(text, flagName, defaultKey, callback)
                callback = callback or function() end
                flagName = flagName or text
                local currentKey = Library.Flags[flagName] or defaultKey or Enum.KeyCode.E

                local frame = Create("Frame", { Parent = Container, Size = UDim2.new(1,0,0,36), BackgroundColor3 = ThemeManager.current.Main })
                Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0,8) })
                AddToTheme(frame, "BackgroundColor3", "Main")
                local label = Create("TextLabel", { Parent = frame, Text = text, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(0,12,0,6) })
                AddToTheme(label, "TextColor3", "Text")

                local keyBtn = Create("TextButton", { Parent = frame, Size = UDim2.new(0,120,0,26), Position = UDim2.new(1,-140,0,5), BackgroundColor3 = ThemeManager.current.Secondary, Text = tostring(currentKey):gsub("Enum.KeyCode.", ""), TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14 })
                Create("UICorner", { Parent = keyBtn, CornerRadius = UDim.new(0,6) })
                AddToTheme(keyBtn, "BackgroundColor3", "Secondary")
                AddToTheme(keyBtn, "TextColor3", "Text")

                local listening = false
                local handlerId = nil

                local function beginListen()
                    listening = true
                    keyBtn.Text = "..."
                    handlerId = InputManager:Register({
                        onBegin = function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                currentKey = input.KeyCode
                                keyBtn.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
                                Library.Flags[flagName] = currentKey
                                pcall(callback, currentKey)
                                listening = false
                                InputManager:Unregister(handlerId)
                                SaveConfigDebounced()
                            end
                        end
                    })
                end

                keyBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    beginListen()
                end)

                -- runtime hotkey activation (non-listening)
                local runtimeHandler = InputManager:Register({
                    onBegin = function(input, processed)
                        if (not listening) and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                            pcall(callback, currentKey)
                        end
                    end
                })

                table.insert(Window._components, { Instance = frame, OnDestroy = function() InputManager:Unregister(runtimeHandler) end })
                return {
                    Frame = frame,
                    Get = function() return currentKey end,
                    Set = function(k) currentKey = k keyBtn.Text = tostring(k):gsub("Enum.KeyCode.", "") Library.Flags[flagName] = currentKey SaveConfigDebounced() end
                }
            end

            -- 7) Label
            function section:CreateLabel(text)
                local lab = Create("TextLabel", { Parent = Container, Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, Text = text, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14 })
                AddToTheme(lab, "TextColor3", "Text")
                table.insert(Window._components, { Instance = lab })
                return lab
            end

            -- 8) ColorPicker (hue slider simplified)
            function section:CreateColorPicker(text, flagName, defaultColor, callback)
                callback = callback or function() end
                flagName = flagName or text
                local current = Library.Flags[flagName] or defaultColor or Color3.new(1,1,1)
                local frame = Create("Frame", { Parent = Container, Size = UDim2.new(1,0,0,72), BackgroundColor3 = ThemeManager.current.Main })
                Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0,8) })
                AddToTheme(frame, "BackgroundColor3", "Main")
                local label = Create("TextLabel", { Parent = frame, Text = text, BackgroundTransparency = 1, TextColor3 = ThemeManager.current.Text, Font = Enum.Font.Gotham, TextSize = 14, Position = UDim2.new(0,12,0,6) })
                AddToTheme(label, "TextColor3", "Text")
                local preview = Create("Frame", { Parent = frame, Size = UDim2.new(0,42,0,26), Position = UDim2.new(1,-60,0,6), BackgroundColor3 = current })
                Create("UICorner", { Parent = preview, CornerRadius = UDim.new(0,6) })

                local hue = Create("Frame", { Parent = frame, Size = UDim2.new(1,-24,0,12), Position = UDim2.new(0,12,0,40), BackgroundColor3 = Color3.new(1,1,1) })
                Create("UIGradient", { Parent = hue, Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
                    ColorSequenceKeypoint.new(0.17, Color3.new(1,1,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.new(0,1,0)),
                    ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
                    ColorSequenceKeypoint.new(0.67, Color3.new(0,0,1)),
                    ColorSequenceKeypoint.new(0.83, Color3.new(1,0,1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
                }) })
                Create("UICorner", { Parent = hue, CornerRadius = UDim.new(1,0) })
                local knob = Create("Frame", { Parent = hue, Size = UDim2.new(0,10,0,18), Position = UDim2.new(0, -5, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1) })
                Create("UICorner", { Parent = knob, CornerRadius = UDim.new(1,0) })

                local dragging = false
                local function updateColor(pos)
                    knob.Position = UDim2.new(pos, -5, 0.5, -9)
                    current = Color3.fromHSV(pos, 1, 1)
                    preview.BackgroundColor3 = current
                    Library.Flags[flagName] = { current.R, current.G, current.B }
                    pcall(callback, current)
                    SaveConfigDebounced()
                end

                hue.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local pos = math.clamp((input.Position.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 1)
                        updateColor(pos)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = math.clamp((input.Position.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 1)
                        updateColor(pos)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                table.insert(Window._components, { Instance = frame })
                return {
                    Frame = frame,
                    Get = function() return current end,
                    Set = function(c) current = c preview.BackgroundColor3 = c Library.Flags[flagName] = { c.R, c.G, c.B } SaveConfigDebounced() end
                }
            end

            return section
        end

        -- store tab metadata
        Window._tabs[name] = { Button = btn, Content = content }
        return tab
    end

    function Window:AddConfigTab()
        local cfgTab = Window:CreateTab("Config")
        local cfgSec = cfgTab:CreateSection("Theme & Config")
        local names = ThemeManager:GetThemeNames()
        local dd = cfgSec:CreateDropdown("Select Theme", "ThemeConfig", names, function(val)
            if ThemeManager:ApplyTheme(val) then SaveConfigDebounced() end
        end)
        -- make sure dropdown shows current theme
        dd:Set(settings.Theme)

        cfgSec:CreateButton("Force Save Config", function()
            SaveConfigImmediate()
        end)
        cfgSec:CreateLabel("Auto-saving is enabled (debounced). Config path: " .. settings.Folder .. "/" .. settings.ConfigName .. ".json")
    end

    -- expose public API
    local PublicWindow = {}
    function PublicWindow:CreateTab(name) return Window:CreateTab(name) end
    function PublicWindow:AddConfig() return Window:AddConfigTab() end
    function PublicWindow:Save() SaveConfigImmediate() end
    function PublicWindow:Destroy()
        -- cleanup components
        for _,comp in ipairs(Window._components) do
            if comp.Connections then
                for _,c in ipairs(comp.Connections) do if c and c.Disconnect then pcall(function() c:Disconnect() end) end end
            end
            if comp.OnDestroy then pcall(comp.OnDestroy) end
            if comp.Instance and comp.Instance.Parent then pcall(function() comp.Instance:Destroy() end) end
        end
        if screenGui and screenGui.Parent then pcall(function() screenGui:Destroy() end) end
    end

    -- Save window reference
    table.insert(Library._windows, PublicWindow)

    -- apply initial theme values to dynamic controls (subscribe done on creation)
    return PublicWindow
end

-- Library-level helpers
function Library:SaveAll()
    local path = DEFAULT_SETTINGS.Folder .. "/" .. DEFAULT_SETTINGS.ConfigName .. ".json"
    local encoded = Serializer.encodeTable(self.Flags)
    local ok, json = pcall(function() return HttpService:JSONEncode(encoded) end)
    if ok then safe_writefile(path, json) end
end

-- return the module
return Library
