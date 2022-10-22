function mob_composer.Trait(base)
    local meta = {
        __call = function(mt, defaults)
            return setmetatable(table.copy(defaults), mt)
        end
    }

    if base then
        meta.__index = base
    end

    local trait = {}
    trait.__index = trait

    return setmetatable(trait, meta)
end
