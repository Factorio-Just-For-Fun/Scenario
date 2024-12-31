--- This contains a list of all files that will be loaded and the order they are loaded in;
-- to stop a file from loading add "--" in front of it, remove the "--" to have the file be loaded;
-- config files should be loaded after all modules are loaded;
-- core files should be required by modules and not be present in this list;
-- @config File-Loader
return {
    --'example.file_not_loaded',
    'modules.factorio-control', -- base factorio free play scenario
    'expcore.player_data', -- must be loaded first to register event handlers

    --- Game Commands
    'modules.commands.debug',
    'modules.commands.me',
    'modules.commands.kill',
    'modules.commands.admin-chat',
    'modules.commands.admin-markers',
    'modules.commands.teleport',
    'modules.commands.interface',
    'modules.commands.roles',
    'modules.commands.rainbow',
    'modules.commands.clear-inventory',
    'modules.commands.jail',
    'modules.commands.repair',
    'modules.commands.reports',
    'modules.commands.find',
    'modules.commands.home',
    'modules.commands.last-location',
    'modules.commands.search',
    'modules.commands.bot-queue',
    'modules.commands.speed',
    'modules.commands.enemy',

    --- Addons
    'modules.addons.chat-popups',
    'modules.addons.damage-popups',
    'modules.addons.afk-kick',
    'modules.addons.report-jail',
    'modules.addons.protection-jail',
    'modules.addons.deconlog',

    --- Data
    'modules.data.statistics',
    'modules.data.player-colours',
    'modules.data.greetings',
    'modules.data.alt-view',
    'modules.data.tag',
    'modules.data.language',

    --- GUI
    'modules.gui.player-list',
    'modules.gui.server-ups',
    'modules.gui.playerdata',
    'modules.gui.toolbar', -- must be loaded last to register toolbar handlers

    --- Config Files
    'config.expcore.command_auth_admin', -- commands tagged with admin_only are blocked for non admins
    'config.expcore.command_auth_roles', -- commands must be allowed via the role config
    'config.expcore.command_runtime_disable', -- allows commands to be enabled and disabled during runtime
    'config.expcore.permission_groups', -- loads some predefined permission groups
    'config.expcore.roles', -- loads some predefined roles
}
