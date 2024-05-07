fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'TH-Development x Dalle'
version '1.0'


client_scripts {
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    'client/*.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'server/*.lua',
    '@mysql-async/lib/MySQL.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

dependencies {
    'ox_lib',
    'HT_base'
}