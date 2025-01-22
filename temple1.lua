local temple1 = {
    identifier = "Temple-1",
    title = "Temple-1: Momentum",
    theme = THEME.TEMPLE,
    width = 4,
    height = 4,
    file_name = "Temple-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

temple1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	toast(temple1.title)
end

temple1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return temple1