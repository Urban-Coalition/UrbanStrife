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

function GM:GameTypeFinish(winner)
    self.ActiveGameType = nil

    MsgAll("The winner is " .. (team.GetName(winner) or "nobody") .. "!")

    net.Start("us_gametypeupdate")
        net.WriteString("")
    net.Broadcast()
end