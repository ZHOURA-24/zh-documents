# zh-documents
esx_documents convert qb-core 
original repository : https://github.com/apoiat/ESX_Documents

# preview 
https://youtu.be/F1prso-TRVM

# install
add this to qb-core/shared/items.lua

['documents'] 				 	 = {['name'] = 'documents', 			  	  		['label'] = 'documents', 				['weight'] = 200, 		['type'] = 'item', 		['image'] = 'documents.png', 			['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'documents'},

add this to qb-inventorty/html/js/app.js

 } else if (itemData.name == "documents") {
     $(".item-info-title").html("<p>" + itemData.label +  "</p>");
     $(".item-info-title").html("<p>" + itemData.info.description + "</p>");
     $(".item-info-description").html(
 );
