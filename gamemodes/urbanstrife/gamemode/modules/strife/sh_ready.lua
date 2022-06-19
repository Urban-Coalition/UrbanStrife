GM.ReadyPlayers = {}
GM.ReadyPlayersDict = {}

function GM:ReadyPlayerCount()
    return math.ceil(#player.GetHumans() * GetConVar("us_round_ready_fraction"):GetFloat())
end

function GM:IsEnoughPlayersReady()
    return #GAMEMODE.ReadyPlayers > GAMEMODE:ReadyPlayerCount()
end

function GM:IsPlayerReady(ply)
    return ply:IsBot() or GAMEMODE.ReadyPlayersDict[ply] ~= nil
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