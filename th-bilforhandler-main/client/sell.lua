HT = nil

Citizen.CreateThread(function()
	while HT == nil do
		TriggerEvent("HT_base:getBaseObjects", function(obj)
			HT = obj
		end)
		Citizen.Wait(0)
	end
end)

sold = nil

function sellMenu(playerId, firstName, lastName)
	lib.registerContext({
		id = "sell_menu",
		title = "Borger: " .. firstName .. " " .. lastName,
		menu = "sellveh_menu",
		onBack = function() end,
		options = {
			{
				title = "Vælg et køretøj",
				icon = "user",
				onSelect = function()
					chosseTheCar(playerId, firstName, lastName)
				end,
			},
			{
				title = "Faktura",
				icon = "coins",
				onSelect = function() end,
			},
		},
	})
	lib.showContext("sell_menu")
end

function chosseTheCar(playerId, firstName, lastName, seller)
	HT.TriggerServerCallback("th-bilforhandler:fetchCars", function(data)
		carsStock = {}

		if next(data) == nil then
			notifyIngenBilerLager()
		else
			for _, v in pairs(data) do
				local bilModel = v.model
				local nummerPlade = v.nummerplade
				local price = v.pris
				local veh_type = v.type
				table.insert(carsStock, {
					title = "MODEL: " .. v.model,
					description = "PRIS: " .. v.pris .. "\n NUMMERPLADE: " .. v.nummerplade,
					icon = "car-side",
					onSelect = function()
						sellVehicleToPlayer(
							bilModel,
							nummerPlade,
							firstName,
							lastName,
							playerId,
							price,
							seller,
							veh_type
						)
					end,
				})
			end
			lib.registerContext({
				id = "biler5",
				title = "Biler",
				menu = "main_menu",
				onBack = function() end,
				options = carsStock,
			})

			lib.showContext("biler5")
		end
	end)
end

function sellVehicleToPlayer(model, plate, firstName, lastName, playerId, price, seller, veh_type)
	local input = lib.inputDialog("Sælg køretøjet " .. plate, {
		{
			type = "number",
			label = "Indsæt salgspris",
			description = "For meget skal personen betale for sin " .. model,
			icon = "user",
			min = Config.Job.MinSell,
			max = Config.Job.MaxSell,
		},
	})

	local vehiclePrice = input[1]

	local alert = lib.alertDialog({
		header = "Person: " .. firstName .. " " .. lastName,
		content = "MODEL: " .. model .. "\n\n NUMMERPLADE: " .. plate .. "\n\nSALGSPRIS: " .. vehiclePrice,
		centered = true,
		cancel = true,
		labels = {
			confirm = "Sælg køretøjet til " .. firstName,
			cancel = "Fortryd",
		},
	})

	if alert == "confirm" then
		HT.TriggerServerCallback("th-bilforhandler:sellVeh", function(hasMoney)
			if hasMoney then
				--                TriggerServerEvent('th-bilforhandler:removePlayerMoney', playerId, price)
				TriggerServerEvent(
					"th-bilforhandler:targetId",
					model,
					plate,
					firstName,
					lastName,
					playerId,
					vehiclePrice,
					seller,
					veh_type
				)
			else
				notifyPlayerHasNoMoney(firstName, lastName)
			end
		end, vehiclePrice, playerId, plate, model)
	else
		notifyCanceled()
	end
end

function spawnVehicle(veh, plate, playerId, vehiclePrice, veh_type, model)
	print(model)
	HT.Game.SpawnVehicle(veh, Config.SpawnPoint.coords, Config.SpawnPoint.heading, function(veh)
		SetVehicleNumberPlateText(veh, plate)
        local props = lib.getVehicleProperties(veh)
		TriggerServerEvent("th-bilforhandler:giveVehToPlayer", plate, playerId, props, model)
	end)
end

RegisterNetEvent(
	"th-bilforhandler:targetIdClient",
	function(model, plate, firstName, lastName, playerId, vehiclePrice, seller, veh_type)
		local alert = lib.alertDialog({
			header = "Bekræft købet " .. firstName .. " " .. lastName,
			content = "Bekræft købet af "
				.. model
				.. " med nummerpladen "
				.. plate
				.. ". \n\n Prisen er "
				.. vehiclePrice
				.. " DKK \n\n Ønsker du at købe køretøjet?",
			centered = true,
			cancel = true,
			labels = {
				confirm = "Bekræft køb",
				cancel = "Afbryd køb",
			},
		})

		if alert == "confirm" then
			spawnVehicle(model, plate, playerId, vehiclePrice, veh_type, model)
			notifyPlayerBoughtVehicle(model, plate)
			TriggerServerEvent("th-bilforhandler:addDataToDatabase", playerId, model, vehiclePrice, seller)
			TriggerServerEvent(
				"th-bilforhandler:removePlayerMoney",
				playerId,
				vehiclePrice,
				firstName,
				lastName,
				model,
				seller
			)
		else
			notifyCanceled()
		end
	end
)

RegisterNetEvent("th-bilforhandler:sellerCommission", function(model, firstName, lastName, moneyToSeller)
	notifyPlayerHasMoney(model, firstName, lastName, moneyToSeller)
end)

RegisterNetEvent("th-bilforhandler:soldVehicle", function(firstName, lastName, model)
	notifyPlayerHasMoney(firstName, lastName, model)
end)
