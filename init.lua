futil.check_version({ year = 2022, month = 10, day = 24 })

mob_composer = fmod.create()

mob_composer.dofile("settings")
mob_composer.dofile("api", "init")
mob_composer.dofile("trait", "init")
