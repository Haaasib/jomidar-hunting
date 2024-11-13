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

local ox_inventory = exports.ox_inventory

local function getPlayerFromId(src)
    if framework == "ESX" then
        return ESX.GetPlayerFromId(src)
    elseif framework == "QBCore" then
        return QBCore.Functions.GetPlayer(src)
    else
        print("Unknown framework specified.")
        return nil
    end
end
RegisterNetEvent('jomidar:hunting:remove', function(item, ammount)
    local src = source
    local xPlayer = getPlayerFromId(source)
    if xPlayer then
        if framework == "QBCore" then
            xPlayer.Functions.RemoveItem(item, ammount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
        elseif framework == "ESX" then
            ox_inventory:RemoveItem(source, item, ammount)
        end
    end
end)

RegisterNetEvent('jomidar:hunting:addItem', function(item, ammount)
    local src = source
    local xPlayer = getPlayerFromId(source)
    if xPlayer then
        if framework == "QBCore" then
            xPlayer.Functions.AddItem(item, ammount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
        elseif framework == "ESX" then
            exports.ox_inventory:AddItem(src, item, ammount)
        end
    end
end)
RegisterNetEvent('jomidar:hunting:startgroup', function()
    local src = source
    local xPlayer = getPlayerFromId(source)
    local playerID = xPlayer.PlayerData.source
    local groupID = exports["ps-playergroups"]:FindGroupByMember(playerID)

    if groupID and groupID ~= 0 then
        exports["ps-playergroups"]:GroupEvent(groupID, 'jomidar:hunting:start1') 
    end
end)
QBCore.Functions.CreateCallback('jomidar:hunting:checkGroupSize', function(source, cb, contract)
    local xPlayer = getPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end

    local playerID = xPlayer.PlayerData.source
    local groupID = exports["ps-playergroups"]:FindGroupByMember(playerID)

    if groupID and groupID ~= 0 then
        local groupSize = exports["ps-playergroups"]:getGroupSize(groupID)
        
        -- Retrieve min and max group size from config based on the contract
        local minGroupSize = Config.Contract[contract].min
        local maxGroupSize = Config.Contract[contract].max

        if groupSize >= minGroupSize and groupSize <= maxGroupSize then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)  -- Not in any group
    end
end)

RegisterNetEvent('jomidar-hunting:addmoney', function(amount, groupid)
    local src = source
    local xPlayer = getPlayerFromId(source)
    if xPlayer then
        if framework == "ESX" then
            if amount == Config.SellSkinnedDeer then
                xPlayer.removeAccountMoney("bank", amount)
            elseif amount == Config.DeerHead then
                xPlayer.removeAccountMoney("bank", amount)
            elseif amount == Config.Leather then
                xPlayer.removeAccountMoney("bank", amount)
            end
    elseif framework == "QBCore" then
            if amount == Config.SellSkinnedDeer then
                xPlayer.Functions.AddMoney('cash', amount, 'jomidar-addmoney')
                TriggerClientEvent('QBCore:Notify', src, "Great Job You Got"..amount.."$", "success")
            elseif amount == Config.DeerHead then
                xPlayer.Functions.AddMoney('cash', amount, 'jomidar-addmoney')
                TriggerClientEvent('QBCore:Notify', src, "Great Job You Got"..amount.."$", "success")
            elseif amount == Config.Leather then
                xPlayer.Functions.AddMoney('cash', amount,'jomidar-addmoney')
                TriggerClientEvent('QBCore:Notify', src, "Great Job You Got"..amount.."$", "success")
            end
        end
    end
end)

