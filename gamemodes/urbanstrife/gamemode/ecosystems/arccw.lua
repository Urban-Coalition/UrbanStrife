ECOSYSTEM = {}

ECOSYSTEM.Name = "ArcCW"

function ECOSYSTEM:Check()
    return ArcCW ~= nil
end

function ECOSYSTEM:OnLoad()
    local arccw_base = weapons.GetStored("arccw_base")
    arccw_base.InitialDefaultClip = function() end
end