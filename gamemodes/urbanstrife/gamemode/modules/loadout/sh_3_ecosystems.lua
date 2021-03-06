function GM:LoadEcosystems(path)
    path = path or (GAMEMODE.FolderName .. "/gamemode/ecosystems/")
    for _, f in SortedPairs(file.Find(path .. "*.lua", "LUA") or {}, false) do
        local succ, err = pcall(function()
            AddCSLuaFile(path .. f)
            include(path .. f)
        end)
        if not succ or not ECOSYSTEM then
            print("Failed to load ecosystem '" .. f .. "': " .. tostring(err))
            continue
        end
        local name = string.Explode(".", f)[1]

        if ECOSYSTEM.Ignore or (ECOSYSTEM.Check and not ECOSYSTEM:Check()) then continue end

        if ECOSYSTEM.OnLoad then
            ECOSYSTEM:OnLoad()
        end

        if ECOSYSTEM.LoadoutEntries then
            for k, v in pairs(ECOSYSTEM.LoadoutEntries) do
                v.ecosystem = name
                self:AddLoadoutEntry(k, v)
            end
        end

        if ECOSYSTEM.PartialAttachments then
            GAMEMODE.PartialAttachments = table.Merge(GAMEMODE.PartialAttachments, ECOSYSTEM.PartialAttachments)
        end

        ECOSYSTEM = nil
    end
end