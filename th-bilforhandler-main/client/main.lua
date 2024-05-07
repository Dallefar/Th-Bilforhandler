HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

function fetchLagerCars(category)
    local elements = {}
    
    HT.TriggerServerCallback('th-bilforhandler:carsLager', function(vehicles) 
      for i=1, #vehicles, 1 do
          table.insert(elements, {
              title = 'Køretøj: '..vehicles[i].name,
              description = 'PRIS: '..vehicles[i].price.. ' DKK \nKATEGORI: '..vehicles[i].category.. '\nMODEL: '..vehicles[i].model,
              onSelect = function()
                local vehicleModel = vehicles[i].model
                local vehiclePrice = vehicles[i].price
                local vehicleName = vehicles[i].name
                buyVehicle(vehicleModel, vehiclePrice, vehicleName)
              end 
          })
      end

      lib.registerContext({
          id = 'lager_cars2',
          title = 'Lager',
          menu = 'lager_cars',
          onBack = function()
          end,
          options = elements
      })

      lib.showContext('lager_cars2')
  end, category)
end

function lagerMenu()

  elements = {}

  for category, data in pairs(Config.bilKategorier) do
      table.insert(elements, {
        title = data.title,
        description = data.description,
        icon = data.icon,
        onSelect = function()
          fetchLagerCars(category)
        end
      })
  end 

  lib.registerContext({
    id = 'lager_cars',
    title = 'Bil kategorier',
    menu = 'main_menu',
    onBack = function()
    end,
    options = elements
  })

  lib.showContext('lager_cars')
end

function buyVehicle(model, price, name)
    local alert = lib.alertDialog({
        header = 'Køb køretøj',
        content = 'KØRETØJ: \n'..name.. '\n\n PRIS: '..price,
        centered = true,
        cancel = true,
        labels = {
          cancel = 'Fortryd',
          confirm = 'Køb køretøjet'
        }
    })

    if alert == 'confirm' then
      HT.TriggerServerCallback('th-bilforhandler:buyCarsToStock', function(hasMoney)
        if hasMoney then
            notifyVehicleBought(name)
        else
            notifyNoVehicleBought()
        end
      end, model, price)
    else
      notifyCanceled()
    end

end

function getPlayers()
  local closestplayer = HT.Game.GetClosestPlayer()
  local closePlayer = GetPlayerServerId(closestplayer)
  local seller = GetPlayerServerId(PlayerId())

  HT.TriggerServerCallback('th-bilforhandler:getNearestPlayers', function(players)
      local options = {}
      for k,v in pairs(players) do
          local playerId = v.source
          local firstName = v.firstname
          local lastName = v.lastname
          table.insert(options, {
              title = 'Navn: ' .. v.firstname..' '..v.lastname,
              description = 'Tryk her for at sælge vedkommende en bil',
              icon = 'user',
              onSelect = function()
                  chosseTheCar(playerId, firstName, lastName, seller)
              end
          })
      end

      lib.registerContext({
          id = 'sellveh_menu',
          title = 'Sælg køretøj',
          menu = 'main_menu',
          onBack = function()
          end,
          options = options,
      })
      lib.showContext('sellveh_menu')
  end, closePlayer)
end

-- Laver blip --
CreateThread(function()
	local blip = AddBlipForCoord(Config.Blip.coords)

	SetBlipSprite (blip, Config.Blip.sprite)
	SetBlipDisplay(blip, Config.Blip.display)
  SetBlipColour(blip, Config.Blip.color)
	SetBlipScale  (blip, Config.Blip.scale)
	SetBlipAsShortRange(blip, Config.Blip.shortrange)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(Config.Blip.bliptext)
	EndTextCommandSetBlipName(blip)
end)   


-- Function til at finde bil --
function GetVehicleInDirection()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local forwardVector = GetEntityForwardVector(playerPed)

	local endCoords = coords + forwardVector * 5.0

	local rayHandle =
		StartShapeTestRay(coords.x, coords.y, coords.z, endCoords.x, endCoords.y, endCoords.z, 10, playerPed, 0)
	local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

	return vehicle
end
