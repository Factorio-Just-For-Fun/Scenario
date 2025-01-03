--[[-- Gui Module - Player List
    - Adds a player list to show names and play time; also includes action buttons which can preform actions to players
    @gui Player-List
    @alias player_list
]]

-- luacheck:ignore 211/Colors
local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Datastore = require 'expcore.datastore' --- @dep expcore.datastore
local Event = require 'utils.event' --- @dep utils.event
local Colors = require 'utils.color_presets' --- @dep utils.color_presets
local format_time = _C.format_time --- @dep expcore.common

--- Stores all data for the warp gui
local PlayerListData = Datastore.connect('PlayerListData')
PlayerListData:set_serializer(Datastore.name_serializer)

--- Set of elements that are used to make up a row of the player table
-- @element add_player_base
local add_player_base =
Gui.element(function(_, parent, player_data)
    -- Add the player name
    local player_name = parent.add{
        type = 'label',
        name = 'player-name-'..player_data.index,
        caption = player_data.name,
        tooltip = {'player-list.open-map', player_data.name, player_data.tag, player_data.role_name}
    }
    player_name.style.padding = {0, 2,0, 0}
    player_name.style.font_color = player_data.chat_color

    -- Add the time played label
    local alignment = Gui.alignment(parent, 'player-time-'..player_data.index)
    local time_label = alignment.add{
        name = 'label',
        type = 'label',
        caption = player_data.caption,
        tooltip = player_data.tooltip
    }
    time_label.style.padding = 0

    return player_name
end)

-- Removes the three elements that are added as part of the base
local function remove_player_base(parent, player)
    Gui.destroy_if_valid(parent[player.name])
    Gui.destroy_if_valid(parent['player-name-'..player.index])
    Gui.destroy_if_valid(parent['player-time-'..player.index])
end

-- Update the time label for a player using there player time data
local function update_player_base(parent, player_time)
    local time_element = parent[player_time.element_name]
    if time_element and time_element.valid then
        time_element.label.caption = player_time.caption
        time_element.label.tooltip = player_time.tooltip
    end
end

--- Main player list container for the left flow
-- @element player_list_container
local player_list_container =
Gui.element(function(definition, parent)
    -- Draw the internal container
    local container = Gui.container(parent, definition.name, 200)

    -- Draw the scroll table for the players
    local scroll_table = Gui.scroll_table(container, 184, 2)

    -- Change the style of the scroll table
    local scroll_table_style = scroll_table.style
    scroll_table_style.padding = {1, 0,1, 2}

    -- Return the exteral container
    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow(true)

--- Button on the top flow used to toggle the player list container
-- @element toggle_player_list
Gui.left_toolbar_button('entity/character', {'player-list.main-tooltip'}, player_list_container, function(player)
    return Roles.player_allowed(player, 'gui/player-list')
end)

-- Get caption and tooltip format for a player
local function get_time_formats(online_time, afk_time)
    local tick = game.tick > 0 and game.tick or 1
    local percent = math.round(online_time/tick, 3)*100
    local caption = format_time(online_time)
    local tooltip = {'player-list.afk-time', percent, format_time(afk_time, {minutes=true, long=true})}
    return caption, tooltip
end

-- Get the player time to be used to update time label
local function get_player_times()
    local ctn = 0
    local player_times = {}
    for _, player in pairs(game.connected_players) do
        ctn = ctn + 1
        -- Add the player time details to the array
        local caption, tooltip = get_time_formats(player.online_time, player.afk_time)
        player_times[ctn] = {
            element_name = 'player-time-'..player.index,
            caption = caption,
            tooltip = tooltip
        }
    end

    return player_times
end

-- Get a sorted list of all online players
local function get_player_list_order()
    -- Sort all the online players into roles
    local players = {}
    for _, player in pairs(game.connected_players) do
        local highest_role = Roles.get_player_highest_role(player)
        if not players[highest_role.name] then
            players[highest_role.name] = {}
        end
        table.insert(players[highest_role.name], player)
    end

    -- Sort the players from roles into a set order
    local ctn = 0
    local player_list_order = {}
    for _, role_name in pairs(Roles.config.order) do
        if players[role_name] then
            for _, player in pairs(players[role_name]) do
                ctn = ctn + 1
                -- Add the player data to the array
                local caption, tooltip = get_time_formats(player.online_time, player.afk_time)
                player_list_order[ctn] = {
                    name = player.name,
                    index = player.index,
                    tag = player.tag,
                    role_name = role_name,
                    chat_color = player.chat_color,
                    caption = caption,
                    tooltip = tooltip
                }
            end
        end
    end

    --[[Adds fake players to the player list
    local tick = game.tick+1
    for i = 1, 10 do
        local online_time = math.random(1, tick)
        local afk_time = math.random(online_time-(tick/10), tick)
        local caption, tooltip = get_time_formats(online_time, afk_time)
        player_list_order[ctn+i] = {
            name='Player '..i,
            index=0-i,
            tag='',
            role_name = 'Fake Player',
            chat_color = table.get_random_dictionary_entry(Colors),
            caption = caption,
            tooltip = tooltip
        }
    end--]]

    return player_list_order
end

--- Update the play times every 30 sections
Event.on_nth_tick(1800, function()
    local player_times = get_player_times()
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, player_list_container)
        local scroll_table = frame.container.scroll.table
        for _, player_time in pairs(player_times) do
            update_player_base(scroll_table, player_time)
        end
    end
end)

--- When a player leaves only remove they entry
Event.add(defines.events.on_player_left_game, function(event)
    local remove_player = game.players[event.player_index]
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, player_list_container)
        local scroll_table = frame.container.scroll.table
        remove_player_base(scroll_table, remove_player)
    end
end)

--- All other events require a full redraw of the table
local function redraw_player_list()
    local player_list_order = get_player_list_order()
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, player_list_container)
        local scroll_table = frame.container.scroll.table
        scroll_table.clear()
        for _, next_player_data in ipairs(player_list_order) do
            add_player_base(scroll_table, next_player_data)
        end
    end
end

Event.add(defines.events.on_player_joined_game, redraw_player_list)
Event.add(Roles.events.on_role_assigned, redraw_player_list)
Event.add(Roles.events.on_role_unassigned, redraw_player_list)