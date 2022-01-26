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
    ply.NextSpawnTime = CurTime() + 5

    if mode == SPAWNMODE_TIME then
        GAMEMODE.RespawnTimers[ply] = CurTime() + self:GetGameTypeParam("Spawning.Delay", ply:Team())
    elseif mode == SPAWNMODE_WAVE then
        -- TODO wave based respawn
        -- maybe go rip off team fortress 2 or ins:s or something
    end
end

function GM:PlayerDeathThink(ply)

    if ply:Team() == TEAM_SPECTATOR then
        self:PlayerSpawnAsSpectator(ply)
        return
    end

    if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() and not ply.ForceSpawn then return end

    if ply.ForceSpawn or self:GetRoundState() == ROUND_PREGAME then
        --self:PlayerSpawn(ply)
        ply:Spawn()
        ply.ForceSpawn = nil
    elseif self:GetRoundState() == ROUND_STRIFE then
        -- In Strife, respawn after player chooses to (no spectator cam)
        if (ply:IsBot() or ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_ATTACK2) or ply:KeyPressed(IN_JUMP)) then ply:Spawn() end
    elseif not ply.ReadyToSpawn then
        self:PlayerSpawnAsSpectator(ply)
    end
end