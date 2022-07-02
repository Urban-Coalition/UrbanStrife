ECOSYSTEM = {}

ECOSYSTEM.Name = "Urban Coalition"

ECOSYSTEM.AttachmentType = ATTTYPE_ARCCW
ECOSYSTEM.PartialAttachments = {

    ["uc_muzzle_supressor_870"] = {
        cost_point = 3,
        slot = "uc_muzzle_shotgun",
    },
    ["uc_muzzle_supressor_salvo"] = {
        cost_point = 3,
        slot = "uc_muzzle_shotgun",
    },
    ["uc_choke_wide"] = {
        slot = "uc_muzzle_shotgun",
    },
    ["uc_choke_cyl"] = {
        slot = "uc_muzzle_shotgun",
    },
    ["uc_choke_rifled"] = {
        slot = "uc_muzzle_shotgun",
    },

    ["uc_fg_slamfire"] = {
        slot = "uc_fg_shotgun",
    },
    ["uc_fg_sg_rifled"] = {
        slot = "uc_fg_shotgun",
    },

    ["uc_fg_autotrigger"] = {
        slot = "uc_fg"
    },
    ["uc_fg_civvy"] = {
        slot = "uc_fg"
    },
    ["uc_fg_deeprifling"] = {
        slot = "uc_fg"
    },
    ["uc_fg_dualstage"] = {
        slot = "uc_fg"
    },
    ["uc_fg_longrifling"] = {
        slot = "uc_fg"
    },
    ["uc_fg_preciserifling"] = {
        slot = "uc_fg"
    },

    ["uc_fg_heavy"] = {
        slot = {"uc_fg", "uc_fg_shotgun"},
    },
    ["uc_fg_light"] = {
        slot = {"uc_fg", "uc_fg_shotgun"},
    },
    ["uc_fg_lightweight"] = {
        slot = {"uc_fg", "uc_fg_shotgun"},
    },
    ["uc_fg_match"] = {
        slot = {"uc_fg", "uc_fg_shotgun"},
    },
    ["uc_fg_underwater"] = {
        slot = {"uc_fg", "uc_fg_shotgun"},
    },

    ["uc_muzzle_fhider1"] = {
        cost_point = 1,
        slot = "muzzle",
    },
    ["uc_muzzle_brake1"] = {
        cost_point = 3,
        slot = "muzzle",
    },
    ["uc_muzzle_brake2"] = {
        cost_point = 3,
        slot = "muzzle",
    },
    ["uc_muzzle_compensator"] = {
        cost_point = 3,
        slot = "muzzle",
    },

    ["uc_muzzle_supressor_longass"] = {
        cost_point = 3,
        slot = "muzzle",
    },
    ["uc_muzzle_supressor_masada"] = {
        cost_point = 3,
        slot = "muzzle",
    },
    ["uc_muzzle_supressor_ga9"] = {
        cost_point = 2,
        slot = "uc_muzzle_pistol",
    },
    ["uc_muzzle_supressor_ssq"] = {
        cost_point = 2,
        slot = "uc_muzzle_pistol",
    },
    ["uc_muzzle_supressor_light"] = {
        cost_point = 3,
        slot = "uc_muzzle_rifle",
    },
    ["uc_muzzle_supressor_tac"] = {
        cost_point = 3,
        slot = "uc_muzzle_rifle",
    },
    ["uc_muzzle_supressor_pbs1"] = {
        cost_point = 3,
        slot = "uc_muzzle_pbs1",
    },
    ["uc_muzzle_supressor_pbs4"] = {
        cost_point = 3,
        slot = "uc_muzzle_pbs4",
    },
    ["uc_muzzle_supressor_tgpa"] = {
        cost_point = 3,
        slot = "uc_muzzle_tgpa",
    },
}

function ECOSYSTEM:Check()
    return ArcCW ~= nil and ArcCW.UC ~= nil
end

function ECOSYSTEM:OnLoad()
end