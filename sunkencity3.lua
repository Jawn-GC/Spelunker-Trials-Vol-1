local sunkencity3 = {
    identifier = "Sunken City-3",
    title = "Sunken City-3: Choking Hazard",
    theme = THEME.SUNKEN_CITY,
    width = 4,
    height = 4,
    file_name = "Sunken City-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snakes to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	toast(sunkencity3.title)
end

sunkencity3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return sunkencity3