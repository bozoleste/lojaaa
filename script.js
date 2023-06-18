--java
function restockItem() {
    var itemName = document.getElementById("itemNameInput").value;
    var quantity = document.getElementById("quantityInput").value;

    if (itemName && quantity) {
        var restockData = {
            itemName: itemName,
            quantity: parseInt(quantity)
        };

        // Enviar dados para o servidor
        $.post("restockItem", JSON.stringify(restockData), function (response) {
            if (response === "ok") {
                // Operação concluída com sucesso
                // Atualize a interface, se necessário
            } else {
                // Lidar com erro, se aplicável
            }
        });
    } else {
        // Lidar com entrada inválida, se necessário
    }
}
// Código da NUI
document.getElementById('sacarButton').addEventListener('click', function() {
    var amount = parseFloat(document.getElementById('sacarInput').value);
    if (!isNaN(amount) && amount > 0) {
        // Envia um evento para o servidor solicitar o saque
        // O valor do saque será passado como parâmetro
        emit('vrp_example:withdrawCash', amount);
    }
});
