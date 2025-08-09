local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local slimesFolder = workspace:WaitForChild("Slimes")

local gui = Instance.new("ScreenGui")
gui.Name = "AutoFarmUI"
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
toggleButton.Text = "Auto Farm: OFF"
toggleButton.Parent = gui

local isFarming = false

toggleButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    toggleButton.Text = "Auto Farm: " .. (isFarming and "ON" or "OFF")
end)

task.spawn(function()
    while true do
        if isFarming then
            local slimes = slimesFolder:GetChildren()
            for _, slime in ipairs(slimes) do
                local targetPart
                if slime:IsA("Model") then
                    targetPart = slime.PrimaryPart or slime:FindFirstChildWhichIsA("BasePart")
                elseif slime:IsA("BasePart") then
                    targetPart = slime
                end
                if targetPart then
                    hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 0))
                    task.wait(0.5)
                end
            end
        else
            task.wait(0.5)
        end
        task.wait()
    end
end)