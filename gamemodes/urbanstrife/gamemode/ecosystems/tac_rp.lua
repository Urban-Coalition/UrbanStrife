ECOSYSTEM = {}

ECOSYSTEM.Name = "Tactical RP"

ECOSYSTEM.LoadoutEntries = {
    ["tacrp_medkit"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_UTILITY,
        class = "tacrp_medkit",
        icon = Material("entities/tacrp_medkit.png", "smooth mips"),
        icon_ratio = 1,
        icon_scale = 1.5,
        icon_rotation = 90,

        cost_point = 1,
        cost_cash = 500,

        atttype = ATTTYPE_TACRP,
    },
    ["tacrp_riot_shield"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_UTILITY,
        class = "tacrp_riot_shield",
        icon = Material("entities/tacrp_riot_shield.png", "smooth mips"),
        icon_ratio = 1,
        icon_scale = 1.5,
        icon_rotation = 90,

        cost_point = 2,
        cost_cash = 500,

        atttype = ATTTYPE_TACRP,
    },
    ["tacrp_m320"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_UTILITY,
        class = "tacrp_m320",
        icon = Material("entities/tacrp_m320.png", "smooth mips"),
        icon_ratio = 1,
        icon_scale = 2,

        cost_point = 2,
        cost_cash = 2500,

        nodefaultclip = true,
        --ammotype = "smg1_grenade",
        --ammocount = 1,

        atttype = ATTTYPE_TACRP,
    },
    ["tacrp_rpg7"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_UTILITY,
        class = "tacrp_rpg7",
        icon = Material("entities/tacrp_rpg7.png", "smooth mips"),
        icon_ratio = 1,
        icon_scale = 2,

        cost_point = 4,
        cost_cash = 7500,

        nodefaultclip = true,
        --ammotype = "rpg_round",
        --ammocount = 1,

        atttype = ATTTYPE_TACRP,
    },
    ["tacrp_c4_detonator"] = {
        type = LDENTRY_TYPE_SWEP,
        wepcat = LDENTRY_WEPCAT_UTILITY,
        class = "tacrp_c4_detonator",
        icon = Material("entities/tacrp_c4_detonator.png", "smooth mips"),
        icon_ratio = 1,
        icon_scale = 1.5,

        cost_point = 2,
        cost_cash = 2000,

        nodefaultclip = true,
        ammotype = "ti_c4",
        ammocount = 1, -- comes with 1 by default

        atttype = ATTTYPE_TACRP,
    },
}

function ECOSYSTEM:Check()
    return TacRP ~= nil
end

function ECOSYSTEM:OnLoad()
    -- override the fucking stupid auto ammo thing
    local tacrp_base = weapons.GetStored("tacrp_base")
    tacrp_base.GiveDefaultAmmo = function() end -- why can't you use defaultclip like a sane human being?

    tacrp_base.SetBaseSettings = function(base)
        if game.SinglePlayer() and SERVER then
            base:CallOnClient("SetBaseSettings")
        end

        local fm = base:GetCurrentFiremode()
        if fm ~= 1 then
            if base:GetValue("RunawayBurst") and fm < 0 then
                if base:GetValue("AutoBurst") then
                    base.Primary.Automatic = true
                else
                    base.Primary.Automatic = false
                end
            else
                base.Primary.Automatic = true
            end
        else
            base.Primary.Automatic = false
        end

        base.Primary.ClipSize = base:GetValue("ClipSize")
        base.Primary.Ammo = base:GetValue("Ammo")
    end

    for k, v in pairs(weapons.GetList()) do
        if weapons.IsBasedOn(v.ClassName, "tacrp_base") and v.ClassName ~= "tacrp_base" and v.ClipSize then
            -- ???????? why is this called v.ClipSize and not v.Primary.ClipSize???
            -- what the fuck were you smoking, arctic?
            v.Primary.DefaultClip = v.ClipSize * 3
        end
    end
end