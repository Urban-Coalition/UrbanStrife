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