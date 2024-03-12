HT = nil
TriggerEvent('HT_base:getBaseObjects', function(obj)
    HT = obj
end)

function DoesPlateExist(plate)
    local result = false
    MySQL.Async.fetchAll("SELECT * FROM vrp_user_vehicles WHERE vehicle_plate = @plate", {["@plate"] = plate}, function(data)
        result = #data > 0
    end)
    return result
end

function GenerateUniquePlate()
    local plate = ""
    repeat
        plate = GenerateRandomPlate()
    until not DoesPlateExist(plate)
    return plate
end

function GenerateRandomPlate()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local numbers = "0123456789"

    local plate = ""
    if Config.DanskeNummerplader then
        for i = 1, 2 do
            local randomIndex = math.random(1, #letters)
            plate = plate .. string.sub(letters, randomIndex, randomIndex)
        end

        for i = 1, 5 do
            local randomIndex = math.random(1, #numbers)
            plate = plate .. string.sub(numbers, randomIndex, randomIndex)
        end
    end

    return plate
end

