local neobabylon2 = {
    identifier = "Neo Babylon-2",
    title = "Neo Babylon-2: Power Core",
    theme = THEME.NEO_BABYLON,
    width = 6,
    height = 3,
    file_name = "Neo Babylon-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		ent.speed = 0.1
		ent.distance = 1.1

	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	toast(neobabylon2.title)
end

neobabylon2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon2