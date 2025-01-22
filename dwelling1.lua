local dwelling1 = {
    identifier = "Dwelling-1",
    title = "Dwelling-1: Skill Check",
    theme = THEME.DWELLING,
    width = 3,
    height = 3,
    file_name = "Dwelling-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	toast(dwelling1.title)
end

dwelling1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling1