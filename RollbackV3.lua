-- Criar ScreenGui e colocar na PlayerGui
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RollbackGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Criar botão Relogar
local rejoinButton = Instance.new("TextButton")
rejoinButton.Name = "RejoinButton"
rejoinButton.Size = UDim2.new(0, 150, 0, 50)
rejoinButton.Position = UDim2.new(0, 10, 0, 10)
rejoinButton.Text = "Relogar"
rejoinButton.Parent = screenGui

-- Criar botão Rollback
local rollbackButton = Instance.new("TextButton")
rollbackButton.Name = "RollbackToggle"
rollbackButton.Size = UDim2.new(0, 150, 0, 50)
rollbackButton.Position = UDim2.new(0, 10, 0, 70)
rollbackButton.Text = "Rollback: OFF"
rollbackButton.Parent = screenGui

-- Estado rollback
local rollbackEnabled = false

-- Função Relogar
local TeleportService = game:GetService("TeleportService")
rejoinButton.MouseButton1Click:Connect(function()
	TeleportService:Teleport(game.PlaceId, player)
end)

-- Função ativar/desativar rollback
rollbackButton.MouseButton1Click:Connect(function()
	rollbackEnabled = not rollbackEnabled
	rollbackButton.Text = "Rollback: " .. (rollbackEnabled and "ON" or "OFF")
	-- Aqui você pode disparar RemoteEvent para avisar servidor do estado
	print("Rollback ativado:", rollbackEnabled)
end)
