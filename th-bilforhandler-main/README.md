###
SQL:
    Hvis du i forvejen har sqlerne "vehicles" & "vehiclescategories" så fjern de to, og sæt vores ind.
    Husk at indsætte th_lager og th_sold i din SQL

####
Arbejde:
    Du kan selv vælge hvilket arbejde du ønsker at bilforhandleren skal være under config.lua.
    Den er standard sat til "cardealer"

Køb af lager:
    Hvis du ønsker at gøre, så alle medarbejdere kan indkøbe biler, så fjern disabled = isBoss, under "Køb biler".
    /client/job:36

Provision & Society
    Hvis man ønsker at ændre ens bilforhandlers provision & society, gøres dette i vores config under Config.Job
    Provision og salget tilbage til fabrikken er sat i procent, hvilket vil sige at 0,20 er 20%

Demo / Spawn
    Alle demo og spawn pladser ændres også i vores config under Config.demoSpawnPoints & Config.SpawnPoint

Oprettelse af bil kategorier
    Når du skal oprette en ny bil kategori, skal du først sikre dig at kategorien findes i din th_vehiclescategories.
    Såfremt den findes, skal du tilføje det under Config.bilKategorier.

Locales:
    Vi har valgt ikke at lave nogle locales til scriptet.
    Så ønsker man at ændre noget tekst, findes det meste i job, sell, notify & demo.lua