ATTTYPE_NONE = 0
ATTTYPE_ARCCW = 1
ATTTYPE_TACRP = 2

GM.CommonAttSlots = {
    -- ArcCW
    ["acw_optic"] = {
        name = "Optic",
        slot = {"optic"},
    },
    ["acw_muzzle"] = {
        name = "Muzzle",
        slot = {"muzzle"},
    },
    ["acw_muzzle_sg"] = {
        name = "Muzzle",
        slot = {"choke", "muzzle_shotgun"},
    },
    ["acw_ub"] = {
        name = "Underbarrel",
        slot = {"foregrip", "ubgl"},
    },
    ["acw_tac"] = {
        name = "Tactical",
        slot = {"tac"},
    },
    ["acw_tac_pistol"] = {
        name = "Tactical",
        slot = {"tac_pistol"},
    },
    ["acw_fg_tac_pistol"] = {
        name = "Underbarrel",
        slot = {"foregrip", "tac_pistol"},
    },

    -- ArcCW Urban Coalition
    ["uc_ammo"] = {
        name = "Ammo Type",
        slot = "uc_ammo",
    },
    ["uc_powder"] = {
        name = "Powder Load",
        slot = "uc_powder",
    },
    ["uc_tp"] = {
        name = "Training Package",
        slot = "uc_tp",
    },
    ["uc_fg"] = {
        name = "Internals",
        slot = "uc_fg",
    },
    ["uc_stock"] = {
        name = "Stock",
        slot = "uc_stock",
    },
}

GM.EntryAttachments = GM.EntryAttachments or {}
GM.EntryIDToAtt = GM.EntryIDToAtt or {}
GM.EntryAttachmentNum = GM.EntryAttachmentNum or 0
GM.PartialAttachments = {}

GM.EntryAttBit = nil
function GM:GetAttBits()
    if not self.EntryAttBit then
        self.EntryAttBit = math.min(math.ceil(math.log(self.EntryAttachmentNum + 1, 2)), 32)
    end
    return self.EntryAttBit
end

function GM:AddEntryAtt(t, class, slot, cost_point, cost_cash, args)
    local id
    if not GAMEMODE.EntryAttachments[class] then
        GAMEMODE.EntryAttachmentNum = GAMEMODE.EntryAttachmentNum + 1
        id = GAMEMODE.EntryAttachmentNum
    else
        return
        --id = GAMEMODE.EntryAttachments[class].ID
    end

    GAMEMODE.EntryAttachments[class] = {
        atttyp = t,
        shortname = class,
        ID = id,
        atttype = t,
        cost_point = cost_point or 1,
        cost_cash = cost_cash or 250,
        slot = isstring(slot) and {slot} or slot,
    }
    GAMEMODE.EntryIDToAtt[id] = class
    if args then GAMEMODE.EntryAttachments[class] = table.Merge(GAMEMODE.EntryAttachments[class], args) end
    if GAMEMODE.PartialAttachments[class] then
        GAMEMODE.EntryAttachments[class] = table.Merge(GAMEMODE.EntryAttachments[class], GAMEMODE.PartialAttachments[class])
    end

    if t == ATTTYPE_ARCCW then
        GAMEMODE.EntryAttachments[class].baseID = ArcCW.AttachmentTable[class].ID
    elseif t == ATTTYPE_TACRP then
        GAMEMODE.EntryAttachments[class].baseID = -1 -- TODO
    end

    GAMEMODE.EntryAttBit = nil
end

function GM:GetAttName(class)
    local att = GAMEMODE.EntryAttachments[class]
    if not att then return class end

    if att.atttyp == ATTTYPE_ARCCW then
        return ArcCW.AttachmentTable[class].AbbrevName or ArcCW.AttachmentTable[class].PrintName
    elseif att.atttyp == ATTTYPE_TACRP then
        return class -- TODO
    end
    return class
end

function GM:GetAttsForEntry(slot)
    if isstring(slot) then slot = {slot} end

    local ret = {}

    for id, att in pairs(self.EntryAttachments) do
        local has = false
        for _, s in pairs(slot or {}) do
            if table.HasValue(att.slot, s) then has = true break end
        end
        if has then table.insert(ret, id) end
    end

    return ret
end

function GM:GetSortedAttsForEntry(slot)
    local atts = self:GetAttsForEntry(slot)
    table.sort(atts, function(a, b)
        local a_e = self.EntryAttachments[a]
        local b_e = self.EntryAttachments[b]
        if a_e.cost_point ~= b_e.cost_point then
            return a_e.cost_point < b_e.cost_point
        end
        if a_e.atttype == ATTTYPE_ARCCW and a_e.atttype == ATTTYPE_ARCCW then
            local aso = ArcCW.AttachmentTable[a].SortOrder or 0
            local bso = ArcCW.AttachmentTable[b].SortOrder or 0
            if aso ~= bso then return aso > bso end
        end
        return string.lower(self:GetAttName(a)) < string.lower(self:GetAttName(b))
    end)
    return atts
end

function GM:InitializeAtts()
    if ArcCW then
        for k, v in pairs(ArcCW.AttachmentTable) do
            if v.Ignore or v.Blacklisted or v.Charm or v.InvAtt then continue end
            self:AddEntryAtt(ATTTYPE_ARCCW, k, v.Slot, v.Free and 0 or v.US_Cost_Point, v.Free and 0 or v.US_Cost_Cash)
        end
    end
end