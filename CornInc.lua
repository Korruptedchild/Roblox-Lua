local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
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
			for i = 1, 10 do
				ReplicatedStorage:WaitForChild("CollectCornEvent"):FireServer("GoldenCorn")
				ReplicatedStorage:WaitForChild("CollectCornEvent"):FireServer("SilverCorn")
			end
			for i = 1, 10 do
				ReplicatedStorage:WaitForChild("ClickEvent"):FireServer()
			end
			ReplicatedStorage:WaitForChild("GenerationEvent"):FireServer()
		end
		task.wait(0.05)
	end
end)

task.spawn(function()
	while true do
		if isFarming then
			ReplicatedStorage:WaitForChild("UpgradeCornValueUpg1RequestMax"):FireServer()
			ReplicatedStorage:WaitForChild("UpgradeCornValueUpg4RequestMax"):FireServer()
			ReplicatedStorage:WaitForChild("UpgradeRebirthValueUpg2RequestMax"):FireServer()
			ReplicatedStorage:WaitForChild("GeneratorPurchaseEventMax"):FireServer()
			ReplicatedStorage:WaitForChild("AddEnergy1"):FireServer()
			ReplicatedStorage:WaitForChild("AddEnergy2"):FireServer()
			ReplicatedStorage:WaitForChild("AddEnergy3"):FireServer()
		end
		task.wait(1)
	end
end)
