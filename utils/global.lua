local Event = require 'utils.event_core' --- @dep utils.event_core
local Token = require 'utils.token' --- @dep utils.token

local Global = {}

function Global.register(tbl, callback)
    if _LIFECYCLE ~= _STAGE.control then
        error('can only be called during the control stage', 2)
    end
    local token = Token.register_global(tbl)

    Event.on_load(
        function()
            callback(Token.get_global(token))
        end
    )
end

function Global.register_init(tbl, init_handler, callback)
    if _LIFECYCLE ~= _STAGE.control then
        error('can only be called during the control stage', 2)
    end
    local token = Token.register_global(tbl)

    Event.on_init(
        function()
            init_handler(tbl)
            callback(tbl)
        end
    )

    Event.on_load(
        function()
            callback(Token.get_global(token))
        end
    )
end

if _DEBUG or true then
    local concat = table.concat

    local names = {}
    Global.names = names
    
    function Global.register(tbl, callback)
        local filepath = debug.getinfo(2, 'S').source:match('^.+__level__/(.+)$'):sub(1, -5)
        local token = Token.register_global(tbl)

        names[token] = concat {token, ' - ', filepath}

        Event.on_load(
            function()
                callback(Token.get_global(token))
            end
        )
    end

    function Global.register_init(tbl, init_handler, callback)
        local filepath = debug.getinfo(2, 'S').source:match('^.+__level__/(.+)$'):sub(1, -5)
        local token = Token.register_global(tbl)

        names[token] = concat {token, ' - ', filepath}

        Event.on_init(
            function()
                init_handler(tbl)
                callback(tbl)
            end
        )

        Event.on_load(
            function()
                callback(Token.get_global(token))
            end
        )
    end
end

return Global
