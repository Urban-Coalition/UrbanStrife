util.AddNetworkString("us_stateupdate")
util.AddNetworkString("us_scoreupdate")

net.Receive("us_stateupdate", function(len, ply)
    GAMEMODE:WriteRoundState(ply)
end)

net.Receive("us_scoreupdate", function(len, ply)
    GAMEMODE:WriteScores(ply)
end)

function GM:WriteRoundState(ply)
    net.Start("us_stateupdate")
    net.WriteUInt(GAMEMODE:GetRoundState(), 3)
    net.WriteUInt(GAMEMODE:GetRoundCount(), 8)
    net.WriteString(GAMEMODE:GetActiveGameTypeName()) -- TODO: Better way of networking gametype?
    net.WriteFloat(GAMEMODE.RoundLastTimer)
    net.WriteFloat(GAMEMODE.RoundTimerLength)

    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function GM:WriteScores(ply)
    net.Start("us_scoreupdate")
    net.WriteInt(GAMEMODE.Scores[TEAM_CT], 16)
    net.WriteInt(GAMEMODE.Scores[TEAM_TR], 16)
    net.WriteUInt(GAMEMODE.RoundWins[TEAM_CT], 8)
    net.WriteUInt(GAMEMODE.RoundWins[TEAM_TR], 8)
    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function GM:SetRoundState(state, dur)
    if istable(dur) then PrintTable(dur) end
    print("setting state to " .. tostring(state) .. " for " .. tostring(dur or 0) .. "s")
    self.RoundState = state
    self.RoundLastTimer = CurTime()
    self.RoundTimerLength = dur or 0
    self:WriteRoundState()
end

function GM:RoundSetup()
    self.RespawnTimers = {}
    self.Scores = {[TEAM_CT] = 0, [TEAM_TR] = 0}

    game.CleanUpMap()

    for _, ply in pairs(player.GetAll()) do
        if ply:Team() == TEAM_CT or ply:Team() == TEAM_TR then
            ply.ForceSpawn = true
            if ply:Alive() then ply:KillSilent() end
            timer.Simple(0.1, function() ply:Freeze(true) end)
        end
    end

    self:SetRoundState(ROUND_PREGAME, self:GetGameTypeParam("Rounds.PregameTime"))
    self:WriteScores()
end

function GM:RoundStart()

    MsgAll("game start!")
    self:SetRoundState(ROUND_PLAYING, self:GetGameTypeParam("Rounds.RoundLength"))
    for _, ply in pairs(player.GetAll()) do
        if ply:Team() == TEAM_CT or ply:Team() == TEAM_TR then
            ply:Freeze(false)
        end
    end
end

function GM:RoundTimeoutWinner()
    local winner = self:CallGameTypeFunction("Rounds.ResolveTimeout")
    if winner ~= nil and winner ~= false then return winner end

    -- TODO check win condition

    return 0
end

function GM:RoundFinish(winner)

    MsgAll("the winner is: " .. winner)

    if winner ~= 0 then
        self.RoundWins[winner] = self.RoundWins[winner] + 1
    end

    PrintTable(self.RoundWins)

    self:CallGameTypeFunction("OnRoundFinish", winner)

    local roundcount = self:GetGameTypeParam("Rounds.RoundCount")

    if self:GetGameTypeParam("Rounds.BestOf") and self.RoundWins[winner] > math.floor(roundcount / 2) then
        self:GameTypeFinish(winner)
    elseif self:GetRoundCount() >= roundcount then
        local ct, tr = self.RoundWins[TEAM_CT], self.RoundWins[TEAM_TR]
        if ct == tr then
            if self:GetGameTypeParam("Rounds.Tiebreaker") then
                MsgAll("Playing tiebreaker round!")
                self:SetRoundState(ROUND_POSTGAME, self:GetGameTypeParam("Rounds.PostgameTime"))
            else
                self:SetRoundState(ROUND_POSTMODE)
                self:GameTypeFinish(0)
            end
        else
            self:SetRoundState(ROUND_POSTMODE)
            self:GameTypeFinish(ct > tr and TEAM_CT or TEAM_TR)
        end
        -- TODO: tiebreaker round?

    else
        self:SetRoundState(ROUND_POSTGAME, self:GetGameTypeParam("Rounds.PostgameTime"))
    end
end

function GM:RoundWinCheck()

    if self:GetGameTypeParam("WinCond.Score") then
        local limit = self:CallGameTypeFunction("GetScoreLimit") or self:GetGameTypeParam("WinCond.ScoreLimit")
        local ct, tr = self.Scores[TEAM_CT], self.Scores[TEAM_TR]
        if ct > limit and tr > limit then
            if ct == tr then
                return 0
            else
                return (ct > tr and TEAM_CT) or TEAM_TR
            end
        elseif ct > limit then
            return TEAM_CT
        elseif tr > limit then
            return TEAM_TR
        end
    end

    if self:GetGameTypeParam("WinCond.Eliminate") then
        -- TODO: check tickets
        local ct, tr = false, false
        for _, ply in pairs(team.GetPlayers(TEAM_CT)) do
            if ply:Alive() and ply:GetObserverMode() == OBS_MODE_NONE then
                ct = true
                break
            end
        end
        for _, ply in pairs(team.GetPlayers(TEAM_TR)) do
            if ply:Alive() and ply:GetObserverMode() == OBS_MODE_NONE then
                tr = true
                break
            end
        end
        if ct and not tr then
            return TEAM_CT
        elseif tr and not ct then
            return TEAM_TR
        elseif not ct and not tr then
            return 0
        end
    end

    -- TODO: control points
end

local lastwincheck = 0
function GM:RoundThink()

    local state = self:GetRoundState()
    if state == ROUND_STRIFE then return end

    if self.RoundLastTimer + self.RoundTimerLength < CurTime() then
        if state == ROUND_PREGAME then
            self:RoundStart()
        elseif state == ROUND_PLAYING then
            local ot = self:CallGameTypeFunction("Rounds.ShouldOvertime")
            if not ot then
                self:RoundFinish(self:RoundTimeoutWinner())
            end
        elseif state == ROUND_POSTGAME then
            if self:GetRoundCount() >= self:GetGameTypeParam("Rounds.RoundCount") then
                self:StartVoting()
                self:SetRoundState(ROUND_POSTMODE, 30) -- TODO convar for voting duration
            else
                self:RoundSetup()
            end
        elseif state == ROUND_POSTMODE then
            self:SetRoundState(ROUND_STRIFE)
            self:FinishVoting()
        end
        return
    end

    if state == ROUND_PLAYING then
        self:CallGameTypeFunction("Think")
        self:RespawnThink()

        if lastwincheck < CurTime() then
            lastwincheck = CurTime() + 1
            local winner = self:RoundWinCheck()
            if winner ~= nil then
                self:RoundFinish(winner)
            end
        end
    end
end