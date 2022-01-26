AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("player_class/player_us.lua")
include("shared.lua")
include("player_class/player_us.lua")

function GM:PlayerInitialSpawn(ply, transiton)

    if ply:IsBot() and GAMEMODE.OptionConvars.dev_botteam:GetInt() > 0 then
        ply:SetTeam(GAMEMODE.OptionConvars.dev_botteam:GetInt())
        return
    end

    local ct, tr = #team.GetPlayers(TEAM_CT), #team.GetPlayers(TEAM_TR)
    if ct > tr or (ct == tr and math.random() <= 0.5) then
        ply:SetTeam(TEAM_TR)
    else
        ply:SetTeam(TEAM_CT)
    end

end

function GM:PlayerSpawnAsSpectator(ply)
    ply:StripWeapons()
    --ply:SetTeam(TEAM_SPECTATOR)
    ply:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerSpawn(ply, transiton)
    if ply:Team() == TEAM_SPECTATOR then
        self:PlayerSpawnAsSpectator(ply)
        return
    end

    ply:UnSpectate()
    ply:SetupHands()
    player_manager.SetPlayerClass(ply, "player_us")
    player_manager.OnPlayerSpawn(ply, transiton)
    player_manager.RunClass(ply, "Spawn")

    if not transiton then
        hook.Call("PlayerLoadout", GAMEMODE, ply)
    end

    hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:Think()
    self:RoundThink()
end