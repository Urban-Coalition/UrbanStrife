util.AddNetworkString("us_strifeupdate")

function GM:StrifeInitialize()
    game.CleanUpMap()
    GAMEMODE:LoadSpawnSet("strife")
end

function GM:StrifeBroadcast()
    net.Start("us_strifeupdate")
        net.WriteFloat(GAMEMODE.StrifeAdvantage)
    net.Broadcast()
end

function GM:StrifeTeamMult(t)
    local ct = #team.GetPlayers(TEAM_CT)
    local tr = #team.GetPlayers(TEAM_TR)
    local mult = math.Clamp(t == TEAM_CT and tr / ct or ct / tr, 0.5, 1.25)
    if GAMEMODE:StrifeAdvantageTeam() == GAMEMODE:OppositeTeam(t)
            and math.abs(GAMEMODE.StrifeAdvantage) > 75 then
        mult = mult * 2
    end
    return mult
end

function GM:StrifeAddAdvantage(t, amt)
    self.StrifeAdvantage = math.Clamp(self.StrifeAdvantage + (t == TEAM_CT and amt or -amt), -100, 100)
end

function GM:StrifeDecayAdvantage(amt)
    if math.abs(self.StrifeAdvantage) <= amt then
        self.StrifeAdvantage = 0
    else
        self.StrifeAdvantage = self.StrifeAdvantage + (self.StrifeAdvantage > 0 and -amt or amt)
    end
end

function GM.StrifeThink()
    if GAMEMODE:GetRoundState() == ROUND_STRIFE and
            GAMEMODE.StrifeAdvantage ~= 0 and GAMEMODE.StrifeLastScore < CurTime() - 10 then
        GAMEMODE:StrifeDecayAdvantage(3 * (1 + math.abs(GAMEMODE.StrifeAdvantage / 100)))
        GAMEMODE:StrifeBroadcast()
    end
end
timer.Create("StrifeThink", 3, 0, GM.StrifeThink)

hook.Add("PlayerDeath", "Strife", function(ply, inflictor, attacker)
    if GAMEMODE:GetRoundState() == ROUND_STRIFE and
            ply ~= attacker and not (attacker:IsNPC() or attacker:IsNextBot())
            and (not attacker:IsPlayer() or ply:Team() ~= attacker:Team()) then
        local t2 = GAMEMODE:OppositeTeam(ply:Team())
        GAMEMODE:StrifeAddAdvantage(t2, 5 * GAMEMODE:StrifeTeamMult(t2))
        GAMEMODE.StrifeLastScore = CurTime()
        GAMEMODE:StrifeBroadcast()
    end
end)

hook.Add("PlayerRequestData", "Strife", function(ply)
    net.Start("us_strifeupdate")
        net.WriteFloat(GAMEMODE.StrifeAdvantage)
    net.Send(ply)
end)