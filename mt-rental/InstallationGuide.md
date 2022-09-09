# MT RENTAL 2.0 INSTALLATION GUIDE

# Add to your qb-core/shared/items.lua:
```
	['renting_contract'] 			 = {['name'] = 'renting_contract', 				['label'] = 'Renting Contract', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'renting_contract.png', 		['unique'] = true, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
```

# Add to your qb-inventory/html/js/app.js:
```
 else if (itemData.name == "renting_contract") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>Name: " + itemData.info.name + "</p> <p>Vehicle Plate: " + itemData.info.plate + "</p> <p>Renting Time: " + itemData.info.time + "</p> <p>Paid Price: " + itemData.info.price + "</p> <p>Vehicle Model: " + itemData.info.vehiclename + "</p>");
        }
```

# Add image at images folder to your qb-inventory/html/images
# Configure the script at your away and enjoy :)