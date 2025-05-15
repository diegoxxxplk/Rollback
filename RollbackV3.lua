-- No LocalScript (cliente)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DataStoreService = game:GetService("DataStoreService")
local rollbackStore = DataStoreService:GetDataStore("RollbackStateStore")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RollbackGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local rejoinButton = Instance.new("TextButton")
rejoinButton.Name = "RejoinButton"
rejoinButton.Size = UDim2.new(0, 150, 0, 50)
rejoinButton.Position = UDim2.new(0, 10, 0, 10)
rejoinButton.Text = "Relogar"
rejoinButton.Parent = screenGui

local rollbackButton = Instance.new("TextButton")
rollbackButton.Name = "RollbackToggle"
rollbackButton.Size = UDim2.new(0, 150, 0, 50)
rollbackButton.Position = UDim2.new(0, 10, 0, 70)
rollbackButton.Text = "Rollback: OFF"
rollbackButton.Parent = screenGui

local rollbackEnabled = false

local TeleportService = game:GetService("TeleportService")

-- Função para atualizar UI e estado
local function updateRollbackState(state)
    rollbackEnabled = state
    rollbackButton.Text = "Rollback: " .. (rollbackEnabled and "ON" or "OFF")
    print("Rollback ativado:", rollbackEnabled)
end

-- Puxar estado salvo no DataStore quando entrar no jogo
local success, savedState = pcall(function()
    return rollbackStore:GetAsync(player.UserId)
end)

if success and savedState ~= nil then
    updateRollbackState(savedState)
else
    updateRollbackState(false)
end

-- Botão rollback toggle
rollbackButton.MouseButton1Click:Connect(function()
    rollbackEnabled = not rollbackEnabled
    rollbackButton.Text = "Rollback: " .. (rollbackEnabled and "ON" or "OFF")
    
    -- Salvar estado no DataStore
    local success, err = pcall(function()
        rollbackStore:SetAsync(player.UserId, rollbackEnabled)
    end)
    if not success then
        warn("Erro ao salvar estado rollback:", err)
    end

    print("Rollback ativado:", rollbackEnabled)
end)

-- Botão relogar
rejoinButton.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)
