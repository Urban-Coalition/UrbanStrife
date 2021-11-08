local function read()
    local i = net.ReadUInt(8)
    GAMEMODE.SpawnAreas[i] = {}
    GAMEMODE.SpawnAreas[i][1] = net.ReadVector()
    if net.ReadBool() then
        GAMEMODE.SpawnAreas[i][2] = net.ReadFloat()
    else
        GAMEMODE.SpawnAreas[i][2] = net.ReadVector()
    end
    GAMEMODE.SpawnAreas[i][3] = net.ReadUInt(4)
end

net.Receive("UpdateSpawnArea", function()
    if net.ReadBool() then
        GAMEMODE.SpawnAreas[net.ReadUInt(8)] = nil
    else
        read()
    end
end)
net.Receive("UpdateSpawnAreaFull", function()
    GAMEMODE.SpawnAreas = {}
    for i = 1, net.ReadUInt(8) do
        read()
    end
end)

hook.Add("InitPostEntity", "UpdateSpawnArea", function()
    net.Start("UpdateSpawnAreaFull")
    net.SendToServer()
end)