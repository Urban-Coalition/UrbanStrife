
--
-- Round enums
--

-- "Strife" gametype, basically a deathmatch lobby
ROUND_STRIFE = 0

-- Round status
ROUND_PREGAME = 1
ROUND_PLAYING = 2
ROUND_POSTGAME = 3
ROUND_POSTMODE = 4 -- A gametype has ended and we are voting

GM.RoundState = ROUND_STRIFE
GM.RoundCount = 0
GM.RoundLastTimer = 0
GM.RoundTimerLength = 0

GM.Scores = {
    [TEAM_CT] = 0,
    [TEAM_TR] = 0,
}

function GM:GetRoundState()
    return GAMEMODE.RoundState
end

function GM:GetRoundCount()
    return GAMEMODE.RoundCount
end