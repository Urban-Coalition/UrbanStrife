net.Receive("us_strifeupdate", function()
    GAMEMODE.StrifeAdvantage = net.ReadFloat()
end)

local last_advantage = 0
hook.Add("HUDPaint", "Strife", function()
    if IsValid(GAMEMODE.LoadoutPanel) or not GetConVar("cl_drawhud"):GetBool() then return end
    if GAMEMODE:GetRoundState() == ROUND_STRIFE then

        local ct_abbrev, tr_abbrev = language.GetPhrase("urbanstrife.teamabbrev.ct"), language.GetPhrase("urbanstrife.teamabbrev.tr")

        --draw.SimpleText("STRIFE", "StrifeSS_12", ScrW() * 0.5, ScreenScale(4), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleTextOutlined(ct_abbrev, "StrifeSS_12", ScrW() * 0.4 - 4, ScrH() - ScreenScale(2), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, TCLR_DARK[TEAM_CT])
        draw.SimpleTextOutlined(tr_abbrev, "StrifeSS_12", ScrW() * 0.6 + 4, ScrH() - ScreenScale(2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, TCLR_DARK[TEAM_TR])

        last_advantage = Lerp(FrameTime() * 5, last_advantage, GAMEMODE.StrifeAdvantage)

        local border = 2
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(ScrW() * 0.4 - border, ScrH() * 0.98 - ScreenScale(4) - border, ScrW() * 0.2 + border * 2, ScrH() * 0.02 + border * 2)

        local ct_len = (last_advantage + 100) / 100 * ScrW() * 0.1
        draw.RoundedBox(0, ScrW() * 0.4, ScrH() * 0.98 - ScreenScale(4), ct_len, ScrH() * 0.02, TCLR[TEAM_CT])
        draw.RoundedBox(0, ScrW() * 0.4 + ct_len, ScrH() * 0.98 - ScreenScale(4), ScrW() * 0.2 - ct_len, ScrH() * 0.02, TCLR[TEAM_TR])

        local str = nil
        local clr = TCLR_DARK[GAMEMODE.StrifeAdvantage > 0 and TEAM_CT or TEAM_TR]
        if GAMEMODE.StrifeAdvantage >= 75 then
            str = string.upper(string.Replace(language.GetPhrase("urbanstrife.strife.lead3"), "{team}", ct_abbrev))
        elseif GAMEMODE.StrifeAdvantage > 50 then
            str = string.upper(string.Replace(language.GetPhrase("urbanstrife.strife.lead2"), "{team}", ct_abbrev))
        elseif GAMEMODE.StrifeAdvantage > 25 then
            str = string.upper(string.Replace(language.GetPhrase("urbanstrife.strife.lead1"), "{team}", ct_abbrev))
        elseif GAMEMODE.StrifeAdvantage < -75 then
            str = string.upper(string.Replace(language.GetPhrase("urbanstrife.strife.lead3"), "{team}", tr_abbrev))
        elseif GAMEMODE.StrifeAdvantage < -50 then
            str = string.upper(string.Replace(language.GetPhrase("urbanstrife.strife.lead2"), "{team}", tr_abbrev))
        elseif GAMEMODE.StrifeAdvantage < -25 then
            str = string.upper(string.Replace(language.GetPhrase("urbanstrife.strife.lead1"), "{team}", tr_abbrev))
        end
        if str then
            draw.SimpleTextOutlined(str, "StrifeSS_8", ScrW() * 0.5, ScrH() * 0.98 - ScreenScale(6), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, clr)
        end
    end
end)