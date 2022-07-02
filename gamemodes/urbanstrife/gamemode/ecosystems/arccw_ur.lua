ECOSYSTEM = {}

ECOSYSTEM.Name = "Urban Renewal"

ECOSYSTEM.LoadoutEntries = {
    ["arccw_ur_pm"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_PISTOL,
        class = "arccw_ur_pm",
        icon = Material("arccw/weaponicons/arccw_ur_pm"),

        cost_point = 0,
        cost_cash = 0,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic_lp,
            {
                name = "Variant",
                slot = "ur_pm_variant",
            },
            GAMEMODE.CommonAttSlots.uc_muzzle_pistol,
            GAMEMODE.CommonAttSlots.acw_tac_pistol,
            GAMEMODE.CommonAttSlots.uc_stock,
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        }
    },
    ["arccw_ur_m1911"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_PISTOL,
        class = "arccw_ur_m1911",
        icon = Material("arccw/weaponicons/arccw_ur_m1911"),

        cost_point = 2,
        cost_cash = 0,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic_lp,
            {
                name = "Slide",
                slot = "ur_m1911_slide",
            },
            {
                name = "Caliber",
                slot = "ur_m1911_caliber",
            },
            GAMEMODE.CommonAttSlots.uc_muzzle_pistol,
            GAMEMODE.CommonAttSlots.acw_tac_pistol,
            {
                name = "Magazine",
                slot = "ur_m1911_mag",
            },
            GAMEMODE.CommonAttSlots.uc_stock,
            {
                name = "Grip",
                slot = "ur_m1911_grip",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
            {
                name = "Finish",
                slot = "ur_m1911_skin",
            },
        }
    },
    ["arccw_ur_deagle"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_PISTOL,
        class = "arccw_ur_deagle",
        icon = Material("arccw/weaponicons/arccw_ur_deagle"),

        cost_point = 5,
        cost_cash = 0,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic_lp", "ur_deagle_tritium", "optic"},
            },
            {
                name = "Barrel",
                slot = "ur_deagle_barrel",
            },
            {
                name = "Caliber",
                slot = "ur_deagle_caliber",
            },
            GAMEMODE.CommonAttSlots.uc_muzzle_pistol,
            GAMEMODE.CommonAttSlots.acw_tac_pistol,
            {
                name = "Magazine",
                slot = "ur_deagle_mag",
            },
            GAMEMODE.CommonAttSlots.uc_stock,
            {
                name = "Grip",
                slot = "ur_deagle_grip",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
            {
                name = "Finish",
                slot = "ur_deagle_skin",
            },
        }
    },
    ["arccw_ur_ak"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ur_ak",
        icon = Material("arccw/weaponicons/arccw_ur_ak"),
        hiddenunlessfree = true,

        cost_point = 5,
        cost_cash = 0,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic", "optic_sniper", "ur_ak_optic"},
            },
            {
                name = "Barrel",
                slot = "ur_ak_barrel",
            },
            {
                name = "Muzzle",
                slot = {"muzzle", "uc_muzzle_pbs1", "uc_muzzle_rifle"},
            },
            {
                name = "Receiver",
                slot = "ur_ak_cal",
            },
            {
                name = "Magazine",
                slot = "ur_ak_mag",
            },
            {
                name = "Underbarrel",
                slot = {"foregrip", "ubgl", "ur_ak_ub"},
            },
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Grip",
                slot = "ur_ak_grip",
            },
            {
                name = "Stock",
                slot = "ur_ak_stock",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        }
    },
    ["arccw_ur_mp5"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ur_mp5",
        icon = Material("arccw/weaponicons/arccw_ur_mp5"),

        cost_point = 3,
        cost_cash = 0,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic", "optic_lp"},
            },
            {
                name = "Barrel",
                slot = "ur_mp5_barrel",
            },
            {
                name = "Receiver",
                slot = "ur_mp5_caliber",
            },
            GAMEMODE.CommonAttSlots.uc_muzzle_pistol,
            {
                name = "Underbarrel",
                slot = {"foregrip", "ur_mp5_hg"},
            },
            GAMEMODE.CommonAttSlots.acw_tac_pistol,
            {
                name = "Stock",
                slot = "ur_mp5_stock",
            },
            {
                name = "Magazine",
                slot = "ur_mp5_mag",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        }
    },

    ["arccw_ur_akm"] = {
        name = "AKM",
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ur_ak",
        icon = Material("arccw/weaponicons/arccw_ur_ak"),
        hiddenwhenfree = true,

        cost_point = 3,
        cost_cash = 0,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic", "optic_sniper", "ur_ak_optic"},
            },
            false,
            {
                name = "Muzzle",
                slot = {"muzzle", "uc_muzzle_pbs1", "uc_muzzle_rifle"},
            },
            false,
            false,
            {
                name = "Underbarrel",
                slot = {"foregrip", "ubgl", "ur_ak_ub"},
            },
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Grip",
                slot = "ur_ak_grip",
            },
            {
                name = "Stock",
                slot = "ur_ak_stock",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        }
    },
}

ECOSYSTEM.AttachmentType = ATTTYPE_ARCCW
ECOSYSTEM.PartialAttachments = {
}

function ECOSYSTEM:Check()
    return ArcCW ~= nil and ArcCW.UC ~= nil and (weapons.Get("arccw_ur_m1911") ~= nil)
end

function ECOSYSTEM:OnLoad()
end