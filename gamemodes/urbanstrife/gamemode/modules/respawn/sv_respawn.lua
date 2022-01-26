GM.RespawnTimers = {}

function GM:RespawnThink()

    --local mode = self:GetGameTypeParam("Spawning.Mode")
    --if mode == SPAWNMODE_NONE then return end

    for ply, t in pairs(self.RespawnTimers) do
        if not IsValid(ply) then self.RespawnTimers[ply] = nil continue end
        if t < CurTime() then
            self.RespawnTimers[ply] = nil
            self:PlayerSpawn(ply)
        end
    end
end

function GM:PostPlayerDeath(ply)
    ply.LastDeath = CurTime()

    if mode == SPAWNMODE_TIME then
        GAMEMODE.RespawnTimers[ply] = CurTime() + self:GetGameTypeParam("Spawning.Delay", ply:Team())
    elseif mode == SPAWNMODE_WAVE then
        -- TODO wave based respawn
        -- maybe go rip off team fortress 2 or ins:s or something
    end
end

function GM:PlayerDeathThink(ply)
    if ply.LastDeath + 5 > CurTime() then return end

    if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED then
        self:PlayerSpawnAsSpectator(ply)
        return
    end

    -- In Strife, respawn after player chooses to (no spectator cam)
    if ply.ForceSpawn then
        ply:Spawn()
        ply.ForceSpawn = nil
    elseif self:GetRoundState() == ROUND_STRIFE then
        if (ply:IsBot() or ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_ATTACK2) or ply:KeyPressed(IN_JUMP)) then ply:Spawn() end
    elseif not ply.ReadyToSpawn then
        self:PlayerSpawnAsSpectator(ply)
    end
end