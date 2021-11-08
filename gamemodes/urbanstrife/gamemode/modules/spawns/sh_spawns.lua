-- Areas within which a team is invulnerable, and the other team cannot enter.
GM.SpawnAreas = {
    -- {Vector mins, Vector maxs, number team}
    -- {Vector origin, number radius, number team}
}

local PLAYER = FindMetaTable("Player")

function PLAYER:GetSpawnArea()
    local p = self:WorldSpaceCenter()
    for i, a in pairs(GAMEMODE.SpawnAreas) do
        if (isnumber(a[2]) and (p:Distance(a[1]) <= a[2]))
                or (not isnumber(a[2]) and p:WithinAABox(a[1], a[2])) then
            return a[3]
        end
    end
    return false
end

concommand.Add("us_loadspawnset", function(ply, cmd, args, argStr)
    if CLIENT or (IsValid(ply) and not ply:IsAdmin()) then return end
    if not args[1] or args[1] == "" then
        MsgN("You must provide a set name!")
        return
    end
    local result = GAMEMODE:LoadSpawnSet(args[1])
    if result then
        MsgN("Loaded spawn set '", args[1], "'.")
    else
        MsgN("Could not load spawn set '", args[1], "'!")
    end
end)

concommand.Add("us_savespawnset", function(ply, cmd, args, argStr)
    if CLIENT or (IsValid(ply) and not ply:IsAdmin()) then return end
    if not args[1] or args[1] == "" then
        MsgN("You must provide a set name!")
        return
    end
    GAMEMODE:SaveSpawnSet(args[1])
    MsgN("Saved spawn set '", args[1], "'.")
end)