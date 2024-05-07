HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

function mainMenu(isBoss)
    lib.registerContext({
        id = 'main_menu',
        title = 'Bilforhandler menu',
        options = {
        {
            title = Config.Title
        },
        {
            title = 'Sælg et køretøj',
            description = 'Vælg den nærmeste spiller',
            icon = 'user',
            onSelect = function()
                local closestPlayer, closestPlayerDistance = HT.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestPlayerDistance > 3.0 then
                    notifyNoPlayers()
                else
                    getPlayers()
                end
            end
        },
        {
            title = 'Lager',
            description = 'Lageret af nuværende biler',
            icon = 'list',
            onSelect = function()
                getCars()
            end
        },
        {
            title = 'Bossmenu',
            description = 'Åben bossmenuen',
            icon = 'star',
            disabled = isBoss,
            onSelect = function()
                bossMenu()
            end
        },
        }
    })
    lib.showContext('main_menu')
end

function bossMenu()
    lib.registerContext({
        id = 'boss_menu',
        title = 'Boss menu',
        menu = 'main_menu',
        onBack = function()
        end,
        options = {
        {
            title = 'Køb biler',
            description = 'Køb en bil fra lageret',
            icon = 'clipboard',
            disabled = isBoss,
            onSelect = function()
                lagerMenu()
            end
        },
        {
            title = 'Database',
            description = 'Liste over solgte køretøjer',
            icon = 'database',
            disabled = isBoss,
            onSelect = function()
                dataBase()
            end
        },
        {
            title = 'Bossmenu',
            description = 'Åben bossmenuen',
            icon = 'star',
            disabled = isBoss,
            onSelect = function()
                bossMenu1()
            end
        },
        }
    })
    lib.showContext('boss_menu')
end 

function bossMenu1()
    lib.registerContext({
        id = 'boss_menu1',
        title = 'Boss menu',
        menu = 'boss_menu',
        onBack = function()
        end,
        options = {
            -- Ikke lavet endnu kommer måske
--[[         {
            title = 'Ansæt/fyr',
            description = 'Hyre eller fyr en person.',
            icon = 'address-book',
            onSelect = function()
                lagerMenu()
            end
        }, ]]
        {
            title = 'Bilforhandler finansieret',
            description = 'Bilforhandler bank konto.',
            icon = 'handshake',
            onSelect = function()
                finansieret()
            end
        },
        }
    })
    lib.showContext('boss_menu1')
end 

function finansieret()
    HT.TriggerServerCallback('dalle:getmoney', function(penge)
        lib.registerContext({
            id = 'boss_menu1',
            title = 'Boss Menu',
            menu = 'boss_menu',
            onBack = function()
            end,
            options = {
                {
                    title = 'Bilforhandler Konto: ' .. penge .. ' kr.',
                },
                {
                    title = 'Indsæt Penge',
                    description = 'Tilføj penge til bilforhandlerens bankkonto.',
                    icon = 'database',
                    disabled = isBoss,
                    onSelect = function()
                        local input = lib.inputDialog('Bilforhandler', {
                            {type = 'number', label = 'Beløb', description = 'Indtast det beløb, du vil indsætte på kontoen.', required = true, min = 1, icon = 'credit-card'}
                        })

                        if input then
                            local pengebeleob = input[1]
                            HT.TriggerServerCallback('dalle:addmoney', function(success)
                                if success then
                                    notifymoney(pengebeleob)
                                else
                                    notifynomoney()
                                end
                            end, pengebeleob)
                        end
                    end
                },
                {
                    title = 'Tag Penge',
                    description = 'Hæv penge fra bilforhandlerens konto.',
                    icon = 'star',
                    disabled = isBoss,
                    onSelect = function()
                        local input = lib.inputDialog('Bilforhandler', {
                            {type = 'number', label = 'Beløb', description = 'Indtast det beløb, du vil hæve fra kontoen.', required = true, min = 1, icon = 'credit-card'}
                        })

                        if input then
                            local pengebeleob = input[1]
                            HT.TriggerServerCallback('dalle:removemoney', function(success)
                                if success then
                                    notifyremovemoney(pengebeleob)
                                else
                                    notifynomoney()
                                end
                            end, pengebeleob)
                        end
                    end
                },
            }
        })
        lib.showContext('boss_menu1')
    end)
end
