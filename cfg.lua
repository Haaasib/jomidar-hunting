Config = {}
--- FRAMEWORK CONFIG AUTOMATIC 
Config.QBPrefix = "qb-core"  -- your qbcore prefix dont edit if you dont know what youre doing
Config.ESXPrefix = "es_extended" -- your esx prefix dont edit if you dont know what youre doing
Config.OxInventory = false -- if youre using ox inventory then make it true or false
Config.ShootingProtection = true
Config.ProtectedWeapons = { 'weapon_huntingriflenew' }
Config.Location = {
    [1] = {
        zonecoords = vector3(-705.32, 5159.75, 114.62),
        hintcoords = vector3(-705.59, 5161.87, 113.39)
    },
    [2] = {
        zonecoords = vector3(-503.24, 4935.34, 147.31),
        hintcoords = vector3(-525.52, 4950.37, 146.42)
    },
    [3] = {
        zonecoords = vector3(-293.90, 4790.23, 206.50),
        hintcoords = vector3(-297.70, 4798.02, 206.61)
    },
    [4] = {
        zonecoords = vector3(-10.20, 4531.23, 109.91),
        hintcoords = vector3(11.45, 4525.54, 105.24)
    },
    [5] = {
        zonecoords = vector3(614.57, 4239.80, 54.14),
        hintcoords = vector3(632.10, 4239.39, 53.40)
    },
    [6] = {
        zonecoords = vector3(-60.06, 4382.52, 54.87),
        hintcoords = vector3(-66.77, 4371.24, 53.01)
    },
    [7] = {
        zonecoords = vector3(-831.12, 5965.87, 19.95),
        hintcoords = vector3(-823.76, 5959.50, 19.02)
    },
    [8] = {
        zonecoords = vector3(-1531.89, 4898.41, 65.15),
        hintcoords = vector3(-1538.72, 4890.89, 62.75)
    },
    [9] = {
        zonecoords = vector3(-1617.51, 5017.43, 45.04),
        hintcoords = vector3(-1615.18, 5028.90, 41.86)
    },
    [10] = {
        zonecoords = vector3(-1676.72, 4246.51, 78.71),
        hintcoords = vector3(-1672.67, 4235.28, 79.28)
    },
    [11] = {
        zonecoords = vector3(-1458.43, 4479.16, 19.49),
        hintcoords = vector3(-1449.89, 4479.98, 19.39)
    }
}

Config.SellSkinnedDeer = 100
Config.DeerHead = 150
Config.Leather = 200

Config.Contract = {
    contract1 = {min = 1, max = 2},  --- group member need
    contract2 = {min = 2, max = 3},  --- group member need
    contract3 = {min = 1, max = 4}   --- group member need
}