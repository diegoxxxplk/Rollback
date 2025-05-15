local DataStoreService = game:GetService("DataStoreService")
local rollbackStore = DataStoreService:GetDataStore("RollbackStateStore")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rollbackEvent = Instance.new("RemoteEvent")
rollbackEvent.Name = "RollbackToggleEvent"
rollbackEvent.Parent = ReplicatedStorage

local playerRollbackStates = {}

game.Players.PlayerAdded:Connect(function(player)
    -- Puxar estado salvo para o jogador
    local success, savedState = pcall(function()
        return rollbackStore:GetAsync(player.UserId)
    end)

    if success and savedState ~= nil then
        playerRollbackStates[player.UserId] = savedState
    else
        playerRollbackStates[player.UserId] = false
    end

    -- Avisar cliente do estado atual via RemoteEvent
    rollbackEvent:FireClient(player, playerRollbackStates[player.UserId])
end)

rollbackEvent.OnServerEvent:Connect(function(player, newState)
    playerRollbackStates[player.UserId] = newState

    -- Salvar no DataStore
    local success, err = pcall(function()
        rollbackStore:SetAsync(player.UserId, newState)
    end)
    if not success then
        warn("Erro ao salvar rollback no DataStore para "..player.Name..": "..err)
    end

    print(player.Name .. " setou rollback para: " .. tostring(newState))
end)

game.Players.PlayerRemoving:Connect(function(player)
    -- Opcional: salvar estado ao sair (garantir persistência)
    local state = playerRollbackStates[player.UserId]
    if state ~= nil then
        local success, err = pcall(function()
            rollbackStore:SetAsync(player.UserId, state)
        end)
        if not success then
            warn("Erro ao salvar rollback no DataStore no PlayerRemoving para "..player.Name..": "..err)
        end
    end
end)
