fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name         'jomidar-huting'
version      '2.0.0'
description  'A multi-framework hunting'
author       'Hasib'

shared_scripts {
    'cfg.lua',
    '@ox_lib/init.lua'
}

server_scripts {
    'sv.lua',
    '@mysql-async/lib/MySQL.lua',
	'@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'cl.lua',
    'nui.lua'
}

ui_page "web/index.html"

files {
	"web/*.html",
    "web/*.css",
    "web/*.js",
    "web/fonts/*.ttf",
    "web/*.png"
}

escrow_ignore {
    'cfg.lua'
}