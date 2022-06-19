ECOSYSTEM = {}

ECOSYSTEM.Name = "Urban Coalition - USP"

ECOSYSTEM.LoadoutEntries = {
    ["arccw_uc_usp"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_PISTOL,
        class = "arccw_uc_usp",
        icon = Material("arccw/weaponicons/arccw_uc_usp"),

        cost_point = 2,
        cost_cash = 400,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
            {
                name = "Slide",
                slot = "uc_usp_slide",
            },
            {
                name = "Caliber",
                slot = "uc_usp_caliber",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle,
            GAMEMODE.CommonAttSlots.acw_fg_tac_pistol,
            {
                name = "Magazine",
                slot = "uc_usp_mag",
            },
            GAMEMODE.CommonAttSlots.uc_stock,
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
            {
                name = "Finish",
                slot = "uc_usp_skin",
            },
        }
    },
}

ECOSYSTEM.AttachmentType = ATTTYPE_ARCCW
ECOSYSTEM.PartialAttachments = {
    ["uc_usp_slide_cs"] = {
        cost_point = 0,
    },
    ["uc_usp_slide_compact"] = {
        cost_point = 1,
        cost_cash = 200,
    },
    ["uc_usp_slide_ext"] = {
        cost_point = 1,
        cost_cash = 300,
    },
    ["uc_usp_slide_match"] = {
        cost_point = 1,
        cost_cash = 400,
    },
    ["uc_usp_cal_9mm"] = {
        cost_point = 0,
    },
    ["uc_usp_cal_40sw"] = {
        cost_point = 0,
    },
    ["uc_usp_mag_ext"] = {
        cost_point = 1,
        cost_cash = 200,
    },
    ["uc_usp_skin_nickel"] = {
        cost_point = 0,
    },
    ["uc_usp_skin_blued"] = {
        cost_point = 0,
    },
}

function ECOSYSTEM:Check()
    return ArcCW ~= nil and ArcCW.UC ~= nil and (weapons.Get("arccw_uc_usp") ~= nil)
end

function ECOSYSTEM:OnLoad()
end