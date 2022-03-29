util.AddNetworkString("us_gametypeupdate")

local function gametypes(cmd, args)
    local tbl = {}
    for _, v in pairs(GAMEMODE.GameTypes) do table.insert(tbl, cmd .. " " .. v.ShortName) end
    return tbl
end

concommand.Add("us_admin_gametypestart", function(ply, cmd, args)
    if not IsValid(ply) or ply:IsAdmin() then
        GAMEMODE:GameTypeStart(args[1])
    end
end, gametypes)

concommand.Add("us_admin_gametypefinish", function(ply, cmd, args)
    if not IsValid(ply) or ply:IsAdmin() then
        GAMEMODE:GameTypeFinish(args[1])
    end
end, gametypes)

function GM:GameTypeStart(gametype)

    self.ActiveGameType = self.GameTypes[gametype]
    self.GameTypeParamCache = {}
    self.RoundCount = 0

    if not self.ActiveGameType then error("couldn't load gametype " .. tostring(gametype) .. "!") end

    self:CallGameTypeFunction("OnGameTypeStart")

    net.Start("us_gametypeupdate")
        net.WriteString(gametype)
    net.Broadcast()

    self:RoundSetup()
end

function GM:GameTypeFinish(winner)
    MsgAll("The match winner is " .. (team.GetName(winner) or "nobody") .. "!")

    self:CallGameTypeFunction("OnGameTypeFinish", winner)

    self.ActiveGameType = nil
    self.GameTypeParamCache = {}
    self.RoundCount = 0

    net.Start("us_gametypeupdate")
        net.WriteString("")
    net.Broadcast()

    self:StartVoting()
    self:SetRoundState(ROUND_POSTMATCH, 30)
end