local neobabylon4 = {
    identifier = "Neo Babylon-4",
    title = "Neo Babylon-4: Ascension",
    theme = THEME.NEO_BABYLON,
    width = 3,
    height = 10,
    file_name = "Neo Babylon-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	rotation = math.random(2)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Tame Qilin
		--Set its health to one
        entity:tame(true)
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_QILIN)
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		if rotation == 1 then
			ent.speed = -0.1
			ent.distance = 2.0
		elseif rotation == 2 then
			ent.speed = 0.1
			ent.distance = 2.0
		end

	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	toast(neobabylon4.title)
end

neobabylon4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon4