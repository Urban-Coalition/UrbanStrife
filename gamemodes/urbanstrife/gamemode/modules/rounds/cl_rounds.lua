net.Receive("us_stateupdate", function()
    GAMEMODE.RoundState = net.ReadUInt(3)
    GAMEMODE.RoundCount = net.ReadUInt(8)
    GAMEMODE.ActiveGameType = GAMEMODE.GameTypes[net.ReadString()]
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

local modestr = {
    [ROUND_PREGAME] = "#urbanstrife.round.pregame",
    [ROUND_POSTGAME] = "#urbanstrife.round.postgame",
}

local shadow = Color(0, 0, 0, 255)
local function drawtextshadow(str, font, x, y, clr, ...)
    draw.SimpleText(str, font .. "_Glow", x, y, shadow, ...)
    draw.SimpleText(str, font, x, y, clr, ...)
end
local function drawmultilineshadow(str, font, x, y, clr, ...)
    local lines = string.Explode("\n", str)
    for k, v in ipairs(lines) do
        drawtextshadow(v, font, x, y, clr, ...)
        local w, h = surface.GetTextSize(v)
        y = y + h + ScreenScale(2)
    end
end

hook.Add("HUDPaint", "Rounds", function()
    if IsValid(GAMEMODE.LoadoutPanel) or not GetConVar("cl_drawhud"):GetBool() or not GAMEMODE.ActiveGameType then return end

    local state = GAMEMODE:GetRoundState()
    if state == ROUND_STRIFE then return end

    if modestr[state] then
        drawtextshadow(language.GetPhrase(modestr[state]), "StrifeSS_12", ScrW() * 0.5, ScrH() - ScreenScale(16), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

        drawtextshadow(GAMEMODE:GetGameTypeParam("Name"), "StrifeSS_16", ScrW() * 0.5, ScreenScale(4), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        if GAMEMODE.RoundCount > 0 then
            drawtextshadow(GAMEMODE.RoundWins[TEAM_CT], "StrifeSS_20", ScrW() * 0.5 - ScreenScale(20), ScreenScale(18), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            drawtextshadow(GAMEMODE.RoundWins[TEAM_TR], "StrifeSS_20", ScrW() * 0.5 + ScreenScale(20), ScreenScale(18), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            drawtextshadow(":", "StrifeSS_20", ScrW() * 0.5, ScreenScale(18), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        else
            drawmultilineshadow(GAMEMODE:GetGameTypeParam("Description", LocalPlayer():Team()), "StrifeSS_12", ScrW() * 0.5, ScreenScale(18), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end
    drawtextshadow(string.ToMinutesSeconds(GAMEMODE.RoundLastTimer + GAMEMODE.RoundTimerLength - CurTime()), "StrifeSS_12", ScrW() * 0.5, ScrH() - ScreenScale(4), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end)