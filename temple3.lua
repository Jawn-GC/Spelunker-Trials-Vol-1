local temple3 = {
    identifier = "Temple-3",
    title = "Temple-3: Fool's Gold",
    theme = THEME.CITY_OF_GOLD,
    width = 4,
    height = 4,
    file_name = "Temple-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

temple3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	toast(temple3.title)
end

temple3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return temple3