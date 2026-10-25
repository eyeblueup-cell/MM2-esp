local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local protectGui = syn and syn.protect_gui or function() end

local function purgeOldUIs()
    pcall(function()
        if CoreGui then
            for _, obj in ipairs(CoreGui:GetChildren()) do
                if obj.Name == "MM2UltimateProSuite" then
                    obj:Destroy()
                end
            end
        end
        if localPlayer then
            local playerGui = localPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, obj in ipairs(playerGui:GetChildren()) do
                    if obj.Name == "MM2UltimateProSuite" then
                        obj:Destroy()
                    end
                end
            end
        end
        if _G.MM2ProGui and typeof(_G.MM2ProGui) == "Instance" then
            _G.MM2ProGui:Destroy()
        end
    end)
    _G.MM2ProGui = nil
end

purgeOldUIs()

local CONFIG = {
    EspEnabled = true,
    GunEspEnabled = true,
    AlwaysOnTop = true,
    FillTransparency = 0.45,
    OutlineTransparency = 0.0,
    AutoGrabGun = false,
    Fullbright = false,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 24,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    InfJump = false,
    Noclip = false,
    FovValue = 70,
    AccentColor = Color3.fromRGB(220, 40, 60),
    Colors = {
        Murderer = { Fill = Color3.fromRGB(230, 40, 50), Outline = Color3.fromRGB(255, 100, 110) },
        Sheriff  = { Fill = Color3.fromRGB(30, 140, 255), Outline = Color3.fromRGB(90, 200, 255) },
        Friend   = { Fill = Color3.fromRGB(40, 220, 110), Outline = Color3.fromRGB(100, 255, 160) },
        Innocent = { Fill = Color3.fromRGB(120, 120, 135), Outline = Color3.fromRGB(200, 200, 215) },
        Lobby    = { Fill = Color3.fromRGB(40, 40, 50), Outline = Color3.fromRGB(80, 80, 95) },
        GunDrop  = { Fill = Color3.fromRGB(255, 215, 0), Outline = Color3.fromRGB(255, 255, 255) }
    }
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2UltimateProSuite"
screenGui.ResetOnSpawn = false
pcall(function() protectGui(screenGui) end)

local successParent = pcall(function()
    screenGui.Parent = CoreGui
end)
if not successParent then
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end
_G.MM2ProGui = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 380)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 65)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.BackgroundColor3 = CONFIG.AccentColor
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 300, 0, 38)
titleLabel.Position = UDim2.new(0, 12, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MM2 EXECUTIVE PRO SUITE"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    purgeOldUIs()
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -44)
sidebar.Position = UDim2.new(0, 0, 0, 44)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 8)
sidebarPadding.PaddingLeft = UDim.new(0, 8)
sidebarPadding.PaddingRight = UDim.new(0, 8)
sidebarPadding.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -135, 1, -44)
contentArea.Position = UDim2.new(0, 135, 0, 44)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local tabs = {}
local currentTabName = ""

local function createTabContent(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.new(1, -12, 1, -12)
    sf.Position = UDim2.new(0, 6, 0, 6)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.Visible = false
    sf.ScrollBarThickness = 4
    sf.CanvasSize = UDim2.new(0, 0, 2, 0)
    sf.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = sf

    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = sf

    tabs[name] = sf
    return sf
end

local function createNavButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local targetTab = createTabContent(name)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do t.Visible = false end
        for _, b in ipairs(sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
                b.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
        end
        targetTab.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(45, 90, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTabName = name
    end)

    return targetTab
end

local espTab = createNavButton("ESP & VISUALS")
local teleTab = createNavButton("TELEPORTS & GUN")
local moveTab = createNavButton("MOVEMENT & MISC")
local customTab = createNavButton("CUSTOMIZATION")

tabs["ESP & VISUALS"].Visible = true
for _, child in ipairs(sidebar:GetChildren()) do
    if child:IsA("TextButton") and child.Text == "ESP & VISUALS" then
        child.BackgroundColor3 = Color3.fromRGB(45, 90, 180)
        child.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local function addHeader(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(110, 140, 240)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

local function addToggle(parent, text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(35, 140, 70) or Color3.fromRGB(160, 40, 40)
    btn.Text = text .. (defaultState and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(35, 140, 70) or Color3.fromRGB(160, 40, 40)
        btn.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
    return btn
end

local function addButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 90, 180)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 18)
    lbl.Position = UDim2.new(0, 6, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(defaultVal)
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 12)
    btn.Position = UDim2.new(0, 6, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(45, 90, 180)
    fill.BorderSizePixel = 0
    fill.Parent = btn
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - btn.AbsolutePosition.X) / btn.AbsoluteSize.X, 0, 1)
        local val = math.floor((minVal + (maxVal - minVal) * pos) * 100) / 100
        fill.Size = UDim2.new(pos, 0, 1, 0)
        lbl.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function addColorPicker(parent, roleName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = roleName .. " Color"
    lbl.TextColor3 = Color3.fromRGB(220, 220, 235)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 20, 0, 20)
    preview.Position = UDim2.new(1, -85, 0.5, -10)
    preview.BackgroundColor3 = CONFIG.Colors[roleName].Fill
    preview.BorderSizePixel = 0
    preview.Parent = frame
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 20)
    btn.Position = UDim2.new(1, -60, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(45, 90, 180)
    btn.Text = "CYCLE"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local presets = {
        CONFIG.Colors[roleName].Fill,
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 128, 0)
    }
    local index = 1

    btn.MouseButton1Click:Connect(function()
        index = (index % #presets) + 1
        local newCol = presets[index]
        preview.BackgroundColor3 = newCol
        CONFIG.Colors[roleName].Fill = newCol
        CONFIG.Colors[roleName].Outline = Color3.new(math.min(newCol.R + 0.3, 1), math.min(newCol.G + 0.3, 1), math.min(newCol.B + 0.3, 1))
    end)
end

addHeader(espTab, "MAIN TOGGLES")
addToggle(espTab, "PLAYER ESP", CONFIG.EspEnabled, function(s) CONFIG.EspEnabled = s end)
addToggle(espTab, "GUN DROP ESP", CONFIG.GunEspEnabled, function(s) CONFIG.GunEspEnabled = s end)
addToggle(espTab, "SEE THROUGH WALLS", CONFIG.AlwaysOnTop, function(s) CONFIG.AlwaysOnTop = s end)

addHeader(espTab, "VISUAL ADJUSTMENTS")
addSlider(espTab, "FILL TRANSPARENCY", 0, 1, CONFIG.FillTransparency, function(v) CONFIG.FillTransparency = v end)
addSlider(espTab, "OUTLINE TRANSPARENCY", 0, 1, CONFIG.OutlineTransparency, function(v) CONFIG.OutlineTransparency = v end)

local function grabGunInstantly()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local gunDrop = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name == "RevolverDrop" or (obj:IsA("Tool") and obj.Name:lower():find("gun")) then
            gunDrop = obj
            break
        end
    end
    
    if gunDrop then
        local targetPart = gunDrop:FindFirstChild("Handle") or (gunDrop:IsA("BasePart") and gunDrop) or gunDrop.PrimaryPart
        if targetPart then
            local originalCFrame = hrp.CFrame
            hrp.CFrame = targetPart.CFrame
            task.wait(0.05)
            hrp.CFrame = originalCFrame
        end
    end
end

addHeader(teleTab, "GUN ACTIONS")
addButton(teleTab, "INSTANT GRAB GUN (TP & BACK)", grabGunInstantly)
addToggle(teleTab, "AUTO GRAB GUN", CONFIG.AutoGrabGun, function(s) CONFIG.AutoGrabGun = s end)

addHeader(teleTab, "PLAYER TELEPORTS")
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, -6, 0, 200)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
playerListFrame.Parent = teleTab
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 6)

local playerListScroll = Instance.new("ScrollingFrame")
playerListScroll.Size = UDim2.new(1, -8, 1, -8)
playerListScroll.Position = UDim2.new(0, 4, 0, 4)
playerListScroll.BackgroundTransparency = 1
playerListScroll.BorderSizePixel = 0
playerListScroll.ScrollBarThickness = 4
playerListScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
playerListScroll.Parent = playerListFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Padding = UDim.new(0, 4)
playerListLayout.Parent = playerListScroll

addHeader(moveTab, "MOVEMENT MODIFIERS")
addToggle(moveTab, "WALKSPEED HACK", CONFIG.WalkSpeedEnabled, function(s) CONFIG.WalkSpeedEnabled = s end)
addSlider(moveTab, "WALKSPEED VALUE", 16, 100, CONFIG.WalkSpeedValue, function(v) CONFIG.WalkSpeedValue = v end)
addToggle(moveTab, "JUMPPOWER HACK", CONFIG.JumpPowerEnabled, function(s) CONFIG.JumpPowerEnabled = s end)
addSlider(moveTab, "JUMPPOWER VALUE", 50, 300, CONFIG.JumpPowerValue, function(v) CONFIG.JumpPowerValue = v end)
addToggle(moveTab, "INFINITE JUMP", CONFIG.InfJump, function(s) CONFIG.InfJump = s end)
addToggle(moveTab, "CHARACTER NOCLIP", CONFIG.Noclip, function(s) CONFIG.Noclip = s end)

addHeader(moveTab, "WORLD & CAMERA")
addToggle(moveTab, "FULLBRIGHT LIGHTING", CONFIG.Fullbright, function(s) CONFIG.Fullbright = s end)
addSlider(moveTab, "FIELD OF VIEW (FOV)", 50, 120, CONFIG.FovValue, function(v)
    CONFIG.FovValue = v
    Camera.FieldOfView = v
end)

addHeader(customTab, "ROLE COLORS")
addColorPicker(customTab, "Murderer")
addColorPicker(customTab, "Sheriff")
addColorPicker(customTab, "Friend")
addColorPicker(customTab, "Innocent")
addColorPicker(customTab, "GunDrop")

local function getPlayerStatus(plr)
    local char = Workspace:FindFirstChild(plr.Name)
    local bp = plr:FindFirstChild("Backpack")
    if not char then return "Lobby" end
    local hasKnife = (char:FindFirstChild("Knife") or char:FindFirstChild("Blade")) or (bp and (bp:FindFirstChild("Knife") or bp:FindFirstChild("Blade")))
    local hasGun = (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")) or (bp and (bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver")))
    if hasKnife then return "Murderer"
    elseif hasGun then return "Sheriff"
    elseif plr:IsFriendsWith(localPlayer.UserId) then return "Friend"
    else return "Innocent" end
end

local playerEntries = {}

task.spawn(function()
    while true do
        task.wait(0.3)
        if CONFIG.AutoGrabGun then
            pcall(function()
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj.Name == "GunDrop" or obj.Name == "RevolverDrop" or (obj:IsA("Tool") and obj.Name:lower():find("gun")) then
                            local targetPart = obj:FindFirstChild("Handle") or (obj:IsA("BasePart") and obj) or obj.PrimaryPart
                            if targetPart then
                                local orig = hrp.CFrame
                                hrp.CFrame = targetPart.CFrame
                                task.wait(0.03)
                                hrp.CFrame = orig
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if CONFIG.InfJump then
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    if CONFIG.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end

    local char = localPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if CONFIG.WalkSpeedEnabled then humanoid.WalkSpeed = CONFIG.WalkSpeedValue end
        if CONFIG.JumpPowerEnabled then humanoid.JumpPower = CONFIG.JumpPowerValue end
    end

    if CONFIG.Noclip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local role = getPlayerStatus(plr)
            local pchar = Workspace:FindFirstChild(plr.Name)

            local highlight = pchar and pchar:FindFirstChild("PlayerESP")
            if CONFIG.EspEnabled and pchar then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerESP"
                    highlight.Parent = pchar
                end
                highlight.Adornee = pchar
                highlight.DepthMode = CONFIG.AlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                local palette = CONFIG.Colors[role] or CONFIG.Colors.Innocent
                highlight.FillColor = palette.Fill
                highlight.OutlineColor = palette.Outline
                highlight.FillTransparency = CONFIG.FillTransparency
                highlight.OutlineTransparency = CONFIG.OutlineTransparency
            elseif highlight then
                highlight:Destroy()
            end

            local entry = playerEntries[plr]
            if not entry then
                entry = {}
                entry.Frame = Instance.new("Frame")
                entry.Frame.Size = UDim2.new(1, 0, 0, 28)
                entry.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                entry.Frame.Parent = playerListScroll
                Instance.new("UICorner", entry.Frame).CornerRadius = UDim.new(0, 4)

                entry.NameLbl = Instance.new("TextLabel")
                entry.NameLbl.Size = UDim2.new(0.6, 0, 1, 0)
                entry.NameLbl.Position = UDim2.new(0, 6, 0, 0)
                entry.NameLbl.BackgroundTransparency = 1
                entry.NameLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
                entry.NameLbl.TextSize = 10
                entry.NameLbl.Font = Enum.Font.GothamBold
                entry.NameLbl.TextXAlignment = Enum.TextXAlignment.Left
                entry.NameLbl.Parent = entry.Frame

                entry.TpBtn = Instance.new("TextButton")
                entry.TpBtn.Size = UDim2.new(0, 50, 0, 20)
                entry.TpBtn.Position = UDim2.new(1, -56, 0.5, -10)
                entry.TpBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 210)
                entry.TpBtn.Text = "TP"
                entry.TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                entry.TpBtn.TextSize = 9
                entry.TpBtn.Font = Enum.Font.GothamBold
                entry.TpBtn.Parent = entry.Frame
                Instance.new("UICorner", entry.TpBtn).CornerRadius = UDim.new(0, 4)

                entry.TpBtn.MouseButton1Click:Connect(function()
                    local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetHrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp and targetHrp then
                        myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                    end
                end)

                playerEntries[plr] = entry
            end
            entry.NameLbl.Text = plr.Name .. " (" .. role .. ")"
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name == "RevolverDrop" or (obj:IsA("Tool") and obj.Name:lower():find("gun")) then
            local hl = obj:FindFirstChild("GunESP")
            if CONFIG.GunEspEnabled then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "GunESP"
                    hl.Parent = obj
                end
                hl.Adornee = obj
                hl.DepthMode = CONFIG.AlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                hl.FillColor = CONFIG.Colors.GunDrop.Fill
                hl.OutlineColor = CONFIG.Colors.GunDrop.Outline
                hl.FillTransparency = CONFIG.FillTransparency
                hl.OutlineTransparency = CONFIG.OutlineTransparency
            elseif hl then
                hl:Destroy()
            end
        end
    end
end)
