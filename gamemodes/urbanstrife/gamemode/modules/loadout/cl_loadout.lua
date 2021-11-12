GM.LoadoutPanel = nil
GM.NewLoadout = {}
GM.NewLoadoutDirty = false

function GM:GetLoadoutSlot(i, new)
    if not i then return nil end
    local tbl = LocalPlayer().Loadout
    if new then tbl = GAMEMODE.NewLoadout end
    if tbl and tbl[i] then
        return tbl[i]
    end
end

function GM:CreateLoadoutPanel()
    if IsValid(GAMEMODE.LoadoutPanel) then
        GAMEMODE.LoadoutPanel:Remove()
    end
    GAMEMODE.NewLoadout = {}
    GAMEMODE.NewLoadoutDirty = false
    for k, v in pairs(LocalPlayer().Loadout) do
        GAMEMODE.NewLoadout[k] = table.Copy(v)
    end
    GAMEMODE.LoadoutPanel = vgui.Create("LoadoutPanel")
end
concommand.Add("loadoutpanel", GM.CreateLoadoutPanel)

net.Receive("loadout_open", function()
    if IsValid(GAMEMODE.LoadoutPanel) then
        GAMEMODE.LoadoutPanel:Remove()
        GAMEMODE.LoadoutPanel = nil
    else
        if ArcCW and ArcCW.InvHUD then
            ArcCW.Inv_Hidden = true
        end
        GAMEMODE:CreateLoadoutPanel()
    end
end)

function GM:SendLoadout()
    LocalPlayer().Loadout = {}
    net.Start("loadout_update")

        net.WriteUInt(table.Count(GAMEMODE.LoadoutSlots), 8)

        for k, v in pairs(GAMEMODE.LoadoutSlots) do

            local slot = GAMEMODE.NewLoadout[k]
            local entry = slot and GAMEMODE.LoadoutEntries[slot[1] or ""]

            net.WriteString(k)

            local entryid = entry and entry.ID or 0
            net.WriteUInt(entryid, GAMEMODE:GetEntryBits())
            if entryid == 0 then
                LocalPlayer().Loadout[k] = nil
            else
                LocalPlayer().Loadout[k] = {slot[1], table.Copy(slot[2])}
                if entry.attachments then
                    for i = 1, #entry.attachments do
                        local id = 0
                        if slot[2] and slot[2][i] ~= nil then
                            id = GAMEMODE.EntryAttachments[slot[2][i]].ID or id
                        end
                        net.WriteUInt(id, GAMEMODE:GetAttBits())
                    end
                end
            end
        end
    net.SendToServer()
    GAMEMODE.NewLoadoutDirty = false
end