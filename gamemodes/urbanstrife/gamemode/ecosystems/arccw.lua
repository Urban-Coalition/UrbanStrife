ECOSYSTEM = {}

ECOSYSTEM.Name = "ArcCW"

function ECOSYSTEM:Check()
    return ArcCW ~= nil
end

function ECOSYSTEM:OnLoad()
    local arccw_base = weapons.GetStored("arccw_base")
    arccw_base.InitialDefaultClip = function() end
    ArcCW.LimbCompensation["urbanstrife"] = {
        [HITGROUP_HEAD]     = 1,
        [HITGROUP_LEFTARM]  = 1,
        [HITGROUP_RIGHTARM] = 1,
        [HITGROUP_LEFTLEG]  = 1,
        [HITGROUP_RIGHTLEG] = 1,
        [HITGROUP_GEAR]     = 1,
    }
end