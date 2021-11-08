--[[]
    Advantage is the score counter for the default "Strife" mode, goes from -100 to 100.
    It has zero gameplay impact - it's just for show.

    Positive values means the CT side is winning, and negative means TR side is winning.
    Each side increases their advantage by getting kills.
    If a map has control points, holding them increases the score multiplier.
    There is a score bonus (up to 25%) for being outnumbered and an inverse penalty (up to -50%)
    The score will start to decay if nobody scores for 10 seconds.
]]
GM.StrifeAdvantage = GM.StrifeAdvantage or 0

-- Last time a scoring kill was made
GM.StrifeLastScore = 0

function GM:StrifeAdvantageTeam()
    if self.StrifeAdvantage == 0 then
        return nil
    end
    return self.StrifeAdvantage > 0 and TEAM_CT or TEAM_TR
end