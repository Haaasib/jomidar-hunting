-- qb-core/shared/items.lua
```
-- Deer Head item
['deer_head'] = {
    name = 'deer_head',
    label = 'Deer Head',
    weight = 1000, -- Adjust the weight as needed
    type = 'item',
    image = 'deer_head.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A deer head, a trophy from hunting.'
},
['deer_head_packed'] = {
    name = 'deer_head_packed',
    label = 'Deer Head Packed',
    weight = 1000, -- Adjust the weight as needed
    type = 'item',
    image = 'deer_head.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A deer head, a trophy from hunting.'
},
['deer_leather_packed'] = {
    name = 'deer_leather_packed',
    label = 'Leather Packed',
    weight = 1000, -- Adjust the weight as needed
    type = 'item',
    image = 'leather.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A deer head, a trophy from hunting.'
},
-- Leather item
['leather'] = {
    name = 'leather',
    label = 'Leather',
    weight = 500, -- Adjust the weight as needed
    type = 'item',
    image = 'leather.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A piece of leather obtained from skinning an animal.'
},
-- Skinned Deer item
['skinneddeer'] = {
    name = 'skinneddeer',
    label = 'Skinned Deer',
    weight = 2000, -- Adjust the weight as needed
    type = 'item',
    image = 'skinnedeer.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A deer that has been skinned. Ready for further processing.'
},
```
```
--- ox inventory 
-- Deer Head item
['deer_head'] = {
    label = 'Deer Head',
    weight = 1000, -- Adjust the weight as needed
    stack = true, -- Whether this item can be stacked
    close = true, -- Should the inventory close after using the item
    description = 'A deer head, a trophy from hunting.',
    client = {
        image = 'deer_head.png'
    }
},

-- Deer Head Packed item
['deer_head_packed'] = {
    label = 'Deer Head Packed',
    weight = 1000, -- Adjust the weight as needed
    stack = true,
    close = true,
    description = 'A deer head, a trophy from hunting, packed for sale.',
    client = {
        image = 'deer_head.png'
    }
},

-- Deer Leather Packed item
['deer_leather_packed'] = {
    label = 'Leather Packed',
    weight = 1000, -- Adjust the weight as needed
    stack = true,
    close = true,
    description = 'Packed deer leather, ready for sale.',
    client = {
        image = 'leather.png'
    }
},

-- Leather item
['leather'] = {
    label = 'Leather',
    weight = 500, -- Adjust the weight as needed
    stack = true,
    close = true,
    description = 'A piece of leather obtained from skinning an animal.',
    client = {
        image = 'leather.png'
    }
},

-- Skinned Deer item
['skinneddeer'] = {
    label = 'Skinned Deer',
    weight = 2000, -- Adjust the weight as needed
    stack = true,
    close = true,
    description = 'A deer that has been skinned. Ready for further processing.',
    client = {
        image = 'skinnedeer.png'
    }
}
```
ITEMS ICONS ARE IN PNG FOLDER CHECK

--- weapon setup

If using OX then place in ox_inventory/data/weapons.lua
  ```  ['weapon_huntingriflenew'] 		           	 = { label = 'Hunting Rifle', 			weight = 1000,	durability = 0.0,	ammoname = 'ammo-sniper',},```
else 
----- items.lua
```
['weapon_huntingriflenew'] 		 = {['name'] = 'weapon_huntingriflenew', 	 	  	['label'] = 'Hunting Rifle', 			['weight'] = 23000, 	['type'] = 'weapon', 	['ammotype'] = 'AMMO_SNIPER',			['image'] = 'weapon_huntingriflenew.png', 					['unique'] = true, 		['useable'] = false,["created"] = nil,	['description'] = 'A very accurate Rifle for hunting'},
```
----- weapons.lua
```
[`weapon_huntingriflenew`] 		 = {['name'] = 'weapon_huntingriflenew', 	 	['label'] = 'Hunting Rifle', 				['ammotype'] = 'AMMO_SNIPER',	['damagereason'] = 'Ended / Sniped / Shot down / Floored'},
```
----- qb-weapons/config.lua
```
['weapon_huntingriflenew'] 	     = 0.20,
```
----- qb-ambulancejob/config.lua
```
[`WEAPON_HUNTINGRIFLENEW`] = Config.WeaponClasses['HIGH_CALIBER'],
```
----- qb-smallresources/client/recoil.lua
```
[GetHashKey("weapon_huntingrifle")] = 0.4,
```

https://github.com/overextended/ox_lib/releases

if you dont have my tablet script then download this script

https://github.com/Project-Sloth/ps-playergroups

and if you want to buy my tablet script just check the tebex 

