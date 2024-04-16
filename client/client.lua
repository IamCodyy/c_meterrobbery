local QBCore = exports['qb-core']:GetCoreObject()

local robbed = { 3423423424 }

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

RegisterNetEvent("c-meterrobbery:client:startRobbing", function()
    local hasItem = QBCore.Functions.HasItem(Config.RequiredItems)
    local cashAmount = math.random(Config.MinCash, Config.MaxCash)

    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local MeterFound = false

    for i = 1, #Config.Models do
        local meter = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, GetHashKey(Config.Models[i]), false, false, false)
        local meterPos = GetEntityCoords(meter)
        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, meterPos.x, meterPos.y, meterPos.z, true)

        if dist < 1.5 then
            for i = 1, #robbed do
                if robbed[i] == meter then
                    MeterFound = true
                end
                if i == #robbed and MeterFound then
                    QBCore.Functions.Notify('This meter has already been robbed.', 'error')
                elseif i == #robbed and not MeterFound then
                    if hasItem then
                        loadAnimDict('veh@break_in@0h@p_m_one@')
                        TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
                        exports['ps-ui']:Circle(function(success)
                            if success then
                                ParticleFX(meter)

                                loadAnimDict('anim@scripted@player@freemode@tun_prep_grab_midd_ig3@male@')
                                TaskPlayAnim(PlayerPedId(), "anim@scripted@player@freemode@tun_prep_grab_midd_ig3@male@", "tun_prep_grab_midd_ig3", 3.0, 3.0, -1, 16, 0, 0, 0, 0)

                                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10, 'coins', 0.4)
                                TriggerServerEvent('c-meterrobbery:server:FinishRobbery', cashAmount)
                                TriggerEvent('c-meterrobbery:client:AlertPolice')

                                ClearPedTasksImmediately(GetPlayerPed())

                                TriggerServerEvent('c-meterrobbery:server:meterCoolDown', meter)
                                table.insert(robbed, meter)
                            else
                                QBCore.Functions.Notify('Break-in attempt failed.', 'error', 3000)
                                ClearPedTasksImmediately(GetPlayerPed())
                            end
                        end, 4, 20) -- NumberOfCircles, MS
                    else
                        QBCore.Functions.Notify('You are missing required items.', 'error', 3000)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('c-meterrobbery:client:AlertPolice', function()
    local coords = GetEntityCoords(PlayerPedId(), true)
    local chance = math.random(1, 100)
    if chance <= Config.PoliceChance then
        local policeJobs = { 'police', 'csis' }
        exports["ps-dispatch"]:CustomAlert({
            coords = coords,
            job = policeJobs,
            message = 'Parking Meter Robbery',
            dispatchCode = '10-??',
            firstStreet = coords,
            description = 'Parking Meter Robbery',
            radius = 0,
            sprite = 276,
            color = 1,
            scale = 1.0,
            length = 3,
            gender = true,
        })
    end
end)

RegisterNetEvent('c-meterrobbery:client:refreshMeter')
AddEventHandler('c-meterrobbery:client:refreshMeter', function(object)
    for i = 1, #robbed do
        if robbed[i] == object then
            table.remove(robbed, i)
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    createMeterTargets()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    removeMeterTargets()
end)

-- Not sure if needed, but better to be safe than sorry?
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    createMeterTargets()
end)

AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    removeMeterTargets()
end)