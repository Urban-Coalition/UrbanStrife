GM.GameTypes = {}

function GM:LoadGameTypes(path)
    path = path or (GAMEMODE.FolderName .. "/gamemode/gametypes/")
    for _, f in SortedPairs(file.Find(path .. "/*.lua", "LUA") or {}, false) do
        local succ, err = pcall(function()
            AddCSLuaFile(path .. "/" .. f)
            include(path .. "/" .. f)
        end)
        if not succ or not GAMETYPE then
            print("Failed to load gametype '" .. f .. "': " .. tostring(err))
            continue
        end
        local name = string.Explode(".", f)[1]

        GAMEMODE.GameTypes[name] = GAMETYPE
        GAMEMODE.GameTypes[name].ShortName = name
        GAMETYPE = nil
    end
end