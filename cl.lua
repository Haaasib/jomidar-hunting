local framework = nil

if GetResourceState(Config.ESXPrefix) == "started" then
    framework = "ESX"
    ESX = exports[Config.ESXPrefix]:getSharedObject()
elseif GetResourceState(Config.QBPrefix) == "started" then
    framework = "QBCore"
    QBCore = exports[Config.QBPrefix]:GetCoreObject()
else
    return print('no framework')
end

local zones = {}

function createVisualZone(position, zoneId)
    local zone = {}
    local blip = AddBlipForRadius(position.x, position.y, position.z, 100.0)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 128)
    zone.blip = blip
    zones[zoneId] = zone  
    return zone
end

CreateThread(function()
    while true do
        Wait(0)
        for _, zone in ipairs(zones) do
            DrawMarker(1, zone.position.x, zone.position.y, zone.position.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, zone.size.x, zone.size.y, zone.size.z, zone.color.r, zone.color.g, zone.color.b, zone.color.a, false, false, 2, false, nil, nil, false)
        end
    end
end)

function removeVisualZone(zoneId)
    if zones[zoneId] then
        RemoveBlip(zones[zoneId].blip)  -- Remove the blip associated with the zone
        zones[zoneId] = nil             -- Clear the entry from the zones table
    else
        print("Zone with ID " .. zoneId .. " does not exist.")
    end
end

local function hasItem(item, amount)
    local function getItemCount(searchResult)
        if type(searchResult) == "table" then
            local totalCount = 0
            for _, count in pairs(searchResult) do
                totalCount = totalCount + count
            end
            return totalCount
        else
            return searchResult
        end
    end

    if framework == "QBCore" then
        if Config.OxInventory then
            local searchResult = exports.ox_inventory:Search('count', item)
            local itemCount = getItemCount(searchResult)
            return itemCount >= amount
        else
            return QBCore.Functions.HasItem(item, amount)
        end
    elseif framework == "ESX" then
        local searchResult = exports.ox_inventory:Search('count', item)
        local itemCount = getItemCount(searchResult)
        return itemCount >= amount
    else
        print("Unknown core specified in framework")
        return false
    end
end


function getCoords()
    local totalLocations = #Config.Location
    local randomIndex = math.random(1, totalLocations)
    local selectedLocation = Config.Location[randomIndex]
    return selectedLocation.zonecoords, selectedLocation.hintcoords, randomIndex
end

function StartHunting(contract)
    local groupid = exports["ps-playergroups"]:GetGroupID()
    local huntingCoords, hintCoords, selectedIndex = getCoords()
    local zoneId = groupid.."ZoneGroup" 
    createVisualZone(huntingCoords, zoneId)
    print(hintCoords)
    exports.interact:AddInteraction({
        coords = hintCoords,
        distance = 10.0, 
        interactDst = 4.0, 
        id = groupid..'CentralZone', 
        name = groupid..'CentralZone',
        options = {
            {
                label = 'See',
                action = function(entity, coords, args)
                    if contract == 'contract1' then
                        SpawnDeer()
                    elseif contract == 'contract2' then
                        SpawnDeer1()
                    elseif contract == 'contract3' then
                        SpawnDeer2()
                    end
                    exports.interact:RemoveInteraction(groupid..'CentralZone')
                end,
            },
        }
    })
end

function SpawnDeer()
    local groupid = exports["ps-playergroups"]:GetGroupID()
    local model = GetHashKey("a_c_deer")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnCoords = GetEntityCoords(playerPed)
    local zoneId = groupid.."ZoneGroup" 
    -- Spawn the deer at the hint coordinates
    local deer = CreatePed(28, model, spawnCoords.x + 10 , spawnCoords.y - 10, spawnCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedComponentVariation(deer, 0, 0, 1, 0)
    TaskWanderStandard(deer, 10.0, 10)

    -- Monitor the deer's health
    Citizen.CreateThread(function()
        while true do
            Wait(1000) -- Check every second
            if IsEntityDead(deer) then
                local deerCoords = GetEntityCoords(deer)
                exports.interact:AddInteraction({
                    coords = deerCoords,
                    distance = 4.0, 
                    interactDst = 2.0, 
                    id = groupid,
                    name = groupid..'deerdead', 
                    options = {
                        {
                            label = 'Examine the Deer',
                            action = function(entity, coords, args)
                                local hasItem = hasItem("weapon_knife", 1)
                                if hasItem then
                                    -- Add knife prop to player's hand
                                    local knifeModel = GetHashKey("prop_w_me_knife_01")
                                    RequestModel(knifeModel)
                                    while not HasModelLoaded(knifeModel) do
                                        Wait(1)
                                    end
                                    local knifeProp = CreateObject(knifeModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                                    AttachEntityToEntity(knifeProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.0, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1, true)

                                    QBCore.Functions.Progressbar("skiningdeer", "Taking Deer Skin...", 5000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true,
                                     }, {
                                        animDict = "amb@medic@standing@kneel@exit",
                                        anim = "exit",
                                        flags = 49,
                                     }, {}, {}, function()
                                        -- Success: Delete deer entity and knife prop
                                        DeleteEntity(deer)
                                        exports.interact:RemoveInteraction(groupid)
                                        DeleteEntity(knifeProp) -- Remove knife prop
                                        TriggerServerEvent('jomidar:hunting:addItem', 'leather', 1)
                                        TriggerServerEvent('jomidar:hunting:addItem', 'deer_head', 1)
                                        local propModel = GetHashKey("a3d_deer_dead")
                                        RequestModel(propModel)
                                        while not HasModelLoaded(propModel) do
                                            Wait(1)
                                        end
                                        local deerProp = CreateObject(propModel, deerCoords.x, deerCoords.y, deerCoords.z, true, true, false)
                                        SetEntityHeading(deerProp, GetEntityHeading(playerPed))
                                        exports.interact:AddInteraction({
                                            coords = deerCoords,
                                            distance = 4.0, 
                                            interactDst = 2.0, 
                                            id = groupid..'dead', 
                                            name = groupid..'dead',
                                            options = {
                                                label = 'Take Deer',
                                                action = function(entity, coords, args)
                                                    QBCore.Functions.Progressbar("random_task", "Doing something", 5000, false, true, {
                                                        disableMovement = true,
                                                        disableCarMovement = false,
                                                        disableMouse = false,
                                                        disableCombat = true,
                                                     }, {
                                                        animDict = "amb@medic@standing@kneel@exit",
                                                        anim = "exit",
                                                        flags = 49,
                                                     }, {}, {}, function()
                                                        TriggerServerEvent('jomidar:hunting:addItem', 'skinneddeer', 1)
                                                        DeleteEntity(deerProp)
                                                        exports.interact:RemoveInteraction(groupid..'dead')
                                                        removeVisualZone(zoneId)
                                                     end, function()
                                                        if framework == "QBCore" then
                                                            QBCore.Functions.Notify("You stopped doing it", "error")
                                                        elseif framework == "ESX" then
                                                           lib.notify({
                                                                title = 'Hunting',
                                                                description = 'You stopped doing it',
                                                                type = 'error'
                                                            })
                                                        end 
                                                     end)
                                                end,
                                            }
                                        })
                                    end, function()
                                        if framework == "QBCore" then
                                            QBCore.Functions.Notify("You stopped doing it", "error")
                                        elseif framework == "ESX" then
                                           lib.notify({
                                                title = 'Hunting',
                                                description = 'You stopped doing it',
                                                type = 'error'
                                            })
                                        end 
                                        DeleteEntity(knifeProp) 
                                    end)
                                else 
                                    if framework == "QBCore" then
                                        QBCore.Functions.Notify("You don't have a knife", "error")
                                    elseif framework == "ESX" then
                                       lib.notify({
                                            title = 'Hunting',
                                            description = 'You dont have a knife',
                                            type = 'error'
                                        })
                                    end 
                                end
                            end,
                        },
                    }
                })
                break
            end
        end
    end)
end

function SpawnDeer1()
    local groupid = exports["ps-playergroups"]:GetGroupID()
    local model = GetHashKey("a_c_deer")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnCoords = GetEntityCoords(playerPed)
    local zoneId = groupid.."ZoneGroup" 
    -- Spawn the deer at the hint coordinates
    local deer = CreatePed(28, model, spawnCoords.x + 10 , spawnCoords.y - 10, spawnCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedComponentVariation(deer, 0, 0, 1, 0)
    TaskWanderStandard(deer, 10.0, 10)
    -- Monitor the deer's health
    Citizen.CreateThread(function()
        while true do
            Wait(1000) -- Check every second
            if IsEntityDead(deer) then
                local deerCoords = GetEntityCoords(deer)
                exports.interact:AddInteraction({
                    coords = deerCoords,
                    distance = 4.0, 
                    interactDst = 2.0, 
                    id = groupid,
                    name = groupid..'deerdead', 
                    options = {
                        {
                            label = 'Examine the Deer',
                            action = function(entity, coords, args)
                                local hasItem = hasItem("weapon_knife", 1) -- QBCore.Functions.HasItem("weapon_knife", 1)
                                if hasItem then
                                    -- Add knife prop to player's hand
                                    local knifeModel = GetHashKey("prop_w_me_knife_01")
                                    RequestModel(knifeModel)
                                    while not HasModelLoaded(knifeModel) do
                                        Wait(1)
                                    end
                                    local knifeProp = CreateObject(knifeModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                                    AttachEntityToEntity(knifeProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.0, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1, true)

                                    QBCore.Functions.Progressbar("skiningdeer", "Taking Deer Skin...", 5000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true,
                                     }, {
                                        animDict = "amb@medic@standing@kneel@exit",
                                        anim = "exit",
                                        flags = 49,
                                     }, {}, {}, function()
                                        -- Success: Delete deer entity and knife prop
                                        DeleteEntity(deer)
                                        exports.interact:RemoveInteraction(groupid)
                                        DeleteEntity(knifeProp) -- Remove knife prop
                                        TriggerServerEvent('jomidar:hunting:addItem', 'leather', 1)
                                        TriggerServerEvent('jomidar:hunting:addItem', 'deer_head', 1)
                                        local propModel = GetHashKey("a3d_deer_dead")
                                        RequestModel(propModel)
                                        while not HasModelLoaded(propModel) do
                                            Wait(1)
                                        end
                                        local deerProp = CreateObject(propModel, deerCoords.x, deerCoords.y, deerCoords.z, true, true, false)
                                        SetEntityHeading(deerProp, GetEntityHeading(playerPed))
                                        exports.interact:AddInteraction({
                                            coords = deerCoords,
                                            distance = 4.0, 
                                            interactDst = 2.0, 
                                            id = groupid..'dead', 
                                            name = groupid..'dead',
                                            options = {
                                                label = 'Take Deer',
                                                action = function(entity, coords, args)
                                                    QBCore.Functions.Progressbar("random_task", "Doing something", 5000, false, true, {
                                                        disableMovement = true,
                                                        disableCarMovement = false,
                                                        disableMouse = false,
                                                        disableCombat = true,
                                                     }, {
                                                        animDict = "amb@medic@standing@kneel@exit",
                                                        anim = "exit",
                                                        flags = 49,
                                                     }, {}, {}, function()
                                                        TriggerServerEvent('jomidar:hunting:addItem', 'skinneddeer', 1)
                                                        DeleteEntity(deerProp)
                                                        exports.interact:RemoveInteraction(groupid..'dead')
                                                        removeVisualZone(zoneId)
                                                     end, function()
                                                        if framework == "QBCore" then
                                                            QBCore.Functions.Notify("You stopped doing it", "error")
                                                        elseif framework == "ESX" then
                                                           lib.notify({
                                                                title = 'Hunting',
                                                                description = 'You stopped doing it',
                                                                type = 'error'
                                                            })
                                                        end
                                                     end)
                                                end,
                                            }
                                        })
                                    end, function()
                                        if framework == "QBCore" then
                                            QBCore.Functions.Notify("You stopped doing it", "error")
                                        elseif framework == "ESX" then
                                           lib.notify({
                                                title = 'Hunting',
                                                description = 'You stopped doing it',
                                                type = 'error'
                                            })
                                        end
                                        DeleteEntity(knifeProp) 
                                    end)
                                else 
                                    if framework == "QBCore" then
                                        QBCore.Functions.Notify("You don't have a knife", "error")
                                    elseif framework == "ESX" then
                                       lib.notify({
                                            title = 'Hunting',
                                            description = 'You dont have a knife',
                                            type = 'error'
                                        })
                                    end
                                end
                            end,
                        },
                    }
                })
                break
            end
        end
    end)
end
function SpawnDeer2()
    local groupid = exports["ps-playergroups"]:GetGroupID()
    local model = GetHashKey("a_c_deer")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnCoords = GetEntityCoords(playerPed)
    local zoneId = groupid.."ZoneGroup" 
    -- Spawn the deer at the hint coordinates
    local deer = CreatePed(28, model, spawnCoords.x + 10 , spawnCoords.y - 10, spawnCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedComponentVariation(deer, 0, 0, 1, 0)
    TaskWanderStandard(deer, 10.0, 10)

    -- Monitor the deer's health
    Citizen.CreateThread(function()
        while true do
            Wait(1000) -- Check every second
            if IsEntityDead(deer) then
                local deerCoords = GetEntityCoords(deer)
                exports.interact:AddInteraction({
                    coords = deerCoords,
                    distance = 4.0, 
                    interactDst = 2.0, 
                    id = groupid,
                    name = groupid..'deerdead', 
                    options = {
                        {
                            label = 'Examine the Deer',
                            action = function(entity, coords, args)
                                local hasItem = hasItem("weapon_knife", 1)-- QBCore.Functions.HasItem("weapon_knife", 1)
                                if hasItem then
                                    -- Add knife prop to player's hand
                                    local knifeModel = GetHashKey("prop_w_me_knife_01")
                                    RequestModel(knifeModel)
                                    while not HasModelLoaded(knifeModel) do
                                        Wait(1)
                                    end
                                    local knifeProp = CreateObject(knifeModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                                    AttachEntityToEntity(knifeProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.0, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1, true)

                                    QBCore.Functions.Progressbar("skiningdeer", "Taking Deer Skin...", 5000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true,
                                     }, {
                                        animDict = "amb@medic@standing@kneel@exit",
                                        anim = "exit",
                                        flags = 49,
                                     }, {}, {}, function()
                                        -- Success: Delete deer entity and knife prop
                                        DeleteEntity(deer)
                                        exports.interact:RemoveInteraction(groupid)
                                        DeleteEntity(knifeProp) -- Remove knife prop
                                        TriggerServerEvent('jomidar:hunting:addItem', 'leather', 1)
                                        TriggerServerEvent('jomidar:hunting:addItem', 'deer_head', 1)
                                        local propModel = GetHashKey("a3d_deer_dead")
                                        RequestModel(propModel)
                                        while not HasModelLoaded(propModel) do
                                            Wait(1)
                                        end
                                        local deerProp = CreateObject(propModel, deerCoords.x, deerCoords.y, deerCoords.z, true, true, false)
                                        SetEntityHeading(deerProp, GetEntityHeading(playerPed))
                                        exports.interact:AddInteraction({
                                            coords = deerCoords,
                                            distance = 4.0, 
                                            interactDst = 2.0, 
                                            id = groupid..'dead', 
                                            name = groupid..'dead',
                                            options = {
                                                label = 'Take Deer',
                                                action = function(entity, coords, args)
                                                    QBCore.Functions.Progressbar("random_task", "Doing something", 5000, false, true, {
                                                        disableMovement = true,
                                                        disableCarMovement = false,
                                                        disableMouse = false,
                                                        disableCombat = true,
                                                     }, {
                                                        animDict = "amb@medic@standing@kneel@exit",
                                                        anim = "exit",
                                                        flags = 49,
                                                     }, {}, {}, function()
                                                        TriggerServerEvent('jomidar:hunting:addItem', 'skinneddeer', 1)
                                                        DeleteEntity(deerProp)
                                                        exports.interact:RemoveInteraction(groupid..'dead')
                                                        removeVisualZone(zoneId)
                                                     end, function()
                                                        if framework == "QBCore" then
                                                            QBCore.Functions.Notify("You stopped doing it", "error")
                                                        elseif framework == "ESX" then
                                                           lib.notify({
                                                                title = 'Hunting',
                                                                description = 'You stopped doing it',
                                                                type = 'error'
                                                            })
                                                        end                                                     end)
                                                end,
                                            }
                                        })
                                    end, function()
                                        if framework == "QBCore" then
                                            QBCore.Functions.Notify("You stopped doing it", "error")
                                        elseif framework == "ESX" then
                                           lib.notify({
                                                title = 'Hunting',
                                                description = 'You stopped doing it',
                                                type = 'error'
                                            })
                                        end                                        
                                        DeleteEntity(knifeProp) 
                                    end)
                                else 
                                    if framework == "QBCore" then
                                        QBCore.Functions.Notify("You don't have a knife", "error")
                                    elseif framework == "ESX" then
                                       lib.notify({
                                            title = 'Hunting',
                                            description = 'You dont have a knife',
                                            type = 'error'
                                        })
                                    end                               
                                 end
                            end,
                        },
                    }
                })
                break
            end
        end
    end)
end


local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
end

local itemProps = {
    skinneddeer = 'a3d_deer_dead',
    leather = 'a3d_leather_corp'
}

local holdingItem = nil
local heldProp = nil

local function hasDeChanged()
    local player = PlayerPedId()
    
    -- Loop through all item props
    for itemName, propModel in pairs(itemProps) do
        if hasItem(itemName, 1) then
            if holdingItem ~= itemName then
                holdingItem = itemName
                loadAnimDict('anim@heists@box_carry@')
                TaskPlayAnim(player, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                CarryAnimation()
                RequestModel(propModel)
                while not HasModelLoaded(propModel) do
                    Wait(100)
                end
                heldProp = CreateObject(GetHashKey(propModel), 0, 0, 0, true, true, true)
                AttachEntityToEntity(heldProp, player, GetPedBoneIndex(player, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 2, true)
                DisableControls()
            end
            return  -- Exit function since the item is found and being handled
        end
    end
    
    -- If no item is found, reset
    if holdingItem then
        ClearPedTasks(player)
        if heldProp then
            DeleteObject(heldProp)
            heldProp = nil
        end
        holdingItem = nil
    end
end

-- Continuous check for package status changes
CreateThread(function()
    while true do
        hasDeChanged()
        Wait(1250) -- Wait for a specified amount of time before checking again
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and holdingDeer then
        ClearPedTasks(PlayerPedId())
        if DeadDeer then
            DeleteObject(DeadDeer)
            DeadDeer = nil
        end
        holdingDeer = false
    end
end)

function DisableControls()
    CreateThread(function ()
        while holdingDeer do
            DisableControlAction(0, 21, true) -- Sprinting
            DisableControlAction(0, 22, true) -- Jumping
            DisableControlAction(0, 36, true) -- Ctrl
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 47, true) -- Weapon
            DisableControlAction(0, 58, true) -- Weapon (alternative)
            DisableControlAction(0, 263, true) -- Melee (general)
            DisableControlAction(0, 264, true) -- Melee (alternative)
            DisableControlAction(0, 257, true) -- Melee (another alternative)
            DisableControlAction(0, 140, true) -- Melee (another alternative)
            DisableControlAction(0, 141, true) -- Melee (another alternative)
            DisableControlAction(0, 142, true) -- Melee (another alternative)
            DisableControlAction(0, 143, true) -- Melee (another alternative)
            Wait(1)
        end
    end)
end

function CarryAnimation()
    CreateThread(function ()
        while holdingDeer do
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end

RegisterNetEvent('jomidar:hunting:start1', function()
    QBCore.Functions.TriggerCallback('jomidar:hunting:checkGroupSize', function(canStart)
        if canStart then
            StartHunting('contract1')
        else
            if framework == "QBCore" then
                QBCore.Functions.Notify("Your group does not meet the requirements", "error")
            elseif framework == "ESX" then
               lib.notify({
                    title = 'Hunting',
                    description = 'Your group does not meet the requirements',
                    type = 'error'
                })
            end
        end
    end, 'contract1')  -- Passing contract1 to the callback
end)

RegisterNetEvent('jomidar:hunting:start2', function()
    QBCore.Functions.TriggerCallback('jomidar:hunting:checkGroupSize', function(canStart)
        if canStart then
            StartHunting('contract2')
        else
            if framework == "QBCore" then
                QBCore.Functions.Notify("Your group does not meet the requirements", "error")
            elseif framework == "ESX" then
               lib.notify({
                    title = 'Hunting',
                    description = 'Your group does not meet the requirements',
                    type = 'error'
                })
            end
            end
    end, 'contract2')  -- Passing contract2 to the callback
end)

RegisterNetEvent('jomidar:hunting:start3', function()
    QBCore.Functions.TriggerCallback('jomidar:hunting:checkGroupSize', function(canStart)
        if canStart then
            StartHunting('contract3')
        else
            if framework == "QBCore" then
                QBCore.Functions.Notify("Your group does not meet the requirements", "error")
            elseif framework == "ESX" then
               lib.notify({
                    title = 'Hunting',
                    description = 'Your group does not meet the requirements',
                    type = 'error'
                })
            end        
        end
    end, 'contract3')  -- Passing contract3 to the callback
end)



Citizen.CreateThread(function()

    local blipCoords = vector3(713.7, -961.59, 30.4)
    local blip = AddBlipForCoord(blipCoords)
    SetBlipSprite(blip, 141) 
    SetBlipDisplay(blip, 4) 
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Leather Process")
    EndTextCommandSetBlipName(blip)
    exports.interact:AddInteraction({
        coords = vector3(713.7, -961.59, 30.4),
        distance = 4.0, -- optional
        interactDst = 2.0, -- optional
        id = 'myCoolUniqueId', -- needed for removing interactions
        name = 'interactionName', -- optional
        options = {
             {
                label = 'Process Leather',
                action = function(entity, coords, args)
                    local hasItem = hasItem("leather", 1)  --QBCore.Functions.HasItem("leather", 1)
        
                    if hasItem then
                        -- Start the progress bar with a mechanic animation
                        QBCore.Functions.Progressbar("random_task", "Packing Leather", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", -- Mechanic animation dictionary
                            anim = "machinic_loop_mechandplayer", -- Mechanic animation
                            flags = 49,
                        }, {}, {}, function()
                        TriggerServerEvent('jomidar:hunting:remove', 'leather', 1)
                        TriggerServerEvent('jomidar:hunting:addItem', 'deer_leather_packed', 1)
                        end, function()
                        end)
                    else
                        if framework == "QBCore" then
                            QBCore.Functions.Notify("You don't have the item", "error")
                        elseif framework == "ESX" then
                           lib.notify({
                                title = 'Hunting',
                                description = 'You dont have the item',
                                type = 'error'
                            })
                        end
                        -- Notify the player if they don't have the item
                    end
                end,
            },
            {
                label = 'Process Head',
                action = function(entity, coords, args)
                    local hasItem = hasItem("deer_head", 1) -- QBCore.Functions.HasItem("deer_head", 1)
                    if hasItem then
                        QBCore.Functions.Progressbar("random_task", "Packing Head", 5000, false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", -- Mechanic animation dictionary
                            anim = "machinic_loop_mechandplayer", -- Mechanic animation
                            flags = 49,
                        }, {}, {}, function()
                            TriggerServerEvent('jomidar:hunting:remove', 'deer_head', 1)

                            TriggerServerEvent('jomidar:hunting:addItem', 'deer_head_packed', 1)
                            end, function()

                        end)
                    else
                        if framework == "QBCore" then
                            QBCore.Functions.Notify("You don't have the item", "error")
                        elseif framework == "ESX" then
                           lib.notify({
                                title = 'Hunting',
                                description = 'You dont have the item',
                                type = 'error'
                            })
                        end
                    end
                end,
            },
        }
    })
end)

local function openHuntingBuyerMenu()
    -- Create the menu options
    local menuOptions = {
        {
            title = "Sell Leather Packed",
            description = "Sell your packed leather",
            event = "yourEventNameHere", -- Replace with the event to handle selling leather packed
            args = { type = "leather_packed" }
        },
        {
            title = "Sell Head Packed",
            description = "Sell your packed head",
            event = "yourEventNameHere", -- Replace with the event to handle selling head packed
            args = { type = "head_packed" }
        },
        {
            title = "Sell Deer Meat",
            description = "Sell your deer meat",
            event = "yourEventNameHere", -- Replace with the event to handle selling deer meat
            args = { type = "deer_meat" }
        },
        {
            title = "Close",
            description = "Close the menu",
            event = "ox:menu:close" -- This closes the menu in OxLib
        }
    }

    -- Open the menu using OxLib
    lib.registerContext({
        id = 'hunting_buyer_menu',
        title = 'Hunting Buyer',
        options = menuOptions
    })

    lib.showContext('hunting_buyer_menu')
end



RegisterNetEvent("jomidar:hunting:openHuntingBuyerMenu")
AddEventHandler("jomidar:hunting:openHuntingBuyerMenu", function()
    openHuntingBuyerMenu()
end)
RegisterNetEvent("yourEventNameHere")
AddEventHandler("yourEventNameHere", function(data)
    if data.type == "leather_packed" then
        local hasItem = hasItem("deer_leather_packed", 1) --QBCore.Functions.HasItem("deer_leather_packed", 1)
        if hasItem then
         TriggerServerEvent('jomidar:hunting:remove', 'deer_leather_packed' , 1)
         TriggerServerEvent('jomidar-hunting:addmoney',Config.Leather )
        else
            if framework == "QBCore" then
                QBCore.Functions.Notify("You dont have the item", "error")
            elseif framework == "ESX" then
               lib.notify({
                    title = 'Hunting',
               description = 'You dont have the item',
                      type = 'error'
                   })
            end
        end
    elseif data.type == "head_packed" then
        local hasItem = hasItem("deer_head_packed", 1) --QBCore.Functions.HasItem("deer_head_packed", 1)
        if hasItem then
            TriggerServerEvent('jomidar:hunting:remove', 'deer_head_packed' , 1)
            TriggerServerEvent('jomidar-hunting:addmoney', Config.DeerHead )
        else
            if framework == "QBCore" then
                QBCore.Functions.Notify("You dont have the item", "error")
            elseif framework == "ESX" then
               lib.notify({
                    title = 'Hunting',
               description = 'You dont have the item',
                      type = 'error'
                   })
            end        end
    elseif data.type == "deer_meat" then
        local hasItem =  hasItem("skinneddeer", 1) --QBCore.Functions.HasItem("skinneddeer", 1)
        if hasItem then
            TriggerServerEvent('jomidar:hunting:remove', 'skinneddeer' , 1)
            TriggerServerEvent('jomidar-hunting:addmoney', Config.SellSkinnedDeer )
        else
            if framework == "QBCore" then
                QBCore.Functions.Notify("You dont have the item", "error")
            elseif framework == "ESX" then
               lib.notify({
                    title = 'Hunting',
                    description = 'You dont have the item',
                    type = 'error'
                })
            end        
        end
    end
end)

-- Shooting protection system
if Config.ShootingProtection then
    local hasMusket = false

    function disablePlayerFiring()
        DisableControlAction(0, 24) -- INPUT_ATTACK
        DisableControlAction(0, 69) -- INPUT_VEH_ATTACK
        DisableControlAction(0, 70) -- INPUT_VEH_ATTACK2
        DisableControlAction(0, 92) -- INPUT_VEH_PASSENGER_ATTACK
        DisableControlAction(0, 114) -- INPUT_VEH_FLY_ATTACK
        DisableControlAction(0, 257) -- INPUT_ATTACK2
        DisableControlAction(0, 331) -- INPUT_VEH_FLY_ATTACK2

        DisableControlAction(0, 282) -- INPUT_VEH_FLY_ATTACK2
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 47, true)
        DisableControlAction(0, 58, true)
        DisablePlayerFiring(ped, true)
    end

    local function blockShooting()
        local playerId = PlayerId()
        local PlyPedId = PlayerPedId()
        Citizen.CreateThread(function()
            while hasMusket do
                Citizen.Wait(1)
                local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(playerId)
                local PedType = GetPedType(targetPed)

                if aiming then
                    if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and
                        (PedType == 4 or PedType == 5 or PedType == 2 or PedType == 1) then
                        DisablePlayerFiring(playerId, true)
                        disablePlayerFiring()
                    end
                else
                    if IsPedShooting(PlyPedId) then
                        SetCurrentPedWeapon(PlyPedId, "weapon_unarmed", true)
                    else
                        hasMusket = false
                    end
                end
            end
        end)
    end

    local hashTable = {}
    for key, weapon in pairs(Config.ProtectedWeapons) do
        table.insert(hashTable, GetHashKey(weapon))
    end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            for key, weaponHash in pairs(hashTable) do
                if hasMusket == false then
                    if GetSelectedPedWeapon(PlayerPedId()) == weaponHash then
                        hasMusket = true
                        blockShooting()
                    else
                        hasMusket = false
                    end
                end
            end
        end
    end)
end