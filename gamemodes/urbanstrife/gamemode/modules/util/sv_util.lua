-- Prevent malicious clients from abusing net message requests
-- Most certainly overkill but you can never be too secure
local timeout = 1
local limit = 10
function GM:NetLimiterCheck(ply)
    if ply:IsAdmin() then return true end

    if (ply.NetMessageLast or 0) + timeout < CurTime() then
        ply.NetMessageCount = 1
        ply.NetMessageLast = CurTime()
    else
        ply.NetMessageCount = (ply.NetMessageCount or 0) + 1
    end

    if ply.NetMessageCount > limit then
        print("Player " .. ply:GetName() .. " is sending too many net messages!")
        return false
    end

    return true
end