meta = {
    name = 'Spelunker Trials',
    version = '1.3.5',
    description = 'Test your Spelunky skills with these platforming challenges.',
    author = 'JawnGC',
}

register_option_int("level_selected", "Level number for shortcut door (1 to 28)", 1, 1, 28)
register_option_bool("speedrun_mode", "Speedrun Mode (Instant Restart on death)", false)

local level_sequence = require("LevelSequence/level_sequence")
local DIFFICULTY = require('difficulty')
local SIGN_TYPE = level_sequence.SIGN_TYPE
local save_state = require('save_state')

local update_continue_door_enabledness
local force_save
local save_data
local save_context

--Dwelling Levels
local dwelling1 = require("dwelling1")
local dwelling2 = require("dwelling2")
local dwelling3 = require("dwelling3")
local dwelling4 = require("dwelling4")

--Volcana Levels
local volcana1 = require("volcana1")
local volcana2 = require("volcana2")
local volcana3 = require("volcana3")
local volcana4 = require("volcana4")

--Jungle Levels
local jungle1 = require("jungle1")
local jungle2 = require("jungle2")
local jungle3 = require("jungle3")
local jungle4 = require("jungle4")

--Tidepool Levels
local tidepool1 = require("tidepool1")
local tidepool2 = require("tidepool2")
local tidepool3 = require("tidepool3")
local tidepool4 = require("tidepool4")

--Temple Levels
local temple1 = require("temple1")
local temple2 = require("temple2")
local temple3 = require("temple3")
local temple4 = require("temple4")

--Neo Babylon Levels
local neobabylon1 = require("neobabylon1")
local neobabylon2 = require("neobabylon2")
local neobabylon3 = require("neobabylon3")
local neobabylon4 = require("neobabylon4")

--Sunken City Level
local sunkencity1 = require("sunkencity1")
local sunkencity2 = require("sunkencity2")
local sunkencity3 = require("sunkencity3")
local sunkencity4 = require("sunkencity4")

--Set level order
levels = {dwelling1, dwelling2, dwelling3, dwelling4, volcana1, volcana2, volcana3, volcana4, jungle1, jungle2, jungle3, jungle4, tidepool1, tidepool2, tidepool3, tidepool4, temple1, temple2, temple3, temple4, neobabylon1, neobabylon2, neobabylon3, neobabylon4, sunkencity1, sunkencity2, sunkencity3, sunkencity4}
level_sequence.set_levels(levels)


--Do not spawn Ghost
set_ghost_spawn_times(-1, -1)

local create_stats = require('stats')
local function create_saved_run()
	return {
		has_saved_run = false,
		saved_run_attempts = nil,
		saved_run_time = nil,
		saved_run_level = nil,
	}
end

local game_state = {
	difficulty = DIFFICULTY.NORMAL,
	stats = create_stats(),
	normal_saved_run = create_saved_run(),
}

local continue_door

function update_continue_door_enabledness()
	if not continue_door then return end
	local current_saved_run = game_state.normal_saved_run
	continue_door.update_door(current_saved_run.saved_run_level, current_saved_run.saved_run_attempts, current_saved_run.saved_run_time)
end

-- "Continue Run" Door
define_tile_code("continue_run")
local function continue_run_callback()
	return set_pre_tile_code_callback(function(x, y, layer)
		continue_door = level_sequence.spawn_continue_door(
			x,
			y,
			layer,
			game_state.normal_saved_run.saved_run_level,
			game_state.normal_saved_run.saved_run_attempts,
			game_state.normal_saved_run.saved_run_time,
			SIGN_TYPE.RIGHT)
		return true
	end, "continue_run")
end

-- Creates a door for the shortcut, uses "volcana_shortcut" tile code
define_tile_code("volcana_shortcut")
local function shortcut_callback()
	return set_pre_tile_code_callback(function(x, y, layer)
	
		if options.level_selected < 1 then
			options.level_selected = 1
		elseif options.level_selected > 28 then
			options.level_selected = 28
		end
		
		level_sequence.spawn_shortcut(x, y, layer, levels[options.level_selected], SIGN_TYPE.RIGHT)
		return true
	end, "volcana_shortcut")
end

level_sequence.set_on_win(function(attempts, total_time)
	local frames = total_time
	local hours = 0
	local minutes = 0
	local seconds = 0
	local milliseconds = 0

	local minutes_sc4 = 0
	local seconds_sc4 = 0
	local milliseconds_sc4 = 0

	hours = frames // 216000
	frames = frames - (hours * 216000)
	
	minutes = frames // 3600
	frames = frames - (minutes * 3600)
	
	seconds = frames // 60
	frames = frames - (seconds * 60)
	
	milliseconds = math.floor(frames * 16.667)

	minutes_sc4 = frames_sc4 // 3600
	frames_sc4 = frames_sc4 - (minutes_sc4 * 3600)
	
	seconds_sc4 = frames_sc4 // 60
	frames_sc4 = frames_sc4 - (seconds_sc4 * 60)
	
	milliseconds_sc4 = math.floor(frames_sc4 * 16.667)

    print("Wow, you did it. :)")
	print("Total Deaths: " .. tostring(attempts - 1))
	print("Total Time: " .. hours .. "h " .. minutes .. "m " .. seconds .. "s " .. milliseconds .. "ms")
	print("SC-4 Clear Time: " .. minutes_sc4 .. "m " .. seconds_sc4 .. "s " .. milliseconds_sc4 .. "ms")
	
	warp(1, 1, THEME.BASE_CAMP)
end)

--Remove resources from the player and set health to 1
--Remove held item from the player
level_sequence.set_on_post_level_generation(function(level)
	if #players == 0 then return end
	
	players[1].inventory.bombs = 0
	players[1].inventory.ropes = 0
	players[1].health = 1
	
	if players[1].holding_uid ~= -1 then
		players[1]:get_held_entity():destroy()
	end
end)

--Prevent Dark Levels
set_callback(function() 
	state.level_flags = clr_flag(state.level_flags, 18) 
end, ON.POST_ROOM_GENERATION)

level_sequence.set_on_completed_level(function(completed_level, next_level)
	if not next_level then return end

	local current_stats = game_state.stats
	local best_level_index = level_sequence.index_of_level(current_stats.best_level)
	local current_level_index = level_sequence.index_of_level(next_level)

	if (not best_level_index or current_level_index > best_level_index) and
			not level_sequence.took_shortcut() then
				current_stats.best_level = next_level
	end
end)

-- Manage saving data and keeping the time in sync during level transitions and resets.
function save_data()
	if save_context then
		force_save(save_context)
	end
end

function save_current_run_stats()
	local run_state = level_sequence.get_run_state()
	-- Save the current run
	if state.theme ~= THEME.BASE_CAMP and
		level_sequence.run_in_progress() then
		local saved_run = game_state.normal_saved_run
		saved_run.saved_run_attempts = run_state.attempts
		saved_run.saved_run_level = run_state.current_level
		saved_run.saved_run_time = run_state.total_time
		saved_run.has_saved_run = true
	end
end

-- Saves the current state of the run so that it can be continued later if exited.
local function save_current_run_stats_callback()
	return set_callback(function()
		save_current_run_stats()
	end, ON.FRAME)
end

local function clear_variables_callback()
	return set_callback(function()
		continue_door = nil
	end, ON.PRE_LOAD_LEVEL_FILES)
end

set_callback(function(ctx)
	game_state = save_state.load(game_state, level_sequence, ctx)
end, ON.LOAD)

function force_save(ctx)
	save_state.save(game_state, level_sequence, ctx)
end

local function on_save_callback()
	return set_callback(function(ctx)
		save_context = ctx
		force_save(ctx)
	end, ON.SAVE)
end

local active = false
local callbacks = {}

local function activate()
	if active then return end
	active = true
	level_sequence.activate()

	local function add_callback(callback_id)
		callbacks[#callbacks+1] = callback_id
	end

	add_callback(continue_run_callback())
	add_callback(shortcut_callback())
	add_callback(clear_variables_callback())
	add_callback(on_save_callback())
	add_callback(save_current_run_stats_callback())
end

set_callback(function()
    activate()
end, ON.LOAD)

set_callback(function()
    activate()
end, ON.SCRIPT_ENABLE)

set_callback(function()
    if not active then return end
	active = false
	level_sequence.deactivate()

	for _, callback in pairs(callbacks) do
		clear_callback(callback)
	end

	callbacks = {}

end, ON.SCRIPT_DISABLE)

--Instant Restart on death
set_callback(function()
	if options.speedrun_mode then
		if state.screen ~= 12 then
			return
		end

		local health = 0
		for i = 1,#players do
			health = health + players[i].health
		end

		if health == 0 then
			state.quest_flags = set_flag(state.quest_flags, 1)
			warp(state.world_start, state.level_start, state.theme_start)
		end
	end
end, ON.FRAME)

