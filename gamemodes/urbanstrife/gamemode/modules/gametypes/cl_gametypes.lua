hook.Add("HUDPaint", "GameType", function()
    -- TODO: draw gametype related hud - scores, tickets, time left, state etc
end)

net.Receive("us_gametypeupdate", function()
    local gametype = net.ReadString()
    if gametype == "" then
        GAMEMODE.ActiveGameType = nil
    else
        GAMEMODE.ActiveGameType = GAMEMODE.GameTypes[gametype]
        if not GAMEMODE.ActiveGameType then error("couldn't load gametype " .. tostring(gametype) .. "!") end
    end
    GAMEMODE.GameTypeParamCache = {}
end)