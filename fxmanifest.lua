fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

description 'Parking Meter Robbery'
author 'CJ'
verison '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'client/utils.lua'
}

server_scripts {
    'server/server.lua'
}