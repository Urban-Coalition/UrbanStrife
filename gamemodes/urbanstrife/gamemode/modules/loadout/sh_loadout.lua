function GM:GetSlotCost(slot)
    local name = istable(slot) and slot[1]
    if not name then return 0, 0 end
    local entry = GAMEMODE.LoadoutEntries[name]
    if not entry then print("invalid entry " .. tostring(entry)) return math.huge, math.huge end
    local costp, costc = entry.cost_point or 1, entry.cost_cash or 500
    local atts = slot[2]
    if not entry.attachments or not atts or atts == {} then return costp, costc end
    for k, v in pairs(entry.attachments) do
        if not v then continue end
        local default = v.default
        if default and (not atts[k] or atts[k] == default) then
            -- either we're using default (no cost), or removed default (add removal cost)
            if not atts[k] then
                costp = costp + (v.removecost_point or 0)
                costc = costc + (v.removecost_cash or 0)
            end
        elseif atts[k] then
            costp = costp + (GAMEMODE.EntryAttachments[atts[k]].cost_point or 1)
            costc = costc + (GAMEMODE.EntryAttachments[atts[k]].cost_cash or 100)
        end
    end
    return costp, costc
end

function GM:GetLoadoutCost(tbl)
    if not tbl then return 0, 0 end
    local costp, costc = 0, 0
    for k, v in pairs(tbl) do
        local p, c = self:GetSlotCost(v)
        costp = costp + p
        costc = costc + c
    end
    return costp, costc
end

GM:AddLoadoutEntry("armor_light", {
    type = LDENTRY_TYPE_LUA,
    name = "Light Armor",

    cost_point = 1,
    cost_cash = 1000,

    callback = function(self, ply)
        ply:SetNWInt("ArmorLevel", 1)
    end,
    revoke = function(self, ply)
        ply:SetNWInt("ArmorLevel", 0)
    end,
})

GM:AddLoadoutEntry("armor_heavy", {
    type = LDENTRY_TYPE_LUA,
    name = "Heavy Armor",

    cost_point = 3,
    cost_cash = 1000,

    callback = function(self, ply)
        ply:SetNWInt("ArmorLevel", 2)
    end,
    revoke = function(self, ply)
        ply:SetNWInt("ArmorLevel", 0)
    end,
})

GM:AddLoadoutEntry("ammo_light", {
    type = LDENTRY_TYPE_LUA,
    name = "Light Carrier",

    cost_point = 1,
    cost_cash = 500,

    callback = function(self, ply)
        ply:SetNWInt("AmmoLevel", 1)
    end,
    revoke = function(self, ply)
        ply:SetNWInt("AmmoLevel", 0)
    end,
})

GM:AddLoadoutEntry("ammo_heavy", {
    type = LDENTRY_TYPE_LUA,
    name = "Heavy Carrier",

    cost_point = 3,
    cost_cash = 1000,

    callback = function(self, ply)
        ply:SetNWInt("AmmoLevel", 2)
    end,
    revoke = function(self, ply)
        ply:SetNWInt("AmmoLevel", 0)
    end,
})