local sunkencity2 = {
    identifier = "Sunken City-2",
    title = "Sunken City-2: Aubergine",
    theme = THEME.EGGPLANT_WORLD,
    width = 4,
    height = 4,
    file_name = "Sunken City-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Jumpdog to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_JUMPDOG)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Minister to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_EGGPLANT_MINISTER)
	
	toast(sunkencity2.title)
end

sunkencity2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return sunkencity2