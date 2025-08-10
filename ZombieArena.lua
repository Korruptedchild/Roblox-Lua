local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "ZombieAimbotUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 80)
frame.Position = UDim2.new(0, 25, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = gui

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Text = "Zombie Aimbot"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 18
titleBar.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleButton.BorderSizePixel = 0
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Text = "Aimbot: OFF"
toggleButton.Parent = frame

local isEnabled = false
toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    toggleButton.Text = "Aimbot: " .. (isEnabled and "ON" or "OFF")
end)

-- Make frame draggable
local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragInput, dragStart, startPos

local function UpdateFramePosition(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        UpdateFramePosition(input)
    end
end)

local function GetZombieHead()
    local closestHead = nil
    local shortestDistance = math.huge
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local zombiesFolder = workspace:FindFirstChild("Zombies")
    if not zombiesFolder then return nil end

    for _, zombie in pairs(zombiesFolder:GetChildren()) do
        local head = zombie:FindFirstChild("Head")
        if head then
            local dist = (hrp.Position - head.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestHead = head
            end
        end
    end

    return closestHead
end

RunService.RenderStepped:Connect(function()
    if not isEnabled then return end

    local targetHead = GetZombieHead()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if targetHead and hrp then
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
    end
end)