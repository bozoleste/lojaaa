-- client
local shopItems = {
    {name = "skate", price = 10},
    {name = "vaper", price = 20},
    {name = "salgadinhodefrango", price = 30},
    -- Adicione mais itens conforme necessário
}
local shopOwner = nil

local shoppingCart = {}

local isShopMenuOpen = false
local shopBlip = nil

function OpenShopMenu()
    isShopMenuOpen = true
    SendNUIMessage({openShopMenu = true, items = shopItems})
    SetNuiFocus(true, true)
end

function AddToCart(item)
    local found = false

    for _, cartItem in ipairs(shoppingCart) do
        if cartItem.name == item.name then
            found = true
            break
        end
    end

    if not found then
        table.insert(shoppingCart, item)
        ShowNotification("Item adicionado ao carrinho.")
    else
        ShowNotification("Este item já está no carrinho.")
    end
end

function ShowCart()
    SendNUIMessage({showCart = true, cartItems = shoppingCart})
end

function ShowTotal()
    local total = 0

    for _, item in ipairs(shoppingCart) do
        total = total + item.price
    end

    ShowNotification("Total da compra: $" .. total)
end

RegisterNUICallback("addItemToCart", function(data, cb)
    local selectedItem = data.item
    AddToCart(selectedItem)
    cb("ok")
end)

RegisterNUICallback("showCart", function(data, cb)
    ShowCart()
    cb("ok")
end)

RegisterNUICallback("showTotal", function(data, cb)
    ShowTotal()
    cb("ok")
end)

function CloseShopMenu()
    isShopMenuOpen = false
    SendNUIMessage({closeShopMenu = true})
    SetNuiFocus(false, false)
end

local shopCoords = {
    x = -3036.9,
    y = 594.38,
    z = 7.82
}

function CreateShopBlip()
    shopBlip = AddBlipForCoord(shopCoords.x, shopCoords.y, shopCoords.z)
    SetBlipSprite(shopBlip, 59)
    SetBlipDisplay(shopBlip, 4)
    SetBlipScale(shopBlip, 0.7)
    SetBlipColour(shopBlip, 2)
    SetBlipAsShortRange(shopBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Loja")
    EndTextCommandSetBlipName(shopBlip)
end

function RemoveShopBlip()
    if shopBlip ~= nil then
        RemoveBlip(shopBlip)
        shopBlip = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(playerCoords, shopCoords.x, shopCoords.y, shopCoords.z, true)

        if distance <= Config.ShopMarkerDistance then
            DrawMarker(Config.ShopMarkerType, shopCoords.x, shopCoords.y, shopCoords.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ShopMarkerSize.x, Config.ShopMarkerSize.y, Config.ShopMarkerSize.z, Config.ShopMarkerColor.r, Config.ShopMarkerColor.g, Config.ShopMarkerColor.b, Config.ShopMarkerColor.a, false, true, 2, false, false, false, false)

            if distance <= Config.ShopInteractionDistance then
                ShowHelpNotification("Pressione ~INPUT_CONTEXT~ para abrir a loja.")

                if IsControlJustReleased(0, Config.ShopInteractionKey) then
                    OpenShopMenu()
                end
            end
        end
    end
end)

function ShowHelpNotification(message)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterNetEvent("vrp_example:showStock")
AddEventHandler("vrp_example:showStock", function(stock)
    SendNUIMessage({showStock = true, stockItems = stock})
end)

RegisterNetEvent("vrp_example:showSales")
AddEventHandler("vrp_example:showSales", function(totalSales)
    ShowNotification("Vendas totais: $" .. totalSales)
end)

RegisterNUICallback("closeShopMenu", function(data, cb)
    CloseShopMenu()
    cb("ok")
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if isShopMenuOpen then
            CloseShopMenu()
        end
    end
end)

function InitializeNui()
    SetNuiFocus(false, false)
    SendNUIMessage({initShopMenu = true})
end

Citizen.CreateThread(function()
    InitializeNui()
end)

local isOwnerMenuOpen = false

function OpenOwnerMenu()
    isOwnerMenuOpen = true
    SendNUIMessage({openOwnerMenu = true})
    SetNuiFocus(true, true)
end

function CloseOwnerMenu()
    isOwnerMenuOpen = false
    SendNUIMessage({closeOwnerMenu = true})
    SetNuiFocus(false, false)
end

RegisterNUICallback("closeOwnerMenu", function(data, cb)
    CloseOwnerMenu()
    cb("ok")
end)

RegisterNetEvent("vrp_example:showStock")
AddEventHandler("vrp_example:showStock", function(stock)
    SendNUIMessage({showStock = true, stockItems = stock})
end)

RegisterNetEvent("vrp_example:showSales")
AddEventHandler("vrp_example:showSales", function(totalSales)
    SendNUIMessage({showSales = true, totalSales = totalSales})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(playerCoords, shopCoords.x, shopCoords.y, shopCoords.z, true)

        if distance <= Config.ShopMarkerDistance then
            if IsPlayerAceAllowed(source, "shop.owner") then
                DrawMarker(Config.ShopMarkerType, shopCoords.x, shopCoords.y, shopCoords.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ShopMarkerSize.x, Config.ShopMarkerSize.y, Config.ShopMarkerSize.z, Config.ShopMarkerColor.r, Config.ShopMarkerColor.g, Config.ShopMarkerColor.b, Config.ShopMarkerColor.a, false, true, 2, false, false, false, false)
            end

            if distance <= Config.ShopInteractionDistance then
                if IsPlayerAceAllowed(source, "shop.owner") then
                    ShowHelpNotification("Pressione ~INPUT_CONTEXT~ para abrir o menu do dono.")

                    if IsControlJustReleased(0, Config.ShopInteractionKey) then
                        OpenOwnerMenu()
                    end
                else
                    ShowHelpNotification("Bem-vindo à loja!")
                end
            end
        end
    end
end)

RegisterNUICallback("restockItem", function(data, cb)
    local itemName = data.itemName
    local quantity = data.quantity

    TriggerServerEvent("vrp_example:restockItem", itemName, quantity)
    cb("ok")
end)

RegisterNetEvent("vrp_example:showCash")
AddEventHandler("vrp_example:showCash", function(cash)
    -- Atualize a exibição do dinheiro para o dono da loja
    -- Por exemplo, atualize o texto em uma NUI ou mostre uma notificação
    print("Dinheiro da loja: $" .. cash)
end)

RegisterNetEvent("vrp_example:updateCash")
AddEventHandler("vrp_example:updateCash", function(cash)
    SendNUIMessage({updateCash = true, cash = cash})
end)
