local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local protectGui = syn and syn.protect_gui or function() end

local function purgeOldUIs()
    pcall(function()
        if CoreGui then
            for _, obj in ipairs(CoreGui:GetChildren()) do
                if obj.Name == "MM2Suite_Pro" then
                    obj:Destroy()
                end
            end
        end
        if localPlayer then
            local playerGui = localPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, obj in ipairs(playerGui:GetChildren()) do
                    if obj.Name == "MM2Suite_Pro" then
                        obj:Destroy()
                    end
                end
            end
        end
        if _G.MM2Suite_Gui and typeof(_G.MM2Suite_Gui) == "Instance" then
            _G.MM2Suite_Gui:Destroy()
        end
    end)
    _G.MM2Suite_Gui = nil
end

purgeOldUIs()

local ROLE_COLORS = {
    Murderer = { Fill = Color3.fromRGB(230, 40, 50), Outline = Color3.fromRGB(255, 100, 110) },
    Sheriff  = { Fill = Color3.fromRGB(30, 140, 255), Outline = Color3.fromRGB(90, 200, 255) },
    Friend   = { Fill = Color3.fromRGB(40, 220, 110), Outline = Color3.fromRGB(100, 255, 160) },
    Innocent = { Fill = Color3.fromRGB(120, 120, 135), Outline = Color3.fromRGB(200, 200, 215) },
    Lobby    = { Fill = Color3.fromRGB(40, 40, 50), Outline = Color3.fromRGB(80, 80, 95) },
    GunDrop  = { Fill = Color3.fromRGB(255, 215, 0), Outline = Color3.fromRGB(255, 255, 255) }
}

local espEnabled = true
local gunEspEnabled = true
local alwaysOnTop = true
local fillTransparencyValue = 0.45
local outlineTransparencyValue = 0.0

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Suite_Pro"
screenGui.ResetOnSpawn = false
pcall(function() protectGui(screenGui) end)

local successParent = pcall(function()
    screenGui.Parent = CoreGui
end)
if not successParent then
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end
_G.MM2Suite_Gui = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 420)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
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
accentBar.BackgroundColor3 = Color3.fromRGB(220, 40, 60)
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 250, 0, 38)
titleLabel.Position = UDim2.new(0, 12, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MM2 ESP & TELEPORT SUITE"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
titleLabel.TextSize = 11
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

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -24, 1, -50)
container.Position = UDim2.new(0, 12, 0, 42)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 4
container.CanvasSize = UDim2.new(0, 0, 0, 700)
container.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = container

local function addHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(110, 140, 240)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container
end

local function addToggle(text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 30)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(35, 140, 70) or Color3.fromRGB(160, 40, 40)
    btn.Text = text .. (defaultState and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
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

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 90, 180)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addSlider(text, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    frame.Parent = container
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

addHeader("QUICK ACTIONS")
addButton("INSTANT GRAB GUN (TP & BACK)", grabGunInstantly)

addHeader("ESP TOGGLES")
addToggle("MASTER PLAYER ESP", espEnabled, function(s) espEnabled = s end)
addToggle("GUN DROP ESP", gunEspEnabled, function(s) gunEspEnabled = s end)
addToggle("SEE THROUGH WALLS", alwaysOnTop, function(s) alwaysOnTop = s end)

addHeader("VISUAL ADJUSTMENTS")
addSlider("FILL TRANSPARENCY", 0, 1, fillTransparencyValue, function(v) fillTransparencyValue = v end)
addSlider("OUTLINE TRANSPARENCY", 0, 1, outlineTransparencyValue, function(v) outlineTransparencyValue = v end)

addHeader("PLAYER TELEPORTS")
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, -6, 0, 180)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
playerListFrame.Parent = container
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

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local role = getPlayerStatus(plr)
            local char = Workspace:FindFirstChild(plr.Name)

            local highlight = char and char:FindFirstChild("PlayerESP")
            if espEnabled and char then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerESP"
                    highlight.Parent = char
                end
                highlight.Adornee = char
                highlight.DepthMode = alwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                local palette = ROLE_COLORS[role] or ROLE_COLORS.Innocent
                highlight.FillColor = palette.Fill
                highlight.OutlineColor = palette.Outline
                highlight.FillTransparency = fillTransparencyValue
                highlight.OutlineTransparency = outlineTransparencyValue
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
                entry.NameLbl.Size = UDim2.new(0.5, 0, 1, 0)
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
            if gunEspEnabled then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "GunESP"
                    hl.Parent = obj
                end
                hl.Adornee = obj
                hl.DepthMode = alwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                hl.FillColor = ROLE_COLORS.GunDrop.Fill
                hl.OutlineColor = ROLE_COLORS.GunDrop.Outline
                hl.FillTransparency = fillTransparencyValue
                hl.OutlineTransparency = outlineTransparencyValue
            elseif hl then
                hl:Destroy()
            end
        end
    end
end)
