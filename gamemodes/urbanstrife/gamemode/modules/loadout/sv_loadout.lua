util.AddNetworkString("loadout_open")
util.AddNetworkString("loadout_update")

net.Receive("loadout_update", function(len, ply)
    ply.LastLoadout = {}
    local amt = net.ReadUInt(8)
    for i = 1, amt do
        local slotname = net.ReadString()
        local slot = GAMEMODE.LoadoutSlots[slotname]

        if not slot then print("no valid slot " .. tostring(slotname)) return end

        ply.LastLoadout[slotname] = table.Copy(ply.Loadout[slotname])

        local id = net.ReadUInt(GAMEMODE:GetEntryBits())
        if id == 0 then
            ply.Loadout[slotname] = nil
        else
            local entry = GAMEMODE.LoadoutEntries[GAMEMODE.LoadoutIDToEntry[id]]
            if not entry then continue end
            if not GAMEMODE:EntryFitsSlot(slot, entry) then print("entry " .. tostring(GAMEMODE.LoadoutIDToEntry[id]) .. " does not fit slot " .. slotname) return end

            ply.Loadout[slotname] = {entry.shortname, nil}

            if entry.attachments then
                ply.Loadout[slotname][2] = {}
                for j = 1, #entry.attachments do
                    local attid = net.ReadUInt(GAMEMODE:GetAttBits())
                    if attid ~= 0 then
                        ply.Loadout[slotname][2][j] = GAMEMODE.EntryIDToAtt[attid]
                    end
                end
            end
        end
    end

    if GAMEMODE:GetLoadoutCost(ply.Loadout) > GAMEMODE:GetLoadoutBudget() then
        ply.Loadout = ply.LastLoadout
        print("loadout exceeds budget!")
        return
    end

    if ply:GetSpawnArea() == ply:Team() then
        GAMEMODE:GiveLoadoutPlayer(ply, true)
    else
        ply:ChatPrint("Your loadout will be applied on respawn.")
    end
end)

function GM:ShowSpare2(ply)
    net.Start("loadout_open")
    net.Send(ply)
end

function GM:GiveLoadoutEntry(ply, id, atts, slot)
    local entry = GAMEMODE.LoadoutEntries[id]
    if not entry then print("invalid loadout entry " .. tostring(id)) return end

    if entry.callback then
        entry:callback(ply)
    end
    if entry.class then
        local wep = ply:Give(entry.class, entry.nodefaultclip)

        if entry.atttype == ATTTYPE_ARCCW then
            wep:SetHolster_Time(1)
            wep:SetHolster_Entity(NULL)
            if entry.atttype and entry.attachments and atts then
                for k, v in pairs(entry.attachments) do
                    if not atts[k] then continue end
                    wep.Attachments[k].Installed = atts[k]
                end
            end
        elseif entry.atttype == ATTTYPE_TACRP then
            -- TODO: TacRP attachments
        else

        end

        if slot and slot.ammolevel then
            local ammolevel = slot.ammolevel[ply:GetNWInt("AmmoLevel", 0) + 1]
            local ammotype = wep and wep.Primary.Ammo or entry.ammotype
            local size = wep.Primary.ClipSize
            if wep and wep.ArcCW then
                wep:AdjustAtts()
                ammotype = wep:GetBuff_Override("Override_Ammo", wep.Primary.Ammo) or ammotype
                size = wep:GetCapacity()
            end
            -- completely arbitrary threshold but just trust me ok
            if size >= 75 then ammolevel = math.ceil(ammolevel / 3) end
            ply:GiveAmmo(ammolevel * size, ammotype, true)
        end
        wep:SetClip1(wep.ArcCW and (wep:GetCapacity() + wep:GetChamberSize()) or wep.Primary.ClipSize)

        if entry.ammotype and entry.ammocount then
            ply:GiveAmmo(entry.ammocount, entry.ammotype, true)
        end
    end
end

function GM:GiveLoadoutPlayer(ply, strip)

    if strip then
        ply:StripWeapons()
        ply:StripAmmo()
        ply.ArcCW_AttInv = nil
        ArcCW:PlayerSendAttInv(ply)
        for _, v in pairs(ply.LastLoadout or {}) do
            if v and v[1] and GAMEMODE.LoadoutEntries[v[1]].revoke then
                GAMEMODE.LoadoutEntries[v[1]]:revoke(ply)
            end
        end
    end

    for k, v in pairs(GAMEMODE.LoadoutSlots) do
        local slot = ply.Loadout[k]
        if not slot then continue end
        GAMEMODE:GiveLoadoutEntry(ply, slot[1], slot[2], v)
    end

    for k, v in pairs(GAMEMODE.LoadoutSlots) do
        local slot = ply.Loadout[k]
        if not slot then continue end
        local entry = GAMEMODE.LoadoutEntries[slot[1]]

        if entry and entry.class and v.primary then
            ply:SelectWeapon(entry.class)
        end
    end
end

net.Receive("loadout_open", function(len, ply)
    if ply:GetSpawnArea() == ply:Team() then
        GAMEMODE:GiveLoadoutPlayer(ply, true)
    end
end)