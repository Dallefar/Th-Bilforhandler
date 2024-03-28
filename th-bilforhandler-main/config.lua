Config = {}

Config.Title = 'Vagk x Dalle - Development'

Config.Job = {
    Profession = 'Bilforhandler', -- Normal dette er bare det normale.
    Bossgroup = 'Mekaniker', -- Chef -- Dette er chef rank 
    MinSell = 2000, -- det minimale du kan sælge et køretøj for
    MaxSell = 50000000, -- det maksimale du kan sælge et køretøj for
    SellProcent = 0.20,

    Menu = {
        targetCoords = vec3(-56.2302, -1096.7307, 26.4223) -- { -56.2302, -1096.7307, 26.4223, 185.7584 }
    }

}

Config.SellVehicleProcent = 0.25

-- danske nummerplader
Config.DanskeNummerplader = true

-- Notify styles
Config.Notify = {
    Style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
        color = '#909296'
        }
    },
}

Config.bilKategorier = {
    ['sedans'] = {
        title = 'Sedans',
        description = 'Kategori for sedan biler',
        icon = 'car' -- billederne findes på hjemmesiden "fontawesome.com"
    },
    ['super'] = {
        title = 'Super',
        description = 'Kategori for super biler',
        icon = 'gauge-high'
    },
    ['compacts'] = {
        title = 'Kompakte',
        description = 'Kategori for kompakte biler',
        icon = 'magnifying-glass'
    },
    ['offroad'] = {
        title = 'Off Road',
        description = 'Kategori for Off Road biler',
        icon = 'truck-monster'
    },
    -- ['custom'] = {
    --     title = 'Custom',
    --     description = 'Kategori for custom biler',
    --     icon = 'diamond' 
    -- },
}

Config.Blip = {
    coords = vec3(-1251.2906, -361.2316, 36.9076),
    sprite = 225,
    color = 0,
    scale = 1.0,
    display = 4,
    shortrange = true,
    bliptext = 'Bilforhandler'
}

-- demo bilers spawn plads, tilpas radiusen 
Config.demoSpawnPoints = {
    {coords = vector3(-56.293, -1116.6835, 25.8617), heading = 182.833}, -- { -56.293, -1116.6835, 25.8617, 182.8416 }
    {coords = vector3(-53.5151, -1116.5491, 25.8619), heading = 181.9854} -- { -53.5151, -1116.5491, 25.8619, 181.9854 }
}


-- hvor bilen spawner efter man har købt den
Config.SpawnPoint = {
    coords = vec3(-1234.9867, -344.0579, 37.3329),
    heading = 25.0684
} 