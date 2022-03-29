GM.ReadyPlayers = {}
GM.ReadyPlayersDict = {}

function GM:IsEnoughPlayersReady()
    return #GAMEMODE.ReadyPlayers > math.ceil(player.GetCount() * GAMEMODE.OptionConvars.round_ready_fraction:GetFloat())
end

function GM:IsPlayerReady(ply)
    return GAMEMODE.ReadyPlayersDict[ply] ~= nil
end

function GM:AddPlayerToReadyTable(ply)
    local i = GAMEMODE.ReadyPlayersDict[ply]
    if not i then
        i = table.insert(GAMEMODE.ReadyPlayers, ply)
        GAMEMODE.ReadyPlayersDict[ply] = i
    end
end

function GM:RemovePlayerFromReadyTable(ply)
    local i = GAMEMODE.ReadyPlayersDict[ply]
    if i then
        table.remove(GAMEMODE.ReadyPlayers, i)
        GAMEMODE.ReadyPlayersDict[ply] = nil
    end
end