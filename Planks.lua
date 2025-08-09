local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local playertype = {
    this = 0,
    teammate = 1,
    enemy = 2,
}

local function areTeamMates(p1, p2)
    return p1.Team == p2.Team
end

local function getPlayerType(p)
    if p == player then
        return playertype.this
    elseif areTeamMates(player, p) then
        return playertype.teammate
    else
        return playertype.enemy
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "AimbotUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 25, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleButton.BorderSizePixel = 0
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Text = "Disabled"
toggleButton.Parent = gui
toggleButton.Visible = true

local isEnabled = false

toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    toggleButton.Text = isEnabled and "Enabled" or "Disabled"
end)

local function isAlive(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Character and getPlayerType(otherPlayer) == playertype.enemy and isAlive(otherPlayer.Character) then
            local enemyHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if enemyHRP then
                local dist = (hrp.Position - enemyHRP.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = enemyHRP
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if not isEnabled then return end

    local targetPart = GetEnemy()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if targetPart and hrp then
        local cameraPos = camera.CFrame.Position
        local targetPos = targetPart.Position
        camera.CFrame = CFrame.new(cameraPos, targetPos)
    end
end)