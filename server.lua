--servidor
local estoque = {
    {nome = "skate", quantidade = 10},
    {nome = "vaper", quantidade = 5},
    {nome = "salgadinhodefrango", quantidade = 3},
    -- Adicione mais itens conforme necessário
}

local vendas = 0

function GetStock()
    return estoque
end

function GetSales()
    return vendas
end

function SellItems(items)
    local total = 0

    for _, item in ipairs(items) do
        for _, stockItem in ipairs(estoque) do
            if stockItem.nome == item.nome then
                if stockItem.quantidade >= item.quantidade then
                    stockItem.quantidade = stockItem.quantidade - item.quantidade
                    total = total + item.preco * item.quantidade
                else
                    return false -- Não há estoque suficiente
                end
                break
            end
        end
    end

    vendas = vendas + total
    return true, total
end

RegisterServerEvent("vrp_example:getStock")
AddEventHandler("vrp_example:getStock", function()
    local estoque = GetStock()
    TriggerClientEvent("vrp_example:showStock", source, estoque)
end)

RegisterServerEvent("vrp_example:getSales")
AddEventHandler("vrp_example:getSales", function()
    local vendas = GetSales()
    TriggerClientEvent("vrp_example:showSales", source, vendas)
end)

RegisterServerEvent("vrp_example:sellItems")
AddEventHandler("vrp_example:sellItems", function(items)
    local sucesso, total = SellItems(items)
    if sucesso then
        TriggerClientEvent("vrp_example:purchaseSuccess", source, total)
    else
        TriggerClientEvent("vrp_example:purchaseFailed", source)
    end
end)

function IsPlayerAceAllowed(playerId, ace)
    if IsPlayerAceAllowed then
        return IsPlayerAceAllowed(playerId, ace)
    else
        return true
    end
end

function RestockItem(itemName, quantidade)
    for _, stockItem in ipairs(estoque) do
        if stockItem.nome == itemName then
            stockItem.quantidade = stockItem.quantidade + quantidade
            break
        end
    end
end

RegisterServerEvent("vrp_example:restockItem")
AddEventHandler("vrp_example:restockItem", function(itemName, quantidade)
    RestockItem(itemName, quantidade)
    TriggerClientEvent("vrp_example:showStock", -1, estoque)
end)

function GetCash()
    local query = "SELECT cash FROM finance LIMIT 1"
    MySQL.Async.fetchScalar(query, {}, function(result)
        if result ~= nil then
            local cash = tonumber(result)
            TriggerClientEvent("vrp_example:showCash", -1, cash) -- Envia o valor do dinheiro para todos os clientes
        end
    end)
end

RegisterNUICallback("withdrawCash", function(data, cb)
    local amount = tonumber(data.amount)
    if amount ~= nil and amount > 0 then
        WithdrawCash(amount)
        cb("ok")
    else
        cb("error")
    end
end)

function WithdrawCash(amount)
    local query = "SELECT cash FROM finance LIMIT 1"
    MySQL.Async.fetchScalar(query, {}, function(result)
        if result ~= nil then
            local currentCash = tonumber(result)
            if currentCash >= amount then
                local newCash = currentCash - amount
                local updateQuery = "UPDATE finance SET cash = @newCash LIMIT 1"
                local params = {["@newCash"] = newCash}
                MySQL.Async.execute(updateQuery, params, function(affectedRows)
                    if affectedRows > 0 then
                        -- Saque bem-sucedido
                        TriggerEvent("vrp_example:updateCash", newCash) -- Atualiza o valor do dinheiro para todos os clientes
                        -- Aqui você pode adicionar a lógica para transferir o valor sacado para o banco do dono da loja
                        local owner_id = -- Obtenha o ID do dono da loja
                        if owner_id ~= nil then
                            vRP.setBankMoney(owner_id, vRP.getBankMoney(owner_id) + amount)
                        end
                    end
                end)
            else
                -- Não há dinheiro suficiente na loja para realizar o saque
                -- Aqui você pode adicionar a lógica para notificar o dono da loja no jogo
            end
        end
    end)
end


-- Coordenadas do blip do dono da loja
local ownerCoords = vector3(-3035.74, 592.37, 7.81)

-- Crie os blips da loja
CreateShopBlips()

-- ...

function CreateShopBlips()
    -- Coordenadas do blip de acesso para os clientes
    local clientShopCoords = vector3(-3036.9, 594.38, 7.82)

    -- Blip de acesso para os clientes
    local shopBlip = AddBlipForCoord(clientShopCoords.x, clientShopCoords.y, clientShopCoords.z)
    SetBlipSprite(shopBlip, 59)
    SetBlipDisplay(shopBlip, 4)
    SetBlipScale(shopBlip, 0.7)
    SetBlipColour(shopBlip, 2)
    SetBlipAsShortRange(shopBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Loja")
    EndTextCommandSetBlipName(shopBlip)

    -- Blip do dono
    if IsPlayerAceAllowed(PlayerId(), "admin.permissao") then
        local ownerBlip = AddBlipForCoord(ownerCoords.x, ownerCoords.y, ownerCoords.z)
        SetBlipSprite(ownerBlip, 498)
        SetBlipDisplay(ownerBlip, 4)
        SetBlipScale(ownerBlip, 0.7)
        SetBlipColour(ownerBlip, 2)
        SetBlipAsShortRange(ownerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Acesso do Dono")
        EndTextCommandSetBlipName(ownerBlip)
    end

    print("Os blips da loja foram criados.")
end


-- ...
