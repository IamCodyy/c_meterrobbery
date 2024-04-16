local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("c-meterrobbery:server:FinishRobbery", function(amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney("cash", amount, 'Robbed parking meter')
    TriggerClientEvent('QBCore:Notify', source, 'You stole $'..amount..' from this meter.', 'success', 2500)
end)

RegisterServerEvent('c-meterrobbery:server:meterCoolDown')
AddEventHandler('c-meterrobbery:server:meterCoolDown', function(meter)
    startTimer(source, meter)
end)

function startTimer(id, object)
    local timer = 10 * 1000
    while timer > 0 do
        Wait(10)
        timer = timer - 10
        if timer == 0 then
        TriggerClientEvent('c-meterrobbery:client:refreshMeter', id, object)
        end
    end
end