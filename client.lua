-- why do yoiu think its empty

local isInAircraft = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and (IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed)) then
            local vehicleDriver = GetPedInVehicleSeat(vehicle, -1)
            if vehicleDriver == playerPed then
                TriggerServerEvent('checkForAircraft', vehicle)
            else
                isInAircraft = true
                TriggerServerEvent('updatePlayerVehicleState', true)
            end
        else
            isInAircraft = false
            TriggerServerEvent('updatePlayerVehicleState', false)
        end
    end
end)

RegisterNetEvent('kickFromVehicle')
AddEventHandler('kickFromVehicle', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 16)
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"You are not allowed to fly aircraft without a pilot license!"}
        })
    end
end)

RegisterNetEvent('updatePlayerVehicleState')
AddEventHandler('updatePlayerVehicleState', function(state)
    isInAircraft = state
end)
