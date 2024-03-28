local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","th-bilforhandler-main")

HT = nil
TriggerEvent('HT_base:getBaseObjects', function(obj)
    HT = obj
end)


HT.RegisterServerCallback('th-bilforhandler:buyCarsToStock', function(source, cb, model, price)
    local randomPlate = GenerateUniquePlate()

    MySQL.query('SELECT balance FROM business_fund WHERE id = @id', {
        ['@id'] = 1
    }, function(result)
        if result[1] then
            local balance = tonumber(result[1].balance)

            price = tonumber(price)

            if balance and price then 
                if balance >= price then
                    MySQL.insert('INSERT INTO th_lager (model, nummerplade, pris) VALUES (?, ?, ?)', {
                        model, randomPlate, price
                    })

                    MySQL.execute('UPDATE business_fund SET balance = balance - ? WHERE id = ?', {
                        price, 1
                    })

                    cb(true) 
                else
                    cb(false) 
                end
            else
                cb(false) 
            end
        else
            cb(false) 
        end
    end)
end)

RegisterNetEvent('th-bilforhandler:sellVehicle', function(plate, price)
    
    MySQL.Async.execute('DELETE FROM th_lager WHERE nummerplade = @nummerplade', {
        ['@nummerplade'] = plate
    })

    local sellPrice = Config.SellVehicleProcent * price
    local finalPrice = price - sellPrice 

    TriggerEvent('dalle_addonaccount:getSharedAccount', 'society_cardealer', function(account)
        account.addMoney(finalPrice)
    end)
end)

HT.RegisterServerCallback('th-bilforhandler:fetchCars', function(source, cb)
    local cars = MySQL.query.await('SELECT model, nummerplade, pris FROM th_lager')
    cb(cars)
end)

HT.RegisterServerCallback('th-bilforhandler:fetchDatabase', function(source, cb)
    local db = MySQL.query.await('SELECT id, bil, medarbejder, buyer, pris FROM th_sold')
    cb(db)
end)

HT.RegisterServerCallback('th-bilforhandler:carsLager', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM th_vehicles WHERE category = ?', {
        category
    }, function(response)
        if response then    
            for k,v in ipairs(response) do
                cb(response)
                break
            end
        end
    end)
end)

HT.RegisterServerCallback('th-bilforhandler:getNearestPlayers', function(source, cb, closePlayer)
    local xPlayer = vRP.getUserId({closePlayer})
    local players = {}
    
    if xPlayer then
        vRP.getUserIdentity({xPlayer, function(identity)
            if identity.firstname and identity.name then
                local name = identity.firstname .. " " .. identity.name
                table.insert(players, {
                    source = closePlayer,
                    identifier = xPlayer,
                    name = name,
                    firstname = identity.firstname,
                    lastname = identity.name,
                })
            else
                print("Identity not found for player: " .. closePlayer)
            end
            cb(players)
        end})
    else
        print("User ID not found for player: " .. closePlayer)
        cb(players)
    end
end)


HT.RegisterServerCallback('dalle:Bilforhandler', function(source, cb)
    local user_id = vRP.getUserId({source})
    
    vRP.teleport({Config.SpawnPoint.coords,Config.SpawnPoint.heading})
    vRPg.spawnBoughtVehicle({veh_type, vehicle})
    cb(true)
end)


HT.RegisterServerCallback('th-bilforhandler:sellVeh', function(source, cb, vehPrice, playerId, plate, model)
    xTarget = vRP.getUserId({playerId})

    playerMoney = vRP.getBankMoney({xTarget})

    if playerMoney >= vehPrice then
        cb(true)
    else
        cb(false)
    end
end)


RegisterNetEvent('th-bilforhandler:removePlayerMoney', function(playerId, vehiclePrice, firstName ,lastName, model, seller)
    local xTarget = vRP.getUserId({source})
    local xPlayer = vRP.getUserId({playerId})
    local sellProcent = Config.Job.SellProcent
    local moneyToSeller = vehiclePrice * sellProcent
    local moneyToCompany = vehiclePrice - moneyToSeller
    moneyToSeller = HT.Math.Round(moneyToSeller)

    vRP.giveBankMoney({xPlayer,moneyToSeller})
    vRP.giveBankMoney({xTarget,vehiclePrice})

    TriggerEvent('dalle_addonaccount:getSharedAccount', Config.Job.Society, function(account)
        account.addMoney(moneyToCompany)
    end)
    TriggerClientEvent('th-bilforhandler:sellerCommission', seller, model, firstName, lastName, moneyToSeller)
end)

HT.RegisterServerCallback('th-bilforhandler:isPlateTaken', function(source, cb, plate)
	MySQL.scalar('SELECT plate FROM vrp_user_vehicles WHERE vehicle_plate = ?', {plate},
	function(result)
		cb(result ~= nil)
	end)
end)

RegisterNetEvent('th-bilforhandler:targetId', function(model, plate, firstName, lastName, playerId, vehiclePrice, seller, veh_type)
    TriggerClientEvent('th-bilforhandler:targetIdClient', playerId, model, plate, firstName, lastName, playerId, vehiclePrice, seller, veh_type)
end)

RegisterNetEvent('th-bilforhandler:giveVehToPlayer', function(plate, playerId, props)
    local xTarget = vRP.getUserId({playerId})

    -- MySQL.insert('INSERT INTO vrp_user_vehicles (user_id, vehicle_plate, vehicle) VALUES (?, ?, ?)', {
    --      xTarget,
    --      plate,
    --      json.encode(props)
    -- })

    MySQL.Async.execute("INSERT INTO vrp_user_vehicles(user_id,vehicle,vehicle_plate,veh_type) VALUES(@user_id,@vehicle,@vehicle_plate,@veh_type)", {
        user_id = user_id, 
        vehicle = vehicle, 
        vehicle_plate = plate, 
        veh_type = "car"
    })

    MySQL.Async.execute('DELETE FROM th_lager WHERE nummerplade = @nummerplade', {
         ['@nummerplade'] = plate
    })

end)

RegisterNetEvent('th-bilforhandler:removeIdFromDatabase', function(id)
    MySQL.Async.execute('DELETE FROM th_sold WHERE id = @id', {
        ['@id'] = id
   })
end)

RegisterNetEvent('th-bilforhandler:addDataToDatabase', function(playerId, model, vehiclePrice, seller)
    local xPlayer = vRP.getUserId({seller})
    local xTarget = vRP.getUserId({playerId})
    local buyerName = getName(xPlayer)
    local sellerName = getName(xTarget)

    MySQL.insert('INSERT INTO th_sold (bil, medarbejder, buyer, pris) VALUES (?, ?, ?, ?)', {
        model,
        sellerName,
        buyerName,
        vehiclePrice
    })
end)

function getName(user_id)
    if user_id then
        vRP.getUserIdentity({user_id, function(identity)
            local name = identity.firstName .. " " .. identity.name
            print("User name: " .. name)
            return name
        end})
    else
        print("User Id is nil.")
        return false
    end
end

HT.RegisterServerCallback('TH:JobCallback', function(source, cb)
    local user_id = vRP.getUserId({source})
    local job = vRP.getUserGroupByType({user_id,"job"})
    cb(job)
end)

HT.RegisterServerCallback('dalle:getmoney', function(source, cb)
    MySQL.Async.fetchAll('SELECT balance FROM business_fund WHERE id = @id', {
        ['@id'] = 1,
    }, function(result)
        if result[1] then
            cb(result[1].balance)
        else
            cb(0)
        end
    end)
end)

HT.RegisterServerCallback('dalle:addmoney', function(source, cb, pengebeleob)
    local user_id = vRP.getUserId({source})
    local playermoney = vRP.getBankMoney({user_id})

    MySQL.Async.fetchAll('SELECT balance FROM business_fund WHERE id = @id', {
        ['@id'] = 1,
    }, function(result)
        local money = result[1].balance
        local finalmoney = money + pengebeleob

        if playermoney >= pengebeleob then
            MySQL.Async.execute('UPDATE business_fund SET balance = @balance WHERE id = @id', {
                ['@id'] = 1,
                ['@balance'] = finalmoney
            }, function(rowsChanged)
                if rowsChanged == 1 then
                    vRP.tryBankPayment({user_id, pengebeleob})
                    cb(true)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)
end)

HT.RegisterServerCallback('dalle:removemoney', function(source, cb, playermoney)
    local user_id = vRP.getUserId({source})

    MySQL.Async.fetchAll('SELECT balance FROM business_fund WHERE id = @id', {
        ['@id'] = 1,
    }, function(result)
        if result and #result > 0 then
            local money = tonumber(result[1].balance) 
            local finalmoney = money - playermoney 

            if money and finalmoney >= 0 then 
                MySQL.Async.execute('UPDATE business_fund SET balance = @balance WHERE id = @id', {
                    ['@id'] = 1,
                    ['@balance'] = finalmoney
                }, function(rowsChanged)
                    if rowsChanged == 1 then
                        vRP.giveBankMoney({user_id, playermoney})
                        cb(true)
                    else
                        cb(false) 
                    end
                end)
            else
                cb(false) 
            end
        else
            cb(false) 
        end
    end)
end)