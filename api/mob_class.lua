local f = string.format

local deserialize = minetest.deserialize
local serialize = minetest.serialize

local class = futil.class
local identity = futil.functional.identity

local api = mob_composer.api
local log = mob_composer.log

api.entity_by_mob_id = {}

local Mob = class()

Mob.initial_properties = {
    hp_max = 1,
    physical = false,
    collide_with_objects = false,
    collisionbox = {0, 0, 0, 0, 0, 0},
    selectionbox = {0, 0, 0, 0, 0, 0},
    pointable = false,
    visual = "sprite",
    visual_size = {x = 0, y = 0, z = 0},
    textures = {"blank.png"},
    use_texture_alpha = true,
    is_visible = false,
    makes_footstep_sound = false,
    automatic_face_movement_dir = false,
    static_save = false,
}

function Mob:_init(id)
    if not self.object then
        error("not an entity")
    end

    id = tonumber(id)

    if not id then
        error("no id")
    end

    self._id = id
end

function Mob:get_staticdata()
    local object = self.object
    return serialize({
        self._id,
        object:get_properties(),
        object:get_armor_groups(),
        object:get_nametag_attributes(),
        self:get_attributes(),
    })
end

function Mob:on_activate(staticdata, dtime_s)
    local object = self.object

    if not object then
        log("warning", "attempt to initialize mob of type %q w/out an object", self.name or "nil")
        return
    end

    local id, properties, armor_groups, nametag_attributes, attributes = unpack(deserialize(staticdata))

    if not id then
        log("warning", "attempt to initialize mob of type %q w/out an id", self.name or "nil")
        self.object:remove()
        return

    elseif api.entity_by_mob_id[id] then
        log("error", "mob created w/ already existing ID? will be removed. %i %s", id, dump(self))
        self.is_duplicate = true
        self.object:remove()
        return
    end

    api.entity_by_mob_id[id] = self

    self.attributes = {}

    if not properties then
        self._initializing = true
    end

    if properties then
        object:set_properties(properties)
    end

    if armor_groups then
        object:set_armor_groups(armor_groups)
    end

    if nametag_attributes then
        object:set_nametag_attributes(nametag_attributes)
    end

    self._on_deactivates = {}
    self._on_steps = {}
    self._on_punches = {}
    self._on_deaths = {}
    self._on_rightclicks = {}
    self._on_attach_childs = {}
    self._on_detach_childs = {}
    self._on_detaches = {}

    -- note: traits[1] == Mob
    local traits = getmetatable(self)._parents

    for i = 1, #traits do
        local parent = traits[i]
        if parent._init then
            parent._init(self, attributes, dtime_s)
        end
    end
end

function Mob:on_deactivate(removal)
    local callbacks = self._on_deactivates
    for i = 1, #callbacks do
        callbacks[i](self, removal)
    end

    api.entity_by_mob_id[self._id] = nil
    --if removal and not self.is_duplicate then
    --    -- wipe backed-up properties
    --end
end

function Mob:register_on_deactivate(callback)
    table.insert(self._on_deactivates, callback)
end

function Mob:on_step(dtime, moveresult)
    local callbacks = self._on_steps
    for i = 1, #callbacks do
        callbacks[i](self, dtime, moveresult)
    end
end

function Mob:register_on_step(callback)
    table.insert(self._on_step, callback)
end

function Mob:on_punch(puncher, time_from_last_punch, tool_capabilities, dir, damage)
    local callbacks = self._on_punches
    for i = 1, #callbacks do
        callbacks[i](self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
    end
end

function Mob:register_on_punch(callback)
    table.insert(self._on_punches, callback)
end

function Mob:on_death(killer)
    local callbacks = self._on_deaths
    for i = 1, #callbacks do
        callbacks[i](self, killer)
    end
end

function Mob:register_on_death(callback)
    table.insert(self._on_deaths, callback)
end

function Mob:on_rightclick(clicker)
    local callbacks = self._on_rightclicks
    for i = 1, #callbacks do
        callbacks[i](self, clicker)
    end
end

function Mob:register_on_rightclick(callback)
    table.insert(self._on_rightclicks, callback)
end

function Mob:on_attach_child(child)
    local callbacks = self._on_attach_childs
    for i = 1, #callbacks do
        callbacks[i](self, child)
    end
end

function Mob:register_on_attach_child(callback)
    table.insert(self._on_attach_childs, callback)
end

function Mob:on_detach_child(child)
    local callbacks = self._on_detach_childs
    for i = 1, #callbacks do
        callbacks[i](self, child)
    end
end

function Mob:register_on_detach_child(callback)
    table.insert(self._on_detach_childs, callback)
end

function Mob:on_detach(parent)
    local callbacks = self._on_detaches
    for i = 1, #callbacks do
        callbacks[i](self, parent)
    end
end

function Mob:register_on_detach(callback)
    table.insert(self._on_detaches, callback)
end

--local object_property = {
--    hp_max = true,
--    physical = true,
--    collide_with_objects = true,
--    collisionbox = true,
--    selectionbox = true,
--    pointable = true,
--    visual = true,
--    visual_size = true,
--    mesh = true,
--    textures = true,
--    colors = true,
--    use_texture_alpha = true,
--    spritediv = true,
--    initial_sprite_basepos = true,
--    is_visible = true,
--    makes_footstep_sound = true,
--    automatic_rotate = true,
--    stepheight = true,
--    automatic_face_movement_dir = true,
--    automatic_face_movement_max_rotation_per_sec = true,
--    backface_culling = true,
--    glow = true,
--    nametag = true,
--    nametag_color = true,
--    nametag_bgcolor = true,
--    infotext = true,
--    static_save = true,
--    damage_texture_modifier = true,
--    shaded = true,
--    show_on_minimap = true,
--}

function Mob:register_attribute(key, initializer, serializer)
    local attributes = self.attributes

    if attributes[key] then
        error(f("[properties] attempt to re-register key %q", key))
    end

    attributes[key] = {
        initializer = initializer or identity,
        serializer = serializer or identity,
    }
end

function Mob:get_attribute(key)
    local def = self.attributes[key]
    if not def then
        error(("attempt to get unknown attribute %q of mob %s"):format(key, dump(self)))
    end
    return self[key]
end

function Mob:set_attribute(key, value)
    local def = self.attributes[key]
    if not def then
        error(("attempt to get unknown attribute %q of mob %s"):format(key, dump(self)))
    end
    self[key] = value
end

api.Mob = Mob
