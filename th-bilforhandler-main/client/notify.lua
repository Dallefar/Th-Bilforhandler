function notifyIngenBilerLager()
    lib.notify({
        id = 'biler',
        title = 'Lager tomt',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'list',
        iconColor = '#C53030'
    })
end

function notifyCanceled()
    lib.notify({
        id = 'biler1',
        title = 'Du fortrød',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function notifyCarRemoved()
    lib.notify({
        id = 'biler2',
        title = 'Demo fjernet',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function notifyCarDemo(veh)
    lib.notify({
        id = 'biler3',
        title = 'Fremviste '..veh,
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'car',
        iconColor = '#0afc12'
    })
end

function notifyIngenPlads(veh)
    lib.notify({
        id = 'biler4',
        title = 'Der ikke plads til '..veh,
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'car',
        iconColor = '#C53030'
    })
end

function notifyNoPlayers()
    lib.notify({
        id = 'biler5',
        title = 'Ingen i nærheden',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function notifyVehicleBought(name)
    lib.notify({
        id = 'biler6',
        title = name..' er blevet købt',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'car',
        iconColor = '#0afc12'
    })
end

function notifyNoVehicleBought()
    lib.notify({
        id = 'biler7',
        title = 'Ikke nok penge',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function notifyVehicleSoldToFactory(plate, finalPrice)
    lib.notify({
        id = 'biler8',
        title = plate..' solgt til '..HT.Math.Round(finalPrice)..' DKK',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-check',
        iconColor = '#0afc12'
    })
end

function notifyPlayerHasNoMoney(firstName ,lastName)
    lib.notify({
        id = 'biler9',
        title = firstName.. ' '..lastName..' \n\n har ikke nok penge',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'money-bill',
        iconColor = '#C53030'
    })
end

function notifyPlayerHasMoney(model, firstName, lastName, moneyToSeller)
    lib.notify({
        id = 'biler9',
        title = 'Du har fået '..moneyToSeller..' i provision for salget af '..model.. ' til '..firstName..' '..lastName,
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-check',
        iconColor = '#0afc12'
    })
end

function notifyPlayerBoughtVehicle(model, plate)
    lib.notify({
        id = 'biler9',
        title = 'Du har købt bil modellen: ' ..model.. ' med nummerpladen '..plate,
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-check',
        iconColor = '#0afc12'
    })
end

function notifyNoDatabase()
    lib.notify({
        id = 'biler11',
        title = 'Intet data',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'database',
        iconColor = '#C53030'
    })
end

function notifyRemovedDatabaseId()
    lib.notify({
        id = 'biler10',
        title = 'Fjernet en kolonne',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'database',
        iconColor = '#C53030'
    })
end

function notifynomoney()
    lib.notify({
        id = 'biler12',
        title = 'Handling mislykkedes',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function notifymoney(money)
    lib.notify({
        id = 'biler12',
        title = money .. ' kr. blev sat i bilforhandler kontoen.',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-check',
        iconColor = '#0afc12'
    })
end

function notifyremovemoney(money)
    lib.notify({
        id = 'biler12',
        title = money .. ' kr. blev taget af bilforhandler kontoen.',
        position = 'right-top',
        style = Config.Notify.Style,
        icon = 'circle-check',
        iconColor = '#0afc12'
    })
end