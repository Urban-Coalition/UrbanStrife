net.Receive("us_stateupdate", function()
    GAMEMODE.RoundState = net.ReadUInt(3)
    GAMEMODE.RoundCount = net.ReadUInt(8)
    GAMEMODE.ActiveGameType = net.ReadString()
    GAMEMODE.RoundLastTimer = net.ReadFloat()
    GAMEMODE.RoundTimerLength = net.ReadFloat()
end)

net.Receive("us_scoreupdate", function()
    GAMEMODE.Scores = {}
    GAMEMODE.Scores[TEAM_CT] = net.ReadInt(16)
    GAMEMODE.Scores[TEAM_TR] = net.ReadInt(16)
    GAMEMODE.RoundWins = {}
    GAMEMODE.RoundWins[TEAM_CT] = net.ReadUInt(8)
    GAMEMODE.RoundWins[TEAM_TR] = net.ReadUInt(8)
end)