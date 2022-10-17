local serialize = minetest.serialize

local api = mob_composer.api

function api.add_mob(pos, name, properties)
    minetest.add_entity(pos, name, serialize({api.generate_next_id(), properties}))
end

function api.get_mob(id)
    local entity = api.entity_by_mob_id[id]
    if entity then
        local object = entity.object
        if object and object:get_pos() then
            return entity
        end
    end
end

function api.summon_mob(pos, id, resurrect)
    local mob = api.get_mob(id)

    if not mob then
        if resurrect then
            error()

        else
            return
        end
    end
end
