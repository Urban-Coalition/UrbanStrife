--[[
    LoadoutSlot
        string name,
        int filter,

        (optional)
        int sortorder,
        table whitelist {a = true, b = true}
        table wepcats {a = true, b = true}
        function filter(string shortname, table entry)
]]

GM.LoadoutSlots = {
    ["strife_primary"] = {
        name = "Primary",
        sortorder = 1,
        wepcats = {
            [LDENTRY_WEPCAT_SMG] = true,
            [LDENTRY_WEPCAT_RIFLE] = true,
            [LDENTRY_WEPCAT_HEAVY] = true
        },
    },
    ["strife_secondary"] = {
        name = "Secondary",
        sortorder = 2,
        wepcats = {[LDENTRY_WEPCAT_PISTOL] = true},
    },
    ["strife_melee"] = {
        name = "Melee",
        sortorder = 3,
        wepcats = {[LDENTRY_WEPCAT_MELEE] = true},
    },
    ["strife_utility1"] = {
        name = "Utility 1",
        sortorder = 4,
        wepcats = {[LDENTRY_WEPCAT_UTILITY] = true},
    },
    ["strife_utility2"] = {
        name = "Utility 2",
        sortorder = 5,
        wepcats = {[LDENTRY_WEPCAT_UTILITY] = true},
    },
    ["strife_armor"] = {
        name = "Armor",
        sortorder = 10,
        whitelist = {armor_light = true, armor_heavy = true},
    },
}

function GM:EntryFitsSlot(slot, entry)
    if slot.whitelist and not slot.whitelist[entry.shortname] then return false end
    if slot.wepcats and (entry.wepcat == nil or not slot.wepcats[entry.wepcat]) then return false end
    if slot.filter and not slot:filter(entry.shortname, entry) then return false end
    return true
end

function GM:GetEntriesForSlot(slot)
    local slotinfo = self.LoadoutSlots[slot]
    local entries = {}
    for k, v in pairs(self.LoadoutEntries) do
        if not self:EntryFitsSlot(slotinfo, v) then continue end
        table.insert(entries, k)
    end
    return entries
end

function GM:GetSortedEntriesForSlot(slot)
    local entries = self:GetEntriesForSlot(slot)
    table.sort(entries, function(a, b)
        local a_e = self.LoadoutEntries[a]
        local b_e = self.LoadoutEntries[b]
        if a_e.cost_point ~= b_e.cost_point then
            return a_e.cost_point < b_e.cost_point
        end
        local a_name = string.lower(self:GetEntryName(a))
        local b_name = string.lower(self:GetEntryName(b))
        for i = 1, math.min(#a_name, #b_name) do
            if a_name[i] ~= b_name[i] then
                return string.byte(a_name, i) < string.byte(b_name, i)
            end
        end
        return a_e.ID < b_e.ID
    end)
    return entries
end