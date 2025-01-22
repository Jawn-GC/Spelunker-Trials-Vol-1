local temple4 = {
    identifier = "Temple-4",
    title = "Temple-4: Oasis",
    theme = THEME.TEMPLE,
    width = 4,
    height = 4,
    file_name = "Temple-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

temple4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snake to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	toast(temple4.title)
end

temple4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return temple4