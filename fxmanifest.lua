fx_version 'cerulean'
game 'gta5'

author 'Sativa BrisaLeve'
description 'Loja com estoque'
version '1.0.0'

-- Define o arquivo principal do servidor
server_script 'server.lua'

-- Define o arquivo principal do cliente
client_script 'client.lua'

-- Arquivos necessários para o recurso
files {
    'utils/lib.lua',
    'config/cfg.lua',
    'interface/index.html',
    'interface/script.js',
    'interface/style.css'
}

-- Configurações adicionais
ui_page 'interface/index.html' -- Define o arquivo HTML como página de interface do usuário