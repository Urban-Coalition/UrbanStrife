util.AddNetworkString("us_updatespawnareas")
util.AddNetworkString("us_fullupdatespawnareas")

local function writearea(i)
    local a = GAMEMODE.SpawnAreas[i]
    if not a then return end
    net.WriteUInt(i, 8)
    net.WriteVector(a[1])
    net.WriteBool(isnumber(a[2]))
    if isnumber(a[2]) then
        net.WriteFloat(a[2])
    else
        net.WriteVector(a[2])
    end
    net.WriteUInt(a[3], 4)
end

function GM:SendSpawnArea(i)
    net.Start("us_updatespawnareas")
        if GAMEMODE.SpawnAreas[i] == nil then
            net.WriteBool(true)
            net.WriteUInt(i, 8)
        else
            net.WriteBool(false)
            writearea(i)
        end
    net.Broadcast()
end

function GM:SendSpawnAreaFull(ply)
    net.Start("us_fullupdatespawnareas")
        net.WriteUInt(table.Count(GAMEMODE.SpawnAreas), 8)
        for k, v in pairs(GAMEMODE.SpawnAreas) do
            writearea(k)
        end
    if not ply then net.Broadcast() else net.Send(ply) end
end
net.Receive("us_fullupdatespawnareas", function(len, ply)
    GAMEMODE:SendSpawnAreaFull(ply)
end)

function GM:LoadSpawnSet(name)
    local f = "urbanstrife/" .. game.GetMap() .. "/spawnsets/" .. string.lower(name) .. ".json"
    if not file.Exists(f, "DATA") then return false end

    for _, spawn in pairs(ents.FindByClass("us_spawn_ct")) do
        spawn:Remove()
    end
    for _, spawn in pairs(ents.FindByClass("us_spawn_tr")) do
        spawn:Remove()
    end

    local spawns = util.JSONToTable(file.Read(f))
    GAMEMODE.SpawnAreas = spawns.Areas
    for _, v in pairs(spawns.Points) do
        local spawn = ents.Create(v[2])
        spawn:SetPos(v[1])
        spawn:Spawn()
    end

    return true
end

function GM:SaveSpawnSet(name)
    local spawns = {
        Areas = GAMEMODE.SpawnAreas,
        Points = {}
    }
    for _, spawn in pairs(ents.FindByClass("us_spawn_ct")) do
        table.insert(spawns.Points, {spawn:GetPos(), spawn:GetClass()})
    end
    for _, spawn in pairs(ents.FindByClass("us_spawn_tr")) do
        table.insert(spawns.Points, {spawn:GetPos(), spawn:GetClass()})
    end

    file.CreateDir("urbanstrife/" .. game.GetMap() .. "/spawnsets")
    local f = "urbanstrife/" .. game.GetMap() .. "/spawnsets/" .. string.lower(name) .. ".json"
    file.Write(f, util.TableToJSON(spawns))
end