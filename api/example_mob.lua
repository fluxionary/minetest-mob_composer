-- luacheck: ignore

-- TODO: this is mostly so i can work out now i want things to work

local api = mob_composer.api

local trait = mob_composer.trait

local Lizard = api.register_mob("composed_mob:lizard",
    trait.appears({
        drawtype = "mesh",
        model = "composed_mob_lizard.b3d",
        textures = {"composed_mob_lizard.png"},
    }),
    trait.spawns({
        strategy = "ABM",
        nodenames = {"group:soil"},
        interval = 61.3,
        chance = 1000,
    }),
    trait.sees({
        range = 3,
        min_light = 5,
    }),
    trait.fears_objects({
        what = {
            player = 10,
        },
    }),
    trait.flees({
        when = {"afraid"},
        speed = 5,
    })
)

local lizard = Lizard(pos) -- create a new lizard?


local Balrog = api.register_mob("composed_mob:balrog",
    trait.appears({
        drawtype = "mesh",
        model = "composed_mob_balrog.b3d",
        textures = {"composed_mob_balrog.png"},
    }),
    trait.spawns({
        strategy = "ABM",
        nodenames = {"group:stone"},
        interval = 61.3,
        chance = 1000,
    }),
    trait.sees({
        range = 40,
        min_light = 1,
    }),
    trait.hears({
        range = 40,
    }),
    trait.extrasenses({
        range = 10,
    })
)
