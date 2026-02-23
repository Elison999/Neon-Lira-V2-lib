-- ╔══════════════════════════════════════════════════════════════╗
-- ║              Nova UI Library - by NovaTeam                  ║
-- ║         Modern, Clean, OOP, PC & Mobile Compatible          ║
-- ╚══════════════════════════════════════════════════════════════╝

local Nova = {
	Version     = "1.0.0",
	Flags       = {},
	Connections = {},
	ThemeObjects= {},
	Elements    = {},
	Folder      = "NovaLib",
	SaveCfg     = false,
	SelectedTheme = "Dark",
}

-- ══════════════════════════════════════════════
--  Services
-- ══════════════════════════════════════════════
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

-- ══════════════════════════════════════════════
--  Theme Definitions (15 themes)
-- ══════════════════════════════════════════════
Nova.Themes = {
	Dark = {
		Background  = Color3.fromRGB(18, 18, 24),
		Surface     = Color3.fromRGB(26, 26, 34),
		SurfaceAlt  = Color3.fromRGB(34, 34, 46),
		Accent      = Color3.fromRGB(99, 102, 241),
		AccentHover = Color3.fromRGB(118, 120, 255),
		Border      = Color3.fromRGB(55, 55, 75),
		Text        = Color3.fromRGB(230, 230, 240),
		TextDim     = Color3.fromRGB(140, 140, 160),
		Toggle      = Color3.fromRGB(99, 102, 241),
		Scrollbar   = Color3.fromRGB(99, 102, 241),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Light = {
		Background  = Color3.fromRGB(245, 245, 250),
		Surface     = Color3.fromRGB(255, 255, 255),
		SurfaceAlt  = Color3.fromRGB(235, 235, 245),
		Accent      = Color3.fromRGB(99, 102, 241),
		AccentHover = Color3.fromRGB(79, 82, 221),
		Border      = Color3.fromRGB(210, 210, 225),
		Text        = Color3.fromRGB(20, 20, 30),
		TextDim     = Color3.fromRGB(100, 100, 120),
		Toggle      = Color3.fromRGB(99, 102, 241),
		Scrollbar   = Color3.fromRGB(99, 102, 241),
		Shadow      = Color3.fromRGB(160, 160, 180),
		Success     = Color3.fromRGB(22, 163, 74),
		Error       = Color3.fromRGB(220, 38, 38),
	},
	Midnight = {
		Background  = Color3.fromRGB(8, 8, 18),
		Surface     = Color3.fromRGB(14, 14, 28),
		SurfaceAlt  = Color3.fromRGB(20, 20, 40),
		Accent      = Color3.fromRGB(139, 92, 246),
		AccentHover = Color3.fromRGB(167, 139, 250),
		Border      = Color3.fromRGB(45, 45, 70),
		Text        = Color3.fromRGB(220, 220, 240),
		TextDim     = Color3.fromRGB(120, 120, 150),
		Toggle      = Color3.fromRGB(139, 92, 246),
		Scrollbar   = Color3.fromRGB(139, 92, 246),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Ocean = {
		Background  = Color3.fromRGB(10, 20, 35),
		Surface     = Color3.fromRGB(15, 30, 52),
		SurfaceAlt  = Color3.fromRGB(22, 44, 72),
		Accent      = Color3.fromRGB(6, 182, 212),
		AccentHover = Color3.fromRGB(34, 211, 238),
		Border      = Color3.fromRGB(30, 60, 90),
		Text        = Color3.fromRGB(220, 240, 250),
		TextDim     = Color3.fromRGB(100, 150, 180),
		Toggle      = Color3.fromRGB(6, 182, 212),
		Scrollbar   = Color3.fromRGB(6, 182, 212),
		Shadow      = Color3.fromRGB(0, 5, 15),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Sunset = {
		Background  = Color3.fromRGB(25, 12, 18),
		Surface     = Color3.fromRGB(38, 18, 28),
		SurfaceAlt  = Color3.fromRGB(52, 25, 38),
		Accent      = Color3.fromRGB(249, 115, 22),
		AccentHover = Color3.fromRGB(251, 146, 60),
		Border      = Color3.fromRGB(90, 40, 60),
		Text        = Color3.fromRGB(255, 230, 220),
		TextDim     = Color3.fromRGB(180, 120, 120),
		Toggle      = Color3.fromRGB(249, 115, 22),
		Scrollbar   = Color3.fromRGB(249, 115, 22),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Forest = {
		Background  = Color3.fromRGB(10, 22, 14),
		Surface     = Color3.fromRGB(14, 32, 20),
		SurfaceAlt  = Color3.fromRGB(20, 44, 28),
		Accent      = Color3.fromRGB(34, 197, 94),
		AccentHover = Color3.fromRGB(74, 222, 128),
		Border      = Color3.fromRGB(30, 70, 40),
		Text        = Color3.fromRGB(210, 240, 220),
		TextDim     = Color3.fromRGB(100, 170, 120),
		Toggle      = Color3.fromRGB(34, 197, 94),
		Scrollbar   = Color3.fromRGB(34, 197, 94),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Rose = {
		Background  = Color3.fromRGB(25, 10, 15),
		Surface     = Color3.fromRGB(38, 14, 22),
		SurfaceAlt  = Color3.fromRGB(55, 20, 32),
		Accent      = Color3.fromRGB(244, 63, 94),
		AccentHover = Color3.fromRGB(251, 113, 133),
		Border      = Color3.fromRGB(90, 30, 50),
		Text        = Color3.fromRGB(255, 220, 230),
		TextDim     = Color3.fromRGB(190, 120, 140),
		Toggle      = Color3.fromRGB(244, 63, 94),
		Scrollbar   = Color3.fromRGB(244, 63, 94),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Cyberpunk = {
		Background  = Color3.fromRGB(8, 8, 15),
		Surface     = Color3.fromRGB(12, 12, 22),
		SurfaceAlt  = Color3.fromRGB(18, 18, 32),
		Accent      = Color3.fromRGB(250, 204, 21),
		AccentHover = Color3.fromRGB(253, 224, 71),
		Border      = Color3.fromRGB(60, 50, 10),
		Text        = Color3.fromRGB(250, 250, 200),
		TextDim     = Color3.fromRGB(160, 150, 80),
		Toggle      = Color3.fromRGB(250, 204, 21),
		Scrollbar   = Color3.fromRGB(250, 204, 21),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Sakura = {
		Background  = Color3.fromRGB(30, 18, 28),
		Surface     = Color3.fromRGB(44, 26, 40),
		SurfaceAlt  = Color3.fromRGB(60, 36, 55),
		Accent      = Color3.fromRGB(236, 72, 153),
		AccentHover = Color3.fromRGB(244, 114, 182),
		Border      = Color3.fromRGB(100, 50, 90),
		Text        = Color3.fromRGB(255, 225, 245),
		TextDim     = Color3.fromRGB(190, 130, 170),
		Toggle      = Color3.fromRGB(236, 72, 153),
		Scrollbar   = Color3.fromRGB(236, 72, 153),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Arctic = {
		Background  = Color3.fromRGB(12, 22, 32),
		Surface     = Color3.fromRGB(18, 32, 46),
		SurfaceAlt  = Color3.fromRGB(25, 44, 62),
		Accent      = Color3.fromRGB(56, 189, 248),
		AccentHover = Color3.fromRGB(125, 211, 252),
		Border      = Color3.fromRGB(30, 60, 90),
		Text        = Color3.fromRGB(220, 240, 255),
		TextDim     = Color3.fromRGB(100, 160, 200),
		Toggle      = Color3.fromRGB(56, 189, 248),
		Scrollbar   = Color3.fromRGB(56, 189, 248),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Ember = {
		Background  = Color3.fromRGB(22, 10, 6),
		Surface     = Color3.fromRGB(34, 14, 8),
		SurfaceAlt  = Color3.fromRGB(48, 20, 10),
		Accent      = Color3.fromRGB(239, 68, 68),
		AccentHover = Color3.fromRGB(252, 100, 100),
		Border      = Color3.fromRGB(100, 30, 20),
		Text        = Color3.fromRGB(255, 230, 220),
		TextDim     = Color3.fromRGB(200, 120, 110),
		Toggle      = Color3.fromRGB(239, 68, 68),
		Scrollbar   = Color3.fromRGB(239, 68, 68),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Slate = {
		Background  = Color3.fromRGB(15, 18, 22),
		Surface     = Color3.fromRGB(22, 26, 32),
		SurfaceAlt  = Color3.fromRGB(30, 36, 44),
		Accent      = Color3.fromRGB(148, 163, 184),
		AccentHover = Color3.fromRGB(203, 213, 225),
		Border      = Color3.fromRGB(50, 58, 70),
		Text        = Color3.fromRGB(220, 228, 240),
		TextDim     = Color3.fromRGB(110, 125, 145),
		Toggle      = Color3.fromRGB(148, 163, 184),
		Scrollbar   = Color3.fromRGB(148, 163, 184),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Lavender = {
		Background  = Color3.fromRGB(20, 15, 32),
		Surface     = Color3.fromRGB(30, 22, 46),
		SurfaceAlt  = Color3.fromRGB(42, 32, 64),
		Accent      = Color3.fromRGB(167, 139, 250),
		AccentHover = Color3.fromRGB(196, 181, 253),
		Border      = Color3.fromRGB(70, 50, 110),
		Text        = Color3.fromRGB(240, 235, 255),
		TextDim     = Color3.fromRGB(160, 145, 200),
		Toggle      = Color3.fromRGB(167, 139, 250),
		Scrollbar   = Color3.fromRGB(167, 139, 250),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(34, 197, 94),
		Error       = Color3.fromRGB(239, 68, 68),
	},
	Monochrome = {
		Background  = Color3.fromRGB(10, 10, 10),
		Surface     = Color3.fromRGB(20, 20, 20),
		SurfaceAlt  = Color3.fromRGB(32, 32, 32),
		Accent      = Color3.fromRGB(200, 200, 200),
		AccentHover = Color3.fromRGB(255, 255, 255),
		Border      = Color3.fromRGB(60, 60, 60),
		Text        = Color3.fromRGB(240, 240, 240),
		TextDim     = Color3.fromRGB(140, 140, 140),
		Toggle      = Color3.fromRGB(200, 200, 200),
		Scrollbar   = Color3.fromRGB(200, 200, 200),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(200, 200, 200),
		Error       = Color3.fromRGB(200, 200, 200),
	},
	Neon = {
		Background  = Color3.fromRGB(5, 5, 10),
		Surface     = Color3.fromRGB(10, 10, 18),
		SurfaceAlt  = Color3.fromRGB(15, 15, 28),
		Accent      = Color3.fromRGB(0, 255, 180),
		AccentHover = Color3.fromRGB(80, 255, 210),
		Border      = Color3.fromRGB(0, 80, 60),
		Text        = Color3.fromRGB(200, 255, 240),
		TextDim     = Color3.fromRGB(0, 180, 130),
		Toggle      = Color3.fromRGB(0, 255, 180),
		Scrollbar   = Color3.fromRGB(0, 255, 180),
		Shadow      = Color3.fromRGB(0, 0, 0),
		Success     = Color3.fromRGB(0, 255, 180),
		Error       = Color3.fromRGB(255, 50, 50),
	},
}

-- ══════════════════════════════════════════════
--  Utility: current theme shorthand
-- ══════════════════════════════════════════════
local function T(key)
	return Nova.Themes[Nova.SelectedTheme][key]
end

-- ══════════════════════════════════════════════
--  ScreenGui Setup
-- ══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name       = "NovaLibrary"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

pcall(function()
	if syn then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = game:GetService("CoreGui")
	else
		ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
	end
end)

if not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Remove duplicates
local guiParent = ScreenGui.Parent
for _, c in ipairs(guiParent:GetChildren()) do
	if c.Name == "NovaLibrary" and c ~= ScreenGui then
		c:Destroy()
	end
end

-- ══════════════════════════════════════════════
--  Helpers
-- ══════════════════════════════════════════════
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function Tween(obj, info, props)
	TweenService:Create(obj, info, props):Play()
end

local function QuickTween(obj, t, props, style, dir)
	local ti = TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
	Tween(obj, ti, props)
end

local function AddConn(signal, fn)
	local c = signal:Connect(fn)
	table.insert(Nova.Connections, c)
	return c
end

local function New(class, props, children)
	local inst = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			pcall(function() inst[k] = v end)
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = inst
		end
	end
	return inst
end

local function Corner(r)
	return New("UICorner", {CornerRadius = UDim.new(0, r or 8)})
end

local function Padding(t, b, l, r)
	return New("UIPadding", {
		PaddingTop    = UDim.new(0, t or 6),
		PaddingBottom = UDim.new(0, b or 6),
		PaddingLeft   = UDim.new(0, l or 6),
		PaddingRight  = UDim.new(0, r or 6),
	})
end

local function ListLayout(pad, sort)
	return New("UIListLayout", {
		Padding    = UDim.new(0, pad or 4),
		SortOrder  = sort or Enum.SortOrder.LayoutOrder,
	})
end

local function AutoCanvas(frame, padding)
	padding = padding or 8
	AddConn(frame.UIListLayout.Changed, function()
		frame.CanvasSize = UDim2.new(0, 0, 0, frame.UIListLayout.AbsoluteContentSize.Y + padding)
	end)
end

local function MakeDraggable(dragHandle, moveTarget)
	local dragging   = false
	local dragStart  = Vector3.new()
	local startPos   = UDim2.new()

	local function onInput(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or
		   input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local delta = input.Position - dragStart
				QuickTween(moveTarget, 0.08, {
					Position = UDim2.new(
						startPos.X.Scale, startPos.X.Offset + delta.X,
						startPos.Y.Scale, startPos.Y.Offset + delta.Y
					)
				}, Enum.EasingStyle.Linear)
			end
		end
	end

	AddConn(dragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = input.Position
			startPos  = moveTarget.Position
			AddConn(input.Changed, function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	AddConn(UserInputService.InputChanged, onInput)
end

-- ══════════════════════════════════════════════
--  Notification System
-- ══════════════════════════════════════════════
local NotifHolder = New("Frame", {
	Parent          = ScreenGui,
	Position        = UDim2.new(1, -20, 1, -20),
	Size            = UDim2.new(0, 300, 1, -20),
	AnchorPoint     = Vector2.new(1, 1),
	BackgroundTransparency = 1,
}, {ListLayout(6)})
NotifHolder.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifHolder.UIListLayout.VerticalAlignment   = Enum.VerticalAlignment.Bottom

function Nova:Notify(cfg)
	cfg = cfg or {}
	cfg.Title   = cfg.Title   or "Notification"
	cfg.Message = cfg.Message or ""
	cfg.Time    = cfg.Time    or 4
	cfg.Type    = cfg.Type    or "info" -- "info", "success", "error"

	local accentColor = T("Accent")
	if cfg.Type == "success" then accentColor = T("Success")
	elseif cfg.Type == "error" then accentColor = T("Error") end

	local wrap = New("Frame", {
		Parent             = NotifHolder,
		Size               = UDim2.new(1, 0, 0, 0),
		AutomaticSize      = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})

	local frame = New("Frame", {
		Parent             = wrap,
		Size               = UDim2.new(1, 0, 0, 0),
		AutomaticSize      = Enum.AutomaticSize.Y,
		BackgroundColor3   = T("Surface"),
		BorderSizePixel    = 0,
		Position           = UDim2.new(1, 20, 0, 0),
	}, {
		Corner(10),
		Padding(12, 12, 14, 14),
		New("UIStroke", {Color = accentColor, Thickness = 1.5, Transparency = 0.4}),
		New("Frame", {
			Size             = UDim2.new(0, 3, 1, -20),
			Position         = UDim2.new(0, 0, 0, 10),
			BackgroundColor3 = accentColor,
			BorderSizePixel  = 0,
		}, {Corner(4)}),
		New("TextLabel", {
			Name             = "Title",
			Text             = cfg.Title,
			Font             = Enum.Font.GothamBold,
			TextSize         = 14,
			TextColor3       = T("Text"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, -10, 0, 18),
			Position         = UDim2.new(0, 10, 0, 0),
		}),
		New("TextLabel", {
			Name             = "Msg",
			Text             = cfg.Message,
			Font             = Enum.Font.Gotham,
			TextSize         = 13,
			TextColor3       = T("TextDim"),
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextWrapped      = true,
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, -10, 0, 0),
			AutomaticSize    = Enum.AutomaticSize.Y,
			Position         = UDim2.new(0, 10, 0, 22),
		}),
	})

	QuickTween(frame, 0.4, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)

	task.delay(cfg.Time - 0.5, function()
		QuickTween(frame, 0.4, {Position = UDim2.new(1, 20, 0, 0)}, Enum.EasingStyle.Quint)
		task.wait(0.45)
		wrap:Destroy()
	end)
end

-- ══════════════════════════════════════════════
--  Config / Save System
-- ══════════════════════════════════════════════
local function EnsureFolder(name)
	pcall(function()
		if not isfolder(name) then
			makefolder(name)
		end
	end)
end

local function SaveConfig(folder, name)
	pcall(function()
		EnsureFolder(folder)
		local data = {}
		for flag, obj in pairs(Nova.Flags) do
			if obj.Save then
				if obj.Type == "ColorPicker" then
					data[flag] = {R = obj.Value.R * 255, G = obj.Value.G * 255, B = obj.Value.B * 255}
				else
					data[flag] = obj.Value
				end
			end
		end
		writefile(folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
	end)
end

local function LoadConfig(folder, name)
	pcall(function()
		local path = folder .. "/" .. name .. ".json"
		if isfile and isfile(path) then
			local data = HttpService:JSONDecode(readfile(path))
			for flag, val in pairs(data) do
				if Nova.Flags[flag] then
					task.spawn(function()
						local obj = Nova.Flags[flag]
						if obj.Type == "ColorPicker" then
							obj:Set(Color3.fromRGB(val.R, val.G, val.B))
						else
							obj:Set(val)
						end
					end)
				end
			end
		end
	end)
end

-- ══════════════════════════════════════════════
--  Theme update system
-- ══════════════════════════════════════════════
Nova._themeListeners = {}

function Nova:_onThemeChanged()
	for _, fn in ipairs(Nova._themeListeners) do
		pcall(fn)
	end
end

function Nova:_listen(fn)
	table.insert(Nova._themeListeners, fn)
end

-- ══════════════════════════════════════════════
--  Key System
-- ══════════════════════════════════════════════
local function ShowKeySystem(cfg, callback)
	local kFrame = New("Frame", {
		Parent           = ScreenGui,
		Size             = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.4,
		ZIndex           = 50,
	})

	local box = New("Frame", {
		Parent           = kFrame,
		Size             = UDim2.new(0, 380, 0, 210),
		Position         = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = T("Surface"),
		BorderSizePixel  = 0,
		ZIndex           = 51,
	}, {
		Corner(14),
		Padding(20, 20, 22, 22),
		New("UIStroke", {Color = T("Border"), Thickness = 1.2}),
	})

	-- Accent bar top
	New("Frame", {
		Parent           = box,
		Size             = UDim2.new(1, 0, 0, 3),
		BackgroundColor3 = T("Accent"),
		BorderSizePixel  = 0,
		ZIndex           = 52,
	}, {Corner(3)})

	local titleLbl = New("TextLabel", {
		Parent           = box,
		Text             = cfg.KeyName or "Key Required",
		Font             = Enum.Font.GothamBold,
		TextSize         = 18,
		TextColor3       = T("Text"),
		BackgroundTransparency = 1,
		Size             = UDim2.new(1, 0, 0, 24),
		Position         = UDim2.new(0, 0, 0, 12),
		ZIndex           = 52,
	})

	local statusLbl = New("TextLabel", {
		Parent           = box,
		Text             = "Enter your key below to continue.",
		Font             = Enum.Font.Gotham,
		TextSize         = 13,
		TextColor3       = T("TextDim"),
		BackgroundTransparency = 1,
		Size             = UDim2.new(1, 0, 0, 18),
		Position         = UDim2.new(0, 0, 0, 40),
		ZIndex           = 52,
	})

	local inputBg = New("Frame", {
		Parent           = box,
		Size             = UDim2.new(1, 0, 0, 38),
		Position         = UDim2.new(0, 0, 0, 68),
		BackgroundColor3 = T("SurfaceAlt"),
		BorderSizePixel  = 0,
		ZIndex           = 52,
	}, {
		Corner(8),
		New("UIStroke", {Color = T("Border"), Thickness = 1}),
	})

	local inputBox = New("TextBox", {
		Parent           = inputBg,
		Size             = UDim2.new(1, -16, 1, 0),
		Position         = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		PlaceholderText  = "Paste your key here...",
		Font             = Enum.Font.Gotham,
		TextSize         = 14,
		TextColor3       = T("Text"),
		PlaceholderColor3 = T("TextDim"),
		ClearTextOnFocus = false,
		ZIndex           = 53,
		TextXAlignment   = Enum.TextXAlignment.Left,
	})

	local confirmBtn = New("TextButton", {
		Parent           = box,
		Size             = UDim2.new(0.48, 0, 0, 36),
		Position         = UDim2.new(0.52, 0, 0, 118),
		BackgroundColor3 = T("Accent"),
		Text             = "Confirm",
		Font             = Enum.Font.GothamBold,
		TextSize         = 14,
		TextColor3       = Color3.fromRGB(255, 255, 255),
		BorderSizePixel  = 0,
		ZIndex           = 52,
		AutoButtonColor  = false,
	}, {Corner(8)})

	local linkBtn = New("TextButton", {
		Parent           = box,
		Size             = UDim2.new(0.48, 0, 0, 36),
		Position         = UDim2.new(0, 0, 0, 118),
		BackgroundColor3 = T("SurfaceAlt"),
		Text             = "Get Key",
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 14,
		TextColor3       = T("Text"),
		BorderSizePixel  = 0,
		ZIndex           = 52,
		AutoButtonColor  = false,
	}, {Corner(8), New("UIStroke", {Color = T("Border"), Thickness = 1})})

	AddConn(linkBtn.MouseButton1Click, function()
		if cfg.Sitekey then
			pcall(function()
				setclipboard(cfg.Sitekey)
				statusLbl.TextColor3 = T("Success") or Color3.fromRGB(34,197,94)
				statusLbl.Text = "Link copied to clipboard!"
				task.wait(2)
				statusLbl.TextColor3 = T("TextDim")
				statusLbl.Text = "Enter your key below to continue."
			end)
		end
	end)

	AddConn(confirmBtn.MouseButton1Click, function()
		local entered = inputBox.Text
		if entered == cfg.Key then
			if cfg.KeySave then
				pcall(function()
					EnsureFolder(Nova.Folder)
					local kn = cfg.KeyJsonName or "key"
					writefile(Nova.Folder .. "/" .. kn .. ".json", HttpService:JSONEncode({key = entered}))
				end)
			end
			statusLbl.TextColor3 = T("Success") or Color3.fromRGB(34,197,94)
			statusLbl.Text = "Key accepted! Loading..."
			task.wait(0.8)
			QuickTween(kFrame, 0.4, {BackgroundTransparency = 1})
			QuickTween(box, 0.4, {BackgroundTransparency = 1, Size = UDim2.new(0, 380, 0, 0)}, Enum.EasingStyle.Back)
			task.wait(0.45)
			kFrame:Destroy()
			callback(true)
		else
			statusLbl.TextColor3 = T("Error") or Color3.fromRGB(239,68,68)
			statusLbl.Text = "Incorrect key. Please try again."
			QuickTween(inputBg, 0.08, {Position = UDim2.new(0.01, 0, 0, 68)})
			task.wait(0.08)
			QuickTween(inputBg, 0.08, {Position = UDim2.new(-0.01, 0, 0, 68)})
			task.wait(0.08)
			QuickTween(inputBg, 0.08, {Position = UDim2.new(0, 0, 0, 68)})
			task.wait(2)
			statusLbl.TextColor3 = T("TextDim")
			statusLbl.Text = "Enter your key below to continue."
		end
	end)

	-- animate in
	box.Size = UDim2.new(0, 380, 0, 0)
	QuickTween(box, 0.4, {Size = UDim2.new(0, 380, 0, 210)}, Enum.EasingStyle.Back)
end

-- ══════════════════════════════════════════════
--  Loading Screen
-- ══════════════════════════════════════════════
local function ShowLoading(cfg, callback)
	local loadBg = New("Frame", {
		Parent           = ScreenGui,
		Size             = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(8, 8, 14),
		ZIndex           = 100,
	})

	local logoImg
	if cfg.LoadingIcon and cfg.LoadingIcon ~= "" then
		logoImg = New("ImageLabel", {
			Parent           = loadBg,
			Size             = UDim2.new(0, 56, 0, 56),
			Position         = UDim2.new(0.5, 0, 0.44, 0),
			AnchorPoint      = Vector2.new(0.5, 0.5),
			Image            = "rbxassetid://" .. tostring(cfg.LoadingIcon),
			BackgroundTransparency = 1,
			ImageTransparency = 1,
			ZIndex           = 101,
		})
	end

	local nameLbl = New("TextLabel", {
		Parent           = loadBg,
		Text             = cfg.LoadingName or "Loading...",
		Font             = Enum.Font.GothamBold,
		TextSize         = 22,
		TextColor3       = Color3.fromRGB(230, 230, 240),
		BackgroundTransparency = 1,
		Size             = UDim2.new(1, 0, 0, 30),
		Position         = UDim2.new(0.5, 0, 0.5, 20),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		TextXAlignment   = Enum.TextXAlignment.Center,
		TextTransparency = 1,
		ZIndex           = 101,
	})

	local barBg = New("Frame", {
		Parent           = loadBg,
		Size             = UDim2.new(0, 220, 0, 3),
		Position         = UDim2.new(0.5, 0, 0.58, 0),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(40, 40, 56),
		BorderSizePixel  = 0,
		ZIndex           = 101,
	}, {Corner(4)})

	local barFill = New("Frame", {
		Parent           = barBg,
		Size             = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = T("Accent"),
		BorderSizePixel  = 0,
		ZIndex           = 102,
	}, {Corner(4)})

	task.spawn(function()
		task.wait(0.1)
		if logoImg then
			QuickTween(logoImg, 0.5, {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.42, 0)}, Enum.EasingStyle.Back)
		end
		task.wait(0.4)
		QuickTween(nameLbl, 0.4, {TextTransparency = 0})
		-- animate bar
		QuickTween(barFill, 2.0, {Size = UDim2.new(1, 0, 1, 0)}, Enum.EasingStyle.Quint)
		task.wait(2.2)
		QuickTween(loadBg, 0.5, {BackgroundTransparency = 1})
		if logoImg then QuickTween(logoImg, 0.3, {ImageTransparency = 1}) end
		QuickTween(nameLbl, 0.3, {TextTransparency = 1})
		task.wait(0.55)
		loadBg:Destroy()
		callback()
	end)
end

-- ══════════════════════════════════════════════
--  Main Window
-- ══════════════════════════════════════════════
function Nova:CreateWindow(cfg)
	cfg = cfg or {}
	cfg.Title          = cfg.Title          or "Nova Library"
	cfg.SubTitle       = cfg.SubTitle       or "v1.0"
	cfg.LoadingEnabled = cfg.LoadingEnabled ~= false
	cfg.LoadingName    = cfg.LoadingName    or cfg.Title
	cfg.LoadingIcon    = cfg.LoadingIcon    or ""
	cfg.KeySystem      = cfg.KeySystem      or false
	cfg.KeyName        = cfg.KeyName        or "Key System"
	cfg.Key            = cfg.Key            or ""
	cfg.GetKeyFromSite = cfg.GetKeyFromSite or false
	cfg.Sitekey        = cfg.Sitekey        or ""
	cfg.KeySave        = cfg.KeySave        ~= false
	cfg.KeyJsonName    = cfg.KeyJsonName    or "keydata"
	cfg.AutoSave       = cfg.AutoSave       ~= false
	cfg.Folder         = cfg.Folder         or "NovaLib"

	Nova.Folder  = cfg.Folder
	Nova.SaveCfg = cfg.AutoSave

	EnsureFolder(Nova.Folder)

	local winSize   = Vector2.new(600, 400)
	local minWinH   = 400
	local maxWinH   = 600
	local minimized = false
	local visible   = true

	-- ── Main Frame ──────────────────────────────
	local MainFrame = New("Frame", {
		Parent           = ScreenGui,
		Size             = UDim2.new(0, winSize.X, 0, winSize.Y),
		Position         = UDim2.new(0.5, -winSize.X/2, 0.5, -winSize.Y/2),
		BackgroundColor3 = T("Background"),
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	}, {
		Corner(12),
		New("UIStroke", {Color = T("Border"), Thickness = 1.2, Name = "MainStroke"}),
	})

	-- Theme update for main frame
	Nova:_listen(function()
		MainFrame.BackgroundColor3 = T("Background")
		MainFrame.MainStroke.Color  = T("Border")
	end)

	-- ── Top Bar ─────────────────────────────────
	local TopBar = New("Frame", {
		Parent           = MainFrame,
		Size             = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = T("Surface"),
		BorderSizePixel  = 0,
		ZIndex           = 3,
		Name             = "TopBar",
	}, {
		New("UICorner", {CornerRadius = UDim.new(0, 12)}),
		-- bottom fill to prevent double-rounded corners at join
		New("Frame", {
			Size             = UDim2.new(1, 0, 0, 12),
			Position         = UDim2.new(0, 0, 1, -12),
			BackgroundColor3 = T("Surface"),
			BorderSizePixel  = 0,
			ZIndex           = 2,
		}),
	})

	-- accent bar underline
	New("Frame", {
		Parent           = TopBar,
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = T("Border"),
		BorderSizePixel  = 0,
		ZIndex           = 4,
		Name             = "Divider",
	})

	Nova:_listen(function()
		TopBar.BackgroundColor3           = T("Surface")
		TopBar:FindFirstChild("Frame").BackgroundColor3 = T("Surface")
		TopBar.Divider.BackgroundColor3   = T("Border")
	end)

	MakeDraggable(TopBar, MainFrame)

	-- Window Title
	local TitleLabel = New("TextLabel", {
		Parent           = TopBar,
		Text             = cfg.Title,
		Font             = Enum.Font.GothamBold,
		TextSize         = 16,
		TextColor3       = T("Text"),
		BackgroundTransparency = 1,
		Size             = UDim2.new(0, 200, 1, 0),
		Position         = UDim2.new(0, 16, 0, 0),
		ZIndex           = 5,
		TextXAlignment   = Enum.TextXAlignment.Left,
	})
	local SubLabel = New("TextLabel", {
		Parent           = TopBar,
		Text             = cfg.SubTitle,
		Font             = Enum.Font.Gotham,
		TextSize         = 12,
		TextColor3       = T("TextDim"),
		BackgroundTransparency = 1,
		Size             = UDim2.new(0, 200, 1, 0),
		Position         = UDim2.new(0, 16 + TitleLabel.TextBounds.X + 8, 0, 0),
		ZIndex           = 5,
		TextXAlignment   = Enum.TextXAlignment.Left,
	})
	Nova:_listen(function()
		TitleLabel.TextColor3 = T("Text")
		SubLabel.TextColor3   = T("TextDim")
	end)

	-- ── Top Bar Buttons ──────────────────────────
	local BtnContainer = New("Frame", {
		Parent           = TopBar,
		Size             = UDim2.new(0, 110, 0, 30),
		Position         = UDim2.new(1, -118, 0.5, 0),
		AnchorPoint      = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		ZIndex           = 5,
	}, {ListLayout(6)})
	BtnContainer.UIListLayout.FillDirection       = Enum.FillDirection.Horizontal
	BtnContainer.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	BtnContainer.UIListLayout.VerticalAlignment   = Enum.VerticalAlignment.Center

	local function MakeTopBtn(color, icon)
		local btn = New("TextButton", {
			Parent           = BtnContainer,
			Size             = UDim2.new(0, 28, 0, 28),
			BackgroundColor3 = T("SurfaceAlt"),
			Text             = icon,
			Font             = Enum.Font.GothamBold,
			TextSize         = 14,
			TextColor3       = color,
			AutoButtonColor  = false,
			BorderSizePixel  = 0,
			ZIndex           = 6,
		}, {Corner(6)})
		AddConn(btn.MouseEnter, function()
			QuickTween(btn, 0.18, {BackgroundColor3 = color, TextColor3 = Color3.fromRGB(255,255,255)})
		end)
		AddConn(btn.MouseLeave, function()
			QuickTween(btn, 0.18, {BackgroundColor3 = T("SurfaceAlt"), TextColor3 = color})
		end)
		Nova:_listen(function()
			btn.BackgroundColor3 = T("SurfaceAlt")
		end)
		return btn
	end

	local ResizeBtn   = MakeTopBtn(T("Accent"), "⤢")
	local MinimizeBtn = MakeTopBtn(T("TextDim"), "—")
	local CloseBtn    = MakeTopBtn(T("Error"),   "✕")

	-- ── Close Modal ─────────────────────────────
	local function ShowCloseModal()
		local overlay = New("Frame", {
			Parent           = ScreenGui,
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.5,
			ZIndex           = 200,
		})
		local modal = New("Frame", {
			Parent           = overlay,
			Size             = UDim2.new(0, 300, 0, 0),
			Position         = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint      = Vector2.new(0.5, 0.5),
			BackgroundColor3 = T("Surface"),
			BorderSizePixel  = 0,
			ZIndex           = 201,
		}, {
			Corner(12),
			Padding(20, 20, 20, 20),
			New("UIStroke", {Color = T("Border"), Thickness = 1}),
		})
		local lbl = New("TextLabel", {
			Parent           = modal,
			Text             = "Close the UI?",
			Font             = Enum.Font.GothamBold,
			TextSize         = 16,
			TextColor3       = T("Text"),
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 0, 22),
			Position         = UDim2.new(0, 0, 0, 0),
			ZIndex           = 202,
		})
		local sub = New("TextLabel", {
			Parent           = modal,
			Text             = "This will close Nova Library.",
			Font             = Enum.Font.Gotham,
			TextSize         = 13,
			TextColor3       = T("TextDim"),
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, 0, 0, 18),
			Position         = UDim2.new(0, 0, 0, 26),
			ZIndex           = 202,
		})
		local btnRow = New("Frame", {
			Parent           = modal,
			Size             = UDim2.new(1, 0, 0, 36),
			Position         = UDim2.new(0, 0, 0, 56),
			BackgroundTransparency = 1,
			ZIndex           = 202,
		}, {ListLayout(10)})
		btnRow.UIListLayout.FillDirection = Enum.FillDirection.Horizontal

		local function ModalBtn(txt, bg, tc, cb)
			local b = New("TextButton", {
				Parent           = btnRow,
				Size             = UDim2.new(0.5, -5, 1, 0),
				BackgroundColor3 = bg,
				Text             = txt,
				Font             = Enum.Font.GothamBold,
				TextSize         = 14,
				TextColor3       = tc,
				AutoButtonColor  = false,
				BorderSizePixel  = 0,
				ZIndex           = 203,
			}, {Corner(8)})
			AddConn(b.MouseButton1Click, cb)
		end
		ModalBtn("Cancel", T("SurfaceAlt"), T("Text"), function()
			QuickTween(modal, 0.3, {Size = UDim2.new(0, 300, 0, 0)}, Enum.EasingStyle.Back)
			task.wait(0.35)
			overlay:Destroy()
		end)
		ModalBtn("Yes, Close", T("Error"), Color3.fromRGB(255,255,255), function()
			overlay:Destroy()
			ScreenGui:Destroy()
		end)

		modal.Size = UDim2.new(0, 300, 0, 0)
		QuickTween(modal, 0.35, {Size = UDim2.new(0, 300, 0, 110)}, Enum.EasingStyle.Back)
	end

	AddConn(CloseBtn.MouseButton1Click, ShowCloseModal)

	-- ── Minimize ─────────────────────────────────
	AddConn(MinimizeBtn.MouseButton1Click, function()
		minimized = not minimized
		if minimized then
			QuickTween(MainFrame, 0.4, {Size = UDim2.new(0, winSize.X, 0, 48)}, Enum.EasingStyle.Quint)
			MinimizeBtn.Text = "⬜"
		else
			QuickTween(MainFrame, 0.4, {Size = UDim2.new(0, winSize.X, 0, winSize.Y)}, Enum.EasingStyle.Quint)
			MinimizeBtn.Text = "—"
		end
	end)

	-- ── Resize ──────────────────────────────────
	local resizing     = false
	local resizeStart  = Vector3.new()
	local resizeStartH = 0

	AddConn(ResizeBtn.MouseButton1Down, function()
		resizing     = true
		resizeStart  = UserInputService:GetMouseLocation()
		resizeStartH = MainFrame.AbsoluteSize.Y
	end)
	AddConn(UserInputService.InputChanged, function(input)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position.Y - resizeStart.Y
			local newH  = math.clamp(resizeStartH + delta, minWinH, maxWinH)
			winSize     = Vector2.new(winSize.X, newH)
			QuickTween(MainFrame, 0.08, {Size = UDim2.new(0, winSize.X, 0, newH)}, Enum.EasingStyle.Linear)
		end
	end)
	AddConn(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)

	-- Mobile touch resize support
	if isMobile then
		local pinchStart, sizeStart
		AddConn(UserInputService.TouchPinch, function(positions, scale, _, state)
			if state == Enum.UserInputState.Begin then
				sizeStart = MainFrame.AbsoluteSize
			elseif state == Enum.UserInputState.Change then
				local newW = math.clamp(sizeStart.X * scale, 300, 700)
				local newH = math.clamp(sizeStart.Y * scale, minWinH, maxWinH)
				winSize    = Vector2.new(newW, newH)
				QuickTween(MainFrame, 0.08, {Size = UDim2.new(0, newW, 0, newH)}, Enum.EasingStyle.Linear)
			end
		end)
	end

	-- ── Tab Bar (left sidebar) ───────────────────
	local TabBar = New("ScrollingFrame", {
		Parent             = MainFrame,
		Size               = UDim2.new(0, 150, 1, -48),
		Position           = UDim2.new(0, 0, 0, 48),
		BackgroundColor3   = T("Surface"),
		BorderSizePixel    = 0,
		ScrollBarThickness = 0,
		CanvasSize         = UDim2.new(0, 0, 0, 0),
		ZIndex             = 2,
	}, {
		Padding(8, 8, 8, 8),
		ListLayout(4),
	})
	TabBar.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Divider line between tab bar and content
	New("Frame", {
		Parent           = MainFrame,
		Size             = UDim2.new(0, 1, 1, -48),
		Position         = UDim2.new(0, 150, 0, 48),
		BackgroundColor3 = T("Border"),
		BorderSizePixel  = 0,
		ZIndex           = 3,
		Name             = "TabDivider",
	})

	Nova:_listen(function()
		TabBar.BackgroundColor3 = T("Surface")
		MainFrame.TabDivider.BackgroundColor3 = T("Border")
	end)

	AddConn(TabBar.UIListLayout.Changed, function()
		TabBar.CanvasSize = UDim2.new(0, 0, 0, TabBar.UIListLayout.AbsoluteContentSize.Y + 16)
	end)

	-- ── Content Area ─────────────────────────────
	local ContentArea = New("Frame", {
		Parent           = MainFrame,
		Size             = UDim2.new(1, -150, 1, -48),
		Position         = UDim2.new(0, 150, 0, 48),
		BackgroundColor3 = T("Background"),
		BorderSizePixel  = 0,
		ZIndex           = 2,
	})
	Nova:_listen(function()
		ContentArea.BackgroundColor3 = T("Background")
	end)

	-- ══════════════════════════════════════════════
	--  Window Object
	-- ══════════════════════════════════════════════
	local Window = {}
	local tabs   = {}
	local firstTab = true
	local saveKey  = cfg.Title:gsub("%s", "_")

	-- ── Tab Item Helper (elements per tab/section) ─
	local function MakeItemFunctions(ItemParent, tabRef)

		local function AutoSaveTrigger()
			if Nova.SaveCfg then
				SaveConfig(Nova.Folder, saveKey)
			end
		end

		local ItemFunctions = {}

		-- Label
		function ItemFunctions:AddLabel(cfg2)
			cfg2 = type(cfg2) == "string" and {Text = cfg2} or (cfg2 or {})
			cfg2.Text = cfg2.Text or "Label"

			local frame = New("Frame", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = T("SurfaceAlt"),
				BorderSizePixel  = 0,
			}, {Corner(8)})

			local lbl = New("TextLabel", {
				Parent           = frame,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 13,
				TextColor3       = T("TextDim"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, -20, 1, 0),
				Position         = UDim2.new(0, 10, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
				TextWrapped      = true,
			})

			Nova:_listen(function()
				frame.BackgroundColor3 = T("SurfaceAlt")
				lbl.TextColor3 = T("TextDim")
			end)

			local LabelObj = {}
			function LabelObj:Set(txt) lbl.Text = txt end
			return LabelObj
		end

		-- Button
		function ItemFunctions:AddButton(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text     = cfg2.Text     or "Button"
			cfg2.Callback = cfg2.Callback or function() end

			local frame = New("TextButton", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = T("SurfaceAlt"),
				Text             = "",
				BorderSizePixel  = 0,
				AutoButtonColor  = false,
			}, {
				Corner(8),
				New("UIStroke", {Color = T("Border"), Thickness = 1}),
			})

			local lbl = New("TextLabel", {
				Parent           = frame,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamBold,
				TextSize         = 14,
				TextColor3       = T("Text"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, -20, 1, 0),
				Position         = UDim2.new(0, 12, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			local arrowLbl = New("TextLabel", {
				Parent           = frame,
				Text             = "›",
				Font             = Enum.Font.GothamBold,
				TextSize         = 18,
				TextColor3       = T("Accent"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0, 20, 1, 0),
				Position         = UDim2.new(1, -28, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Center,
			})

			Nova:_listen(function()
				frame.BackgroundColor3 = T("SurfaceAlt")
				frame.UIStroke.Color   = T("Border")
				lbl.TextColor3         = T("Text")
				arrowLbl.TextColor3    = T("Accent")
			end)

			AddConn(frame.MouseEnter, function()
				QuickTween(frame, 0.18, {BackgroundColor3 = T("Surface")})
			end)
			AddConn(frame.MouseLeave, function()
				QuickTween(frame, 0.18, {BackgroundColor3 = T("SurfaceAlt")})
			end)
			AddConn(frame.MouseButton1Down, function()
				QuickTween(frame, 0.1, {BackgroundColor3 = T("Background")})
			end)
			AddConn(frame.MouseButton1Up, function()
				QuickTween(frame, 0.18, {BackgroundColor3 = T("Surface")})
				task.spawn(cfg2.Callback)
			end)

			-- Touch support
			AddConn(frame.TouchTap, function()
				task.spawn(cfg2.Callback)
			end)

			local BtnObj = {}
			function BtnObj:Set(txt) lbl.Text = txt end
			return BtnObj
		end

		-- Toggle
		function ItemFunctions:AddToggle(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text     = cfg2.Text     or "Toggle"
			cfg2.Default  = cfg2.Default  or false
			cfg2.Callback = cfg2.Callback or function() end
			cfg2.Flag     = cfg2.Flag     or nil
			cfg2.Save     = cfg2.Save     or false

			local Toggle = {Value = cfg2.Default, Type = "Toggle", Save = cfg2.Save}

			local frame = New("TextButton", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = T("SurfaceAlt"),
				Text             = "",
				BorderSizePixel  = 0,
				AutoButtonColor  = false,
			}, {
				Corner(8),
				New("UIStroke", {Color = T("Border"), Thickness = 1}),
			})

			local lbl = New("TextLabel", {
				Parent           = frame,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 14,
				TextColor3       = T("Text"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, -58, 1, 0),
				Position         = UDim2.new(0, 12, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			-- Toggle pill
			local pillBg = New("Frame", {
				Parent           = frame,
				Size             = UDim2.new(0, 38, 0, 22),
				Position         = UDim2.new(1, -50, 0.5, 0),
				AnchorPoint      = Vector2.new(0, 0.5),
				BackgroundColor3 = T("Surface"),
				BorderSizePixel  = 0,
			}, {Corner(11)})

			local pillDot = New("Frame", {
				Parent           = pillBg,
				Size             = UDim2.new(0, 16, 0, 16),
				Position         = UDim2.new(0, 3, 0.5, 0),
				AnchorPoint      = Vector2.new(0, 0.5),
				BackgroundColor3 = T("TextDim"),
				BorderSizePixel  = 0,
			}, {Corner(9)})

			Nova:_listen(function()
				frame.BackgroundColor3 = T("SurfaceAlt")
				frame.UIStroke.Color   = T("Border")
				lbl.TextColor3         = T("Text")
				if not Toggle.Value then
					pillBg.BackgroundColor3  = T("Surface")
					pillDot.BackgroundColor3 = T("TextDim")
				end
			end)

			function Toggle:Set(val)
				Toggle.Value = val
				if val then
					QuickTween(pillBg,  0.25, {BackgroundColor3 = T("Toggle")})
					QuickTween(pillDot, 0.25, {Position = UDim2.new(1, -19, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255,255,255)})
				else
					QuickTween(pillBg,  0.25, {BackgroundColor3 = T("Surface")})
					QuickTween(pillDot, 0.25, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = T("TextDim")})
				end
				task.spawn(cfg2.Callback, Toggle.Value)
				AutoSaveTrigger()
			end

			Toggle:Set(Toggle.Value)

			AddConn(frame.MouseEnter, function()
				QuickTween(frame, 0.18, {BackgroundColor3 = T("Surface")})
			end)
			AddConn(frame.MouseLeave, function()
				QuickTween(frame, 0.18, {BackgroundColor3 = T("SurfaceAlt")})
			end)
			AddConn(frame.MouseButton1Up, function()
				Toggle:Set(not Toggle.Value)
			end)
			AddConn(frame.TouchTap, function()
				Toggle:Set(not Toggle.Value)
			end)

			if cfg2.Flag then
				Nova.Flags[cfg2.Flag] = Toggle
			end
			return Toggle
		end

		-- Slider
		function ItemFunctions:AddSlider(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text      = cfg2.Text      or "Slider"
			cfg2.Min       = cfg2.Min       or 0
			cfg2.Max       = cfg2.Max       or 100
			cfg2.Default   = cfg2.Default   or 50
			cfg2.Increment = cfg2.Increment or 1
			cfg2.Suffix    = cfg2.Suffix    or ""
			cfg2.Callback  = cfg2.Callback  or function() end
			cfg2.Flag      = cfg2.Flag      or nil
			cfg2.Save      = cfg2.Save      or false

			local Slider = {Value = cfg2.Default, Type = "Slider", Save = cfg2.Save}
			local dragging = false

			local frame = New("Frame", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 56),
				BackgroundColor3 = T("SurfaceAlt"),
				BorderSizePixel  = 0,
			}, {
				Corner(8),
				New("UIStroke", {Color = T("Border"), Thickness = 1}),
			})

			local topRow = New("Frame", {
				Parent           = frame,
				Size             = UDim2.new(1, -24, 0, 20),
				Position         = UDim2.new(0, 12, 0, 8),
				BackgroundTransparency = 1,
			})

			local nameLbl = New("TextLabel", {
				Parent           = topRow,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 14,
				TextColor3       = T("Text"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0.7, 0, 1, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			local valLbl = New("TextLabel", {
				Parent           = topRow,
				Text             = tostring(cfg2.Default) .. cfg2.Suffix,
				Font             = Enum.Font.GothamBold,
				TextSize         = 13,
				TextColor3       = T("Accent"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0.3, 0, 1, 0),
				Position         = UDim2.new(0.7, 0, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Right,
			})

			local trackBg = New("Frame", {
				Parent           = frame,
				Size             = UDim2.new(1, -24, 0, 6),
				Position         = UDim2.new(0, 12, 0, 36),
				BackgroundColor3 = T("Surface"),
				BorderSizePixel  = 0,
			}, {Corner(4)})

			local trackFill = New("Frame", {
				Parent           = trackBg,
				Size             = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = T("Accent"),
				BorderSizePixel  = 0,
			}, {Corner(4)})

			local thumb = New("Frame", {
				Parent           = trackBg,
				Size             = UDim2.new(0, 14, 0, 14),
				AnchorPoint      = Vector2.new(0.5, 0.5),
				Position         = UDim2.new(0, 0, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel  = 0,
			}, {Corner(8), New("UIStroke", {Color = T("Accent"), Thickness = 2})})

			Nova:_listen(function()
				frame.BackgroundColor3    = T("SurfaceAlt")
				frame.UIStroke.Color      = T("Border")
				nameLbl.TextColor3        = T("Text")
				valLbl.TextColor3         = T("Accent")
				trackBg.BackgroundColor3  = T("Surface")
				trackFill.BackgroundColor3= T("Accent")
				thumb.UIStroke.Color      = T("Accent")
			end)

			local function UpdateSlider(rawX)
				local rel   = math.clamp(rawX - trackBg.AbsolutePosition.X, 0, trackBg.AbsoluteSize.X)
				local pct   = rel / trackBg.AbsoluteSize.X
				local steps = (cfg2.Max - cfg2.Min) / cfg2.Increment
				local val   = cfg2.Min + math.round(pct * steps) * cfg2.Increment
				val         = math.clamp(val, cfg2.Min, cfg2.Max)
				Slider.Value = val
				local fillPct = (val - cfg2.Min) / (cfg2.Max - cfg2.Min)
				QuickTween(trackFill, 0.07, {Size = UDim2.new(fillPct, 0, 1, 0)}, Enum.EasingStyle.Linear)
				QuickTween(thumb,     0.07, {Position = UDim2.new(fillPct, 0, 0.5, 0)}, Enum.EasingStyle.Linear)
				valLbl.Text = tostring(val) .. cfg2.Suffix
				task.spawn(cfg2.Callback, val)
				AutoSaveTrigger()
			end

			function Slider:Set(val)
				val         = math.clamp(val, cfg2.Min, cfg2.Max)
				self.Value  = val
				local pct   = (val - cfg2.Min) / (cfg2.Max - cfg2.Min)
				QuickTween(trackFill, 0.15, {Size = UDim2.new(pct, 0, 1, 0)}, Enum.EasingStyle.Linear)
				QuickTween(thumb,     0.15, {Position = UDim2.new(pct, 0, 0.5, 0)}, Enum.EasingStyle.Linear)
				valLbl.Text = tostring(val) .. cfg2.Suffix
				task.spawn(cfg2.Callback, val)
			end

			Slider:Set(Slider.Value)

			-- Desktop input
			AddConn(trackBg.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					UpdateSlider(input.Position.X)
				end
			end)
			AddConn(trackBg.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			AddConn(UserInputService.InputChanged, function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					UpdateSlider(input.Position.X)
				end
			end)

			-- Mobile touch
			AddConn(trackBg.TouchPan, function(positions, _, _, state)
				if state ~= Enum.UserInputState.End then
					UpdateSlider(positions[1].X)
				end
			end)

			if cfg2.Flag then
				Nova.Flags[cfg2.Flag] = Slider
			end
			return Slider
		end

		-- Dropdown
		function ItemFunctions:AddDropdown(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text     = cfg2.Text     or "Dropdown"
			cfg2.Options  = cfg2.Options  or {}
			cfg2.Default  = cfg2.Default  or nil
			cfg2.Callback = cfg2.Callback or function() end
			cfg2.Flag     = cfg2.Flag     or nil
			cfg2.Save     = cfg2.Save     or false

			local Dropdown = {Value = cfg2.Default, Type = "Dropdown", Save = cfg2.Save, Options = cfg2.Options}
			local isOpen   = false

			local outerFrame = New("Frame", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundTransparency = 1,
				BorderSizePixel  = 0,
				ClipsDescendants = false,
			})

			local headerBtn = New("TextButton", {
				Parent           = outerFrame,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = T("SurfaceAlt"),
				Text             = "",
				BorderSizePixel  = 0,
				AutoButtonColor  = false,
			}, {
				Corner(8),
				New("UIStroke", {Color = T("Border"), Thickness = 1}),
			})

			local nameLbl = New("TextLabel", {
				Parent           = headerBtn,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 14,
				TextColor3       = T("Text"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0.55, 0, 1, 0),
				Position         = UDim2.new(0, 12, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			local selLbl = New("TextLabel", {
				Parent           = headerBtn,
				Text             = cfg2.Default or "Select...",
				Font             = Enum.Font.Gotham,
				TextSize         = 13,
				TextColor3       = T("Accent"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0.35, 0, 1, 0),
				Position         = UDim2.new(0.55, 0, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Right,
			})

			local arrowLbl = New("TextLabel", {
				Parent           = headerBtn,
				Text             = "▾",
				Font             = Enum.Font.GothamBold,
				TextSize         = 14,
				TextColor3       = T("TextDim"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0, 22, 1, 0),
				Position         = UDim2.new(1, -26, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Center,
			})

			-- Dropdown list (renders above other elements using ZIndex)
			local listFrame = New("Frame", {
				Parent           = outerFrame,
				Size             = UDim2.new(1, 0, 0, 0),
				Position         = UDim2.new(0, 0, 0, 42),
				BackgroundColor3 = T("Surface"),
				BorderSizePixel  = 0,
				Visible          = false,
				ZIndex           = 10,
				ClipsDescendants = true,
			}, {
				Corner(8),
				Padding(4, 4, 4, 4),
				New("UIStroke", {Color = T("Border"), Thickness = 1}),
				ListLayout(3),
			})

			Nova:_listen(function()
				headerBtn.BackgroundColor3 = T("SurfaceAlt")
				headerBtn.UIStroke.Color   = T("Border")
				nameLbl.TextColor3         = T("Text")
				selLbl.TextColor3          = T("Accent")
				arrowLbl.TextColor3        = T("TextDim")
				listFrame.BackgroundColor3 = T("Surface")
				listFrame.UIStroke.Color   = T("Border")
			end)

			local optionBtns = {}

			local function RebuildOptions()
				for _, b in ipairs(optionBtns) do b:Destroy() end
				optionBtns = {}
				for _, opt in ipairs(Dropdown.Options) do
					local btn = New("TextButton", {
						Parent           = listFrame,
						Size             = UDim2.new(1, 0, 0, 30),
						BackgroundColor3 = T("SurfaceAlt"),
						Text             = "",
						AutoButtonColor  = false,
						BorderSizePixel  = 0,
						ZIndex           = 11,
					}, {Corner(6)})
					local olbl = New("TextLabel", {
						Parent           = btn,
						Text             = tostring(opt),
						Font             = Enum.Font.Gotham,
						TextSize         = 13,
						TextColor3       = T("Text"),
						BackgroundTransparency = 1,
						Size             = UDim2.new(1, -20, 1, 0),
						Position         = UDim2.new(0, 10, 0, 0),
						TextXAlignment   = Enum.TextXAlignment.Left,
						ZIndex           = 12,
					})
					Nova:_listen(function()
						btn.BackgroundColor3  = T("SurfaceAlt")
						olbl.TextColor3       = T("Text")
					end)
					AddConn(btn.MouseEnter, function()
						QuickTween(btn, 0.15, {BackgroundColor3 = T("Background")})
					end)
					AddConn(btn.MouseLeave, function()
						QuickTween(btn, 0.15, {BackgroundColor3 = T("SurfaceAlt")})
					end)
					AddConn(btn.MouseButton1Up, function()
						Dropdown:Set(opt)
					end)
					AddConn(btn.TouchTap, function()
						Dropdown:Set(opt)
					end)
					table.insert(optionBtns, btn)
				end
			end

			local function OpenDropdown()
				isOpen = true
				listFrame.Visible = true
				local h = math.min(#Dropdown.Options * 34 + 8, 180)
				QuickTween(listFrame, 0.25, {Size = UDim2.new(1, 0, 0, h)}, Enum.EasingStyle.Back)
				QuickTween(outerFrame, 0.25, {Size = UDim2.new(1, 0, 0, 38 + h + 6)})
				QuickTween(arrowLbl, 0.2, {TextTransparency = 0})
				arrowLbl.Text = "▴"
			end

			local function CloseDropdown()
				isOpen = false
				QuickTween(listFrame, 0.2, {Size = UDim2.new(1, 0, 0, 0)})
				QuickTween(outerFrame, 0.2, {Size = UDim2.new(1, 0, 0, 38)})
				arrowLbl.Text = "▾"
				task.wait(0.22)
				listFrame.Visible = false
			end

			AddConn(headerBtn.MouseButton1Up, function()
				if isOpen then CloseDropdown() else OpenDropdown() end
			end)
			AddConn(headerBtn.TouchTap, function()
				if isOpen then CloseDropdown() else OpenDropdown() end
			end)

			function Dropdown:Set(val)
				self.Value = val
				selLbl.Text = tostring(val)
				task.spawn(cfg2.Callback, val)
				AutoSaveTrigger()
				CloseDropdown()
			end

			function Dropdown:Refresh(options)
				self.Options = options
				RebuildOptions()
			end

			RebuildOptions()

			if cfg2.Default then
				selLbl.Text = tostring(cfg2.Default)
			end

			if cfg2.Flag then
				Nova.Flags[cfg2.Flag] = Dropdown
			end
			return Dropdown
		end

		-- Textbox
		function ItemFunctions:AddTextbox(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text        = cfg2.Text        or "Textbox"
			cfg2.Placeholder = cfg2.Placeholder or "Enter text..."
			cfg2.Default     = cfg2.Default     or ""
			cfg2.Callback    = cfg2.Callback    or function() end
			cfg2.Flag        = cfg2.Flag        or nil
			cfg2.Save        = cfg2.Save        or false
			cfg2.ClearOnFocus= (cfg2.ClearOnFocus == nil) and false or cfg2.ClearOnFocus

			local Textbox = {Value = cfg2.Default, Type = "Textbox", Save = cfg2.Save}

			local frame = New("Frame", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 56),
				BackgroundColor3 = T("SurfaceAlt"),
				BorderSizePixel  = 0,
			}, {Corner(8), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			local lbl = New("TextLabel", {
				Parent           = frame,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 13,
				TextColor3       = T("TextDim"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, -20, 0, 16),
				Position         = UDim2.new(0, 12, 0, 6),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			local inputBg = New("Frame", {
				Parent           = frame,
				Size             = UDim2.new(1, -24, 0, 26),
				Position         = UDim2.new(0, 12, 0, 24),
				BackgroundColor3 = T("Surface"),
				BorderSizePixel  = 0,
			}, {Corner(6), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			local inputBox = New("TextBox", {
				Parent           = inputBg,
				Size             = UDim2.new(1, -16, 1, 0),
				Position         = UDim2.new(0, 8, 0, 0),
				BackgroundTransparency = 1,
				PlaceholderText  = cfg2.Placeholder,
				Text             = cfg2.Default,
				Font             = Enum.Font.Gotham,
				TextSize         = 13,
				TextColor3       = T("Text"),
				PlaceholderColor3= T("TextDim"),
				ClearTextOnFocus = cfg2.ClearOnFocus,
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			Nova:_listen(function()
				frame.BackgroundColor3  = T("SurfaceAlt")
				frame.UIStroke.Color    = T("Border")
				lbl.TextColor3          = T("TextDim")
				inputBg.BackgroundColor3= T("Surface")
				inputBg.UIStroke.Color  = T("Border")
				inputBox.TextColor3     = T("Text")
				inputBox.PlaceholderColor3 = T("TextDim")
			end)

			AddConn(inputBox.Focused, function()
				QuickTween(inputBg.UIStroke, 0.15, {Color = T("Accent")})
			end)
			AddConn(inputBox.FocusLost, function(enter)
				QuickTween(inputBg.UIStroke, 0.15, {Color = T("Border")})
				Textbox.Value = inputBox.Text
				task.spawn(cfg2.Callback, inputBox.Text, enter)
				AutoSaveTrigger()
			end)

			function Textbox:Set(val)
				self.Value   = val
				inputBox.Text = val
				task.spawn(cfg2.Callback, val, false)
			end

			if cfg2.Flag then
				Nova.Flags[cfg2.Flag] = Textbox
			end
			return Textbox
		end

		-- Keybind
		function ItemFunctions:AddKeybind(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text     = cfg2.Text     or "Keybind"
			cfg2.Default  = cfg2.Default  or Enum.KeyCode.Unknown
			cfg2.Callback = cfg2.Callback or function() end
			cfg2.Flag     = cfg2.Flag     or nil
			cfg2.Save     = cfg2.Save     or false

			local Keybind = {Value = cfg2.Default, Type = "Keybind", Save = cfg2.Save}
			local listening = false

			local BlackList = {
				Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
				Enum.KeyCode.Space, Enum.KeyCode.Tab, Enum.KeyCode.Escape,
				Enum.KeyCode.Unknown,
			}

			local function KeyName(k)
				local n = tostring(k):gsub("Enum.KeyCode.", "")
				return n
			end

			local frame = New("TextButton", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = T("SurfaceAlt"),
				Text             = "",
				AutoButtonColor  = false,
				BorderSizePixel  = 0,
			}, {Corner(8), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			local lbl = New("TextLabel", {
				Parent           = frame,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 14,
				TextColor3       = T("Text"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(0.6, 0, 1, 0),
				Position         = UDim2.new(0, 12, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			local keyBadge = New("Frame", {
				Parent           = frame,
				Size             = UDim2.new(0, 60, 0, 24),
				Position         = UDim2.new(1, -72, 0.5, 0),
				AnchorPoint      = Vector2.new(0, 0.5),
				BackgroundColor3 = T("Surface"),
				BorderSizePixel  = 0,
			}, {Corner(6), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			local keyLbl = New("TextLabel", {
				Parent           = keyBadge,
				Text             = KeyName(cfg2.Default),
				Font             = Enum.Font.GothamBold,
				TextSize         = 12,
				TextColor3       = T("Accent"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, 0, 1, 0),
				TextXAlignment   = Enum.TextXAlignment.Center,
			})

			Nova:_listen(function()
				frame.BackgroundColor3    = T("SurfaceAlt")
				frame.UIStroke.Color      = T("Border")
				lbl.TextColor3            = T("Text")
				keyBadge.BackgroundColor3 = T("Surface")
				keyBadge.UIStroke.Color   = T("Border")
				keyLbl.TextColor3         = T("Accent")
			end)

			AddConn(frame.MouseButton1Up, function()
				listening = true
				keyLbl.Text = "..."
				QuickTween(keyBadge.UIStroke, 0.15, {Color = T("Accent")})
			end)
			AddConn(frame.TouchTap, function()
				listening = true
				keyLbl.Text = "..."
				QuickTween(keyBadge.UIStroke, 0.15, {Color = T("Accent")})
			end)

			AddConn(UserInputService.InputBegan, function(input, gameProcessed)
				if listening and input.UserInputType == Enum.UserInputType.Keyboard then
					local bad = false
					for _, k in ipairs(BlackList) do
						if input.KeyCode == k then bad = true break end
					end
					if not bad then
						Keybind.Value = input.KeyCode
						keyLbl.Text   = KeyName(input.KeyCode)
					else
						keyLbl.Text = KeyName(Keybind.Value)
					end
					listening = false
					QuickTween(keyBadge.UIStroke, 0.15, {Color = T("Border")})
					AutoSaveTrigger()
				elseif not listening and not gameProcessed
				       and input.KeyCode == Keybind.Value then
					task.spawn(cfg2.Callback, Keybind.Value)
				end
			end)

			function Keybind:Set(k)
				self.Value  = k
				keyLbl.Text = KeyName(k)
			end

			if cfg2.Flag then
				Nova.Flags[cfg2.Flag] = Keybind
			end
			return Keybind
		end

		-- ColorPicker
		function ItemFunctions:AddColorPicker(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text     = cfg2.Text     or "Color Picker"
			cfg2.Default  = cfg2.Default  or Color3.fromRGB(255, 100, 100)
			cfg2.Callback = cfg2.Callback or function() end
			cfg2.Flag     = cfg2.Flag     or nil
			cfg2.Save     = cfg2.Save     or false

			local CP    = {Value = cfg2.Default, Type = "ColorPicker", Save = cfg2.Save, Toggled = false}
			local ColorH, ColorS, ColorV = Color3.toHSV(cfg2.Default)
			local ColorInput, HueInput

			local outerFrame = New("Frame", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundTransparency = 1,
				BorderSizePixel  = 0,
			})

			local headerBtn = New("TextButton", {
				Parent           = outerFrame,
				Size             = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = T("SurfaceAlt"),
				Text             = "",
				BorderSizePixel  = 0,
				AutoButtonColor  = false,
			}, {Corner(8), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			local lbl = New("TextLabel", {
				Parent           = headerBtn,
				Text             = cfg2.Text,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 14,
				TextColor3       = T("Text"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, -60, 1, 0),
				Position         = UDim2.new(0, 12, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
			})

			local colorPreview = New("Frame", {
				Parent           = headerBtn,
				Size             = UDim2.new(0, 26, 0, 26),
				Position         = UDim2.new(1, -38, 0.5, 0),
				AnchorPoint      = Vector2.new(0, 0.5),
				BackgroundColor3 = cfg2.Default,
				BorderSizePixel  = 0,
			}, {Corner(6), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			-- Picker panel
			local pickerPanel = New("Frame", {
				Parent           = outerFrame,
				Size             = UDim2.new(1, 0, 0, 0),
				Position         = UDim2.new(0, 0, 0, 42),
				BackgroundColor3 = T("Surface"),
				BorderSizePixel  = 0,
				Visible          = false,
				ZIndex           = 8,
				ClipsDescendants = true,
			}, {Corner(8), New("UIStroke", {Color = T("Border"), Thickness = 1})})

			-- SV canvas
			local svCanvas = New("ImageLabel", {
				Parent           = pickerPanel,
				Size             = UDim2.new(1, -36, 1, -12),
				Position         = UDim2.new(0, 6, 0, 6),
				Image            = "rbxassetid://4155801252",
				BorderSizePixel  = 0,
				ZIndex           = 9,
			})

			local svThumb = New("Frame", {
				Parent           = svCanvas,
				Size             = UDim2.new(0, 12, 0, 12),
				AnchorPoint      = Vector2.new(0.5, 0.5),
				Position         = UDim2.new(ColorS, 0, 1 - ColorV, 0),
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel  = 0,
				ZIndex           = 10,
			}, {Corner(6), New("UIStroke", {Color = Color3.fromRGB(0,0,0), Thickness = 1.5})})

			-- Hue strip
			local hueStrip = New("ImageLabel", {
				Parent           = pickerPanel,
				Size             = UDim2.new(0, 18, 1, -12),
				Position         = UDim2.new(1, -24, 0, 6),
				BorderSizePixel  = 0,
				Image            = "rbxassetid://4155805446",
				ZIndex           = 9,
			})

			local hueThumb = New("Frame", {
				Parent           = hueStrip,
				Size             = UDim2.new(1, 4, 0, 4),
				AnchorPoint      = Vector2.new(0.5, 0.5),
				Position         = UDim2.new(0.5, 0, 1 - ColorH, 0),
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel  = 0,
				ZIndex           = 10,
			}, {Corner(3), New("UIStroke", {Color = Color3.fromRGB(0,0,0), Thickness = 1})})

			Nova:_listen(function()
				headerBtn.BackgroundColor3  = T("SurfaceAlt")
				headerBtn.UIStroke.Color    = T("Border")
				lbl.TextColor3              = T("Text")
				colorPreview.UIStroke.Color = T("Border")
				pickerPanel.BackgroundColor3= T("Surface")
				pickerPanel.UIStroke.Color  = T("Border")
			end)

			local function UpdateColor()
				local c = Color3.fromHSV(ColorH, ColorS, ColorV)
				CP.Value = c
				colorPreview.BackgroundColor3 = c
				svCanvas.BackgroundColor3     = Color3.fromHSV(ColorH, 1, 1)
				task.spawn(cfg2.Callback, c)
				AutoSaveTrigger()
			end

			-- SV drag
			AddConn(svCanvas.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if ColorInput then ColorInput:Disconnect() end
					ColorInput = AddConn(RunService.Heartbeat, function()
						local mx = Mouse.X
						local my = Mouse.Y
						local px = svCanvas.AbsolutePosition.X
						local py = svCanvas.AbsolutePosition.Y
						local pw = svCanvas.AbsoluteSize.X
						local ph = svCanvas.AbsoluteSize.Y
						ColorS = math.clamp((mx - px) / pw, 0, 1)
						ColorV = 1 - math.clamp((my - py) / ph, 0, 1)
						svThumb.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
						UpdateColor()
					end)
				end
			end)
			AddConn(svCanvas.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if ColorInput then ColorInput:Disconnect() ColorInput = nil end
				end
			end)

			-- Hue drag
			AddConn(hueStrip.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if HueInput then HueInput:Disconnect() end
					HueInput = AddConn(RunService.Heartbeat, function()
						local my = Mouse.Y
						local py = hueStrip.AbsolutePosition.Y
						local ph = hueStrip.AbsoluteSize.Y
						ColorH = 1 - math.clamp((my - py) / ph, 0, 1)
						hueThumb.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)
						UpdateColor()
					end)
				end
			end)
			AddConn(hueStrip.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if HueInput then HueInput:Disconnect() HueInput = nil end
				end
			end)

			-- Mobile touch SV
			AddConn(svCanvas.TouchPan, function(positions, _, _, state)
				if state ~= Enum.UserInputState.End then
					local px = svCanvas.AbsolutePosition.X
					local py = svCanvas.AbsolutePosition.Y
					local pw = svCanvas.AbsoluteSize.X
					local ph = svCanvas.AbsoluteSize.Y
					ColorS = math.clamp((positions[1].X - px) / pw, 0, 1)
					ColorV = 1 - math.clamp((positions[1].Y - py) / ph, 0, 1)
					svThumb.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
					UpdateColor()
				end
			end)

			-- Mobile touch Hue
			AddConn(hueStrip.TouchPan, function(positions, _, _, state)
				if state ~= Enum.UserInputState.End then
					local py = hueStrip.AbsolutePosition.Y
					local ph = hueStrip.AbsoluteSize.Y
					ColorH = 1 - math.clamp((positions[1].Y - py) / ph, 0, 1)
					hueThumb.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)
					UpdateColor()
				end
			end)

			-- Open/close
			AddConn(headerBtn.MouseButton1Up, function()
				CP.Toggled = not CP.Toggled
				if CP.Toggled then
					pickerPanel.Visible = true
					QuickTween(pickerPanel, 0.3, {Size = UDim2.new(1, 0, 0, 140)}, Enum.EasingStyle.Back)
					QuickTween(outerFrame,  0.3, {Size = UDim2.new(1, 0, 0, 38 + 146)})
				else
					QuickTween(pickerPanel, 0.25, {Size = UDim2.new(1, 0, 0, 0)})
					QuickTween(outerFrame,  0.25, {Size = UDim2.new(1, 0, 0, 38)})
					task.wait(0.28)
					pickerPanel.Visible = false
				end
			end)
			AddConn(headerBtn.TouchTap, function()
				CP.Toggled = not CP.Toggled
				if CP.Toggled then
					pickerPanel.Visible = true
					QuickTween(pickerPanel, 0.3, {Size = UDim2.new(1, 0, 0, 140)}, Enum.EasingStyle.Back)
					QuickTween(outerFrame,  0.3, {Size = UDim2.new(1, 0, 0, 38 + 146)})
				else
					QuickTween(pickerPanel, 0.25, {Size = UDim2.new(1, 0, 0, 0)})
					QuickTween(outerFrame,  0.25, {Size = UDim2.new(1, 0, 0, 38)})
					task.wait(0.28)
					pickerPanel.Visible = false
				end
			end)

			function CP:Set(color)
				self.Value = color
				colorPreview.BackgroundColor3 = color
				ColorH, ColorS, ColorV = Color3.toHSV(color)
				svThumb.Position  = UDim2.new(ColorS, 0, 1 - ColorV, 0)
				hueThumb.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)
				svCanvas.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				task.spawn(cfg2.Callback, color)
			end

			CP:Set(CP.Value)

			if cfg2.Flag then
				Nova.Flags[cfg2.Flag] = CP
			end
			return CP
		end

		-- Section
		function ItemFunctions:AddSection(cfg2)
			cfg2 = cfg2 or {}
			cfg2.Text = cfg2.Text or "Section"

			local sectionWrap = New("Frame", {
				Parent           = ItemParent,
				Size             = UDim2.new(1, 0, 0, 28),
				BackgroundTransparency = 1,
				BorderSizePixel  = 0,
			})

			local sectionHeader = New("Frame", {
				Parent           = sectionWrap,
				Size             = UDim2.new(1, 0, 0, 24),
				BackgroundTransparency = 1,
			})

			New("Frame", {
				Parent           = sectionHeader,
				Size             = UDim2.new(0, 3, 0, 14),
				Position         = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint      = Vector2.new(0, 0.5),
				BackgroundColor3 = T("Accent"),
				BorderSizePixel  = 0,
			}, {Corner(2)})

			local sectionLbl = New("TextLabel", {
				Parent           = sectionHeader,
				Text             = cfg2.Text:upper(),
				Font             = Enum.Font.GothamBold,
				TextSize         = 11,
				TextColor3       = T("TextDim"),
				BackgroundTransparency = 1,
				Size             = UDim2.new(1, -12, 1, 0),
				Position         = UDim2.new(0, 10, 0, 0),
				TextXAlignment   = Enum.TextXAlignment.Left,
				LetterSpacing    = 1,
			})

			local sectionContent = New("Frame", {
				Parent           = sectionWrap,
				Size             = UDim2.new(1, 0, 0, 0),
				Position         = UDim2.new(0, 0, 0, 28),
				BackgroundTransparency = 1,
			}, {ListLayout(4)})

			Nova:_listen(function()
				sectionLbl.TextColor3 = T("TextDim")
				sectionHeader:FindFirstChildOfClass("Frame").BackgroundColor3 = T("Accent")
			end)

			AddConn(sectionContent.UIListLayout.Changed, function()
				sectionContent.Size = UDim2.new(1, 0, 0, sectionContent.UIListLayout.AbsoluteContentSize.Y)
				sectionWrap.Size    = UDim2.new(1, 0, 0, sectionContent.UIListLayout.AbsoluteContentSize.Y + 32)
			end)

			return MakeItemFunctions(sectionContent, tabRef)
		end

		return ItemFunctions
	end

	-- ══════════════════════════════════════════════
	--  AddTab
	-- ══════════════════════════════════════════════
	function Window:AddTab(cfg2)
		cfg2 = cfg2 or {}
		cfg2.Text = cfg2.Text or "Tab"
		cfg2.Icon = cfg2.Icon or ""

		local isActive = false

		-- Tab button
		local tabBtn = New("TextButton", {
			Parent           = TabBar,
			Size             = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = T("Background"),
			Text             = "",
			AutoButtonColor  = false,
			BorderSizePixel  = 0,
		}, {Corner(8)})

		local accentLine = New("Frame", {
			Parent           = tabBtn,
			Size             = UDim2.new(0, 3, 0, 20),
			Position         = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundColor3 = T("Accent"),
			BorderSizePixel  = 0,
			Visible          = false,
		}, {Corner(3)})

		local tabLbl = New("TextLabel", {
			Parent           = tabBtn,
			Text             = cfg2.Text,
			Font             = Enum.Font.GothamSemibold,
			TextSize         = 13,
			TextColor3       = T("TextDim"),
			BackgroundTransparency = 1,
			Size             = UDim2.new(1, -14, 1, 0),
			Position         = UDim2.new(0, 10, 0, 0),
			TextXAlignment   = Enum.TextXAlignment.Left,
		})

		-- Content scrollframe
		local content = New("ScrollingFrame", {
			Parent             = ContentArea,
			Size               = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel    = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = T("Scrollbar"),
			CanvasSize         = UDim2.new(0, 0, 0, 0),
			Visible            = false,
		}, {
			Padding(12, 12, 12, 12),
			ListLayout(8),
		})

		Nova:_listen(function()
			tabBtn.BackgroundColor3  = isActive and T("SurfaceAlt") or T("Background")
			accentLine.BackgroundColor3 = T("Accent")
			tabLbl.TextColor3 = isActive and T("Text") or T("TextDim")
			content.ScrollBarImageColor3 = T("Scrollbar")
		end)

		AddConn(content.UIListLayout.Changed, function()
			content.CanvasSize = UDim2.new(0, 0, 0, content.UIListLayout.AbsoluteContentSize.Y + 24)
		end)

		local function Activate()
			-- Deactivate all other tabs
			for _, t in ipairs(tabs) do
				if t ~= tabBtn then
					t._deactivate()
				end
			end
			isActive = true
			content.Visible = true
			QuickTween(tabBtn, 0.2, {BackgroundColor3 = T("SurfaceAlt")})
			QuickTween(tabLbl, 0.2, {TextColor3 = T("Text")})
			accentLine.Visible = true
		end

		local function Deactivate()
			isActive = false
			content.Visible = false
			QuickTween(tabBtn, 0.2, {BackgroundColor3 = T("Background")})
			QuickTween(tabLbl, 0.2, {TextColor3 = T("TextDim")})
			accentLine.Visible = false
		end

		local entry = {_deactivate = Deactivate, _activate = Activate}
		table.insert(tabs, entry)

		if firstTab then
			firstTab = false
			Activate()
		end

		AddConn(tabBtn.MouseButton1Up, Activate)
		AddConn(tabBtn.TouchTap, Activate)
		AddConn(tabBtn.MouseEnter, function()
			if not isActive then
				QuickTween(tabBtn, 0.15, {BackgroundColor3 = T("Surface")})
			end
		end)
		AddConn(tabBtn.MouseLeave, function()
			if not isActive then
				QuickTween(tabBtn, 0.15, {BackgroundColor3 = T("Background")})
			end
		end)

		return MakeItemFunctions(content, entry)
	end

	-- ══════════════════════════════════════════════
	--  AddConfig (Theme Selector Tab)
	-- ══════════════════════════════════════════════
	function Window:AddConfig()
		local configTab = self:AddTab({Text = "⚙ Config"})

		local themeSection = configTab:AddSection({Text = "Themes"})

		local themeNames = {}
		for name in pairs(Nova.Themes) do
			table.insert(themeNames, name)
		end
		table.sort(themeNames)

		themeSection:AddDropdown({
			Text     = "Theme",
			Options  = themeNames,
			Default  = Nova.SelectedTheme,
			Callback = function(selected)
				if Nova.Themes[selected] then
					Nova.SelectedTheme = selected
					Nova:_onThemeChanged()
					Nova:Notify({
						Title   = "Theme Changed",
						Message = "Applied theme: " .. selected,
						Type    = "success",
						Time    = 2,
					})
				end
			end,
		})

		local saveSection = configTab:AddSection({Text = "Configuration"})

		saveSection:AddButton({
			Text     = "Save Config",
			Callback = function()
				SaveConfig(Nova.Folder, saveKey)
				Nova:Notify({Title = "Saved", Message = "Configuration saved.", Type = "success", Time = 2})
			end,
		})

		saveSection:AddButton({
			Text     = "Load Config",
			Callback = function()
				LoadConfig(Nova.Folder, saveKey)
				Nova:Notify({Title = "Loaded", Message = "Configuration loaded.", Type = "success", Time = 2})
			end,
		})

		saveSection:AddButton({
			Text     = "Reset Config",
			Callback = function()
				pcall(function()
					local path = Nova.Folder .. "/" .. saveKey .. ".json"
					if isfile and isfile(path) then
						delfile(path)
					end
				end)
				Nova:Notify({Title = "Reset", Message = "Configuration reset.", Type = "info", Time = 2})
			end,
		})
	end

	-- ══════════════════════════════════════════════
	--  Init / Flow
	-- ══════════════════════════════════════════════
	local function FinishInit()
		-- Load saved config after key/loading
		if Nova.SaveCfg then
			LoadConfig(Nova.Folder, saveKey)
		end
		-- Animate window in
		MainFrame.Size = UDim2.new(0, winSize.X, 0, 0)
		QuickTween(MainFrame, 0.45, {Size = UDim2.new(0, winSize.X, 0, winSize.Y)}, Enum.EasingStyle.Back)
	end

	local function AfterKey(success)
		if success then
			if cfg.LoadingEnabled then
				ShowLoading(cfg, FinishInit)
			else
				FinishInit()
			end
		end
	end

	-- Check saved key
	local keyValidated = false
	if cfg.KeySystem then
		pcall(function()
			local kn   = cfg.KeyJsonName or "keydata"
			local path = Nova.Folder .. "/" .. kn .. ".json"
			if cfg.KeySave and isfile and isfile(path) then
				local saved = HttpService:JSONDecode(readfile(path))
				if saved.key == cfg.Key then
					keyValidated = true
				end
			end
		end)
	end

	if cfg.KeySystem and not keyValidated then
		-- Hide main frame until validated
		MainFrame.Visible = false
		ShowKeySystem(cfg, function(ok)
			MainFrame.Visible = true
			AfterKey(ok)
		end)
	else
		AfterKey(true)
	end

	return Window
end

-- ══════════════════════════════════════════════
--  Cleanup
-- ══════════════════════════════════════════════
function Nova:Destroy()
	for _, c in ipairs(Nova.Connections) do
		pcall(function() c:Disconnect() end)
	end
	ScreenGui:Destroy()
end

return Nova
