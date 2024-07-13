local QBCore = exports['qb-core']:GetCoreObject()

-- Check if the player has a pilot license in ps-inventory
function hasPilotLicense(player)
    local playerData = QBCore.Functions.GetPlayer(player)
    if not playerData then
        return false
    end

    local citizenid = playerData.PlayerData.citizenid
    local inventory = exports['ps-inventory']:LoadInventory(player, citizenid)
    if not inventory then
        return false
    end

    for slot, item in pairs(inventory) do
        if item.name == 'pilot_license' then
            return true
        end
    end

    return false
end

-- Check if the player has the ACE permission to fly aircraft
function hasAcePermission(player)
    return IsPlayerAceAllowed(player, "allow.flight")
end

RegisterServerEvent('checkForAircraft')
AddEventHandler('checkForAircraft', function(vehicle)
    local src = source
    local isPlayerInVehicle = false

    -- Check if the player is the driver of the vehicle
    if GetPedInVehicleSeat(vehicle, -1) == src then
        -- If the player is the driver, check for license or permission
        if not hasPilotLicense(src) and not hasAcePermission(src) then
            TriggerClientEvent('kickFromVehicle', src)
        end
    else
        -- If the player is a passenger, allow them to stay in the vehicle
        isPlayerInVehicle = true
    end

    TriggerClientEvent('updatePlayerVehicleState', src, isPlayerInVehicle)
end)
