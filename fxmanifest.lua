fx_version 'bodacious'
game 'gta5'

ui_page 'html/zh_document.html'

files {
	'html/zh_document.html',
	'html/img/seal.png',
	'html/img/document.jpg',
	'html/img/signature.png',
	'html/zh_style.css',
	'html/language_zh.js',
	'html/language_en.js',
	'html/zh_script.js',
	'html/jquery-3.4.1.min.js',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/server.lua',
}

client_scripts {
	'config.lua',
	'client/client.lua',
}

lua54 'yes'

