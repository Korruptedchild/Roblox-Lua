local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local slimesFolder = workspace:WaitForChild("Slimes")

spawn(function()
    while true do
        local slimes = slimesFolder:GetChildren()
        for i = 1, #slimes do
            local slime = slimes[i]
            local targetPart = nil
            if slime:IsA("Model") then
                targetPart = slime.PrimaryPart or slime:FindFirstChildWhichIsA("BasePart")
            elseif slime:IsA("BasePart") then
                targetPart = slime
            end
            if targetPart then
                hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 0))
                wait(0.1)
            end
        end
        wait(1)
    end
end)