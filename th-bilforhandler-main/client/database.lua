HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

function dataBase()
    HT.TriggerServerCallback('th-bilforhandler:fetchDatabase', function(data)
        database = {}

        if next(data) == nil then
            notifyNoDatabase()
        else
            for _, v in pairs(data) do 
                table.insert(database, {
                    title = 'BIL: '..v.bil,
                    description = 'SÆLGER: '..v.medarbejder.. ' \nKØBER: '..v.buyer..'\nPRIS: '..v.pris..'\n\nTryk for at fjerne dette data',
                    icon = 'car',
                    onSelect = function()
                        removeDatabaseId(v.id)
                    end
                })
            end

            lib.registerContext({
                id = 'database',
                title = 'Database over solgte biler',
                options = database,
            })

            lib.showContext('database')

        end
    end)
end

function removeDatabaseId(id)
    notifyRemovedDatabaseId()
    TriggerServerEvent('th-bilforhandler:removeIdFromDatabase', id)
end