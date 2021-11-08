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
    cost_cash = 2500,

    callback = function(self, ply)
        ply:SetNWInt("ArmorLevel", 2)
    end,
    revoke = function(self, ply)
        ply:SetNWInt("ArmorLevel", 0)
    end,
})