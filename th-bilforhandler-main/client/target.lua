-- HT Library --
HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) 
            HT = obj 
        end)
        Citizen.Wait(0)
    end
end)

-- Main Menu -- 
exports.ox_target:addSphereZone({
    coords = Config.Job.Menu.targetCoords, 
    radius = 1,
    debug = drawZones,
    options = {
        {
            icon = 'fa-solid fa-hashtag',
            label = 'Job menu',
            onSelect = function()
                job(function(isJob)
                    if isJob == true then
                        mainMenu(true) 
                    elseif isJob == false then
                        mainMenu(false) 
                    else
                        notifynomoney() 
                    end
                end)
            end
        },
    }
})

-- Vehicle Fjern -- 
for _, spawnPoint in ipairs(Config.demoSpawnPoints) do
    exports.ox_target:addSphereZone({
        coords = spawnPoint.coords,
        radius = 1,
        debug = drawZones,
        options = {
            {
                icon = 'fa-solid fa-hashtag',
                label = 'Fjern Køretøjet',
                onSelect = function()
                    job(function(isJob)
                        if isJob == true then
                            local vehicle = GetVehicleInDirection()
                            if DoesEntityExist(vehicle) then
                                HT.Game.DeleteVehicle(vehicle)
                            end
                        elseif isJob == false then
                            local vehicle = GetVehicleInDirection()
                            if DoesEntityExist(vehicle) then
                                HT.Game.DeleteVehicle(vehicle)
                            end
                        else
                            notifynomoney()
                        end
                    end)
                end
            },
        }
    })
end

-- Job Callback Funktion -- 
function job(callback)
    HT.TriggerServerCallback('TH:JobCallback', function(data)
        if data == Config.Job.Profession then 
            callback(true)  
        elseif data == Config.Job.Bossgroup then 
            callback(false) 
        else 
            callback(nil) 
        end
    end)
end
