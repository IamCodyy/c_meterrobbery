function createMeterTargets()
    exports['qb-target']:AddTargetModel(Config.Models, {
        options = {
        {
            name = 'meterRobbery',
            type = 'client',
            label = 'Rob Parking Meter',
            icon = 'fas fa-coins',
            item = Config.RequiredItems,
            event = "c-meterrobbery:client:startRobbing",
        },
    },
    distance = 1.5,
    })
end

function removeMeterTargets()
    exports['qb-target']:RemoveTargetModel(Config.Models, 'meterRobbery')
end

function ParticleFX(ENT)
    local entCoords = GetEntityCoords(ENT)
    local offset, rotation = vec3(entCoords.x, entCoords.y, entCoords.z), GetEntityRotation(ENT)
    local dict, ptfx = 'core', 'ent_brk_coins'

    RequestNamedPtfxAsset(dict, 1000)

    UseParticleFxAsset(dict)

    local startPTFX = StartParticleFxLoopedAtCoord(ptfx, offset.x, offset.y, (offset.z + 1), rotation.x, rotation.y, rotation.z, 1.0, false, false, false)

    RemoveNamedPtfxAsset(dict)
    StopParticleFxLooped(startPTFX, false)
end