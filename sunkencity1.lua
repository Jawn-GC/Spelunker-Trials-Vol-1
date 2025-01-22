local sunkencity1 = {
    identifier = "Sunken City-1",
    title = "Sunken City-1: Graveyard",
    theme = THEME.SUNKEN_CITY,
    width = 4,
    height = 4,
    file_name = "Sunken City-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	toast(sunkencity1.title)
end

sunkencity1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return sunkencity1