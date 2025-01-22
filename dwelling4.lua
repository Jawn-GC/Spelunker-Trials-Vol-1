local dwelling4 = {
    identifier = "Dwelling-4",
    title = "Dwelling-4: Quilliam",
    theme = THEME.DWELLING,
    width = 3,
    height = 3,
    file_name = "Dwelling-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	toast(dwelling4.title)
end

dwelling4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling4
