-- Lucent-style Roblox UI
-- Standalone LocalScript
-- Visual/configuration UI only.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {
    Enabled = false,
    EvasionMode = "Random",
    WeaponType = "Primary, Secondary, Melee",
    Stability = 0.15,
    ShootFrames = 1,
    RandomRadius = 100,
    RandomRadiusFactor = 0.5,
    BindMode = "Toggle",
    Keybind = "None",
    Accent = Color3.fromRGB(145, 90, 255),
    VisualsEnabled = true,
    ShowInfo = true,
    UIVisible = true,
}

local Old = PlayerGui:FindFirstChild("LucentStyleUI")
if Old then Old:Destroy() end

local function Create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0
    }, parent)
end

local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function AddPadding(parent, left, top, right, bottom)
    return Create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
    }, parent)
end

local ScreenGui = Create("ScreenGui", {
    Name = "LucentStyleUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
}, PlayerGui)

local ScaleHolder = Create("Frame", {
    Name = "ScaleHolder",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
}, ScreenGui)

local UIScale = Create("UIScale", {Scale = 0.82}, ScaleHolder)

local function UpdateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize

    if viewport.X <= 600 then
        UIScale.Scale = 0.58
    elseif viewport.X <= 900 then
        UIScale.Scale = 0.70
    else
        UIScale.Scale = 0.82
    end
end

UpdateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

local Main = Create("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(1040, 650),
    BackgroundColor3 = Color3.fromRGB(8, 8, 10),
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ScaleHolder)

Corner(Main, 18)
Stroke(Main, Color3.fromRGB(27, 27, 32), 1)

local TopBar = Create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 76),
    BackgroundColor3 = Color3.fromRGB(9, 9, 11),
    BorderSizePixel = 0,
}, Main)

Corner(TopBar, 18)

local Title = Create("TextLabel", {
    Position = UDim2.fromOffset(22, 17),
    Size = UDim2.fromOffset(115, 42),
    BackgroundColor3 = Color3.fromRGB(18, 18, 21),
    Text = "Lucent v2",
    TextColor3 = Color3.fromRGB(190, 190, 198),
    TextSize = 17,
    Font = Enum.Font.GothamMedium,
}, TopBar)

Corner(Title, 12)

local SearchBox = Create("TextBox", {
    Position = UDim2.fromOffset(150, 17),
    Size = UDim2.fromOffset(275, 42),
    BackgroundColor3 = Color3.fromRGB(14, 14, 17),
    PlaceholderText = "⌕  search",
    PlaceholderColor3 = Color3.fromRGB(90, 90, 98),
    Text = "",
    TextColor3 = Color3.fromRGB(220, 220, 225),
    TextSize = 15,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
}, TopBar)

Corner(SearchBox, 12)
Stroke(SearchBox, Color3.fromRGB(22, 22, 26), 1)

Create("TextLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -70, 0, 17),
    Size = UDim2.fromOffset(180, 24),
    BackgroundTransparency = 1,
    Text = Player.DisplayName,
    TextColor3 = Color3.fromRGB(230, 230, 235),
    TextSize = 15,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Right,
}, TopBar)

Create("TextLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -70, 0, 39),
    Size = UDim2.fromOffset(180, 20),
    BackgroundTransparency = 1,
    Text = "FREE",
    TextColor3 = Color3.fromRGB(200, 180, 65),
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Right,
}, TopBar)

local Avatar = Create("ImageLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -18, 0, 17),
    Size = UDim2.fromOffset(42, 42),
    BackgroundColor3 = Color3.fromRGB(20, 20, 23),
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150",
}, TopBar)

Corner(Avatar, 21)

local Navigation = Create("Frame", {
    Name = "Navigation",
    Position = UDim2.fromOffset(0, 76),
    Size = UDim2.fromOffset(78, 574),
    BackgroundColor3 = Color3.fromRGB(9, 9, 11),
    BorderSizePixel = 0,
}, Main)

Create("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Navigation)

AddPadding(Navigation, 0, 16, 0, 10)

local Content = Create("Frame", {
    Name = "Content",
    Position = UDim2.fromOffset(78, 76),
    Size = UDim2.new(1, -78, 1, -76),
    BackgroundColor3 = Color3.fromRGB(7, 7, 9),
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, Main)

local Pages = {}

local function CreatePage(name)
    local Page = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(50, 50, 56),
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ClipsDescendants = true,
    }, Content)

    AddPadding(Page, 28, 25, 28, 25)
    Pages[name] = Page
    return Page
end

local CurrentPage

local function CreateNavButton(icon, pageName, order)
    local Button = Create("TextButton", {
        Name = pageName .. "Button",
        Size = UDim2.fromOffset(54, 54),
        BackgroundColor3 = Color3.fromRGB(10, 10, 13),
        Text = icon,
        TextColor3 = Color3.fromRGB(100, 100, 108),
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = order,
    }, Navigation)

    Corner(Button, 13)

    local Indicator = Create("Frame", {
        Name = "Indicator",
        Position = UDim2.new(0, -3, 0.5, -12),
        Size = UDim2.fromOffset(3, 24),
        BackgroundColor3 = Config.Accent,
        BorderSizePixel = 0,
        Visible = false,
    }, Button)

    Corner(Indicator, 3)

    Button.MouseButton1Click:Connect(function()
        for name, page in pairs(Pages) do
            page.Visible = name == pageName
        end

        for _, child in ipairs(Navigation:GetChildren()) do
            if child:IsA("TextButton") then
                local active = child.Name == pageName .. "Button"

                child.BackgroundColor3 = active
                    and Color3.fromRGB(25, 22, 30)
                    or Color3.fromRGB(10, 10, 13)

                child.TextColor3 = active
                    and Color3.fromRGB(235, 235, 240)
                    or Color3.fromRGB(100, 100, 108)

                local indicator = child:FindFirstChild("Indicator")
                if indicator then indicator.Visible = active end
            end
        end

        CurrentPage = pageName
    end)

    return Button
end

local function SectionTitle(parent, text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(220, 220, 225),
        TextSize = 20,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
end

local function CreateToggle(parent, text, default, callback)
    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
    }, parent)

    Create("TextLabel", {
        Position = UDim2.fromOffset(2, 0),
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(175, 175, 183),
        TextSize = 15,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Holder)

    local Toggle = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(62, 32),
        BackgroundColor3 = default and Config.Accent or Color3.fromRGB(31, 31, 35),
        Text = "",
        AutoButtonColor = false,
    }, Holder)

    Corner(Toggle, 18)

    local Knob = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = default and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(22, 22),
        BackgroundColor3 = Color3.fromRGB(245, 245, 247),
    }, Toggle)

    Corner(Knob, 11)

    local state = default

    local function SetState(value)
        state = value

        Tween(Toggle, {
            BackgroundColor3 = state and Config.Accent or Color3.fromRGB(31, 31, 35)
        })

        Tween(Knob, {
            Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 16, 0.5, 0)
        })

        if callback then callback(state) end
    end

    Toggle.MouseButton1Click:Connect(function()
        SetState(not state)
    end)

    return SetState
end

local function CreateSlider(parent, text, minimum, maximum, default, callback)
    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 74),
        BackgroundTransparency = 1,
    }, parent)

    Create("TextLabel", {
        Position = UDim2.fromOffset(2, 0),
        Size = UDim2.new(1, -70, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(175, 175, 183),
        TextSize = 15,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Holder)

    local ValueText = Create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(70, 25),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(190, 190, 198),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, Holder)

    local Bar = Create("Frame", {
        Position = UDim2.fromOffset(2, 39),
        Size = UDim2.new(1, -2, 0, 5),
        BackgroundColor3 = Color3.fromRGB(37, 37, 42),
        BorderSizePixel = 0,
    }, Holder)

    Corner(Bar, 5)

    local Fill = Create("Frame", {
        Size = UDim2.fromScale((default - minimum) / (maximum - minimum), 1),
        BackgroundColor3 = Config.Accent,
        BorderSizePixel = 0,
    }, Bar)

    Corner(Fill, 5)

    local Knob = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((default - minimum) / (maximum - minimum), 0, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = Color3.fromRGB(240, 240, 243),
    }, Bar)

    Corner(Knob, 9)

    local dragging = false

    local function SetValue(value)
        value = math.clamp(value, minimum, maximum)
        local percent = (value - minimum) / (maximum - minimum)

        Fill.Size = UDim2.fromScale(percent, 1)
        Knob.Position = UDim2.new(percent, 0, 0.5, 0)

        if math.abs(value - math.floor(value)) < 0.001 then
            ValueText.Text = tostring(math.floor(value))
        else
            ValueText.Text = string.format("%.2f", value)
        end

        if callback then callback(value) end
    end

    local function UpdateFromX(x)
        local percent = math.clamp(
            (x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0,
            1
        )

        SetValue(minimum + (maximum - minimum) * percent)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            UpdateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return SetValue
end

local OpenDropdown

local function CreateDropdown(parent, text, options, default, callback)
    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 78),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 20,
    }, parent)

    Create("TextLabel", {
        Position = UDim2.fromOffset(2, 0),
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(125, 125, 133),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 20,
    }, Holder)

    local Button = Create("TextButton", {
        Position = UDim2.fromOffset(0, 27),
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(14, 14, 17),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 21,
    }, Holder)

    Corner(Button, 11)
    Stroke(Button, Color3.fromRGB(25, 25, 29), 1)

    Create("TextLabel", {
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -45, 1, 0),
        BackgroundTransparency = 1,
        Text = default,
        TextColor3 = Color3.fromRGB(190, 190, 197),
        TextSize = 15,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 22,
    }, Button)

    Create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        Text = "⌄",
        TextColor3 = Color3.fromRGB(150, 150, 158),
        TextSize = 20,
        Font = Enum.Font.Gotham,
        ZIndex = 22,
    }, Button)

    local List = Create("Frame", {
        Position = UDim2.new(0, 0, 1, 5),
        Size = UDim2.new(1, 0, 0, #options * 36 + 10),
        BackgroundColor3 = Color3.fromRGB(13, 13, 16),
        Visible = false,
        ZIndex = 100,
    }, Button)

    Corner(List, 10)
    Stroke(List, Color3.fromRGB(32, 32, 37), 1)
    AddPadding(List, 5, 5, 5, 5)

    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, List)

    local function Close()
        List.Visible = false
        if OpenDropdown == List then OpenDropdown = nil end
    end

    local function Open()
        if OpenDropdown and OpenDropdown ~= List then
            OpenDropdown.Visible = false
        end
        List.Visible = true
        OpenDropdown = List
    end

    for _, option in ipairs(options) do
        local OptionButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(13, 13, 16),
            Text = option,
            TextColor3 = Color3.fromRGB(165, 165, 172),
            TextSize = 14,
            Font = Enum.Font.Gotham,
            AutoButtonColor = false,
            ZIndex = 101,
        }, List)

        Corner(OptionButton, 7)

        OptionButton.MouseButton1Click:Connect(function()
            Button:FindFirstChildOfClass("TextLabel").Text = option
            Close()
            if callback then callback(option) end
        end)
    end

    Button.MouseButton1Click:Connect(function()
        if List.Visible then Close() else Open() end
    end)

    return Holder
end

local function CreateKeybind(parent, text, default)
    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundTransparency = 1,
    }, parent)

    Create("TextLabel", {
        Position = UDim2.fromOffset(2, 0),
        Size = UDim2.new(1, -180, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(175, 175, 183),
        TextSize = 15,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Holder)

    local Mode = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -75, 0.5, 0),
        Size = UDim2.fromOffset(85, 36),
        BackgroundColor3 = Color3.fromRGB(18, 18, 21),
        Text = "Toggle",
        TextColor3 = Color3.fromRGB(145, 145, 153),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
    }, Holder)

    Corner(Mode, 9)

    local Key = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(70, 36),
        BackgroundColor3 = Color3.fromRGB(18, 18, 21),
        Text = default,
        TextColor3 = Color3.fromRGB(200, 200, 207),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
    }, Holder)

    Corner(Key, 9)

    Key.MouseButton1Click:Connect(function()
        Key.Text = "press key..."

        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Config.Keybind = input.KeyCode.Name
                Key.Text = input.KeyCode.Name
                connection:Disconnect()
            end
        end)
    end)

    Mode.MouseButton1Click:Connect(function()
        Config.BindMode = Config.BindMode == "Toggle" and "Hold" or "Toggle"
        Mode.Text = Config.BindMode
    end)

    return Holder
end

local function CreateColorPicker(parent, text, default)
    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundTransparency = 1,
    }, parent)

    Create("TextLabel", {
        Position = UDim2.fromOffset(2, 0),
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(175, 175, 183),
        TextSize = 15,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Holder)

    local Preview = Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(70, 32),
        BackgroundColor3 = default,
        Text = "",
        AutoButtonColor = false,
    }, Holder)

    Corner(Preview, 8)

    local Popup = Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, -50),
        Size = UDim2.fromOffset(230, 115),
        BackgroundColor3 = Color3.fromRGB(14, 14, 17),
        Visible = false,
        ZIndex = 200,
    }, Holder)

    Corner(Popup, 10)
    Stroke(Popup, Color3.fromRGB(35, 35, 40), 1)

    CreateSlider(Popup, "Red", 0, 255, default.R * 255, function(v)
        Config.Accent = Color3.fromRGB(
            math.floor(v),
            math.floor(Config.Accent.G * 255),
            math.floor(Config.Accent.B * 255)
        )
        Preview.BackgroundColor3 = Config.Accent
    end)

    Preview.MouseButton1Click:Connect(function()
        Popup.Visible = not Popup.Visible
    end)

    return Holder
end

local RagePage = CreatePage("ragebot")
local VisualPage = CreatePage("visuals")
local SettingsPage = CreatePage("settings")

for _, page in pairs(Pages) do
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
end

SectionTitle(RagePage, "ragebot")

CreateToggle(RagePage, "enabled", Config.Enabled, function(value)
    Config.Enabled = value
end)

CreateKeybind(RagePage, "enabled · bind", Config.Keybind)

CreateDropdown(RagePage, "evasion mode", {
    "Random", "Translocate", "ProjectileBreaker", "Off"
}, Config.EvasionMode, function(value)
    Config.EvasionMode = value
end)

CreateDropdown(RagePage, "weapon types", {
    "Primary, Secondary, Melee", "Primary", "Secondary", "Melee"
}, Config.WeaponType, function(value)
    Config.WeaponType = value
end)

CreateSlider(RagePage, "stability", 0, 1, Config.Stability, function(value)
    Config.Stability = value
end)

CreateSlider(RagePage, "shoot frames", 1, 20, Config.ShootFrames, function(value)
    Config.ShootFrames = math.floor(value)
end)

CreateSlider(RagePage, "random radius", 0, 250, Config.RandomRadius, function(value)
    Config.RandomRadius = math.floor(value)
end)

CreateSlider(RagePage, "random radius factor", 0, 1, Config.RandomRadiusFactor, function(value)
    Config.RandomRadiusFactor = value
end)

SectionTitle(VisualPage, "visuals")

CreateToggle(VisualPage, "visuals enabled", Config.VisualsEnabled, function(value)
    Config.VisualsEnabled = value
end)

CreateToggle(VisualPage, "show information", Config.ShowInfo, function(value)
    Config.ShowInfo = value
end)

CreateColorPicker(VisualPage, "accent color", Config.Accent)

CreateDropdown(VisualPage, "interface style", {
    "Dark", "Midnight", "Glass", "Minimal"
}, "Dark")

SectionTitle(SettingsPage, "settings")

CreateToggle(SettingsPage, "interface enabled", true)

CreateDropdown(SettingsPage, "interface scale", {
    "Automatic", "Small", "Medium", "Large"
}, "Automatic", function(value)
    if value == "Small" then
        UIScale.Scale = 0.58
    elseif value == "Medium" then
        UIScale.Scale = 0.70
    elseif value == "Large" then
        UIScale.Scale = 0.82
    else
        UpdateScale()
    end
end)

CreateToggle(SettingsPage, "mobile optimization", true)

CreateColorPicker(SettingsPage, "interface accent", Config.Accent)

CreateNavButton("◎", "ragebot", 1)
CreateNavButton("◎", "visuals", 2)
CreateNavButton("♙", "settings", 3)

CurrentPage = "ragebot"
RagePage.Visible = true

for _, child in ipairs(Navigation:GetChildren()) do
    if child:IsA("TextButton") then
        local active = child.Name == "ragebotButton"
        child.BackgroundColor3 = active
            and Color3.fromRGB(25, 22, 30)
            or Color3.fromRGB(10, 10, 13)
        child.TextColor3 = active
            and Color3.fromRGB(235, 235, 240)
            or Color3.fromRGB(100, 100, 108)

        local indicator = child:FindFirstChild("Indicator")
        if indicator then indicator.Visible = active end
    end
end

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local ToggleButton = Create("TextButton", {
    Name = "ProfessionalToggle",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 18, 0.57, 0),
    Size = UDim2.fromOffset(58, 58),
    BackgroundColor3 = Color3.fromRGB(12, 12, 15),
    Text = "",
    AutoButtonColor = false,
    ZIndex = 500,
}, ScaleHolder)

Corner(ToggleButton, 16)
Stroke(ToggleButton, Color3.fromRGB(40, 40, 46), 1)

local ToggleIcon = Create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "◎",
    TextColor3 = Config.Accent,
    TextSize = 27,
    Font = Enum.Font.GothamBold,
    ZIndex = 501,
}, ToggleButton)

ToggleButton.MouseEnter:Connect(function()
    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(23, 20, 29)})
    Tween(ToggleIcon, {TextColor3 = Color3.fromRGB(190, 160, 255)})
end)

ToggleButton.MouseLeave:Connect(function()
    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(12, 12, 15)})
    Tween(ToggleIcon, {TextColor3 = Config.Accent})
end)

ToggleButton.MouseButton1Click:Connect(function()
    Config.UIVisible = not Config.UIVisible
    Main.Visible = Config.UIVisible
end)

_G.LucentConfig = Config

_G.LucentUI = {
    GetConfig = function()
        return Config
    end,

    SetAccent = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Accent = color
        ToggleIcon.TextColor3 = color
    end,

    Toggle = function()
        Config.UIVisible = not Config.UIVisible
        Main.Visible = Config.UIVisible
    end,
}

print("Lucent-style UI loaded successfully.")
