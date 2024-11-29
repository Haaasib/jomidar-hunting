PREVIEW : https://www.youtube.com/watch?v=uFAzmSYjWXg&t=15s
CFX FORUM : https://forum.cfx.re/t/free-qbcore-esx-jomidar-hunting-script-inspired-ui/5262923

# Credits
* [Hasib](https://github.com/Haaasib/) - Creator
* [QBCore Devs](https://github.com/qbcore-framework/) - For making an awesome framework and enabling me to do this.
* QBCore Community - Thank you so much for everyone who's been testing this!

# If You want to report bugs and want support Join Our Discord Server 
https://discord.com/invite/T7du2nJfyN

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
```  
  ['weapon_huntingriflenew'] 		           	 = { label = 'Hunting Rifle', 			weight = 1000,	durability = 0.0,	ammoname = 'ammo-sniper',},
```
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

## Dependencies

[OX_LIB](https://github.com/overextended/ox_lib)

[PS-PLAYERGROUPS](https://github.com/Project-Sloth/ps-playergroups)

[INTERACT](https://github.com/darktrovx/interact)

[0R-NPCDIALOG](https://github.com/0resmon/resource-pack/tree/main/0r-npcdialog)

[PROP](https://haaasib.tebex.io/category/scripts)
![image](https://github.com/user-attachments/assets/05309b58-87c7-4545-9ef1-61996f35c5b3)

ADD THIS TO 0R-NPCDIALOG

```
Config = {
    MenuAlign = "left", -- left or right
    Dialogs = {

        { 
            Ped = {
                Enable = true,
                coords = vector4(-341.42, 6066.42, 30.47, 314.03),
                hash = "a_m_m_farmer_01", -- Check here https://docs.fivem.net/docs/game-references/ped-models/
                animDict = "amb@world_human_hang_out_street@female_arms_crossed@idle_a",
                animName = "idle_a"
            },
            Blip = { -- https://docs.fivem.net/docs/game-references/blips/
                Enable = false,
                coords = vector3(1304.48, 4229.45, 33.91),
                sprite = 88,
                color = 2,
                scale = 0.5,
                text = "Fishing"
            },
            Menu = {
                Label = "Hunting",
                Description = "MENU",
                Icon = "fas fa-briefcase", -- https://fontawesome.com/v5/search | You can use Pro Icons too
            },
            AutoMessage = { -- This is an automatic message system that sends automatic message when you open dialog menu.
                Enable = true,
                AutoMessages = {
                    {type = "question", text = "Welcome, choose what you want to do."},
                    --{type = "message",  text = "This is an automatic message."}
                }
            },
            Buttons = {
                [1] = { -- Button 2 and answers
                    label = "FStart Contract",
                    systemAnswer = {enable = true, type = "message", text = "On Shop"},
                    playerAnswer = {enable = true, text ="Ok"},
                    maxClick = 1,
                    onClick = function()
                        -- Write your export or events here
                        -- exports[GetCurrentResourceName()]:closeMenu()
                        TriggerEvent('jomidar:hunting:shownui')
                        exports[GetCurrentResourceName()]:closeMenu()
                    end
                },
                [2] = { -- Button 3 and answers
                    label = "Sell Stuffs",
                    systemAnswer = {enable = true, type = "message", text = "Check Leaderboard"},
                    playerAnswer = {enable = true, text = "Checking"},
                    maxClick = 1,
                    onClick = function() 
                        TriggerServerEvent('jomidar:hunting:openHuntingBuyerMenu')
                        exports[GetCurrentResourceName()]:closeMenu()
                    end
                },
                [3] = { -- Button 4 and answers
                    label = "Leave Conversation",
                    systemAnswer = {enable = false, type = "message", text = "The authorities are closing in. We need a clear path for extraction."},
                    playerAnswer = {enable = false, text = "Understood. Head to the rendezvous point, and be ready to move fast."},
                    maxClick = 1,
                    onClick = function()
                        -- Write your export or events here
                        exports[GetCurrentResourceName()]:closeMenu()
                    end
                },
                -- Don't write more than 5 buttons
            },
            Interaction = {
                Target = {
                    Enable = true,
                    Distance = 2.0,
                    Label = "Contact",
                    Icon = "fa-solid fa-address-book"
                },
                Text = {
                    Enable = true,
                    Distance = 3.0,
                    Label = "[E] Contact"
                },
                DrawText = {
                    Enable = false,
                    Distance = 3.0,
                    Show = function()
                        exports["qb-core"]:DrawText("Contact", "left")

                    end,
                    Hide = function()
                        exports["qb-core"]:HideText()
                    end
                }
            }
        },
    }
}
```
