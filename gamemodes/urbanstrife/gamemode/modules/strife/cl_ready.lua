net.Receive("us_strifeready", function()
    GAMEMODE.ReadyPlayers = {}
    GAMEMODE.ReadyPlayersDict = {}
    for i = 1, net.ReadUInt(7) do
        GAMEMODE:AddPlayerToReadyTable(net.ReadEntity())
    end
end)