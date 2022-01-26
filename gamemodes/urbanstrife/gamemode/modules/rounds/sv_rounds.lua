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
    net.WriteString(GAMEMODE:GetActiveGameType()) -- TODO: Better way of networking gametype?
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
    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function GM:SetRoundState(state, dur)
    self.RoundState = state
    self.RoundLastTimer = CurTime()
    self.RoundTimerLength = dur or 0
    self:WriteRoundState()
end

function GM:RoundSetup()
    self:SetRoundState(ROUND_PREGAME, self:GetGameTypeParam("Rounds.PregameTime"))
end

function GM:RoundStart()

    MsgAll("game start!")
    self:SetRoundState(ROUND_PLAYING, self:GetGameTypeParam("Rounds.RoundLength"))

end

function GM:RoundTimeoutWinner()
    local winner = self:CallGameTypeFunction("Rounds.ResolveTimeout")
    if winner ~= nil and winner ~= false then return winner end

    -- TODO check win condition

    return 0
end

function GM:RoundFinish(winner)

    MsgAll("the winner is: " .. winner)

    self:CallGameTypeFunction("OnRoundFinish", winner)

    if self:GetRoundCount() >= self:GetGameTypeParam("Rounds.RoundCount") then
        -- TODO: tiebreaker round?
        self:SetRoundState(ROUND_POSTMODE)
        self:GameTypeFinish()
    else
        self:SetRoundState(ROUND_POSTGAME, self:GetGameTypeParam("Rounds.PostgameTime"))
    end
end

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
                self:SetRoundState(ROUND_POSTGAME, self:GetGameTypeParam("Rounds.PostgameTime"))
            end
        elseif state == ROUND_POSTMODE then
            self:SetRoundState(ROUND_STRIFE)
            self:FinishVoting()
        end
        return
    end

    if state == ROUND_PLAYING then
        self:CallGameTypeFunction("Think")
    end
end