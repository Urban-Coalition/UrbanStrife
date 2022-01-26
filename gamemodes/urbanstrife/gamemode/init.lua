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

    if (ply:Team() == TEAM_UNASSIGNED) then
        ply:Spectate(OBS_MODE_FIXED)
        return
    end

    ply:SetTeam(TEAM_SPECTATOR)
    ply:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerSpawn(ply, transiton)
    if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED then
        self:PlayerSpawnAsSpectator(ply)
        return
    end

    -- Stop observer mode
    ply:UnSpectate()
    player_manager.SetPlayerClass(ply, "player_us")
    player_manager.OnPlayerSpawn(ply, transiton)
    player_manager.RunClass(ply, "Spawn")
    ply:SetupHands()

    -- If we are in transition, do not touch player's weapons
    if (not transiton) then
        -- Call item loadout function
        hook.Call("PlayerLoadout", GAMEMODE, ply)
    end

    -- Set player model
    hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:Think()
    self:RoundThink()
end