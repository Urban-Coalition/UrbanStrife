AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("player_class/player_us.lua")
include("shared.lua")
include("player_class/player_us.lua")

function GM:PlayerInitialSpawn(pl, transiton)
    pl:SetTeam((#team.GetPlayers(TEAM_CT) < #team.GetPlayers(TEAM_TR) or math.random() <= 0.5) and TEAM_CT or TEAM_TR)
end

function GM:PlayerSpawnAsSpectator(pl)
    pl:StripWeapons()

    if (pl:Team() == TEAM_UNASSIGNED) then
        pl:Spectate(OBS_MODE_FIXED)

        return
    end

    pl:SetTeam(TEAM_SPECTATOR)
    pl:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerSpawn(pl, transiton)
    if self.TeamBased and (pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_UNASSIGNED) then
        self:PlayerSpawnAsSpectator(pl)
        return
    end

    -- Stop observer mode
    pl:UnSpectate()
    player_manager.SetPlayerClass(pl, "player_us")
    player_manager.OnPlayerSpawn(pl, transiton)
    player_manager.RunClass(pl, "Spawn")
    pl:SetupHands()

    -- If we are in transition, do not touch player's weapons
    if (not transiton) then
        -- Call item loadout function
        hook.Call("PlayerLoadout", GAMEMODE, pl)
    end

    -- Set player model
    hook.Call("PlayerSetModel", GAMEMODE, pl)
end