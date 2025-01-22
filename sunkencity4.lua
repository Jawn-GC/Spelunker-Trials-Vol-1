local sunkencity4 = {
    identifier = "Sunken City-4",
    title = "Sunken City-4: Zenith",
    theme = THEME.SUNKEN_CITY,
    width = 3,
    height = 7,
    file_name = "Sunken City-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snakes to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	frames_sc4 = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		frames_sc4 = frames_sc4 + 1
    end, ON.FRAME)
	
	toast(sunkencity4.title)
end

sunkencity4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return sunkencity4