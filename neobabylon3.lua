local neobabylon3 = {
    identifier = "Neo Babylon-3",
    title = "Neo Babylon-3: Bounce House",
    theme = THEME.NEO_BABYLON,
    width = 4,
    height = 4,
    file_name = "Neo Babylon-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		ent.speed = -0.1
		ent.distance = 1.1

	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	toast(neobabylon3.title)
end

neobabylon3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon3