util.AddNetworkString("us_gametypeupdate")

function GM:GameTypeStart(gametype)

    self.ActiveGameType = self.GameTypes[gametype]
    self.GameTypeParamCache = {}
    if not self.ActiveGameType then error("couldn't load gametype " .. tostring(gametype) .. "!") end

    net.Start("us_gametypeupdate")
        net.WriteString(gametype)
    net.Broadcast()

    self:RoundSetup()
end

function GM:GameTypeFinish()
    self.ActiveGameType = nil

    net.Start("us_gametypeupdate")
        net.WriteString("")
    net.Broadcast()
end