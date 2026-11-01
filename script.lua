--[[
    DEMOTTONIA SUB v2  -  UI Library (Mobile / Delta)
    Dark + Red | Tabs on the left | Full-screen intro
    Elementi: Section, Label, Button, Toggle, Slider, Dropdown, Input, Notify
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- ========= INTRO MUSIC (edit these) =========
-- Option 1: a Roblox audio asset ID (number). 0 = off.
local INTRO_MUSIC_ID = 1846368080
-- Option 2: an .mp3 / .ogg file placed in your executor's workspace folder, e.g. "demottonia.mp3"
local INTRO_MUSIC_FILE = ""
local INTRO_MUSIC_VOLUME = 0.6

local Library = {}

-- ========= COLORI =========
local C = {
    Bg        = Color3.fromRGB(10, 8, 9),
    Side      = Color3.fromRGB(17, 10, 12),
    Card      = Color3.fromRGB(25, 15, 18),
    CardHover = Color3.fromRGB(34, 18, 22),
    Item      = Color3.fromRGB(44, 26, 30),
    Line      = Color3.fromRGB(80, 22, 30),
    Red       = Color3.fromRGB(215, 18, 34),
    RedLight  = Color3.fromRGB(255, 70, 80),
    DarkRed   = Color3.fromRGB(110, 5, 14),
    Blood     = Color3.fromRGB(150, 0, 10),
    Text      = Color3.fromRGB(245, 232, 232),
    Dim       = Color3.fromRGB(158, 124, 128),
}

-- ========= UTILITY =========
local function tween(obj, t, props, style, dir)
    local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function new(class, props, children)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = o end
    return o
end

local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r or 8)}) end
local function round() return new("UICorner", {CornerRadius = UDim.new(1, 0)}) end
local function stroke(col, th, tr)
    return new("UIStroke", {Color = col or C.Red, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
local function grad(c0, c1, rot)
    return new("UIGradient", {Color = ColorSequence.new(c0, c1), Rotation = rot or 0})
end

-- Pentagramma disegnato con frame (cerchio + stella), nessun font speciale necessario
local function drawPentagram(parent, size, col, th)
    th = th or 2
    local holder = new("Frame", {
        Size = UDim2.fromOffset(size, size), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
    })
    holder.Parent = parent
    new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, {round(), stroke(col, th, 0)}).Parent = holder
    local c = size / 2
    local R = size * 0.42
    local pts = {}
    for i = 0, 4 do
        local a = math.rad(-90 + i * 72)
        pts[i] = Vector2.new(c + R * math.cos(a), c + R * math.sin(a))
    end
    local order = {0, 2, 4, 1, 3, 0}
    for i = 1, 5 do
        local p1, p2 = pts[order[i]], pts[order[i + 1]]
        local mid, d = (p1 + p2) / 2, p2 - p1
        new("Frame", {
            Size = UDim2.fromOffset(d.Magnitude + th * 0.5, th), Position = UDim2.fromOffset(mid.X, mid.Y),
            AnchorPoint = Vector2.new(0.5, 0.5), Rotation = math.deg(math.atan2(d.Y, d.X)),
            BackgroundColor3 = col, BorderSizePixel = 0,
        }).Parent = holder
    end
    return holder
end

local function safeParent(gui)
    local ok = pcall(function()
        gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if not ok or not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

local function makeDraggable(handle, target, scaleObj)
    local dragging, startPos, startInput
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = i.Position
            startPos = target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startInput
            local s = (scaleObj and scaleObj.Scale > 0.05) and scaleObj.Scale or 1
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X / s, startPos.Y.Scale, startPos.Y.Offset + d.Y / s)
        end
    end)
end

-- ========= FULL-SCREEN INTRO =========
local function startMusic()
    local ok, snd = pcall(function()
        local id
        if INTRO_MUSIC_FILE ~= "" and getcustomasset and isfile and isfile(INTRO_MUSIC_FILE) then
            id = getcustomasset(INTRO_MUSIC_FILE)
        elseif INTRO_MUSIC_ID and INTRO_MUSIC_ID ~= 0 then
            id = "rbxassetid://" .. tostring(INTRO_MUSIC_ID)
        end
        if not id then return nil end
        local snd2 = Instance.new("Sound")
        snd2.Name = "DemottoniaIntro"
        snd2.SoundId = id
        snd2.Looped = true
        snd2.Volume = 0
        snd2.Parent = SoundService
        snd2:Play()
        tween(snd2, 2.5, {Volume = INTRO_MUSIC_VOLUME}, Enum.EasingStyle.Sine)
        return snd2
    end)
    return ok and snd or nil
end

local function stopMusic(snd)
    if not snd then return end
    pcall(function()
        local t = tween(snd, 1.8, {Volume = 0}, Enum.EasingStyle.Sine)
        t.Completed:Connect(function() snd:Destroy() end)
    end)
end

local function playIntro(gui, title, onDone)
    local rng = Random.new()
    local music = startMusic()

    local intro = new("Frame", {
        Name = "Intro", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0, ZIndex = 100, ClipsDescendants = true,
    })
    intro.Parent = gui

    local pulsing = true
    task.spawn(function()
        while pulsing do
            tween(intro, 0.7, {BackgroundColor3 = Color3.fromRGB(45, 0, 4)}, Enum.EasingStyle.Sine)
            task.wait(0.7)
            tween(intro, 0.7, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, Enum.EasingStyle.Sine)
            task.wait(0.7)
        end
    end)

    local pent = new("Frame", {
        Size = UDim2.fromOffset(320, 320), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 101,
    })
    pent.Parent = intro
    local scale = new("UIScale", {Scale = 0})
    scale.Parent = pent

    local function circle(size, th)
        local f = new("Frame", {
            Size = UDim2.fromOffset(size, size), Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 101,
        }, {new("UICorner", {CornerRadius = UDim.new(1, 0)}), stroke(C.Red, th, 0)})
        f.Parent = pent
        return f
    end
    circle(320, 3)
    circle(290, 1)

    local R = 145
    local pts = {}
    for i = 0, 4 do
        local a = math.rad(-90 + i * 72)
        pts[i] = Vector2.new(160 + R * math.cos(a), 160 + R * math.sin(a))
    end
    local order = {0, 2, 4, 1, 3, 0}
    for i = 1, 5 do
        local p1, p2 = pts[order[i]], pts[order[i + 1]]
        local mid = (p1 + p2) / 2
        local d = p2 - p1
        local line = new("Frame", {
            Size = UDim2.fromOffset(d.Magnitude, 3), Position = UDim2.fromOffset(mid.X, mid.Y),
            AnchorPoint = Vector2.new(0.5, 0.5), Rotation = math.deg(math.atan2(d.Y, d.X)),
            BackgroundColor3 = C.Red, BorderSizePixel = 0, ZIndex = 102,
        })
        line.Parent = pent
    end

    local rotConn = RunService.RenderStepped:Connect(function(dt)
        pent.Rotation = pent.Rotation + dt * 40
    end)

    tween(scale, 1.1, {Scale = 1}, Enum.EasingStyle.Back)

    local embers = true
    task.spawn(function()
        while embers do
            local s = rng:NextInteger(3, 8)
            local e = new("Frame", {
                Size = UDim2.fromOffset(s, s), BackgroundColor3 = Color3.fromRGB(rng:NextInteger(200, 255), rng:NextInteger(0, 60), 0),
                Position = UDim2.new(rng:NextNumber(), 0, 1.02, 0), BorderSizePixel = 0, ZIndex = 103,
            }, {corner(8)})
            e.Parent = intro
            local t = rng:NextNumber(1.5, 3)
            tween(e, t, {
                Position = UDim2.new(rng:NextNumber(), 0, rng:NextNumber(-0.1, 0.4), 0),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Quad)
            task.delay(t, function() e:Destroy() end)
            task.wait(0.03)
        end
    end)

    for i = 1, 24 do
        task.delay(rng:NextNumber(0.2, 1.4), function()
            local w = rng:NextInteger(8, 22)
            local drip = new("Frame", {
                Size = UDim2.new(0, w, 0, 0), Position = UDim2.new((i - 0.5) / 24, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = C.Blood, BorderSizePixel = 0, ZIndex = 104,
            }, {new("UICorner", {CornerRadius = UDim.new(0, 10)})})
            drip.Parent = intro
            tween(drip, rng:NextNumber(1.2, 2.2), {Size = UDim2.new(0, w, rng:NextNumber(0.15, 0.6), 0)}, Enum.EasingStyle.Quad)
        end)
    end

    local label = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Text = "", TextColor3 = C.Red, Font = Enum.Font.Antique,
        TextSize = 44, ZIndex = 110, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.new(0, 0, 0),
    })
    label.Parent = intro
    local sub = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0.5, 0, 0.5, 52), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Text = "ENTER THE ABYSS", TextColor3 = C.Dim, Font = Enum.Font.Code,
        TextSize = 16, TextTransparency = 1, ZIndex = 110,
    })
    sub.Parent = intro
    local prompt = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0.5, 0, 0.5, 86), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Text = "PRESS ANY BUTTON  /  TAP THE SCREEN", TextColor3 = C.RedLight,
        Font = Enum.Font.Code, TextSize = 14, TextTransparency = 1, ZIndex = 110,
    })
    prompt.Parent = intro

    task.wait(1.0)
    local up = string.upper(title)
    for i = 1, #up do
        label.Text = string.sub(up, 1, i)
        tween(label, 0.1, {TextColor3 = Color3.fromRGB(255, 40, 40)})
        task.wait(0.08)
        tween(label, 0.2, {TextColor3 = C.Red})
    end
    tween(sub, 0.6, {TextTransparency = 0})

    for _ = 1, 22 do
        label.Position = UDim2.new(0.5, rng:NextInteger(-8, 8), 0.5, rng:NextInteger(-5, 5))
        label.TextColor3 = (rng:NextInteger(1, 3) == 1) and Color3.new(1, 1, 1) or C.Red
        pent.Position = UDim2.new(0.5, rng:NextInteger(-4, 4), 0.5, rng:NextInteger(-4, 4))
        task.wait(0.04)
    end
    label.Position = UDim2.fromScale(0.5, 0.5)
    pent.Position = UDim2.fromScale(0.5, 0.5)
    label.TextColor3 = C.Red

    -- wait for a tap / click / any key
    local pressed = false
    local armedAt = os.clock() + 0.4
    local inputConn = UserInputService.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if os.clock() >= armedAt and (t == Enum.UserInputType.Keyboard or t == Enum.UserInputType.MouseButton1
            or t == Enum.UserInputType.Touch or t == Enum.UserInputType.Gamepad1) then
            pressed = true
        end
    end)
    local tap = new("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 130, AutoButtonColor = false,
    })
    tap.Parent = intro
    tap.MouseButton1Click:Connect(function()
        if os.clock() >= armedAt then pressed = true end
    end)
    task.spawn(function()
        while not pressed do
            tween(prompt, 0.8, {TextTransparency = 0}, Enum.EasingStyle.Sine)
            task.wait(0.8)
            if pressed then break end
            tween(prompt, 0.8, {TextTransparency = 0.75}, Enum.EasingStyle.Sine)
            task.wait(0.8)
        end
    end)
    while not pressed do task.wait() end
    inputConn:Disconnect()
    tap:Destroy()
    tween(prompt, 0.2, {TextTransparency = 1})

    pulsing = false
    local flood = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = C.Red, BorderSizePixel = 0, ZIndex = 120,
    })
    flood.Parent = intro
    tween(flood, 0.7, {Size = UDim2.fromScale(1, 1)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tween(scale, 0.7, {Scale = 8}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    task.wait(0.75)

    embers = false
    rotConn:Disconnect()
    intro.BackgroundTransparency = 1
    for _, v in ipairs(intro:GetChildren()) do
        if v ~= flood then v:Destroy() end
    end

    task.spawn(onDone)
    stopMusic(music)
    local t = tween(flood, 0.9, {BackgroundTransparency = 1}, Enum.EasingStyle.Sine)
    t.Completed:Wait()
    intro:Destroy()
end

-- ========= WINDOW =========
function Library:CreateWindow(title, subtitle)
    title = title or "Demottonia Sub"
    subtitle = subtitle or "v2.0  |  Delta"
    local Window = {Tabs = {}, Current = nil}

    -- remove a previous UI
    pcall(function()
        local root = (gethui and gethui()) or game:GetService("CoreGui")
        local old = root:FindFirstChild("DemottoniaSub")
        if old then old:Destroy() end
        local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
        if pg and pg:FindFirstChild("DemottoniaSub") then pg.DemottoniaSub:Destroy() end
    end)

    local gui = new("ScreenGui", {
        Name = "DemottoniaSub", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
    })
    safeParent(gui)

    local W, H = 520, 320

    -- transparency system: every registered panel follows the slider
    local glassObjs = {}
    local glassValue = 0
    local function glass(obj, base)
        base = base or 0
        table.insert(glassObjs, {obj = obj, base = base})
        obj.BackgroundTransparency = 1 - (1 - base) * (1 - glassValue)
    end

    -- ===== FINESTRA PRINCIPALE =====
    local main = new("Frame", {
        Name = "Main", Size = UDim2.fromOffset(W, H), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
        Visible = false,
    }, {corner(20)})
    main.Parent = gui
    main.Visible = false
    grad(Color3.fromRGB(24, 11, 15), Color3.fromRGB(9, 7, 9), 55).Parent = main
    glass(main, 0)

    local mscale = new("UIScale", {Scale = 0})
    mscale.Parent = main

    -- bordo animato (rosso che ruota)
    local border = new("UIStroke", {Thickness = 2, Color = Color3.new(1, 1, 1), ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    border.Parent = main
    local borderGrad = new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Red),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(45, 8, 12)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(45, 8, 12)),
            ColorSequenceKeypoint.new(1, C.Red),
        }),
    })
    borderGrad.Parent = border

    Window._spinOn = true
    local spin = RunService.RenderStepped:Connect(function(dt)
        if Window._spinOn then
            borderGrad.Rotation = (borderGrad.Rotation + dt * 90) % 360
        end
    end)
    gui.Destroying:Connect(function() spin:Disconnect() end)

    local function fit()
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(800, 400)
        local base = math.clamp(math.min((vp.X * 0.92) / W, (vp.Y * 0.85) / H), 0.4, 1)
        Window._baseScale = base * (Window._userScale or 1)
    end
    fit()

    -- ===== HEADER =====
    local header = new("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1})
    header.Parent = main

    -- logo: pentagramma rosso che ruota lentamente dentro un sigillo scuro
    local logoStroke = stroke(C.Red, 1.5, 0.2)
    local logo = new("Frame", {
        Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(14, 7), BackgroundColor3 = Color3.new(1, 1, 1),
    }, {round(), logoStroke})
    logo.Parent = header
    grad(Color3.fromRGB(70, 8, 14), Color3.fromRGB(14, 6, 8), 90).Parent = logo
    local logoPent = drawPentagram(logo, 26, C.RedLight, 1.5)
    local logoConn = RunService.RenderStepped:Connect(function(dt)
        logoPent.Rotation = (logoPent.Rotation + dt * 25) % 360
        logoStroke.Transparency = 0.25 + 0.25 * math.sin(os.clock() * 3)
    end)
    gui.Destroying:Connect(function() logoConn:Disconnect() end)

    new("TextLabel", {
        Size = UDim2.new(1, -170, 0, 20), Position = UDim2.fromOffset(54, 7), BackgroundTransparency = 1,
        Text = string.upper(title), TextColor3 = C.Text, Font = Enum.Font.GothamBlack, TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = header
    new("TextLabel", {
        Size = UDim2.new(1, -170, 0, 14), Position = UDim2.fromOffset(54, 26), BackgroundTransparency = 1,
        Text = subtitle, TextColor3 = C.Red, Font = Enum.Font.GothamBold, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }).Parent = header

    local function headerBtn(text, xOff, bg)
        local b = new("TextButton", {
            Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, xOff, 0, 10), BackgroundColor3 = bg,
            Text = text, TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false,
        }, {round(), stroke(C.Line, 1, 0.5)})
        b.Parent = header
        b.MouseEnter:Connect(function() tween(b, 0.2, {BackgroundColor3 = C.Red}) end)
        b.MouseLeave:Connect(function() tween(b, 0.2, {BackgroundColor3 = bg}) end)
        return b
    end
    local closeBtn = headerBtn("X", -44, C.Item)
    local miniBtn = headerBtn("-", -78, C.Item)

    new("Frame", {
        Size = UDim2.new(1, -32, 0, 1), Position = UDim2.fromOffset(16, 48), BackgroundColor3 = C.Line,
        BackgroundTransparency = 0.5, BorderSizePixel = 0,
    }).Parent = main

    makeDraggable(header, main, mscale)

    -- ===== SIDEBAR =====
    local side = new("Frame", {
        Size = UDim2.fromOffset(142, 252), Position = UDim2.fromOffset(12, 58), BackgroundColor3 = C.Side, BorderSizePixel = 0,
    }, {corner(16), stroke(C.Line, 1, 0.55)})
    side.Parent = main
    glass(side, 0)

    -- indicatore a pillola che scorre
    local indicator = new("Frame", {
        Size = UDim2.new(1, -16, 0, 36), Position = UDim2.fromOffset(8, 8), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, Visible = false,
    }, {corner(12), stroke(C.RedLight, 1, 0.55)})
    indicator.Parent = side
    grad(C.Red, C.DarkRed, 0).Parent = indicator

    local tabList = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -50), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, {
        new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}),
        new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
    })
    tabList.Parent = side

    -- footer profilo
    local plr = Players.LocalPlayer
    local footer = new("Frame", {
        Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 1, -44), BackgroundColor3 = C.Card, BorderSizePixel = 0,
    }, {corner(12), stroke(C.Line, 1, 0.6)})
    footer.Parent = side
    glass(footer, 0)
    local av = new("Frame", {
        Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = Color3.fromRGB(40, 8, 12),
    }, {round()})
    av.Parent = footer
    drawPentagram(av, 20, C.Red, 1)
    new("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(36, 0), BackgroundTransparency = 1,
        Text = plr.DisplayName, TextColor3 = C.Dim, Font = Enum.Font.GothamBold, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }).Parent = footer

    -- ===== CONTENUTO =====
    local pages = new("Frame", {
        Size = UDim2.fromOffset(348, 252), Position = UDim2.fromOffset(162, 58), BackgroundTransparency = 1,
        ClipsDescendants = true,
    })
    pages.Parent = main

    -- ===== NOTIFICHE =====
    local notifHolder = new("Frame", {
        Size = UDim2.new(0, 250, 1, -20), Position = UDim2.new(1, -12, 1, -10), AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
    }, {new("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
    })})
    notifHolder.Parent = gui

    function Window:Notify(ttl, text, duration)
        duration = duration or 4
        local wrap = new("Frame", {Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1})
        wrap.Parent = notifHolder
        local toast = new("Frame", {
            Size = UDim2.fromScale(1, 1), Position = UDim2.new(1, 40, 0, 0), BackgroundColor3 = C.Bg, BorderSizePixel = 0,
        }, {corner(14), stroke(C.Red, 1.5, 0.3)})
        toast.Parent = wrap
        grad(Color3.fromRGB(30, 13, 17), Color3.fromRGB(12, 8, 10), 20).Parent = toast
        toast.BackgroundColor3 = Color3.new(1, 1, 1)
        new("Frame", {
            Size = UDim2.new(0, 4, 1, -20), Position = UDim2.fromOffset(10, 10), BackgroundColor3 = C.Red, BorderSizePixel = 0,
        }, {round()}).Parent = toast
        new("TextLabel", {
            Size = UDim2.new(1, -34, 0, 18), Position = UDim2.fromOffset(24, 8), BackgroundTransparency = 1,
            Text = ttl or "Demottonia", TextColor3 = C.Text, Font = Enum.Font.GothamBlack, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        }).Parent = toast
        new("TextLabel", {
            Size = UDim2.new(1, -34, 0, 30), Position = UDim2.fromOffset(24, 26), BackgroundTransparency = 1,
            Text = text or "", TextColor3 = C.Dim, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        }).Parent = toast
        tween(toast, 0.5, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)
        task.delay(duration, function()
            local t = tween(toast, 0.4, {Position = UDim2.new(1, 60, 0, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            t.Completed:Wait()
            wrap:Destroy()
        end)
    end

    -- ===== PULSANTE FLOTTANTE =====
    local fab = new("TextButton", {
        Size = UDim2.fromOffset(60, 60), Position = UDim2.new(0, 14, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1), Text = "", Visible = false, AutoButtonColor = false,
    }, {round()})
    fab.Parent = gui
    -- hellfire background: blood red at the top fading to black
    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 8, 16)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(45, 3, 8)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 2, 3)),
        }),
        Rotation = 90,
    }).Parent = fab
    -- pulsing outer glow ring
    local glowRing = new("Frame", {
        Size = UDim2.fromOffset(70, 70), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Active = false,
    }, {round()})
    glowRing.Parent = fab
    local glowStroke = stroke(C.Red, 2, 0.4)
    glowStroke.Parent = glowRing
    -- inner border
    stroke(C.RedLight, 1.5, 0.2).Parent = fab
    -- rune ring (12 ticks) that spins the opposite way
    local runeRing = new("Frame", {
        Size = UDim2.fromOffset(54, 54), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Active = false,
    })
    runeRing.Parent = fab
    for i = 0, 11 do
        local a = math.rad(i * 30)
        new("Frame", {
            Size = UDim2.fromOffset(2, (i % 3 == 0) and 7 or 4), Position = UDim2.fromOffset(27 + 25 * math.sin(a), 27 - 25 * math.cos(a)),
            AnchorPoint = Vector2.new(0.5, 0.5), Rotation = i * 30, BackgroundColor3 = C.RedLight, BorderSizePixel = 0,
            BackgroundTransparency = 0.15,
        }).Parent = runeRing
    end
    local fabPent = drawPentagram(fab, 36, C.RedLight, 2)
    fabPent.Active = false
    local rng2 = Random.new()
    local emberAcc = 0
    local fabConn = RunService.RenderStepped:Connect(function(dt)
        if not fab.Visible then return end
        fabPent.Rotation = (fabPent.Rotation + dt * 35) % 360
        runeRing.Rotation = (runeRing.Rotation - dt * 20) % 360
        glowStroke.Transparency = 0.45 + 0.3 * math.sin(os.clock() * 3)
        emberAcc = emberAcc + dt
        if emberAcc > 0.22 then
            emberAcc = 0
            local sz = rng2:NextInteger(2, 4)
            local e = new("Frame", {
                Size = UDim2.fromOffset(sz, sz), Position = UDim2.fromOffset(rng2:NextInteger(14, 46), 8),
                BackgroundColor3 = Color3.fromRGB(255, rng2:NextInteger(30, 90), 0), BorderSizePixel = 0, Active = false,
            }, {round()})
            e.Parent = fab
            tween(e, 1.1, {Position = UDim2.fromOffset(rng2:NextInteger(10, 50), -22), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
            task.delay(1.15, function() e:Destroy() end)
        end
    end)
    gui.Destroying:Connect(function() fabConn:Disconnect() end)
    makeDraggable(fab, fab, nil)

    -- ===== APRI / CHIUDI =====
    local open = false
    local function setOpen(state)
        open = state
        if state then
            fit()
            main.Visible = true
            fab.Visible = false
            tween(mscale, 0.6, {Scale = Window._baseScale}, Enum.EasingStyle.Back)
        else
            local t = tween(mscale, 0.3, {Scale = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            t.Completed:Connect(function()
                if not open then main.Visible = false; fab.Visible = true end
            end)
        end
    end
    closeBtn.MouseButton1Click:Connect(function() setOpen(false) end)
    miniBtn.MouseButton1Click:Connect(function() setOpen(false) end)
    fab.MouseButton1Click:Connect(function() setOpen(true) end)

    -- ===== SELEZIONE TAB =====
    local function selectTab(tab)
        for _, t in ipairs(Window.Tabs) do
            local on = (t == tab)
            if on then
                t.Page.Position = UDim2.fromOffset(0, 14)
                t.Page.Visible = true
                tween(t.Page, 0.35, {Position = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Quint)
            else
                t.Page.Visible = false
            end
            tween(t.Label, 0.25, {TextColor3 = on and Color3.new(1, 1, 1) or C.Dim})
            tween(t.Dot, 0.25, {BackgroundColor3 = on and Color3.new(1, 1, 1) or C.Item})
        end
        indicator.Visible = true
        tween(indicator, 0.4, {Position = UDim2.fromOffset(8, 8 + (tab.Index - 1) * 42)}, Enum.EasingStyle.Quint)
        Window.Current = tab
    end

    -- ===== CREA TAB =====
    function Window:CreateTab(name)
        local Tab = {}
        local idx = #Window.Tabs + 1

        local btn = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = idx,
        })
        btn.Parent = tabList
        local dot = new("Frame", {
            Size = UDim2.fromOffset(8, 8), Position = UDim2.new(0, 14, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = C.Item, BorderSizePixel = 0,
        }, {round()})
        dot.Parent = btn
        local lbl = new("TextLabel", {
            Size = UDim2.new(1, -36, 1, 0), Position = UDim2.fromOffset(32, 0), BackgroundTransparency = 1,
            Text = name, TextColor3 = C.Dim, Font = Enum.Font.GothamBold, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        lbl.Parent = btn

        local page = new("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
            ScrollBarThickness = 3, ScrollBarImageColor3 = C.Red, CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, {
            new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}),
            new("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 8)}),
        })
        page.Parent = pages

        Tab.Button, Tab.Page, Tab.Label, Tab.Dot, Tab.Index = btn, page, lbl, dot, idx
        table.insert(Window.Tabs, Tab)
        btn.MouseButton1Click:Connect(function() selectTab(Tab) end)
        if idx == 1 then selectTab(Tab) end

        local function card(h)
            local f = new("Frame", {
                Size = UDim2.new(1, 0, 0, h or 40), BackgroundColor3 = C.Card, BorderSizePixel = 0, ClipsDescendants = true,
            }, {corner(14), stroke(C.Line, 1, 0.55)})
            f.Parent = page
            glass(f, 0)
            f.MouseEnter:Connect(function() tween(f, 0.2, {BackgroundColor3 = C.CardHover}) end)
            f.MouseLeave:Connect(function() tween(f, 0.2, {BackgroundColor3 = C.Card}) end)
            return f
        end

        local function text(parent, str, size, col, font, xAlign, pos, sz)
            local l = new("TextLabel", {
                Size = sz or UDim2.new(1, -24, 1, 0), Position = pos or UDim2.fromOffset(14, 0), BackgroundTransparency = 1,
                Text = str, TextColor3 = col or C.Text, Font = font or Enum.Font.GothamBold, TextSize = size or 13,
                TextXAlignment = xAlign or Enum.TextXAlignment.Left,
            })
            l.Parent = parent
            return l
        end

        -- SECTION
        function Tab:AddSection(str)
            local f = new("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1})
            f.Parent = page
            new("Frame", {
                Size = UDim2.fromOffset(4, 12), Position = UDim2.new(0, 4, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = C.Red, BorderSizePixel = 0,
            }, {round()}).Parent = f
            text(f, string.upper(str), 11, C.Red, Enum.Font.GothamBlack, nil, UDim2.fromOffset(16, 0))
        end

        -- LABEL
        function Tab:AddLabel(str)
            local f = card(32)
            local l = text(f, str, 12, C.Dim, Enum.Font.Gotham)
            local obj = {}
            function obj:SetText(s) l.Text = s end
            return obj
        end

        -- BUTTON
        function Tab:AddButton(str, callback)
            local f = card(40)
            local b = new("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = str, TextColor3 = C.Text,
                Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false,
            })
            b.Parent = f
            b.MouseButton1Click:Connect(function()
                f.BackgroundColor3 = C.Red
                tween(f, 0.45, {BackgroundColor3 = C.Card})
                if callback then task.spawn(callback) end
            end)
        end

        -- TOGGLE
        function Tab:AddToggle(str, default, callback)
            local f = card(40)
            local state = default and true or false
            text(f, str, 13, C.Text, Enum.Font.GothamBold, nil, nil, UDim2.new(1, -80, 1, 0))
            local track = new("Frame", {
                Size = UDim2.fromOffset(44, 24), Position = UDim2.new(1, -56, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and C.Red or C.Item,
            }, {round(), stroke(C.Line, 1, 0.4)})
            track.Parent = f
            local knob = new("Frame", {
                Size = UDim2.fromOffset(18, 18), Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1),
            }, {round()})
            knob.Parent = track
            local hit = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = ""})
            hit.Parent = f
            local obj = {}
            local function set(v, silent)
                state = v
                tween(track, 0.25, {BackgroundColor3 = v and C.Red or C.Item})
                tween(knob, 0.3, {Position = v and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}, Enum.EasingStyle.Back)
                if callback and not silent then task.spawn(callback, v) end
            end
            function obj:Set(v) set(v) end
            function obj:Get() return state end
            hit.MouseButton1Click:Connect(function() set(not state) end)
            if default and callback then task.spawn(callback, true) end
            return obj
        end

        -- SLIDER
        function Tab:AddSlider(str, min, max, default, callback)
            local f = card(58)
            local value = default or min
            text(f, str, 13, C.Text, Enum.Font.GothamBold, nil, UDim2.fromOffset(14, 6), UDim2.new(1, -90, 0, 22))
            local val = text(f, tostring(value), 13, C.Red, Enum.Font.GothamBlack, Enum.TextXAlignment.Right,
                UDim2.new(1, -78, 0, 6), UDim2.fromOffset(64, 22))
            local bar = new("Frame", {
                Size = UDim2.new(1, -28, 0, 8), Position = UDim2.new(0, 14, 0, 38), BackgroundColor3 = C.Item, BorderSizePixel = 0,
            }, {round()})
            bar.Parent = f
            local rel0 = (value - min) / (max - min)
            local fill = new("Frame", {
                Size = UDim2.fromScale(rel0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
            }, {round()})
            fill.Parent = bar
            grad(C.DarkRed, C.RedLight, 0).Parent = fill
            local knob = new("Frame", {
                Size = UDim2.fromOffset(16, 16), Position = UDim2.new(rel0, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 3,
            }, {round(), stroke(C.Red, 2, 0)})
            knob.Parent = bar

            local dragging = false
            local obj = {}
            local function apply(rel, silent)
                rel = math.clamp(rel, 0, 1)
                value = math.floor(min + (max - min) * rel + 0.5)
                local r2 = (value - min) / (max - min)
                tween(fill, 0.08, {Size = UDim2.fromScale(r2, 1)})
                tween(knob, 0.08, {Position = UDim2.new(r2, 0, 0.5, 0)})
                val.Text = tostring(value)
                if callback and not silent then task.spawn(callback, value) end
            end
            local function update(x)
                apply((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
            end
            function obj:Set(v) apply((v - min) / (max - min)) end
            function obj:Get() return value end

            f.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if i.Position.Y - f.AbsolutePosition.Y > f.AbsoluteSize.Y * 0.4 then
                        dragging = true
                        page.ScrollingEnabled = false
                        tween(knob, 0.15, {Size = UDim2.fromOffset(20, 20)}, Enum.EasingStyle.Back)
                        update(i.Position.X)
                    end
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    update(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                    dragging = false
                    page.ScrollingEnabled = true
                    tween(knob, 0.15, {Size = UDim2.fromOffset(16, 16)}, Enum.EasingStyle.Back)
                end
            end)
            return obj
        end

        -- DROPDOWN
        function Tab:AddDropdown(str, options, default, callback)
            local f = card(40)
            local selected = default or options[1]
            local opened = false
            local head = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
            })
            head.Parent = f
            text(head, str, 13, C.Text, Enum.Font.GothamBold, nil, nil, UDim2.new(0.5, -14, 1, 0))
            local valLbl = text(head, tostring(selected), 12, C.Red, Enum.Font.GothamBold, Enum.TextXAlignment.Right,
                UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, -36, 1, 0))
            local arrow = new("TextLabel", {
                Size = UDim2.fromOffset(20, 40), Position = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1,
                Text = ">", TextColor3 = C.Dim, Font = Enum.Font.GothamBlack, TextSize = 14,
            })
            arrow.Parent = head
            local list = new("Frame", {
                Size = UDim2.new(1, -16, 0, #options * 32), Position = UDim2.fromOffset(8, 44), BackgroundTransparency = 1,
            }, {new("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})})
            list.Parent = f

            local function setOpen2(v)
                opened = v
                tween(f, 0.35, {Size = UDim2.new(1, 0, 0, v and (50 + #options * 34) or 40)}, Enum.EasingStyle.Quint)
                tween(arrow, 0.3, {Rotation = v and 90 or 0})
            end
            for n, opt in ipairs(options) do
                local ob = new("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.Item, BackgroundTransparency = 0.4, Text = tostring(opt),
                    TextColor3 = (opt == selected) and C.Text or C.Dim, Font = Enum.Font.GothamBold, TextSize = 12,
                    AutoButtonColor = false, LayoutOrder = n,
                }, {corner(10)})
                ob.Parent = list
                ob.MouseButton1Click:Connect(function()
                    selected = opt
                    valLbl.Text = tostring(opt)
                    for _, o in ipairs(list:GetChildren()) do
                        if o:IsA("TextButton") then tween(o, 0.2, {TextColor3 = (o == ob) and C.Text or C.Dim}) end
                    end
                    setOpen2(false)
                    if callback then task.spawn(callback, opt) end
                end)
            end
            head.MouseButton1Click:Connect(function() setOpen2(not opened) end)
            if callback then task.spawn(callback, selected) end
            local obj = {}
            function obj:Get() return selected end
            return obj
        end

        -- INPUT
        function Tab:AddInput(str, placeholder, callback)
            local f = card(40)
            text(f, str, 13, C.Text, Enum.Font.GothamBold, nil, nil, UDim2.new(0.5, -14, 1, 0))
            local box = new("TextBox", {
                Size = UDim2.new(0.5, -20, 0, 26), Position = UDim2.new(0.5, 6, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = C.Item, Text = "", PlaceholderText = placeholder or "...", PlaceholderColor3 = C.Dim,
                TextColor3 = C.Text, Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false,
            }, {corner(10), stroke(C.Line, 1, 0.5)})
            box.Parent = f
            box.Focused:Connect(function() tween(box, 0.2, {BackgroundColor3 = C.DarkRed}) end)
            box.FocusLost:Connect(function(enter)
                tween(box, 0.2, {BackgroundColor3 = C.Item})
                if callback then task.spawn(callback, box.Text, enter) end
            end)
            local obj = {}
            function obj:Get() return box.Text end
            return obj
        end

        return Tab
    end

    -- UI transparency: 0 = opaque, 0.8 = very transparent
    function Window:SetTransparency(t)
        glassValue = math.clamp(t, 0, 0.85)
        for _, g in ipairs(glassObjs) do
            if g.obj.Parent then
                g.obj.BackgroundTransparency = 1 - (1 - g.base) * (1 - glassValue)
            end
        end
        border.Transparency = glassValue * 0.5
    end

    -- UI size: 0.6 - 1.0
    function Window:SetScale(s)
        Window._userScale = math.clamp(s, 0.5, 1)
        fit()
        if open then tween(mscale, 0.35, {Scale = Window._baseScale}, Enum.EasingStyle.Quint) end
    end

    function Window:SetAnimatedBorder(v)
        Window._spinOn = v and true or false
        if not v then borderGrad.Rotation = 0 end
    end

    function Window:Destroy() gui:Destroy() end

    -- intro, poi apre la finestra
    task.spawn(function()
        playIntro(gui, title, function()
            setOpen(true)
            task.delay(0.8, function()
                Window:Notify(title, "Loaded successfully. Welcome, " .. Players.LocalPlayer.DisplayName .. ".", 4)
            end)
        end)
    end)

    return Window
end

-- ================= YOUR SCRIPT =================
local Window = Library:CreateWindow("Demottonia Sub", "v2.1  |  Delta")

-- Empty tabs: add your own elements here
local MainTab = Window:CreateTab("Main")
local PlayerTab = Window:CreateTab("Player")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")

-- Settings
local Settings = Window:CreateTab("Settings")
Settings:AddSection("Appearance")
Settings:AddSlider("UI Transparency", 0, 80, 0, function(v)
    Window:SetTransparency(v / 100)
end)

local scaleToken = 0
Settings:AddSlider("UI Size", 60, 100, 100, function(v)
    scaleToken = scaleToken + 1
    local my = scaleToken
    task.delay(0.4, function()
        if my == scaleToken then Window:SetScale(v / 100) end
    end)
end)
Settings:AddToggle("Animated Border", true, function(v)
    Window:SetAnimatedBorder(v)
end)

Settings:AddSection("Other")
Settings:AddButton("Destroy UI", function() Window:Destroy() end)
