local tidepool2 = {
    identifier = "Tidepool-2",
    title = "Tidepool-2: Escape Artist",
    theme = THEME.TIDE_POOL,
    width = 6,
    height = 6,
    file_name = "Tidepool-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Tame Axolotl
		--Reduce stun time (?)
		--Set its health to one
        entity:tame(true)
		entity.stun_timer = 0
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_AXOLOTL)
	
	toast(tidepool2.title)
end

tidepool2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool2