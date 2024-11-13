function showHuntingUI()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "show" })
end

function hideHuntingUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
end

RegisterNetEvent("jomidar:hunting:shownui")
AddEventHandler("jomidar:hunting:shownui", function()
    showHuntingUI()
end)

RegisterNUICallback('takeContract', function(data, cb)
    if data.contract == 'tc1' then
        TriggerEvent('jomidar:hunting:start1')
    elseif data.contract == 'tc3' then
        TriggerEvent('jomidar:hunting:start2')
    elseif data.contract == 'tc4' then
        TriggerEvent('jomidar:hunting:start3')
    end
    cb('ok') -- You can respond to the NUI callback with a success message
end)
RegisterNUICallback("closeUI", function(data, cb)
    hideHuntingUI()
    cb("ok")
end)