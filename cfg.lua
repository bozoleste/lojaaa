--cfg
-- Configurações do marcador da loja
Config.ShopMarkerType = 1 -- Tipo de marcador
Config.ShopMarkerSize = {x = 1.5, y = 1.5, z = 1.0} -- Tamanho do marcador
Config.ShopMarkerColor = {r = 0, g = 255, b = 0, a = 100} -- Cor do marcador
Config.ShopMarkerDistance = 10.0 -- Distância máxima para ver o marcador
Config.ShopInteractionDistance = 2.0 -- Distância máxima para interagir com a loja
Config.ShopInteractionKey = 38 -- Tecla para interagir com a loja (INPUT_CONTEXT)

-- Coordenadas da loja
local shopCoords = {x = 0.0, y = 0.0, z = 0.0} -- Substitua pelas coordenadas corretas da loja

-- Coordenadas do blip do dono da loja
local ownerCoords = {x = 0.0, y = 0.0, z = 0.0} -- Substitua pelas coordenadas corretas do dono da loja

-- ID do jogador dono da loja
local shopOwner = 123 -- Substitua 123 pelo ID correto do dono da loja

-- Configurações do NUI
Config.NUIPage = "shop.html" -- Arquivo HTML do NUI

-- Configurações do estoque
Config.Stock = {
    {id = 1, name = "skate", price = 10, quantity = 10},
    {id = 2, name = "vaper", price = 20, quantity = 5},
    {id = 3, name = "salgadinhodefrango", price = 15, quantity = 8}
}

-- Configurações do menu do proprietário
Config.OwnerMenu = {
    title = "Menu do Proprietário",
    buttons = {
        {name = "Visualizar Estoque", event = "shop:viewStock"},
        {name = "Visualizar Vendas", event = "shop:viewSales"},
        {name = "Adicionar Item", event = "shop:addItem"},
        {name = "Remover Item", event = "shop:removeItem"}
    }
}

-- Configurações do servidor
Config.ServerEvents = {
    getStock = "shop:getStock",
    sellItem = "shop:sellItem",
    restockItem = "shop:restockItem"
}
