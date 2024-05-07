HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

function spawnCar(veh, plate)
    local spawnedCar = false

    for _, spawnPoint in ipairs(Config.demoSpawnPoints) do
        spawnCoords = spawnPoint.coords
        local radius = spawnPoint.radius
        local isSpawnPointClear = isSpawnClear(spawnCoords)

        if isSpawnPointClear then
            bil = veh
            HT.Game.SpawnVehicle('' .. bil .. '', spawnCoords, spawnPoint.heading, function(vehicle)
                notifyCarDemo(bil)
                
                if plate then
                    SetVehicleNumberPlateText(vehicle, plate)
                end
            end)
            spawnedCar = true
            break
        end
    end

    if not spawnedCar then
        notifyIngenPlads(veh)
    end
end


function sellVehicle(nummerPlade, price)
    local sellPrice = Config.SellVehicleProcent * price
    local finalPrice = price - sellPrice 

    local alert = lib.alertDialog({
        header = 'Sælg '..nummerPlade,
        content = 'Ønsker du at sælge køretøjet? \n\n Indkøbspris '..price..' DKK \n\n Salgspris '..HT.Math.Round(finalPrice).. ' DKK',
        centered = true,
        cancel = true,
        labels = {
            cancel = 'Fortryd',
            confirm = 'Ja, sælg køretøjet'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('th-bilforhandler:sellVehicle', nummerPlade, price)
        notifyVehicleSoldToFactory(nummerPlade, finalPrice)
    else
        notifyCanceled()
    end

end

function getCars()
    HT.TriggerServerCallback('th-bilforhandler:fetchCars', function(data) 
      carsStock = {}

      if next(data) == nil then
        notifyIngenBilerLager()
    else
        for _, v in pairs(data) do
            local bilModel = v.model
            local nummerPlade = v.nummerplade
            local price = v.pris
            table.insert(carsStock, {
                title = 'MODEL: ' ..v.model,
                description = 'PRIS: ' .. v.pris.. '\n NUMMERPLADE: '..v.nummerplade,
                icon = 'car-side',
                onSelect = function()
                    carChoose(bilModel, nummerPlade, price)
                end
            })
        end

        lib.registerContext({
            id = 'biler',
            title = 'Biler',
            menu = 'main_menu',
            onBack = function()
            end,
            options = carsStock,
        })

      lib.showContext('biler')

    end
  end)
end

function carChoose(bilModel, nummerPlade, price)
    lib.registerContext({
        id = 'køretøj_menu',
        title = 'Køretøj: '..bilModel,
        menu = 'biler',
        onBack = function()
            getCars()
        end,
        options = {
          {
            title = 'Fremvis '..bilModel,
            icon = 'eye',
            
            onSelect = function()
                spawnCar(bilModel, nummerPlade)
            end
          },
          {
            title = 'Sælg '..bilModel,
            icon = 'coins',
            onSelect = function()
                sellVehicle(nummerPlade, price)
            end
          },
        }
      })
      lib.showContext('køretøj_menu')
end

function isSpawnClear(coords)
    local clear = false
    local handle = StartShapeTestCapsule(coords - 5.0, coords + 5.0, 2.5, 10, -1)
    local _, _, _, _, result = GetShapeTestResult(handle)
    if result == 0 then
        clear = true
    end
    return clear
  end