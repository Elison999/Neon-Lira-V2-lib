--[[
    ╔══════════════════════════════════════════════════════╗
    ║           ModernUI Library - Roblox                  ║
    ║   Draggable | Resizable | Minimizable | 12 Elements  ║
    ║   Mobile Touch Support | Compact (1.5x smaller)      ║
    ╚══════════════════════════════════════════════════════╝

    ELEMENTOS: Button, Toggle, Slider, Dropdown, TextBox,
               ColorPicker, Keybind, Label, Paragraph,
               Separator, ProgressBar, MultiDropdown
]]

local Library = {}
Library.__index = Library

-- ══ Services ══
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ══ Theme ══
local T = {
    Bg          = Color3.fromRGB(12, 12, 18),
    Secondary   = Color3.fromRGB(18, 18, 26),
    Tertiary    = Color3.fromRGB(24, 24, 34),
    Accent      = Color3.fromRGB(90, 140, 255),
    AccentDark  = Color3.fromRGB(55, 95, 200),
    AccentGlow  = Color3.fromRGB(110, 160, 255),
    Text        = Color3.fromRGB(235, 235, 250),
    TextMuted   = Color3.fromRGB(130, 130, 155),
    Border      = Color3.fromRGB(35, 35, 50),
    BorderLight = Color3.fromRGB(50, 50, 70),
    Section     = Color3.fromRGB(20, 20, 30),
    Element     = Color3.fromRGB(28, 28, 40),
    ElementHov  = Color3.fromRGB(36, 36, 52),
    Input       = Color3.fromRGB(22, 22, 32),
    SliderBar   = Color3.fromRGB(30, 30, 44),
    ToggleOn    = Color3.fromRGB(90, 140, 255),
    ToggleOff   = Color3.fromRGB(44, 44, 60),
    Green       = Color3.fromRGB(80, 200, 120),
    Red         = Color3.fromRGB(220, 80, 80),
}

-- ══ Utilities ══
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out
        ), props):Play()
end

local function Corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color     = color or T.Border
    s.Thickness = thick or 1
    s.Parent    = parent
    return s
end

local function Gradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 0
    g.Parent   = parent
    return g
end

local function Shadow(frame, size, alpha)
    local s = Instance.new("ImageLabel")
    s.Name               = "Shadow"
    s.AnchorPoint        = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position           = UDim2.new(0.5, 0, 0.5, 4)
    s.Size               = UDim2.new(1, size or 20, 1, size or 20)
    s.ZIndex             = frame.ZIndex - 1
    s.Image              = "rbxassetid://6015897843"
    s.ImageColor3        = Color3.new(0, 0, 0)
    s.ImageTransparency  = alpha or 0.45
    s.ScaleType          = Enum.ScaleType.Slice
    s.SliceCenter        = Rect.new(49, 49, 450, 450)
    s.Parent             = frame
    return s
end

-- ══ Touch/Mouse unified helpers ══
local function isTouch(inp)
    return inp.UserInputType == Enum.UserInputType.Touch
end
local function isMouse1(inp)
    return inp.UserInputType == Enum.UserInputType.MouseButton1
end
local function isDragInput(inp)
    return inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch
end

-- ══ Create Window ══
-- Original 580x420 → /1.5 = 387x280
function Library.new(title, subtitle)
    local self = setmetatable({}, Library)
    self.Tabs      = {}
    self.ActiveTab = nil
    self.Minimized = false

    -- ── ScreenGui ──
    local gui = Instance.new("ScreenGui")
    gui.Name           = "ModernUILibrary_" .. math.random(1000, 9999)
    gui.ResetOnSpawn   = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder   = 999
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = gui

    -- ── Main Window Frame ──
    local win = Instance.new("Frame")
    win.Name              = "Window"
    win.Size              = UDim2.new(0, 387, 0, 280)
    win.Position          = UDim2.new(0.5, -194, 0.5, -140)
    win.BackgroundColor3  = T.Bg
    win.BorderSizePixel   = 0
    win.ClipsDescendants  = true
    win.Parent            = gui
    Corner(win, 7)
    Stroke(win, T.Border, 1)
    Shadow(win, 27, 0.35)
    self.Window = win

    -- ── Title Bar ── (40→27)
    local titleBar = Instance.new("Frame")
    titleBar.Name             = "TitleBar"
    titleBar.Size             = UDim2.new(1, 0, 0, 27)
    titleBar.BackgroundColor3 = T.Secondary
    titleBar.BorderSizePixel  = 0
    titleBar.ZIndex           = 2
    titleBar.Parent           = win
    Corner(titleBar, 7)
    local fix = Instance.new("Frame")
    fix.Size             = UDim2.new(1, 0, 0, 7)
    fix.Position         = UDim2.new(0, 0, 1, -7)
    fix.BackgroundColor3 = T.Secondary
    fix.BorderSizePixel  = 0
    fix.ZIndex           = 2
    fix.Parent           = titleBar

    local accentBar = Instance.new("Frame")
    accentBar.Size             = UDim2.new(1, 0, 0, 2)
    accentBar.Position         = UDim2.new(0, 0, 1, -1)
    accentBar.BackgroundColor3 = T.Accent
    accentBar.BorderSizePixel  = 0
    accentBar.ZIndex           = 3
    accentBar.Parent           = titleBar
    Gradient(accentBar,
        Color3.fromRGB(90, 140, 255),
        Color3.fromRGB(150, 90, 255), 0)

    local dot = Instance.new("Frame")
    dot.Size             = UDim2.new(0, 5, 0, 5)
    dot.Position         = UDim2.new(0, 8, 0.5, -3)
    dot.BackgroundColor3 = T.Accent
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 3
    dot.Parent           = titleBar
    Corner(dot, 3)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text                 = title or "Window"
    titleLbl.Size                 = UDim2.new(0, 200, 1, 0)
    titleLbl.Position             = UDim2.new(0, 18, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3           = T.Text
    titleLbl.Font                 = Enum.Font.GothamBold
    titleLbl.TextSize             = 9
    titleLbl.TextXAlignment       = Enum.TextXAlignment.Left
    titleLbl.ZIndex               = 3
    titleLbl.Parent               = titleBar

    if subtitle then
        local subLbl = Instance.new("TextLabel")
        subLbl.Text                 = subtitle
        subLbl.Size                 = UDim2.new(0, 150, 1, 0)
        subLbl.Position             = UDim2.new(0, 18 + 60, 0, 0)
        subLbl.BackgroundTransparency = 1
        subLbl.TextColor3           = T.TextMuted
        subLbl.Font                 = Enum.Font.Gotham
        subLbl.TextSize             = 8
        subLbl.TextXAlignment       = Enum.TextXAlignment.Left
        subLbl.ZIndex               = 3
        subLbl.Parent               = titleBar
        titleLbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
            subLbl.Position = UDim2.new(0, 18 + titleLbl.TextBounds.X + 6, 0, 0)
        end)
    end

    -- minimize button (26→17)
    local minBtn = Instance.new("TextButton")
    minBtn.Name             = "Minimize"
    minBtn.Size             = UDim2.new(0, 17, 0, 17)
    minBtn.Position         = UDim2.new(1, -22, 0.5, -9)
    minBtn.BackgroundColor3 = T.Element
    minBtn.Text             = "—"
    minBtn.TextColor3       = T.TextMuted
    minBtn.Font             = Enum.Font.GothamBold
    minBtn.TextSize         = 8
    minBtn.BorderSizePixel  = 0
    minBtn.ZIndex           = 3
    minBtn.Parent           = titleBar
    Corner(minBtn, 4)
    Stroke(minBtn, T.BorderLight, 1)

    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundColor3 = T.Accent, TextColor3 = T.Text}, 0.15)
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundColor3 = T.Element, TextColor3 = T.TextMuted}, 0.15)
    end)

    -- ── Content ──
    local content = Instance.new("Frame")
    content.Name                  = "Content"
    content.Size                  = UDim2.new(1, 0, 1, -27)
    content.Position              = UDim2.new(0, 0, 0, 27)
    content.BackgroundTransparency = 1
    content.ClipsDescendants      = true
    content.Parent                = win
    self.Content = content

    -- ── Sidebar ── (140→93)
    local sidebar = Instance.new("Frame")
    sidebar.Name             = "Sidebar"
    sidebar.Size             = UDim2.new(0, 93, 1, 0)
    sidebar.BackgroundColor3 = T.Secondary
    sidebar.BorderSizePixel  = 0
    sidebar.Parent           = content
    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size             = UDim2.new(0, 7, 1, 0)
    sidebarFix.Position         = UDim2.new(1, -7, 0, 0)
    sidebarFix.BackgroundColor3 = T.Secondary
    sidebarFix.BorderSizePixel  = 0
    sidebarFix.Parent           = sidebar

    local sideHeader = Instance.new("TextLabel")
    sideHeader.Text                 = "NAVEGAÇÃO"
    sideHeader.Size                 = UDim2.new(1, -10, 0, 19)
    sideHeader.Position             = UDim2.new(0, 7, 0, 4)
    sideHeader.BackgroundTransparency = 1
    sideHeader.TextColor3           = T.TextMuted
    sideHeader.Font                 = Enum.Font.GothamBold
    sideHeader.TextSize             = 6
    sideHeader.TextXAlignment       = Enum.TextXAlignment.Left
    sideHeader.Parent               = sidebar

    local sideDiv = Instance.new("Frame")
    sideDiv.Size             = UDim2.new(1, -10, 0, 1)
    sideDiv.Position         = UDim2.new(0, 5, 0, 23)
    sideDiv.BackgroundColor3 = T.Border
    sideDiv.BorderSizePixel  = 0
    sideDiv.Parent           = sidebar

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name                  = "TabList"
    tabScroll.Size                  = UDim2.new(1, -5, 1, -28)
    tabScroll.Position              = UDim2.new(0, 3, 0, 25)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel       = 0
    tabScroll.ScrollBarThickness    = 2
    tabScroll.ScrollBarImageColor3  = T.Accent
    tabScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    tabScroll.Parent                = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding   = UDim.new(0, 2)
    tabListLayout.Parent    = tabScroll

    local tabListPad = Instance.new("UIPadding")
    tabListPad.PaddingTop = UDim.new(0, 2)
    tabListPad.Parent     = tabScroll

    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 4)
    end)

    self.TabScroll     = tabScroll
    self.TabListLayout = tabListLayout

    -- ── Main Content Area ── (140→93)
    local mainArea = Instance.new("Frame")
    mainArea.Name             = "MainArea"
    mainArea.Size             = UDim2.new(1, -93, 1, 0)
    mainArea.Position         = UDim2.new(0, 93, 0, 0)
    mainArea.BackgroundColor3 = T.Bg
    mainArea.BorderSizePixel  = 0
    mainArea.ClipsDescendants = true
    mainArea.Parent           = content
    self.MainArea = mainArea

    -- ── Resize Handle ── (18→12)
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name             = "ResizeHandle"
    resizeHandle.Size             = UDim2.new(0, 12, 0, 12)
    resizeHandle.Position         = UDim2.new(1, -12, 1, -12)
    resizeHandle.BackgroundColor3 = T.Accent
    resizeHandle.Text             = ""
    resizeHandle.BorderSizePixel  = 0
    resizeHandle.ZIndex           = 10
    resizeHandle.Parent           = win
    Corner(resizeHandle, 3)

    local function makeLine(x, y, w, h)
        local l = Instance.new("Frame")
        l.Size             = UDim2.new(0, w, 0, h)
        l.Position         = UDim2.new(0, x, 0, y)
        l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        l.BorderSizePixel  = 0
        l.ZIndex           = 11
        l.Parent           = resizeHandle
        Corner(l, 1)
    end
    makeLine(2, 8, 7, 2)
    makeLine(2, 5, 4, 2)
    makeLine(2, 2, 2, 2)

    -- ══ DRAGGING (Mouse + Touch) ══
    local dragging, dragStart, winStart = false, nil, nil

    titleBar.InputBegan:Connect(function(inp)
        if isMouse1(inp) or isTouch(inp) then
            dragging  = true
            dragStart = inp.Position
            winStart  = win.Position
        end
    end)
    titleBar.InputEnded:Connect(function(inp)
        if isMouse1(inp) or isTouch(inp) then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and isDragInput(inp) then
            local d = inp.Position - dragStart
            win.Position = UDim2.new(
                winStart.X.Scale, winStart.X.Offset + d.X,
                winStart.Y.Scale, winStart.Y.Offset + d.Y
            )
        end
    end)

    -- ══ RESIZE (Mouse + Touch) ══
    local resizing, resizeStart, startSize = false, nil, nil
    local MIN_W, MIN_H = 280, 200

    resizeHandle.InputBegan:Connect(function(inp)
        if isMouse1(inp) or isTouch(inp) then
            resizing    = true
            resizeStart = inp.Position
            startSize   = Vector2.new(win.AbsoluteSize.X, win.AbsoluteSize.Y)
        end
    end)
    resizeHandle.InputEnded:Connect(function(inp)
        if isMouse1(inp) or isTouch(inp) then
            resizing = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if resizing and isDragInput(inp) then
            local d  = inp.Position - resizeStart
            local nw = math.max(MIN_W, startSize.X + d.X)
            local nh = math.max(MIN_H, startSize.Y + d.Y)
            win.Size = UDim2.new(0, nw, 0, nh)
        end
    end)

    -- ══ MINIMIZE (Mouse + Touch) ══
    local storedH = 280
    local function doMinimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            storedH = win.AbsoluteSize.Y
            Tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, 27)}, 0.28, Enum.EasingStyle.Quart)
            task.delay(0.1, function() content.Visible = false end)
            minBtn.Text = "+"
        else
            content.Visible = true
            Tween(win, {Size = UDim2.new(0, win.AbsoluteSize.X, 0, storedH)}, 0.28, Enum.EasingStyle.Quart)
            minBtn.Text = "—"
        end
    end
    minBtn.MouseButton1Click:Connect(doMinimize)
    minBtn.TouchTap:Connect(doMinimize)

    return self
end

-- ══ Add Tab ══
function Library:AddTab(name, icon)
    local idx = #self.Tabs + 1

    -- tab button (34→23)
    local btn = Instance.new("TextButton")
    btn.Name             = "Tab_" .. name
    btn.Size             = UDim2.new(1, 0, 0, 23)
    btn.BackgroundColor3 = T.Element
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = idx
    btn.Parent           = self.TabScroll
    Corner(btn, 5)

    local bar = Instance.new("Frame")
    bar.Size                   = UDim2.new(0, 2, 0.55, 0)
    bar.Position               = UDim2.new(0, 1, 0.225, 0)
    bar.BackgroundColor3       = T.Accent
    bar.BorderSizePixel        = 0
    bar.BackgroundTransparency = 1
    bar.Parent                 = btn
    Corner(bar, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Text                 = icon or "◈"
    iconLbl.Size                 = UDim2.new(0, 15, 1, 0)
    iconLbl.Position             = UDim2.new(0, 7, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextColor3           = T.TextMuted
    iconLbl.Font                 = Enum.Font.GothamBold
    iconLbl.TextSize             = 9
    iconLbl.Parent               = btn

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Text                 = name
    nameLbl.Size                 = UDim2.new(1, -24, 1, 0)
    nameLbl.Position             = UDim2.new(0, 23, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3           = T.TextMuted
    nameLbl.Font                 = Enum.Font.Gotham
    nameLbl.TextSize             = 9
    nameLbl.TextXAlignment       = Enum.TextXAlignment.Left
    nameLbl.Parent               = btn

    local page = Instance.new("ScrollingFrame")
    page.Name                   = "Page_" .. name
    page.Size                   = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel        = 0
    page.ScrollBarThickness     = 2
    page.ScrollBarImageColor3   = T.Accent
    page.CanvasSize             = UDim2.new(0, 0, 0, 0)
    page.Visible                = false
    page.Parent                 = self.MainArea

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding   = UDim.new(0, 4)
    pageLayout.Parent    = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingLeft   = UDim.new(0, 5)
    pagePad.PaddingRight  = UDim.new(0, 5)
    pagePad.PaddingTop    = UDim.new(0, 5)
    pagePad.PaddingBottom = UDim.new(0, 5)
    pagePad.Parent        = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
    end)

    local tabData = {
        Name   = name,
        Button = btn,
        Bar    = bar,
        Icon   = iconLbl,
        Label  = nameLbl,
        Page   = page,
    }

    btn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabData then
            Tween(btn, {BackgroundColor3 = T.ElementHov}, 0.12)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabData then
            Tween(btn, {BackgroundColor3 = T.Element}, 0.12)
        end
    end)
    btn.MouseButton1Click:Connect(function() self:_SelectTab(tabData) end)
    btn.TouchTap:Connect(function() self:_SelectTab(tabData) end)

    table.insert(self.Tabs, tabData)
    if idx == 1 then self:_SelectTab(tabData) end

    local tabAPI = { _data = tabData, _lib = self }
    function tabAPI:AddSection(sname)
        return Library._MakeSection(page, sname)
    end
    return tabAPI
end

function Library:_SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
        Tween(t.Button, {BackgroundColor3 = T.Element}, 0.15)
        Tween(t.Label,  {TextColor3 = T.TextMuted}, 0.15)
        Tween(t.Icon,   {TextColor3 = T.TextMuted}, 0.15)
        Tween(t.Bar,    {BackgroundTransparency = 1}, 0.15)
    end
    tab.Page.Visible = true
    Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(28, 45, 85)}, 0.18)
    Tween(tab.Label,  {TextColor3 = T.Accent}, 0.18)
    Tween(tab.Icon,   {TextColor3 = T.AccentGlow}, 0.18)
    Tween(tab.Bar,    {BackgroundTransparency = 0}, 0.18)
    self.ActiveTab = tab
end

-- ══ Section ══
function Library._MakeSection(parent, name)
    local section = Instance.new("Frame")
    section.Name             = "Section_" .. name
    section.Size             = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize    = Enum.AutomaticSize.Y
    section.BackgroundColor3 = T.Section
    section.BorderSizePixel  = 0
    section.Parent           = parent
    Corner(section, 5)
    Stroke(section, T.Border, 1)

    local header = Instance.new("Frame")
    header.Size                 = UDim2.new(1, 0, 0, 21)
    header.BackgroundTransparency = 1
    header.Parent               = section

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Text              = name
    headerLbl.Size              = UDim2.new(1, -10, 1, 0)
    headerLbl.Position          = UDim2.new(0, 8, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.TextColor3        = T.Text
    headerLbl.Font              = Enum.Font.GothamBold
    headerLbl.TextSize          = 8
    headerLbl.TextXAlignment    = Enum.TextXAlignment.Left
    headerLbl.Parent            = header

    local div = Instance.new("Frame")
    div.Size             = UDim2.new(1, -10, 0, 1)
    div.Position         = UDim2.new(0, 5, 0, 20)
    div.BackgroundColor3 = T.Border
    div.BorderSizePixel  = 0
    div.Parent           = section

    local holder = Instance.new("Frame")
    holder.Name                 = "Holder"
    holder.Size                 = UDim2.new(1, 0, 0, 0)
    holder.Position             = UDim2.new(0, 0, 0, 21)
    holder.AutomaticSize        = Enum.AutomaticSize.Y
    holder.BackgroundTransparency = 1
    holder.Parent               = section

    local hLayout = Instance.new("UIListLayout")
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.Padding   = UDim.new(0, 1)
    hLayout.Parent    = holder

    local hPad = Instance.new("UIPadding")
    hPad.PaddingLeft   = UDim.new(0, 4)
    hPad.PaddingRight  = UDim.new(0, 4)
    hPad.PaddingBottom = UDim.new(0, 4)
    hPad.Parent        = holder

    local S = {}

    local function BaseElem(h)
        local f = Instance.new("Frame")
        f.Size             = UDim2.new(1, 0, 0, h or 21)
        f.BackgroundColor3 = T.Element
        f.BorderSizePixel  = 0
        f.Parent           = holder
        Corner(f, 4)
        return f
    end

    local function LeftLabel(par, text, size)
        local l = Instance.new("TextLabel")
        l.Text                 = text
        l.Size                 = UDim2.new(0.55, 0, 1, 0)
        l.Position             = UDim2.new(0, 7, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3           = T.Text
        l.Font                 = Enum.Font.Gotham
        l.TextSize             = size or 9
        l.TextXAlignment       = Enum.TextXAlignment.Left
        l.Parent               = par
        return l
    end

    -- ══════════════════════════════════════
    --  1. BUTTON
    -- ══════════════════════════════════════
    function S:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(1, 0, 0, 20)
        btn.BackgroundColor3 = T.Element
        btn.Text             = ""
        btn.BorderSizePixel  = 0
        btn.Parent           = holder
        Corner(btn, 4)

        local lbl = Instance.new("TextLabel")
        lbl.Text                 = text or "Button"
        lbl.Size                 = UDim2.new(1, -10, 1, 0)
        lbl.Position             = UDim2.new(0, 5, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3           = T.Text
        lbl.Font                 = Enum.Font.Gotham
        lbl.TextSize             = 9
        lbl.TextXAlignment       = Enum.TextXAlignment.Center
        lbl.Parent               = btn

        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = T.Accent}, 0.15)
            Tween(lbl, {TextColor3 = Color3.new(1,1,1)}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = T.Element}, 0.15)
            Tween(lbl, {TextColor3 = T.Text}, 0.15)
        end)
        btn.MouseButton1Down:Connect(function()
            Tween(btn, {BackgroundColor3 = T.AccentDark}, 0.06)
        end)
        btn.MouseButton1Up:Connect(function()
            Tween(btn, {BackgroundColor3 = T.Accent}, 0.12)
            if callback then task.spawn(callback) end
        end)
        btn.TouchTap:Connect(function()
            Tween(btn, {BackgroundColor3 = T.AccentDark}, 0.06)
            task.delay(0.1, function()
                Tween(btn, {BackgroundColor3 = T.Accent}, 0.12)
            end)
            if callback then task.spawn(callback) end
        end)

        local api = {}
        function api:SetText(t) lbl.Text = t end
        return api
    end

    -- ══════════════════════════════════════
    --  2. TOGGLE
    -- ══════════════════════════════════════
    function S:AddToggle(text, default, callback)
        local val  = default or false
        local elem = BaseElem(20)
        LeftLabel(elem, text)

        local trackBg = Instance.new("Frame")
        trackBg.Size             = UDim2.new(0, 25, 0, 13)
        trackBg.Position         = UDim2.new(1, -30, 0.5, -7)
        trackBg.BackgroundColor3 = val and T.ToggleOn or T.ToggleOff
        trackBg.BorderSizePixel  = 0
        trackBg.Parent           = elem
        Corner(trackBg, 7)

        local dot = Instance.new("Frame")
        dot.Size             = UDim2.new(0, 9, 0, 9)
        dot.Position         = UDim2.new(0, val and 14 or 2, 0.5, -5)
        dot.BackgroundColor3 = Color3.new(1,1,1)
        dot.BorderSizePixel  = 0
        dot.Parent           = trackBg
        Corner(dot, 5)

        local clickArea = Instance.new("TextButton")
        clickArea.Size                 = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text                 = ""
        clickArea.Parent               = elem

        local function update(v)
            val = v
            Tween(trackBg, {BackgroundColor3 = val and T.ToggleOn or T.ToggleOff}, 0.18)
            Tween(dot, {Position = UDim2.new(0, val and 14 or 2, 0.5, -5)}, 0.18)
        end
        local function toggle()
            update(not val)
            if callback then task.spawn(callback, val) end
        end

        clickArea.MouseButton1Click:Connect(toggle)
        clickArea.TouchTap:Connect(toggle)

        local api = {}
        function api:Set(v) update(v) end
        function api:Get() return val end
        return api
    end

    -- ══════════════════════════════════════
    --  3. SLIDER
    -- ══════════════════════════════════════
    function S:AddSlider(text, min, max, default, callback)
        min = min or 0; max = max or 100
        local val  = math.clamp(default or min, min, max)
        local elem = BaseElem(31)
        LeftLabel(elem, text, 8)

        local valLbl = Instance.new("TextLabel")
        valLbl.Text                 = tostring(math.floor(val))
        valLbl.Size                 = UDim2.new(0, 30, 0, 12)
        valLbl.Position             = UDim2.new(1, -34, 0, 3)
        valLbl.BackgroundTransparency = 1
        valLbl.TextColor3           = T.Accent
        valLbl.Font                 = Enum.Font.GothamBold
        valLbl.TextSize             = 8
        valLbl.TextXAlignment       = Enum.TextXAlignment.Right
        valLbl.Parent               = elem

        local track = Instance.new("Frame")
        track.Size             = UDim2.new(1, -13, 0, 4)
        track.Position         = UDim2.new(0, 7, 0, 21)
        track.BackgroundColor3 = T.SliderBar
        track.BorderSizePixel  = 0
        track.Parent           = elem
        Corner(track, 2)

        local fill = Instance.new("Frame")
        fill.Size             = UDim2.new((val-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = T.Accent
        fill.BorderSizePixel  = 0
        fill.Parent           = track
        Corner(fill, 2)
        Gradient(fill,
            Color3.fromRGB(90,140,255),
            Color3.fromRGB(150,100,255), 0)

        local handle = Instance.new("Frame")
        handle.Size             = UDim2.new(0, 9, 0, 9)
        handle.AnchorPoint      = Vector2.new(0.5, 0.5)
        handle.Position         = UDim2.new((val-min)/(max-min), 0, 0.5, 0)
        handle.BackgroundColor3 = Color3.new(1,1,1)
        handle.BorderSizePixel  = 0
        handle.ZIndex           = 2
        handle.Parent           = track
        Corner(handle, 5)

        local sliding = false

        local function applyPos(posX)
            local rel = math.clamp(
                (posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            val = math.floor(min + rel * (max - min))
            fill.Size       = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text     = tostring(val)
            if callback then task.spawn(callback, val) end
        end

        track.InputBegan:Connect(function(inp)
            if isMouse1(inp) or isTouch(inp) then
                sliding = true
                applyPos(inp.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if sliding and isDragInput(inp) then
                applyPos(inp.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if isMouse1(inp) or isTouch(inp) then sliding = false end
        end)

        local api = {}
        function api:Set(v)
            val = math.clamp(v, min, max)
            local rel = (val-min)/(max-min)
            fill.Size       = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text     = tostring(val)
        end
        function api:Get() return val end
        return api
    end

    -- ══════════════════════════════════════
    --  4. DROPDOWN
    -- ══════════════════════════════════════
    function S:AddDropdown(text, options, default, callback)
        local val  = default or (options and options[1]) or ""
        local open = false
        options    = options or {}

        local elem = BaseElem(20)
        elem.ClipsDescendants = false
        elem.ZIndex = 6
        LeftLabel(elem, text)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size             = UDim2.new(0, 72, 0, 15)
        dropBtn.Position         = UDim2.new(1, -76, 0.5, -8)
        dropBtn.BackgroundColor3 = T.Input
        dropBtn.Text             = val
        dropBtn.TextColor3       = T.Text
        dropBtn.Font             = Enum.Font.Gotham
        dropBtn.TextSize         = 8
        dropBtn.BorderSizePixel  = 0
        dropBtn.ZIndex           = 6
        dropBtn.Parent           = elem
        Corner(dropBtn, 3)
        Stroke(dropBtn, T.BorderLight, 1)

        local arrow = Instance.new("TextLabel")
        arrow.Text                 = "▾"
        arrow.Size                 = UDim2.new(0, 12, 1, 0)
        arrow.Position             = UDim2.new(1, -12, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.TextColor3           = T.Accent
        arrow.Font                 = Enum.Font.GothamBold
        arrow.TextSize             = 8
        arrow.ZIndex               = 7
        arrow.Parent               = dropBtn

        local list = Instance.new("Frame")
        list.Size             = UDim2.new(0, 72, 0, 0)
        list.Position         = UDim2.new(1, -76, 1, 2)
        list.BackgroundColor3 = T.Secondary
        list.BorderSizePixel  = 0
        list.ClipsDescendants = true
        list.ZIndex           = 30
        list.Visible          = false
        list.Parent           = elem
        Corner(list, 3)
        Stroke(list, T.BorderLight, 1)

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent    = list

        local totalH = 0
        for _, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.Size                 = UDim2.new(1, 0, 0, 16)
            ob.BackgroundTransparency = 1
            ob.Text                 = opt
            ob.TextColor3           = T.TextMuted
            ob.Font                 = Enum.Font.Gotham
            ob.TextSize             = 8
            ob.BorderSizePixel      = 0
            ob.ZIndex               = 31
            ob.Parent               = list
            ob.MouseEnter:Connect(function()
                Tween(ob, {TextColor3 = T.Text, BackgroundTransparency = 0.88}, 0.1)
                ob.BackgroundColor3 = T.Accent
            end)
            ob.MouseLeave:Connect(function()
                Tween(ob, {TextColor3 = T.TextMuted, BackgroundTransparency = 1}, 0.1)
            end)
            local function selectOpt()
                val = opt
                dropBtn.Text = opt
                open = false
                Tween(list, {Size = UDim2.new(0, 72, 0, 0)}, 0.18)
                task.delay(0.18, function() list.Visible = false end)
                Tween(arrow, {Rotation = 0}, 0.18)
                if callback then task.spawn(callback, val) end
            end
            ob.MouseButton1Click:Connect(selectOpt)
            ob.TouchTap:Connect(selectOpt)
            totalH = totalH + 16
        end

        local function toggleDrop()
            open = not open
            if open then
                list.Visible = true
                Tween(list, {Size = UDim2.new(0, 72, 0, math.min(totalH, 85))}, 0.18)
                Tween(arrow, {Rotation = 180}, 0.18)
            else
                Tween(list, {Size = UDim2.new(0, 72, 0, 0)}, 0.18)
                task.delay(0.18, function() list.Visible = false end)
                Tween(arrow, {Rotation = 0}, 0.18)
            end
        end
        dropBtn.MouseButton1Click:Connect(toggleDrop)
        dropBtn.TouchTap:Connect(toggleDrop)

        local api = {}
        function api:Get() return val end
        function api:Set(v) val = v; dropBtn.Text = v end
        function api:GetOptions() return options end
        return api
    end

    -- ══════════════════════════════════════
    --  5. TEXTBOX
    -- ══════════════════════════════════════
    function S:AddTextBox(text, placeholder, callback)
        local elem = BaseElem(20)
        LeftLabel(elem, text)

        local inputWrap = Instance.new("Frame")
        inputWrap.Size             = UDim2.new(0, 79, 0, 15)
        inputWrap.Position         = UDim2.new(1, -83, 0.5, -8)
        inputWrap.BackgroundColor3 = T.Input
        inputWrap.BorderSizePixel  = 0
        inputWrap.Parent           = elem
        Corner(inputWrap, 3)
        Stroke(inputWrap, T.BorderLight, 1)

        local tb = Instance.new("TextBox")
        tb.Size                 = UDim2.new(1, -6, 1, 0)
        tb.Position             = UDim2.new(0, 3, 0, 0)
        tb.BackgroundTransparency = 1
        tb.Text                 = ""
        tb.PlaceholderText      = placeholder or "Type here..."
        tb.PlaceholderColor3    = T.TextMuted
        tb.TextColor3           = T.Text
        tb.Font                 = Enum.Font.Gotham
        tb.TextSize             = 8
        tb.TextXAlignment       = Enum.TextXAlignment.Left
        tb.ClearTextOnFocus     = false
        tb.Parent               = inputWrap

        tb.Focused:Connect(function()
            Tween(inputWrap, {BackgroundColor3 = T.ElementHov}, 0.12)
        end)
        tb.FocusLost:Connect(function(enter)
            Tween(inputWrap, {BackgroundColor3 = T.Input}, 0.12)
            if callback then task.spawn(callback, tb.Text, enter) end
        end)

        local api = {}
        function api:Get() return tb.Text end
        function api:Set(v) tb.Text = v end
        return api
    end

    -- ══════════════════════════════════════
    --  6. COLORPICKER
    -- ══════════════════════════════════════
    function S:AddColorPicker(text, default, callback)
        local color = default or Color3.fromRGB(100, 140, 255)
        local open  = false
        local r, g, b = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)

        local elem = BaseElem(20)
        elem.ClipsDescendants = false
        elem.ZIndex = 5
        LeftLabel(elem, text)

        local preview = Instance.new("TextButton")
        preview.Size             = UDim2.new(0, 21, 0, 15)
        preview.Position         = UDim2.new(1, -26, 0.5, -8)
        preview.BackgroundColor3 = color
        preview.Text             = ""
        preview.BorderSizePixel  = 0
        preview.ZIndex           = 5
        preview.Parent           = elem
        Corner(preview, 3)
        Stroke(preview, T.BorderLight, 1)

        local picker = Instance.new("Frame")
        picker.Size             = UDim2.new(0, 127, 0, 0)
        picker.Position         = UDim2.new(1, -132, 1, 3)
        picker.BackgroundColor3 = T.Secondary
        picker.BorderSizePixel  = 0
        picker.ClipsDescendants = true
        picker.ZIndex           = 30
        picker.Visible          = false
        picker.Parent           = elem
        Corner(picker, 5)
        Stroke(picker, T.BorderLight, 1)

        local pLayout = Instance.new("UIListLayout")
        pLayout.Padding = UDim.new(0, 3)
        pLayout.Parent  = picker

        local pPad = Instance.new("UIPadding")
        pPad.PaddingLeft   = UDim.new(0, 5)
        pPad.PaddingRight  = UDim.new(0, 5)
        pPad.PaddingTop    = UDim.new(0, 5)
        pPad.PaddingBottom = UDim.new(0, 5)
        pPad.Parent        = picker

        local function recalc()
            color = Color3.fromRGB(r, g, b)
            preview.BackgroundColor3 = color
            if callback then task.spawn(callback, color) end
        end

        local chColors = {
            R = Color3.fromRGB(220, 70, 70),
            G = Color3.fromRGB(60, 200, 80),
            B = Color3.fromRGB(80, 130, 230)
        }

        for _, ch in ipairs({"R","G","B"}) do
            local row = Instance.new("Frame")
            row.Size                 = UDim2.new(1, 0, 0, 15)
            row.BackgroundTransparency = 1
            row.ZIndex               = 31
            row.Parent               = picker

            local chLbl = Instance.new("TextLabel")
            chLbl.Text                 = ch
            chLbl.Size                 = UDim2.new(0, 8, 1, 0)
            chLbl.BackgroundTransparency = 1
            chLbl.TextColor3           = chColors[ch]
            chLbl.Font                 = Enum.Font.GothamBold
            chLbl.TextSize             = 8
            chLbl.ZIndex               = 31
            chLbl.Parent               = row

            local trackBg = Instance.new("Frame")
            trackBg.Size             = UDim2.new(1, -34, 0, 4)
            trackBg.Position         = UDim2.new(0, 11, 0.5, -2)
            trackBg.BackgroundColor3 = T.SliderBar
            trackBg.BorderSizePixel  = 0
            trackBg.ZIndex           = 31
            trackBg.Parent           = row
            Corner(trackBg, 2)

            local cval = ch == "R" and r or ch == "G" and g or b

            local tFill = Instance.new("Frame")
            tFill.Size             = UDim2.new(cval/255, 0, 1, 0)
            tFill.BackgroundColor3 = chColors[ch]
            tFill.BorderSizePixel  = 0
            tFill.ZIndex           = 32
            tFill.Parent           = trackBg
            Corner(tFill, 2)

            local numBox = Instance.new("TextBox")
            numBox.Size                 = UDim2.new(0, 20, 1, 0)
            numBox.Position             = UDim2.new(1, -20, 0, 0)
            numBox.BackgroundColor3     = T.Input
            numBox.Text                 = tostring(cval)
            numBox.TextColor3           = T.Text
            numBox.Font                 = Enum.Font.Gotham
            numBox.TextSize             = 7
            numBox.BorderSizePixel      = 0
            numBox.ZIndex               = 31
            numBox.Parent               = row
            Corner(numBox, 2)

            local sliding = false
            trackBg.InputBegan:Connect(function(inp)
                if isMouse1(inp) or isTouch(inp) then
                    sliding = true
                    local rel = math.clamp((inp.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X, 0, 1)
                    local v   = math.floor(rel*255)
                    tFill.Size  = UDim2.new(rel,0,1,0)
                    numBox.Text = tostring(v)
                    if ch=="R" then r=v elseif ch=="G" then g=v else b=v end
                    recalc()
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if sliding and isDragInput(inp) then
                    local rel = math.clamp((inp.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X, 0, 1)
                    local v   = math.floor(rel*255)
                    tFill.Size  = UDim2.new(rel,0,1,0)
                    numBox.Text = tostring(v)
                    if ch=="R" then r=v elseif ch=="G" then g=v else b=v end
                    recalc()
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if isMouse1(inp) or isTouch(inp) then sliding = false end
            end)
            numBox.FocusLost:Connect(function()
                local v = math.clamp(tonumber(numBox.Text) or 0, 0, 255)
                numBox.Text = tostring(v)
                tFill.Size  = UDim2.new(v/255, 0, 1, 0)
                if ch=="R" then r=v elseif ch=="G" then g=v else b=v end
                recalc()
            end)
        end

        local function togglePicker()
            open = not open
            if open then
                picker.Visible = true
                Tween(picker, {Size = UDim2.new(0, 127, 0, 69)}, 0.2)
            else
                Tween(picker, {Size = UDim2.new(0, 127, 0, 0)}, 0.18)
                task.delay(0.18, function() picker.Visible = false end)
            end
        end
        preview.MouseButton1Click:Connect(togglePicker)
        preview.TouchTap:Connect(togglePicker)

        local api = {}
        function api:Get() return color end
        function api:Set(c)
            color = c
            r,g,b = math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)
            preview.BackgroundColor3 = c
        end
        return api
    end

    -- ══════════════════════════════════════
    --  7. KEYBIND
    -- ══════════════════════════════════════
    function S:AddKeybind(text, default, callback)
        local key       = default or Enum.KeyCode.Unknown
        local listening = false
        local conn

        local elem = BaseElem(20)
        LeftLabel(elem, text)

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size             = UDim2.new(0, 45, 0, 15)
        keyBtn.Position         = UDim2.new(1, -49, 0.5, -8)
        keyBtn.BackgroundColor3 = T.Input
        keyBtn.Text             = key == Enum.KeyCode.Unknown and "NONE" or key.Name
        keyBtn.TextColor3       = T.Text
        keyBtn.Font             = Enum.Font.GothamBold
        keyBtn.TextSize         = 8
        keyBtn.BorderSizePixel  = 0
        keyBtn.Parent           = elem
        Corner(keyBtn, 3)
        Stroke(keyBtn, T.BorderLight, 1)

        local function startListen()
            if listening then return end
            listening   = true
            keyBtn.Text = "..."
            Tween(keyBtn, {BackgroundColor3 = T.Accent}, 0.15)
            conn = UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Keyboard then
                    key         = inp.KeyCode
                    keyBtn.Text = key.Name
                    listening   = false
                    Tween(keyBtn, {BackgroundColor3 = T.Input}, 0.15)
                    conn:Disconnect()
                    if callback then task.spawn(callback, key) end
                end
            end)
        end
        keyBtn.MouseButton1Click:Connect(startListen)
        keyBtn.TouchTap:Connect(startListen)

        local api = {}
        function api:Get() return key end
        function api:Set(k)
            key = k
            keyBtn.Text = k == Enum.KeyCode.Unknown and "NONE" or k.Name
        end
        return api
    end

    -- ══════════════════════════════════════
    --  8. LABEL
    -- ══════════════════════════════════════
    function S:AddLabel(text)
        local elem = Instance.new("Frame")
        elem.Size                 = UDim2.new(1, 0, 0, 17)
        elem.BackgroundTransparency = 1
        elem.BorderSizePixel      = 0
        elem.Parent               = holder

        local lbl = Instance.new("TextLabel")
        lbl.Text                 = text or ""
        lbl.Size                 = UDim2.new(1, -10, 1, 0)
        lbl.Position             = UDim2.new(0, 5, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3           = T.TextMuted
        lbl.Font                 = Enum.Font.Gotham
        lbl.TextSize             = 8
        lbl.TextXAlignment       = Enum.TextXAlignment.Left
        lbl.TextWrapped          = true
        lbl.Parent               = elem

        local api = {}
        function api:Set(t) lbl.Text = t end
        function api:Get() return lbl.Text end
        return api
    end

    -- ══════════════════════════════════════
    --  9. PARAGRAPH
    -- ══════════════════════════════════════
    function S:AddParagraph(title, body)
        local elem = Instance.new("Frame")
        elem.Size             = UDim2.new(1, 0, 0, 0)
        elem.AutomaticSize    = Enum.AutomaticSize.Y
        elem.BackgroundColor3 = T.Input
        elem.BorderSizePixel  = 0
        elem.Parent           = holder
        Corner(elem, 4)

        local inner = Instance.new("UIListLayout")
        inner.Padding = UDim.new(0, 1)
        inner.Parent  = elem
        local ipad = Instance.new("UIPadding")
        ipad.PaddingLeft   = UDim.new(0, 5)
        ipad.PaddingRight  = UDim.new(0, 5)
        ipad.PaddingTop    = UDim.new(0, 5)
        ipad.PaddingBottom = UDim.new(0, 5)
        ipad.Parent        = elem

        local tLbl = Instance.new("TextLabel")
        tLbl.Text                 = title or "Title"
        tLbl.Size                 = UDim2.new(1, 0, 0, 11)
        tLbl.BackgroundTransparency = 1
        tLbl.TextColor3           = T.Text
        tLbl.Font                 = Enum.Font.GothamBold
        tLbl.TextSize             = 8
        tLbl.TextXAlignment       = Enum.TextXAlignment.Left
        tLbl.Parent               = elem

        local bLbl = Instance.new("TextLabel")
        bLbl.Text                 = body or ""
        bLbl.Size                 = UDim2.new(1, 0, 0, 0)
        bLbl.AutomaticSize        = Enum.AutomaticSize.Y
        bLbl.BackgroundTransparency = 1
        bLbl.TextColor3           = T.TextMuted
        bLbl.Font                 = Enum.Font.Gotham
        bLbl.TextSize             = 7
        bLbl.TextXAlignment       = Enum.TextXAlignment.Left
        bLbl.TextWrapped          = true
        bLbl.Parent               = elem

        local api = {}
        function api:Set(t, bd)
            if t  then tLbl.Text = t  end
            if bd then bLbl.Text = bd end
        end
        return api
    end

    -- ══════════════════════════════════════
    --  10. SEPARATOR
    -- ══════════════════════════════════════
    function S:AddSeparator(label)
        local elem = Instance.new("Frame")
        elem.Size                 = UDim2.new(1, 0, 0, 12)
        elem.BackgroundTransparency = 1
        elem.BorderSizePixel      = 0
        elem.Parent               = holder

        if label and label ~= "" then
            local l1 = Instance.new("Frame")
            l1.Size             = UDim2.new(0.3, 0, 0, 1)
            l1.Position         = UDim2.new(0, 0, 0.5, 0)
            l1.BackgroundColor3 = T.Border
            l1.BorderSizePixel  = 0
            l1.Parent           = elem

            local txt = Instance.new("TextLabel")
            txt.Text                 = label
            txt.Size                 = UDim2.new(0.4, 0, 1, 0)
            txt.Position             = UDim2.new(0.3, 0, 0, 0)
            txt.BackgroundTransparency = 1
            txt.TextColor3           = T.TextMuted
            txt.Font                 = Enum.Font.Gotham
            txt.TextSize             = 7
            txt.Parent               = elem

            local l2 = Instance.new("Frame")
            l2.Size             = UDim2.new(0.3, 0, 0, 1)
            l2.Position         = UDim2.new(0.7, 0, 0.5, 0)
            l2.BackgroundColor3 = T.Border
            l2.BorderSizePixel  = 0
            l2.Parent           = elem
        else
            local line = Instance.new("Frame")
            line.Size             = UDim2.new(1, 0, 0, 1)
            line.Position         = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = T.Border
            line.BorderSizePixel  = 0
            line.Parent           = elem
        end
    end

    -- ══════════════════════════════════════
    --  11. PROGRESS BAR
    -- ══════════════════════════════════════
    function S:AddProgressBar(text, default)
        local val  = math.clamp(default or 0, 0, 100)
        local elem = BaseElem(31)
        LeftLabel(elem, text, 8)

        local pctLbl = Instance.new("TextLabel")
        pctLbl.Text                 = math.floor(val) .. "%"
        pctLbl.Size                 = UDim2.new(0, 30, 0, 12)
        pctLbl.Position             = UDim2.new(1, -34, 0, 3)
        pctLbl.BackgroundTransparency = 1
        pctLbl.TextColor3           = T.Accent
        pctLbl.Font                 = Enum.Font.GothamBold
        pctLbl.TextSize             = 8
        pctLbl.TextXAlignment       = Enum.TextXAlignment.Right
        pctLbl.Parent               = elem

        local barBg = Instance.new("Frame")
        barBg.Size             = UDim2.new(1, -13, 0, 5)
        barBg.Position         = UDim2.new(0, 7, 0, 20)
        barBg.BackgroundColor3 = T.SliderBar
        barBg.BorderSizePixel  = 0
        barBg.Parent           = elem
        Corner(barBg, 3)

        local barFill = Instance.new("Frame")
        barFill.Size             = UDim2.new(val/100, 0, 1, 0)
        barFill.BackgroundColor3 = T.Accent
        barFill.BorderSizePixel  = 0
        barFill.Parent           = barBg
        Corner(barFill, 3)
        Gradient(barFill,
            Color3.fromRGB(90,140,255),
            Color3.fromRGB(140,90,255), 0)

        local shine = Instance.new("Frame")
        shine.Size                   = UDim2.new(0.4, 0, 0.5, 0)
        shine.BackgroundColor3       = Color3.new(1,1,1)
        shine.BackgroundTransparency = 0.75
        shine.BorderSizePixel        = 0
        shine.Parent                 = barFill
        Corner(shine, 3)

        local api = {}
        function api:Set(v)
            val = math.clamp(v, 0, 100)
            Tween(barFill, {Size = UDim2.new(val/100, 0, 1, 0)}, 0.3)
            pctLbl.Text = math.floor(val) .. "%"
        end
        function api:Get() return val end
        return api
    end

    -- ══════════════════════════════════════
    --  12. MULTI-DROPDOWN
    -- ══════════════════════════════════════
    function S:AddMultiDropdown(text, options, callback)
        local selected = {}
        local open     = false
        options        = options or {}

        local elem = BaseElem(20)
        elem.ClipsDescendants = false
        elem.ZIndex = 4
        LeftLabel(elem, text)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size             = UDim2.new(0, 72, 0, 15)
        dropBtn.Position         = UDim2.new(1, -76, 0.5, -8)
        dropBtn.BackgroundColor3 = T.Input
        dropBtn.Text             = "Select..."
        dropBtn.TextColor3       = T.TextMuted
        dropBtn.Font             = Enum.Font.Gotham
        dropBtn.TextSize         = 8
        dropBtn.BorderSizePixel  = 0
        dropBtn.ZIndex           = 4
        dropBtn.Parent           = elem
        Corner(dropBtn, 3)
        Stroke(dropBtn, T.BorderLight, 1)

        local arrow2 = Instance.new("TextLabel")
        arrow2.Text                 = "▾"
        arrow2.Size                 = UDim2.new(0, 12, 1, 0)
        arrow2.Position             = UDim2.new(1, -12, 0, 0)
        arrow2.BackgroundTransparency = 1
        arrow2.TextColor3           = T.Accent
        arrow2.Font                 = Enum.Font.GothamBold
        arrow2.TextSize             = 8
        arrow2.ZIndex               = 5
        arrow2.Parent               = dropBtn

        local list2 = Instance.new("Frame")
        list2.Size             = UDim2.new(0, 83, 0, 0)
        list2.Position         = UDim2.new(1, -87, 1, 2)
        list2.BackgroundColor3 = T.Secondary
        list2.BorderSizePixel  = 0
        list2.ClipsDescendants = true
        list2.ZIndex           = 28
        list2.Visible          = false
        list2.Parent           = elem
        Corner(list2, 3)
        Stroke(list2, T.BorderLight, 1)

        local l2Layout = Instance.new("UIListLayout")
        l2Layout.SortOrder = Enum.SortOrder.LayoutOrder
        l2Layout.Parent    = list2

        local function refreshLabel()
            local cnt = 0
            for _ in pairs(selected) do cnt = cnt + 1 end
            dropBtn.Text       = cnt == 0 and "Select..." or cnt .. " selected"
            dropBtn.TextColor3 = cnt == 0 and T.TextMuted or T.Text
        end

        local totalH2 = 0
        for _, opt in ipairs(options) do
            local row = Instance.new("Frame")
            row.Size                 = UDim2.new(1, 0, 0, 17)
            row.BackgroundTransparency = 1
            row.ZIndex               = 29
            row.Parent               = list2

            local box = Instance.new("Frame")
            box.Size             = UDim2.new(0, 9, 0, 9)
            box.Position         = UDim2.new(0, 4, 0.5, -5)
            box.BackgroundColor3 = T.SliderBar
            box.BorderSizePixel  = 0
            box.ZIndex           = 30
            box.Parent           = row
            Corner(box, 2)
            Stroke(box, T.BorderLight, 1)

            local check = Instance.new("TextLabel")
            check.Text                 = "✓"
            check.Size                 = UDim2.new(1, 0, 1, 0)
            check.BackgroundTransparency = 1
            check.TextColor3           = T.Accent
            check.Font                 = Enum.Font.GothamBold
            check.TextSize             = 7
            check.Visible              = false
            check.ZIndex               = 31
            check.Parent               = box

            local optLbl = Instance.new("TextLabel")
            optLbl.Text                 = opt
            optLbl.Size                 = UDim2.new(1, -18, 1, 0)
            optLbl.Position             = UDim2.new(0, 17, 0, 0)
            optLbl.BackgroundTransparency = 1
            optLbl.TextColor3           = T.TextMuted
            optLbl.Font                 = Enum.Font.Gotham
            optLbl.TextSize             = 8
            optLbl.TextXAlignment       = Enum.TextXAlignment.Left
            optLbl.ZIndex               = 30
            optLbl.Parent               = row

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size                 = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text                 = ""
            clickBtn.ZIndex               = 31
            clickBtn.Parent               = row

            local function toggleOpt()
                if selected[opt] then
                    selected[opt]        = nil
                    check.Visible        = false
                    box.BackgroundColor3 = T.SliderBar
                    optLbl.TextColor3    = T.TextMuted
                else
                    selected[opt]        = true
                    check.Visible        = true
                    box.BackgroundColor3 = Color3.fromRGB(25, 45, 90)
                    optLbl.TextColor3    = T.Text
                end
                refreshLabel()
                if callback then task.spawn(callback, selected) end
            end
            clickBtn.MouseButton1Click:Connect(toggleOpt)
            clickBtn.TouchTap:Connect(toggleOpt)

            totalH2 = totalH2 + 17
        end

        local function toggleMultiDrop()
            open = not open
            if open then
                list2.Visible = true
                Tween(list2, {Size = UDim2.new(0, 83, 0, math.min(totalH2, 87))}, 0.18)
                Tween(arrow2, {Rotation = 180}, 0.18)
            else
                Tween(list2, {Size = UDim2.new(0, 83, 0, 0)}, 0.18)
                task.delay(0.18, function() list2.Visible = false end)
                Tween(arrow2, {Rotation = 0}, 0.18)
            end
        end
        dropBtn.MouseButton1Click:Connect(toggleMultiDrop)
        dropBtn.TouchTap:Connect(toggleMultiDrop)

        local api = {}
        function api:Get() return selected end
        function api:Set(tbl)
            selected = tbl
            refreshLabel()
        end
        return api
    end

    return S
end

return Library

--[[
══════════════════════════════════════════════════
  EXEMPLO DE USO — cole em um LocalScript
══════════════════════════════════════════════════

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Elison999/Neon-Lira-V2-lib/refs/heads/main/Library.Lua"))()
-- OU se for módulo local: local Lib = require(script.ModernUILibrary)

local Win = Lib.new("ModernScript", "v2.0")

-- Cria tabs com ícone (emoji ou texto)
local tabMain   = Win:AddTab("Principal", "⚙")
local tabVisual = Win:AddTab("Visual",    "👁")
local tabPlayer = Win:AddTab("Player",    "👤")

-- ── Seção na tab Principal ──
local sec = tabMain:AddSection("Configurações Gerais")

sec:AddButton("Executar Script", function()
    print("Executando!")
end)

local tog = sec:AddToggle("God Mode", false, function(v)
    print("God Mode:", v)
end)

local spd = sec:AddSlider("WalkSpeed", 16, 250, 16, function(v)
    local char = game.Players.LocalPlayer.Character
    if char then char.Humanoid.WalkSpeed = v end
end)

local jmp = sec:AddSlider("JumpPower", 50, 300, 50, function(v)
    local char = game.Players.LocalPlayer.Character
    if char then char.Humanoid.JumpPower = v end
end)

local drop = sec:AddDropdown("Time", {"Vermelho","Azul","Verde"}, "Vermelho", function(v)
    print("Time:", v)
end)

local tb = sec:AddTextBox("Username", "Digite o nome...", function(v, enter)
    print("Nome:", v)
end)

sec:AddSeparator("Extras")

local cp = sec:AddColorPicker("Cor do ESP", Color3.fromRGB(100,200,100), function(c)
    print("Cor:", c)
end)

local kb = sec:AddKeybind("Toggle UI", Enum.KeyCode.RightAlt, function(k)
    print("Tecla:", k)
end)

sec:AddLabel("ModernUI Library  •  Feito para Roblox")

sec:AddParagraph("Sobre", "Esta library oferece 12 elementos modernos com animações suaves, sistema de resize e minimize.")

local prog = sec:AddProgressBar("Download", 72)
-- Para atualizar: prog:Set(100)

local multi = sec:AddMultiDropdown("Itens", {"Espada","Escudo","Poção","Armadura","Arco"}, function(sel)
    print("Selecionados:", sel)
end)

-- ── Tab Visual ──
local secVis = tabVisual:AddSection("ESP & Aimbot")
secVis:AddToggle("ESP Players", false)
secVis:AddToggle("Wallhack",    false)
secVis:AddSlider("FOV Circle",  10, 500, 120)
secVis:AddColorPicker("Cor Box", Color3.fromRGB(255, 80, 80))

-- ── Tab Player ──
local secPly = tabPlayer:AddSection("Stats do Personagem")
secPly:AddSlider("WalkSpeed",  16, 250, 16)
secPly:AddSlider("JumpPower",  50, 350, 50)
secPly:AddToggle("Fly",        false)
secPly:AddToggle("Noclip",     false)

]]
