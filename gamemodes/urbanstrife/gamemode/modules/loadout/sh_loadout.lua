-- TODO check if defaults should be loaded
-- TOOO load by files

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

GM:AddLoadoutEntry("arccw_ud_glock", {
    type = LDENTRY_TYPE_SWEP,
    wepcat = LDENTRY_WEPCAT_PISTOL,
    category = "Urban Coalition",
    class = "arccw_ud_glock",
    icon = Material("arccw/weaponicons/arccw_ud_glock"),

    cost_point = 2,
    cost_cash = 400,

    atttype = ATTTYPE_ARCCW,
    attachments = {
        GM.CommonAttSlots.acw_optic,
        {
            name = "Slide",
            slot = "ud_glock_slide",
        },
        {
            name = "Frame",
            slot = "ud_glock_frame",
        },
        {
            name = "Caliber",
            slot = "ud_glock_caliber",
        },
        GM.CommonAttSlots.acw_muzzle,
        GM.CommonAttSlots.acw_fg_tac_pistol,
        {
            name = "Magazine",
            slot = "ud_glock_mag",
        },
        GM.CommonAttSlots.uc_ammo,
        GM.CommonAttSlots.uc_powder,
        GM.CommonAttSlots.uc_tp,
        GM.CommonAttSlots.uc_fg,
        {
            name = "Material",
            slot = "ud_glock_skin",
        },
    }
})

GM:AddLoadoutEntry("arccw_ud_m16", {
    type = LDENTRY_TYPE_SWEP,
    wepcat = LDENTRY_WEPCAT_RIFLE,
    category = "Urban Coalition",
    class = "arccw_ud_m16",
    icon = Material("arccw/weaponicons/arccw_ud_m16"),

    cost_point = 3,
    cost_cash = 2800,

    atttype = ATTTYPE_ARCCW,
    attachments = {
        GM.CommonAttSlots.acw_optic,
        {
            name = "Barrel",
            slot = "ud_m16_barrel",
        },
        GM.CommonAttSlots.acw_muzzle,
        {
            name = "Receiver",
            slot = "ud_m16_receiver",
        },
        GM.CommonAttSlots.acw_ub,
        GM.CommonAttSlots.acw_tac,
        {
            name = "Grip",
            slot = "ud_m16_grip",
        },
        {
            name = "Stock",
            slot = "ud_m16_stock",
        },
        {
            name = "Magazine",
            slot = "ud_m16_mag",
        },
        GM.CommonAttSlots.uc_ammo,
        GM.CommonAttSlots.uc_powder,
        GM.CommonAttSlots.uc_tp,
        GM.CommonAttSlots.uc_fg,
    },
})

GM:AddLoadoutEntry("arccw_ud_mini14", {
    type = LDENTRY_TYPE_SWEP,
    wepcat = LDENTRY_WEPCAT_RIFLE,
    category = "Urban Coalition",
    class = "arccw_ud_mini14",
    icon = Material("arccw/weaponicons/arccw_ud_mini14"),

    cost_point = 2,
    cost_cash = 1900,
})

GM:AddLoadoutEntry("arccw_ud_870", {
    type = LDENTRY_TYPE_SWEP,
    wepcat = LDENTRY_WEPCAT_HEAVY,
    category = "Urban Coalition",
    class = "arccw_ud_870",
    icon = Material("arccw/weaponicons/arccw_ud_870"),

    cost_point = 2,
    cost_cash = 2400,
})

GM:AddLoadoutEntry("arccw_ud_m1014", {
    type = LDENTRY_TYPE_SWEP,
    wepcat = LDENTRY_WEPCAT_HEAVY,
    category = "Urban Coalition",
    class = "arccw_ud_m1014",
    icon = Material("arccw/weaponicons/arccw_ud_m1014"),

    cost_point = 4,
    cost_cash = 3500,
})

GM:AddLoadoutEntry("arccw_ud_m79", {
    type = LDENTRY_TYPE_SWEP,
    wepcat = LDENTRY_WEPCAT_UTILITY,
    category = "Urban Coalition",
    class = "arccw_ud_m79",
    icon = Material("arccw/weaponicons/arccw_ud_m79"),

    cost_point = 4,
    cost_cash = 7000,
    unique = true,

    atttype = ATTTYPE_ARCCW,
    attachments = {
        GM.CommonAttSlots.acw_optic,
        {
            name = "Tube",
            slot = "ud_m79_barrel",
        },
        GM.CommonAttSlots.acw_ub,
        GM.CommonAttSlots.acw_tac,
        {
            name = "Stock",
            slot = "ud_m79_stock",
        },
        {
            name = "Grenade Type",
            slot = "uc_40mm",
        },
        GM.CommonAttSlots.uc_tp,
        GM.CommonAttSlots.uc_fg,
    },
})