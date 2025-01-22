local jungle1 = {
    identifier = "Jungle-1",
    title = "Jungle-1: Welcome to the Jungle",
    theme = THEME.JUNGLE,
    width = 3,
    height = 3,
    file_name = "Jungle-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

jungle1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Monkeys.
        local x, y, layer = get_position(entity.uid)
        local vines = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #vines > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MONKEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Set Mantrap health to 1
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MANTRAP)
	
	toast(jungle1.title)
end

jungle1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return jungle1