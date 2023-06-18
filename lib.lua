--lib Aqui você pode adicionar funções de utilidade personalizadas que serão usadas em seu script

function PrintMessage(message)
    print("[Loja] " .. message)
end

function CalculateTotalPrice(itemPrice, quantity)
    return itemPrice * quantity
end

function GetFormattedPrice(price)
    return "$" .. tostring(price)
end

-- Adicione outras funções de utilidade aqui, se necessário

-- Certifique-se de fechar o arquivo com "return" para que as funções estejam disponíveis
return {
    PrintMessage = PrintMessage,
    CalculateTotalPrice = CalculateTotalPrice,
    GetFormattedPrice = GetFormattedPrice
    -- Adicione outras funções aqui, se necessário
}
