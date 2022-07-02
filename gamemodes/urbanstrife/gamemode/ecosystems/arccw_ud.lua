ECOSYSTEM = {}

ECOSYSTEM.Name = "Urban Decay"

ECOSYSTEM.LoadoutEntries = {
    ["arccw_ud_glock"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_PISTOL,
        class = "arccw_ud_glock",
        icon = Material("arccw/weaponicons/arccw_ud_glock"),

        cost_point = 3,
        cost_cash = 400,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
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
            GAMEMODE.CommonAttSlots.acw_muzzle,
            GAMEMODE.CommonAttSlots.acw_fg_tac_pistol,
            GAMEMODE.CommonAttSlots.uc_stock,
            {
                name = "Magazine",
                slot = "ud_glock_mag",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
            {
                name = "Material",
                slot = "ud_glock_skin",
            },
        }
    },
    ["arccw_ud_m16"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ud_m16",
        icon = Material("arccw/weaponicons/arccw_ud_m16"),
        hiddenunlessfree = true,

        cost_point = 5,
        cost_cash = 2800,

        atttype = ATTTYPE_ARCCW,
    },
    ["arccw_ud_mini14"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ud_mini14",
        icon = Material("arccw/weaponicons/arccw_ud_mini14"),

        cost_point = 1,
        cost_cash = 1900,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
            {
                name = "Barrel",
                slot = "ud_mini14_barrel",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle,
            {
                name = "Receiver",
                slot = "ud_mini14_receiver",
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Magazine",
                slot = "ud_mini14_mag",
            },
            {
                name = "Stock",
                slot = "ud_m16_stock",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        },
    },
    ["arccw_ud_870"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_HEAVY,
        class = "arccw_ud_870",
        icon = Material("arccw/weaponicons/arccw_ud_870"),

        cost_point = 2,
        cost_cash = 2400,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
            {
                name = "Barrel",
                slot = "ud_870_barrel",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle_sg,
            {
                name = "Forend",
                slot = "ud_870_slide",
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Stock",
                slot = "ud_870_stock",
            },
            {
                name = "Tube",
                slot = "ud_870_tube",
            },
            {
                name = "Ammo",
                slot = "ud_ammo_shotgun",
            },
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg_shotgun,
        },
    },
    ["arccw_ud_m1014"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_HEAVY,
        class = "arccw_ud_m1014",
        icon = Material("arccw/weaponicons/arccw_ud_m1014"),

        cost_point = 5,
        cost_cash = 2400,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
            {
                name = "Barrel",
                slot = "ud_870_barrel",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle_sg,
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Stock",
                slot = "ud_1014_stock",
            },
            {
                name = "Tube",
                slot = "ud_1014_tube",
            },
            {
                name = "Ammo",
                slot = "ud_ammo_shotgun",
            },
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg_shotgun,
        },
    },
    ["arccw_ud_m79"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_UTILITY,
        class = "arccw_ud_m79",
        icon = Material("arccw/weaponicons/arccw_ud_m79"),

        cost_point = 5,
        cost_cash = 7000,
        unique = true,
        nodefaultclip = true,
        ammotype = "smg1_grenade",
        ammocount = 2,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
            {
                name = "Tube",
                slot = "ud_m79_barrel",
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Stock",
                slot = "ud_m79_stock",
            },
            {
                name = "Grenade",
                slot = "uc_40mm",
            },
            GAMEMODE.CommonAttSlots.uc_tp,
            false,
        },
    },
    ["arccw_ud_uzi"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_SMG,
        class = "arccw_ud_uzi",
        icon = Material("arccw/weaponicons/arccw_ud_uzi"),

        cost_point = 2,
        cost_cash = 2600,
        unique = true,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            GAMEMODE.CommonAttSlots.acw_optic,
            {
                name = "Barrel",
                slot = "ud_uzi_frame",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle,
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Stock",
                slot = "ud_uzi_stock",
            },
            {
                name = "Magazine",
                slot = "ud_uzi_mag",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        },
    },

    ["arccw_ud_m4a1"] = {
        wepcat = LDENTRY_WEPCAT_RIFLE,
        name = "M4A1",
        class = "arccw_ud_m16",
        icon = Material("urbanstrife/icons/arccw_ud_m4a1.png", "mips smooth"),
        hiddenwhenfree = true,

        cost_point = 5,
        cost_cash = 2800,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic", "ud_m16_rs"},
                default = "ud_m16_rs",
                removename = "Carry Handle",
            },
            {
                name = "Barrel",
                slot = "ud_m16_blen",
                default = "ud_m16_barrel_14in",
                removename = "20\" Standard Barrel",
            },
            {
                name = "Handguard",
                slot = "ud_m16_hg",
                default = "ud_m16_hg_tactical",
                removename = "Ribbed Handguard",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle,
            {
                name = "Upper Receiver",
                slot = "ud_m16_receiver",
            },
            {
                name = "Receiver",
                slot = "ud_m16_fcg",
                default = "ud_m16_receiver_auto",
                removename = "Burst Receiver",
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
            {
                name = "Grip",
                slot = "ud_m16_grip",
            },
            {
                name = "Stock",
                slot = "ud_m16_stock",
                default = "ud_m16_stock_carbine",
                removename = "Full Stock",
            },
            {
                name = "Magazine",
                slot = "ud_m16_mag",
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        },
    },
    ["arccw_ud_ar15"] = {
        name = "AR-15",
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ud_m16",
        icon = Material("arccw/weaponicons/arccw_ud_m16"),
        hiddenwhenfree = true,

        cost_point = 2,
        cost_cash = 2800,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic", "ud_m16_rs"},
                default = "ud_m16_rs_ch",
            },
            {
                name = "Barrel",
                slot = "ud_m16_barrel",
            },
            GAMEMODE.CommonAttSlots.acw_muzzle,
            {
                name = "Upper Receiver",
                slot = "ud_m16_receiver",
                fixed = true
            },
            {
                name = "Lower Receiver",
                slot = "ud_m16_fcg",
                default = "ud_m16_receiver_semi",
                fixed = true
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
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
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        },
    },
    ["arccw_ud_m16a1"] = {
        name = "M16A1",
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ud_m16",
        icon = Material("urbanstrife/icons/arccw_ud_m16a1.png", "mips smooth"),
        hiddenwhenfree = true,

        cost_point = 3,
        cost_cash = 2800,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            false,
            false,
            {
                name = "Handguard",
                slot = "ud_m16_hg",
                default = "ud_m16_hg_a1",
                fixed = true,
            },
            GAMEMODE.CommonAttSlots.acw_muzzle,
            {
                name = "Upper Receiver",
                slot = "ud_m16_receiver_a1",
                default = "ud_m16_receiver_a1",
                fixed = true,
            },
            {
                name = "Lower Receiver",
                slot = "ud_m16_fcg_auto",
                default = "ud_m16_receiver_auto",
                fixed = true,
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
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
                slot = "ud_m16_mag_a1",
                default = "ud_m16_mag_20",
                fixed = true,
            },
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        },
    },
    ["arccw_ud_m16a4"] = {
        name = "M16A4",
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_RIFLE,
        class = "arccw_ud_m16",
        icon = Material("arccw/weaponicons/arccw_ud_m16"),
        hiddeniffree = true,

        cost_point = 2,
        cost_cash = 2800,

        atttype = ATTTYPE_ARCCW,
        attachments = {
            {
                name = "Optic",
                slot = {"optic", "ud_m16_rs"},
                default = "ud_m16_rs_ch",
            },
            false, -- ud_m16_blen
            false, -- ud_m16_hg
            GAMEMODE.CommonAttSlots.acw_muzzle,
            false, -- ud_m16_receiver
            {
                name = "Lower Receiver", -- ud_m16_fcg
                slot = "ud_m16_fcg_a2",
            },
            GAMEMODE.CommonAttSlots.acw_ub,
            GAMEMODE.CommonAttSlots.acw_tac,
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
            GAMEMODE.CommonAttSlots.uc_ammo,
            GAMEMODE.CommonAttSlots.uc_powder,
            GAMEMODE.CommonAttSlots.uc_tp,
            GAMEMODE.CommonAttSlots.uc_fg,
        },
    },
}

ECOSYSTEM.AttachmentType = ATTTYPE_ARCCW
ECOSYSTEM.PartialAttachments = {

    ---------------------------------------------
    -- Glock 17
    ---------------------------------------------
    ["ud_glock_slide_auto"] = {
        cost_point = 2,
        cost_cash = 1500,
    },
    ["ud_glock_slide_cs"] = {
        cost_point = 2,
        cost_cash = 1000,
    },
    ["ud_glock_slide_sd"] = {
        cost_point = 2,
        cost_cash = 1000,
    },
    ["ud_glock_slide_carbine"] = {
        cost_point = 1,
        cost_cash = 500,
    },
    ["ud_glock_slide_lb"] = {
        cost_point = 0,
    },
    ["ud_glock_slide_nytesyte"] = {
        cost_point = 1,
        cost_cash = 500,
    },
    ["ud_glock_slide_comp"] = {
        cost_point = 1,
        cost_cash = 500,
    },
    ["ud_glock_slide_subcompact"] = {
        cost_point = 0,
    },
    ["ud_glock_frame_flared"] = {
        cost_point = 0,
    },
    ["ud_glock_frame_subcompact"] = {
        cost_point = 0,
    },
    ["ud_glock_mag_10"] = {
        cost_point = 0,
    },
    ["ud_glock_mag_33"] = {
        cost_point = 1,
        cost_cash = 1200,
    },
    ["ud_glock_mag_100"] = {
        cost_point = 2,
        cost_cash = 2000,
    },
    ["ud_glock_caliber_10auto"] = {
        cost_point = 0,
    },
    ["ud_glock_caliber_22lr"] = {
        cost_point = 0,
    },
    ["ud_glock_caliber_40sw"] = {
        cost_point = 0,
    },
    ["ud_glock_caliber_45acp"] = {
        cost_point = 0,
    },
    ["ud_glock_caliber_357sig"] = {
        cost_point = 0,
    },
    ["ud_glock_caliber_380acp"] = {
        cost_point = 0,
    },

    ---------------------------------------------
    -- M16A2
    ---------------------------------------------
    ["ud_m16_grip_ergo"] = {
        cost_point = 0,
    },
    ["ud_m16_grip_skel"] = {
        cost_point = 0,
    },
    ["ud_m16_grip_wood"] = {
        cost_point = 0,
    },
    ["ud_m16_mag_20"] = {
        cost_point = 0,
        slot = {"ud_m16_mag", "ud_m16_mag_a1"},
    },
    ["ud_m16_mag_40"] = {
        cost_point = 1,
        cost_cash = 800,
    },
    ["ud_m16_mag_60"] = {
        cost_point = 2,
        cost_cash = 1500,
    },
    ["ud_m16_mag_100"] = {
        cost_point = 3,
        cost_cash = 2000,
    },
    ["ud_m16_receiver_9mm"] = {
        cost_point = 0,
    },
    ["ud_m16_receiver_50beo"] = {
        cost_point = 1,
        cost_cash = 800,
    },
    ["ud_m16_receiver_auto"] = {
        cost_point = 2,
        cost_cash = 1200,
        slot = {"ud_m16_fcg", "ud_m16_fcg_auto"},
    },
    ["ud_m16_receiver_a1"] = {
        cost_point = 1,
        cost_cash = 1200,
        slot = {"ud_m16_receiver", "ud_m16_receiver_a1"},
    },
    ["ud_m16_receiver_semi"] = {
        cost_point = 0,
        slot = {"ud_m16_fcg", "ud_m16_fcg_a2"},
    },
    ["ud_m16_receiver_cali"] = {
        cost_point = 0,
        slot = {"ud_m16_fcg", "ud_m16_fcg_a2"},
    },
    ["ud_m16_receiver_altburst"] = {
        cost_point = 0,
        slot = {"ud_m16_fcg", "ud_m16_fcg_a2"},
    },

    ---------------------------------------------
    -- Uzi
    ---------------------------------------------
    ["ud_uzi_mag_20"] = {
        cost_point = 0,
    },
    ["ud_uzi_mag_40"] = {
        cost_point = 1,
        cost_cash = 500,
    },
    ["ud_uzi_mag_100"] = {
        cost_point = 3,
        cost_cash = 500,
    },
    ["ud_uzi_body_civvy"] = {
        cost_point = 0,
    },

    ---------------------------------------------
    -- Mini-14
    ---------------------------------------------
    ["ud_mini14_receiver_22lr"] = {
        cost_point = 0,
    },
    ["ud_mini14_receiver_auto"] = {
        cost_point = 3,
    },
    ["ud_mini14_receiver_762"] = {
        cost_point = 2,
    },
    ["ud_mini14_mag_10"] = {
        cost_point = 0,
    },
    ["ud_mini14_mag_10_762"] = {
        cost_point = 0,
    },
    ["ud_mini14_mag_30"] = {
        cost_point = 1,
    },
    ["ud_mini14_mag_30_762"] = {
        cost_point = 1,
    },
    ["ud_mini14_mag_42"] = {
        cost_point = 2,
    },
    ["ud_mini14_mag_60"] = {
        cost_point = 3,
    },
}

function ECOSYSTEM:Check()
    return ArcCW ~= nil and ArcCW.UC ~= nil and (weapons.Get("arccw_ud_glock") ~= nil)
end

function ECOSYSTEM:OnLoad()
end