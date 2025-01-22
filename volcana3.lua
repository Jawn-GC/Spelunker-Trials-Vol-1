local volcana3 = {
    identifier = "Volcana-3",
    title = "Volcana-3: Companion",
    theme = THEME.VOLCANA,
    width = 6,
    height = 3,
    file_name = "Volcana-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Magmamen.
        local x, y, layer = get_position(entity.uid)
        local lavas = get_entities_at(0, MASK.LAVA, x, y, layer, 1)
        if #lavas > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MAGMAMAN)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Firebugs.
        local x, y, layer = get_position(entity.uid)
        local chains = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #chains > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FIREBUG)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Tame Rockdog
		--Reduce stun time (?)
		--Set its health to one
        entity:tame(true)
		entity.stun_timer = 0
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_ROCKDOG)
	
	toast(volcana3.title)
end

volcana3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return volcana3