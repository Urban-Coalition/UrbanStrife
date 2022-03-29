include( "shared.lua" )
include( "player_class/player_us.lua" )

hook.Add("InitPostEntity", "PlayerRequestData", function()
    net.Start("us_playerrequestdata")
    net.SendToServer()
end)