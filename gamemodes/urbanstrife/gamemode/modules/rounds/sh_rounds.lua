
--
-- Round enums
--

-- "Strife" gametype, basically a deathmatch lobby
ROUND_STRIFE = 0

-- Round status
ROUND_PREGAME = 1
ROUND_PLAYING = 2
ROUND_POSTGAME = 3

-- A gametype has ended and we are voting
ROUND_POSTMODE = 4

GM.RoundState = ROUND_STRIFE

function GM:GetRoundState()
    return GAMEMODE.RoundState
end