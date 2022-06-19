util.AddNetworkString("us_strifeready")

function GM:SendAllReadyPlayers(ply)
    net.Start("us_strifeready")
        PrintTable(self.ReadyPlayers)
        net.WriteUInt(#self.ReadyPlayers, 7)
        for i = 1, #self.ReadyPlayers do
            net.WriteEntity(self.ReadyPlayers[i])
        end
    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function GM:ShowSpare1(ply)
    if self:IsPlayerReady(ply) then
        self:RemovePlayerFromReadyTable(ply)
    else
        self:AddPlayerToReadyTable(ply)
    end
    self:SendAllReadyPlayers()
end

net.Receive("us_strifeready", function(len, ply)
    if not GAMEMODE:NetLimiterCheck(ply) then return end
    if net.ReadBool() then
        -- Send all ready players to the player
        GAMEMODE:SendAllReadyPlayers(ply)
    else
        if net.ReadBool() then
            GAMEMODE:AddPlayerToReadyTable(ply)
        else
            GAMEMODE:AddPlayerToReadyTable(ply)
        end
    end

    if GAMEMODE:IsEnoughPlayersReady() then
        GM:StartVoting()
    end
end)

-- If a player disconnects, remove them from the ready table
hook.Add("PlayerDisconnected", "Ready", GM.RemovePlayerFromReadyTable)

hook.Add("PlayerRequestData", "Ready", function(ply)
    GAMEMODE:SendAllReadyPlayers(ply)
end)
