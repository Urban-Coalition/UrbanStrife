-- No respawns
SPAWNMODE_NONE = 0
-- Individual timer
SPAWNMODE_TIME = 1
-- Wave-based (each wave respawns all dead players)
SPAWNMODE_WAVE = 2

GM.GameTypes = {}

function GM:LoadGameTypes(path)
    path = path or (GAMEMODE.FolderName .. "/gamemode/gametypes/")
    for _, f in SortedPairs(file.Find(path .. "/*.lua", "LUA"), false) do
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