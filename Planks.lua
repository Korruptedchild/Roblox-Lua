local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function GetEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
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
    local targetPart = GetEnemy()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if targetPart and hrp then
        local cameraPos = camera.CFrame.Position
        local targetPos = targetPart.Position
        camera.CFrame = CFrame.new(cameraPos, targetPos)
    end
end)